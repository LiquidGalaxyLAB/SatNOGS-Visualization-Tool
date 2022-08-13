import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:satnogs_visualization_tool/entities/satellite_entity.dart';
import 'package:satnogs_visualization_tool/entities/tle_entity.dart';
import 'package:satnogs_visualization_tool/entities/transmitter_entity.dart';
import 'package:satnogs_visualization_tool/enums/satellite_status_enum.dart';
import 'package:satnogs_visualization_tool/services/tle_service.dart';
import 'package:satnogs_visualization_tool/services/transmitter_service.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';
import 'package:satnogs_visualization_tool/utils/date.dart';
import 'package:satnogs_visualization_tool/widgets/button.dart';
import 'package:satnogs_visualization_tool/widgets/transmitter_card.dart';
import 'package:url_launcher/url_launcher.dart';

class SatelliteInfoPage extends StatefulWidget {
  const SatelliteInfoPage({
    Key? key,
    required this.satellite,
  }) : super(key: key);

  final SatelliteEntity satellite;

  @override
  State<SatelliteInfoPage> createState() => _SatelliteInfoPageState();
}

class _SatelliteInfoPageState extends State<SatelliteInfoPage>
    with TickerProviderStateMixin {
  TransmitterService get _transmitterService => GetIt.I<TransmitterService>();
  TLEService get _tleService => GetIt.I<TLEService>();

  late TabController _tabController;

  List<TransmitterEntity> _transmitters = [];
  TLEEntity? _tle;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _setTransmitters();
    _setTLE();
  }

  /// Loads the satellite transmitters and set the `_transmitters` property.
  void _setTransmitters() async {
    final transmitters = await _transmitterService.getMany(offline: true);

    setState(() {
      _transmitters = transmitters
          .where((element) => element.satelliteId == widget.satellite.id)
          .toList();
    });
  }

  /// Loads the satellite TLE and set the `_tle` property.
  void _setTLE() async {
    final tles = await _tleService.getMany(offline: true);

    final matchTLEs =
        tles.where((element) => element.satelliteId == widget.satellite.id);

    setState(() {
      _tle = matchTLEs.isNotEmpty ? matchTLEs.toList()[0] : null;
    });
  }

  /// Opens the satellite `website`.
  void _openLink() async {
    final Uri websiteLaunchUri = Uri.parse(widget.satellite.website);

    if (await canLaunchUrl(websiteLaunchUri)) {
      await launchUrl(websiteLaunchUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final satellite = widget.satellite;
    final badgeSize = 16.0 * _transmitters.length.toString().length;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(satellite.name),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.satellite_alt_rounded),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: ThemeColors.primaryColor,
          labelColor: ThemeColors.primaryColor,
          unselectedLabelColor: Colors.white70,
          tabs: [
            const Tab(
              icon: Icon(Icons.info_rounded),
              text: 'Information',
            ),
            Tab(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.settings_input_antenna_rounded),
                  _transmitters.isEmpty
                      ? Container()
                      : Positioned(
                          top: -16,
                          right: -badgeSize / 2 - 4,
                          child: Container(
                            height: 16,
                            width: badgeSize,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: ThemeColors.primaryColor,
                            ),
                            child: Text(
                              _transmitters.length.toString(),
                              style: TextStyle(
                                color: ThemeColors.backgroundColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                ],
              ),
              text: 'Transmitters',
            ),
            const Tab(
              icon: Icon(Icons.stacked_line_chart_rounded),
              text: 'TLE',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSatelliteInfo(),
          _buildSatelliteTransmitter(),
          _buildSatelliteTLE(),
        ],
      ),
    );
  }

  /// Builds the satellite `TLE` page.
  Widget _buildSatelliteTLE() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoSection(
              'Latest Two-Line Element (TLE)',
              _tle == null
                  ? 'Not available'
                  : '${_tle!.line0}\r\n${_tle!.line1}\r\n${_tle!.line2}',
            ),
            _buildInfoSection(
              'TLE Source',
              _tle == null ? 'Not available' : _tle!.source,
            ),
            _buildInfoSection(
              'TLE Updated at',
              _tle == null ? 'Not available' : parseDateString(_tle!.updated),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the satellite `transmitters` page.
  Widget _buildSatelliteTransmitter() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      shrinkWrap: true,
      itemCount: _transmitters.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0 : 16),
          child: TransmitterCard(transmitter: _transmitters[index]),
        );
      },
    );
  }

  /// Builds the satellite `information` page.
  Widget _buildSatelliteInfo() {
    final satellite = widget.satellite;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildSatelliteStatus(),
                      _buildInfoSection('Satellite ID', satellite.id),
                      _buildInfoSection(
                          'NORAD ID', satellite.noradId.toString()),
                      _buildInfoSection('Name', satellite.name),
                      _buildInfoSection(
                        'Alternate names',
                        satellite.altNames.isEmpty
                            ? '-'
                            : satellite.altNames.replaceAll(
                                RegExp(',\\s?'),
                                '\r\n',
                              ),
                      ),
                      _buildDateSection('Launch date', satellite.launched),
                      _buildDateSection('Deploy date', satellite.deployed),
                      _buildDateSection('Decay date', satellite.decayed),
                    ],
                  ),
                ),
                _buildSatelliteImage(),
              ],
            ),
            _buildInfoSection(
              'Countries of origin',
              satellite.countries.isEmpty
                  ? '-'
                  : satellite.countries.replaceAll(',', ' - '),
            ),
            _buildInfoSection('Operator', satellite.satOperator),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Website'),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          satellite.website.isNotEmpty
                              ? satellite.website
                              : '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  !satellite.websiteValid()
                      ? Container()
                      : Row(
                          children: [
                            Button(
                              width: 110,
                              elevation: 0,
                              label: 'Open',
                              labelColor: ThemeColors.primaryColor,
                              color: ThemeColors.primaryColor.withOpacity(0.1),
                              border:
                                  BorderSide(color: ThemeColors.primaryColor),
                              icon: Icon(
                                Icons.open_in_browser_rounded,
                                color: ThemeColors.primaryColor,
                              ),
                              onPressed: () {
                                _openLink();
                              },
                            ),
                          ],
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a date section.
  Widget _buildDateSection(String title, String? date) {
    if (date == null || date.isEmpty) {
      return Container();
    }

    return _buildInfoSection(title, parseDateString(date));
  }

  /// Builds an informational section (title and description).
  Widget _buildInfoSection(String title, String info) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
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

  /// Builds the satellite `image`.
  Widget _buildSatelliteImage() {
    final image = widget.satellite.image;

    if (image.isEmpty) {
      return Container();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final width = screenWidth / 5;

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ThemeColors.primaryColor,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.network(
          'https://db-satnogs.freetls.fastly.net/media/$image',
        ),
      ),
    );
  }

  /// Builds the satellite status widget.
  Widget _buildSatelliteStatus() {
    final statusData = _getStatusData();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          statusData['description'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        Container(
          width: 300,
          height: 1,
          color: Colors.white12,
          margin: const EdgeInsets.only(top: 16),
        ),
      ],
    );
  }

  /// Gets the status data from the current [satellite].
  Map<String, dynamic> _getStatusData() {
    switch (widget.satellite.status) {
      case SatelliteStatusEnum.ALIVE:
        return {
          'icon': Icons.check_circle_rounded,
          'title': 'Operational',
          'description': 'Satellite is in orbit and operational',
          'color': ThemeColors.success,
        };
      case SatelliteStatusEnum.RE_ENTERED:
        return {
          'icon': Icons.transit_enterexit_rounded,
          'title': 'Decayed',
          'description': 'Satellite has re-entered',
          'color': ThemeColors.warning,
        };
      case SatelliteStatusEnum.FUTURE:
        return {
          'icon': Icons.av_timer_rounded,
          'title': 'Future',
          'description': 'Satellite is not yet in orbit',
          'color': ThemeColors.info,
        };
      case SatelliteStatusEnum.DEAD:
        return {
          'icon': Icons.public_off_rounded,
          'title': 'Malfunctioning ',
          'description': 'Satellite appears to be malfunctioning',
          'color': ThemeColors.alert
        };
    }
  }
}
