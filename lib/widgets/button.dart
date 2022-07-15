import 'package:flutter/material.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';

class Button extends StatefulWidget {
  const Button(
      {Key? key,
      this.height,
      this.icon,
      this.color,
      this.labelColor,
      this.label = 'Label',
      this.width = double.maxFinite,
      this.loading = false,
      required this.onPressed})
      : super(key: key);

  final String label;
  final double width;
  final Function onPressed;
  final bool loading;

  final Color? color;
  final Color? labelColor;
  final double? height;
  final Icon? icon;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        height: widget.height,
        child: ElevatedButton(
          onPressed: () {
            if (!widget.loading) {
              widget.onPressed();
            }
          },
          child: Row(
            mainAxisAlignment: widget.icon != null
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              Text(widget.label.toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              !widget.loading
                  ? widget.icon ?? Container()
                  : const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 3))
            ],
          ),
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.height ?? 50))),
              foregroundColor: MaterialStateProperty.all(
                  widget.labelColor ?? ThemeColors.backgroundColor),
              backgroundColor: MaterialStateProperty.all(
                  widget.color ?? ThemeColors.primaryColor)),
        ));
  }
}
