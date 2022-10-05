import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_data/repositories/http_client_repository_impl.dart';
import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_data/repositories/socket_repository_impl.dart';
import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_domain/repositories/http_client_repository.dart';
import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_domain/repositories/socket_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:togg_mobile_super_app_sdk/togg_mobile_super_app_sdk.dart';
import '../core/swifty_chat/swifty_chat.dart';
class DependencyInjection {
  const DependencyInjection._();

  static List<RepositoryProvider> build(
    EtiyaChatbotBuilder builder,
  ) {
    builder.visitorId = TOGGMobileSdk.shared.getTOGGUser().userId;

    final socketClientRepository = SocketClientRepositoryImpl(
      url: builder.socketUrl,
      namespace: '/chat',
      query: {'visitorId': builder.visitorId},
    );

    final deviceId = TOGGMobileSdk.shared.getTOGGUser().userId;
    final httpClient = HttpClientRepositoryImpl(
      serviceUrl: builder.serviceUrl,
      authUrl: builder.authUrl,
      userId: deviceId,
      accessToken: builder.accessToken,
    );

    return [
      RepositoryProvider<EtiyaChatbotBuilder>(
        create: (_) => builder,
      ),
      RepositoryProvider<SocketClientRepository>(
        create: (_) => socketClientRepository,
      ),
      RepositoryProvider<HttpClientRepository>(
        create: (_) => httpClient,
      ),
      RepositoryProvider<ChatTheme>(
        create: (_) => builder.chatTheme,
      ),
    ];
  }
}
