import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_data/models/api/etiya_message_response.dart';
import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_data/models/etiya_carousel_item.dart';
import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_data/models/etiya_login_message_kind.dart';
import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_data/models/etiya_quick_reply.dart';
import 'package:flutter/material.dart';
import 'package:swifty_chat_data/swifty_chat_data.dart';
import 'package:uuid/uuid.dart';

extension CheckHTMLExist on String {
  bool get containsHTML {
    return contains(RegExp(r'<\/?[a-z][\s\S]*>'));
  }
}

class EtiyaChatMessage extends Message {
  final EtiyaChatUser chatUser;

  const EtiyaChatMessage({
    required this.chatUser,
    required String id,
    required bool isMe,
    required MessageKind messageKind,
  }) : super(
          user: chatUser,
          id: id,
          isMe: isMe,
          messageKind: messageKind,
        );
}

extension MessageMapper on MessageResponse {
  List<EtiyaChatMessage> mapToChatMessage() {
    final List<EtiyaChatMessage> messages = [];
    final msgId = id ?? const Uuid().v1();
    final EtiyaChatUser msgUser = user ?? EtiyaChatUser();
    switch (type) {
      case 'login':
        messages.add(
          EtiyaChatMessage(
            id: msgId,
            isMe: false,
            chatUser: msgUser,
            messageKind: MessageKind.custom(
              EtiyaLoginMessageKind(title: text ?? 'Login'),
            ),
          ),
        );
        break;
      case 'text':
        if (hasQuickReply) {
          final quickReplies = rawMessage?.data?.payload?.quickReplies ?? [];
          final List<EtiyaQuickReplyItem> items = quickReplies
              .map(
                (qr) => EtiyaQuickReplyItem(
                  title: qr.title ?? "",
                  payload: qr.payload ?? "unknown_payload",
                ),
              )
              .toList();
          if (text != null) {
            MessageKind kind = MessageKind.text(text);
            if (text!.containsHTML) {
              kind = MessageKind.html(text);
            }
            messages.add(
              EtiyaChatMessage(
                id: msgId,
                isMe: false,
                chatUser: msgUser,
                messageKind: kind,
              ),
            );
          }
          messages.add(
            EtiyaChatMessage(
              id: msgId,
              isMe: false,
              chatUser: msgUser,
              messageKind: MessageKind.quickReply(items),
            ),
          );
        } else {
          if (text != null) {
            MessageKind kind = MessageKind.text(text);
            if (text!.containsHTML) {
              kind = MessageKind.html(text);
            }
            messages.add(
              EtiyaChatMessage(
                id: msgId,
                isMe: false,
                chatUser: msgUser,
                messageKind: kind,
              ),
            );
          }
        }
        break;
      case 'carousel':
        final items = rawMessage?.data?.payload?.elements ?? [];
        if (items.isEmpty) {
          break;
        }

        final List<EtiyaCarouselItem> _carouselItems = items.map((e) {
          final title = e.title ?? '';
          final subtitle = e.subtitle ?? '';
          final url = e.picture;
          final buttons = e.buttons ?? [];

          final List<CarouselButtonItem> carouselButtons = buttons.map((btn) {
            return CarouselButtonItem(
              title: btn.title ?? '',
              url: btn.url,
              payload: btn.payload,
            );
          }).toList();

          return EtiyaCarouselItem(
            title: title,
            subtitle: subtitle,
            imageProvider: NetworkImage(url ?? ""),
            buttons: carouselButtons,
          );
        }).toList();

        messages.add(
          EtiyaChatMessage(
            chatUser: msgUser,
            id: msgId,
            isMe: false,
            messageKind: MessageKind.carousel(_carouselItems),
          ),
        );
        break;

      case 'file':
        if (hasImage) {
          final String? url = rawMessage?.data?.payload?.url;
          if (url == null) break;
          messages.add(
            EtiyaChatMessage(
              id: msgId,
              isMe: false,
              chatUser: msgUser,
              messageKind: MessageKind.imageProvider(
                NetworkImage(url),
              ),
            ),
          );
        }
        break;
    }

    return messages.reversed.toList();
  }
}
