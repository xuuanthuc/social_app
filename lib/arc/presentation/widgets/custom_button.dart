import 'package:flutter/material.dart';
import 'package:hii_xuu_social/src/styles/dimens.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool? hasBorder;
  final bool? hasBgColor;
  final double? sizeWidth;
  final double? sizeHeight;

  const CustomButton({
    Key? key,
    required this.onTap,
    required this.label,
    this.hasBorder = false,
    this.hasBgColor = false,
    this.sizeHeight,
    this.sizeWidth,
  }) : super(key: key);

  const CustomButton.withBorder({
    Key? key,
    required this.onTap,
    required this.label,
    this.hasBorder = true,
    this.hasBgColor,
    this.sizeHeight,
    this.sizeWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: sizeHeight ?? Dimens.size50,
        width: sizeWidth ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color:
                hasBgColor == true ? theme.primaryColor.withOpacity(0.1) : null,
            borderRadius: BorderRadius.circular(15),
            gradient: hasBorder == true
                ? null
                : LinearGradient(
                    colors: [
                      theme.primaryColor,
                      theme.colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            border: hasBorder == false
                ? null
                : Border.all(width: 2, color: theme.primaryColor)),
        child: Center(
          child: Text(
            label,
            style: hasBorder == true
                ? theme.primaryTextTheme.headline5
                : theme.primaryTextTheme.button,
          ),
        ),
      ),
    );
  }
}
