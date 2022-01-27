import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/auth/auth_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/custom_button.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/custom_textfiled.dart';
import 'package:hii_xuu_social/src/config/config.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/utilities/navigation_service.dart';
import 'package:hii_xuu_social/src/utilities/showtoast.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hii_xuu_social/src/validators/validators.dart';

class LoginSheet extends StatefulWidget {
  final int initPage;

  const LoginSheet({Key? key, required this.initPage}) : super(key: key);

  @override
  _LoginSheetState createState() => _LoginSheetState();
}

class _LoginSheetState extends State<LoginSheet>
    with SingleTickerProviderStateMixin {
  late PageController _controller;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _registerUsernameController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    _registerUsernameController.dispose();
    _usernameController.dispose();
    _registerPasswordController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  void submitLogin() {
    context.read<AuthBloc>().add(SubmitLoginEvent(
        password: _passwordController.text.trim(),
        username: _usernameController.text.trim()));
  }

  void submitRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(SubmitRegisterEvent(
          password: _registerPasswordController.text.trim(),
          username: _registerUsernameController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoadingLoginState) {
          EasyLoading.show();
        }
        if (state is LoginSuccessState) {
          EasyLoading.dismiss();
          navService.pushReplacementNamed(RouteKey.main);
        }
        if (state is LoginFailedState) {
          EasyLoading.dismiss();
          ToastView.show('Login Failed');
        }
        if (state is UserExistState) {
          EasyLoading.dismiss();
          ToastView.show(_registerUsernameController.text + 'Existed');
        }
        if (state is RegisterFailedState) {
          EasyLoading.dismiss();
          ToastView.show('Register Failed');
        }
        if (state is RegisterSuccessState) {
          EasyLoading.dismiss();
          navService.pushNamed(RouteKey.setUpProfile);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [_buildLogin(context), _buildRegister(context)],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogin(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: AnimationConfiguration.toStaggeredList(
        duration: const Duration(milliseconds: 300),
        childAnimationBuilder: (widget) => SlideAnimation(
          verticalOffset: Dimens.size50,
          child: FadeInAnimation(child: widget),
        ),
        children: [
          const SizedBox(height: Dimens.size30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: TranslationKey.login.tr(),
                      style: Theme.of(context).primaryTextTheme.headline2,
                    ),
                    TextSpan(
                      text: ' To HiiXuu',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.size30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.size30),
            child: CustomTextField(
              controller: _usernameController,
              textInputAction: TextInputAction.next,
              hintText: TranslationKey.username.tr(),
            ),
          ),
          const SizedBox(height: Dimens.size20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.size30),
            child: CustomTextField(
              isPassword: true,
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              hintText: TranslationKey.password.tr(),
            ),
          ),
          const SizedBox(height: Dimens.size4),
          Container(
            color: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.size30, vertical: Dimens.size10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      TranslationKey.forgotPassword.tr(),
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    ),
                  ],
                )),
          ),
          const SizedBox(height: Dimens.size20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.size30),
            child: CustomButton(
              onTap: submitLogin,
              label: TranslationKey.login.tr(),
            ),
          ),
          const SizedBox(height: Dimens.size20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _controller.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: TranslationKey.notHaveAccount.tr(),
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      ),
                      TextSpan(
                        text: ' ' + TranslationKey.register.tr(),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegister(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 300),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: Dimens.size50,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            const SizedBox(height: Dimens.size30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: TranslationKey.register.tr(),
                        style: Theme.of(context).primaryTextTheme.headline2,
                      ),
                      TextSpan(
                        text: ' HiiXuu',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      TextSpan(
                        text: ' Account',
                        style: Theme.of(context).primaryTextTheme.headline2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.size30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.size30),
              child: CustomTextField(
                validator: TextFieldValidator.usernameValidator,
                controller: _registerUsernameController,
                textInputAction: TextInputAction.next,
                hintText: TranslationKey.registerUsername.tr(),
              ),
            ),
            const SizedBox(height: Dimens.size20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.size30),
              child: CustomTextField(
                isPassword: true,
                validator: TextFieldValidator.passValidator,
                controller: _registerPasswordController,
                textInputAction: TextInputAction.next,
                hintText: TranslationKey.registerPassword.tr(),
              ),
            ),
            const SizedBox(height: Dimens.size20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.size30),
              child: CustomTextField(
                isPassword: true,
                validator: (value) {
                  if (value != _registerPasswordController.text) {
                    return 'Mật khẩu không khớp';
                  }
                  return null;
                },
                controller: _rePasswordController,
                textInputAction: TextInputAction.done,
                hintText: TranslationKey.confirmPassword.tr(),
              ),
            ),
            const SizedBox(height: Dimens.size20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.size30),
              child: CustomButton(
                onTap: submitRegister,
                label: TranslationKey.register.tr(),
              ),
            ),
            const SizedBox(height: Dimens.size20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: TranslationKey.haveAccount.tr(),
                          style: Theme.of(context).primaryTextTheme.subtitle1,
                        ),
                        TextSpan(
                          text: ' ' + TranslationKey.login.tr(),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
