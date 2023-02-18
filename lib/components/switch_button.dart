import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enums/settings.dart';
import '../notifiers/settings_notifier.dart';
import '../utils/methods.dart';

class SwitchButton extends StatelessWidget {
  const SwitchButton({
    required this.displayOption,
    this.disable = false,
    Key? key,
  }) : super(key: key);

  final Settings displayOption;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(
      builder: (_, notifier, __) => Column(
        children: [
          SwitchListTile(
            inactiveThumbColor: Colors.black.withOpacity(0.5),
            tileColor:
                disable ? Colors.black.withOpacity(0.1) : Colors.transparent,
            title: Text(displayOption.toText()),
            value: notifier.displayOptions.entries
                .firstWhere((element) => element.key == displayOption)
                .value,
            onChanged: disable
                ? null
                : (value) {
                    notifier.updateDisplayOptions(
                        displayOption: displayOption, isToggled: value);
                  },
          ),
          Divider(
            height: 1,
            thickness: 1,
          )
        ],
      ),
    );
  }
}
