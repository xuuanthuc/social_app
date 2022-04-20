class ChatData {
  String? userId;
  String? chatId;
  String? authName;
  String? authAvatar;
  String? message;
  int? messageType;
  String? createAt;

  ChatData({
    this.userId,
    this.authAvatar,
    this.createAt,
    this.chatId,
    this.authName,
    this.message,
    this.messageType
  });

  ChatData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    chatId = json['chat_id'];
    message = json['message'];
    authName = json['auth_name'];
    createAt = json['create_at'];
    authAvatar = json['auth_avatar'];
    messageType = json['message_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['user_id'] = userId;
    json['auth_name'] = authName;
    json['auth_avatar'] = authAvatar;
    json['create_at'] = createAt;
    json['message'] = message;
    json['chat_id'] = chatId;
    json['message_type'] = messageType;
    return json;
  }
}
