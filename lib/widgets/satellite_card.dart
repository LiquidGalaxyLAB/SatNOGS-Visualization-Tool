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
    required this.onBalloonToggle,
    required this.onOrbitPeriodChange,
    required this.onView,
    required this.disabled,
  }) : super(key: key);

  final bool selected;
  final bool disabled;
  final SatelliteEntity satellite;

  final Function(bool) onOrbit;
  final Function(bool) onBalloonToggle;
  final Function(SatelliteEntity) onView;
  final Function(double) onOrbitPeriodChange;

  @override
  State<SatelliteCard> createState() => _SatelliteCardState();
}

class _SatelliteCardState extends State<SatelliteCard> {
  bool _orbiting = false;
  bool _balloonVisible = true;

  double _orbitPeriod = 2.8;

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
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              child: Text(
                            widget.satellite.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
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
                  ),
                  widget.satellite.altNames.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                    widget.satellite.altNames
                                        .replaceAll('\r\n', ' | '),
                                    style: const TextStyle(color: Colors.grey)),
                              )
                            ],
                          ))
                      : Container(),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: satelliteHasDate ? 16 : 0,
                  bottom: satelliteHasDate ? 4 : 0,
                  left: 16,
                  right: 16,
                ),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        fontSize: 18,
                      ),
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
                      onPressed: () async {
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

                        setState(() {
                          _orbiting = false;
                          _balloonVisible = true;
                          _orbitPeriod = 2.8;
                        });
                      },
                    )
                  ],
                ),
              ),
              !widget.selected
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Balloon visibility',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Switch(
                            value: _balloonVisible,
                            activeColor: ThemeColors.primaryColor,
                            activeTrackColor:
                                ThemeColors.primaryColor.withOpacity(0.6),
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey.withOpacity(0.6),
                            onChanged: widget.disabled
                                ? null
                                : (value) {
                                    setState(() {
                                      _balloonVisible = value;
                                    });

                                    widget.onBalloonToggle(value);
                                  },
                          )
                        ],
                      )),
              !widget.selected
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Orbit period (h)',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                disabledActiveTrackColor: Colors.grey,
                                disabledThumbColor: Colors.grey.shade400,
                                disabledInactiveTrackColor:
                                    Colors.grey.withOpacity(0.5),
                              ),
                              child: Slider(
                                value: _orbitPeriod,
                                min: 1,
                                max: 10,
                                divisions: 100,
                                activeColor:
                                    ThemeColors.primaryColor.withOpacity(0.8),
                                thumbColor: ThemeColors.primaryColor,
                                inactiveColor: Colors.grey.withOpacity(0.8),
                                label: _orbitPeriod.toStringAsFixed(1),
                                onChanged: widget.disabled
                                    ? null
                                    : (value) {
                                        setState(() {
                                          _orbitPeriod = value;
                                        });
                                      },
                                onChangeEnd: (value) {
                                  setState(() {
                                    _orbitPeriod = value;
                                  });

                                  widget.onOrbitPeriodChange(value);
                                },
                              ),
                            ),
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
