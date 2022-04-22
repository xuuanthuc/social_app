import 'package:flutter/material.dart';
import 'package:hii_xuu_social/arc/presentation/screens/shop/child/shop_detail_my_item.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';

import '../../../../../src/utilities/navigation_service.dart';
import '../../../../../src/validators/static_variable.dart';
import '../../../../../src/validators/translation_key.dart';
import '../../../../data/models/data_models/shop.dart';
import '../child/shop_detail_item.dart';
import 'package:easy_localization/easy_localization.dart';

class ShopItemWidget extends StatelessWidget {
  final ShopItem item;

  const ShopItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        navService.push(
          MaterialPageRoute(
            builder: (context) =>
                item.shopKeeperId != StaticVariable.myData?.userId
                    ? ShopDetailItem(
                        item: item,
                      )
                    : ShopDetailMyItem(
                        item: item,
                      ),
          ),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.width / 2 * 3,
        width: MediaQuery.of(context).size.width / 3 * 2,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200, width: 1),
            borderRadius: BorderRadius.circular(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: item.images?.first ?? '',
                    child: Padding(
                      padding: const EdgeInsets.all(Dimens.size8),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width / 3 * 2,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: Image.network(
                                item.images?.first ?? '',
                                fit: BoxFit.cover,
                              ))),
                    ),
                  ),
                  Positioned(
                    child: switchMarkerItem(item.itemType ?? 0, context),
                    top: Dimens.size15,
                    left: Dimens.size15,
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.size10),
              height: Dimens.size60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemLabel ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.primaryTextTheme.subtitle2,
                  ),
                  const Spacer(),
                  Text(
                    "₫" + item.price.toString(),
                    style: theme.primaryTextTheme.headline6,
                  ),
                  const SizedBox(height: Dimens.size8),
                ],
              ),
            )
          ],
        ),
      ),
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
