import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {

  UploadBloc() : super(InitUploadState()) {
    on<InitUploadEvent>(_onInitData);
  }

  void _onInitData(
      InitUploadEvent event,
      Emitter<UploadState> emit,
      ) async {
    emit(UploadLoadedState());
  }
}
