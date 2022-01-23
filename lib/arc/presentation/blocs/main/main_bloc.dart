import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/request_models/user_request.dart';
import 'package:hii_xuu_social/src/config/app_config.dart';
import 'package:hii_xuu_social/src/utilities/generate.dart';
import 'package:hii_xuu_social/src/utilities/logger.dart';

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
    List<String> listUserId = [];
    String currentAutoId = GenerateValue().genRandomString(15);
    var input = UserRequest(
      userId: currentAutoId,
      fullName: 'Thuc Chubby',
      username: 'chubby',
      password: '123123',
      phone: '',
      email: '',
      tagName: 'thuc chubby',
      imageUrl: '',
      createAt: DateTime.now().toIso8601String(),
      updateAt: DateTime.now().toIso8601String(),
    );

    await firestore
        .collection(AppConfig.instance.cUser)
        .doc(currentAutoId)
        .set({}, SetOptions(merge: true));

    await firestore
        .collection(AppConfig.instance.cUser)
        .doc(currentAutoId)
        .collection(AppConfig.instance.cProfile)
        .doc(AppConfig.instance.cBasicProfile)
        .set(input.toJson(), SetOptions(merge: true));

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
          LoggerUtils.d(documentSnapshot.data());
        }
      });
    }
    emit(MainLoadedState());
  }
}
