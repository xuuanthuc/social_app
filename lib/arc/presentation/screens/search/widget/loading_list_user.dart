import 'package:flutter/material.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/shimmer_widget.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';

class LoadingListUserScreen extends StatefulWidget {

  const LoadingListUserScreen({Key? key}) : super(key: key);

  @override
  _LoadingSearchScreenState createState() => _LoadingSearchScreenState();
}

class _LoadingSearchScreenState extends State<LoadingListUserScreen> {

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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildItemUser(context, index, theme);
              },
              itemCount: 5,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemUser(BuildContext context, int index, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.size15, vertical: Dimens.size10),
      child: Row(
        children: [
          const ShimmerWidget.rectangular(
            height: Dimens.size50,
            width: Dimens.size50,
          ),
          const SizedBox(
            width: Dimens.size10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ShimmerWidget.rectangular(
                height: Dimens.size15,
                width: Dimens.size140,
              ),
              SizedBox(height: Dimens.size10),
              ShimmerWidget.rectangular(
                height: Dimens.size15,
                width: Dimens.size100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
