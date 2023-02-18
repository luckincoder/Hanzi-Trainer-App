import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:hanzi_trainer/enums/language_type.dart';
import 'package:hanzi_trainer/notifiers/review_notifier.dart';
import 'package:hanzi_trainer/utils/methods.dart';
import 'package:provider/provider.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({
    this.isDisabled = false,
    required this.languageType,
    Key? key,
  }) : super(key: key);

  final LanguageType languageType;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: isDisabled
              ? null
              : () {
                  Provider.of<ReviewNotifier>(context, listen: false)
                      .updateShowLanguage(languageType: languageType);
                },
          child: Text(languageType.toSymbol()),
        ),
      ),
    );
  }
}
