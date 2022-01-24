import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';
import 'package:hii_xuu_social/src/styles/images.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final bool? isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final int? maxLines;
  const CustomTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.textInputType,
    this.maxLines = 1,
    this.textInputAction
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool hidePass = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      child: TextFormField(
        obscureText: widget.isPassword == true ? hidePass : false,
        style: theme.textTheme.headline6,
        controller: widget.controller,
        validator: widget.validator,
        maxLines: widget.maxLines,
        textInputAction: widget.textInputAction,
        onChanged: widget.onChanged,
        keyboardType: widget.textInputType,
        decoration: InputDecoration(
          hintText: widget.hintText,
          fillColor: theme.primaryColor.withOpacity(0.1),
          filled: true,
          suffixIcon: widget.isPassword == true
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      hidePass = !hidePass;
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimens.size15),
                      child: SvgPicture.asset(hidePass == true
                          ? MyImages.icHidePassword
                          : MyImages.icShowPassword),
                    ),
                  ))
              : null,
          hintStyle: theme.primaryTextTheme.headline6,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: Dimens.size20, vertical: Dimens.size5),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: Dimens.size2,
              color: theme.primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: Dimens.size2,
              color: theme.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
