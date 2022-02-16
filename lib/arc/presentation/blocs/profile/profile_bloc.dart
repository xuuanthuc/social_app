import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/user.dart';
import 'package:hii_xuu_social/src/config/app_config.dart';
import 'package:hii_xuu_social/src/utilities/logger.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  ProfileBloc() : super(InitState()) {
    on<InitProfileUserEvent>(_onInit);
    on<OnFollowClickedEvent>(_onFollow);
    on<OnUnFollowClickedEvent>(_onUnFollow);
  }

  void _onInit(
    InitProfileUserEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(LoadingInitProfileState());
    var user = UserData();
    List<String> _listFollowing = [];
    List<String> _listFollower = [];
    List<String> _listPostId = [];
    List<PostData> _listPost = [];

    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(event.userId)
        .collection(AppConfig.instance.cProfile)
        .doc(AppConfig.instance.cBasicProfile)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        var res = data as Map<String, dynamic>;
        LoggerUtils.d(res);
        user = UserData.fromJson(res);
      }
    });

    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(event.userId)
        .collection(AppConfig.instance.cMedia)
        .orderBy("create_at", descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        _listPostId.add(doc.id);
      }
    });
    for (var id in _listPostId) {
      PostData post = PostData();
      List<String> _listLikes = [];
      List<String> _listComment = [];
      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(event.userId)
          .collection(AppConfig.instance.cMedia)
          .doc(id)
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
          .doc(event.userId)
          .collection(AppConfig.instance.cMedia)
          .doc(id)
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
          .doc(event.userId)
          .collection(AppConfig.instance.cMedia)
          .doc(id)
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
      post.postId = id;
      post.likes = _listLikes;
      _listPost.add(post);
    }

    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(event.userId)
        .collection(AppConfig.instance.cConnect)
        .doc(AppConfig.instance.cFollowing)
        .collection(AppConfig.instance.cListFollowing)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        _listFollowing.add(doc.id);
      }
    });

    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(event.userId)
        .collection(AppConfig.instance.cConnect)
        .doc(AppConfig.instance.cFollowers)
        .collection(AppConfig.instance.cListFollowing)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        _listFollower.add(doc.id);
      }
    });

    user.following = _listFollowing;
    user.follower = _listFollower;
    user.posts = _listPost;
    emit(InitProfileSuccessState(user));
  }

  void _onFollow(
    OnFollowClickedEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(LoadingClickedFollowState());
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
    emit(OnFollowSuccessState());
  }

  void _onUnFollow(
    OnUnFollowClickedEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(LoadingClickedFollowState());
    //update me
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(StaticVariable.myData?.userId)
        .collection(AppConfig.instance.cConnect)
        .doc(AppConfig.instance.cFollowing)
        .collection(AppConfig.instance.cListFollowing)
        .doc(event.userId)
        .delete()
        .then((value) => LoggerUtils.d("User Deleted"))
        .catchError((error) => LoggerUtils.d("Failed to delete user: $error"));

    //update that user
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(event.userId)
        .collection(AppConfig.instance.cConnect)
        .doc(AppConfig.instance.cFollowers)
        .collection(AppConfig.instance.cListFollowing)
        .doc(StaticVariable.myData?.userId)
        .delete()
        .then((value) => LoggerUtils.d("User Deleted"))
        .catchError((error) => LoggerUtils.d("Failed to delete user: $error"));
    emit(OnUnFollowSuccessState());
  }
}
