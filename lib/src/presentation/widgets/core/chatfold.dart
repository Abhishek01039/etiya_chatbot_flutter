import 'package:etiya_chatbot_flutter/src/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Chatfold extends HookWidget {
  final List<Widget> appBarElements, scaffoldBackGround, elements;
  final BoxDecoration? appBarDecoration;
  final Color? color;
  const Chatfold(
      {required this.appBarElements,
      required this.scaffoldBackGround,
      required this.elements,
      this.color,
      this.appBarDecoration});
  @override
  Widget build(BuildContext context) {

    return Center(
      child: SizedBox(
        height: context.screenHeight,
        width: context.screenWidth,
        child: Scaffold(
          backgroundColor: color,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(context.screenHeight / 14.7),
            child: DecoratedBox(
              decoration: appBarDecoration ??
                  BoxDecoration(color: Colors.transparent.withOpacity(0)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(children: appBarElements),
              ),
            ),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              ...scaffoldBackGround,
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: elements,
              )
            ],
          ),
        ),
      ),
    );
  }
}
