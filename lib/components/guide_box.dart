import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../animations/fade_in_animation.dart';

class GuideBox extends StatelessWidget {
  const GuideBox({super.key, required this.isFirst});

  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heightPadding = size.height * 0.2;
    final widthPadding = size.width * 0.1;
    return FadeInAnimation(
      child: AlertDialog(
        insetPadding: EdgeInsets.symmetric(
            vertical: heightPadding, horizontal: widthPadding),
        content: Column(
          children: [
            if (isFirst) ...[
              const Text('Double Tap\nTo Reveal Answer',
                  textAlign: TextAlign.center),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset('assets/images/GuideDoubleTap.png'),
                ),
              ),
            ] else ...[
              Expanded(
                child: Row(
                  children: [
                    GuideSwipe(isLeft: true),
                    GuideSwipe(isLeft: false),
                  ],
                ),
              )
            ],
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: size.width * 0.5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                  child: Text('Got It!')),
            ),
          )
        ],
      ),
    );
  }
}

class GuideSwipe extends StatelessWidget {
  const GuideSwipe({
    required this.isLeft,
    Key? key,
  }) : super(key: key);

  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          isLeft
              ? const Text('Swipe Left\nIf Incorrect',
                  textAlign: TextAlign.left)
              : const Text('Swipe Right\nIf Correct',
                  textAlign: TextAlign.right),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: isLeft
                  ? Image.asset('assets/images/GuideLeftSwipe.png')
                  : Image.asset('assets/images/GuideRightSwipe.png'),
            ),
          ),
        ],
      ),
    );
  }
}
