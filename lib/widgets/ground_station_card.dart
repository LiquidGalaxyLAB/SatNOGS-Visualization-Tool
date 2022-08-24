import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:satnogs_visualization_tool/entities/ground_station_entity.dart';
import 'package:satnogs_visualization_tool/enums/ground_station_status_enum.dart';
import 'package:satnogs_visualization_tool/screens/ground_station_info.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';

class GroundStationCard extends StatefulWidget {
  const GroundStationCard({
    Key? key,
    required this.groundStation,
    required this.selected,
    required this.onOrbit,
    required this.onBalloonToggle,
    required this.onView,
    required this.disabled,
  }) : super(key: key);

  final bool selected;
  final bool disabled;
  final GroundStationEntity groundStation;

  final Function(bool) onOrbit;
  final Function(bool) onBalloonToggle;
  final Function(GroundStationEntity) onView;

  @override
  State<GroundStationCard> createState() => _GroundStationCardState();
}

class _GroundStationCardState extends State<GroundStationCard> {
  bool _orbiting = false;
  bool _balloonVisible = true;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();

    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: () {
        if (widget.disabled) {
          return;
        }

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              GroundStationInfoPage(groundStation: widget.groundStation),
        ));
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
        elevation: MaterialStateProperty.all(0),
      ),
      child: Container(
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
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Text(
                      widget.groundStation.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    )),
                    Text(widget.groundStation.getStatusLabel().toUpperCase(),
                        style: TextStyle(
                          color: widget.groundStation.status ==
                                  GroundStationStatusEnum.ONLINE
                              ? ThemeColors.success
                              : widget.groundStation.status ==
                                      GroundStationStatusEnum.OFFLINE
                                  ? ThemeColors.alert
                                  : ThemeColors.warning,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ))
                  ]),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Latitude: ${widget.groundStation.lat}',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Longitude: ${widget.groundStation.lng}',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.groundStation.id.toString(),
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

                      widget.onView(widget.groundStation);

                      setState(() {
                        _orbiting = false;
                        _balloonVisible = true;
                      });
                    },
                  )
                ],
              ),
              widget.selected
                  ? Row(
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
                                    _orbiting = false;
                                  });

                                  widget.onBalloonToggle(value);
                                },
                        )
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
