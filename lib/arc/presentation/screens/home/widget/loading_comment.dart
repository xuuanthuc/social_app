import 'package:flutter/material.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/shimmer_widget.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';

class LoadingComment extends StatefulWidget {
  const LoadingComment({Key? key}) : super(key: key);

  @override
  State<LoadingComment> createState() => _LoadingCommentState();
}

class _LoadingCommentState extends State<LoadingComment> {
  final FocusNode _focus = FocusNode();
  final TextEditingController _commentController = TextEditingController();
  final bool _canComment = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    debugPrint("Focus: ${_focus.hasFocus.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height - Dimens.size120,
      child: DraggableScrollableSheet(
        initialChildSize: 1,
        minChildSize: 0.85,
        maxChildSize: 1,
        snap: true,
        expand: true,
        builder: (context, scrollController) => ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Scaffold(
            backgroundColor: theme.backgroundColor,
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      top: Dimens.size20, bottom: Dimens.size10),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimens.size15, vertical: Dimens.size15),
                        child: Row(
                          children: [
                            const ShimmerWidget.rectangular(
                              height: Dimens.size60,
                              width: Dimens.size60,
                            ),
                            const SizedBox(width: Dimens.size10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShimmerWidget.rectangular(
                                  height: Dimens.size25,
                                  width: size.width * 0.6,
                                ),
                                const SizedBox(height: Dimens.size10),
                                ShimmerWidget.rectangular(
                                  height: Dimens.size25,
                                  width: size.width * 0.4,
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: 5,
                  ),
                )),
                SizedBox(
                  height: Dimens.size50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: Dimens.size15),
                      _buildAvatarWidget(theme),
                      const SizedBox(width: Dimens.size10),
                      _buildTextFieldComment(theme),
                      _buildCommentButton(),
                      Visibility(
                        visible: !_focus.hasFocus,
                        child: const SizedBox(width: Dimens.size15),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: Dimens.size12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildAvatarWidget(ThemeData theme) {
    return Container(
      height: Dimens.size40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(width: 1, color: theme.primaryColor)),
      width: Dimens.size40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: StaticVariable.myData?.imageUrl == ''
            ? Image.asset(MyImages.defaultAvt, fit: BoxFit.cover,)
            : Image.network(StaticVariable.myData?.imageUrl ?? '', fit: BoxFit.cover,),
      ),
    );
  }

  Visibility _buildCommentButton() {
    return Visibility(
      visible: _focus.hasFocus,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(Dimens.size15),
          child: SizedBox(
              width: Dimens.size20,
              height: Dimens.size20,
              child: Image.asset(_canComment == true
                  ? MyImages.icSend
                  : MyImages.icSendOutline)),
        ),
      ),
    );
  }

  Expanded _buildTextFieldComment(ThemeData theme) {
    return Expanded(
      child: SizedBox(
        height: 40,
        child: TextField(
          focusNode: _focus,
          style: theme.textTheme.headline6,
          controller: _commentController,
          cursorHeight: Dimens.size18,
          decoration: InputDecoration(
              hintText: 'Write comment',
              hintStyle: theme.primaryTextTheme.subtitle1,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: Dimens.size20, vertical: Dimens.size4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: theme.shadowColor.withOpacity(0.7)),
        ),
      ),
    );
  }
}
