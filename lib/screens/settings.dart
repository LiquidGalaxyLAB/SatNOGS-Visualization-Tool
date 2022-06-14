import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        shadowColor: Colors.transparent,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            splashRadius: 24,
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.build_rounded),
          )
        ],
      ),
    );
  }
}
