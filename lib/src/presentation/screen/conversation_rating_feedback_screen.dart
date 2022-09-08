import 'package:etiya_chatbot_flutter/src/presentation/widgets/background_gradient.dart';
import 'package:flutter/material.dart';
import 'package:show_up_animation/show_up_animation.dart';

class ConversationRatingFeedbackScreen extends StatelessWidget {
  const ConversationRatingFeedbackScreen({Key? key, required this.endText})
      : super(key: key);

  final String endText;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: _conversationRatingFeedbackScreen(
        context,
        size,
      ),
    );
  }

  Widget _conversationFeedbackBody(
      BuildContext context, List<Widget> widgets, Size size) {
    return Stack(
      children: [
        ...screenGradientElements,
        SingleChildScrollView(
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

  Widget _conversationRatingFeedbackScreen(BuildContext context, Size size) {
    return _conversationFeedbackBody(
      context,
      [
        SizedBox(
          height: size.height / 25,
        ),
        _backButton(context, size),
        _toggLogo(size),
        SizedBox(height: size.height / 70),
        _toggTitle(size),
      ],
      size,
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
            Navigator.of(context).pop;
            Navigator.of(context).pop;
            Navigator.of(context).pop;
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

  Padding _toggTitle(Size size) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ShowUpAnimation(
        delayStart: const Duration(seconds: 1),
        animationDuration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        child: Text(endText),
      ),
    );
  }
}
