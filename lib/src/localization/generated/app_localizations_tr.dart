import 'app_localizations.dart';

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get submit => 'Gönder';

  @override
  String get enter_valid_email => 'Geçerli bir email giriniz';

  @override
  String get email_address => 'Email Adresi';

  @override
  String get end_message =>
      "Değerli görüşleriniz için teşekkür eder, sağlıklı ve mutlu günler dileriz.";

  @override
  String get enter_non_empty_password =>
      'Lütfen şifre alanını boş bırakmayınız';

  @override
  String get password => 'Şifre';

  @override
  String get login => 'Giriş';
}
