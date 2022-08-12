import 'dart:async';

import 'package:flutter/material.dart';
import 'package:satnogs_visualization_tool/screens/home.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final _imageRows = [
    [
      'assets/images/lg-logo.png',
      'assets/images/gsoc.png',
    ],
    [
      'assets/images/lglab-logo.png',
      'assets/images/lgeu-logo.png',
      'assets/images/laboratoris-tic-logo.png',
      'assets/images/pcital-logo.jpg',
    ],
    [
      'assets/images/facens.png',
      'assets/images/satnogs.png',
    ]
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(_homeRoute());
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: ThemeColors.logo,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(50),
                margin: const EdgeInsets.only(bottom: 16),
                child: Image.asset('assets/images/logo.png'),
              ),
              ..._imageRows
                  .map(
                    (images) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: images
                            .map(
                              (img) => Container(
                                alignment: Alignment.center,
                                width: screenWidth / (images.length + 1),
                                child: Image.asset(img),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns the Home page route with a fade transition.
  Route _homeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.ease)),
          child: child,
        );
      },
    );
  }
}
