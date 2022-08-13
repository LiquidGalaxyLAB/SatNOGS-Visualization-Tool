import 'package:satnogs_visualization_tool/enums/iaro_coordination_enum.dart';
import 'package:satnogs_visualization_tool/enums/transmitter_service_enum.dart';
import 'package:satnogs_visualization_tool/enums/transmitter_status_enum.dart';
import 'package:satnogs_visualization_tool/enums/transmitter_type_enum.dart';

/// Entity that represents the `transmitter`, with all of its properties and methods.
class TransmitterEntity {
  /// Property that defines the transmitter `uuid`.
  String id;

  /// Property that defines the transmitter `description`.
  String description;

  /// Property that defines whether a transmitter is `alive`.
  bool alive;

  /// Property that defines the transmitter `type`.
  ///
  /// See [TransmitterTypeEnum].
  TransmitterTypeEnum type;

  /// Property that defines the transmitter `uplink transmission mode`.
  String? uplinkMode;

  /// Property that defines the transmitter `uplink low frequency`, in Hz.
  int? uplinkLow;

  /// Property that defines the transmitter `uplink high frequency`, in Hz.
  int? uplinkHigh;

  /// Property that defines the transmitter `uplink drift frequency`, in Hz.
  int? uplinkDrift;

  /// Property that defines the transmitter `downlink low frequency`, in Hz.
  int? downlinkLow;

  /// Property that defines the transmitter `downlink high frequency`, in Hz.
  int? downlinkHigh;

  /// Property that defines the transmitter `downlink drift frequency`, in Hz.
  int? downlinkDrift;

  /// Property that defines the transmitter `downlink transmission mode`.
  String? mode;

  /// Property that defines the transmitter `downlink transmission mode id`.
  int? modeId;

  /// Property that defines whether the transmitter is an `inverted transponder`.
  bool? invert;

  /// Property that defines the `number of modulated symbols` that the transmitter
  /// sends every second.
  double? baud;

  /// Property that defines the transmitter `satellite id`.
  String satelliteId;

  /// Property that defines the transmitter `NORAD id`.
  int noradId;

  /// Property that defines the transmitter `status`.
  ///
  /// See [TransmitterStatusEnum].
  TransmitterStatusEnum status;

  /// Property that defines the `date` that the transmitter has `updated`.
  String updated;

  /// Property that defines how the transmitter must be `citated`.
  String citation;

  /// Property that defines what `service` does the transmitter use.
  ///
  /// See [TransmitterServiceEnum].
  TransmitterServiceEnum service;

  /// Property that defines the transmitter `IARU coordination`.
  ///
  /// See [IARUCoordinationEnum].
  IARUCoordinationEnum iaruCoordination;

  /// Property that defines the transmitter `IARU coordination URL`.
  String iaruCoordinationUrl;

  /// Property that defines the transmitter `ITU notification`.
  dynamic ituNotification;

  /// Property that defines whether the transmitter has a `violated frequency`.
  bool? frequencyViolation;

  TransmitterEntity({
    required this.id,
    required this.description,
    required this.alive,
    required this.type,
    this.uplinkMode,
    this.uplinkLow,
    this.uplinkHigh,
    this.uplinkDrift,
    this.downlinkLow,
    this.downlinkHigh,
    this.downlinkDrift,
    this.mode,
    this.modeId,
    this.invert,
    this.baud,
    required this.satelliteId,
    required this.noradId,
    required this.status,
    required this.updated,
    required this.citation,
    required this.service,
    required this.iaruCoordination,
    required this.iaruCoordinationUrl,
    required this.ituNotification,
    required this.frequencyViolation,
  });

  /// Gets the transmitter type label according to the current [type].
  String getTypeLabel() {
    switch (type) {
      case TransmitterTypeEnum.TRANSMITTER:
        return 'Transmitter';
      case TransmitterTypeEnum.TRANSCEIVER:
        return 'Transceiver';
      case TransmitterTypeEnum.TRANSPONDER:
        return 'Transponder';
    }
  }

  /// Gets the transmitter service label according to the current [service].
  String getServiceLabel() {
    String parsed = service.name.replaceAll('_', ' ').toLowerCase();
    return '${parsed[0].toUpperCase()}${parsed.substring(1)}';
  }

  /// Gets the transmitter IARU Coordination label according to the current one.
  String getIaruLabel() {
    switch (iaruCoordination) {
      case IARUCoordinationEnum.IARU_COORDINATED:
        return 'IARU Coordinated';
      case IARUCoordinationEnum.IARU_UNCOORDINATED:
        return 'IARU Uncoordinated';
      case IARUCoordinationEnum.IARU_DECLINED:
        return 'IARU Declined';
      case IARUCoordinationEnum.NA:
        return 'N/A';
    }
  }

  /// Gets the transmitter status from the given string.
  static IARUCoordinationEnum parseIaru(String iaru) {
    switch (iaru.toLowerCase()) {
      case 'iaru coordinated':
        return IARUCoordinationEnum.IARU_COORDINATED;
      case 'iaru uncoordinated':
        return IARUCoordinationEnum.IARU_UNCOORDINATED;
      case 'iaru declined':
        return IARUCoordinationEnum.IARU_DECLINED;
      case 'n/a':
        return IARUCoordinationEnum.NA;
      default:
        return IARUCoordinationEnum.NA;
    }
  }

  /// Gets the transmitter status from the given string.
  static TransmitterStatusEnum parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return TransmitterStatusEnum.ACTIVE;
      case 'inactive':
        return TransmitterStatusEnum.INACTIVE;
      case 'invalid':
        return TransmitterStatusEnum.INVALID;
      default:
        return TransmitterStatusEnum.ACTIVE;
    }
  }

  /// Gets the transmitter type from the given string.
  static TransmitterTypeEnum parseType(String type) {
    switch (type.toLowerCase()) {
      case 'transmitter':
        return TransmitterTypeEnum.TRANSMITTER;
      case 'transceiver':
        return TransmitterTypeEnum.TRANSCEIVER;
      case 'transponder':
        return TransmitterTypeEnum.TRANSPONDER;
      default:
        return TransmitterTypeEnum.TRANSMITTER;
    }
  }

  /// Gets the transmitter service from the given string.
  static TransmitterServiceEnum parseService(String service) {
    switch (service.toLowerCase()) {
      case 'aeronautical':
        return TransmitterServiceEnum.AERONAUTICAL;
      case 'amateur':
        return TransmitterServiceEnum.AMATEUR;
      case 'broadcasting':
        return TransmitterServiceEnum.BROADCASTING;
      case 'earth exploration':
        return TransmitterServiceEnum.EARTH_EXPLORATION;
      case 'fixed':
        return TransmitterServiceEnum.FIXED;
      case 'inter satellite':
        return TransmitterServiceEnum.INTER_SATELLITE;
      case 'maritime':
        return TransmitterServiceEnum.MARITIME;
      case 'meteorological':
        return TransmitterServiceEnum.METEOROLOGICAL;
      case 'mobile':
        return TransmitterServiceEnum.MOBILE;
      case 'radiolocation':
        return TransmitterServiceEnum.RADIOLOCATION;
      case 'radionavigational':
        return TransmitterServiceEnum.RADIONAVIGATIONAL;
      case 'space operation':
        return TransmitterServiceEnum.SPACE_OPERATION;
      case 'space research':
        return TransmitterServiceEnum.SPACE_RESEARCH;
      case 'standard frequency and time signal':
        return TransmitterServiceEnum.STANDARD_FREQUENCY_AND_TIME_SIGNAL;
      case 'unknown':
        return TransmitterServiceEnum.UNKNOWN;
      default:
        return TransmitterServiceEnum.UNKNOWN;
    }
  }

  /// Gets a [TransmitterEntity] from the given [map].
  factory TransmitterEntity.fromMap(Map map) {
    return TransmitterEntity(
      id: map['uuid'],
      description: map['description'],
      alive: map['alive'],
      type: TransmitterEntity.parseType(map['type']),
      uplinkLow: map['uplink_low'],
      uplinkHigh: map['uplink_high'],
      uplinkDrift: map['uplink_drift'],
      downlinkLow: map['downlink_low'],
      downlinkHigh: map['downlink_high'],
      downlinkDrift: map['downlink_drift'],
      mode: map['mode'],
      modeId: map['mode_id'],
      uplinkMode: map['uplink_mode'],
      invert: map['invert'],
      baud: map['baud'],
      satelliteId: map['sat_id'],
      noradId: map['norad_cat_id'],
      status: TransmitterEntity.parseStatus(map['status']),
      updated: map['updated'],
      citation: map['citation'],
      service: TransmitterEntity.parseService(map['service']),
      iaruCoordination: TransmitterEntity.parseIaru(map['iaru_coordination']),
      iaruCoordinationUrl: map['iaru_coordination_url'],
      ituNotification: map['itu_notification'],
      frequencyViolation: map['frequency_violation'],
    );
  }
}
