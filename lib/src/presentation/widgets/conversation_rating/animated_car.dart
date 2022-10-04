import 'package:flutter/material.dart';

class AnimatedCar extends StatelessWidget {
  AnimatedCar({
    Key? key,
    required this.ratingProgress,
    required this.size,
  }) : super(key: key);
  ValueNotifier<double> ratingProgress;
  Size size;

  @override
  Widget build(BuildContext context) {
    const carWidth = 70.0;
    final ratingProgressPercentage = ratingProgress.value / 5;

    final tempProg = size.width - size.width / 18 - carWidth;
    final carPositionX = tempProg * ratingProgressPercentage;

    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 800),
          curve: Curves.ease,
          height: size.height / 9,
          width: size.width / 4,
          left: (ratingProgress.value < 1 ? -20 : 5) + carPositionX,
          child: Image.asset(
            "assets/images/car.png",
            package: 'etiya_chatbot_flutter',
            width: carWidth,
          ),
        ),
      ],
    );
  }
}
