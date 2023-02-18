import 'package:flutter/material.dart';
import 'package:hanzi_trainer/components/tts_button.dart';
import 'package:hanzi_trainer/configs/constants.dart';
import 'package:hanzi_trainer/notifiers/review_notifier.dart';
import 'package:provider/provider.dart';

import '../models/word.dart';

class WordTile extends StatelessWidget {
  WordTile(
      {Key? key,
      required this.word,
      required this.animation,
      this.onPressed,
      required this.index})
      : super(key: key);

  final Word word;

  final Animation animation;
  final _tweenOffsetLeft =
      Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0));
  final _tweenOffsetRight =
      Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));
  final VoidCallback? onPressed;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation
          .drive(CurveTween(curve: Curves.easeInOutSine))
          .drive(index % 2 == 0 ? _tweenOffsetRight : _tweenOffsetLeft),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Consumer<ReviewNotifier>(
          builder: (_, notifier, __) {
            return Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(kCircularBorderRadius),
                  border: Border.all(color: Colors.white, width: 2)),
              child: ListTile(
                leading: notifier.showImage
                    ? SizedBox(
                        width: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child:
                              Image.asset('assets/images/${word.english}.png'),
                        ),
                      )
                    : SizedBox(),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    notifier.showEnglish ? Text(word.english) : SizedBox(),
                    notifier.showCharacter ? Text(word.character) : SizedBox(),
                    notifier.showPinyin ? Text(word.pinyin) : SizedBox(),
                  ],
                ),
                trailing: SizedBox(
                  width: 80,
                  child: Row(
                    children: [
                      TTSButton(
                        word: word,
                        iconSize: 24,
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            onPressed?.call();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
