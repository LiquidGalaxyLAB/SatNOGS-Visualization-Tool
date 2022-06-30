/// Entity that represents the `TLE`, with all of its properties and methods.
class TLEEntity {
  /// Property that defines the TLE `line 0`, which contains its name.
  String line0;

  /// Property that defines the TLE `line 1`.
  String line1;

  /// Property that defines the TLE `line 2`.
  String line2;

  /// Property that defines the TLE `source`.
  String source;

  /// Property that defines the TLE `satellite id`.
  String satelliteId;

  /// Property that defines the TLE `NORAD id`.
  int noradId;

  /// Property that defines the `date` that the TLE has `updated`.
  String updated;

  TLEEntity(
      {required this.line0,
      required this.line1,
      required this.line2,
      required this.source,
      required this.satelliteId,
      required this.noradId,
      required this.updated});
}
