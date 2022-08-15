import 'package:intl/intl.dart';
import 'package:satnogs_visualization_tool/entities/tle_entity.dart';
import 'package:satnogs_visualization_tool/enums/satellite_status_enum.dart';

/// Entity that represents the `satellite`, with all of its properties and methods.
class SatelliteEntity {
  /// Property that defines the satellite `uuid`.
  String id;

  /// Property that defines the satellite `NORAD id`.
  int? noradId;

  /// Property that defines the satellite `main name`.
  String name;

  /// Property that defines the satellite `alternative names`.
  String altNames;

  /// Property that defines the satellite `image`.
  String image;

  /// Property that defines the satellite `status`.
  ///
  /// See [SatelliteStatusEnum].
  SatelliteStatusEnum status;

  /// Property that defines the `date` that the satellite has `decayed`.
  String decayed;

  /// Property that defines the `date` that the satellite has `launched`.
  String launched;

  /// Property that defines the `date` that the satellite has `deployed`.
  String deployed;

  /// Property that defines the satellite `website URL`.
  String website;

  /// Property that defines the satellite `operator`. I.e.: TU Berlim.
  String satOperator;

  /// Property that defines the satellites `countries` separated by comma (,).
  String countries;

  /// Property that defines the satellites linked telemetries.
  List<dynamic> telemetries;

  /// Property that defines the `date` that the satellite has `updated`.
  String updated;

  /// Property that defines how the satellite must be `citated`.
  String citation;

  /// Property that defines a `list of associated satellites ids`.
  List<dynamic> associatedSatellites;

  /// Property that defines the satellite linked `TLE`.
  TLEEntity? tle;

  SatelliteEntity({
    this.tle,
    required this.id,
    required this.noradId,
    required this.name,
    required this.altNames,
    required this.image,
    required this.status,
    required this.decayed,
    required this.launched,
    required this.deployed,
    required this.website,
    required this.satOperator,
    required this.countries,
    required this.telemetries,
    required this.updated,
    required this.citation,
    required this.associatedSatellites,
  });

  /// Gets the balloon content from the current satellite.
  String balloonContent(int transmitterAmount) => '''
    <b><font size="+2">$name <font color="#5D5D5D">(${getStatusLabel().toUpperCase()})</font></font></b>
    <br/><br/>
    ${image.isNotEmpty ? '<img height="200" src="https://db-satnogs.freetls.fastly.net/media/$image"><br/><br/>' : ''}
    <b>NORAD ID:</b> $noradId
    <br/>
    <b>Alternames:</b> ${altNames.replaceAll('\r\n', ' | ')}
    <br/>
    <b>Countries:</b> ${countries.replaceAll('\r\n', ' | ')}
    <br/>
    <b>Operator:</b> $satOperator
    <br/>
    <b>Transmitters:</b> $transmitterAmount
    <br/>
    <b>Launched:</b> ${launched.isNotEmpty ? _buildDateString(launched) : 'Never'}
    <br/>
    <b>Deployed:</b> ${deployed.isNotEmpty ? _buildDateString(deployed) : 'Never'}
    <br/>
    <b>Decayed:</b> ${decayed.isNotEmpty ? _buildDateString(decayed) : 'Never'}
  ''';

  /// Gets the satellite status from the given string.
  static SatelliteStatusEnum parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return SatelliteStatusEnum.ALIVE;
      case 'dead':
        return SatelliteStatusEnum.DEAD;
      case 'future':
        return SatelliteStatusEnum.FUTURE;
      case 're-entered':
        return SatelliteStatusEnum.RE_ENTERED;
      default:
        return SatelliteStatusEnum.ALIVE;
    }
  }

  /// Gets the status label.
  ///
  /// Example
  /// ```
  /// final satellite = SatelliteEntity(status: SatelliteStatusEnum.ALIVE);
  /// satellite.getStatusLabel(); => 'Alive'
  /// ```
  String getStatusLabel() {
    switch (status) {
      case SatelliteStatusEnum.ALIVE:
        return 'Alive';
      case SatelliteStatusEnum.DEAD:
        return 'Dead';
      case SatelliteStatusEnum.FUTURE:
        return 'Future';
      case SatelliteStatusEnum.RE_ENTERED:
        return 'Re-entered';
    }
  }

  /// Gets whether the [website] is a valid URL.
  bool websiteValid() {
    final regex = RegExp(
        'https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()@:%_\\+.~#?&//=]*)');
    return regex.hasMatch(website);
  }

  /// Gets the orbit coordinates from the current satellite.
  ///
  /// Returns a [List] of coordinates with [lat], [lng] and [alt].
  List<Map<String, double>> getOrbitCoordinates({double step = 3}) {
    if (tle == null) {
      return [];
    }

    List<Map<String, double>> coords = [];

    double displacement = 3.3 - step / 361;
    double spot = 0;

    while (spot < 361) {
      displacement += step / 361;
      final tleCoords = tle!.read(displacement: displacement / 24.0);
      coords.add({
        'lat': tleCoords['lat']!,
        'lng': tleCoords['lng']!,
        'altitude': tleCoords['alt']!
      });
      spot++;
    }

    return coords;
  }

  /// Converts the current [SatelliteEntity] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'sat_id': id,
      'norad_cat_id': noradId,
      'name': name,
      'names': altNames,
      'image': image,
      'status': getStatusLabel(),
      'decayed': decayed.isEmpty ? null : '',
      'launched': launched.isEmpty ? null : '',
      'deployed': deployed.isEmpty ? null : '',
      'website': website,
      'operator': satOperator,
      'countries': countries,
      'telemetries': telemetries,
      'updated': updated,
      'citation': citation,
      'associated_satellites': associatedSatellites,
      'tle': tle != null ? tle!.toMap() : null,
    };
  }

  /// Gets a [SatelliteEntity] from the given [map].
  factory SatelliteEntity.fromMap(Map map) {
    return SatelliteEntity(
      id: map['sat_id'],
      noradId: map['norad_cat_id'],
      name: map['name'],
      altNames: map['names'],
      image: map['image'],
      status: SatelliteEntity.parseStatus(map['status']),
      decayed: map['decayed'] ?? '',
      launched: map['launched'] ?? '',
      deployed: map['deployed'] ?? '',
      website: map['website'],
      satOperator: map['operator'],
      countries: map['countries'],
      telemetries: map['telemetries'],
      updated: map['updated'],
      citation: map['citation'],
      associatedSatellites: map['associated_satellites'],
      tle: map['tle'] != null ? TLEEntity.fromMap(map['tle']) : null,
    );
  }

  /// Gets a date string according to the given date.
  String _buildDateString(String value) {
    final date = DateFormat.yMMMMd('en_US');
    final hour = DateFormat.jm();
    return '${date.format(DateTime.parse(value))} ${hour.format(DateTime.parse(value))}';
  }
}
