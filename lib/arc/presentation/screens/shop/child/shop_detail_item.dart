import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/shop.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/user.dart';

import '../../../../../src/styles/dimens.dart';
import '../../../../../src/styles/images.dart';
import '../../../../../src/utilities/navigation_service.dart';
import '../../../blocs/shop/shop_bloc.dart';
import '../../chat/child/box_chat_screen.dart';

class ShopDetailItem extends StatefulWidget {
  final ShopItem item;

  const ShopDetailItem({Key? key, required this.item}) : super(key: key);

  @override
  State<ShopDetailItem> createState() => _ShopDetailItemState();
}

class _ShopDetailItemState extends State<ShopDetailItem> {
  UserData? _seller;

  @override
  void initState() {
    super.initState();
    context
        .read<ShopBloc>()
        .add(InitProfileSellerEvent(widget.item.shopKeeperId ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return BlocListener<ShopBloc, ShopState>(
      listener: (context, state) {},
      child: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          if (state is InitProfileSuccessState) {
            _seller = state.user;
          }
          return Scaffold(
            backgroundColor: theme.backgroundColor,
            appBar: _buildAppBar(theme, context),
            body: Column(
              children: [
                Hero(
                    tag: widget.item.images?.first ?? '',
                    child: Image.network(widget.item.images?.first ?? '')),
                _seller == null
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          navService.push(
                            MaterialPageRoute(
                              builder: (context) => BoxChatScreen(
                                userId: _seller?.userId ?? '',
                                username: _seller?.fullName ?? '',
                                imageUser: _seller?.imageUrl,
                              ),
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
                                child: Image.asset(MyImages.icFlightSelected),
                              ),
                              Text(
                                'Chat voi nguoi ban',
                                style: theme.textTheme.headline2,
                              ),
                              const SizedBox(
                                width: Dimens.size10,
                              )
                            ],
                          ),
                        ),
                      )
              ],
            ),
          );
        },
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
}
