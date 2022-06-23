import 'package:flutter/material.dart';
import 'package:satnogs_visualization_tool/screens/settings.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SatNOGS Visualization Tool'),
        shadowColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  splashRadius: 24,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()));
                  }))
        ],
      ),
      body: const Center(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'View satellite by NORAD id',
        child: const Icon(Icons.manage_search_rounded, size: 28),
        backgroundColor: ThemeColors.primaryColor,
        foregroundColor: ThemeColors.backgroundColor,
        onPressed: () {},
      ),
    );
  }
}
