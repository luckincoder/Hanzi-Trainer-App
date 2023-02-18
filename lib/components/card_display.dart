import 'package:flutter/material.dart';

import 'package:hanzi_trainer/components/tts_button.dart';
import 'package:hanzi_trainer/notifiers/cards_notifier.dart';
import 'package:hanzi_trainer/notifiers/settings_notifier.dart';
import 'package:provider/provider.dart';

import '../enums/settings.dart';

class CardDisplay extends StatelessWidget {
  const CardDisplay({
    required this.isCard1,
    Key? key,
  }) : super(key: key);
  final bool isCard1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Consumer<SettingsNotifier>(
        builder: (_, notifier, __) {
          final setEnglishFirst = notifier.displayOptions.entries
              .firstWhere((element) => element.key == Settings.englishFirst)
              .value;

          final showPinyin = notifier.displayOptions.entries
              .firstWhere((element) => element.key == Settings.showPinyin)
              .value;
          final audioOnly = notifier.displayOptions.entries
              .firstWhere((element) => element.key == Settings.audioOnly)
              .value;

          return Consumer<CardsNotifier>(
            builder: (_, notifier, __) => isCard1
                ? Column(
                    children: [
                      if (audioOnly) ...[
                        TTSButton(
                          word: notifier.word1,
                        )
                      ] else if (!setEnglishFirst) ...[
                        buildTextBox(notifier.word1.character, context, 3),
                        showPinyin
                            ? buildTextBox(notifier.word1.pinyin, context, 1)
                            : SizedBox(),
                        TTSButton(word: notifier.word1),
                      ] else ...[
                        buildImage(notifier.word1.english),
                        buildTextBox(notifier.word1.english, context, 1),
                      ]
                    ],
                  )
                : Column(
                    children: [
                      if (audioOnly) ...[
                        buildImage(notifier.word2.english),
                        buildTextBox(notifier.word2.english, context, 2),
                        buildTextBox(notifier.word2.character, context, 2),
                        showPinyin
                            ? buildTextBox(notifier.word2.pinyin, context, 1)
                            : SizedBox(),
                        TTSButton(word: notifier.word1),
                      ] else if (!setEnglishFirst) ...[
                        buildImage(notifier.word2.english),
                        buildTextBox(notifier.word2.english, context, 2),
                      ] else ...[
                        buildImage(notifier.word2.english),
                        buildTextBox(notifier.word2.character, context, 2),
                        showPinyin
                            ? buildTextBox(notifier.word2.pinyin, context, 1)
                            : SizedBox(),
                        TTSButton(word: notifier.word1),
                      ]
                    ],
                  ),
          );
        },
      ),
    );
  }

  Expanded buildTextBox(String text, BuildContext context, int flex) {
    return Expanded(
        flex: flex,
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: FittedBox(
            child: Text(
              text,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        ));
  }

  Expanded buildImage(String image) {
    return Expanded(
        flex: 4,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Image.asset('assets/images/$image.png'),
        ));
  }
}
