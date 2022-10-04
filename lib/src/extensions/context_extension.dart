import 'dart:ui';

import 'package:flutter/material.dart';

class Dimension {
  static const bottomBarHeight = 70.0;
}

extension BuildContextExt on BuildContext {
  double get screenHeightExceptBottomBarAndAppBar {
    final screenHeight = MediaQuery.of(this).size.height;
    final spacings = MediaQueryData.fromWindow(window).viewPadding.bottom +
        MediaQueryData.fromWindow(window).padding.top +
        MediaQueryData.fromWindow(window).viewPadding.top;
    const bottomBarHeight = Dimension.bottomBarHeight;
    return screenHeight - spacings - bottomBarHeight;
  }

  double get screenHeight {
    return MediaQuery.of(this).size.height;
  }

  double get screenWidth {
    return MediaQuery.of(this).size.width;
  }
}
