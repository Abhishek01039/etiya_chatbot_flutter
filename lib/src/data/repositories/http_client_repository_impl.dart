import 'dart:convert';

import 'package:etiya_chatbot_flutter/src/data/models/models.dart';
import 'package:etiya_chatbot_flutter/src/domain/http_client_repository.dart';
import 'package:etiya_chatbot_flutter/src/util/logger.dart';
import 'package:http/http.dart' as http;

class HttpClientRepositoryImpl extends HttpClientRepository {
  HttpClientRepositoryImpl({
    required String serviceUrl,
    required String authUrl,
    required String userId,
  }) : super(serviceUrl: serviceUrl, authUrl: authUrl, userId: userId);

  @override
  Future<bool> auth({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse(authUrl);
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "username": username,
          "password": password,
          "chatId": "mobile:$userId"
        }),
      );
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        Log.info(response.body);
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final isAuth = json["isAuth"] as bool? ?? false;
        Log.info("isAuthenticated: $isAuth");
        return isAuth;
      } else {
        Log.error(
          "User's message could not sent, statusCode: ${response.statusCode}",
        );
        return false;
      }
    } catch (error) {
      Log.error(error.toString());
      return false;
    }
  }

  @override
  Future<void> sendMessage(MessageRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$serviceUrl/mobile'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        Log.info("User's message sent successfully");
      } else {
        Log.error(
          "User's message could not sent, statusCode: ${response.statusCode}",
        );
      }
    } catch (error) {
      Log.error(error.toString());
    }
  }
}
