import 'package:etiya_chatbot_flutter/src/presentation/widgets/conversation_rating/custom_slider.dart';
import 'package:flutter/material.dart';

CustomSlider CarSlider(
  ValueNotifier<double> ratingScore,
  ValueNotifier<double> ratingProgress,
  ValueNotifier<bool> valueChange,
) {
  return CustomSlider(
    gradient: const LinearGradient(
      colors: [
        Color(0xFFFF001F),
        Color(0xFFFF983C),
        Color(0xFFFFD748),
        Color(0xFF74DB34),
        Color(0xFF00DF24),
      ],
    ),
    trackHeight: 8,
    assetImageHeight: 40,
    assetImageWidth: 40,
    inActiveTrackColor: const Color.fromRGBO(21, 12, 0, 0.05),
    slider: Slider(
      max: 5,
      value: ratingProgress.value,
      onChangeEnd: (_) {
        valueChange.value = false;
      },
      onChangeStart: (_) => valueChange.value = true,
      onChanged: (value) {
        var tempvalue = value;
        tempvalue = tempvalue.clamp(0.30, 4.7);
        ratingProgress.value = tempvalue;
        value = value.ceilToDouble();
        ratingScore.value = value - 1;
      },
    ),
  );
}
