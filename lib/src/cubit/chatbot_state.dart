part of 'chatbot_cubit.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState({
    this.messages = const [],
  });

  final List<Message> messages;

  @override
  List<Object?> get props => [messages];
}

class ChatbotMessages extends ChatbotState {
  const ChatbotMessages({
    List<Message> messages = const [],
  }) : super(messages: messages);
}

class ChatbotUserAuthenticated extends ChatbotState {
  // ignore: avoid_positional_boolean_parameters
  const ChatbotUserAuthenticated(this.isAuthenticated);

  final bool isAuthenticated;

  @override
  List<Object?> get props => [messages, isAuthenticated];
}

class ChatbotSessionEnded extends ChatbotState {
  const ChatbotSessionEnded(
    List<Message> messages,
    this.message,
  ) : super(messages: messages);

  final MessageResponse message;

  @override
  List<Object?> get props => [messages, message];
}
