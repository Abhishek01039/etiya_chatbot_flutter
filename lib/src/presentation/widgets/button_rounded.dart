import 'package:flutter/material.dart';

class ButtonRounded extends StatelessWidget {
  const ButtonRounded({
    Key? key,
    this.text,
    this.onPressed,
    this.color,
    this.textColor = Colors.white,
    this.child,
    this.margin,
  }) : super(key: key);

  final String? text;
  final Widget? child;
  final void Function()? onPressed;
  final Color? color;
  final Color? textColor;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(66),
        color: color,
        gradient: color != null
            ? null
            : const LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xff00D1F9), Color(0xff379FFF)],
                stops: [0.0, 1.0],
              ),
      ),
      margin: margin,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(66),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all(0),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: onPressed,
        child: child == null && text != null
            ? Text(
                text ?? '',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
              )
            : child ?? const SizedBox(),
      ),
    );
  }
}
