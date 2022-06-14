import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etiya_chatbot_data/etiya_chatbot_data.dart';
import 'package:etiya_chatbot_domain/etiya_chatbot_domain.dart';
import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:etiya_chatbot_flutter/src/util/logger.dart';
import 'package:uuid/uuid.dart';

part 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  final SocketClientRepository socketRepository;
  final HttpClientRepository httpClientRepository;
  final EtiyaChatbotBuilder chatbotBuilder;

  String get messageInputHintText =>
      chatbotBuilder.messageInputHintText ?? "Aa";

  String get visitorId =>
      socketRepository.query['visitorId'] as String? ?? 'Unknown visitor id';

  /// Customer User
  EtiyaChatUser get _customerUser {
    final user = EtiyaChatUser(fullName: chatbotBuilder.userName);
    user.avatar = chatbotBuilder.outgoingAvatar;
    return user;
  }

  ChatbotCubit({
    required this.chatbotBuilder,
    required this.socketRepository,
    required this.httpClientRepository,
  }) : super(const ChatbotMessages()) {
    socketRepository
      ..onEvent({
        'newMessage': (json) {
          final messageResponse =
              MessageResponse.fromJson(json as Map<String, dynamic>);
          Log.info('socketRepository.onNewMessageReceived');
          messageResponse.user?.fullName = chatbotBuilder.userName;
          messageResponse.user?.avatar = chatbotBuilder.incomingAvatar;
          Log.info(messageResponse.toJson().toString());
          if (messageResponse.type == 'feedback') {
            emit(ChatbotSessionEnded(state.messages, messageResponse));
          } else {
            _insertNewMessages(messageResponse.mapToChatMessage());
          }
        }
      })
      ..onError((handler) => Log.error(handler as String? ?? 'Error'))
      ..onConnect((handler) async {
        Log.info('socketRepository.onSocketConnected (visitorId=$visitorId)');
        await userVisitMessage();
      })
      ..connect();
  }

  Future<void> userVisitMessage() async {
    await httpClientRepository.sendMessage(
      text: '/user_visit',
      senderId: visitorId,
    );
  }

  Future<void> closeSessionMessage() async {
    await httpClientRepository.sendMessage(
      text: '/close-session',
      senderId: visitorId,
    );
    Log.info('Chat Session is closed');
  }

  void _insertNewMessages(List<Message> messages) {
    final updatedMessages = [...state.messages];
    updatedMessages.insertAll(0, messages);
    emit(
      ChatbotMessages(messages: updatedMessages),
    );
  }

  /// Triggered when user fills message input field.
  Future<void> userAddedMessage(String messageText) async {
    await httpClientRepository.sendMessage(
      text: messageText,
      senderId: visitorId,
    );
    _insertNewMessages(
      [
        EtiyaChatMessage(
          isMe: true,
          id: const Uuid().v1(),
          messageKind: MessageKind.text(messageText),
          chatUser: _customerUser,
        ),
      ],
    );
  }

  /// Triggered when user taps quick reply button
  void userAddedQuickReplyMessage(QuickReplyItem item) {
    httpClientRepository.sendMessage(
      text: item.payload ?? "payload",
      senderId: visitorId,
      type: 'quick_reply',
      quickReplyTitle: item.title,
      quickReplyPayload: item.payload,
    );
    _insertNewMessages([
      EtiyaChatMessage(
        isMe: true,
        id: const Uuid().v1(),
        messageKind: MessageKind.text(item.title),
        chatUser: _customerUser,
      )
    ]);
  }

  /// Triggered when user taps carousel button
  void userAddedCarouselMessage(CarouselButtonItem item) {
    httpClientRepository.sendMessage(
      text: item.payload!,
      senderId: visitorId,
    );
    _insertNewMessages([
      EtiyaChatMessage(
        isMe: true,
        id: const Uuid().v1(),
        messageKind: MessageKind.text(item.title),
        chatUser: _customerUser,
      )
    ]);
  }

  Future<void> authenticate({
    required String username,
    required String password,
  }) async {
    final isAuthenticated =
        await httpClientRepository.auth(username: username, password: password);
    emit(ChatbotUserAuthenticated(isAuthenticated));
    _insertNewMessages([
      EtiyaChatMessage(
        isMe: false,
        id: const Uuid().v1(),
        messageKind: MessageKind.text(
          isAuthenticated ? "Giriş Başarılı" : "Giriş Başarısız",
        ),
        chatUser: _customerUser,
      )
    ]);
  }

  @override
  Future<void> close() async {
    socketRepository.dispose();
    await closeSessionMessage();
    return super.close();
  }
}
