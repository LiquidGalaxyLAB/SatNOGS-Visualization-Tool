import 'package:flutter/material.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({Key? key, required this.message, required this.onConfirm})
      : super(key: key);

  final String message;
  final Function onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Oops...',
            style: TextStyle(color: ThemeColors.alert),
          ),
          Icon(
            Icons.error_outline_rounded,
            color: ThemeColors.alert,
          ),
        ],
      ),
      backgroundColor: ThemeColors.backgroundColor,
      content: Text(message, style: const TextStyle(color: Colors.white)),
      actions: [
        TextButton(
          child: Text('OK', style: TextStyle(color: ThemeColors.alert)),
          onPressed: () {
            onConfirm();
          },
        )
      ],
    );
  }
}
