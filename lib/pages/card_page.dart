// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:hanzi_trainer/components/card_2.dart';
import 'package:hanzi_trainer/components/progress_bar.dart';
import 'package:hanzi_trainer/notifiers/cards_notifier.dart';
import 'package:hanzi_trainer/utils/methods.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/card_1.dart';
import '../components/custom_app_bar.dart';
import '../configs/constants.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  void initState() {
    final cardsNotifier = Provider.of<CardsNotifier>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      cardsNotifier.runSlideCard1();
      cardsNotifier.generateAllSelectedWords();
      cardsNotifier.generateCurrentWord(context: context);
      SharedPreferences.getInstance().then(
        (prefs) {
          if (prefs.getBool('guidebox') == null) {
            runGuideBox(context: context, isFirst: true);
          }
        },
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CardsNotifier>(
      builder: (_, notifier, __) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kAppBarHeight),
          child: CustomAppBar(),
        ),
        body: IgnorePointer(
          ignoring: notifier.ignoreTouches,
          child: Stack(
            children: [
              Align(alignment: Alignment.bottomCenter, child: ProgressBar()),
              Card2(),
              Card1(),
            ],
          ),
        ),
      ),
    );
  }
}
