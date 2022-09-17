import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:flutter/material.dart';
import 'package:togg_mobile_super_app_sdk/togg_mobile_super_app_sdk.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Etiya Chatbot',
      home: InitialScreen(),
      localizationsDelegates: [
        ChatBotAppLocalizationsDelegate(),
      ],
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ),
            );
          },
          child: const Text("Open Chatbot"),
        ),
      ),
    );
  }
}

class ToggChatbotTheme extends ChatTheme {
  const ToggChatbotTheme() : super();

  final Color toggPrimary = const Color(0xFF00C2E7);
  final Color toggSecondary = const Color(0xFFFF8933);

  @override
  Color get backgroundColor => neutral7;

  @override
  double get messageBorderRadius => 20;

  @override
  double get textMessagePadding => 12;

  @override
  Color get primaryColor => toggSecondary;

  @override
  TextStyle get incomingMessageBodyTextStyle => const TextStyle(
      fontFamily: 'Fedra-Sans-Std', fontSize: 17, color: Colors.white);

  @override
  TextStyle get outgoingMessageBodyTextStyle => const TextStyle(
      fontFamily: 'Fedra-Sans-Std', fontSize: 17, color: Colors.white);

  @override
  Color get secondaryColor => toggPrimary;

  @override
  EdgeInsets get messageInset => const EdgeInsets.symmetric(vertical: 8);

  @override
  TextStyle get carouselTitleTextStyle =>
      const TextStyle(fontFamily: 'Fedra-Sans-Std', fontSize: 19);

  @override
  TextStyle get carouselSubtitleTextStyle =>
      const TextStyle(fontFamily: 'Fedra-Sans-Std', fontSize: 17);

  @override
  ButtonStyle get carouselButtonStyle => ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(toggPrimary),
      );

  @override
  ButtonStyle get quickReplyButtonStyle => ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(toggPrimary),
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            fontWeight: FontWeight.bold,
            color: toggPrimary,
          ),
        ),
      );

  @override
  Color get htmlTextColor => neutral0;

  @override
  String? get htmlTextFontFamily => 'Avenir';

  @override
  BoxDecoration get carouselBoxDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFDFF2F6),
      );

  @override
  BorderRadius get imageBorderRadius => BorderRadius.zero;
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  final EtiyaChatbot _etiyaChatbot = EtiyaChatbotBuilder(
    serviceUrl: '',
    socketUrl: '',
    userName: 'johnDoe',
  )
      .setAccessToken('Bearer *jwt*')
      .setLoggingEnabled(true)
      .setIncomingAvatar(
        UserAvatar(
          size: 36,
          imageProvider: const NetworkImage(
            'https://www.softronic.se/wp-content/uploads/2020/03/avatar_chatbot.png',
          ),
        ),
      )
      .setChatTheme(const ToggChatbotTheme())
      .setAuthUrl('')
      .build();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    TOGGMobileSdk().setTOGGUser(
      const ToggUser(
        firstName: 'john',
        lastName: 'doe',
        userId: '626b2a4e-3e32-4234-bb7c-b01454d3f989',
        tenantId: 'toggId',
        email: 'placeholder@domain.com',
        language: 'tr',
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00C2E7),
      ),
      body: widget._etiyaChatbot.getChatWidget(),
    );
  }
}
