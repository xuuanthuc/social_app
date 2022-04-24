import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/shop.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/shop/shop_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/screens/shop/child/sell_new_item.dart';
import 'package:hii_xuu_social/arc/presentation/screens/shop/widgets/shop_item.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';

import '../../../../src/config/app_config.dart';
import '../../../../src/styles/images.dart';
import '../../../../src/utilities/navigation_service.dart';
import '../../widgets/appbar_custom.dart';
import 'package:easy_localization/easy_localization.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final ScrollController _controller = ScrollController();
  int _currentIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  Stream<QuerySnapshot> getListItem() async* {
    if (_currentIndex == -1) {
      yield* FirebaseFirestore.instance
          .collection(AppConfig.instance.cShop)
          .orderBy('created_at', descending: true)
          .snapshots();
    } else if(_currentIndex == -2){
      yield* FirebaseFirestore.instance
          .collection(AppConfig.instance.cShop)
          .where('shop_keeper_id', isEqualTo: StaticVariable.myData?.userId)
          .snapshots();
    } else {
      yield* FirebaseFirestore.instance
          .collection(AppConfig.instance.cShop)
          .where('item_type', isEqualTo: _currentIndex)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return BlocListener<ShopBloc, ShopState>(
      listener: (context, state) {},
      child: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: theme.backgroundColor,
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
                const SizedBox(height: Dimens.size10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: Dimens.size8),
                  height: size.width * 0.2 + 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _itemCategories(MyImages.splashText, 0,
                          TranslationKey.all.tr(), () {
                            setState(() {
                              _currentIndex = -1;
                            });
                          }),
                      _itemCategories(MyImages.icCategory1, 1,
                          TranslationKey.category1.tr(), () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      }),
                      _itemCategories(MyImages.icCategory2, 2,
                          TranslationKey.category2.tr(), () {
                        setState(() {
                          _currentIndex = 1;
                        });
                      }),
                      _itemCategories(MyImages.icCategory3, 3,
                          TranslationKey.category3.tr(), () {
                        setState(() {
                          _currentIndex = 2;
                        });
                      }),
                      _itemCategories(MyImages.icCategory4, 4,
                          TranslationKey.category4.tr(), () {
                        setState(() {
                          _currentIndex = 3;
                        });
                      }),
                      _itemCategories(MyImages.icCategory5, 5,
                          TranslationKey.category5.tr(), () {
                        setState(() {
                          _currentIndex = 4;
                        });
                      }),
                      _itemCategories(MyImages.icSmile, 6,
                          'My store', () {
                            setState(() {
                              _currentIndex = -2;
                            });
                          }),
                    ],
                  ),
                ),
                const SizedBox(height: Dimens.size10),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: getListItem(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                      if (chatSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: Container(),
                        );
                      }
                      return GridView.count(
                        primary: false,
                        physics: const BouncingScrollPhysics(),
                        controller: _controller,
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimens.size20),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3,
                        children: chatSnapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          var _item = ShopItem.fromJson(data);
                          return ShopItemWidget(
                            item: _item,
                          );
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

  Widget _itemCategories(
      String image, int type, String category, VoidCallback onTap) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: size.width * 0.2 + 40,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.size8),
          child: Column(
            children: [
              Container(
                height: size.width * 0.2,
                width: size.width * 0.2,
                decoration: BoxDecoration(
                  color: switchType(type),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.size20),
                  child: Image.asset(image),
                ),
              ),
              const SizedBox(height: Dimens.size5),
              Text(
                category,
                style: theme.primaryTextTheme.bodyText2,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Color switchType(int type) {
  var color = Colors.white;
  switch (type) {
    case 0:
      color = Colors.blueGrey;
      break;
    case 1:
      color = Colors.teal;
      break;
    case 2:
      color = Colors.pink;
      break;
    case 3:
      color = Colors.yellow;
      break;
    case 4:
      color = Colors.purple;
      break;
    case 5:
      color = Colors.blue;
      break;
    case 6:
      color = Colors.greenAccent;
      break;
  }
  return color.withOpacity(0.2);
}
