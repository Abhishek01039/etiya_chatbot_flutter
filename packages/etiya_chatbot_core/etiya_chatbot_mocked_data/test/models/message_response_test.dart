import 'dart:convert';
import 'dart:io';

import 'package:etiya_chatbot_data/etiya_chatbot_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Message Kinds', () {
    test('text message pojo mapping', () async {
      final textMessageResponseJson =
          File('test/mock/data/text_message_response.json');
      final MessageResponse messageResponse = MessageResponse.fromJson(
        jsonDecode(
          await textMessageResponseJson.readAsString(),
        ) as Map<String, dynamic>,
      );
      expect(messageResponse.text, "Size yardımcı olabileceğim başka bir konu var mı?");
    });

    test('quick reply message pojo mapping', () async {
      final quickReplyMessageResponseJson =
      File('test/mock/data/quick_reply_message_response.json');
      final MessageResponse messageResponse = MessageResponse.fromJson(
        jsonDecode(
          await quickReplyMessageResponseJson.readAsString(),
        ) as Map<String, dynamic>,
      );
      expect(messageResponse.hasQuickReply, true);
      expect(messageResponse.rawMessage?.data?.payload?.quickReplies?.length, 3);
    });

    test('carousel message pojo mapping', () async {
      final carouselMessageResponseJson =
      File('test/mock/data/carousel_message_response.json');
      final MessageResponse messageResponse = MessageResponse.fromJson(
        jsonDecode(
          await carouselMessageResponseJson.readAsString(),
        ) as Map<String, dynamic>,
      );
      expect(messageResponse.hasQuickReply, false);
      expect(messageResponse.rawMessage?.data?.payload?.elements?.length, 3);
      expect(messageResponse.rawMessage?.data?.payload?.elements?.first.buttons?.first == null, false);
    });

    test('carousel message pojo mapping', () async {
      final carouselMessageResponseJson =
      File('test/mock/data/feedback_message_response.json');
      final MessageResponse messageResponse = MessageResponse.fromJson(
        jsonDecode(
          await carouselMessageResponseJson.readAsString(),
        ) as Map<String, dynamic>,
      );
      expect(messageResponse.rawMessage?.data?.payload?.thank?.isEmpty, false);
      expect(messageResponse.rawMessage?.data?.payload?.title?.isEmpty, false);
    });
  });
}
