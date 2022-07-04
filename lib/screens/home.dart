import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:satnogs_visualization_tool/entities/ground_station_entity.dart';
import 'package:satnogs_visualization_tool/entities/satellite_entity.dart';
import 'package:satnogs_visualization_tool/entities/transmitter_entity.dart';
import 'package:satnogs_visualization_tool/enums/ground_station_status_enum.dart';
import 'package:satnogs_visualization_tool/enums/satellite_status_enum.dart';
import 'package:satnogs_visualization_tool/screens/settings.dart';
import 'package:satnogs_visualization_tool/services/ground_station_service.dart';
import 'package:satnogs_visualization_tool/services/satellite_service.dart';
import 'package:satnogs_visualization_tool/services/transmitter_service.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';
import 'package:satnogs_visualization_tool/views/data_list.dart';
import 'package:satnogs_visualization_tool/widgets/data_amount.dart';
import 'package:satnogs_visualization_tool/widgets/input.dart';
import 'package:satnogs_visualization_tool/widgets/modals/ground_station_filter_modal.dart';
import 'package:satnogs_visualization_tool/widgets/modals/satellite_filter_modal.dart';

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

  final TextEditingController _satellitesSearchController =
      TextEditingController();
  final TextEditingController _groundStationsSearchController =
      TextEditingController();

  List<SatelliteEntity> _satellites = [];
  List<TransmitterEntity> _transmitters = [];
  List<GroundStationEntity> _groundStations = [];

  Map<String, dynamic>? _satelliteFilters;
  List<SatelliteEntity> _filteredSatellites = [];

  Map<String, dynamic>? _groundStationFilters;
  List<GroundStationEntity> _filteredGroundStations = [];

  bool _loadingSatellites = false;
  bool _loadingTransmitters = false;
  bool _loadingStations = false;

  bool get _loading =>
      _loadingSatellites || _loadingTransmitters || _loadingStations;

  @override
  void initState() {
    super.initState();

    _loadSatellites(false);
    _loadGroundStations(false);
    _loadTransmitters(false);
  }

  /// Loads all satellites from the local storage or database based on the
  /// [synchronize] param.
  Future<void> _loadSatellites(bool synchronize) async {
    setState(() {
      _loadingSatellites = true;
    });

    final List<SatelliteEntity> list =
        await _satelliteService.getMany(synchronize: synchronize);

    setState(() {
      _satellites = list;
      _filteredSatellites = [...list];
      _loadingSatellites = false;
    });
  }

  /// Loads all transmitters from the local storage or database based on the
  /// [synchronize] param.
  Future<void> _loadTransmitters(bool synchronize) async {
    setState(() {
      _loadingTransmitters = true;
    });

    final List<TransmitterEntity> list =
        await _transmitterService.getMany(synchronize: synchronize);

    setState(() {
      _transmitters = list;
      _loadingTransmitters = false;
    });
  }

  /// Loads all ground stations from the local storage or database based on the
  /// [synchronize] param.
  Future<void> _loadGroundStations(bool synchronize) async {
    setState(() {
      _loadingStations = true;
    });

    final List<GroundStationEntity> list =
        await _groundStationService.getMany(synchronize: synchronize);

    setState(() {
      _groundStations = list;
      _filteredGroundStations = [...list];
      _loadingStations = false;
    });
  }

  /// Searches through the satellites using the given [query].
  ///
  /// It uses the satellites [name], [altNames] and [noradId].
  void _searchSatellites(String query, List<SatelliteEntity> satellites) {
    final lQuery = query.toLowerCase();

    setState(() {
      _filteredSatellites = satellites
          .where((element) =>
              element.name.toLowerCase().contains(lQuery) ||
              element.altNames.toLowerCase().contains(lQuery) ||
              element.noradId.toString().contains(lQuery))
          .toList();
    });
  }

  /// Filters the satellites based on the given [filters].
  void _filterSatellites(Map<String, dynamic> filters) {
    setState(() {
      _satelliteFilters = filters;
    });

    List<SatelliteEntity> sats = [..._satellites];

    final status = filters['status'] as SatelliteStatusEnum?;
    final satOperator = filters['operator'] as String?;
    final countries = filters['countries'] as List<dynamic>?;
    final decayed = filters['decayed'] as bool?;
    final launched = filters['launched'] as bool?;
    final deployed = filters['deployed'] as bool?;

    if (status != null) {
      sats.removeWhere((element) => element.status != status);
    }

    if (satOperator != null && satOperator.isNotEmpty) {
      sats = sats
          .where((element) => element.satOperator.contains(satOperator))
          .toList();
    }

    if (countries != null && countries.isNotEmpty) {
      for (String c in countries) {
        sats = sats
            .where((element) => element.countries.toLowerCase().contains(c))
            .toList();
      }
    }

    if (decayed != null && decayed) {
      sats.removeWhere((element) => element.decayed.isEmpty);
    }

    if (launched != null && launched) {
      sats.removeWhere((element) => element.launched.isEmpty);
    }

    if (deployed != null && deployed) {
      sats.removeWhere((element) => element.deployed.isEmpty);
    }

    _searchSatellites(_satellitesSearchController.text, sats);
  }

  /// Searches through the ground stations using the given [query].
  ///
  /// It uses the ground stations [name] and [id].
  void _searchGroundStations(String query, List<GroundStationEntity> stations) {
    final lQuery = query.toLowerCase();

    setState(() {
      _filteredGroundStations = stations
          .where((element) =>
              element.name.toLowerCase().contains(lQuery) ||
              element.id.toString().contains(lQuery))
          .toList();
    });
  }

  /// Filters the ground stations based on the given [filters].
  void _filterGroundStations(Map<String, dynamic> filters) {
    setState(() {
      _groundStationFilters = filters;
    });

    List<GroundStationEntity> stations = [..._groundStations];

    final status = filters['status'] as GroundStationStatusEnum?;
    final lat = filters['latitude'] as String?;
    final lng = filters['longitude'] as String?;

    final regex = RegExp('\\.\\\\?(.*)');

    if (status != null) {
      stations.removeWhere((element) => element.status != status);
    }

    if (lat != null && lat.isNotEmpty && !lat.contains(RegExp('[^0-9-\\.,]'))) {
      stations = stations
          .where((element) =>
              double.parse(element.lat
                      .toString()
                      .replaceAll(regex, '')
                      .replaceAll(regex, ''))
                  .round() ==
              double.parse(lat.replaceAll(',', '.')).round())
          .toList();
    }

    if (lng != null && lng.isNotEmpty && !lng.contains(RegExp('[^0-9-\\.,]'))) {
      stations = stations
          .where((element) =>
              double.parse(element.lng.toString().replaceAll(regex, ''))
                  .round() ==
              double.parse(lng.replaceAll(',', '.').replaceAll(regex, ''))
                  .round())
          .toList();
    }

    _searchGroundStations(_groundStationsSearchController.text, stations);
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
          TextButton.icon(
              icon: Icon(Icons.cloud_sync_rounded,
                  color: _loading ? Colors.grey : ThemeColors.warning),
              label: Text(_loading ? 'SYNCING' : 'SYNC',
                  style: TextStyle(
                      color: _loading ? Colors.grey : ThemeColors.warning,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                if (_loading) {
                  return;
                }

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
                      child:
                          _buildFilterRow(_satellitesSearchController, 'Search',
                              onSubmit: (value) {
                        _filterSatellites(_satelliteFilters ?? {});
                      }, onFilterPressed: () {
                        _showModal(SatelliteFilterModal(
                            initialValue: _satelliteFilters,
                            onClear: () {
                              Navigator.pop(context);

                              _searchSatellites(
                                  _satellitesSearchController.text,
                                  [..._satellites]);

                              setState(() {
                                _satelliteFilters = null;
                              });
                            },
                            onFilter: (Map<String, dynamic> filters) {
                              Navigator.pop(context);

                              _filterSatellites(filters);
                            }));
                      }),
                    ),
                    _loadingSatellites
                        ? _buildSpinner()
                        : Expanded(
                            child: SizedBox(
                            width:
                                screenWidth >= 768 ? screenWidth / 2 - 24 : 360,
                            child: _filteredSatellites.isEmpty
                                ? _buildEmptyMessage('No satellites')
                                : DataList(
                                    items: _filteredSatellites,
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
                          _groundStationsSearchController, 'Search',
                          onSubmit: (value) {
                        _filterGroundStations(_groundStationFilters ?? {});
                      }, onFilterPressed: () {
                        _showModal(GroundStationFilterModal(
                            initialValue: _groundStationFilters,
                            onClear: () {
                              Navigator.pop(context);

                              _searchGroundStations(
                                  _groundStationsSearchController.text,
                                  [..._groundStations]);

                              setState(() {
                                _groundStationFilters = null;
                              });
                            },
                            onFilter: (Map<String, dynamic> filters) {
                              Navigator.pop(context);

                              _filterGroundStations(filters);
                            }));
                      }),
                    ),
                    _loadingStations
                        ? _buildSpinner()
                        : Expanded(
                            child: SizedBox(
                            width:
                                screenWidth >= 768 ? screenWidth / 2 - 24 : 360,
                            child: DataList(
                                items: _filteredGroundStations,
                                render: 'station'),
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

  /// Builds and shows the base modal with the given [content], used by the
  /// filter modals and NORAD id searching.
  void _showModal(Widget content) {
    showModalBottomSheet(
        context: context,
        backgroundColor: ThemeColors.backgroundColor,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        builder: (context) => content);
  }

  /// Builds the filtering row, with the search bar and filter button.
  Widget _buildFilterRow(TextEditingController controller, String label,
      {required Function onFilterPressed, required Function(String) onSubmit}) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Input(
            controller: controller,
            label: label,
            action: TextInputAction.search,
            prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
            width: screenWidth >= 768 ? screenWidth / 2 - 24 - 64 : 360 - 64,
            onSubmit: (value) {
              onSubmit(value);
            },
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

  /// Builds the list empty warn message.
  Widget _buildEmptyMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(
                color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// Builds the spinner container that is used into the satellites and ground
  /// stations lists.
  Widget _buildSpinner() {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth >= 768 ? screenWidth / 2 - 24 : 360,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircularProgressIndicator(color: ThemeColors.primaryColor)
        ]),
      ),
    );
  }
}
