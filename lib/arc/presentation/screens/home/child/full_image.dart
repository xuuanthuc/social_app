import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';

class FullImageScreen extends StatelessWidget {
  final String image;
  final VoidCallback comment;
  final String countCmt;

  const FullImageScreen(
      {Key? key,
      required this.image,
      required this.comment,
      required this.countCmt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Center(
            child: Image.network(
              image,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: Dimens.size20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Dimens.size5),
                GestureDetector(
                  onTap: comment,
                  child: Row(
                    children: [
                      const SizedBox(width: Dimens.size15),
                      // Padding(
                      //   padding: const EdgeInsets.all(Dimens.size5),
                      //   child: SvgPicture.asset(MyImages.icComment),
                      // ),
                      Text(
                        int.tryParse(countCmt)! <= 1
                            ? countCmt +
                                ' comment'
                            : countCmt +
                                ' comments',
                        style: Theme.of(context).primaryTextTheme.button,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: Dimens.size5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
