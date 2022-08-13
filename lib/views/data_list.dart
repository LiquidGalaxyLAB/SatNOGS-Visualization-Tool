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
    this.onSatelliteView,
    this.onSatelliteSimulate,
    this.onSatelliteBalloonToggle,
    this.onSatelliteOrbitPeriodChange,
    this.onStationOrbit,
    this.onStationView,
    this.onStationBalloonToggle,
    this.disabled,
  }) : super(key: key);

  final List<dynamic> items;
  final String render;
  final Map<String, dynamic> selected;

  final Function(bool)? onSatelliteOrbit;
  final Function(bool)? onSatelliteSimulate;
  final Function(SatelliteEntity)? onSatelliteView;
  final Function(SatelliteEntity, bool)? onSatelliteBalloonToggle;
  final Function(SatelliteEntity, double)? onSatelliteOrbitPeriodChange;
  final bool? disabled;

  final Function(bool)? onStationOrbit;
  final Function(GroundStationEntity, bool)? onStationBalloonToggle;
  final Function(GroundStationEntity)? onStationView;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                  disabled: disabled ?? false,
                  onOrbitPeriodChange: (value) {
                    onSatelliteOrbitPeriodChange!(items[index], value);
                  },
                  onBalloonToggle: (value) {
                    onSatelliteBalloonToggle!(items[index], value);
                  },
                  onOrbit: (value) {
                    onSatelliteOrbit!(value);
                  },
                  onSimulate: (value) {
                    onSatelliteSimulate!(value);
                  },
                  onView: (satellite) {
                    onSatelliteView!(satellite);
                  },
                )
              : GroundStationCard(
                  groundStation: items[index],
                  selected: items[index].id == selected['station'],
                  disabled: disabled ?? false,
                  onBalloonToggle: (value) {
                    onStationBalloonToggle!(items[index], value);
                  },
                  onOrbit: (value) {
                    onStationOrbit!(value);
                  },
                  onView: (station) {
                    onStationView!(station);
                  },
                ),
        );
      },
    );
    //   ],
    // );
  }
}
