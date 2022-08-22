import 'package:flutter/material.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    Key? key,
    this.onCancel,
    required this.title,
    required this.message,
    required this.onConfirm,
  }) : super(key: key);

  final String title;
  final String message;
  final Function onConfirm;
  final Function? onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: ThemeColors.primaryColor),
          ),
        ],
      ),
      backgroundColor: ThemeColors.backgroundColor,
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          child: const Text(
            'CANCEL',
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: () {
            if (onCancel != null) {
              onCancel!();
            }
          },
        ),
        TextButton(
          child: Text(
            'YES',
            style: TextStyle(color: ThemeColors.primaryColor),
          ),
          onPressed: () {
            onConfirm();
          },
        ),
      ],
    );
  }
}
