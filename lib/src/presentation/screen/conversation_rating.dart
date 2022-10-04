import 'package:etiya_chatbot_data/etiya_chatbot_data.dart';
import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:etiya_chatbot_flutter/src/cubit/chatbot_cubit.dart';
import 'package:etiya_chatbot_flutter/src/extensions/context_extension.dart';
import 'package:etiya_chatbot_flutter/src/localization/localization.dart';
import 'package:etiya_chatbot_flutter/src/presentation/widgets/conversation_rating/animated_car.dart';
import 'package:etiya_chatbot_flutter/src/presentation/widgets/conversation_rating/async_button.dart';
import 'package:etiya_chatbot_flutter/src/presentation/widgets/conversation_rating/background_gradient.dart';
import 'package:etiya_chatbot_flutter/src/presentation/widgets/conversation_rating/car_slider.dart';
import 'package:etiya_chatbot_flutter/src/presentation/widgets/conversation_rating/feedback.dart';
import 'package:etiya_chatbot_flutter/src/presentation/widgets/conversation_rating/rating.dart';
import 'package:etiya_chatbot_flutter/src/presentation/widgets/conversation_rating/reflected_texts.dart';
import 'package:etiya_chatbot_flutter/src/presentation/widgets/conversation_rating/title.dart';
import 'package:etiya_chatbot_flutter/src/presentation/widgets/core/chatbot_popup.dart';
import 'package:etiya_chatbot_flutter/src/presentation/widgets/core/chatfold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ConversationRatingScreenUpdated extends HookWidget {
  final MessageResponse message;
  final ChatTheme theme;
  double progress = 0;
  TextEditingController feedbackTextController = TextEditingController();
  final controller = ScrollController();
  late FocusNode focusNode;

  ConversationRatingScreenUpdated(this.message, this.theme);

  @override
  Widget build(BuildContext context) {
    final ratingScore = useState<double>(0);
    final ratingProgress = useState<double>(0);
    final textIndex = useState<double>(0);
    final size = MediaQuery.of(context).size;
    final opacityController = useState<double>(0);
    final changeFinished = useState<bool>(false);
    final textEditing = useState<bool>(false);

    return Chatfold(
      appBarElements: [
        Expanded(
          child: ToggBackButton(context),
        ),
        Expanded(
          child: ToggLogo(),
        ),
        const Spacer()
      ],
      scaffoldBackGround: screenGradientElements,
      elements: [
        if (!textEditing.value)
          Expanded(
            flex: 3,
            child: ToggTitle(message, size),
          ),
        if (!textEditing.value)
          Expanded(
            child: AnimatedCar(ratingProgress: ratingProgress, size: size),
          ),
        if (!textEditing.value)
          Expanded(
            child: CarSlider(ratingScore, ratingProgress, changeFinished),
          ),
        Expanded(
          flex: 2,
          child: ToggRating(
            ratingScore,
            ratingProgress,
            textIndex,
            opacityController,
            changeFinished,
            message,
          ),
        ),
        if (changeFinished.value)
          SizedBox(
            height: context.screenHeight / 12,
          )
        else
          SizedBox(
            height: context.screenHeight / 12,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ReflectedTexts(message, ratingScore),
            ),
          ),
        Expanded(
          flex: 3,
          child: ToggFeedbackWidget(
            onComplete: () {
              changeFinished.value = false;

              if (feedbackTextController == null) {
                sendFeedback(ratingScore, context);
              }
            },
            tap: () => textEditing.value = !textEditing.value,
            send: () => sendFeedback(ratingScore, context),
            ratingScore: ratingScore,
            focus: focusNode,
            ratingProgress: ratingProgress,
            chatbotMessage: message,
            context: context,
            controller: feedbackTextController,
          ),
        ),
        Expanded(
          child: _submitButton(ratingScore, ratingProgress, context, size),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  AsyncButton _submitButton(
    ValueNotifier<double> ratingScore,
    ValueNotifier<double> ratingProgress,
    BuildContext context,
    Size size,
  ) {
    return AsyncButton(
      isEnabled: ratingProgress.value != 0.30,
      text: message.elements?.title ?? context.localization.submit,
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      onPressed: () => sendFeedback(ratingScore, context),
      child: Text(
        message.elements?.title ?? context.localization.submit,
      ),
    );
  }

  Future<void> sendFeedback(
    ValueNotifier<double> ratingScore,
    BuildContext context,
  ) async {
    context.read<ChatbotCubit>().userSubmittedFeedbackMessage(
          ratingScore: ratingScore.value.ceilToDouble(),
          feedback: feedbackTextController.text,
          sessionId: int.tryParse(message.sessionId ?? '') ?? 0,
        );
    alertCustomMessage(
      context,
      message.thank ?? context.localization.end_message,
      icon: 'assets/images/logo.png',
    );
  }
}
