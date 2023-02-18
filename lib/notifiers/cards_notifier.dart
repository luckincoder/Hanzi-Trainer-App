import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hanzi_trainer/components/results_box.dart';
import 'package:hanzi_trainer/configs/constants.dart';
import 'package:hanzi_trainer/data/words.dart';
import 'package:hanzi_trainer/enums/slide_direction.dart';
import 'package:hanzi_trainer/models/word.dart';

class CardsNotifier extends ChangeNotifier {
  List<Word> incorrectCards = [];

  int roundTally = 0,
      cardTally = 0,
      correctTally = 0,
      incorrectTally = 0,
      correctPercentage = 0;

  calculateCorrectPercentage() {
    final percentage = correctTally / cardTally;
    correctPercentage = (percentage * 100).round();
  }

  double progressPercent = 0.0;

  calculateProgressPercentage() {
    progressPercent = (correctTally + incorrectTally) / cardTally;
    notifyListeners();
  }

  resetProgressBar() {
    progressPercent = 0.0;
    notifyListeners();
  }

  late String topic;
  Word word1 =
      Word(topic: '', english: 'Loading Arrow', character: '', pinyin: '');
  Word word2 =
      Word(topic: '', english: 'Loading Arrow', character: '', pinyin: '');
  List<Word> selectedWords = [];

  bool isFirstRound = true,
      isRoundCompleted = false,
      isSessionCompleted = false;
  reset() {
    resetCard1();
    resetCard2();
    incorrectCards.clear();
    isFirstRound = true;
    isRoundCompleted = false;
    isSessionCompleted = false;
    roundTally = 0;
  }

  setTopic({required String topic}) {
    this.topic = topic;
    notifyListeners();
  }

  generateAllSelectedWords() {
    words.shuffle();
    isRoundCompleted = false;
    if (isFirstRound) {
      if (topic == 'Random 5') {
        selectedWords.clear();
        for (int i = 0; i < 5; i++) {
          selectedWords.add(words[i]);
        }
      } else if (topic == 'Random 20') {
        selectedWords.clear();
        for (int i = 0; i < 20; i++) {
          selectedWords.add(words[i]);
        }
      } else if (topic == 'Test All') {
        selectedWords.clear();
        selectedWords = words.toList();
      } else if (topic != 'Review') {
        selectedWords.clear();
        selectedWords =
            words.where((element) => element.topic == topic).toList();
      }
    } else {
      selectedWords = incorrectCards.toList();
      incorrectCards.clear();
    }
    roundTally++;
    cardTally = selectedWords.length;
    correctTally = 0;
    incorrectTally = 0;
    resetProgressBar();
  }

  generateCurrentWord({required BuildContext context}) {
    if (selectedWords.isNotEmpty) {
      final r = Random().nextInt(selectedWords.length);
      word1 = selectedWords[r];
      selectedWords.removeAt(r);
    } else {
      if (incorrectCards.isEmpty) {
        isSessionCompleted = true;
        print('Session Completed: $isSessionCompleted');
      }
      isFirstRound = false;
      isRoundCompleted = true;
      calculateCorrectPercentage();
      Future.delayed(Duration(milliseconds: kSlideAwayDuration), () {
        showDialog(context: context, builder: (context) => ResultBox());
      });
    }
    Future.delayed(
      const Duration(milliseconds: kSlideAwayDuration),
      () => word2 = word1,
    );
  }

  updateCardOutcome({required Word word, required bool isCorrect}) {
    if (!isCorrect) {
      incorrectCards.add(word);
      incorrectTally++;
    } else {
      correctTally++;
    }
    calculateProgressPercentage();
    incorrectCards.forEach(
      (element) => print(element.character),
    );
    notifyListeners();
  }

  //Animation Code
  bool ignoreTouches = true;

  setIgnoreTouch({required bool ignore}) {
    ignoreTouches = ignore;
    notifyListeners();
  }

  SlideDIrection swipeDirection = SlideDIrection.none;

  bool flipCard1 = false,
      flipCard2 = false,
      swipeCard2 = false,
      slideCard1 = false;
  runSlideCard1() {
    resetSlideCard1 = false;
    slideCard1 = true;
    notifyListeners();
  }

  runFlipCard1() {
    resetFlipCard1 = false;
    flipCard1 = true;
    notifyListeners();
  }

  runFlipCard2() {
    resetFlipCard2 = false;
    flipCard2 = true;
    notifyListeners();
  }

  runSwipeCard2({required SlideDIrection direction}) {
    updateCardOutcome(
        word: word2, isCorrect: direction == SlideDIrection.leftAway);
    swipeDirection = direction;
    swipeCard2 = true;
    resetSwipeCard2 = false;
    notifyListeners();
  }

  bool resetFlipCard1 = false,
      resetFlipCard2 = false,
      resetSwipeCard2 = false,
      resetSlideCard1 = false;

  resetCard1() {
    resetFlipCard1 = true;
    resetSlideCard1 = true;
    slideCard1 = false;
    flipCard1 = false;
  }

  resetCard2() {
    resetFlipCard2 = true;
    resetSwipeCard2 = true;
    swipeCard2 = false;
    flipCard2 = false;
  }
}
