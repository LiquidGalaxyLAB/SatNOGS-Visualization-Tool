import 'package:flutter/material.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';

class DataAmount extends StatelessWidget {
  const DataAmount({Key? key, this.amount = 0, required this.label})
      : super(key: key);

  final int amount;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          amount.toString(),
          style: TextStyle(
              color: ThemeColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 48),
        ),
        Text(label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ))
      ],
    );
  }
}
