import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../arc/presentation/blocs/main/main_bloc.dart';
import '../../../../arc/presentation/screens/home/home_screen.dart';
import '../../../../arc/presentation/screens/upload/upload_screen.dart';
import '../../../../src/styles/dimens.dart';
import '../../../../src/styles/images.dart';
import '../../../../src/utilities/showtoast.dart';
import '../../../../src/validators/translation_key.dart';
import 'package:easy_localization/easy_localization.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainBloc>(
      create: (context) => MainBloc(),
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
  DateTime? currentBackPressTime;
  int _selectedIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    _controller.addListener(_handlePageChange);
    context.read<MainBloc>().add(InitMainEvent());
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        if (state is OnChangedPageState) {
          // _controller.animateToPage(state.index,
          //     duration: const Duration(milliseconds: 200), curve: Curves.ease);
          _controller.jumpToPage(state.index);
        }
      },
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return WillPopScope(
            child: Scaffold(
              body: PageView(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                children: [
                  const HomeScreen(),
                  Container(
                    color: Colors.grey,
                  ),
                  const UploadScreen(),
                  Container(
                    color: Colors.red,
                  ),
                  Container(
                    color: Colors.black,
                  ),
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
                        child: Image.asset(MyImages.icChatSelected)),
                    icon: SizedBox(
                        width: Dimens.size20,
                        height: Dimens.size20,
                        child: Image.asset(MyImages.icChatUnSelected)),
                    label: 'Chat',
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
