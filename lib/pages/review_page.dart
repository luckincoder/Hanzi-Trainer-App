// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:hanzi_trainer/components/custom_app_bar.dart';
import 'package:hanzi_trainer/configs/constants.dart';
import 'package:hanzi_trainer/databases/database_manager.dart';
import 'package:hanzi_trainer/enums/language_type.dart';
import 'package:hanzi_trainer/models/word.dart';
import 'package:hanzi_trainer/notifiers/cards_notifier.dart';
import 'package:hanzi_trainer/notifiers/review_notifier.dart';
import 'package:provider/provider.dart';

import '../components/header_button.dart';
import '../components/language_button.dart';
import '../components/word_tile.dart';
import 'card_page.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _listKey = GlobalKey<AnimatedListState>();

  final _reviewWords = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kAppBarHeight),
        child: CustomAppBar(),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Selector<ReviewNotifier, bool>(
              selector: (_, review) => review.buttonsDisabled,
              builder: (_, disable, __) => Row(
                children: [
                  HeaderButton(
                    isDisabled: disable,
                    text: 'Test All',
                    onPressed: () {
                      final provider =
                          Provider.of<CardsNotifier>(context, listen: false);
                      provider.selectedWords.clear();
                      DatabaseManager().selectWords().then((words) {
                        provider.selectedWords = words.toList();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CardPage(),
                          ),
                        );
                      });
                    },
                  ),
                  HeaderButton(
                    isDisabled: disable,
                    text: 'Quick Test',
                    onPressed: () {
                      final provider =
                          Provider.of<CardsNotifier>(context, listen: false);
                      provider.selectedWords.clear();
                      DatabaseManager().selectWords(limit: 2).then((words) {
                        provider.selectedWords = words.toList();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CardPage(),
                          ),
                        );
                      });
                    },
                  ),
                  HeaderButton(
                    isDisabled: disable,
                    text: 'Clear Cards',
                    onPressed: () {
                      _clearAllWords();
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: FutureBuilder(
              future: DatabaseManager().selectWords(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var sortList = snapshot.data as List<Word>;

                  sortList.sort(
                    (a, b) => a.english.compareTo(b.english),
                  );

                  WidgetsBinding.instance.addPostFrameCallback(
                    (timeStamp) {
                      _insertWords(words: sortList);
                    },
                  );

                  return AnimatedList(
                    key: _listKey,
                    initialItemCount: _reviewWords.length,
                    itemBuilder: (context, index, animation) => WordTile(
                      index: index,
                      word: _reviewWords[index],
                      animation: animation,
                      onPressed: () {
                        _removeWord(word: _reviewWords[index]);
                      },
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Selector<ReviewNotifier, bool>(
              selector: (_, review) => review.buttonsDisabled,
              builder: (_, disable, __) => Row(
                children: [
                  LanguageButton(
                      languageType: LanguageType.image, isDisabled: disable),
                  LanguageButton(
                      languageType: LanguageType.english, isDisabled: disable),
                  LanguageButton(
                      languageType: LanguageType.character,
                      isDisabled: disable),
                  LanguageButton(
                      languageType: LanguageType.pinyin, isDisabled: disable),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _insertWords({required List<Word> words}) {
    for (int i = 0; i < words.length; i++) {
      _listKey.currentState?.insertItem(i);
      _reviewWords.insert(i, words[i]);
    }
  }

  _removeWord({required Word word}) async {
    var w = word;
    _listKey.currentState?.removeItem(
      _reviewWords.indexOf(w),
      (context, animation) => WordTile(
        word: w,
        animation: animation,
        index: _reviewWords.indexOf(w),
      ),
    );
    _reviewWords.remove(w);
    await DatabaseManager().removeWord(word: w);
    if (_reviewWords.isEmpty) {
      Provider.of<ReviewNotifier>(context, listen: false)
          .disableButtons(disable: true);
    }
  }

  _clearAllWords() {
    for (int i = 0; i < _reviewWords.length; i++) {
      _listKey.currentState?.removeItem(
        0,
        (context, animation) => WordTile(
          word: _reviewWords[i],
          animation: animation,
          index: i,
        ),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _reviewWords.cast();
      await DatabaseManager().removeAllWords();
      Provider.of<ReviewNotifier>(context, listen: false)
          .disableButtons(disable: true);
    });
  }
}
