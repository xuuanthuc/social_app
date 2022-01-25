import 'package:flutter/material.dart';
import 'package:hii_xuu_social/src/styles/images.dart';

class AppBarDesign extends StatelessWidget implements PreferredSizeWidget {
  const AppBarDesign({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        centerTitle: true,
        title: SizedBox(
            height: preferredSize.height,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(MyImages.logoText),
            )),
        elevation: 0,
        backgroundColor: theme.backgroundColor,
      ),
    );
  }
}
