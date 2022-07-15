import 'package:flutter/material.dart';
import 'package:satnogs_visualization_tool/enums/ground_station_status_enum.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';
import 'package:satnogs_visualization_tool/widgets/button.dart';
import 'package:satnogs_visualization_tool/widgets/input.dart';

class GroundStationFilterModal extends StatefulWidget {
  const GroundStationFilterModal(
      {Key? key,
      required this.onFilter,
      required this.onClear,
      this.initialValue})
      : super(key: key);

  final Function onFilter;
  final Function onClear;
  final Map<String, dynamic>? initialValue;

  @override
  State<GroundStationFilterModal> createState() =>
      _GroundStationFilterModalState();
}

class _GroundStationFilterModalState extends State<GroundStationFilterModal> {
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  GroundStationStatusEnum? _status;

  @override
  void initState() {
    if (widget.initialValue != null) {
      _status = widget.initialValue!['status'] ?? _status;
      _latitudeController.text = widget.initialValue!['latitude'] ?? '';
      _longitudeController.text = widget.initialValue!['longitude'] ?? '';
    }

    super.initState();
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
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Latitude', padding: 13.5),
                          Input(
                            controller: _latitudeController,
                            hint: '30',
                            height: 30,
                            outlined: false,
                            type: TextInputType.number,
                          )
                        ],
                      )),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                  Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Longitude', padding: 13.5),
                          Input(
                            controller: _longitudeController,
                            hint: '-74',
                            height: 30,
                            outlined: false,
                            type: TextInputType.number,
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
                            onChanged: (GroundStationStatusEnum? value) {
                              setState(() {
                                _status = value;
                              });
                            },
                            items: [null, ...GroundStationStatusEnum.values]
                                .map((s) {
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
            padding: const EdgeInsets.only(top: 8),
            child: Button(
                label: 'FILTER',
                height: 48,
                onPressed: () {
                  widget.onFilter({
                    'status': _status,
                    'latitude': _latitudeController.text,
                    'longitude': _longitudeController.text,
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
  Color _getStatusColor(GroundStationStatusEnum? status) {
    switch (status) {
      case GroundStationStatusEnum.ONLINE:
        return ThemeColors.success;
      case GroundStationStatusEnum.OFFLINE:
        return ThemeColors.alert;
      case GroundStationStatusEnum.TESTING:
        return ThemeColors.warning;
      default:
        return Colors.grey;
    }
  }
}
