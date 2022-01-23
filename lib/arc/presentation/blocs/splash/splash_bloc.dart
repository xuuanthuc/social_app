import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/user.dart';
import 'package:hii_xuu_social/src/config/app_config.dart';
import 'package:hii_xuu_social/src/preferences/app_preference.dart';
import 'package:hii_xuu_social/src/utilities/logger.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';
part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  SplashBloc() : super(InitSplashState()) {
    on<InitSplashEvent>(_onInitialSplashEvent);
  }

  void _onInitialSplashEvent(
      InitSplashEvent event,
      Emitter<SplashState> emit,
      ) async {
    var userId = await AppPreference().verificationId;
    if(userId != null){
      await firestore
          .collection(AppConfig.instance.cUser)
          .doc(userId)
          .collection(AppConfig.instance.cProfile)
          .doc(AppConfig.instance.cBasicProfile)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          LoggerUtils.d(documentSnapshot.data());
          var res = data as Map<String, dynamic>;
          var user = UserData.fromJson(res);
          StaticVariable.myData = user;
          emit(GotoHomeState());
        } else {
          emit(GoToLoginState());
        }
      });
    } else {
      emit(GoToLoginState());
    }
  }
}