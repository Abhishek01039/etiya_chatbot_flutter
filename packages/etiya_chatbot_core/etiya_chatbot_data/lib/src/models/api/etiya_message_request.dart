import 'package:etiya_chatbot_domain/etiya_chatbot_domain.dart';

class MessageUser {
  MessageUser({
    required this.senderId,
    this.firstName,
    this.lastName,
    this.language,
  });

  /// Togg Id
  final String senderId;
  final String? firstName;
  final String? lastName;
  final String? language;

  Map<String, dynamic> toJson() => {
        "userId": senderId,
        "first_name": firstName,
        "last_name": lastName,
        "language": language,
      };
}

class MessageRequest {
  MessageRequest({
    this.type = "text",
    required this.text,
    required this.user,
    this.data,
    this.accessToken,
  });

  final String type;
  final String text;
  final MessageUser user;
  final String? accessToken;
  final MessageData? data;

  Map<String, dynamic> toJson() => {
        "type": type,
        "text": text,
        "user": user.toJson(),
        "data": data?.toJson(),
        "extras": {"access_token": accessToken},
      };
}
