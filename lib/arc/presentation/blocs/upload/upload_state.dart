part of 'upload_bloc.dart';

abstract class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object> get props => [];
}

class InitUploadState extends UploadState{}

class UploadLoadedState extends UploadState{}

class ImagePickedState extends UploadState{
  final List<File>? listImageFiles;
  const ImagePickedState({this.listImageFiles});
}

class OnDeleteImageState extends UploadState{
  final List<File>? listImageFiles;
  const OnDeleteImageState({this.listImageFiles});
}

class LoadingSharePostState extends UploadState{}

class SharePostSuccessState extends UploadState{}

class SharePostFailedState extends UploadState{}
