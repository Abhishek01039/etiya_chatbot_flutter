import 'package:etiya_chatbot_flutter/src/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class ChatBotAppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const ChatBotAppLocalizationsDelegate();

  static late AppLocalizations instance;

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.delegate.isSupported(locale);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final _instance = await AppLocalizations.delegate.load(locale);
    ChatBotAppLocalizationsDelegate.instance = _instance;
    return instance;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
