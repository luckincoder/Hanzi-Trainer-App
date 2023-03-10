import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.callback,
  }) : super(key: key);
  final Icon icon;
  final String title;
  final VoidCallback callback;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          height: 1,
          thickness: 1,
        ),
        ListTile(
          leading: icon,
          title: Text(title),
          onTap: callback,
        ),
      ],
    );
  }
}
