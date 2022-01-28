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

class StoryImagePickedState extends UploadState{
  final File? imageFiles;
  const StoryImagePickedState({this.imageFiles});
}

class OnDeleteImageState extends UploadState{
  final List<File>? listImageFiles;
  const OnDeleteImageState({this.listImageFiles});
}

class LoadingSharePostState extends UploadState{}

class SharePostSuccessState extends UploadState{}

class SharePostFailedState extends UploadState{
  final String error;
  const SharePostFailedState(this.error);
}

class UploadStorySuccessState extends UploadState{}