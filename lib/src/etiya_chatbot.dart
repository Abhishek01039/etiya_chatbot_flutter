import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_domain/repositories/http_client_repository.dart';
import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_domain/repositories/socket_repository.dart';
import 'package:etiya_chatbot_flutter/src/cubit/chatbot_cubit.dart';
import 'package:etiya_chatbot_flutter/src/di/setup_locator.dart';
import 'package:etiya_chatbot_flutter/src/ui/etiya_chat_widget.dart';
import 'package:etiya_chatbot_flutter/src/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:etiya_chatbot_flutter/src/core/swifty_chat/swifty_chat.dart';
class EtiyaChatbot {
  final EtiyaChatbotBuilder builder;

  const EtiyaChatbot({
    required this.builder,
  });

  Widget getChatWidget() => MultiRepositoryProvider(
        providers: DependencyInjection.build(builder),
        child: BlocProvider(
          create: (context) => ChatbotCubit(
            chatbotBuilder: context.read<EtiyaChatbotBuilder>(),
            socketRepository: context.read<SocketClientRepository>(),
            httpClientRepository: context.read<HttpClientRepository>(),
          ),
          child: const EtiyaChatWidget(),
        ),
      );
}

class EtiyaChatbotBuilder {
  /// The connection URL for messages to be sent.
  String serviceUrl;

  /// The connection URL for socket.
  String socketUrl;

  /// Behaves like unique id to distinguish chat room for backend.
  String userName;

  /// Jwt token
  String? accessToken;

  String? visitorId;
  String? authUrl;
  String? messageInputHintText;
  UserAvatar? outgoingAvatar;
  UserAvatar? incomingAvatar;
  ChatTheme chatTheme = const DefaultChatTheme();

  EtiyaChatbotBuilder({
    required this.serviceUrl,
    required this.socketUrl,
    required this.userName,
  }) {
    setLoggingEnabled();
  }

  /// The jwt access token.
  EtiyaChatbotBuilder setAccessToken(String jwt) {
    accessToken = jwt;
    return this;
  }

  /// The connection URL for ldap authorization.
  EtiyaChatbotBuilder setAuthUrl(String url) {
    authUrl = url;
    return this;
  }

  /// The hint text displayed on message input field.
  EtiyaChatbotBuilder setMessageInputHintText(String text) {
    messageInputHintText = text;
    return this;
  }

  /// Avatar configuration for incoming messages.
  EtiyaChatbotBuilder setIncomingAvatar(UserAvatar avatar) {
    incomingAvatar = avatar;
    return this;
  }

  /// Avatar configuration for outgoing messages.
  EtiyaChatbotBuilder setOutgoingAvatar(UserAvatar avatar) {
    outgoingAvatar = avatar;
    return this;
  }

  /// Chat theme for styling the Chat widget and inner elements.
  EtiyaChatbotBuilder setChatTheme(ChatTheme theme) {
    chatTheme = theme;
    return this;
  }

  /// Configuration for logging internal events, disabled by default.
  // ignore: avoid_positional_boolean_parameters
  EtiyaChatbotBuilder setLoggingEnabled([bool enabled = false]) {
    Log.isEnabled = enabled;
    return this;
  }

  EtiyaChatbot build() => EtiyaChatbot(builder: this);
}
