import 'package:flutter/material.dart';
import 'package:satnogs_visualization_tool/entities/ground_station_entity.dart';
import 'package:satnogs_visualization_tool/entities/satellite_entity.dart';
import 'package:satnogs_visualization_tool/widgets/ground_station_card.dart';
import 'package:satnogs_visualization_tool/widgets/satellite_card.dart';

class DataList extends StatelessWidget {
  const DataList({
    Key? key,
    required this.items,
    required this.render,
    required this.selected,
    this.onSatelliteOrbit,
    this.onStationOrbit,
    this.onSatelliteView,
    this.onStationView,
  }) : super(key: key);

  final List<dynamic> items;
  final String render;
  final Map<String, dynamic> selected;

  final Function(bool)? onSatelliteOrbit;
  final Function(bool)? onStationOrbit;

  final Function(SatelliteEntity)? onSatelliteView;
  final Function(GroundStationEntity)? onStationView;

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
              ? SatelliteCard(
                  satellite: items[index],
                  selected: items[index].id == selected['satellite'],
                  onOrbit: (value) {
                    onSatelliteOrbit!(value);
                  },
                  onView: (satellite) {
                    if (onSatelliteView != null) {
                      onSatelliteView!(satellite);
                    }
                  },
                )
              : GroundStationCard(
                  groundStation: items[index],
                  selected: items[index].id == selected['station'],
                  onOrbit: (value) {
                    onStationOrbit!(value);
                  },
                  onView: (station) {
                    if (onStationView != null) {
                      onStationView!(station);
                    }
                  },
                ),
        );
      },
    );
    //   ],
    // );
  }
}
