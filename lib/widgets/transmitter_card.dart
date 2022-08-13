import 'package:flutter/material.dart';
import 'package:satnogs_visualization_tool/entities/transmitter_entity.dart';
import 'package:satnogs_visualization_tool/enums/transmitter_status_enum.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';
import 'package:satnogs_visualization_tool/utils/date.dart';
import 'package:url_launcher/url_launcher.dart';

class TransmitterCard extends StatefulWidget {
  const TransmitterCard({Key? key, required this.transmitter})
      : super(key: key);

  final TransmitterEntity transmitter;

  @override
  State<TransmitterCard> createState() => _TransmitterCardState();
}

class _TransmitterCardState extends State<TransmitterCard> {
  /// Opens the transmitter `IARU Coordination URL`.
  void _openLink() async {
    final Uri websiteLaunchUri =
        Uri.parse(widget.transmitter.iaruCoordinationUrl);

    if (await canLaunchUrl(websiteLaunchUri)) {
      await launchUrl(websiteLaunchUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final transmitter = widget.transmitter;

    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: ThemeColors.card.withOpacity(0.5),
        border: Border.all(color: ThemeColors.cardBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    transmitter.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Flexible(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    transmitter.invert == null || !transmitter.invert!
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildTransmitterInverted(),
                          ),
                    _buildTransmitterStatus()
                  ],
                )),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Column(
                      children: [
                        _buildInfoSection('ID', transmitter.id),
                        _buildInfoSection('Type', transmitter.getTypeLabel()),
                        _buildInfoSection(
                            'Service', transmitter.getServiceLabel()),
                        _buildInfoSection('Citation', transmitter.citation),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('IARU Coordination',
                                  fontSize: 14),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      transmitter.getIaruLabel(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  transmitter.iaruCoordinationUrl.isEmpty
                                      ? Container()
                                      : Flexible(
                                          child: IconButton(
                                            splashRadius: 24,
                                            tooltip: 'Open in browser',
                                            icon: Icon(
                                              Icons.open_in_browser_rounded,
                                              color: ThemeColors.primaryColor,
                                            ),
                                            onPressed: () {
                                              _openLink();
                                            },
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _buildInfoSection(
                          'Updated at',
                          parseDateString(transmitter.updated),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: _buildSectionTitle('Downlink'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                _buildInfoSection(
                                  'Mode',
                                  (transmitter.mode ?? '').toUpperCase(),
                                  subsection: true,
                                ),
                                _buildInfoSection(
                                  'High frequency',
                                  transmitter.downlinkHigh != null
                                      ? '${(transmitter.downlinkHigh! / 1000).toStringAsFixed(0)} MHz'
                                      : '-',
                                  subsection: true,
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                _buildInfoSection(
                                  'Low frequency',
                                  transmitter.downlinkLow != null
                                      ? '${(transmitter.downlinkLow! / 1000).toStringAsFixed(0)} MHz'
                                      : '-',
                                  subsection: true,
                                ),
                                _buildInfoSection(
                                  'Drift frequency',
                                  transmitter.downlinkDrift != null
                                      ? '${(transmitter.downlinkDrift! / 1000).toStringAsFixed(0)} MHz'
                                      : '-',
                                  subsection: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: _buildSectionTitle('Uplink'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                _buildInfoSection(
                                  'Mode',
                                  (transmitter.mode ?? '').toUpperCase(),
                                  subsection: true,
                                ),
                                _buildInfoSection(
                                  'High frequency',
                                  transmitter.uplinkHigh != null
                                      ? '${(transmitter.uplinkHigh! / 1000).toStringAsFixed(0)} MHz'
                                      : '-',
                                  subsection: true,
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                _buildInfoSection(
                                  'Low frequency',
                                  transmitter.uplinkLow != null
                                      ? '${(transmitter.uplinkLow! / 1000).toStringAsFixed(0)} MHz'
                                      : '-',
                                  subsection: true,
                                ),
                                _buildInfoSection(
                                  'Drift frequency',
                                  transmitter.uplinkDrift != null
                                      ? '${(transmitter.uplinkDrift! / 1000).toStringAsFixed(0)} MHz'
                                      : '-',
                                  subsection: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _buildInfoSection(
                          'Baud', (transmitter.baud ?? '').toString()),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an informational section (title and description).
  Widget _buildInfoSection(String title, String info,
      {bool subsection = false}) {
    return Padding(
      padding: EdgeInsets.only(top: subsection ? 4 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title, fontSize: subsection ? 12 : 14),
          Row(
            children: [
              Flexible(
                child: Text(
                  info.isEmpty ? '-' : info,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the section title according to the given [title].
  Widget _buildSectionTitle(String title, {double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white70,
          fontSize: fontSize,
        ),
      ),
    );
  }

  /// Builds the transmitter inverted widget.
  Widget _buildTransmitterInverted() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            Icons.flip_rounded,
            color: ThemeColors.primaryColor,
            size: 18,
          ),
        ),
        Text(
          'Inverted',
          style: TextStyle(
            color: ThemeColors.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Builds the transmitter status widget.
  Widget _buildTransmitterStatus() {
    final statusData = _getStatusData();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            statusData['icon'],
            color: statusData['color'],
            size: 18,
          ),
        ),
        Text(
          statusData['title'],
          style: TextStyle(
            color: statusData['color'],
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Gets the status data from the current [transmitter].
  Map<String, dynamic> _getStatusData() {
    switch (widget.transmitter.status) {
      case TransmitterStatusEnum.ACTIVE:
        return {
          'title': 'Active',
          'icon': Icons.check_circle_rounded,
          'color': ThemeColors.success,
        };
      case TransmitterStatusEnum.INACTIVE:
        return {
          'title': 'Inactive',
          'icon': Icons.sensors_off_rounded,
          'color': ThemeColors.alert,
        };
      case TransmitterStatusEnum.INVALID:
        return {
          'title': 'Invalid',
          'icon': Icons.highlight_off_rounded,
          'color': Colors.grey,
        };
    }
  }
}
