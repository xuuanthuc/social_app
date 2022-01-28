import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/main/main_bloc.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/validators/constants.dart';
import 'package:provider/src/provider.dart';

class AppBarDesign extends StatefulWidget implements PreferredSizeWidget {
  const AppBarDesign({Key? key})
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
        centerTitle: false,
        backgroundColor: theme.backgroundColor,
        title: SizedBox(
          height: widget.preferredSize.height,
          child: Padding(
            padding: const EdgeInsets.all(Dimens.size15),
            child: Image.asset(MyImages.logoText),
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () {
              context.read<MainBloc>().add(OnChangePageEvent(Constants.page.camera));
            },
            borderRadius: BorderRadius.circular(50),
            child: Padding(
              padding: const EdgeInsets.all(Dimens.size18),
              child: Image.asset(
                MyImages.icCameraSelected,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              context.read<MainBloc>().add(OnChangePageEvent(Constants.page.chat));
            },
            borderRadius: BorderRadius.circular(50),
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(Dimens.size18),
                child: Image.asset(
                  MyImages.icSend,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
