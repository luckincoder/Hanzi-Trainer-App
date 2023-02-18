import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class QuickBox extends StatelessWidget {
  const QuickBox({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
