part of 'upload_bloc.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object> get props => [];
}

class InitUploadEvent extends UploadEvent {}

class OnPickImageEvent extends UploadEvent{}

class OnDeleteImageEvent extends UploadEvent{
  final int index;
  const OnDeleteImageEvent(this.index);
}

class OnSubmitSharePostEvent extends UploadEvent{
  final String? content;
  const OnSubmitSharePostEvent(this.content);
}

