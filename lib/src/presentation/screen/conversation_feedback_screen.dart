import 'package:auto_size_text/auto_size_text.dart';
import 'package:etiya_chatbot_data/etiya_chatbot_data.dart';
import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:etiya_chatbot_flutter/src/cubit/chatbot_cubit.dart';
import 'package:etiya_chatbot_flutter/src/localization/localization.dart';
import 'package:etiya_chatbot_flutter/src/presentation/screen/conversation_rating_feedback_screen.dart';
import 'package:etiya_chatbot_flutter/src/presentation/widgets/background_gradient.dart';
import 'package:etiya_chatbot_flutter/src/presentation/widgets/button_rounded.dart';
import 'package:etiya_chatbot_flutter/src/presentation/widgets/custom_slider.dart';
import 'package:etiya_chatbot_flutter/src/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:show_up_animation/show_up_animation.dart';

// ignore: must_be_immutable
class ConversationRatingScreen extends HookWidget {
  ConversationRatingScreen({required this.message, required this.theme});
  final MessageResponse message;
  final ChatTheme theme;
  double progress = 0;
  TextEditingController feedbackTextController = TextEditingController();
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final ratingScore = useState<double>(0);
    final ratingProgress = useState<double>(0.17);
    final textIndex = useState<double>(0);
    final size = MediaQuery.of(context).size;

    // final animationControl = ();
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: _conversationRatingScreen(
        ratingScore,
        ratingProgress,
        textIndex,
        message,
        context,
        size,
      ),
    );
  }

  Widget _conversationRatingScreen(
      ValueNotifier<double> ratingScore,
      ValueNotifier<double> ratingProgress,
      ValueNotifier<double> textIndex,
      MessageResponse chatbotMessage,
      BuildContext context,
      Size size) {
    return _conversationFeedbackBody(
      context,
      [
        SizedBox(
          height: size.height / 25,
        ),
        _backButton(context, size),
        _toggLogo(size),
        SizedBox(height: size.height / 70),
        _toggTitle(chatbotMessage, size),
        _AnimatedCar(
          ratingProgress: ratingProgress,
          size: size,
        ),
        _carSlider(ratingScore, ratingProgress, size),
        _ratingWidget(
          ratingScore,
          ratingProgress,
          textIndex,
          chatbotMessage,
          size,
        ),
        _feedbackWidget(
          ratingScore,
          ratingProgress,
          chatbotMessage,
          context,
          size,
        ),
        _submitButton(ratingScore, ratingProgress, context, size),
      ],
      size,
    );
  }

  Widget _conversationFeedbackBody(
      BuildContext context, List<Widget> widgets, Size size) {
    return Stack(
      children: [
        ...screenGradientElements,
        SingleChildScrollView(
          controller: controller,
          child: Padding(
            padding: EdgeInsets.all(size.width / 60),
            child: Column(
              children: widgets,
            ),
          ),
        ),
      ],
    );
  }

  Align _backButton(BuildContext context, Size size) {
    debugPrint("conv backButton");
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

  SizedBox _toggLogo(Size size) {
    return SizedBox(
      width: size.width / 2.5,
      child: Image.asset(
        'assets/images/logo.png',
        package: 'etiya_chatbot_flutter',
      ),
    );
  }

  Padding _toggTitle(MessageResponse chatbotMessage, Size size) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ShowUpAnimation(
        delayStart: const Duration(seconds: 1),
        animationDuration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        child:
            Html(data: chatbotMessage.rawMessage?.data?.payload?.title ?? ''),
      ),
    );
  }

  SizedBox _carSlider(ValueNotifier<double> ratingScore,
      ValueNotifier<double> ratingProgress, Size size) {
    return SizedBox(
      height: size.height / 11,
      child: CustomSlider(
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
        assetImageHeight: 50,
        assetImageWidth: 50,
        inActiveTrackColor: const Color.fromRGBO(21, 12, 0, 0.05),
        slider: Slider(
          max: 5,
          value: ratingProgress.value,
          onChanged: (value) {
            var tempvalue = value;
            tempvalue = tempvalue.clamp(0.17, 4.85);
            ratingProgress.value = tempvalue;
            value = value.ceilToDouble();
            Log.info('onRatingUpdate = ');
            ratingScore.value = value;
            debugPrint(
              " our value = $value" + "\n our progressvalue= $tempvalue",
            );
          },
        ),
      ),
    );
  }

  ButtonRounded _submitButton(ValueNotifier<double> ratingScore,
      ValueNotifier<double> ratingProgress, BuildContext context, Size size) {
    return ratingProgress.value != 0.17
        ? ButtonRounded(
            text: message.elements?.title ?? context.localization.submit,
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            onPressed: () => ratingProgress.value != 0.17
                ? sendFeedback(ratingScore, context)
                : null,
            child: Text(
              message.elements?.title ?? context.localization.submit,
            ),
          )
        : ButtonRounded(
            color: Colors.grey.shade400,
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            text: context.localization.submit,
            onPressed: () {},
            child: Text(
              message.elements?.title ?? context.localization.submit,
            ),
          );
  }

  Column _feedbackWidget(
      ValueNotifier<double> ratingScore,
      ValueNotifier<double> ratingProgress,
      MessageResponse chatbotMessage,
      BuildContext context,
      Size size) {
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
              height: size.height / 8,
              child: TextField(
                onTap: () {
                  controller.animateTo(
                    MediaQuery.of(context).size.height * 0.31,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 600),
                  );
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(24),
                  hintText: message.text ?? '',
                  hintStyle: const TextStyle(color: Colors.black),
                ),
                controller: feedbackTextController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                maxLength: 300,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => sendFeedback(ratingScore, context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _ratingWidget(
      ValueNotifier<double> ratingScore,
      ValueNotifier<double> ratingProgress,
      ValueNotifier<double> textIndex,
      MessageResponse chatbotMessage,
      Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 40),
      child: Column(
        children: [
          SizedBox(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(21, 12, 0, 0.07999999821186066),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  )
                ],
                color: const Color.fromRGBO(255, 255, 255, 1),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ratingElement(
                      text: message
                              .rawMessage?.data?.payload?.emojiText?[0].title ??
                          '',
                      activeColor: const Color(0xFFE12125),
                      icon: FontAwesomeIcons.faceFrownOpen,
                      isActive: ratingScore.value <= 1 &&
                          ratingProgress.value != 0.17,
                      ontap: () {
                        ratingScore.value = 1;
                        ratingProgress.value = 0.40;
                        return null;
                      },
                    ),
                    ratingElement(
                      text: message
                              .rawMessage?.data?.payload?.emojiText?[1].title ??
                          '',
                      icon: FontAwesomeIcons.faceFrown,
                      activeColor: const Color(0xFFF25A29),
                      isActive: ratingScore.value > 1 && ratingScore.value <= 2,
                      ontap: () {
                        ratingScore.value = 2;
                        ratingProgress.value = 1.40;
                        return null;
                      },
                    ),
                    ratingElement(
                      text: message
                              .rawMessage?.data?.payload?.emojiText?[2].title ??
                          '',
                      icon: FontAwesomeIcons.faceMeh,
                      activeColor: const Color(0xFFFCB040),
                      isActive: ratingScore.value > 2 && ratingScore.value <= 3,
                      ontap: () {
                        ratingScore.value = 3;
                        ratingProgress.value = 2.50;
                        return null;
                      },
                    ),
                    ratingElement(
                      text: message
                              .rawMessage?.data?.payload?.emojiText?[3].title ??
                          '',
                      icon: FontAwesomeIcons.faceSmile,
                      activeColor: const Color(0xFF91CA61),
                      isActive: ratingScore.value > 3 && ratingScore.value <= 4,
                      ontap: () {
                        ratingScore.value = 4;
                        ratingProgress.value = 3.55;
                        return null;
                      },
                    ),
                    ratingElement(
                      text: message
                              .rawMessage?.data?.payload?.emojiText?[4].title ??
                          '',
                      icon: FontAwesomeIcons.faceGrin,
                      activeColor: const Color(0xFF3AB54B),
                      isActive: ratingScore.value > 4 && ratingScore.value <= 5,
                      ontap: () {
                        ratingScore.value = 5;
                        ratingProgress.value = 4.60;
                        return null;
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    if (ratingProgress.value >= 0.18 &&
                        ratingProgress.value < 1.0)
                      _animateTexts(size, chatbotMessage, ratingProgress)
                    else if (ratingProgress.value >= 1.01 &&
                        ratingProgress.value < 1.99)
                      _animateTexts(size, chatbotMessage, ratingProgress)
                    else if (ratingProgress.value >= 2.01 &&
                        ratingProgress.value < 2.99)
                      _animateTexts(size, chatbotMessage, ratingProgress)
                    else if (ratingProgress.value >= 3.10 &&
                        ratingProgress.value < 4)
                      _animateTexts(size, chatbotMessage, ratingProgress)
                    else if (ratingProgress.value >= 4.10 &&
                        ratingProgress.value < 5)
                      _animateTexts(size, chatbotMessage, ratingProgress)
                    else
                      SizedBox(
                        height: size.height / 11,
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ShowUpAnimation _animateTexts(Size size, MessageResponse chatbotMessage,
      ValueNotifier<double> ratingProgress) {
    return ShowUpAnimation(
      offset: 2,
      delayStart: const Duration(milliseconds: 200),
      animationDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutExpo,
      child: SizedBox(
        height: size.height / 11,
        child: AutoSizeText(
          chatbotMessage.rawMessage?.data?.payload
                  ?.emojiText?[ratingProgress.value.toInt()].value ??
              '',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  InkWell ratingElement({
    required Function? Function() ontap,
    bool isActive = false,
    required IconData icon,
    required Color activeColor,
    String text = 'Very\n',
  }) {
    text = text.replaceAll(" ", "\n");
    return InkWell(
      onTap: ontap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isActive ? 5 : 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: FaIcon(
              icon,
              color: isActive
                  ? activeColor
                  : const Color(0xff504642).withOpacity(.2),
              size: isActive ? 36 : 24,
            ),
          ),
          const SizedBox(
            height: 9,
          ),
          AutoSizeText(
            text,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: isActive ? 9 : 6,
            ),
          )
        ],
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
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ConversationRatingFeedbackScreen(
          endText: message.thank ??
              'Değerli görüşleriniz için teşekkür eder, sağlıklı ve mutlu günler dileriz.',
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _AnimatedCar extends StatelessWidget {
  _AnimatedCar({
    Key? key,
    required this.ratingProgress,
    required this.size,
  }) : super(key: key);
  ValueNotifier<double> ratingProgress;
  Size size;

  @override
  Widget build(BuildContext context) {
    final carRoad = ratingProgress.value.clamp(0, 1);
    final ratingProgressPercentage = ratingProgress.value / 5;
    final carWidth = size.width / 14;
    final carPositionX =
        ((size.width - 50) * ratingProgressPercentage) - carWidth;
    debugPrint(
      "car postion:$ratingProgressPercentage Car positionX:$carPositionX ",
    );
    return SizedBox(
      height: size.height / 12,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            height: size.height / 9,
            width: size.width / 4,
            left: carPositionX,
            child: Image.asset(
              "assets/images/car.png",
              package: 'etiya_chatbot_flutter',
              width: carWidth,
            ),
          ),
        ],
      ),
    );
  }
}
