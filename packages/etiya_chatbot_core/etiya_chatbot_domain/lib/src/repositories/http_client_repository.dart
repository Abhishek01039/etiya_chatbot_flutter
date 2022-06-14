import 'package:etiya_chatbot_domain/etiya_chatbot_domain.dart';

abstract class HttpClientRepository {
  final String serviceUrl;
  final String? authUrl;
  final String userId;
  final String? accessToken;

  HttpClientRepository({
    required this.serviceUrl,
    required this.authUrl,
    required this.userId,
    this.accessToken,
  });

  /// LDAP Auth
  /// - Parameter username: User Name
  /// - Parameter password: User Password
  /// Returns authentication status.
  Future<bool> auth({
    required String username,
    required String password,
  });

  /// Send Message to Server
  Future<void> sendMessage({
    String type = 'text',
    required String text,
    required String senderId,
    MessageData? data,
  });
}
