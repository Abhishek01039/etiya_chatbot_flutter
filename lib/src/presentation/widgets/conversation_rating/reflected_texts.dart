import 'package:auto_size_text/auto_size_text.dart';
import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_data/models/api/etiya_message_response.dart';
import 'package:flutter/material.dart';
import 'package:show_up_animation/show_up_animation.dart';

Widget ReflectedTexts(
  MessageResponse chatbotMessage,
  ValueNotifier<double> ratingScore,
) {
  return Visibility(
    visible: ratingScore.value > -1,
    child: Center(
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 800),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) => AnimatedOpacity(
          duration: const Duration(milliseconds: 800),
          opacity: value,
          child: _animateTexts(
            chatbotMessage,
            ratingScore,
          ),
        ),
      ),
    ),
  );
}

Widget _animateTexts(
    MessageResponse chatbotMessage, ValueNotifier<double> ratingScore) {
  return AnimatedOpacity(
    duration: const Duration(seconds: 1),
    opacity: 1,
    child: ShowUpAnimation(
      offset: 2,
      delayStart: const Duration(milliseconds: 200),
      animationDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubicEmphasized,
      child: AutoSizeText(
        chatbotMessage.rawMessage?.data?.payload
                ?.emojiText?[ratingScore.value.clamp(0, 4.6).toInt()].value ??
            '',
        maxLines: 4,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
