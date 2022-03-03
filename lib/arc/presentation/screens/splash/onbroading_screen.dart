import 'package:flutter/material.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';

import '../../../../src/config/config.dart';
import '../../../../src/preferences/app_preference.dart';
import '../../../../src/utilities/navigation_service.dart';
import 'package:easy_localization/easy_localization.dart';

class OnBroadScreen extends StatefulWidget {
  const OnBroadScreen({Key? key}) : super(key: key);

  @override
  State<OnBroadScreen> createState() => _OnBroadScreenState();
}

class _OnBroadScreenState extends State<OnBroadScreen> {
  final PageController _controller = PageController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handlePageChange);
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
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            children: [
              _onBoardingScreen(
                topImg: MyImages.imgTopOnBoarding1,
                mainImg: MyImages.imgOnBoarding1,
              ),
              _onBoardingScreen(
                topImg: MyImages.imgTopOnBoarding2,
                mainImg: MyImages.imgOnBoarding2,
              ),
              _onBoardingScreen(
                topImg: MyImages.imgTopOnBoarding3,
                mainImg: MyImages.imgOnBoarding3,
              ),
            ],
          ),
          Positioned(
            bottom: Dimens.size60,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _bottomSmallPage(
                    context,
                    index: 0,
                  ),
                  _bottomSmallPage(
                    context,
                    index: 1,
                  ),
                  _bottomSmallPage(
                    context,
                    index: 2,
                  ),
                ],
              ),
            ),
          ),
          _nextButton(context),
          _skipButton(context),
        ],
      ),
    );
  }

  Positioned _skipButton(BuildContext context) {
    return Positioned(
      top: Dimens.size40,
      right: Dimens.size20,
      child: InkWell(
        onTap: () {
          AppPreference().setOnBoardingSeen(true);
          navService.pushNamed(RouteKey.login);
        },
        child: Padding(
          padding: const EdgeInsets.all(Dimens.size10),
          child: Text(
            TranslationKey.skip.tr(),
            style: Theme.of(context).primaryTextTheme.button,
          ),
        ),
      ),
    );
  }

  Positioned _nextButton(BuildContext context) {
    return Positioned(
      bottom: Dimens.size50,
      right: Dimens.size20,
      child: InkWell(
        onTap: () {
          if (_selectedIndex >= 2) {
            AppPreference().setOnBoardingSeen(true);
            navService.pushNamed(RouteKey.login);
          } else {
            _controller.animateToPage(
              _selectedIndex + 1,
              curve: Curves.ease,
              duration: const Duration(milliseconds: 300),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(Dimens.size10),
          child: Text(
            TranslationKey.next.tr(),
            style: Theme.of(context).primaryTextTheme.headline5,
          ),
        ),
      ),
    );
  }

  Widget _bottomSmallPage(
    BuildContext context, {
    required int index,
  }) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: index == _selectedIndex
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColor.withOpacity(0.3),
        ),
        height: Dimens.size12,
        width: index == _selectedIndex ? Dimens.size25 : Dimens.size12,
      ),
    );
  }

  Widget _onBoardingScreen({
    required String topImg,
    required String mainImg,
  }) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            topImg,
            fit: BoxFit.fitWidth,
          ),
        ),
        Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Image.asset(mainImg)),
        ),
      ],
    );
  }
}
