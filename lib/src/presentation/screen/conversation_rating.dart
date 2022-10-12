import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_data/models/api/etiya_message_response.dart';
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

    useEffect(() {
      focusNode = FocusNode();
      return null;
    });

    return Chatfold(
      scrollController: controller,
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
        SizedBox(
          height: 100,
          child: ToggTitle(message, size),
        ),
        SizedBox(
          height: 50,
          child: AnimatedCar(ratingProgress: ratingProgress, size: size),
        ),
        CarSlider(ratingScore, ratingProgress, changeFinished),
        ToggRating(
          ratingScore,
          ratingProgress,
          textIndex,
          opacityController,
          changeFinished,
          message,
        ),
        if (changeFinished.value)
          SizedBox(
            height: context.screenHeight / 10,
          )
        else
          SizedBox(
            height: context.screenHeight / 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ReflectedTexts(message, ratingScore),
            ),
          ),
        ToggFeedbackWidget(
          tap: () async {
            await controller.animateTo(
              controller.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeIn,
            );
          },
          onComplete: () {
            changeFinished.value = false;

            if (feedbackTextController == null) {
              sendFeedback(ratingScore, context);
            }
          },
          send: () => sendFeedback(ratingScore, context),
          ratingScore: ratingScore,
          focus: focusNode,
          ratingProgress: ratingProgress,
          chatbotMessage: message,
          context: context,
          controller: feedbackTextController,
        ),
        const SizedBox(
          height: 16,
        ),
        _submitButton(ratingScore, ratingProgress, context, size),
        const SizedBox(
          height: 16,
        ),
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
