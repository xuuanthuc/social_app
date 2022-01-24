class UserData {
  String? fullName;
  String? username;
  String? password;
  String? tagName;
  String? email;
  String? phone;
  String? imageUrl;
  String? userId;
  String? bio;
  String? createAt;
  String? updateAt;

  UserData(
      {this.userId,
        this.phone,
        this.email,
        this.username,
        this.imageUrl,
        this.createAt,
        this.bio,
        this.fullName,
        this.password,
        this.updateAt,
        this.tagName});

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    phone = json['phone'];
    email = json['email'];
    username = json['username'];
    fullName = json['full_name'];
    password = json['password'];
    createAt = json['create_at'];
    bio = json['bio'];
    tagName = json['tag_name'];
    imageUrl = json['image_url'];
    updateAt = json['update_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['user_id'] = userId;
    json['phone'] = phone;
    json['email'] = email;
    json['username'] = username;
    json['full_name'] = fullName;
    json['bio'] = bio;
    json['password'] = password;
    json['create_at'] = createAt;
    json['tag_name'] = tagName;
    json['image_url'] = imageUrl;
    json['update_at'] = updateAt;
    return json;
  }
}
