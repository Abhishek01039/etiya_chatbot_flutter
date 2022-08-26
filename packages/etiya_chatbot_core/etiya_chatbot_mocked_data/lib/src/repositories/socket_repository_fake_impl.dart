import 'dart:convert';
import 'dart:io';

import 'package:etiya_chatbot_data/etiya_chatbot_data.dart';
import 'package:etiya_chatbot_domain/etiya_chatbot_domain.dart';

class FakeSocketClientRepository extends SocketClientRepository {
  FakeSocketClientRepository() : super(url: '');

  @override
  void dispose() {}

  Future<void> simulateTextMessageReceiveEvent(String text) async {
    final textMessageResponseJson =
        File('test/mock/data/text_message_response.json');
    final MessageResponse messageResponse = MessageResponse.fromJson(
      jsonDecode(
        await textMessageResponseJson.readAsString(),
      ) as Map<String, dynamic>,
    );
    messageResponse.text = text;
    onEvent({
      'newMessage': (json) => jsonEncode(messageResponse.toJson())
    });
  }

  @override
  void connect() {}

  @override
  void emit(String event, [dynamic data]) {}

  @override
  void onConnect(Handler handler) {}

  @override
  void onError(Handler? onError) {}

  @override
  void onEvent(Map<String, Handler> eventHandler) {}
}
