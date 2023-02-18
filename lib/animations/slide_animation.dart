import 'package:flutter/material.dart';
import 'package:hanzi_trainer/enums/slide_direction.dart';

import '../configs/constants.dart';

class SlideAnimation extends StatefulWidget {
  const SlideAnimation(
      {required this.child,
      this.animationDuration = kSlideAwayDuration,
      this.animationDelay = 0,
      required this.direction,
      this.reset,
      this.animate = true,
      this.animationCompleted,
      super.key});

  final Widget child;
  final SlideDIrection direction;
  final bool animate;
  final bool? reset;
  final VoidCallback? animationCompleted;
  final int animationDuration;
  final int animationDelay;

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: widget.animationDuration), vsync: this)
      ..addListener(() {
        if (_animationController.isCompleted) {
          widget.animationCompleted?.call();
        }
      });
    // _animation = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
    //     CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    super.initState();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    if (widget.reset == true) {
      _animationController.reset();
    }
    if (widget.animate) {
      if (widget.animationDelay > 0) {
        Future.delayed(Duration(milliseconds: widget.animationDelay), () {
          if (mounted) {
            _animationController.forward();
          }
        });
      } else {
        _animationController.forward();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final Animation<Offset> _animation;
    Tween<Offset> tween;

    switch (widget.direction) {
      case SlideDIrection.leftAway:
        tween =
            Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-1, 0));
        break;
      case SlideDIrection.rightAway:
        tween =
            Tween<Offset>(begin: const Offset(0, 0), end: const Offset(1, 0));
        break;
      case SlideDIrection.leftIn:
        tween =
            Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0));
        break;
      case SlideDIrection.rightIn:
        tween =
            Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0));
        break;
      case SlideDIrection.upIn:
        tween =
            Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0));
        break;
      case SlideDIrection.none:
        tween =
            Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0));
        break;
    }

    _animation = tween.animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}
