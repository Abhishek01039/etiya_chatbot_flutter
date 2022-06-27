# Etiya Chatbot SDK

### Supported Message Kinds

- Text
- Quick Reply
- Image
- Carousel
- HTML

### Supported Platforms

- iOS
- Android
- Web
- MacOS
- Windows

### How to integrate?

See [the readme of example project](example/README.md)

### Localization

We have enabled the Localization for chatbot. As soon as we run `flutter pub get`, it will generate the code inside `flutter_gen` directory.

There are following generated files inside `flutter_gen`:

- app_localizations_en.dart
- app_localizations_tr.dart
- app_localizations.dart

Whenever we modify `app_en.arb` or `app_tr.arb` files, it will change above generated files. Therefore, we need to drag these files into `lib/src/localization/generated` directory.
