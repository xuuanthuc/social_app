import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/shimmer_widget.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
class LoadingProfile extends StatelessWidget {
  const LoadingProfile({Key? key}) : super(key: key);

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
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 300),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                const ShimmerWidget.rectangular(
                  height: Dimens.size82,
                  width: Dimens.size82,
                ),
                const SizedBox(height: Dimens.size20),
                const ShimmerWidget.rectangular(
                  height: Dimens.size20,
                  width: Dimens.size120,
                ),
                const SizedBox(height: Dimens.size8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerWidget.rectangular(
                      height: Dimens.size15,
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ],
                ),
                const SizedBox(height: Dimens.size16),
                ShimmerWidget.rectangular(
                  height: Dimens.size50,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
                const SizedBox(height: Dimens.size20),
                ShimmerWidget.rectangular(
                  height: Dimens.size50,
                  width: MediaQuery.of(context).size.width * 0.8,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
