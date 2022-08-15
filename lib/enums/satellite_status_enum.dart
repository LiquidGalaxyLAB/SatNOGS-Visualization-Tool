// ignore_for_file: constant_identifier_names

/// Enum that defines all the satellites possible status.
enum SatelliteStatusEnum {
  /// `Operational` - Satellite is in orbit and operational.
  ALIVE,

  /// `Malfunctioning` - Satellite appears to be malfunctioning.
  DEAD,

  /// `Decayed` - Satellite has re-entered.
  RE_ENTERED,

  /// `Future` - Satellite is not yet in orbit.
  FUTURE,
}
