// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hanzi_trainer/animations/fade_in_animation.dart';
import 'package:hanzi_trainer/databases/database_manager.dart';
import 'package:hanzi_trainer/notifiers/cards_notifier.dart';
import 'package:hanzi_trainer/notifiers/review_notifier.dart';
import 'package:hanzi_trainer/pages/review_page.dart';
import 'package:hanzi_trainer/pages/settings_page.dart';
import 'package:provider/provider.dart';
import '../components/topic_tile.dart';
import '../data/words.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _topics = [];

  @override
  void initState() {
    for (var t in words) {
      if (!_topics.contains(t.topic)) {
        _topics.add(t.topic);
      }
      _topics.sort();
    }
    _topics.insertAll(0, ['Random 5', 'Random 20', 'Test All']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widthPadding = size.width * 0.04;

    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        toolbarHeight: size.height * 0.15,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Provider.of<CardsNotifier>(context, listen: false)
                    .setTopic(topic: 'Settings');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ));
              },
              child: SizedBox(
                  width: size.width * 0.08,
                  child: Image.asset('assets/images/Settings.png')),
            ),
            Text(
              'Hanzi Trainer\n练习中文',
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              onTap: () {
                _loadReviewPage(context);
              },
              child: SizedBox(
                  width: size.width * 0.08,
                  child: Image.asset('assets/images/Review.png')),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: widthPadding),
        child: CustomScrollView(slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            expandedHeight: size.height * 0.4,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsets.all(size.width * 0.10),
                child: FadeInAnimation(
                    child: Image.asset('assets/images/Dragon.png')),
              ),
            ),
          ),
          SliverGrid(
              delegate: SliverChildBuilderDelegate(
                childCount: _topics.length,
                (context, index) => TopicTile(topic: _topics[index]),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 6, mainAxisSpacing: 6))
        ]),
      ),
    );
  }

  void _loadReviewPage(BuildContext context) {
    Provider.of<CardsNotifier>(context, listen: false)
        .setTopic(topic: 'Review');

    DatabaseManager().selectWords().then((words) {
      final reviewNotifier =
          Provider.of<ReviewNotifier>(context, listen: false);
      if (words.isEmpty) {
        reviewNotifier.disableButtons(disable: true);
      } else {
        reviewNotifier.disableButtons(disable: false);
      }
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewPage(),
          ));
    });
  }
}
