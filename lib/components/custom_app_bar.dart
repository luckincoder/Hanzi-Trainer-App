import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifiers/cards_notifier.dart';
import '../pages/home_page.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CardsNotifier>(
      builder: (_, notifier, __) => AppBar(
        actions: [
          IconButton(
            onPressed: () {
              notifier.reset();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: ((context) => HomePage())),
                  (route) => false);
            },
            icon: Icon(Icons.clear),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Hero(
              tag: notifier.topic,
              child: Image.asset('assets/images/${notifier.topic}.png')),
        ),
        title: Text(notifier.topic),
      ),
    );
  }
}
