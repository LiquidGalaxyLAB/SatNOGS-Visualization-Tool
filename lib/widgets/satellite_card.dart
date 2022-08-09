import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:satnogs_visualization_tool/entities/satellite_entity.dart';
import 'package:satnogs_visualization_tool/enums/satellite_status_enum.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';

class SatelliteCard extends StatefulWidget {
  const SatelliteCard({
    Key? key,
    required this.satellite,
    required this.selected,
    required this.onOrbit,
    required this.onView,
    required this.disabled,
  }) : super(key: key);

  final bool selected;
  final bool disabled;
  final SatelliteEntity satellite;
  final Function(bool) onOrbit;
  final Function(SatelliteEntity) onView;

  @override
  State<SatelliteCard> createState() => _SatelliteCardState();
}

class _SatelliteCardState extends State<SatelliteCard> {
  bool _orbiting = false;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();

    final screenWidth = MediaQuery.of(context).size.width;

    final satelliteHasDate = widget.satellite.launched.isNotEmpty ||
        widget.satellite.deployed.isNotEmpty ||
        widget.satellite.decayed.isNotEmpty;

    return Container(
        width: screenWidth >= 768 ? screenWidth / 2 - 24 : 360,
        decoration: BoxDecoration(
            color: ThemeColors.card.withOpacity(0.5),
            border: Border.all(color: ThemeColors.cardBorder),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                            child: Text(
                          widget.satellite.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        )),
                        Text(widget.satellite.getStatusLabel().toUpperCase(),
                            style: TextStyle(
                              color: widget.satellite.status ==
                                      SatelliteStatusEnum.ALIVE
                                  ? ThemeColors.success
                                  : widget.satellite.status ==
                                          SatelliteStatusEnum.DEAD
                                      ? ThemeColors.alert
                                      : widget.satellite.status ==
                                              SatelliteStatusEnum.FUTURE
                                          ? ThemeColors.info
                                          : ThemeColors.warning,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ))
                      ]),
                  widget.satellite.altNames.isNotEmpty
                      ? Row(
                          children: [
                            Flexible(
                              child: Text(
                                  widget.satellite.altNames
                                      .replaceAll('\r\n', ' | '),
                                  style: const TextStyle(color: Colors.grey)),
                            )
                          ],
                        )
                      : Container(),
                ],
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: satelliteHasDate ? 16 : 0),
                child: Column(
                  children: [
                    widget.satellite.launched.isNotEmpty
                        ? Row(
                            children: [
                              _buildDateString(
                                  widget.satellite.launched, 'Launched')
                            ],
                          )
                        : Container(),
                    widget.satellite.deployed.isNotEmpty
                        ? Row(
                            children: [
                              _buildDateString(
                                  widget.satellite.deployed, 'Deployed')
                            ],
                          )
                        : Container(),
                    widget.satellite.decayed.isNotEmpty
                        ? Row(
                            children: [
                              _buildDateString(
                                  widget.satellite.decayed, 'Decayed')
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: satelliteHasDate ? 0 : 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.satellite.noradId != null
                          ? widget.satellite.noradId.toString()
                          : '-',
                      style: TextStyle(
                          color: ThemeColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        tapTargetSize: MaterialTapTargetSize.padded,
                        alignment: Alignment.centerRight,
                        minimumSize: const Size(120, 24),
                      ),
                      icon: Icon(
                        widget.selected
                            ? (!_orbiting
                                ? Icons.flip_camera_android_rounded
                                : Icons.stop_rounded)
                            : Icons.travel_explore_rounded,
                        color: widget.disabled
                            ? Colors.grey
                            : ThemeColors.primaryColor,
                      ),
                      label: Text(
                        widget.selected
                            ? (_orbiting ? 'STOP ORBIT' : 'ORBIT')
                            : 'VIEW IN GALAXY',
                        style: TextStyle(
                          color: widget.disabled ? Colors.grey : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () {
                        if (widget.disabled) {
                          return;
                        }

                        if (widget.selected) {
                          widget.onOrbit(!_orbiting);

                          setState(() {
                            _orbiting = !_orbiting;
                          });

                          return;
                        }

                        widget.onView(widget.satellite);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  /// Builds the date string with a preffix.
  ///
  /// Example
  /// ```
  /// const text = _buildDateString('2022-06-29T18:03:32.083Z', 'Launched');
  /// text => Text(
  ///   'Launched June 26, 2022 6:03 PM',
  ///   style: const TextStyle(color: Colors.grey)
  /// )
  /// ```
  Widget _buildDateString(String value, String preffix) {
    final date = DateFormat.yMMMMd('en_US');
    final hour = DateFormat.jm();
    return Text(
        '$preffix ${date.format(DateTime.parse(value))} ${hour.format(DateTime.parse(value))}',
        style: const TextStyle(color: Colors.grey));
  }
}
