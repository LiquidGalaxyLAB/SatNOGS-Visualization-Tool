import 'package:flutter/material.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';

class SNCheckbox extends StatefulWidget {
  const SNCheckbox({Key? key, required this.onChanged, this.value = false})
      : super(key: key);

  final bool value;
  final Function(bool) onChanged;

  @override
  State<SNCheckbox> createState() => _SNCheckboxState();
}

class _SNCheckboxState extends State<SNCheckbox> {
  bool checked = false;

  @override
  void initState() {
    checked = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: ThemeColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      fillColor: MaterialStateProperty.resolveWith((states) {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.pressed,
          MaterialState.selected,
          MaterialState.focused,
        };

        if (states.any(interactiveStates.contains)) {
          return ThemeColors.primaryColor;
        }

        return Colors.grey;
      }),
      value: checked,
      onChanged: (value) {
        setState(() {
          checked = value!;
        });

        widget.onChanged(value!);
      },
    );
  }
}
