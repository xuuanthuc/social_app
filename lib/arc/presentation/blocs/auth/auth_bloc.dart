import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/user.dart';
import 'package:hii_xuu_social/arc/data/models/request_models/user_request.dart';
import 'package:hii_xuu_social/src/config/app_config.dart';
import 'package:hii_xuu_social/src/preferences/app_preference.dart';
import 'package:hii_xuu_social/src/utilities/generate.dart';
import 'package:hii_xuu_social/src/utilities/logger.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserData user = UserData();

  AuthBloc() : super(InitAuthState()) {
    on<SubmitLoginEvent>(_onSubmitLoginEvent);
    on<SubmitRegisterEvent>(_onSubmitRegisterEvent);
  }

  void _onSubmitLoginEvent(
    SubmitLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoadingLoginState());
    List<String> listUserId = [];
    await firestore
        .collection(AppConfig.instance.cUser)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        listUserId.add(doc.id);
      }
    });
    for (var userId in listUserId) {
      await firestore
          .collection(AppConfig.instance.cUser)
          .doc(userId)
          .collection(AppConfig.instance.cProfile)
          .doc(AppConfig.instance.cBasicProfile)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          var res = data as Map<String, dynamic>;
          user = UserData.fromJson(res);
          if (user.username == event.username &&
              user.password == event.password) {
            StaticVariable.myData = user;
            AppPreference().setVerificationID(user.userId);
          } else {}
        }
      });
    }
    if (StaticVariable.myData != null) {
      emit(LoginSuccessState());
    } else {
      emit(LoginFailedState());
    }
  }

  void _onSubmitRegisterEvent(
    SubmitRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoadingLoginState());
    List<String> listUserId = [];
    bool existUser = false;
    await firestore
        .collection(AppConfig.instance.cUser)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        listUserId.add(doc.id);
      }
    });
    for (var userId in listUserId) {
      await firestore
          .collection(AppConfig.instance.cUser)
          .doc(userId)
          .collection(AppConfig.instance.cProfile)
          .doc(AppConfig.instance.cBasicProfile)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          var res = data as Map<String, dynamic>;
          user = UserData.fromJson(res);
          if (user.username == event.username) {
            existUser = true;
          } else {}
        }
      });
    }
    if (existUser == true) {
      return emit(UserExistState());
    } else {
      StaticVariable.isFirstRegister = false;
      String currentAutoId = GenerateValue().genRandomString(15);
      var input = UserRequest(
        userId: currentAutoId,
        fullName: '',
        username: event.username,
        password: event.password,
        phone: '',
        email: '',
        tagName: '',
        imageUrl: '',
        createAt: DateTime.now().toUtc().toIso8601String(),
        updateAt: DateTime.now().toUtc().toIso8601String(),
      );

      await firestore
          .collection(AppConfig.instance.cUser)
          .doc(currentAutoId)
          .set({}, SetOptions(merge: true)).catchError(
        (error) => LoggerUtils.d("Failed to merge data: $error"),
      );

      await firestore
          .collection(AppConfig.instance.cUser)
          .doc(currentAutoId)
          .collection(AppConfig.instance.cProfile)
          .doc(AppConfig.instance.cBasicProfile)
          .set(input.toJson(), SetOptions(merge: true))
          .then((value) => emit(RegisterSuccessState()))
          .catchError(
            (error) => emit(
              RegisterFailedState(error),
            ),
          );
    }
  }
}
