import 'package:etiya_chatbot_data/etiya_chatbot_data.dart';
import 'package:etiya_chatbot_domain/etiya_chatbot_domain.dart';
import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:togg_mobile_super_app_sdk/togg_mobile_super_app_sdk.dart';

class DependencyInjection {
  const DependencyInjection._();

  static List<RepositoryProvider> build(
    EtiyaChatbotBuilder builder,
  ) {
    builder.visitorId = TOGGMobileSdk().getTOGGUser().userId;

    final socketClientRepository = SocketClientRepositoryImpl(
      url: builder.socketUrl,
      namespace: '/chat',
      query: {'visitorId': builder.visitorId},
    );

    final deviceId = TOGGMobileSdk().getTOGGUser().userId;
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
