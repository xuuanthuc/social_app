import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {

  MainBloc() : super(InitMainState()) {
    on<InitMainEvent>(_onInitData);
    on<OnChangePageEvent>(_onChangePage);
  }

  void _onInitData(
    InitMainEvent event,
    Emitter<MainState> emit,
  ) async {
    emit(MainLoadedState());
  }

  void _onChangePage(
    OnChangePageEvent event,
    Emitter<MainState> emit,
  ) async {
    emit(InitMainState());
    emit(OnChangedPageState(event.index));
  }
}
