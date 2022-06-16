import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';

class Input extends StatefulWidget {
  const Input(
      {Key? key,
      required this.controller,
      this.formatters,
      this.hint,
      this.label = 'Enter text',
      this.width = double.maxFinite,
      this.onChange})
      : super(key: key);

  final TextEditingController controller;
  final List<TextInputFormatter>? formatters;

  final String label;
  final double width;
  final String? hint;
  final Function(String)? onChange;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  final maxWidth = 400.0;

  @override
  void initState() {
    super.initState();

    if (widget.onChange != null) {
      widget.controller.addListener(() {
        widget.onChange!(widget.controller.text);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width > maxWidth ? maxWidth : widget.width,
      child: TextField(
        controller: widget.controller,
        inputFormatters: widget.formatters,
        style: const TextStyle(color: Colors.white),
        cursorColor: ThemeColors.primaryColor,
        decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(color: ThemeColors.primaryColor)),
            labelText: widget.label,
            labelStyle: const TextStyle(color: Colors.grey),
            floatingLabelStyle: TextStyle(
                color: ThemeColors.primaryColor, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
