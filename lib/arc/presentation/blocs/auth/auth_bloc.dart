import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/user.dart';
import 'package:hii_xuu_social/src/config/app_config.dart';
import 'package:hii_xuu_social/src/preferences/app_preference.dart';
import 'package:hii_xuu_social/src/utilities/generate.dart';
import 'package:hii_xuu_social/src/utilities/logger.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  UserData user = UserData();
  File? _imageFile;

  AuthBloc() : super(InitAuthState()) {
    on<SubmitLoginEvent>(_onSubmitLoginEvent);
    on<SubmitRegisterEvent>(_onSubmitRegisterEvent);
    on<OnChangedFullNameTextEvent>(_onChangedFullName);
    on<OnChangedBioTextEvent>(_onChangedBio);
    on<SubmitUpdateProfileEvent>(_onSubmitUpdateProfile);
    on<OnPickImageEvent>(_onPickImageEvent);
  }

  void _onChangedFullName(
    OnChangedFullNameTextEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(OnChangingState());
    emit(OnChangedFullNameTextState(event.text));
  }

  void _onPickImageEvent(
      OnPickImageEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(OnChangingState());
    var _imageXFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    var file = File(_imageXFile!.path);
    var _imagePath = '';
    _imageFile = file;
    emit(ImagePickedState(imagePath: _imagePath, imageFile: file));
  }

  void _onChangedBio(
    OnChangedBioTextEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(OnChangingState());
    emit(OnChangedBioTextState(event.text));
  }

  void _onSubmitUpdateProfile(
    SubmitUpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoadingLoginState());
    var avatar = await uploadImageToFirebase();
    if(avatar == ''){
      avatar = event.imageUrl;
    }
    var input = UserData(
      fullName: event.fullName,
      username: event.username,
      password: event.password,
      tagName: event.tagName,
      email: event.email,
      phone: event.phone,
      imageUrl: avatar,
      userId: event.userId,
      bio: event.bio,
      createAt: event.createAt,
      updateAt: event.updateAt,
    );
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(event.userId)
        .collection(AppConfig.instance.cProfile)
        .doc(AppConfig.instance.cBasicProfile)
        .set(
          input.toJson(),
          SetOptions(merge: true),
        )
        .then((value) {
      StaticVariable.myData = input;
      AppPreference().setVerificationID(event.userId);
      return emit(SubmitUpdateProfileSuccessState());
    }).catchError(
      (error) => emit(SubmitUpdateProfileFailedState()),
    );
  }

  void _onSubmitLoginEvent(
    SubmitLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoadingLoginState());
    List<String> listUserId = StaticVariable.listUserId ?? [];
    for (var userId in listUserId) {
      List<String> _listFollowing = [];
      List<String> _listFollower = [];
      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(userId)
          .collection(AppConfig.instance.cConnect)
          .doc(AppConfig.instance.cFollowing)
          .collection(AppConfig.instance.cListFollowing)
          .get()
          .then((QuerySnapshot querySnapshot){
        for(var doc in querySnapshot.docs){
          _listFollowing.add(doc.id);
        }
      });

      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(userId)
          .collection(AppConfig.instance.cConnect)
          .doc(AppConfig.instance.cFollowers)
          .collection(AppConfig.instance.cListFollowing)
          .get()
          .then((QuerySnapshot querySnapshot){
        for(var doc in querySnapshot.docs){
          _listFollower.add(doc.id);
        }
      });

      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(userId)
          .collection(AppConfig.instance.cProfile)
          .doc(AppConfig.instance.cBasicProfile)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          var res = data as Map<String, dynamic>;
          user = UserData.fromJson(res);
          if (user.username == event.username &&
              user.password == event.password) {
            user.following = _listFollowing;
            user.follower = _listFollower;
            StaticVariable.myData = user;
            AppPreference().setVerificationID(user.userId);
          } else {}
        }
      });
    }
    if (StaticVariable.myData != null) {
      emit(LoginSuccessState());
    } else {
      emit(LoginFailedState());
    }
  }

  void _onSubmitRegisterEvent(
    SubmitRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoadingLoginState());
    List<String> listUserId = StaticVariable.listUserId ?? [];
    bool existUser = false;
    for (var userId in listUserId) {
      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(userId)
          .collection(AppConfig.instance.cProfile)
          .doc(AppConfig.instance.cBasicProfile)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          var res = data as Map<String, dynamic>;
          user = UserData.fromJson(res);
          if (user.username == event.username) {
            existUser = true;
          } else {}
        }
      });
    }
    if (existUser == true) {
      return emit(UserExistState());
    } else {
      StaticVariable.isFirstRegister = false;
      String currentAutoId = GenerateValue().genRandomString(15);
      var input = UserData(
        userId: currentAutoId,
        fullName: '',
        username: event.username,
        password: event.password,
        phone: '',
        email: '',
        tagName: '',
        imageUrl: '',
        bio: '',
        createAt: DateTime.now().toUtc().toIso8601String(),
        updateAt: DateTime.now().toUtc().toIso8601String(),
      );

      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(currentAutoId)
          .set({}, SetOptions(merge: true)).catchError(
        (error) => LoggerUtils.d("Failed to merge data: $error"),
      );

      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(currentAutoId)
          .collection(AppConfig.instance.cProfile)
          .doc(AppConfig.instance.cBasicProfile)
          .set(
            input.toJson(),
            SetOptions(merge: true),
          )
          .then((value) {
        StaticVariable.myData = input;
        return emit(RegisterSuccessState());
      }).catchError(
        (error) => emit(
          RegisterFailedState(error),
        ),
      );
    }
  }

  Future<String?> uploadImageToFirebase() async {
    var user = StaticVariable.myData!;
    String _imagePath = '';
    try {
      String downloadUrl;
      var file = _imageFile;
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      Reference ref = firebaseStorage.ref(
          'uploads-images/${user.userId}/images/${DateTime.now().microsecondsSinceEpoch}');
      TaskSnapshot uploadedFile = await ref.putFile(file!);
      if (uploadedFile.state == TaskState.success) {
        downloadUrl = await ref.getDownloadURL();
        _imagePath = downloadUrl;
      }
      return _imagePath;
    } catch (e) {
      return '';
    }
  }
}
