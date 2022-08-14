import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:satnogs_visualization_tool/entities/ground_station_entity.dart';
import 'package:satnogs_visualization_tool/enums/ground_station_status_enum.dart';
import 'package:satnogs_visualization_tool/services/ground_station_service.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';
import 'package:satnogs_visualization_tool/widgets/svt_icons.dart';

class GroundStationInfoPage extends StatefulWidget {
  const GroundStationInfoPage({
    Key? key,
    required this.groundStation,
  }) : super(key: key);

  final GroundStationEntity groundStation;

  @override
  State<GroundStationInfoPage> createState() => _GroundStationInfoPageState();
}

class _GroundStationInfoPageState extends State<GroundStationInfoPage> {
  GroundStationService get _groundStationService =>
      GetIt.I<GroundStationService>();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _online = false;

  bool _loading = false;

  Map<String, dynamic>? _extra;

  @override
  void initState() {
    super.initState();
    _initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  /// Set the connectivity status when loading the screen.
  Future<void> _initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (_) {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    _updateConnectionStatus(result);
  }

  /// Updates the connectivity status according to the user network.
  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _online = result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi;
    });

    if (_extra != null || !_online) {
      return;
    }

    _loadGroundStationExtraInfo();
  }

  /// Loads the ground station extra data if there's a connection with the
  /// internet.
  void _loadGroundStationExtraInfo() async {
    setState(() {
      _loading = true;
    });

    try {
      final extra = await _groundStationService.getOne(widget.groundStation.id);
      setState(() {
        _extra = extra;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final station = widget.groundStation;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(station.name),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(SVT.satellite_dish),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: _buildInfoSection(
                      'ID',
                      station.id.toString(),
                      padding: false,
                    ),
                  ),
                  _buildStationStatus(),
                ],
              ),
              _buildInfoSection('Name', station.name),
              _buildInfoSection(
                'Location (lon, lat)',
                '${station.lng}°, ${station.lat}°',
              ),
              ...(_loading
                  ? [
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: ThemeColors.primaryColor,
                                strokeWidth: 3,
                              ),
                            ),
                          ],
                        ),
                      )
                    ]
                  : _buildExtraInfoSections()),
              _online || _extra != null ? Container() : _buildOffline(),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns a list of all the extra info sections.
  List<Widget> _buildExtraInfoSections() {
    return _extra == null
        ? [Container()]
        : _extra!.entries
            .where((e) => e.key != 'Coordinates(lat, lon)')
            .map((e) => _buildInfoSection(
                e.key, '${e.value}'.replaceAll(RegExp('[\r\n]'), '').trim()))
            .toList();
  }

  /// Builds an informational section (title and description).
  Widget _buildInfoSection(
    String title,
    String info, {
    bool padding = true,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: padding ? 16 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title),
          Row(
            children: [
              Flexible(
                child: Text(
                  info.isEmpty ? '-' : info,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the section title according to the given [title].
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    );
  }

  /// Builds a widget that is show in case the device is offline.
  Widget _buildOffline() {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    color: ThemeColors.warning,
                    size: 40,
                  ),
                ),
                Flexible(
                  child: Text(
                    'Connect to the internet to be able to see more information about this Ground Station',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ThemeColors.warning,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the ground station status widget.
  Widget _buildStationStatus() {
    final statusData = _getStatusData();

    return Flexible(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              statusData['icon'],
              color: statusData['color'],
            ),
          ),
          Text(
            statusData['title'],
            style: TextStyle(
              color: statusData['color'],
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Gets the status data from the current [groundStation].
  Map<String, dynamic> _getStatusData() {
    switch (widget.groundStation.status) {
      case GroundStationStatusEnum.ONLINE:
        return {
          'icon': Icons.check_circle_rounded,
          'title': 'Online',
          'color': ThemeColors.success,
        };
      case GroundStationStatusEnum.TESTING:
        return {
          'icon': Icons.access_time_filled_rounded,
          'title': 'Testing',
          'color': ThemeColors.warning,
        };
      case GroundStationStatusEnum.OFFLINE:
        return {
          'icon': Icons.highlight_off_rounded,
          'title': 'Offline',
          'color': ThemeColors.alert,
        };
    }
  }
}
