import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';

class Input extends StatefulWidget {
  const Input({
    Key? key,
    required this.controller,
    this.formatters,
    this.hint,
    this.type,
    this.action,
    this.prefixIcon,
    this.suffix,
    this.height,
    this.label,
    this.onChange,
    this.onSubmit,
    this.outlined = true,
    this.obscure = false,
    this.width = double.maxFinite,
  }) : super(key: key);

  final TextEditingController controller;

  final double width;
  final bool obscure;
  final bool outlined;

  final String? label;
  final double? height;
  final Widget? prefixIcon;
  final Widget? suffix;
  final String? hint;
  final TextInputAction? action;
  final TextInputType? type;
  final Function(String)? onChange;
  final Function(String)? onSubmit;
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
      height: widget.height,
      child: TextField(
        textInputAction: widget.action,
        controller: widget.controller,
        inputFormatters: widget.formatters,
        style: const TextStyle(color: Colors.white),
        cursorColor: ThemeColors.primaryColor,
        keyboardType: widget.type,
        obscureText: _obscure,
        onSubmitted: widget.onSubmit,
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
            contentPadding: EdgeInsets.symmetric(
                horizontal: widget.outlined ? 24 : 4,
                vertical: widget.outlined ? 18 : 10),
            enabledBorder: widget.outlined
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Colors.grey))
                : const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: widget.outlined
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: ThemeColors.primaryColor))
                : UnderlineInputBorder(
                    borderSide: BorderSide(color: ThemeColors.primaryColor)),
            labelText: widget.label,
            labelStyle: const TextStyle(color: Colors.grey),
            floatingLabelStyle: TextStyle(
                color: ThemeColors.primaryColor, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
