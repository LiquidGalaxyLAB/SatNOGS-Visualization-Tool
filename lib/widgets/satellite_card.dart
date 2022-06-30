import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:satnogs_visualization_tool/entities/satellite_entity.dart';
import 'package:satnogs_visualization_tool/enums/satellite_status_enum.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';

class SatelliteCard extends StatelessWidget {
  const SatelliteCard({Key? key, required this.satellite}) : super(key: key);

  final SatelliteEntity satellite;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();

    final screenWidth = MediaQuery.of(context).size.width;

    final satelliteHasDate = satellite.launched.isNotEmpty ||
        satellite.deployed.isNotEmpty ||
        satellite.decayed.isNotEmpty;

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
              Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                            child: Text(
                          satellite.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        )),
                        Text(satellite.getStatusLabel().toUpperCase(),
                            style: TextStyle(
                              color: satellite.status ==
                                      SatelliteStatusEnum.ALIVE
                                  ? ThemeColors.success
                                  : satellite.status == SatelliteStatusEnum.DEAD
                                      ? ThemeColors.alert
                                      : satellite.status ==
                                              SatelliteStatusEnum.FUTURE
                                          ? ThemeColors.info
                                          : ThemeColors.warning,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ))
                      ]),
                  satellite.altNames.isNotEmpty
                      ? Row(
                          children: [
                            Flexible(
                              child: Text(
                                  satellite.altNames.replaceAll('\r\n', ' | '),
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
                    satellite.launched.isNotEmpty
                        ? Row(
                            children: [
                              _buildDateString(satellite.launched, 'Launched')
                            ],
                          )
                        : Container(),
                    satellite.deployed.isNotEmpty
                        ? Row(
                            children: [
                              _buildDateString(satellite.deployed, 'Deployed')
                            ],
                          )
                        : Container(),
                    satellite.decayed.isNotEmpty
                        ? Row(
                            children: [
                              _buildDateString(satellite.decayed, 'Decayed')
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
                      satellite.noradId != null
                          ? satellite.noradId.toString()
                          : '-',
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
                        print('view in galaxy: ${satellite.name}');
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
