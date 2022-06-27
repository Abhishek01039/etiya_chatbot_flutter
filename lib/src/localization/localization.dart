import 'package:etiya_chatbot_flutter/src/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';

extension Localization on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this)!;
}
