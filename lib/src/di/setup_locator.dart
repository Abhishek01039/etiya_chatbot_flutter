import 'package:etiya_chatbot_data/etiya_chatbot_data.dart';
import 'package:etiya_chatbot_domain/etiya_chatbot_domain.dart';
import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DependencyInjection {
  const DependencyInjection._();

  static Future<List<RepositoryProvider>> build(
    EtiyaChatbotBuilder builder,
  ) async {
    final deviceIdRepository = DeviceIdRepositoryImpl();
    final deviceId = await deviceIdRepository.fetchDeviceId();

    final String visitorId = '${builder.userName}_$deviceId';
    final socketRepository = SocketRepositoryImpl(
      url: builder.socketUrl,
      namespace: '/chat',
      query: { 'visitorId': visitorId },
    );

    final httpClient = HttpClientRepositoryImpl(
      serviceUrl: builder.serviceUrl,
      authUrl: builder.authUrl!,
      userId: deviceId,
    );

    return [
      RepositoryProvider<SocketClientRepository>(
        create: (_) => socketRepository,
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
