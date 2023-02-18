import 'package:flutter/material.dart';
import 'package:hanzi_trainer/components/language_button.dart';
import 'package:hanzi_trainer/configs/themes.dart';
import 'package:hanzi_trainer/notifiers/cards_notifier.dart';
import 'package:hanzi_trainer/notifiers/review_notifier.dart';
import 'package:hanzi_trainer/notifiers/settings_notifier.dart';
import 'package:hanzi_trainer/utils/methods.dart';
import 'package:provider/provider.dart';

import './pages/home_page.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CardsNotifier()),
    ChangeNotifierProvider(create: (_) => SettingsNotifier()),
    ChangeNotifierProvider(create: (_) => ReviewNotifier()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    updatePreferencesOnRestart(context: context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hanzi Trainer',
      theme: appTheme,
      home: const HomePage(),
    );
  }
}
