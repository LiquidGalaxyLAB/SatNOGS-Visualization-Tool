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
  bool frequencyViolation;

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
}
