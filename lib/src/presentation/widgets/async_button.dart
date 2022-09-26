import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AsyncButton extends HookWidget {
  const AsyncButton({
    Key? key,
    this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.child,
    this.buttonStyle,
    this.height = 56,
    this.margin,
    this.isEnabled = true,
    this.width,
    this.shape,
  }) : super(key: key);

  final String? text;
  final ButtonStyle? buttonStyle;
  final Widget? child;
  final FutureOr<void> Function()? onPressed;
  final bool isEnabled;
  final Color? color, textColor;
  final double height;
  final EdgeInsets? margin;
  final double? width;
  final MaterialStateProperty<OutlinedBorder?>? shape;

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    return Container(
      height: 56,
      width: width ?? double.infinity,
      margin: margin,
      child: ElevatedButton.icon(
        style: buttonStyle ?? _defaultButtonStyle(),
        icon: isLoading.value
            ? Container(
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(2),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : const SizedBox(),
        onPressed: (!isEnabled || isLoading.value)
            ? null
            : () => _onPressed(isLoading),
        label: child == null && text != null
            ? AutoSizeText(
                text ?? '',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: textColor ?? Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                maxLines: 1,
              )
            : child ?? const SizedBox(),
      ),
    );
  }

  ButtonStyle _defaultButtonStyle() => ButtonStyle(
        backgroundColor:
            color == null ? null : MaterialStateProperty.all<Color>(color!),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
        ),
      );

  Future<void> _onPressed(ValueNotifier<bool> isLoading) async {
    isLoading.value = true;
    await onPressed?.call();
    await Future.delayed(
      const Duration(milliseconds: 300),
      () => isLoading.value = false,
    );
  }
}
