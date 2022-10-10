import 'package:auto_size_text/auto_size_text.dart';
import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_data/models/api/etiya_message_response.dart';
import 'package:flutter/material.dart';
import 'package:etiya_chatbot_flutter/src/extensions/context_extension.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Color> rateColors = [
  const Color(0xFFE12125),
  const Color(0xFFF25A29),
  const Color(0xFFFCB040),
  const Color(0xFF91CA61),
  const Color(0xFF3AB54B),
];
List<IconData> rateIcons = [
  FontAwesomeIcons.faceFrownOpen,
  FontAwesomeIcons.faceFrown,
  FontAwesomeIcons.faceMeh,
  FontAwesomeIcons.faceSmile,
  FontAwesomeIcons.faceGrin,
];

Widget ToggRating(
  ValueNotifier<double> ratingScore,
  ValueNotifier<double> ratingProgress,
  ValueNotifier<double> textIndex,
  ValueNotifier<double> opacityController,
  ValueNotifier<bool> changeFinished,
  MessageResponse chatbotMessage,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 18.0,
    ),
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
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount:
              chatbotMessage.rawMessage?.data?.payload?.emojiText?.length ?? 5,
          itemBuilder: (context, index) => ratingElement(
            text: chatbotMessage
                    .rawMessage?.data?.payload?.emojiText?[index].title ??
                '',
            activeColor: rateColors[index],
            icon: rateIcons[index],
            isActive: index == ratingScore.value,
            ontap: () {
              Future.delayed(
                const Duration(
                  milliseconds: 500,
                ),
                () {
                  changeFinished.value = true;
                },
              ).then((value) => changeFinished.value = false);

              ratingScore.value = index.toDouble();
              ratingProgress.value = ratingRatio(index + 1);
              return null;
            },
          ),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(isActive ? 5 : 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: FaIcon(
            icon,
            color: isActive
                ? activeColor
                : const Color(0xff504642).withOpacity(.2),
            size: isActive ? 26 : 18,
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        AutoSizeText(
          text,
          maxLines: 3,
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

double ratingRatio(int score) {
  switch (score) {
    case 1:
      return 0.50;
    case 2:
      return 1.50;
    case 3:
      return 2.50;
    case 4:
      return 3.50;
    case 5:
      return 4.50;
    default:
      return score * 1;
  }
}