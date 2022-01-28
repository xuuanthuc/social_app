import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/user.dart';
import 'package:hii_xuu_social/src/config/app_config.dart';
import 'package:hii_xuu_social/src/utilities/logger.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  List<UserData> _listUser = [];

  SearchBloc() : super(InitState()) {
    on<OnSearchEvent>(_onSearch);
    on<OnFollowClickedEvent>(_onFollow);
  }

  void _onSearch(
    OnSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(LoadingSearchState());
    List<String> listUserId = StaticVariable.listUserId ?? [];
    List<String> _listFindId = [];
    _listUser = [];
    for (var userId in listUserId) {
      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(userId)
          .collection(AppConfig.instance.cProfile)
          .where("tag_name", isEqualTo: event.keyword.trim().toLowerCase())
          .get()
          .then(
        (QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            if (querySnapshot.size > 0) {
              if (userId != StaticVariable.myData?.userId) {
                _listFindId.add(userId);
              }
            }
          }
        },
      );
    }
    for (var userFindId in _listFindId) {
      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(userFindId)
          .collection(AppConfig.instance.cProfile)
          .doc(AppConfig.instance.cBasicProfile)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          var res = data as Map<String, dynamic>;
          LoggerUtils.d(res);
          var user = UserData.fromJson(res);
          _listUser.add(user);
        }
      });
    }
    emit(SearchSuccessState(_listUser));
  }

  void _onFollow(
    OnFollowClickedEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(InitState());
    //update me
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(StaticVariable.myData?.userId)
        .collection(AppConfig.instance.cConnect)
        .doc(AppConfig.instance.cFollowing)
        .set({}, SetOptions(merge: true)).catchError(
      (error) => LoggerUtils.d('Upload failed!'),
    );
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(StaticVariable.myData?.userId)
        .collection(AppConfig.instance.cConnect)
        .doc(AppConfig.instance.cFollowing)
        .collection(AppConfig.instance.cListFollowing)
        .doc(event.userId)
        .set({}, SetOptions(merge: true)).catchError(
      (error) => LoggerUtils.d('Upload failed!'),
    );
    //update that user
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(event.userId)
        .collection(AppConfig.instance.cConnect)
        .doc(AppConfig.instance.cFollowers)
        .set({}, SetOptions(merge: true)).catchError(
          (error) => LoggerUtils.d('Upload failed!'),
    );
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(event.userId)
        .collection(AppConfig.instance.cConnect)
        .doc(AppConfig.instance.cFollowers)
        .collection(AppConfig.instance.cListFollowing)
        .doc(StaticVariable.myData?.userId)
        .set({}, SetOptions(merge: true)).catchError(
          (error) => LoggerUtils.d('Upload failed!'),
    );
    emit(SearchSuccessState(_listUser));
  }
}
