import 'package:etiya_chatbot_data/etiya_chatbot_data.dart';
import 'package:flutter/material.dart';

Column ToggFeedbackWidget({
  FocusNode? focus,
  VoidCallback? tap,
  required VoidCallback send,
  onComplete,
  required ValueNotifier<double> ratingScore,
  required ValueNotifier<double> ratingProgress,
  required MessageResponse chatbotMessage,
  required BuildContext context,
  required TextEditingController controller,
}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(21, 12, 0, 0.07999999821186066),
                offset: Offset(0, 2),
                blurRadius: 4,
              )
            ],
          ),
          child: SizedBox(
            child: TextField(
              onEditingComplete: () => onComplete,
              onTap: tap,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(24),
                hintText: chatbotMessage.text ?? '',
                hintStyle: const TextStyle(color: Colors.black),
              ),
              controller: controller,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              maxLength: 300,
              textInputAction: TextInputAction.send,
              focusNode: focus,
              onSubmitted: (_) => send,
            ),
          ),
        ),
      ),
    ],
  );
}
