import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/chat.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/user.dart';
import 'package:hii_xuu_social/src/config/app_config.dart';
import 'package:hii_xuu_social/src/utilities/generate.dart';
import 'package:hii_xuu_social/src/utilities/logger.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  ChatBloc() : super(InitChatState()) {
    on<SendMessageEvent>(_onChat);
    on<LoadListRoomChatEvent>(_onInit);
    on<OnChatTextChangedEvent>(_onTextChange);
  }

  void _onChat(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(SendingChatState());
    String currentAutoChatId = GenerateValue().genRandomString(15);
    var _listRoom = StaticVariable.listChatRoomId ?? [];
    var _listRoomOtherUser = [];
    if (_listRoom.contains(event.userId)) {
    } else {
      _listRoom.add(event.userId);
    }
    var input = ChatData(
        userId: StaticVariable.myData?.userId,
        authAvatar: StaticVariable.myData?.imageUrl,
        authName: StaticVariable.myData?.fullName,
        chatId: currentAutoChatId,
        createAt: DateTime.now().toUtc().toIso8601String(),
        message: event.message);

    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(event.userId)
        .collection(AppConfig.instance.cChat)
        .doc(AppConfig.instance.cListChat)
        .get()
        .then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          var res = data as Map<String, dynamic>;
          if (res['room_id'] == null) {
            _listRoomOtherUser = [];
          } else {
            for (String id in res['room_id']) {
              _listRoomOtherUser.add(id);
            }
          }
        }
      },
    );
    if (_listRoomOtherUser.contains(StaticVariable.myData?.userId)) {
    } else {
      _listRoomOtherUser.add(StaticVariable.myData?.userId);
    }

    fireStore
        .collection(AppConfig.instance.cUser)
        .doc(event.userId)
        .collection(AppConfig.instance.cChat)
        .doc(AppConfig.instance.cListChat)
        .set({
      "room_id": _listRoomOtherUser,
      "seen": false,
    }, SetOptions(merge: true)).catchError(
      (error) => LoggerUtils.d('Upload khach failed!'),
    );

    fireStore
        .collection(AppConfig.instance.cUser)
        .doc(event.userId)
        .collection(AppConfig.instance.cChat)
        .doc(AppConfig.instance.cListChat)
        .collection(StaticVariable.myData?.userId ?? '')
        .doc(currentAutoChatId)
        .set(input.toJson(), SetOptions(merge: true))
        .catchError(
          (error) => LoggerUtils.d('Chat failed!'),
        );

    fireStore
        .collection(AppConfig.instance.cUser)
        .doc(StaticVariable.myData?.userId)
        .collection(AppConfig.instance.cChat)
        .doc(AppConfig.instance.cListChat)
        .set({
      "room_id": _listRoom,
      "seen": true,
    }).catchError(
      (error) => LoggerUtils.d('Upload minh failed!'),
    );

    fireStore
        .collection(AppConfig.instance.cUser)
        .doc(StaticVariable.myData?.userId)
        .collection(AppConfig.instance.cChat)
        .doc(AppConfig.instance.cListChat)
        .collection(event.userId)
        .doc(currentAutoChatId)
        .set(input.toJson(), SetOptions(merge: true))
        .catchError(
          (error) => LoggerUtils.d('Chat failed!'),
        );
    emit(SendMessageSuccessState());
  }

  void _onTextChange(
    OnChatTextChangedEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(InitChatState());
    var chat = event.text?.trim() ?? '';
    emit(OnChatTextChangedState(chat));
  }

  void _onInit(
    LoadListRoomChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    List<String> _listUserId = [];
    List<UserData> _listRoomChat = [];
    List<UserData> _listSuggetUser = [];
    List<String> _userIdFollowing = [];
    emit(LoadingRoomChatState());

    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(StaticVariable.myData?.userId)
        .collection(AppConfig.instance.cConnect)
        .doc(AppConfig.instance.cFollowing)
        .collection(AppConfig.instance.cListFollowing)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        _userIdFollowing.add(doc.id);
      }
    });

    for (var userId in _userIdFollowing) {
      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(userId)
          .collection(AppConfig.instance.cProfile)
          .doc(AppConfig.instance.cBasicProfile)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          var res = data as Map<String, dynamic>;
          LoggerUtils.d(res);
          var user = UserData.fromJson(res);
          _listSuggetUser.add(user);
        }
      });
    }

    await fireStore
        .collection(AppConfig.instance.cUser)
        .doc(StaticVariable.myData?.userId)
        .collection(AppConfig.instance.cChat)
        .doc(AppConfig.instance.cListChat)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        var res = data as Map<String, dynamic>;

        if (res['room_id'] == null) {
          _listUserId = [];
        } else {
          for (String id in res['room_id']) {
            _listUserId.add(id);
          }
        }
      }
    });

    for (var userId in _listUserId) {
      await fireStore
          .collection(AppConfig.instance.cUser)
          .doc(userId)
          .collection(AppConfig.instance.cProfile)
          .doc(AppConfig.instance.cBasicProfile)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          var res = data as Map<String, dynamic>;
          LoggerUtils.d(res);
          var user = UserData.fromJson(res);
          _listRoomChat.add(user);
        }
      });
    }

    StaticVariable.listChatRoomId = _listUserId;

    emit(LoadListRoomChatSuccessState(_listRoomChat, _listSuggetUser));
  }
}
