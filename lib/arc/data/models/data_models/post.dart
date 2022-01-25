class PostData {
  List<String>? images;
  String? userId;
  String? authName;
  String? authAvatar;
  String? content;
  String? createAt;
  String? updateAt;

  PostData({
    this.content,
    this.images,
    this.userId,
    this.authAvatar,
    this.createAt,
    this.authName,
    this.updateAt,
  });

  PostData.fromJson(Map<String, dynamic> json) {
    var _listImage = <String>[];
    if(json['images'] != null){
      for(String image in json['images']){
        _listImage.add(image);
      }
    }
    userId = json['user_id'];
    images = _listImage;
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
    json['images'] = images;
    json['auth_name'] = authName;
    json['auth_avatar'] = authAvatar;
    json['create_at'] = createAt;
    json['update_at'] = updateAt;
    return json;
  }
}
