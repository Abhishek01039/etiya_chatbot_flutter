import 'package:flutter/material.dart';
import 'package:swifty_chat/swifty_chat.dart';

import '../etiya_chatbot_flutter.dart';
import 'chat_view_model.dart';
import 'models/api/etiya_message_request.dart';
import 'models/api/etiya_message_response.dart';
import 'models/etiya_chat_message.dart';
import 'util/logger.dart';

class EtiyaChatWidget extends StatefulWidget {
  final ChatViewModel viewModel;

  EtiyaChatWidget({required this.viewModel});

  @override
  _EtiyaChatWidgetState createState() => _EtiyaChatWidgetState();
}

class _EtiyaChatWidgetState extends State<EtiyaChatWidget> {
  final List<EtiyaChatMessage> _messages = [];
  late Chat _chatView;

  @override
  void initState() {
    widget.viewModel.onNewMessage = (messages) {
      setState(() {
        _messages.insertAll(0, messages);
      });
      _chatView.scrollToBottom();
    };
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _chatView = Chat(
      messages: _messages,
      theme: DefaultChatTheme(),
      messageCellSizeConfigurator:
      MessageCellSizeConfigurator.defaultConfiguration,
      chatMessageInputField: MessageInputField(
        sendButtonTapped: sendButtonPressedAction,
      ),
    )
    .setOnQuickReplyItemPressed(quickReplyPressedAction);
    return _chatView;
  }

  void sendButtonPressedAction(String text) {
    widget.viewModel.sendMessage(
      MessageRequest(
        text: text,
        user: MessageUser(senderId: widget.viewModel.userId),
        type: "text",
      ),
    );
    setState(() {
      _messages.insert(0, EtiyaChatMessage(
          isMe: true,
          id: DateTime.now().toString(),
          messageKind: MessageKind.text(text),
          chatUser: widget.viewModel.customerUser));
    });
    Log.info(text);
    _chatView.scrollToBottom();
  }

  void quickReplyPressedAction(QuickReplyItem item) {
    widget.viewModel.sendMessage(
      MessageRequest(
        text: item.payload ?? "payload",
        user: MessageUser(senderId: widget.viewModel.userId),
        type: "quick_reply",
        data: QuickReply(
          title: item.title,
          payload: item.payload ?? "payload",
        ),
      ),
    );
    setState(() {
      _messages.insert(0, EtiyaChatMessage(
          isMe: true,
          id: DateTime.now().toString(),
          messageKind: MessageKind.text(item.title),
          chatUser: widget.viewModel.customerUser));
    });
    Log.info(item.payload);
    _chatView.scrollToBottom();
  }
}
