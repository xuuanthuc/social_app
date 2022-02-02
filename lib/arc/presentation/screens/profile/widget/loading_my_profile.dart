import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/main/main_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/appbar_custom.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/shimmer_widget.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/validators/constants.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingProfile extends StatelessWidget {
  const LoadingProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBarDesign(
        hasAction1: false,
        hasAction2: true,
        hasLeading: true,
        imgAction1: MyImages.icAddUser,
        imgAction2: MyImages.icSettingSelected,
        imgLeading: MyImages.icAddUser,
        centerTitle: true,
        title: Text(StaticVariable.myData?.fullName ?? '', style: theme.textTheme.headline2,),
        onTapAction1: () {
          context.read<MainBloc>().add(OnChangePageEvent(Constants.page.search));
        },
        onTapAction2: () {
        },
        onTapLeading: (){
          context.read<MainBloc>().add(OnChangePageEvent(Constants.page.search));
        },
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
                const SizedBox(height: Dimens.size25),
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
