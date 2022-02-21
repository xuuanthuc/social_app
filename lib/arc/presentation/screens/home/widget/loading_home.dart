import 'package:flutter/material.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/main/main_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/appbar_custom.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/shimmer_widget.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/validators/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class LoadingHome extends StatelessWidget {
  const LoadingHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBarDesign(
        hasAction1: false,
        hasLeading: true,
        hasAction2: true,
        centerTitle: true,
        imgAction1: MyImages.icCameraSelected,
        imgAction2: MyImages.icSend,
        imgLeading: MyImages.icCameraSelected,
        onTapLeading: () {
          context.read<MainBloc>().add(OnChangePageEvent(Constants.page.camera));
        },
        onTapAction1: () {
          context.read<MainBloc>().add(OnChangePageEvent(Constants.page.camera));
        },
        onTapAction2: () {
          context.read<MainBloc>().add(OnChangePageEvent(Constants.page.chat));
        },
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimens.size15),
              child: Container(
                height: Dimens.size88,
                color: theme.backgroundColor,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: const [
                        ShimmerWidget.rectangular(
                          height: Dimens.size68,
                          width: Dimens.size68,
                        ),
                        SizedBox(
                          height: Dimens.size20,
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: Dimens.size15);
                  },
                  itemCount: 5,
                ),
              ),
            ),
            Container(
              color: theme.scaffoldBackgroundColor,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: Dimens.size8, vertical: Dimens.size7),
                    height: Dimens.size300,
                    decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const ShimmerWidget.rectangular(
                              height: Dimens.size40,
                              width: Dimens.size40,
                            ),
                            const SizedBox(width: Dimens.size10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                ShimmerWidget.rectangular(
                                  height: Dimens.size15,
                                  width: Dimens.size100,
                                ),
                                SizedBox(height: Dimens.size10),
                                ShimmerWidget.rectangular(
                                  height: Dimens.size15,
                                  width: Dimens.size80,
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: Dimens.size20),
                        const ShimmerWidget.rectangular(
                          height: 200,
                        ),
                      ],
                    ),
                  );
                },
                itemCount: 5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
