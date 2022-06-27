import 'package:etiya_chatbot_domain/etiya_chatbot_domain.dart';

class FakeHttpClientRepository extends HttpClientRepository {
  FakeHttpClientRepository({
    required String serviceUrl,
    required String? authUrl,
    required String userId,
    required String accessToken,
  }) : super(
          serviceUrl: serviceUrl,
          authUrl: authUrl,
          userId: userId,
          accessToken: accessToken,
        );

  @override
  Future<bool> auth({
    required String username,
    required String password,
  }) =>
      Future.value(
        username == 'username' && password == 'password',
      );

  @override
  Future<void> sendMessage({
    MessageData? data,
    String type = 'text',
    required String text,
    required String senderId,
    String? quickReplyTitle,
    String? quickReplyPayload,
  }) =>
      Future.delayed(const Duration(milliseconds: 700));
}
