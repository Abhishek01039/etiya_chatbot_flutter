import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({
    Key? key,
    required this.slider,
    required this.inActiveTrackColor,
    required this.trackHeight,
    required this.assetImageHeight,
    required this.assetImageWidth,
    required this.gradient,
  }) : super(key: key);

  final Color inActiveTrackColor;
  final double trackHeight;
  final int? assetImageHeight;
  final int? assetImageWidth;
  final Slider slider;
  final LinearGradient gradient;

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double intValue = 0;
  Future<ui.Image> loadImage() async {
    const AssetImage assetImage = AssetImage(
      'assets/images/holder.png',
      package: 'etiya_chatbot_flutter',
    );
    final ImageStream stream =
        assetImage.resolve(createLocalImageConfiguration(context));
    final Completer<ui.Image> completer = Completer();
    stream.addListener(
      ImageStreamListener((ImageInfo image, _) {
        return completer.complete(image.image);
      }),
    );
    return completer.future;
  }

  Future<ui.Image> loadImage2() async {
    const AssetImage assetImage = AssetImage(
      "assets/images/car.png",
      package: 'etiya_chatbot_flutter',
    );
    final ImageStream stream =
        assetImage.resolve(createLocalImageConfiguration(context));
    final Completer<ui.Image> completer = Completer();
    stream.addListener(
      ImageStreamListener((ImageInfo image, _) {
        return completer.complete(image.image);
      }),
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: loadImage2(),
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot2) {
        return FutureBuilder<ui.Image>(
          future: loadImage(),
          builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
            if (snapshot.data == null) {
              return const SizedBox.shrink();
            }
            return SliderTheme(
              data: SliderThemeData(
                trackHeight: widget.trackHeight,
                thumbShape: SliderThumbImage(snapshot.data!, snapshot2.data!),
                trackShape: GradientRectSliderTrackShape(
                  trackHeight: widget.trackHeight,
                  inactiveColor: widget.inActiveTrackColor,
                  gradient: widget.gradient,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: widget.slider,
              ),
            );
          },
        );
      },
    );
  }
}

class GradientRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  GradientRectSliderTrackShape({
    required this.trackHeight,
    required this.inactiveColor,
    this.gradient =
        const LinearGradient(colors: [Colors.lightBlue, Colors.blue]),
  });

  final LinearGradient gradient;
  final double trackHeight;
  final Color inactiveColor;
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    if (sliderTheme.trackHeight! <= 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final trackRadius = Radius.circular(trackRect.height / 2);

    // Assign the track segment paints, which are left: active, right: inactive,
    // but reversed for right to left text.
    final ColorTween activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );

    final ColorTween inactiveTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: inactiveColor,
    );

    final Paint activePaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = gradient.createShader(trackRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;

    final Paint inactivePaint = Paint()
      ..strokeCap = ui.StrokeCap.round
      ..strokeJoin = ui.StrokeJoin.round
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;

    final Paint leftTrackPaint;
    final Paint rightTrackPaint;

    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        trackRect.top,
        thumbCenter.dx,
        trackRect.bottom,
        topLeft: trackRadius,
        bottomLeft: trackRadius,
      ),
      leftTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
        topRight: trackRadius,
        bottomRight: trackRadius,
      ),
      rightTrackPaint,
    );
  }
}

class SliderThumbImage extends SliderComponentShape {
  SliderThumbImage(this.image, this.carImage);
  final ui.Image image;
  final ui.Image carImage;
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.zero;
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final picWidth = image.width;
    final picHeight = image.height;

    final picOffset = Offset(
      center.dx - (picWidth / 2),
      center.dy - (picHeight / 2),
    );

    final circleOffSet = ui.Offset(center.dx, center.dy);

    final paint = Paint()
      ..filterQuality = ui.FilterQuality.high
      ..color = Colors.amber;
    final circlePaint = ui.Paint()
      ..color = const ui.Color.fromARGB(255, 255, 255, 255)
      ..colorFilter;
    final circleShadow = ui.Paint()
      ..color = const ui.Color.fromRGBO(0, 194, 231, 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10)
      ..colorFilter;
    canvas
      ..drawCircle(circleOffSet, 24, circlePaint)
      ..drawCircle(circleOffSet, 25, circleShadow)
      ..drawImage(image, picOffset, paint);
  }
}
