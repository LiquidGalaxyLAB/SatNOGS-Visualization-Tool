import 'package:flutter/material.dart';
import 'package:satnogs_visualization_tool/widgets/ground_station_card.dart';
import 'package:satnogs_visualization_tool/widgets/satellite_card.dart';

class DataList extends StatelessWidget {
  const DataList({Key? key, required this.items, required this.render})
      : super(key: key);

  final List<dynamic> items;
  final String render;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 48),
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: render == 'satellite'
              ? SatelliteCard(satellite: items[index])
              : GroundStationCard(groundStation: items[index]),
        );
      },
    );
    //   ],
    // );
  }
}
