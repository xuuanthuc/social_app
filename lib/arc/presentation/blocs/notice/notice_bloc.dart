import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/user.dart';
import 'package:hii_xuu_social/arc/repository/push_noti_repository.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';

import '../../../../src/config/app_config.dart';

part 'notice_event.dart';

part 'notice_state.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final PushNoticeRepository _repository = PushNoticeRepository();

  NoticeBloc() : super(InitNoticeState()) {
    on<CommentPostNoticeEvent>(_commentNotice);
    on<ReactedPostNoticeEvent>(_reactedNotice);
    on<ChatMessageNoticeEvent>(_chatNotice);
    on<FollowedNoticeEvent>(_followedNotice);
  }

  void _commentNotice(
    CommentPostNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    var firebaseToken = await getFirebaseTokenUserReceiver(event.authId);
    var client = await getDataClient(event.userCommentedId);
    _repository.commentToPost(
        token: firebaseToken, fullNameCommenter: client.fullName ?? '');
  }

  void _reactedNotice(
    ReactedPostNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    var firebaseToken = await getFirebaseTokenUserReceiver(event.authId);
    var client = await getDataClient(event.userCommentedId);
    _repository.reactedToPost(
        token: firebaseToken, fullNameCommenter: client.fullName ?? '');
  }

  void _followedNotice(
      FollowedNoticeEvent event,
      Emitter<NoticeState> emit,
      ) async {
    var firebaseToken = await getFirebaseTokenUserReceiver(event.authId);
    var client = await getDataClient(event.userFollowedId);
    _repository.followedYou(
        token: firebaseToken, fullNameCommenter: client.fullName ?? '');
  }

  void _chatNotice(
    ChatMessageNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    var firebaseToken =
        await getFirebaseTokenUserReceiver(event.userReceiverNoticeId);
    var client = await getDataClient(event.userSendMsgId);
    _repository.chatNotice(
        token: firebaseToken,
        fullNameSendChat: client.fullName ?? '',
        chatText: event.message);
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
}
