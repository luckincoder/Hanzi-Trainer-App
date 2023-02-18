// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hanzi_trainer/components/custom_app_bar.dart';
import 'package:hanzi_trainer/databases/database_manager.dart';
import 'package:hanzi_trainer/notifiers/settings_notifier.dart';
import 'package:hanzi_trainer/utils/methods.dart';
import 'package:provider/provider.dart';

import '../components/settings_tile.dart';
import '../components/switch_button.dart';
import '../configs/constants.dart';
import '../enums/settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(
      builder: (_, notifier, __) {
        bool audioFirst = notifier.displayOptions.entries
            .firstWhere((element) => element.key == Settings.audioOnly)
            .value;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kAppBarHeight),
            child: CustomAppBar(),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  SwitchButton(
                      disable: audioFirst,
                      displayOption: Settings.englishFirst),
                  SwitchButton(displayOption: Settings.showPinyin),
                  SwitchButton(displayOption: Settings.audioOnly),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SettingsTile(
                    callback: () async {
                      notifier.resetSettings();
                      runQuickBox(
                          context: context, text: 'Resetting Settings...');
                      await DatabaseManager().removeAllWords();
                    },
                    icon: Icon(Icons.refresh),
                    title: 'Reset',
                  ),
                  SettingsTile(
                    callback: () {
                      Platform.isAndroid
                          ? SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop')
                          : exit(0);
                    },
                    icon: Icon(Icons.exit_to_app),
                    title: 'Exit App',
                  ),
                  if (Platform.isIOS) SizedBox(height: 20)
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
