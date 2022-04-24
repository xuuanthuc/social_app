import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/shop.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/user.dart';
import 'package:hii_xuu_social/arc/presentation/screens/shop/child/sell_update_item.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../src/config/config.dart';
import '../../../../../src/styles/dimens.dart';
import '../../../../../src/styles/images.dart';
import '../../../../../src/utilities/navigation_service.dart';
import '../../../../../src/validators/translation_key.dart';
import '../../../blocs/shop/shop_bloc.dart';
import '../../chat/child/box_chat_screen.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../profile/widget/full_image.dart';

class ShopDetailMyItem extends StatefulWidget {
  ShopItem item;
  ShopDetailMyItem({Key? key, required this.item}) : super(key: key);

  @override
  State<ShopDetailMyItem> createState() => _ShopDetailMyItemState();
}

class _ShopDetailMyItemState extends State<ShopDetailMyItem> {
  UserData? _seller;
  List<String> _listImageFile = [];
  final PageController _pageListImageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _listImageFile = widget.item.images ?? [];
    context
        .read<ShopBloc>()
        .add(InitProfileSellerEvent(widget.item.shopKeeperId ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return BlocListener<ShopBloc, ShopState>(
      listener: (context, state) {
        if(state is UpdateNewSellItemSuccessState){
          context.read<ShopBloc>().add(GetDetailItem(widget.item.itemId ?? ''));
        }
      },
      child: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          if (state is InitProfileSuccessState) {
            _seller = state.user;
          }
          if(state is GetDetailItemSuccessState){
            widget.item = state.item;
          }
          return Scaffold(
            backgroundColor: theme.backgroundColor,
            appBar: _buildAppBar(theme, context),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: Dimens.size10),
                  _pageViewBigImage(size),
                  const SizedBox(height: Dimens.size10),
                  _listSmallImage(theme),
                  const SizedBox(height: Dimens.size20),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.size20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        switchMarkerItem(widget.item.itemType ?? 0, context),
                        const SizedBox(width: Dimens.size10),
                        Text(
                          widget.item.itemLabel ?? '',
                          style: theme.primaryTextTheme.headline2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimens.size10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.size20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "₫" + widget.item.price.toString(),
                          style: theme.textTheme.headline2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimens.size10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.size20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.itemDescription.toString(),
                          style: theme.textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimens.size10),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: Dimens.size20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.address.toString(),
                          style: theme.textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimens.size20),
                  _seller == null
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(Dimens.size20),
                          child: GestureDetector(
                            onTap: () {
                              navService.push(
                                MaterialPageRoute(
                                  builder: (context) => UpdateSellItemScreen(id: widget.item.itemId ?? ""),
                                ),
                              );
                            },
                            child: Container(
                              height: Dimens.size40,
                              // width: Dimens.size150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      width: 1, color: theme.primaryColor)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(Dimens.size10),
                                    child: Image.asset(MyImages.icSettingSelected),
                                  ),
                                  Text(
                                    'Edit information',
                                    style: theme.textTheme.headline2,
                                  ),
                                  const SizedBox(width: Dimens.size10)
                                ],
                              ),
                            ),
                          ),
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
    return SizedBox(
      height: Dimens.size80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.size20),
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
                  child: Image.network(
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
                            navService.push(
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) =>
                                    FullImageScreen(image: _listImageFile),
                              ),
                            );
                          },
                          child: Hero(
                            tag: _listImageFile.first,
                            child: Image.network(
                              _listImageFile[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: _listImageFile.length),
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
      title: Text(
        widget.item.itemLabel ?? '',
        style: theme.textTheme.headline2,
      ),
      centerTitle: true,
    );
  }

  Widget switchMarkerItem(int itemType, BuildContext context) {
    var widget = Container();
    switch (itemType) {
      case 0:
        widget =
            _itemMarker(TranslationKey.category1.tr(), Colors.teal, context);
        break;
      case 1:
        widget =
            _itemMarker(TranslationKey.category2.tr(), Colors.pink, context);
        break;
      case 2:
        widget =
            _itemMarker(TranslationKey.category3.tr(), Colors.yellow, context);
        break;
      case 3:
        widget =
            _itemMarker(TranslationKey.category4.tr(), Colors.purple, context);
        break;
      case 4:
        widget =
            _itemMarker(TranslationKey.category5.tr(), Colors.blue, context);
        break;
    }
    return widget;
  }

  Container _itemMarker(String label, Color color, BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: color),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimens.size8, vertical: Dimens.size2),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }
}
