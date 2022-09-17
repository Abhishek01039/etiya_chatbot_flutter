import 'package:flutter/material.dart';

class ChatbotPopup extends StatefulWidget {
  const ChatbotPopup({
    Key? key,
    this.action,
    this.title,
    this.description,
    this.buttonText,
    this.icon,
    this.iconUrl,
    this.level = TopUpLevel.info,
    this.showMessageCancelButton = false,
  }) : super(key: key);

  const ChatbotPopup.message({
    Key? key,
    this.action,
    this.title,
    this.description,
    this.buttonText,
    this.icon,
    this.iconUrl,
    this.level = TopUpLevel.message,
    this.showMessageCancelButton = false,
  }) : super(key: key);

  final TopUpLevel level;
  final VoidCallback? action;
  final String? title;
  final String? description;
  final String? buttonText;

  final dynamic icon;
  final String? iconUrl;
  final bool showMessageCancelButton;

  @override
  State<ChatbotPopup> createState() => _ChatbotPopupState();
}

enum TopUpLevel { error, success, message, info }

class _ChatbotPopupState extends State<ChatbotPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: MediaQuery.of(context).size.width - 48,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 28),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 28),
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.iconUrl != null) ...[
                      Image.network(
                        widget.iconUrl!,
                        height: 74,
                        width: 100,
                      ),
                      const SizedBox(height: 26.6),
                      if (widget.title != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          child: Text(
                            widget.title ?? '',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headline2!.copyWith(
                              fontSize: 30,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        child: Text(
                          widget.description ?? '',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headline4!.copyWith(
                            color: const Color(0xff575757),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 54),
                    ],
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutBack);

    controller
      ..addListener(() => setState(() {}))
      ..forward();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}

void alertCustomMessage(
  BuildContext context,
  String? title,
  String description, {
  bool dismissable = true,
  bool useRootNavigator = false,
  String? icon,
  String? iconUrl,
  Function()? action,
  String? buttonText,
  bool showMessageCancelButton = false,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: dismissable,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => dismissable,
        child: ChatbotPopup.message(
          title: title,
          description: description,
          icon: icon,
          iconUrl: iconUrl,
          action: action,
          buttonText: buttonText,
          showMessageCancelButton: showMessageCancelButton,
        ),
      );
    },
  );
}
