import 'package:flutter/material.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';
import 'package:satnogs_visualization_tool/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SatNOGS Visualization Tool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: MaterialColor(ThemeColors.backgroundColorHex,
              ThemeColors.backgroundColorMaterial),
          scaffoldBackgroundColor: ThemeColors.backgroundColor),
      home: const HomePage(),
    );
  }
}
