import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(InitHomeState()) {
    on<InitHomeEvent>(_onInitData);
  }

  void _onInitData(
    InitHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadedState());
  }
}
