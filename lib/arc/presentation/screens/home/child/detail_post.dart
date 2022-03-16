import 'package:flutter/material.dart';

import '../../../../../src/styles/dimens.dart';
import '../../../../../src/styles/images.dart';
import '../../../../data/models/data_models/post.dart';
import '../widget/post_item.dart';

class DetailPostScreen extends StatefulWidget {
  final PostData post;
  const DetailPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<DetailPostScreen> createState() => _DetailPostScreenState();
}

class _DetailPostScreenState extends State<DetailPostScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(Dimens.size8),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
                decoration: BoxDecoration(
                  color: theme.primaryColorLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.size12),
                  child: Image.asset(MyImages.icBack),
                )),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            PostItem(
              item: widget.post,
            )
          ],
        ),
      ),
    );
  }
}
