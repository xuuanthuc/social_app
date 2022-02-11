import 'package:hii_xuu_social/arc/data/models/request_models/post_comment.dart';

class PostData {
  List<String>? images;
  String? userId;
  String? authName;
  String? authAvatar;
  String? content;
  String? createAt;
  String? postId;
  String? updateAt;
  List<String>? likes;
  List<String>? comments;
  List<String>? stories;

  PostData({
    this.content,
    this.images,
    this.userId,
    this.authAvatar,
    this.createAt,
    this.postId,
    this.authName,
    this.likes,
    this.updateAt,
    this.comments,
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
    postId = json['post_id'];
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
    json['post_id'] = postId;
    return json;
  }
}
