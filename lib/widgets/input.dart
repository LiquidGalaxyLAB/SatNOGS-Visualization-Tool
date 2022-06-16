import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';

class Input extends StatefulWidget {
  const Input(
      {Key? key,
      required this.controller,
      this.formatters,
      this.hint,
      this.type,
      this.prefixIcon,
      this.suffix,
      this.obscure = false,
      this.label = 'Enter text',
      this.width = double.maxFinite,
      this.onChange})
      : super(key: key);

  final TextEditingController controller;

  final String label;
  final double width;
  final bool obscure;

  final Widget? prefixIcon;
  final Widget? suffix;
  final String? hint;
  final TextInputType? type;
  final Function(String)? onChange;
  final List<TextInputFormatter>? formatters;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  final maxWidth = 400.0;

  bool _obscure = false;

  @override
  void initState() {
    _obscure = widget.obscure;

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
        keyboardType: widget.type,
        obscureText: _obscure,
        decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            suffixIcon: !widget.obscure
                ? widget.suffix
                : Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: IconButton(
                      icon: Icon(
                        !_obscure
                            ? Icons.lock_open_rounded
                            : Icons.lock_outline_rounded,
                        color: ThemeColors.primaryColor,
                      ),
                      splashRadius: 24,
                      onPressed: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                    )),
            hintText: _obscure ? '••••••••' : widget.hint,
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
