import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/appbar_custom.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/custom_button.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/utilities/showtoast.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';
import '../../../../arc/presentation/blocs/upload/upload_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UploadBloc>(
      create: (context) => UploadBloc(),
      child: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  List<File> _listImageFile = [];
  final PageController _pageListImageController = PageController();
  final TextEditingController _contentController = TextEditingController();
  int _currentIndex = 0;

  void sharePost() {
    FocusScope.of(context).requestFocus(FocusNode());
    context.read<UploadBloc>().add(OnSubmitSharePostEvent(_contentController.text));
  }

  void pickImage() {
    context.read<UploadBloc>().add(OnPickImageEvent());
  }

  void onDeleteImage(int index){
    context.read<UploadBloc>().add(OnDeleteImageEvent(index));
  }

  @override
  void dispose() {
    _contentController.dispose();
    _listImageFile.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pickImage();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return BlocListener<UploadBloc, UploadState>(
      listener: (context, state) {
        if (state is ImagePickedState) {
          _listImageFile = state.listImageFiles ?? [];
        }
        if(state is OnDeleteImageState){
          _listImageFile = state.listImageFiles ?? [];
        }
        if(state is SharePostSuccessState){
          EasyLoading.dismiss();
        }
        if(state is SharePostFailedState){
          EasyLoading.dismiss();
          ToastView.show(state.error);
        }
        if(state is LoadingSharePostState){
          EasyLoading.show();
        }
      },
      child: BlocBuilder<UploadBloc, UploadState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: const AppBarDesign(),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildShareBtn(theme),
                  Padding(
                    padding: const EdgeInsets.all(Dimens.size10),
                    child: Container(
                        decoration: BoxDecoration(
                            color: theme.backgroundColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            _textFieldContentPost(theme),
                            _pageViewBigImage(size),
                            Padding(
                              padding: const EdgeInsets.all(Dimens.size10),
                              child: Row(
                                children: [
                                  _btnPickImage(theme),
                                  const SizedBox(width: Dimens.size10),
                                  _listSmallImage(theme)
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _listSmallImage(ThemeData theme) {
    return Expanded(
      child: SizedBox(
        height: Dimens.size40,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                await _pageListImageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                );
              },
              child: Container(
                height: Dimens.size40,
                width: Dimens.size60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                        width: 1,
                        color: index == _currentIndex
                            ? theme.primaryColor
                            : Colors.white)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _listImageFile[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
          itemCount: _listImageFile.length,
          separatorBuilder: (context, index) {
            return const SizedBox(width: Dimens.size10);
          },
        ),
      ),
    );
  }

  GestureDetector _btnPickImage(ThemeData theme) {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        height: Dimens.size40,
        width: Dimens.size60,
        decoration: BoxDecoration(
            color: theme.primaryColorLight,
            border: Border.all(width: 1, color: theme.primaryColor),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(Dimens.size10),
          child: Image.asset(MyImages.icCameraSelected),
        ),
      ),
    );
  }

  Padding _pageViewBigImage(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.size5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          height: _listImageFile.isEmpty ? 0 : size.width - Dimens.size30,
          width: size.width - Dimens.size30,
          child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _pageListImageController,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index){
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(Dimens.size5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: _listImageFile.isEmpty
                              ? 0
                              : size.width - Dimens.size30,
                          width: size.width - Dimens.size30,
                          child: Image.file(
                            _listImageFile[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: Dimens.size10,
                          top: Dimens.size10,
                          child: GestureDetector(
                            onTap: () => onDeleteImage(index),
                            child: Container(
                              width: Dimens.size30,
                              height: Dimens.size30,
                              color: Colors.transparent,
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: _listImageFile.length),
        ),
      ),
    );
  }

  TextField _textFieldContentPost(ThemeData theme) {
    return TextField(
      maxLines: 7,
      style: theme.textTheme.headline6,
      controller: _contentController,
      decoration: InputDecoration(
        hintText: TranslationKey.descriptionPost.tr(),
        border: const OutlineInputBorder(borderSide: BorderSide.none),
      ),
    );
  }

  Container _buildShareBtn(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.size20,
        vertical: Dimens.size10,
      ),
      color: theme.backgroundColor,
      child: Row(
        children: [
          Container(
            width: Dimens.size52,
            height: Dimens.size52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              border:
                  Border.all(width: Dimens.size2, color: theme.primaryColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Dimens.size2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: StaticVariable.myData?.imageUrl == ''
                    ? Image.asset(
                        MyImages.defaultAvt,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        StaticVariable.myData?.imageUrl ?? '',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          const SizedBox(width: Dimens.size10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StaticVariable.myData?.fullName ?? '',
                style: theme.textTheme.headline5,
              ),
              Text(
                '@' + (StaticVariable.myData?.username ?? ''),
                style: theme.primaryTextTheme.subtitle1,
              ),
            ],
          ),
          const Spacer(),
          CustomButton(
            onTap: sharePost,
            sizeWidth: Dimens.size90,
            sizeHeight: Dimens.size30,
            borderRadius: 10,
            label: TranslationKey.share.tr(),
          )
        ],
      ),
    );
  }
}
