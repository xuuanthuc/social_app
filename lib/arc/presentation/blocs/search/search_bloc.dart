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
    on<LoadListUserEvent>(_onLoadListUser);
  }

  void _onSearch(
    OnSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(LoadingSearchState());
    bool isUsername = false;
    List<String> listUserId = [];
    await fireStore
        .collection(AppConfig.instance.cUser)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        listUserId.add(doc.id);
      }
    });
    StaticVariable.listUserId = listUserId;
    List<String> _listFindId = [];
    _listUser = [];
    if (event.keyword.contains('@')) {
      isUsername = true;
    } else {
      isUsername = false;
    }
    for (var userId in listUserId) {
      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(userId)
          .collection(AppConfig.instance.cProfile)
          .where(isUsername ? "username" : "tag_name",
              isEqualTo: event.keyword.replaceAll('@', '').trim().toLowerCase())
          .get()
          .then(
        (QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            LoggerUtils.d(doc.id);
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

  void _onLoadListUser(
      LoadListUserEvent event,
      Emitter<SearchState> emit,
      ) async {
    emit(LoadingListState());
    _listUser = [];
    LoggerUtils.d(event.listUserId);
    for (var userFindId in event.listUserId) {
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
    emit(LoadListUserSuccessState(_listUser));
  }
}
