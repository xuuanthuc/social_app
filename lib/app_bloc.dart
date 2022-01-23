import 'package:flutter_bloc/flutter_bloc.dart';
import '/src/utilities/logger.dart';

/// Custom [BlocObserver] which observes all bloc and cubit instances.
class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    LoggerUtils.d(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    LoggerUtils.d(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    LoggerUtils.d(error);
    super.onError(bloc, error, stackTrace);
  }
}
