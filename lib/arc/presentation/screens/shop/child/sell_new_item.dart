import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/shop.dart';
import 'package:hii_xuu_social/src/validators/constants.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';

import '../../../../../src/config/config.dart';
import '../../../../../src/styles/dimens.dart';
import '../../../../../src/styles/images.dart';
import '../../../../../src/utilities/navigation_service.dart';
import '../../../../../src/utilities/showtoast.dart';
import '../../../../../src/validators/translation_key.dart';
import '../../../../../src/validators/validators.dart';
import '../../../blocs/shop/shop_bloc.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfiled.dart';
import 'package:easy_localization/easy_localization.dart';

class SellNewItemScreen extends StatefulWidget {
  const SellNewItemScreen({Key? key}) : super(key: key);

  @override
  State<SellNewItemScreen> createState() => _SellNewItemScreenState();
}

class _SellNewItemScreenState extends State<SellNewItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _itemLabelTextController =
      TextEditingController();
  final TextEditingController _itemDesTextController = TextEditingController();
  final TextEditingController _itemPriceTextController =
      TextEditingController();
  final TextEditingController _itemQuantityTextController =
      TextEditingController();
  final TextEditingController _itemAddressTextController =
      TextEditingController();
  final TextEditingController _itemContactTextController =
      TextEditingController();
  List<File> _listImageFile = [];
  final PageController _pageListImageController = PageController();
  int _currentIndex = 0;

  CategoryShop? _categoryDropdown;
  final List<CategoryShop> _listCategory = Constants.categoryStore.listCategory;

  void pickImage() {
    context.read<ShopBloc>().add(OnPickImageEvent());
  }

  void onDeleteImage(int index) {
    context.read<ShopBloc>().add(OnDeleteImageEvent(index));
  }

  void submitUpload() {
    if (_listImageFile.isEmpty) {
      ToastView.show(TranslationKey.imagesEmpty.tr());
      return;
    }
    if (_categoryDropdown?.value == -1) {
      ToastView.show(TranslationKey.categoryEmpty.tr());
      return;
    }
    if (_formKey.currentState!.validate()) {
      final ShopItem item = ShopItem(
          shopKeeperId: StaticVariable.myData?.userId,
          itemLabel: _itemLabelTextController.text,
          itemDescription: _itemDesTextController.text,
          price: int.tryParse(_itemPriceTextController.text) ?? 0,
          fileImages: _listImageFile,
          itemType: _categoryDropdown?.value,
          quantity: int.tryParse(_itemQuantityTextController.text) ?? 0,
          address: _itemAddressTextController.text,
          contact: _itemContactTextController.text,
          createdAt: DateTime.now().toIso8601String());
      context.read<ShopBloc>().add(UploadNewSellItemEvent(item));
    }
  }

  @override
  void initState() {
    super.initState();
    _categoryDropdown = _listCategory.first;
  }

  @override
  void dispose() {
    _listImageFile.clear();
    _itemContactTextController.dispose();
    _itemAddressTextController.dispose();
    _itemQuantityTextController.dispose();
    _itemPriceTextController.dispose();
    _itemDesTextController.dispose();
    _itemLabelTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return BlocListener<ShopBloc, ShopState>(
      listener: (context, state) {
        if (state is ImagePickedState) {
          _listImageFile = state.listImageFiles ?? [];
        }
        if (state is OnDeleteImageState) {
          _listImageFile = state.listImageFiles ?? [];
        }
        if(state is LoadingUploadNewItemState){
          EasyLoading.show();
        }
        if(state is UploadNewSellItemSuccessState){
          Navigator.of(context).pop();
          EasyLoading.dismiss();
          ToastView.withBottom(TranslationKey.success.tr());
        }
      },
      child: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: theme.backgroundColor,
            appBar: _buildAppBar(theme, context),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: AnimationLimiter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Dimens.size20),
                  child: Form(
                    key: _formKey,
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
                          const SizedBox(height: Dimens.size10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                TranslationKey.details.tr(),
                                style: theme.primaryTextTheme.headline5,
                              ),
                            ],
                          ),
                          const SizedBox(height: Dimens.size10),
                          _pageViewBigImage(size),
                          const SizedBox(height: Dimens.size5),
                          Row(
                            children: [
                              _btnPickImage(theme),
                              const SizedBox(width: Dimens.size10),
                              _listSmallImage(theme)
                            ],
                          ),
                          const SizedBox(height: Dimens.size20),
                          _optionCategory(),
                          const SizedBox(height: Dimens.size20),
                          CustomTextField(
                            textInputAction: TextInputAction.next,
                            controller: _itemLabelTextController,
                            validator: TextFieldValidator.notEmptyValidator,
                            onChanged: (value) {},
                            hintText: TranslationKey.itemTitle.tr(),
                          ),
                          const SizedBox(height: Dimens.size20),
                          CustomTextField(
                            textInputAction: TextInputAction.next,
                            controller: _itemDesTextController,
                            validator: TextFieldValidator.notEmptyValidator,
                            onChanged: (value) {},
                            maxLines: 5,
                            hintText: TranslationKey.itemDescription.tr(),
                          ),
                          const SizedBox(height: Dimens.size20),
                          CustomTextField(
                            textInputAction: TextInputAction.next,
                            controller: _itemPriceTextController,
                            validator: TextFieldValidator.notEmptyValidator,
                            textInputType: TextInputType.number,
                            onChanged: (value) {},
                            hintText: TranslationKey.itemPrice.tr(),
                          ),
                          const SizedBox(height: Dimens.size20),
                          CustomTextField(
                            textInputAction: TextInputAction.next,
                            controller: _itemQuantityTextController,
                            textInputType: TextInputType.number,
                            validator: TextFieldValidator.notEmptyValidator,
                            onChanged: (value) {},
                            hintText: TranslationKey.itemQuantity.tr(),
                          ),
                          const SizedBox(height: Dimens.size20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                TranslationKey.address.tr(),
                                style: theme.primaryTextTheme.headline5,
                              ),
                            ],
                          ),
                          const SizedBox(height: Dimens.size15),
                          CustomTextField(
                            textInputAction: TextInputAction.next,
                            controller: _itemAddressTextController,
                            validator: TextFieldValidator.notEmptyValidator,
                            onChanged: (value) {},
                            hintText: TranslationKey.itemAddress.tr(),
                          ),
                          const SizedBox(height: Dimens.size20),
                          CustomTextField(
                            textInputAction: TextInputAction.done,
                            controller: _itemContactTextController,
                            validator: TextFieldValidator.notEmptyValidator,
                            onChanged: (value) {},
                            hintText: TranslationKey.itemContact.tr(),
                          ),
                          const SizedBox(height: Dimens.size40),
                          CustomButton(
                            onTap: submitUpload,
                            label: TranslationKey.share.tr(),
                          ),
                          const SizedBox(height: Dimens.size40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _optionCategory() {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: theme.primaryColor.withOpacity(0.1),
      ),
      child: DropdownButton<CategoryShop>(
        value: _categoryDropdown,
        icon: Icon(
          Icons.arrow_drop_down_outlined,
          color: theme.primaryColor,
        ),
        style: TextStyle(color: theme.primaryColor),
        underline: Container(
          color: Colors.transparent,
        ),
        onChanged: (CategoryShop? newValue) {
          setState(() {
            _categoryDropdown = newValue!;
          });
        },
        items: _listCategory
            .map<DropdownMenuItem<CategoryShop>>((CategoryShop item) {
          return DropdownMenuItem<CategoryShop>(
            enabled: item.value == -1 ? false : true,
            value: item,
            child: SizedBox(
                width: size.width - 80,
                child: Padding(
                  padding: const EdgeInsets.only(left: Dimens.size20),
                  child: Text(item.label),
                )),
          );
        }).toList(),
      ),
    );
  }

  AppBar _buildAppBar(ThemeData theme, BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: theme.backgroundColor,
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
            ),
          ),
        ),
      ),
      // title: Text(
      //   TranslationKey.message.tr(),
      //   style: theme.textTheme.headline2,
      // ),
      centerTitle: true,
    );
  }

  Widget _pageViewBigImage(Size size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        height: _listImageFile.isEmpty ? 0 : size.width - Dimens.size30,
        width: size.width - Dimens.size30,
        child: PageView.builder(
            physics: const BouncingScrollPhysics(),
            controller: _pageListImageController,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index) {
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
                        child: GestureDetector(
                          onTap: () {
                            navService.pushNamed(RouteKey.fullImageFile,
                                args: _listImageFile[index]);
                          },
                          child: Image.file(
                            _listImageFile[index],
                            fit: BoxFit.cover,
                          ),
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
    );
  }

  GestureDetector _btnPickImage(ThemeData theme) {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        height: Dimens.size80,
        width: Dimens.size80,
        decoration: BoxDecoration(
            color: theme.primaryColorLight,
            border: Border.all(width: 1, color: theme.primaryColor),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(Dimens.size30),
          child: Image.asset(MyImages.icCameraSelected),
        ),
      ),
    );
  }

  Widget _listSmallImage(ThemeData theme) {
    return Expanded(
      child: SizedBox(
        height: Dimens.size80,
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
                height: Dimens.size80,
                width: Dimens.size80,
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
}
