import 'package:etiya_chatbot_data/etiya_chatbot_data.dart';
import 'package:etiya_chatbot_flutter/src/cubit/chatbot_cubit.dart';
import 'package:etiya_chatbot_flutter/src/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swifty_chat/swifty_chat.dart';

class ConversationFeedback extends StatefulWidget {
  const ConversationFeedback(
    this.message, {
    Key? key,
    required this.theme,
  }) : super(key: key);

  final MessageResponse message;
  final ChatTheme theme;

  @override
  State<StatefulWidget> createState() => ConversationFeedbackState();
}

class ConversationFeedbackState extends State<ConversationFeedback>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  double progress = 0;

  TextEditingController feedbackTextController = TextEditingController();
  double ratingScore = 3;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutBack);

    controller
      ..addListener(() {
        setState(() {});
      })
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 44,
                    color: widget.theme.primaryColor,
                    child: Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  _ConversationFeedbackTitle(
                    title:
                        widget.message.rawMessage?.data?.payload?.title ?? '',
                    textStyle:
                        widget.theme.incomingMessageBodyTextStyle.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RatingBar.builder(
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    initialRating: 3,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return const FaIcon(
                            FontAwesomeIcons.faceSadCry,
                            color: Color(0xFFE12125),
                          );
                        case 1:
                          return const FaIcon(
                            FontAwesomeIcons.faceSadTear,
                            color: Color(0xFFF25A29),
                          );
                        case 2:
                          return const FaIcon(
                            FontAwesomeIcons.faceMeh,
                            color: Color(0xFFFCB040),
                          );
                        case 3:
                          return const FaIcon(
                            FontAwesomeIcons.faceSmileBeam,
                            color: Color(0xFF91CA61),
                          );
                        case 4:
                          return const FaIcon(
                            FontAwesomeIcons.faceGrinStars,
                            color: Color(0xFF3AB54B),
                          );
                        default:
                          return const FaIcon(FontAwesomeIcons.faceSadTear);
                      }
                    },
                    onRatingUpdate: (double value) {
                      Log.info('onRatingUpdate = $value');
                      ratingScore = value;
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Material(
                      elevation: 4,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xffB81E12),
                              width: 2,
                            ),
                          ),
                        ),
                        controller: feedbackTextController,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 7,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      context.read<ChatbotCubit>().userSubmittedFeedbackMessage(
                            ratingScore: ratingScore,
                            feedback: feedbackTextController.text,
                            sessionId:
                                int.tryParse(widget.message.sessionId ?? '') ??
                                    0,
                          );
                      Navigator.of(context).pop();
                    },
                    style: widget.theme.carouselButtonStyle,
                    child: const Text('Submit'),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConversationFeedbackTitle extends StatelessWidget {
  const _ConversationFeedbackTitle({
    Key? key,
    required this.title,
    required this.textStyle,
  }) : super(key: key);

  final String title;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
