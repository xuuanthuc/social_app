import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/user.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/search/search_bloc.dart';
import 'package:hii_xuu_social/src/config/app_config.dart';
import 'package:hii_xuu_social/src/utilities/logger.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../src/utilities/generate.dart';
import '../../../../src/validators/static_variable.dart';
import '../../../data/models/data_models/shop.dart';

part 'shop_event.dart';

part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  List<ShopItem> _listItem = [];
  final List<File> _listImageFile = [];

  ShopBloc() : super(InitState()) {
    on<LoadListItemEvent>(_onLoadListUser);
    on<OnDeleteImageEvent>(_onDeleteImage);
    on<OnPickImageEvent>(_onPickImage);
    on<UploadNewSellItemEvent>(_onUpload);
    on<InitProfileSellerEvent>(_onInit);
    on<GetDetailItem>(_getDetail);
    on<UpdateSellItemEvent>(_onUpdate);
  }

  void _onLoadListUser(
    LoadListItemEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(LoadingShopState());
    _listItem = [];
    var _listItemId = [];

    await fireStore
        .collection(AppConfig.instance.cShop)
        .orderBy("created_at", descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        _listItemId.add(doc.id);
      }
    });

    for (var itemId in _listItemId) {
      await fireStore
          .collection(AppConfig.instance.cShop)
          .doc(itemId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          var res = data as Map<String, dynamic>;
          LoggerUtils.d(res);
          var item = ShopItem.fromJson(res);
          _listItem.add(item);
        }
      });
    }
    emit(LoadListItemSuccessState(_listItem));
  }

  void _getDetail(
      GetDetailItem event,
      Emitter<ShopState> emit,
      ) async {
    await fireStore
        .collection(AppConfig.instance.cShop)
        .doc(event.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        var res = data as Map<String, dynamic>;
        LoggerUtils.d(res);
        var item = ShopItem.fromJson(res);
        emit(GetDetailItemSuccessState(item));
      }
    });
  }

  void _onPickImage(
    OnPickImageEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(InitState());
    var _listImageXFile = await ImagePicker().pickMultiImage();
    for (XFile _imageXFile in _listImageXFile!) {
      _listImageFile.add(File(_imageXFile.path));
    }
    emit(ImagePickedState(listImageFiles: _listImageFile));
  }

  void _onDeleteImage(
    OnDeleteImageEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(InitState());
    _listImageFile.removeAt(event.index);
    emit(OnDeleteImageState(listImageFiles: _listImageFile));
  }

  void _onUpload(
    UploadNewSellItemEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(LoadingUploadNewItemState());
    String currentAutoPostId = GenerateValue().genRandomString(15);
    var _listImageUrl = await uploadImageToFirebase();
    event.item.images = _listImageUrl;
    event.item.itemId = currentAutoPostId;
    await fireStore
        .collection(AppConfig.instance.cShop)
        .doc(currentAutoPostId)
        .set({"created_at": event.item.createdAt},
            SetOptions(merge: true)).catchError(
      (error) => LoggerUtils.d("Failed to merge data: $error"),
    );

    await fireStore
        .collection(AppConfig.instance.cShop)
        .doc(currentAutoPostId)
        .set(event.item.toJson(), SetOptions(merge: true))
        .then((value) {
      return emit(UploadNewSellItemSuccessState());
    }).catchError(
      (error) => debugPrint('Failed'),
    );
  }

  void _onUpdate(
      UpdateSellItemEvent event,
      Emitter<ShopState> emit,
      ) async {
    emit(LoadingUploadNewItemState());
    List<String> _listImageUrl = [];
    if((event.listImageFile ?? []).isEmpty){
      _listImageUrl = event.item.images ?? [];
    } else {
      _listImageUrl = await uploadImageToFirebase() ?? [];
    }
    event.item.images = _listImageUrl;
    await fireStore
        .collection(AppConfig.instance.cShop)
        .doc(event.item.itemId)
        .set(event.item.toJson(), SetOptions(merge: true))
        .then((value) {
      return emit(UpdateNewSellItemSuccessState());
    }).catchError(
          (error) => debugPrint('Failed'),
    );
  }

  Future<List<String>?> uploadImageToFirebase() async {
    var user = StaticVariable.myData!;
    List<String> _listImagePath = [];
    try {
      String downloadUrl;
      for (File _imageFile in _listImageFile) {
        var file = _imageFile;
        FirebaseStorage firebaseStorage = FirebaseStorage.instance;
        Reference ref = firebaseStorage.ref(
            'uploads-images/${user.userId}/images/${DateTime.now().microsecondsSinceEpoch}');
        TaskSnapshot uploadedFile = await ref.putFile(file);
        if (uploadedFile.state == TaskState.success) {
          downloadUrl = await ref.getDownloadURL();
          _listImagePath.add(downloadUrl);
        }
      }
      return _listImagePath;
    } catch (e) {
      return [];
    }
  }

  void _onInit(
      InitProfileSellerEvent event,
      Emitter<ShopState> emit,
      ) async {
    var user = UserData();
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(event.userId)
        .collection(AppConfig.instance.cProfile)
        .doc(AppConfig.instance.cBasicProfile)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        var res = data as Map<String, dynamic>;
        LoggerUtils.d(res);
        user = UserData.fromJson(res);
        emit(InitProfileSuccessState(user));
      }
    });
  }
}
