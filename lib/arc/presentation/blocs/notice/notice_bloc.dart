import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/user.dart';
import 'package:hii_xuu_social/arc/repository/push_noti_repository.dart';
import 'package:hii_xuu_social/src/service/event_bus.dart';

import '../../../../src/config/app_config.dart';
import '../../../../src/service/event_bus.dart';
import '../../../../src/utilities/logger.dart';
import '../../../../src/validators/static_variable.dart';

part 'notice_event.dart';

part 'notice_state.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final PushNoticeRepository _repository = PushNoticeRepository();

  NoticeBloc() : super(InitNoticeState()) {
    on<InitNoticeEvent>((event, emit) {});
    on<CommentPostNoticeEvent>(_commentNotice);
    on<ReactedPostNoticeEvent>(_reactedNotice);
    on<ChatMessageNoticeEvent>(_chatNotice);
    on<FollowedNoticeEvent>(_followedNotice);
    on<OnClickMessageNoticeEvent>(_onClickMessageNotice);
    on<OnClickPostNoticeEvent>(_onClickPostNotice);
    on<OnClickFollowNoticeEvent>(_onClickFollowNotice);
    eventBus.on<OnMessageNoticeClickedEvent>().listen((event) {
      add(OnClickMessageNoticeEvent(event.data));
    });
    eventBus.on<OnPostNoticeClickedEvent>().listen((event) {
      add(OnClickPostNoticeEvent(event.data));
    });
    eventBus.on<OnFollowNoticeClickedEvent>().listen((event) {
      add(OnClickFollowNoticeEvent(event.data));
    });
  }

  void _commentNotice(
    CommentPostNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    var firebaseToken = await getFirebaseTokenUserReceiver(event.authId);
    var client = await getDataClient(event.userCommentedId);
    _repository.commentToPost(
        token: firebaseToken, fullNameCommenter: client.fullName ?? '', postId: event.postId);
  }

  void _reactedNotice(
    ReactedPostNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    var firebaseToken = await getFirebaseTokenUserReceiver(event.authId);
    var client = await getDataClient(event.userCommentedId);
    _repository.reactedToPost(
        token: firebaseToken, fullNameCommenter: client.fullName ?? '', postId: event.postId);
  }

  void _followedNotice(
    FollowedNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    var firebaseToken = await getFirebaseTokenUserReceiver(event.authId);
    var client = await getDataClient(event.userFollowedId);
    _repository.followedYou(
        token: firebaseToken, userFollowYou: client);
  }

  void _chatNotice(
    ChatMessageNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    var firebaseToken =
        await getFirebaseTokenUserReceiver(event.userReceiverNoticeId);
    var client = await getDataClient(event.userSendMsgId);
    _repository.chatNotice(
        token: firebaseToken, userSendMsg: client, chatText: event.message);
  }

  void _onClickMessageNotice(
    OnClickMessageNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    emit(InitNoticeState());
    var client = await getDataClient(event.data['body']);
    emit(OnClickMessageNoticeState(client));
  }

  void _onClickPostNotice(
    OnClickPostNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    emit(InitNoticeState());
    var post = await getPostData(event.data['body']);
    emit(OnClickPostNoticeState(post));
  }

  void _onClickFollowNotice(
      OnClickFollowNoticeEvent event,
      Emitter<NoticeState> emit,
      ) async {
    emit(InitNoticeState());
    emit(OnClickFollowNoticeState(event.data['body']));
  }

  Future<String> getFirebaseTokenUserReceiver(String userId) async {
    var firebaseToken = '';
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(userId)
        .collection(AppConfig.instance.cProfile)
        .doc(AppConfig.instance.cBasicProfile)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        var res = data as Map<String, dynamic>;
        firebaseToken = res['firebase_token'];
      }
    });
    return firebaseToken;
  }

  Future<UserData> getDataClient(String userId) async {
    var user = UserData();
    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(userId)
        .collection(AppConfig.instance.cProfile)
        .doc(AppConfig.instance.cBasicProfile)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        var res = data as Map<String, dynamic>;
        user = UserData.fromJson(res);
      }
    });
    return user;
  }

  Future<PostData> getPostData(String postId) async {
      PostData post = PostData();
      List<String> _listLikes = [];
      List<String> _listComment = [];
      //get post data each item
      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(StaticVariable.myData?.userId)
          .collection(AppConfig.instance.cMedia)
          .doc(postId)
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
          .doc(postId)
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
          .doc(postId)
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
      post.likes = _listLikes;
      post.postId = postId;
      return post;
  }
}
