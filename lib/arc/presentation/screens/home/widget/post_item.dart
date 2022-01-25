import 'package:flutter/material.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/utilities/format.dart';

class PostItem extends StatelessWidget {
  final PostData item;

  const PostItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.size15, vertical: Dimens.size7),
      child: Container(
        padding: const EdgeInsets.all(Dimens.size15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: theme.backgroundColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SizedBox(
                  width: Dimens.size40,
                  height: Dimens.size40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: item.authAvatar == ''
                        ? Image.asset(
                      MyImages.defaultAvt,
                      fit: BoxFit.cover,
                    )
                        : Image.network(
                      item.authAvatar ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: Dimens.size10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.authName ?? '',
                      style: theme.textTheme.headline5,
                    ),
                    Text(
                      TimeAgo.timeAgoSinceDate(item.updateAt ?? ''),
                      style: theme.primaryTextTheme.subtitle1,
                    ),
                  ],
                ),
              ],
            ),
            Text(item.content ?? ''),
            SizedBox(
              height: 100,
              child: PageView.builder(
                  itemBuilder: (context, ind) {
                    return Image.network(item.images?[ind] ?? '');
                  },
                  itemCount: item.images?.length ?? 0),
            )
          ],
        ),
      ),
    );
  }
}
