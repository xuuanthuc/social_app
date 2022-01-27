import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/arc/data/models/request_models/post_comment.dart';
import 'package:hii_xuu_social/src/config/app_config.dart';
import 'package:hii_xuu_social/src/utilities/generate.dart';
import 'package:hii_xuu_social/src/utilities/logger.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  List<PostData> _listPost = [];
  String comment = '';

  HomeBloc() : super(InitHomeState()) {
    on<InitHomeEvent>(_onInitData);
    on<OnLikePostEvent>(_onLike);
    on<OnDisLikePostEvent>(_onDisLike);
    on<OnCommentTextChangedEvent>(_onTextChange);
    on<OnCommentEvent>(_onComment);
    on<LoadListComment>(_loadComment);
    on<ReloadListComment>(_reloadComment);
  }

  void _reloadComment(
      ReloadListComment event,
      Emitter<HomeState> emit,
      ) async {
    emit(ReloadingListCommentState());
    List<CommentModel>? _listComment = [];
    List<String>? _listCommentId = [];
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(StaticVariable.myData?.userId)
        .collection(AppConfig.instance.cMedia)
        .doc(event.post.postId)
        .collection(AppConfig.instance.cPostComment)
        .orderBy("create_at", descending: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        _listCommentId.add(doc.id);
      }
    }).catchError((error) => emit(LoadListCommentFailedState()));
    for (var _commentId in _listCommentId) {
      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(StaticVariable.myData?.userId)
          .collection(AppConfig.instance.cMedia)
          .doc(event.post.postId)
          .collection(AppConfig.instance.cPostComment)
          .doc(_commentId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          LoggerUtils.d(documentSnapshot.data());
          var res = data as Map<String, dynamic>;
          var _comment = CommentModel.fromJson(res);
          _listComment.add(_comment);
        }
      }).catchError((onError) => emit(LoadListCommentFailedState()));
    }
    StaticVariable.listComment = _listComment;
    emit(LoadListCommentSuccessState(_listComment));
  }

  void _loadComment(
    LoadListComment event,
    Emitter<HomeState> emit,
  ) async {
    emit(LoadingListCommentState());
    List<CommentModel>? _listComment = [];
    List<String>? _listCommentId = [];
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(StaticVariable.myData?.userId)
        .collection(AppConfig.instance.cMedia)
        .doc(event.post.postId)
        .collection(AppConfig.instance.cPostComment)
        .orderBy("create_at", descending: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        _listCommentId.add(doc.id);
      }
    }).catchError((error) => emit(LoadListCommentFailedState()));
    for (var _commentId in _listCommentId) {
      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(StaticVariable.myData?.userId)
          .collection(AppConfig.instance.cMedia)
          .doc(event.post.postId)
          .collection(AppConfig.instance.cPostComment)
          .doc(_commentId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          LoggerUtils.d(documentSnapshot.data());
          var res = data as Map<String, dynamic>;
          var _comment = CommentModel.fromJson(res);
          _listComment.add(_comment);
        }
      }).catchError((onError) => emit(LoadListCommentFailedState()));
    }
    StaticVariable.listComment = _listComment;
    emit(LoadListCommentSuccessState(_listComment));
  }

  void _onComment(
    OnCommentEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(InitHomeState());
    String currentAutoPostId = GenerateValue().genRandomString(15);
    var input = CommentModel(
      content: event.comment,
      id: currentAutoPostId,
      userId: StaticVariable.myData?.userId ?? '',
      authAvatar: StaticVariable.myData?.imageUrl ?? '',
      authName: StaticVariable.myData?.fullName ?? '',
      createAt: DateTime.now().toUtc().toIso8601String(),
      updateAt: DateTime.now().toUtc().toIso8601String(),
    );
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(StaticVariable.myData?.userId)
        .collection(AppConfig.instance.cMedia)
        .doc(event.post?.postId ?? '')
        .collection(AppConfig.instance.cPostComment)
        .doc(currentAutoPostId)
        .set(input.toJson(), SetOptions(merge: true))
        .then((value) {
      var newPost = event.post;
      emit(OnCommentSuccessState());
    }).catchError((error) => emit(OnCommentFailedState()));
  }

  void _onTextChange(
    OnCommentTextChangedEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(InitHomeState());
    comment = event.text?.trim() ?? '';
    emit(OnCommentTextChangedState(comment));
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
    _listPost = [];
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
      List<String> _listComment = [];
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

      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(StaticVariable.myData?.userId)
          .collection(AppConfig.instance.cMedia)
          .doc(_postId)
          .collection(AppConfig.instance.cPostComment)
          .orderBy("create_at", descending: false)
          .get()
          .then(
        (QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            _listComment.add(doc.id);
          }
        },
      );

      post.comments = _listComment;
      post.postId = _postId;
      post.likes = _listLikes;
      _listPost.add(post);
    }
    StaticVariable.listPost = _listPost;
    emit(HomeLoadedState(_listPost));
  }
}
