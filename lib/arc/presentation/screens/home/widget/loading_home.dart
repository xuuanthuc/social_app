import 'package:flutter/material.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/appbar_custom.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/shimmer_widget.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';

class LoadingHome extends StatelessWidget {
  const LoadingHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: const AppBarDesign(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 100,
              color: theme.backgroundColor,
            ),
            Container(
              color: theme.scaffoldBackgroundColor,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(horizontal: Dimens.size8,vertical: Dimens.size7),
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
