import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class EtiyaMessageInput extends StatelessWidget {
  EtiyaMessageInput({
    Key? key,
    this.focusNode,
    required this.sendButtonTapped,
    this.hintText = "Aa",
  }) : super(key: key);

  final textEditingController = TextEditingController();
  final FocusNode? focusNode;
  final Function(String) sendButtonTapped;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: Offset(2, -2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              key: ChatKeys.messageTextField.key,
              controller: textEditingController,
              focusNode: focusNode,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration.collapsed(
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 16.0,
                  color: Color(0xffAEA4A3),
                ),
              ),
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) {
                if (textEditingController.text != "") {
                  sendButtonTapped(textEditingController.text);
                  textEditingController.text = "";
                }
              },
            ),
          ),
          Container(
            key: ChatKeys.messageSendButton.key,
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blueAccent,
            ),
            child: const Icon(
              Icons.send_outlined,
              color: Colors.white70,
            ),
          ).rotate(angle: 150).gestures(
            onTap: () {
              sendButtonTapped(textEditingController.text);
              textEditingController.text = "";
            },
          )
        ],
      ),
    );
  }
}
