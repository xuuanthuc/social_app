import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/src/config/app_config.dart';
import 'package:hii_xuu_social/src/utilities/generate.dart';
import 'package:hii_xuu_social/src/utilities/logger.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

part 'upload_event.dart';

part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final List<File> _listImageFile = [];
  File _imageFile = File('');
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  UploadBloc() : super(InitUploadState()) {
    on<InitUploadEvent>(_onInitData);
    on<OnPickImageEvent>(_onPickImage);
    on<OnPickStoryImageEvent>(_onStoryImagePicked);
    on<OnDeleteImageEvent>(_onDeleteImage);
    on<OnSubmitSharePostEvent>(_onShare);
    on<OnSubmitUploadStory>(_uploadStory);
  }

  void _onInitData(
    InitUploadEvent event,
    Emitter<UploadState> emit,
  ) async {
    emit(UploadLoadedState());
  }

  void _uploadStory(
      OnSubmitUploadStory event,
      Emitter<UploadState> emit,
      ) async {
    emit(LoadingSharePostState());
    var _imageUrl = await uploadStoryToFirebase();
    String currentAutoPostId = GenerateValue().genRandomString(15);
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(StaticVariable.myData?.userId)
        .collection(AppConfig.instance.cStory)
        .doc(currentAutoPostId)
        .set({"create_at": DateTime.now().toUtc().toIso8601String(), "image" : _imageUrl},
        SetOptions(merge: true)).catchError(
          (error) => emit(SharePostFailedState('Upload failed!')),
    );
    emit(UploadStorySuccessState());
  }

  void _onPickImage(
    OnPickImageEvent event,
    Emitter<UploadState> emit,
  ) async {
    emit(InitUploadState());
    var _listImageXFile = await ImagePicker().pickMultiImage();
    for (XFile _imageXFile in _listImageXFile!) {
      _listImageFile.add(File(_imageXFile.path));
    }
    emit(ImagePickedState(listImageFiles: _listImageFile));
  }

  void _onStoryImagePicked(
    OnPickStoryImageEvent event,
    Emitter<UploadState> emit,
  ) async {
    emit(InitUploadState());
    var _imageXFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    _imageFile = File(_imageXFile?.path ?? '');
    emit(StoryImagePickedState(imageFiles: _imageFile));
  }

  void _onDeleteImage(
    OnDeleteImageEvent event,
    Emitter<UploadState> emit,
  ) async {
    emit(InitUploadState());
    _listImageFile.removeAt(event.index);
    emit(OnDeleteImageState(listImageFiles: _listImageFile));
  }

  void _onShare(
    OnSubmitSharePostEvent event,
    Emitter<UploadState> emit,
  ) async {
    emit(LoadingSharePostState());
    String currentAutoPostId = GenerateValue().genRandomString(15);
    var _listImageUrl = await uploadImageToFirebase();
    if (event.content == '' && _listImageUrl?.length == 0) {
      emit(const SharePostFailedState("Content isn't empty"));
    } else {
      var input = PostData(
        content: event.content ?? '',
        images: _listImageUrl ?? [],
        authName: StaticVariable.myData?.fullName,
        authAvatar: StaticVariable.myData?.imageUrl,
        userId: StaticVariable.myData?.userId,
        createAt: DateTime.now().toUtc().toIso8601String(),
        updateAt: DateTime.now().toUtc().toIso8601String(),
      );

      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(StaticVariable.myData?.userId)
          .collection(AppConfig.instance.cMedia)
          .doc(currentAutoPostId)
          .set({"create_at": DateTime.now().toUtc().toIso8601String()},
              SetOptions(merge: true)).catchError(
        (error) => LoggerUtils.d("Failed to merge data: $error"),
      );

      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(StaticVariable.myData?.userId)
          .collection(AppConfig.instance.cMedia)
          .doc(currentAutoPostId)
          .collection(AppConfig.instance.cPostData)
          .doc(AppConfig.instance.cPostContent)
          .set(input.toJson(), SetOptions(merge: true))
          .then((value) {
        return emit(SharePostSuccessState());
      }).catchError(
        (error) => emit(const SharePostFailedState('Share Failed')),
      );
    }
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

  Future<String>? uploadStoryToFirebase() async {
    var user = StaticVariable.myData!;
    try {
      String downloadUrl = '';
      var file = _imageFile;
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      Reference ref = firebaseStorage.ref(
          'uploads-images/${user.userId}/images/${DateTime.now().microsecondsSinceEpoch}');
      TaskSnapshot uploadedFile = await ref.putFile(file);
      if (uploadedFile.state == TaskState.success) {
        downloadUrl = await ref.getDownloadURL();
      }
      return downloadUrl;
    } catch (e) {
      return '';
    }
  }
}
