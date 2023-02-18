import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../animations/half_flip_animation.dart';
import '../animations/slide_animation.dart';
import '../enums/slide_direction.dart';
import '../notifiers/cards_notifier.dart';
import '../components/card_display.dart';
import '../configs/constants.dart';
import '../utils/methods.dart';

class Card1 extends StatelessWidget {
  const Card1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<CardsNotifier>(
      builder: (_, notifier, __) => GestureDetector(
        onDoubleTap: () {
          notifier.runFlipCard1();
          notifier.setIgnoreTouch(ignore: true);
          SharedPreferences.getInstance().then(
            (prefs) {
              if (prefs.getBool('guidebox') == null) {
                runGuideBox(context: context, isFirst: false);
              }
            },
          );
        },
        child: HalfFlipAnimation(
          animate: notifier.flipCard1,
          flipFromHalfway: false,
          reset: notifier.resetFlipCard1,
          animationCompleted: () {
            notifier.resetCard1();
            notifier.runFlipCard2();
          },
          child: SlideAnimation(
            animationDuration: 1000,
            animationDelay: 200,
            animationCompleted: () {
              notifier.setIgnoreTouch(ignore: false);
            },
            reset: notifier.resetSlideCard1,
            animate: notifier.slideCard1 && !notifier.isRoundCompleted,
            direction: SlideDIrection.upIn,
            child: Center(
              child: Container(
                width: size.width * 0.9,
                height: size.height * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kCircularBorderRadius),
                  border:
                      Border.all(color: Colors.white, width: kCardBorderWidth),
                  color: Theme.of(context).primaryColor,
                ),
                child: CardDisplay(isCard1: true),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
