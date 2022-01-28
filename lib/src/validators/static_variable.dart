import 'package:flutter/cupertino.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/user.dart';
import 'package:hii_xuu_social/arc/data/models/request_models/post_comment.dart';

class StaticVariable{
  static UserData? myData;
  static bool? isFirstRegister;
  static List<String>? listUserId;
  static CommentModel? comment;
  static List<CommentModel>? listComment;
  static List<PostData>? listPost;
  static List<String>? listStory;
}