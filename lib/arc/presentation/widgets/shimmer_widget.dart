import 'package:flutter/material.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final ShapeBorder shapeBorder;
  const ShimmerWidget.rectangular({
    Key? key,
    this.width = double.infinity,
    this.height = Dimens.size10,
    this.shapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(Dimens.size15),
      ),
    ),
  }) : super(key: key);

  const ShimmerWidget.cirular(
      {Key? key,
      @required this.width,
      @required this.height,
      this.shapeBorder = const CircleBorder()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surface,
      highlightColor: Theme.of(context).colorScheme.surface,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          shape: shapeBorder,
        ),
      ),
    );
  }
}