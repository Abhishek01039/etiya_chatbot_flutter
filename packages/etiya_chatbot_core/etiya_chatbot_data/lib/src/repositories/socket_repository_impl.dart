
import 'package:togg_mobile_super_app_sdk/togg_mobile_super_app_sdk.dart' hide Handler;
import 'package:etiya_chatbot_domain/etiya_chatbot_domain.dart';

class SocketClientRepositoryImpl extends SocketClientRepository {
  late ITOGGSocketClient _socket;

  SocketClientRepositoryImpl({
    required String url,
    String namespace = '/',
    Map query = const {},
  }) : super(
          url: url,
          namespace: namespace,
          query: query,
        ) {
    _socket = TOGGMobileSdk.shared.getTOGGSocketClient(
      url: url,
      namespace: namespace,
      query: query,
      enableLogs: true,
    );
  }

  @override
  void dispose() => _socket.dispose();

  @override
  void connect() => _socket.connect();

  @override
  void onConnect(Handler handler) => _socket.onConnect(handler);

  @override
  void onEvent(Map<String, Handler> eventHandler) => _socket.onEvent(eventHandler);

  @override
  void onError(Handler? onError) => _socket.onError(onError);

  @override
  void emit(String event, [dynamic data]) => _socket.emit(event, data);
}
