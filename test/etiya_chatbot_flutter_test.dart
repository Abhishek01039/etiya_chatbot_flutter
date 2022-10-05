import 'package:bloc_test/bloc_test.dart';
import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_data/models/api/etiya_message_request.dart';
import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_data/models/etiya_quick_reply.dart';
import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_domain/repositories/http_client_repository.dart';
import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_domain/repositories/socket_repository.dart';
import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_mocked_data/repositories/http_client_repository_fake_impl.dart';
import 'package:etiya_chatbot_flutter/src/core/etiya_chatbot_mocked_data/repositories/socket_repository_fake_impl.dart';
import 'package:etiya_chatbot_flutter/src/cubit/chatbot_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockedHttpClientRepository extends Mock implements HttpClientRepository {}

class MockedMessageRequest extends Mock implements MessageRequest {}

class MockSocketRepository extends Mock implements SocketClientRepository {}

void main() {
  group('ChatbotCubit', () {
    late ChatbotCubit chatbotCubit;
    late EtiyaChatbotBuilder _etiyaChatbotBuilder;
    late SocketClientRepository _socketRepository;
    late HttpClientRepository _mockHttpClientRepository;

    setUpAll(() {
      registerFallbackValue(MockedMessageRequest());
    });

    setUp(() {
      _etiyaChatbotBuilder = EtiyaChatbotBuilder(
        serviceUrl: 'https://chatbotbo-test.togg.com.tr/api/chat',
        socketUrl: 'https://chatbotbo-test.togg.com.tr/nlp',
        userName: 'enesKaraosman',
      );

      _mockHttpClientRepository = MockedHttpClientRepository();
      _socketRepository = FakeSocketClientRepository();

      chatbotCubit = ChatbotCubit(
        chatbotBuilder: _etiyaChatbotBuilder,
        socketRepository: _socketRepository,
        httpClientRepository: _mockHttpClientRepository,
      );
    });

    tearDown(() {
      chatbotCubit.close();
    });

    test('initial State Equal empty `ChatbotMessages`', () {
      final _chatbotCubit = ChatbotCubit(
        chatbotBuilder: _etiyaChatbotBuilder,
        socketRepository: _socketRepository,
        httpClientRepository: _mockHttpClientRepository,
      );
      expect(_chatbotCubit.state, const ChatbotMessages());
      _chatbotCubit.close();
    });

    group('Message Add Events (Text, Carousel, Quick Reply', () {
      blocTest<ChatbotCubit, ChatbotState>(
        'emit ChatbotMessages when user adds TEXT message',
        build: () {
          when(
            () => _mockHttpClientRepository.sendMessage(
              text: any(named: 'text'),
              senderId: any(named: 'senderId'),
              type: any(named: 'type'),
            ),
          ).thenAnswer((_) async {});
          return chatbotCubit;
        },
        act: (bloc) => bloc.userAddedMessage('messageText'),
        expect: () => [
          ChatbotMessages(
            messages: chatbotCubit.state.messages
                .where((e) => e.messageKind.text == 'messageText')
                .toList(),
          ),
        ],
      );

      blocTest<ChatbotCubit, ChatbotState>(
        'emit ChatbotMessages when user adds QUICK_REPLY message',
        build: () {
          when(
            () => _mockHttpClientRepository.sendMessage(
              text: any(named: 'text'),
              senderId: any(named: 'senderId'),
              type: any(named: 'type'),
            ),
          ).thenAnswer((_) async {});
          return chatbotCubit;
        },
        act: (bloc) => bloc.userAddedQuickReplyMessage(
          const EtiyaQuickReplyItem(
            title: 'quickReplyText',
            payload: 'quickReplyPayload',
          ),
        ),
        expect: () => [
          ChatbotMessages(
            messages: chatbotCubit.state.messages
                .where((e) => e.messageKind.text == 'quickReplyText')
                .toList(),
          )
        ],
      );

      blocTest<ChatbotCubit, ChatbotState>(
        'emit ChatbotMessages when user adds CAROUSEL message',
        build: () {
          when(
            () => _mockHttpClientRepository.sendMessage(
              text: any(named: 'text'),
              senderId: any(named: 'senderId'),
              type: any(named: 'type'),
            ),
          ).thenAnswer((_) async {});
          return chatbotCubit;
        },
        act: (bloc) => bloc.userAddedCarouselMessage(
          CarouselButtonItem(
            title: 'carouselButtonTitle',
            url: 'url',
            payload: 'carouselButtonPayload',
          ),
        ),
        expect: () => [
          ChatbotMessages(
            messages: chatbotCubit.state.messages
                .where((e) => e.messageKind.text == 'carouselButtonTitle')
                .toList(),
          )
        ],
      );
    });

    group('Authentication Events', () {
      blocTest<ChatbotCubit, ChatbotState>(
        'emit ChatbotUserAuthenticated(true) when user authenticates successfully',
        build: () {
          when(
            () => _mockHttpClientRepository.auth(
              username: 'username',
              password: 'correctPassword',
            ),
          ).thenAnswer((_) async => true);
          return chatbotCubit;
        },
        act: (bloc) => bloc.authenticate(
          username: 'username',
          password: 'correctPassword',
        ),
        expect: () => contains(const ChatbotUserAuthenticated(true)),
        verify: (_) {
          verify(
            () => _mockHttpClientRepository.auth(
              username: 'username',
              password: 'correctPassword',
            ),
          ).called(1);
        },
      );

      blocTest<ChatbotCubit, ChatbotState>(
        'emit ChatbotUserAuthenticated(false) when user authentication fails',
        build: () {
          when(
            () => _mockHttpClientRepository.auth(
              username: 'username',
              password: 'wrongPassword',
            ),
          ).thenAnswer((_) async => false);
          return chatbotCubit;
        },
        act: (bloc) => bloc.authenticate(
          username: 'username',
          password: 'wrongPassword',
        ),
        expect: () => contains(const ChatbotUserAuthenticated(false)),
        verify: (_) {
          verify(
            () => _mockHttpClientRepository.auth(
              username: 'username',
              password: 'wrongPassword',
            ),
          ).called(1);
        },
      );
    });

    group('Socket Parameters Should be triggered properly', () {
      // TODO: Socket should receive a welcome message when socket is connected
      // test('Socket should receive a welcome message when socket is connected',
      //     () async {
      //   when(
      //     () => _mockHttpClientRepository.sendMessage(
      //       any<MessageRequest>(),
      //     ),
      //   ).thenAnswer((_) async {});
      //   expect(chatbotCubit.socketRepository.onSocketConnected == null, false);
      //   await chatbotCubit.socketRepository.onSocketConnected?.call();
      //   expect(chatbotCubit.state, isA<ChatbotMessages>());
      //   expect(chatbotCubit.state.messages.isNotEmpty, true);
      // });

      //   blocTest<ChatbotCubit, ChatbotState>(
      //     'should emit ChatbotMessages state when socket receives TEXT message',
      //     build: () => chatbotCubit,
      //     act: (_) => (_socketRepository as FakeSocketClientRepository)
      //         .simulateTextMessageReceiveEvent("textMessageReceived"),
      //     expect: () => [
      //       ChatbotMessages(
      //         messages: chatbotCubit.state.messages
      //             .where(
      //               (element) =>
      //                   element.messageKind.text == 'textMessageReceived',
      //             )
      //             .toList(),
      //       )
      //     ],
      //   );
    });
  });
}
