import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:satnogs_visualization_tool/entities/ground_station_entity.dart';
import 'package:satnogs_visualization_tool/entities/satellite_entity.dart';
import 'package:satnogs_visualization_tool/entities/transmitter_entity.dart';
import 'package:satnogs_visualization_tool/screens/settings.dart';
import 'package:satnogs_visualization_tool/services/ground_station_service.dart';
import 'package:satnogs_visualization_tool/services/satellite_service.dart';
import 'package:satnogs_visualization_tool/services/transmitter_service.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';
import 'package:satnogs_visualization_tool/views/data_list.dart';
import 'package:satnogs_visualization_tool/widgets/data_amount.dart';
import 'package:satnogs_visualization_tool/widgets/input.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SatelliteService get _satelliteService => GetIt.I<SatelliteService>();
  TransmitterService get _transmitterService => GetIt.I<TransmitterService>();
  GroundStationService get _groundStationService =>
      GetIt.I<GroundStationService>();

  final TextEditingController _satellitesController = TextEditingController();

  List<SatelliteEntity> _satellites = [];
  List<TransmitterEntity> _transmitters = [];
  List<GroundStationEntity> _groundStations = [];

  bool _loadingSatellites = false;
  bool _loadingStations = false;

  @override
  void initState() {
    super.initState();

    _loadSatellites(false);
    _loadGroundStations(false);
    _loadTransmitters(false);
  }

  Future<void> _loadSatellites(bool synchronize) async {
    setState(() {
      _loadingSatellites = true;
    });

    final List<SatelliteEntity> list =
        await _satelliteService.getMany(synchronize: synchronize);

    setState(() {
      _satellites = list;
      _loadingSatellites = false;
    });
  }

  Future<void> _loadTransmitters(bool synchronize) async {
    final List<TransmitterEntity> list =
        await _transmitterService.getMany(synchronize: synchronize);

    setState(() {
      _transmitters = list;
    });
  }

  Future<void> _loadGroundStations(bool synchronize) async {
    setState(() {
      _loadingStations = true;
    });

    final List<GroundStationEntity> list =
        await _groundStationService.getMany(synchronize: synchronize);

    setState(() {
      _groundStations = list;
      _loadingStations = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SatNOGS Visualization Tool'),
        shadowColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.cloud_sync_rounded, color: ThemeColors.warning),
              splashRadius: 24,
              onPressed: () {
                _loadSatellites(true);
                _loadGroundStations(true);
                _loadTransmitters(true);
              }),
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
              children: [
                DataAmount(label: 'satellites', amount: _satellites.length),
                DataAmount(label: 'transmitters', amount: _transmitters.length),
                DataAmount(label: 'stations', amount: _groundStations.length),
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
                    _loadingSatellites
                        ? SizedBox(
                            width:
                                screenWidth >= 768 ? screenWidth / 2 - 24 : 360,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                      color: ThemeColors.primaryColor)
                                ]),
                          )
                        : Expanded(
                            child: SizedBox(
                            width:
                                screenWidth >= 768 ? screenWidth / 2 - 24 : 360,
                            child: DataList(
                              items: _satellites,
                              render: 'satellite',
                            ),
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
                    _loadingStations
                        ? SizedBox(
                            width:
                                screenWidth >= 768 ? screenWidth / 2 - 24 : 360,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                      color: ThemeColors.primaryColor)
                                ]),
                          )
                        : Expanded(
                            child: SizedBox(
                            width:
                                screenWidth >= 768 ? screenWidth / 2 - 24 : 360,
                            child: DataList(
                                items: _groundStations, render: 'station'),
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
                color: ThemeColors.primaryColor, size: 30),
          ),
        )
      ],
    );
  }
}
