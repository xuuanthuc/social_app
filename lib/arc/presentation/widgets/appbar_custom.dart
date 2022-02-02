import 'package:flutter/material.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';

class AppBarDesign extends StatefulWidget implements PreferredSizeWidget {
  final bool hasAction1;
  final bool hasAction2;
  final bool? hasLeading;
  final String imgAction1;
  final String? imgLeading;
  final String imgAction2;
  final VoidCallback onTapAction1;
  final VoidCallback onTapAction2;
  final VoidCallback? onTapLeading;
  final bool? centerTitle;
  final Widget? title;

  const AppBarDesign(
      {Key? key,
      this.title,
      this.centerTitle,
      this.hasLeading,
      this.imgLeading,
      required this.hasAction1,
      required this.hasAction2,
      required this.imgAction1,
      required this.imgAction2,
      required this.onTapAction1,
      this.onTapLeading,
      required this.onTapAction2})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);
  @override
  final Size preferredSize;

  @override
  State<AppBarDesign> createState() => _AppBarDesignState();
}

class _AppBarDesignState extends State<AppBarDesign> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: AppBar(
        centerTitle: widget.centerTitle ?? false,
        backgroundColor: theme.backgroundColor,
        title: widget.title ??
            SizedBox(
              height: widget.preferredSize.height,
              child: Padding(
                padding: const EdgeInsets.all(Dimens.size15),
                child: Image.asset(MyImages.logoText),
              ),
            ),
        elevation: 0.5,
        shadowColor: Colors.orange,
        automaticallyImplyLeading: widget.hasLeading ?? false,
        leading: widget.hasLeading == true
            ? InkWell(
                onTap: widget.onTapLeading,
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.size18),
                  child: Image.asset(widget.imgLeading ?? ''),
                ),
              )
            : Container(),
        actions: [
          widget.hasAction1 == true
              ? InkWell(
                  onTap: widget.onTapAction1,
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimens.size18),
                    child: Image.asset(widget.imgAction1),
                  ),
                )
              : Container(),
          widget.hasAction2 == true
              ? InkWell(
                  onTap: widget.onTapAction2,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimens.size18),
                      child: Image.asset(widget.imgAction2),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
