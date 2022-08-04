import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:satnogs_visualization_tool/entities/ground_station_entity.dart';
import 'package:satnogs_visualization_tool/enums/ground_station_status_enum.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';

class GroundStationCard extends StatefulWidget {
  const GroundStationCard({
    Key? key,
    required this.groundStation,
    required this.selected,
    required this.onOrbit,
    required this.onView,
  }) : super(key: key);

  final bool selected;
  final GroundStationEntity groundStation;
  final Function(bool) onOrbit;
  final Function(GroundStationEntity) onView;

  @override
  State<GroundStationCard> createState() => _GroundStationCardState();
}

class _GroundStationCardState extends State<GroundStationCard> {
  bool _orbiting = false;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();

    final screenWidth = MediaQuery.of(context).size.width;

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
                          fontSize: 20),
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
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                      color: ThemeColors.primaryColor,
                    ),
                    label: Text(
                      widget.selected
                          ? (_orbiting ? 'STOP ORBIT' : 'ORBIT')
                          : 'VIEW IN GALAXY',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    onPressed: () {
                      if (widget.selected) {
                        widget.onOrbit(!_orbiting);

                        setState(() {
                          _orbiting = !_orbiting;
                        });

                        return;
                      }

                      widget.onView(widget.groundStation);
                    },
                  )
                ],
              )
            ],
          ),
        ));
  }
}
