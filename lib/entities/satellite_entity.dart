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

  SatelliteEntity({
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
        associatedSatellites: map['associated_satellites']);
  }
}
