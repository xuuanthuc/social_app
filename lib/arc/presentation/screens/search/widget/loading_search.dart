import 'package:flutter/material.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/main/main_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/appbar_custom.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/shimmer_widget.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/validators/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingSearchScreen extends StatefulWidget {
  final TextEditingController? controller;

  const LoadingSearchScreen({Key? key, this.controller}) : super(key: key);

  @override
  _LoadingSearchScreenState createState() => _LoadingSearchScreenState();
}

class _LoadingSearchScreenState extends State<LoadingSearchScreen> {
  final FocusNode _focus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _focus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBarDesign(
        hasAction1: false,
        hasAction2: false,
        centerTitle: true,
        title: Text('Search', style: theme.textTheme.headline2),
        imgAction1: MyImages.icCameraSelected,
        imgAction2: MyImages.icSend,
        onTapAction1: () {
          context.read<MainBloc>().add(OnChangePageEvent(Constants.page.camera));
        },
        onTapAction2: () {
          context.read<MainBloc>().add(OnChangePageEvent(Constants.page.chat));
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: Dimens.size8),
          _buildSearchField(theme),
          const SizedBox(height: Dimens.size20),
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

  Container _buildSearchField(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.size15),
      height: 40,
      child: TextField(
        focusNode: _focus,
        controller: widget.controller,
        style: theme.textTheme.headline6,
        cursorHeight: Dimens.size18,
        decoration: InputDecoration(
            hintText: 'Enter full name',
            hintStyle: theme.primaryTextTheme.subtitle1,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: const Icon(Icons.close),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: Dimens.size20, vertical: Dimens.size4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: theme.shadowColor.withOpacity(0.7)),
      ),
    );
  }
}
