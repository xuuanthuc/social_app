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
    on<OnLikePostEvent>(_onLike);
    on<OnDisLikePostEvent>(_onDisLike);
  }

  void _onLike(
    OnLikePostEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(InitHomeState());
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(StaticVariable.myData?.userId)
        .collection(AppConfig.instance.cMedia)
        .doc(event.post.postId)
        .collection(AppConfig.instance.cPostLikes)
        .doc(StaticVariable.myData?.userId)
        .set({}, SetOptions(merge: true)).then((value) {
      var newPost = event.post;
      newPost.likes?.add(StaticVariable.myData?.userId ?? '');
      emit(OnLikedPostState(newPost));
    });
  }

  void _onDisLike(
    OnDisLikePostEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(InitHomeState());
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(StaticVariable.myData?.userId)
        .collection(AppConfig.instance.cMedia)
        .doc(event.post.postId)
        .collection(AppConfig.instance.cPostLikes)
        .doc(StaticVariable.myData?.userId)
        .delete()
        .then((value) {
      var newPost = event.post;
      newPost.likes?.remove(StaticVariable.myData?.userId);
      emit(OnDisLikedPostState(newPost));
    });
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
      PostData post = PostData();
      List<String> _listLikes = [];
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
          post = PostData.fromJson(res);
        }
      });

      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(StaticVariable.myData?.userId)
          .collection(AppConfig.instance.cMedia)
          .doc(_postId)
          .collection(AppConfig.instance.cPostLikes)
          .get()
          .then(
        (QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            _listLikes.add(doc.id);
          }
        },
      );
      post.postId = _postId;
      post.likes = _listLikes;
      _listPost.add(post);
    }
    emit(HomeLoadedState(_listPost));
  }
}
