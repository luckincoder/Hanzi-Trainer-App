import 'package:flutter/material.dart';
import 'package:hanzi_trainer/animations/fade_in_animation.dart';
import 'package:hanzi_trainer/configs/constants.dart';
import 'package:hanzi_trainer/utils/methods.dart';

class TopicTile extends StatelessWidget {
  const TopicTile({
    Key? key,
    required this.topic,
  }) : super(key: key);

  final String topic;

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      child: GestureDetector(
        onTap: () {
          loadSessions(context: context, topic: topic);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kCircularBorderRadius),
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Hero(
                      tag: topic,
                      child: Image.asset('assets/images/$topic.png')),
                ),
              ),
              Expanded(child: Text(topic)),
            ],
          ),
        ),
      ),
    );
  }
}
