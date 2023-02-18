import 'package:flutter/material.dart';
import 'package:hanzi_trainer/components/guide_box.dart';
import 'package:hanzi_trainer/components/quick_box.dart';
import 'package:hanzi_trainer/enums/language_type.dart';
import 'package:hanzi_trainer/notifiers/cards_notifier.dart';
import 'package:hanzi_trainer/notifiers/settings_notifier.dart';
import 'package:hanzi_trainer/pages/card_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/settings.dart';

loadSessions({required BuildContext context, required String topic}) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => CardPage()));
  Provider.of<CardsNotifier>(context, listen: false).setTopic(topic: topic);
}

extension SettingsToText on Settings {
  String toText() {
    switch (this) {
      case Settings.englishFirst:
        return 'Show English First';
      case Settings.showPinyin:
        return 'Show Pinyin';
      case Settings.audioOnly:
        return 'Test Listening';
    }
  }
}

extension LanguageSymbol on LanguageType {
  String toSymbol() {
    switch (this) {
      case LanguageType.image:
        return '🖼️';
      case LanguageType.english:
        return 'Abc';
      case LanguageType.character:
        return '汉子';
      case LanguageType.pinyin:
        return 'Pinyin';
    }
  }
}

updatePreferencesOnRestart({required BuildContext context}) {
  final settingsNotifier =
      Provider.of<SettingsNotifier>(context, listen: false);

  for (var e in settingsNotifier.displayOptions.entries) {
    SharedPreferences.getInstance().then((prefs) {
      final result = prefs.getBool(e.key.name);
      if (result != null) {
        settingsNotifier.displayOptions.update(e.key, (value) => result);
      }
    });
  }
}

clearPreferences() {
  SharedPreferences.getInstance().then((prefs) {
    for (var e in SettingsNotifier().displayOptions.entries) {
      prefs.remove(e.key.name);
      prefs.remove('popup');
      prefs.remove('guidebox');
    }
  });
}

runGuideBox({required BuildContext context, required bool isFirst}) {
  if (!isFirst) {
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool('guidebox', true);
      },
    );
  }
  Future.delayed(Duration(milliseconds: 1200), () {
    showDialog(
        context: context,
        builder: (context) => GuideBox(
              isFirst: isFirst,
            ));
  });
}

runQuickBox({required BuildContext context, required String text}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => QuickBox(
            text: text,
          ));
  Future.delayed(Duration(milliseconds: 1200), () {
    Navigator.maybePop(context);
  });
}
