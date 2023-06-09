import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class VButton extends HookWidget {
  const VButton({
    Key? key,
    this.text = '',
    this.disabledColor,
    this.disabledTextColor,
    this.textColor,
    this.color,
    this.width = double.infinity,
    this.height = 44,
    this.fontSize = 16,
    this.fontFamily,
    this.weight = FontWeight.w600,
    this.borderSide,
    this.borderRadius,
    @required this.onPressed,
  }) : super(key: key);

  final String? text;
  final VoidCallback? onPressed;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final Color? textColor;
  final Color? color;
  final double? width;
  final double? height;
  final FontWeight? weight;
  final double? fontSize;
  final String? fontFamily;
  final BorderSide? borderSide;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: borderSide ?? BorderSide.none,
            borderRadius: borderRadius ??
                const BorderRadius.all(
                  Radius.circular(8.0),
                ),
          ),
        ),
      ),
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: onPressed == null ? (disabledColor ?? Color(0x70000000)) : (color ?? Colors.black),
          borderRadius: borderRadius ??
              const BorderRadius.all(
                Radius.circular(8.0),
              ),
        ),
        child: Text(
          text ?? "",
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: weight,
            fontFamily: fontFamily,
            color: onPressed == null ? (disabledTextColor ?? Colors.white38) : (textColor ?? Colors.white),
          ),
        ),
      ),
    );
  }
}
