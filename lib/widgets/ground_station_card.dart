import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:satnogs_visualization_tool/entities/ground_station_entity.dart';
import 'package:satnogs_visualization_tool/enums/ground_station_status_enum.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';

class GroundStationCard extends StatelessWidget {
  const GroundStationCard({Key? key, required this.groundStation})
      : super(key: key);

  final GroundStationEntity groundStation;

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
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Text(
                      groundStation.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    )),
                    Text(groundStation.getStatusLabel().toUpperCase(),
                        style: TextStyle(
                          color: groundStation.status ==
                                  GroundStationStatusEnum.ONLINE
                              ? ThemeColors.success
                              : groundStation.status ==
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
                        Text('Latitude: ${groundStation.lat}',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Longitude: ${groundStation.lng}',
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
                    groundStation.id.toString(),
                    style: TextStyle(
                        color: ThemeColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: const Size(120, 24)),
                    icon: Icon(
                      Icons.travel_explore_rounded,
                      color: ThemeColors.primaryColor,
                    ),
                    label: const Text(
                      'VIEW IN GALAXY',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    onPressed: () {
                      print('view in galaxy: ${groundStation.name}');
                    },
                  )
                ],
              )
            ],
          ),
        ));
  }
}
