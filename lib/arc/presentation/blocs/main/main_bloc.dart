import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  MainBloc() : super(InitMainState()) {
    on<InitMainEvent>(_onInitData);
  }

  void _onInitData(
    InitMainEvent event,
    Emitter<MainState> emit,
  ) async {

    emit(MainLoadedState());
  }
}
