import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:hanzi_trainer/configs/constants.dart';
import 'package:hanzi_trainer/notifiers/cards_notifier.dart';
import 'package:provider/provider.dart';

class ProgressBar extends StatefulWidget {
  const ProgressBar({super.key});

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double startVal = 0.0, endVal = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Selector<CardsNotifier, double>(
      selector: (_, notifier) => notifier.progressPercent,
      builder: (_, progressPercent, __) {
        endVal = progressPercent;
        if (endVal == 0) {
          startVal = 0;
        }
        var animation = Tween<double>(begin: startVal, end: endVal).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOutCirc));

        _controller.reset();
        _controller.forward();
        startVal = endVal;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Padding(
            padding: EdgeInsets.all(size.width * 0.05),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kCircularBorderRadius),
              child: LinearProgressIndicator(
                minHeight: size.height * 0.03,
                value: animation.value,
              ),
            ),
          ),
        );
      },
    );
  }
}
