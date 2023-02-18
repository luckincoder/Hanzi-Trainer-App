import 'dart:math';

import 'package:flutter/material.dart';

class HalfFlipAnimation extends StatefulWidget {
  const HalfFlipAnimation(
      {super.key,
      required this.child,
      required this.animate,
      required this.reset,
      required this.flipFromHalfway,
      required this.animationCompleted});

  final Widget child;
  final bool animate;
  final bool reset;
  final bool flipFromHalfway;
  final VoidCallback animationCompleted;

  @override
  State<HalfFlipAnimation> createState() => _HalfFlipAnimationState();
}

class _HalfFlipAnimationState extends State<HalfFlipAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this)
          ..addListener(() {
            if (_animationController.isCompleted) {
              widget.animationCompleted.call();
            }
          });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    if (widget.reset) {
      _animationController.reset();
    }

    if (widget.animate) {
      _animationController.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double rotationAdjustment = 0;

    if (widget.flipFromHalfway) {
      rotationAdjustment = pi / 2;
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY((_animationController.value * pi) / 2)
          ..rotateY(rotationAdjustment),
        child: widget.child,
      ),
    );
  }
}
