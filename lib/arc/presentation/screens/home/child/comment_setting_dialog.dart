import 'package:flutter/material.dart';
import 'package:hii_xuu_social/arc/data/models/request_models/post_comment.dart';

import '../../../../../src/styles/dimens.dart';
import '../../../../../src/validators/static_variable.dart';
import '../../../../data/models/data_models/post.dart';
import '../../../blocs/home/home_bloc.dart';
import '../../../blocs/profile/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentSettingSheet extends StatefulWidget {
  final PostData postItem;
  final CommentModel commentModel;

  const CommentSettingSheet(
      {Key? key, required this.commentModel, required this.postItem})
      : super(key: key);

  @override
  State<CommentSettingSheet> createState() => _CommentSettingSheetState();
}

class _CommentSettingSheetState extends State<CommentSettingSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: Dimens.size15),
        widget.commentModel.userId != StaticVariable.myData?.userId
            ? InkWell(
          onTap: () {
            Navigator.of(context).pop();
            context
                .read<ProfileBloc>()
                .add(OnUnFollowClickedEvent(widget.commentModel.userId ?? ''));
          },
          child: Container(
            color: Colors.transparent,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                'Unfollow',
                style: Theme
                    .of(context)
                    .primaryTextTheme
                    .headline6,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
            : InkWell(
          onTap: () {
            Navigator.of(context).pop();
            context
                .read<HomeBloc>()
                .add(DeleteCommentClickedEvent(
              widget.commentModel, widget.postItem,));
          },
          child: Container(
            color: Colors.transparent,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                'Delete',
                style: Theme
                    .of(context)
                    .primaryTextTheme
                    .headline6,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const Divider(),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(height: Dimens.size10),
      ],
    );
  }
}