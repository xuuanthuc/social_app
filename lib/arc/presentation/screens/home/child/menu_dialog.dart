import 'package:flutter/material.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/home/home_bloc.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';

import '../../../../../src/styles/dimens.dart';
import '../../../../data/models/data_models/post.dart';
import '../../../blocs/profile/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
class MenuDialog extends StatefulWidget {
  final PostData item;

  const MenuDialog({Key? key, required this.item}) : super(key: key);

  @override
  _MenuDialogState createState() => _MenuDialogState();
}

class _MenuDialogState extends State<MenuDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: Dimens.size15),
        widget.item.userId != StaticVariable.myData?.userId
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  context
                      .read<ProfileBloc>()
                      .add(OnUnFollowClickedEvent(widget.item.userId ?? ''));
                },
                child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      TranslationKey.unFollow.tr(),
                      style: Theme.of(context).primaryTextTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  context
                      .read<HomeBloc>()
                      .add(DeletePostClickedEvent(widget.item));
                },
                child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      TranslationKey.delete.tr(),
                      style: Theme.of(context).primaryTextTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
        const Divider(),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                TranslationKey.save.tr(),
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const Divider(),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                TranslationKey.cancel.tr(),
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
