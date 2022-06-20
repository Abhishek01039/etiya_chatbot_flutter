import 'package:flutter/material.dart';

class L10n {
  const L10n._(this.value);

  static const enUS = L10n._('en_US');
  static const tr = L10n._('tr');

  final String value;

  static final all = [
    const Locale('en', 'US'),
    const Locale('tr'),
  ];

  static List<L10n> get values => [
        enUS,
        tr,
      ];

  Locale getLocale() {
    if (this == tr) {
      return const Locale('tr');
    } else {
      return const Locale('en', 'US');
    }
  }

  String toUiLocales() {
    switch (this) {
      case enUS:
        return 'en-US';
      case tr:
        return 'tr-TR';
      default:
        return '';
    }
  }

  /// Get the flag by language code
  static String getFlag(String code) {
    switch (code) {
      case 'ar':
        return '🇦🇪';
      case 'es':
        return '🇪🇸';
      case 'de':
        return '🇩🇪';
      case 'en':
      default:
        return '🇺🇸';
    }
  }

  static L10n get(String value) => values.firstWhere(
        (it) => it.value.toLowerCase().startsWith(value.toLowerCase()),
        orElse: () => values.first,
      );
}
