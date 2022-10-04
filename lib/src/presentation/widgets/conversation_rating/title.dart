import 'package:etiya_chatbot_data/etiya_chatbot_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:show_up_animation/show_up_animation.dart';

Image ToggLogo() {
  return Image.asset(
    'assets/images/logo.png',
    package: 'etiya_chatbot_flutter',
  );
}

Align ToggBackButton(BuildContext context) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(left: 35),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: const Icon(
          Icons.arrow_back_ios_new,
          size: 18,
        ),
      ),
    ),
  );
}

Padding ToggTitle(MessageResponse chatbotMessage, Size size) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: ShowUpAnimation(
      delayStart: const Duration(seconds: 1),
      animationDuration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      child: Html(
        data: chatbotMessage.rawMessage?.data?.payload?.title ?? '',
        style: {
          "p": Style(
            padding: const EdgeInsets.all(8),
            textAlign: TextAlign.center,
            fontSize: const FontSize(17),
            fontWeight: FontWeight.w400,
          ),
        },
      ),
    ),
  );
}
