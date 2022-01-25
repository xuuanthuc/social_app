import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/src/config/app_config.dart';
import 'package:hii_xuu_social/src/utilities/logger.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final List<PostData> _listPost = [];

  HomeBloc() : super(InitHomeState()) {
    on<InitHomeEvent>(_onInitData);
  }

  void _onInitData(
    InitHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    List<String> _listPostId = [];
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(StaticVariable.myData?.userId)
        .collection(AppConfig.instance.cMedia)
        .orderBy("create_at", descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        _listPostId.add(doc.id);
      }
    });

    for (var _postId in _listPostId) {
      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(StaticVariable.myData?.userId)
          .collection(AppConfig.instance.cMedia)
          .doc(_postId)
          .collection(AppConfig.instance.cPostData)
          .doc(AppConfig.instance.cPostContent)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          LoggerUtils.d(documentSnapshot.data());
          var res = data as Map<String, dynamic>;
          var post = PostData.fromJson(res);
          _listPost.add(post);
        }
      });
    }
    emit(HomeLoadedState(_listPost));
  }
}
