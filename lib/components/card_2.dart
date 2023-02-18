import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../animations/half_flip_animation.dart';
import '../animations/slide_animation.dart';
import '../enums/slide_direction.dart';
import '../notifiers/cards_notifier.dart';
import '../components/card_display.dart';
import '../configs/constants.dart';

class Card2 extends StatelessWidget {
  const Card2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<CardsNotifier>(
      builder: (_, notifier, __) => GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 100) {
            notifier.runSwipeCard2(direction: SlideDIrection.leftAway);
            notifier.runSlideCard1();
            notifier.setIgnoreTouch(ignore: true);
            notifier.generateCurrentWord(context: context);
          }
          if (details.primaryVelocity! < -100) {
            notifier.runSwipeCard2(direction: SlideDIrection.rightAway);
            notifier.runSlideCard1();
            notifier.setIgnoreTouch(ignore: true);
            notifier.generateCurrentWord(context: context);
          }
        },
        child: HalfFlipAnimation(
          animate: notifier.flipCard2,
          flipFromHalfway: true,
          reset: notifier.resetFlipCard2,
          animationCompleted: () {
            notifier.setIgnoreTouch(ignore: false);
          },
          child: SlideAnimation(
            animationCompleted: () {
              notifier.resetCard2();
            },
            reset: notifier.resetSwipeCard2,
            animate: notifier.swipeCard2,
            direction: notifier.swipeDirection,
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
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: CardDisplay(isCard1: false),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
