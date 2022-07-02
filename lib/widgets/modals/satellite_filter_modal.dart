import 'package:flutter/material.dart';
import 'package:satnogs_visualization_tool/enums/satellite_status_enum.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';
import 'package:satnogs_visualization_tool/widgets/button.dart';
import 'package:satnogs_visualization_tool/widgets/checkbox.dart';
import 'package:satnogs_visualization_tool/widgets/input.dart';

class SatelliteFilterModal extends StatefulWidget {
  const SatelliteFilterModal(
      {Key? key,
      required this.onFilter,
      required this.onClear,
      this.initialValue})
      : super(key: key);

  final Function onFilter;
  final Function onClear;
  final Map<String, dynamic>? initialValue;

  @override
  State<SatelliteFilterModal> createState() => _SatelliteFilterModalState();
}

class _SatelliteFilterModalState extends State<SatelliteFilterModal> {
  final TextEditingController _operatorController = TextEditingController();
  final TextEditingController _countriesController = TextEditingController();

  SatelliteStatusEnum? _status;
  bool _decayed = false;
  bool _launched = false;
  bool _deployed = false;

  List<dynamic> _countries = [];

  @override
  void initState() {
    if (widget.initialValue != null) {
      _status = widget.initialValue!['status'] ?? _status;
      _decayed = widget.initialValue!['decayed'] ?? _decayed;
      _launched = widget.initialValue!['launched'] ?? _launched;
      _deployed = widget.initialValue!['deployed'] ?? _deployed;
      _countries = widget.initialValue!['countries'] ?? [];
      _operatorController.text = widget.initialValue!['operator'] ?? '';
    }

    super.initState();

    _countriesController.addListener(() {
      if (_countriesController.text.contains(RegExp('[,|\\s]'))) {
        _splitTags(_countriesController.text);
      }
    });
  }

  /// Splits the given [text] based on commas (,) and spaces.
  ///
  /// Sets the [_countries] property and sets the [text] to empty.
  void _splitTags(String text) {
    final splitted = text
        .toLowerCase()
        .split(RegExp('[,|\\s]'))
        .where((element) => element.isNotEmpty);

    setState(() {
      _countries = [..._countries, ...splitted];
      _countriesController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Operator', padding: 13.5),
                          Input(
                            controller: _operatorController,
                            hint: 'Enter text',
                            height: 30,
                            outlined: false,
                          )
                        ],
                      )),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                  Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Status'),
                          DropdownButton(
                            isExpanded: true,
                            value: _status,
                            elevation: 4,
                            hint: const Text('Select'),
                            icon: Icon(Icons.arrow_drop_down_rounded,
                                color: _getStatusColor(_status)),
                            dropdownColor: ThemeColors.backgroundColor,
                            underline: Container(
                                height: 1, color: _getStatusColor(_status)),
                            style: TextStyle(color: ThemeColors.primaryColor),
                            onChanged: (SatelliteStatusEnum? value) {
                              setState(() {
                                _status = value;
                              });
                            },
                            items:
                                [null, ...SatelliteStatusEnum.values].map((s) {
                              return DropdownMenuItem(
                                  value: s,
                                  child: Text(
                                    s != null ? s.name : 'ALL',
                                    style: TextStyle(
                                        color: _getStatusColor(s),
                                        fontWeight: FontWeight.bold),
                                  ));
                            }).toList(),
                          )
                        ],
                      )),
                ],
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCheckbox('Decayed', _decayed, (value) {
                        setState(() {
                          _decayed = value;
                        });
                      }),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCheckbox('Launched', _launched, (value) {
                        setState(() {
                          _launched = value;
                        });
                      }),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCheckbox('Deployed', _deployed, (value) {
                        setState(() {
                          _deployed = value;
                        });
                      }),
                    ],
                  )),
                ],
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Countries'),
                  Wrap(
                    children: _countries
                        .map((t) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: _buildChip(t, onDeleted: () {
                                setState(() {
                                  _countries
                                      .removeWhere((element) => element == t);
                                });
                              }),
                            ))
                        .toList(),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Input(
                        controller: _countriesController,
                        outlined: false,
                        hint: 'Enter initials separated by comma or space',
                      ))
                    ],
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Button(
                label: 'FILTER',
                height: 48,
                onPressed: () {
                  widget.onFilter({
                    'status': _status,
                    'operator': _operatorController.text,
                    'countries': [..._countries],
                    'decayed': _decayed,
                    'launched': _launched,
                    'deployed': _deployed,
                  });
                }),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: keyboardPadding, top: 16),
            child: Button(
                label: 'CLEAR',
                height: 48,
                color: ThemeColors.warning,
                onPressed: () {
                  widget.onClear();
                }),
          )
        ],
      ),
    );
  }

  /// Builds the checkbox picker with label.
  Widget _buildCheckbox(String label, bool value, Function onChanged) {
    return Row(
      children: [
        _buildSectionTitle(label, padding: 0),
        SNCheckbox(
          value: value,
          onChanged: (v) {
            onChanged(v);
          },
        )
      ],
    );
  }

  /// Builds the section title, returning a [Text].
  Widget _buildSectionTitle(String title, {double padding = 4}) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: Text(title,
          style:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
    );
  }

  /// Gets a [Color] that represents the given [status].
  Color _getStatusColor(SatelliteStatusEnum? status) {
    switch (status) {
      case SatelliteStatusEnum.ALIVE:
        return ThemeColors.success;
      case SatelliteStatusEnum.DEAD:
        return ThemeColors.alert;
      case SatelliteStatusEnum.RE_ENTERED:
        return ThemeColors.warning;
      case SatelliteStatusEnum.FUTURE:
        return ThemeColors.info;
      default:
        return Colors.grey;
    }
  }

  /// Builds a [Chip] to be used to show the countries.
  Widget _buildChip(String label, {required Function onDeleted}) {
    return Chip(
      elevation: 0,
      side: BorderSide(color: ThemeColors.primaryColor),
      backgroundColor: ThemeColors.primaryColor.withOpacity(0.1),
      label: Text(
        label.toUpperCase(),
        style: TextStyle(
            color: ThemeColors.primaryColor, fontWeight: FontWeight.bold),
      ),
      deleteIcon: Icon(
        Icons.close_rounded,
        color: ThemeColors.primaryColor,
        size: 18,
      ),
      onDeleted: () {
        onDeleted();
      },
    );
  }
}
