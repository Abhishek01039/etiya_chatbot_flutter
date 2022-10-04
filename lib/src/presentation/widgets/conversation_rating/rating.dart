import 'package:auto_size_text/auto_size_text.dart';
import 'package:etiya_chatbot_data/src/models/api/etiya_message_response.dart';
import 'package:flutter/material.dart';
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
      horizontal: 24.0,
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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
            width: 20,
            height: 120,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
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
              ratingProgress.value =
                  1 + index.toDouble() - (index >= 2 ? .3 : .1);
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
            size: isActive ? 28 : 20,
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
