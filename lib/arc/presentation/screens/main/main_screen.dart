import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hii_xuu_social/arc/data/models/data_models/post.dart';
import 'package:hii_xuu_social/arc/presentation/screens/chat/chat_screen.dart';
import 'package:hii_xuu_social/arc/presentation/screens/profile/profile_screen.dart';
import 'package:hii_xuu_social/arc/presentation/screens/search/search_screen.dart';
import 'package:hii_xuu_social/arc/presentation/screens/shop/shop_screen.dart';
import 'package:hii_xuu_social/src/validators/constants.dart';
import '../../../../arc/presentation/blocs/main/main_bloc.dart';
import '../../../../arc/presentation/screens/home/home_screen.dart';
import '../../../../arc/presentation/screens/upload/upload_screen.dart';
import '../../../../src/service/event_bus.dart';
import '../../../../src/styles/dimens.dart';
import '../../../../src/styles/images.dart';
import '../../../../src/utilities/navigation_service.dart';
import '../../../../src/utilities/showtoast.dart';
import '../../../../src/validators/static_variable.dart';
import '../../../../src/validators/translation_key.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../data/models/data_models/user.dart';
import '../../blocs/notice/notice_bloc.dart';
import '../chat/child/box_chat_screen.dart';
import '../home/child/detail_post.dart';
import '../profile/user_profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime? currentBackPressTime;
  int _selectedIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    _controller.addListener(_handlePageChange);
    context.read<MainBloc>().add(InitMainEvent());
    _handleMessageOnBackground();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_handlePageChange);
    _controller.dispose();
  }

  void _handlePageChange() {
    setState(() {
      _selectedIndex = (_controller.page ?? 0.0).toInt();
    });
  }

  void _handleMessageOnBackground() {
    FirebaseMessaging.instance.getInitialMessage().then(
      (remoteMessage) {
        if (remoteMessage != null) {
          if (remoteMessage.data["notice_type"] == "message") {
            eventBus.fire(OnMessageNoticeClickedEvent(remoteMessage.data));
          } else if (remoteMessage.data["notice_type"] == "post") {
            eventBus.fire(OnPostNoticeClickedEvent(remoteMessage.data));
          } else if (remoteMessage.data["notice_type"] == "follow") {
            eventBus.fire(OnFollowNoticeClickedEvent(remoteMessage.data));
          }
        }
      },
    );
  }

  void goToBoxChat(UserData user) {
    navService.push(
      MaterialPageRoute(
        builder: (context) => BoxChatScreen(
          userId: user.userId ?? '',
          username: user.fullName ?? '',
          imageUser: user.imageUrl,
        ),
      ),
    );
  }

  void goToDetailPost(PostData post) {
    navService.push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => DetailPostScreen(post: post),
      ),
    );
  }

  void goToUserInfo(String userId) {
    if (userId == StaticVariable.myData?.userId) {
      context.read<MainBloc>().add(OnChangePageEvent(Constants.page.profile));
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return UserProfile(userId: userId);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MainBloc, MainState>(
          listener: (context, state) {
            if (state is OnChangedPageState) {
              // _controller.animateToPage(state.index,
              //     duration: const Duration(milliseconds: 200), curve: Curves.ease);
              _controller.jumpToPage(state.index);
            }
          },
        ),
        BlocListener<NoticeBloc, NoticeState>(
          listener: (context, state) {
            if (state is OnClickMessageNoticeState) {
              // _controller.jumpToPage(Constants.page.chat);
              // navService.push(
              //   MaterialPageRoute(
              //     builder: (context) => const ChatScreen(),
              //   ),
              // );
              goToBoxChat(state.user);
            }
            if (state is OnClickPostNoticeState) {
              goToDetailPost(state.post);
            }
            if (state is OnClickFollowNoticeState) {
              goToUserInfo(state.userId);
            }
          },
        ),
      ],
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return WillPopScope(
            child: Scaffold(
              body: PageView(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                children: const [
                  HomeScreen(),
                  ShopScreen(),
                  UploadScreen(),
                  SearchScreen(),
                  ProfileScreen()
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    activeIcon: SizedBox(
                        width: Dimens.size19,
                        height: Dimens.size20,
                        child: Image.asset(MyImages.icHomeSelected)),
                    icon: SizedBox(
                        width: Dimens.size19,
                        height: Dimens.size20,
                        child: Image.asset(MyImages.icHomeUnSelected)),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: SizedBox(
                        width: Dimens.size20,
                        height: Dimens.size20,
                        child: Image.asset(MyImages.icShopSelected)),
                    icon: SizedBox(
                        width: Dimens.size20,
                        height: Dimens.size20,
                        child: Image.asset(MyImages.icShopUnSelected)),
                    label: 'Shop',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: SizedBox(
                        width: Dimens.size35,
                        height: Dimens.size35,
                        child: Image.asset(MyImages.icCameraCircle)),
                    icon: SizedBox(
                        width: Dimens.size35,
                        height: Dimens.size35,
                        child: Image.asset(MyImages.icCameraCircle)),
                    label: 'Camera',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: SizedBox(
                        width: Dimens.size20,
                        height: Dimens.size20,
                        child: Image.asset(MyImages.icSearchSelected)),
                    icon: SizedBox(
                        width: Dimens.size20,
                        height: Dimens.size20,
                        child: Image.asset(MyImages.icSearchUnSelected)),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: SizedBox(
                        width: Dimens.size16,
                        height: Dimens.size20,
                        child: Image.asset(MyImages.icProfileSelected)),
                    icon: SizedBox(
                        width: Dimens.size16,
                        height: Dimens.size20,
                        child: Image.asset(MyImages.icProfileUnSelected)),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _selectedIndex,
                showSelectedLabels: false,
                elevation: 0,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Theme.of(context).backgroundColor,
                onTap: (index) {
                  context.read<MainBloc>().add(OnChangePageEvent(index));
                },
              ),
            ),
            onWillPop: () async {
              DateTime now = DateTime.now();
              if (currentBackPressTime == null ||
                  now.difference(currentBackPressTime!) >
                      const Duration(seconds: 2)) {
                currentBackPressTime = now;
                ToastView.withBottom(TranslationKey.tapExit.tr());
                return Future.value(false);
              }
              exit(0);
            },
          );
        },
      ),
    );
  }
}
