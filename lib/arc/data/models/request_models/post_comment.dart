class CommentModel {
  String? userId;
  String? authName;
  String? authAvatar;
  String? content;
  String? createAt;
  String? id;
  String? updateAt;

  CommentModel({
    this.content,
    this.userId,
    this.authAvatar,
    this.createAt,
    this.id,
    this.authName,
    this.updateAt,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    id = json['id'];
    content = json['content'];
    authName = json['auth_name'];
    createAt = json['create_at'];
    authAvatar = json['auth_avatar'];
    updateAt = json['update_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['user_id'] = userId;
    json['content'] = content;
    json['id'] = id;
    json['auth_name'] = authName;
    json['auth_avatar'] = authAvatar;
    json['create_at'] = createAt;
    json['update_at'] = updateAt;
    return json;
  }
}