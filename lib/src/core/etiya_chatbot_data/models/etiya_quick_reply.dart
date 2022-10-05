import 'package:swifty_chat_data/swifty_chat_data.dart';

class EtiyaQuickReplyItem extends QuickReplyItem {
  const EtiyaQuickReplyItem({
    required String title,
    String? payload,
    String? url,
  }) : super(
          title: title,
          payload: payload,
          url: url,
        );
}
