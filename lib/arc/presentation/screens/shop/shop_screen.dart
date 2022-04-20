import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/shop.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/shop/shop_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/screens/shop/child/sell_new_item.dart';
import 'package:hii_xuu_social/arc/presentation/screens/shop/child/shop_detail_item.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';

import '../../../../src/config/app_config.dart';
import '../../../../src/styles/images.dart';
import '../../../../src/utilities/navigation_service.dart';
import '../../widgets/appbar_custom.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<ShopBloc, ShopState>(
      listener: (context, state) {},
      child: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBarDesign(
              hasAction1: false,
              hasAction2: true,
              centerTitle: true,
              title: Text(
                'PetStore',
                style: theme.textTheme.headline2,
              ),
              imgAction1: MyImages.icCameraSelected,
              imgAction2: MyImages.icSellNewItem,
              onTapAction1: () {
                // context.read<MainBloc>().add(OnChangePageEvent(Constants.page.camera));
              },
              onTapAction2: () {
                navService.push(
                  MaterialPageRoute(
                    builder: (context) => const SellNewItemScreen(),
                  ),
                );
              },
            ),
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: Dimens.size8),
                  height: Dimens.size100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _itemCategories(),
                      _itemCategories(),
                      _itemCategories(),
                      _itemCategories(),
                      _itemCategories(),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(AppConfig.instance.cShop)
                        .orderBy('created_at', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                      if (chatSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: Container(),
                        );
                      }
                      return ListView(
                        controller: _controller,
                        physics: const BouncingScrollPhysics(),
                        children: chatSnapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          var _item = ShopItem.fromJson(data);
                          return GestureDetector(
                              onTap: () {
                                if (_item.shopKeeperId !=
                                    StaticVariable.myData?.userId) {
                                  navService.push(
                                    MaterialPageRoute(
                                      builder: (context) => ShopDetailItem(
                                        item: _item,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Hero(
                                  tag: _item.images?.first ?? '',
                                  child: Image.network(_item.images?.first ?? '')));
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _itemCategories() {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(Dimens.size8),
      child: Container(
        height: size.width * 0.2,
        width: size.width * 0.2,
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
