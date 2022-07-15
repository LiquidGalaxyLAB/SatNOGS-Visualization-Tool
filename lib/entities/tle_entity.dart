import 'package:sgp4_sdp4/sgp4_sdp4.dart';

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

  TLEEntity({
    required this.line0,
    required this.line1,
    required this.line2,
    required this.source,
    required this.satelliteId,
    required this.noradId,
    required this.updated,
  });

  /// Reads the current [TLEEntity] and returns a [Map] containing all extracted
  /// information.
  Map<String, double> read() {
    final datetime = DateTime.now();
    final TLE tle = TLE(line0, line1, line2);
    final Orbit orbit = Orbit(tle);
    print('is SGP4: ${orbit.period() < 255 * 60}');

    final utcTime = Julian.fromFullDate(datetime.year, datetime.month,
                datetime.day, datetime.hour, datetime.minute)
            .getDate() +
        4 / 24.0;

    final Eci eciPos =
        orbit.getPosition((utcTime - orbit.epoch().getDate()) * MIN_PER_DAY);

    final CoordGeo coord = eciPos.toGeo();
    if (coord.lon > PI) {
      coord.lon -= TWOPI;
    }

    print(
        'lat: ${rad2deg(coord.lat)} - lng: ${rad2deg(coord.lon)} - alt: ${rad2deg(coord.alt)} | ${coord.alt}');

    return {
      'lat': rad2deg(coord.lat),
      'lng': rad2deg(coord.lon),
      'alt': rad2deg(coord.alt),
    };
  }

  /// Converts the current [TLEEntity] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'tle0': line0,
      'tle1': line1,
      'tle2': line2,
      'tle_source': source,
      'sat_id': satelliteId,
      'norad_cat_id': noradId,
      'updated': updated,
    };
  }

  /// Gets a [TLEEntity] from the given [map].
  factory TLEEntity.fromMap(Map map) {
    return TLEEntity(
      line0: map['tle0'],
      line1: map['tle1'],
      line2: map['tle2'],
      source: map['tle_source'],
      satelliteId: map['sat_id'],
      noradId: map['norad_cat_id'],
      updated: map['updated'],
    );
  }
}
