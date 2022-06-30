import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:satnogs_visualization_tool/entities/ground_station_entity.dart';
import 'package:satnogs_visualization_tool/entities/satellite_entity.dart';
import 'package:satnogs_visualization_tool/screens/settings.dart';
import 'package:satnogs_visualization_tool/services/ground_station_service.dart';
import 'package:satnogs_visualization_tool/services/satellite_service.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';
import 'package:satnogs_visualization_tool/views/data_list.dart';
import 'package:satnogs_visualization_tool/widgets/data_amount.dart';
import 'package:satnogs_visualization_tool/widgets/ground_station_card.dart';
import 'package:satnogs_visualization_tool/widgets/input.dart';
import 'package:satnogs_visualization_tool/widgets/satellite_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SatelliteService get _satelliteService => GetIt.I<SatelliteService>();
  GroundStationService get _groundStationService =>
      GetIt.I<GroundStationService>();

  final TextEditingController _satellitesController = TextEditingController();

  List<SatelliteEntity> _satellites = [];
  List<GroundStationEntity> _groundStations = [];

  @override
  void initState() {
    super.initState();

    _loadSatellites();
    _loadGroundStations();
  }

  Future<void> _loadSatellites() async {
    // TODO: implement satellite loading

    final List<SatelliteEntity> list = [];

    final sat1 = await _satelliteService.getOne('EFAY-8089-9221-6385-2409');
    list.add(sat1);

    final sat2 = await _satelliteService.getOne('SCHX-0895-2361-9925-0309');
    list.add(sat2);

    final sat3 = await _satelliteService.getOne('UESX-7919-5228-5020-3244');
    list.add(sat3);

    final sat4 = await _satelliteService.getOne('BDAD-5123-3691-7989-4312');
    list.add(sat4);

    final sat5 = await _satelliteService.getOne('AMQV-8272-4458-8097-5541');
    list.add(sat5);

    final sat6 = await _satelliteService.getOne('UQOW-0891-3949-6041-9698');
    list.add(sat6);

    final sat7 = await _satelliteService.getOne('GKGO-8867-1154-9953-5426');
    list.add(sat7);

    final sat8 = await _satelliteService.getOne('PEOD-7224-7918-2978-4352');
    list.add(sat8);

    final sat9 = await _satelliteService.getOne('LUNR-6930-6214-4841-5140');
    list.add(sat9);

    setState(() {
      _satellites = list;
    });
  }

  Future<void> _loadGroundStations() async {
    // TODO: implement ground station loading

    final List<GroundStationEntity> list = [];

    final gs1 = await _groundStationService.getOne(2);
    list.add(gs1);

    final gs2 = await _groundStationService.getOne(256);
    list.add(gs2);

    final gs3 = await _groundStationService.getOne(1594);
    list.add(gs3);

    final gs4 = await _groundStationService.getOne(1);
    list.add(gs4);

    final gs5 = await _groundStationService.getOne(6);
    list.add(gs5);

    final gs6 = await _groundStationService.getOne(37);
    list.add(gs6);

    final gs7 = await _groundStationService.getOne(1062);
    list.add(gs7);

    final gs8 = await _groundStationService.getOne(1775);
    list.add(gs8);

    final gs9 = await _groundStationService.getOne(1538);
    list.add(gs9);

    setState(() {
      _groundStations = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SatNOGS Visualization Tool'),
        shadowColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  splashRadius: 24,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()));
                  }))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                // TODO: show real data amount
                DataAmount(label: 'satellites', amount: 848),
                DataAmount(label: 'transmitters', amount: 1551),
                DataAmount(label: 'stations', amount: 957),
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildListTitleRow(
                        'Satellites', Icons.satellite_alt_rounded),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: _buildFilterRow(
                          _satellitesController, 'Search by name', () {}),
                    ),
                    Expanded(
                        child: DataList(
                      items: _satellites
                          .map((s) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: SatelliteCard(satellite: s),
                              ))
                          .toList(),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildListTitleRow('Ground stations',
                        Icons.settings_input_antenna_rounded),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: _buildFilterRow(
                          _satellitesController, 'Search by name', () {}),
                    ),
                    Expanded(
                        child: DataList(
                      items: _groundStations
                          .map((gs) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: GroundStationCard(groundStation: gs),
                              ))
                          .toList(),
                    ))
                  ],
                ),
              )
            ]),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'View satellite by NORAD id',
        child: const Icon(Icons.manage_search_rounded, size: 28),
        backgroundColor: ThemeColors.primaryColor,
        foregroundColor: ThemeColors.backgroundColor,
        onPressed: () {},
      ),
    );
  }

  /// Builds the list title row, with the icon and title.
  Widget _buildListTitleRow(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: ThemeColors.primaryColor,
        ),
        Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(title,
                style: TextStyle(
                    color: ThemeColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18)))
      ],
    );
  }

  /// Builds the filtering row, with the search bar and filter button.
  Widget _buildFilterRow(TextEditingController controller, String label,
      Function onFilterPressed) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Input(
            controller: controller,
            label: label,
            width: screenWidth >= 768 ? screenWidth / 2 - 24 - 64 : 360 - 64,
          ),
        ),
        SizedBox(
          width: 54,
          height: 54,
          child: ElevatedButton(
            onPressed: () => onFilterPressed(),
            style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(
                    ThemeColors.primaryColor.withOpacity(0.1)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                    side: BorderSide(color: ThemeColors.primaryColor)))),
            child: Icon(Icons.filter_list_rounded,
                color: ThemeColors.primaryColor),
          ),
        )
      ],
    );
  }
}
