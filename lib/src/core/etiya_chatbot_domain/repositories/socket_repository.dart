typedef Handler = dynamic Function(dynamic handler);

abstract class SocketClientRepository {
  SocketClientRepository({
    required this.url,
    this.namespace = '/',
    this.query = const {},
  });

  final String url;
  final String namespace;
  final Map query;

  void emit(String event, [dynamic data]);

  void onError(Handler? onError);

  void onEvent(Map<String, Handler> eventHandler);

  void onConnect(Handler handler);

  void dispose();

  void connect();
}
