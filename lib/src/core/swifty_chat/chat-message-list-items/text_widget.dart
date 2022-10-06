import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:swifty_chat_data/swifty_chat_data.dart';

import '../extensions/theme_context.dart';
import '../protocols/has_avatar.dart';
import '../protocols/incoming_outgoing_message_widgets.dart';

class TextMessageWidget extends StatelessWidget
    with HasAvatar, IncomingOutgoingMessageWidgets {
  final Message _chatMessage;

  const TextMessageWidget(this._chatMessage);

  @override
  Widget incomingMessageWidget(BuildContext context) => Row(
        crossAxisAlignment: avatarPosition.alignment,
        children: [
          ...avatarWithPadding(),
          TextContainer(
            context,
            chatMessage: message,
          ),
          const SizedBox(width: 24)
        ],
      );

  @override
  Widget outgoingMessageWidget(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: avatarPosition.alignment,
        children: [
          const SizedBox(width: 24),
          TextContainer(
            context,
            chatMessage: message,
          ),
          ...avatarWithPadding(),
        ],
      );

  @override
  Widget build(BuildContext context) => message.isMe
      ? outgoingMessageWidget(context)
      : incomingMessageWidget(context);

  @override
  Message get message => _chatMessage;
}

class TextContainer extends HookWidget {
  final Message chatMessage;
  final BuildContext context;
  const TextContainer(
    this.context, {
    required this.chatMessage,
  });
  @override
  Widget build(BuildContext context) {
    final _theme = context.theme;
    final _messageBorderRadius = _theme.messageBorderRadius;
    final _borderRadius = BorderRadius.only(
      bottomLeft: Radius.circular(message.isMe ? _messageBorderRadius : 0),
      bottomRight: Radius.circular(message.isMe ? 0 : _messageBorderRadius),
      topLeft: Radius.circular(_messageBorderRadius),
      topRight: Radius.circular(_messageBorderRadius),
    );
    final expand = useState<bool>(
      (message.messageKind.text?.length ?? 0) <= (_theme.maxMessageLength ?? 0),
    );

    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: _borderRadius,
        color: message.isMe ? _theme.primaryColor : _theme.secondaryColor,
      ),
      child: ClipRRect(
        borderRadius: _borderRadius,
        child: AbsorbPointer(
          absorbing: expand.value,
          child: InkWell(
            onTap: () => expand.value = true,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: expand.value
                        ? message.messageKind.text ?? ''
                        : message.messageKind.text?.substring(
                              0,
                              (message.messageKind.text?.length ?? 0) >
                                      int.parse(
                                        _theme.maxMessageLength.toString(),
                                      )
                                  ? _theme.maxMessageLength
                                  : message.messageKind.text?.length,
                            ) ??
                            '',
                  ),
                  if (!expand.value) ...[
                    const TextSpan(
                      text: "Read More",
                      style: TextStyle(color: Colors.green),
                    )
                  ]
                ],
                style: message.isMe
                    ? _theme.outgoingMessageBodyTextStyle
                    : _theme.incomingMessageBodyTextStyle,
              ),
            ).padding(all: _theme.textMessagePadding),
          ),
        ),
      ),
    ).flexible();
  }

  @override
  Message get message => chatMessage;
}
