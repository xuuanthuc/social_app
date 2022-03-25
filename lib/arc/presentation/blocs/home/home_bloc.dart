import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/arc/data/models/request_models/post_comment.dart';
import 'package:hii_xuu_social/arc/repository/push_noti_repository.dart';
import 'package:hii_xuu_social/src/config/app_config.dart';
import 'package:hii_xuu_social/src/utilities/format.dart';
import 'package:hii_xuu_social/src/utilities/generate.dart';
import 'package:hii_xuu_social/src/utilities/logger.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final PushNoticeRepository _repository = PushNoticeRepository();
  List<PostData> _listPost = [];
  // List<String> _listStory = [];
  String comment = '';

  HomeBloc() : super(InitHomeState()) {
    on<InitHomeEvent>(_onInitData);
    on<OnLikePostEvent>(_onLike);
    on<OnDisLikePostEvent>(_onDisLike);
    on<OnCommentTextChangedEvent>(_onTextChange);
    on<OnCommentEvent>(_onComment);
    on<LoadListComment>(_loadComment);
    on<ReloadListComment>(_reloadComment);
    on<DeletePostClickedEvent>(_deletePost);
    on<DeleteCommentClickedEvent>(_deleteComment);
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
        .doc(event.post.userId)
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
          .doc(event.post.userId)
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

  void _deletePost(
      DeletePostClickedEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(DeletePostLoadingState());
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(event.postData.userId)
        .collection(AppConfig.instance.cMedia)
        .doc(event.postData.postId)
        .delete()
        .then((value) => LoggerUtils.d('Delete comment success')).catchError((error) => LoggerUtils.d('Delete post failed'));
    emit(DeletePostSuccessState(event.postData.postId ?? ''));
  }

  void _deleteComment(
      DeleteCommentClickedEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(DeleteCommentLoadingState());
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(event.postItem.userId)
        .collection(AppConfig.instance.cMedia)
        .doc(event.postItem.postId)
        .collection(AppConfig.instance.cPostComment)
        .doc(event.commentModel.id)
        .delete()
        .then((value) => emit(DeleteCommentSuccessState(event.commentModel.id ?? ''))).catchError((error) => LoggerUtils.d('Delete post failed'));

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
        .doc(event.post.userId)
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
          .doc(event.post.userId)
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
        .doc(event.post?.userId ?? '')
        .collection(AppConfig.instance.cMedia)
        .doc(event.post?.postId ?? '')
        .collection(AppConfig.instance.cPostComment)
        .doc(currentAutoPostId)
        .set(input.toJson(), SetOptions(merge: true))
        .then((value) {
      // var newPost = event.post;
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
        .doc(event.post.userId)
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
        .doc(event.post.userId)
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
    List<String> _listFollowingUser = [];
    List<String> _listStoryId = [];
    List<String> _listStory = [];
    _listPost = [];
    _listStoryId = [];
    _listStory = [];
    //data of me
    //get list post id;
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

    //init post
    for (var _postId in _listPostId) {
      PostData post = PostData();
      List<String> _listLikes = [];
      List<String> _listComment = [];
      //get post data each item
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
      //get list like;
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
      //get list comment id
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
    //get list story
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(StaticVariable.myData?.userId)
        .collection(AppConfig.instance.cStory)
        .orderBy("create_at", descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        _listStoryId.add(doc.id);
      }
    });

    for (var _story in _listStoryId) {
      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(StaticVariable.myData?.userId)
          .collection(AppConfig.instance.cStory)
          .doc(_story)
          .get()
          .then(
        (DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            var data = documentSnapshot.data();
            LoggerUtils.d(documentSnapshot.data());
            var res = data as Map<String, dynamic>;
            if (TimeAgo.checkCreateAtTime(res['create_at']) == true) {
              _listStory.add(res['image']);
            }
          }
        },
      );
    }
    //data use khAC
    //get list user id dang follow
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(StaticVariable.myData?.userId)
        .collection(AppConfig.instance.cConnect)
        .doc(AppConfig.instance.cFollowing)
        .collection(AppConfig.instance.cListFollowing)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        _listFollowingUser.add(doc.id);
      }
    });
    _listPostId = [];
    for(var _userId in _listFollowingUser){
      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(_userId)
          .collection(AppConfig.instance.cMedia)
          .orderBy("create_at", descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          _listPostId.add(doc.id);
        }
      });

      //init post
      for (var _postId in _listPostId) {
        PostData post = PostData();
        List<String> _listLikes = [];
        List<String> _listComment = [];
        //get post data each item
        await fireStore
            .collection(AppConfig.instance.cUser)
            .doc(_userId)
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
          } else {}
        });
        //get list like;
        await fireStore
            .collection(AppConfig.instance.cUser)
            .doc(_userId)
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
        //get list comment id
        await fireStore
            .collection(AppConfig.instance.cUser)
            .doc(_userId)
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
      // get list story
      _listStoryId = [];
      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(_userId)
          .collection(AppConfig.instance.cStory)
          .orderBy("create_at", descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          _listStoryId.add(doc.id);
        }
      });

      for (var _story in _listStoryId) {
        await fireStore
            .collection(AppConfig.instance.cUser)
            .doc(_userId)
            .collection(AppConfig.instance.cStory)
            .doc(_story)
            .get()
            .then(
              (DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              var data = documentSnapshot.data();
              LoggerUtils.d(documentSnapshot.data());
              var res = data as Map<String, dynamic>;
              if (TimeAgo.checkCreateAtTime(res['create_at']) == true) {
                _listStory.add(res['image']);
              }
            }
          },
        );
      }
    }
    _listPost.sort((a,b) => (b.updateAt ?? '').compareTo(a.updateAt ?? ''));
    StaticVariable.listPost = _listPost;
    StaticVariable.listStory = _listStory;
    emit(HomeLoadedState(listPost: _listPost, listStory: _listStory));
  }
}
