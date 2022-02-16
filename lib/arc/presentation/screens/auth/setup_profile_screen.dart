import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hii_xuu_social/arc/presentation/blocs/auth/auth_bloc.dart';
import 'package:hii_xuu_social/arc/presentation/screens/auth/widgets/success_dialog.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/custom_button.dart';
import 'package:hii_xuu_social/arc/presentation/widgets/custom_textfiled.dart';
import 'package:hii_xuu_social/src/config/config.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hii_xuu_social/src/styles/images.dart';
import 'package:hii_xuu_social/src/utilities/navigation_service.dart';
import 'package:hii_xuu_social/src/utilities/showtoast.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';
import 'package:hii_xuu_social/src/validators/translation_key.dart';
import 'package:hii_xuu_social/src/validators/validators.dart';
import 'dart:io';

class SetUpProfileScreen extends StatefulWidget {
  const SetUpProfileScreen({Key? key}) : super(key: key);

  @override
  _SetUpProfileScreenState createState() => _SetUpProfileScreenState();
}

class _SetUpProfileScreenState extends State<SetUpProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _fullName = '';
  String _bio = '';
  String? _image = '';
  File? _imageFile;

  void submitUpdateProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(SubmitUpdateProfileEvent(
          fullName: _fullNameController.text,
          username: StaticVariable.myData?.username ?? '',
          password: StaticVariable.myData?.password ?? '',
          tagName: _fullNameController.text.trim().toLowerCase(),
          email: _emailController.text,
          phone: _phoneController.text,
          imageUrl: _image,
          userId: StaticVariable.myData?.userId ?? '',
          bio: _bioController.text,
          createAt: StaticVariable.myData?.createAt ?? '',
          updateAt: DateTime.now().toUtc().toIso8601String()));
    }
  }

  void _pickImage() {
    context.read<AuthBloc>().add(OnPickImageEvent());
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _image = StaticVariable.myData?.imageUrl ?? '';
    context.read<AuthBloc>().add(const OnChangedFullNameTextEvent(''));
    context.read<AuthBloc>().add(const OnChangedBioTextEvent(''));
  }

  Future<void> _showSuccessDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (BuildContext context) {
        return SuccessDialog(
          onTap: (){
            Navigator.of(context).pop();
          },
        );
      },
    );
    navService.pushReplacementNamed(RouteKey.main);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is LoadingLoginState) {
          EasyLoading.show();
        }
        if (state is OnChangedFullNameTextState) {
          _fullName = state.text ?? '';
        }
        if (state is OnChangedBioTextState) {
          _bio = state.text ?? '';
        }
        if (state is SubmitUpdateProfileSuccessState) {
          EasyLoading.dismiss();
          _showSuccessDialog();
        }
        if (state is SubmitUpdateProfileFailedState) {
          EasyLoading.dismiss();
          ToastView.show('Register Failed');
        }
        if (state is ImagePickedState) {
          _image = state.imagePath;
          _imageFile = state.imageFile;
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Form(
              key: _formKey,
              child: Scaffold(
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: AnimationLimiter(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimens.size30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 300),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            const SizedBox(height: Dimens.size20),
                            Text(
                              TranslationKey.setUpProfile.tr(),
                              style: theme.primaryTextTheme.headline2,
                            ),
                            const SizedBox(height: Dimens.size10),
                            Text(
                              TranslationKey.updateProfileDescription.tr(),
                              style: theme.primaryTextTheme.headline4,
                            ),
                            const SizedBox(height: Dimens.size30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: Dimens.size120,
                                  width: Dimens.size120,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: Dimens.size110,
                                        width: Dimens.size110,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(29),
                                            border: Border.all(
                                                width: 3,
                                                color: theme.primaryColor)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              Dimens.size2),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              child: _image != ''
                                                  ? Image.network(_image ?? '', fit: BoxFit.cover,)
                                                  : _imageFile != null
                                                      ? Image.file(_imageFile!, fit: BoxFit.cover,)
                                                      : Image.asset(
                                                          MyImages.defaultAvt, fit: BoxFit.cover,)),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: _pickImage,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: theme.primaryColorLight,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                border: Border.all(
                                                    width: 1,
                                                    color: theme.primaryColor)),
                                            child: SizedBox(
                                                height: Dimens.size40,
                                                width: Dimens.size40,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      Dimens.size8),
                                                  child: SvgPicture.asset(
                                                      MyImages.icCamera),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: Dimens.size15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    _fullName,
                                    style: theme.textTheme.headline5,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: Dimens.size5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimens.size30),
                                  child: Center(
                                      child: Text(
                                    _bio,
                                    style: theme.textTheme.headline6,
                                    textAlign: TextAlign.center,
                                  )),
                                ),
                              ],
                            ),
                            const SizedBox(height: Dimens.size25),
                            CustomTextField(
                              textInputAction: TextInputAction.next,
                              controller: _fullNameController,
                              validator: TextFieldValidator.fullnameValidator,
                              onChanged: (value) {
                                context.read<AuthBloc>().add(
                                    OnChangedFullNameTextEvent(
                                        _fullNameController.text));
                              },
                              hintText: TranslationKey.fullName.tr(),
                            ),
                            const SizedBox(height: Dimens.size20),
                            CustomTextField(
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.phone,
                              controller: _phoneController,
                              hintText: TranslationKey.phone.tr(),
                            ),
                            const SizedBox(height: Dimens.size20),
                            CustomTextField(
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.emailAddress,
                              controller: _emailController,
                              hintText: TranslationKey.email.tr(),
                            ),
                            const SizedBox(height: Dimens.size20),
                            CustomTextField(
                              textInputAction: TextInputAction.done,
                              maxLines: 5,
                              controller: _bioController,
                              onChanged: (value) {
                                context
                                    .read<AuthBloc>()
                                    .add(OnChangedBioTextEvent(value));
                              },
                              hintText: TranslationKey.bio.tr(),
                            ),
                            const SizedBox(height: Dimens.size20),
                            CustomButton(
                              onTap: submitUpdateProfile,
                              label: TranslationKey.save.tr(),
                            )
                          ],
                        ),
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
}
