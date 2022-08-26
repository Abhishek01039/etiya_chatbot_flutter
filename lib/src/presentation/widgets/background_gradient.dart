import 'package:flutter/material.dart';

final List<Widget> screenGradientElements = [
  Container(
    decoration: BoxDecoration(
      gradient: RadialGradient(
        colors: [
          const Color.fromRGBO(58, 94, 224, 0.4),
          Colors.white.withOpacity(.6),
        ],
        center: const Alignment(0.4, -0.8),
        stops: const [0, .6],
        radius: 0.8,
      ),
    ),
  ),
  Container(
    decoration: BoxDecoration(
      gradient: RadialGradient(
        colors: [
          const Color.fromRGBO(58, 94, 224, 0.2),
          const Color.fromRGBO(108, 203, 233, 0.1),
          const Color.fromRGBO(90, 200, 250, .2),
          Colors.white.withOpacity(.3),
        ],
        center: const Alignment(-2.1, .1),
        radius: 1,
        stops: const [0, .1, .6, 1],
      ),
    ),
  ),
];

const LinearGradient screenLinearGradient = LinearGradient(
  colors: [
    Color.fromRGBO(108, 114, 233, 0.15),
    Color.fromRGBO(90, 200, 250, 0.15),
  ],
);
