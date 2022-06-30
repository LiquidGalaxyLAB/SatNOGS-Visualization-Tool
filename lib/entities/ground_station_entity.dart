import 'package:satnogs_visualization_tool/enums/ground_station_status_enum.dart';

/// Entity that represents the `ground station`, with all of its properties and methods.
class GroundStationEntity {
  /// Property that defines the ground station `id`.
  int id;

  /// Property that defines the ground station `name`.
  String name;

  /// Property that defines the ground station `latitude`.
  double lat;

  /// Property that defines the ground station `longitude`.
  double lng;

  /// Proeperty that defines the ground station `status`.
  ///
  /// See [GroundStationStatusEnum].
  GroundStationStatusEnum status;

  GroundStationEntity(
      {required this.id,
      required this.name,
      required this.lat,
      required this.lng,
      required this.status});

  /// Gets the ground station status from the given string.
  static GroundStationStatusEnum parseStatus(int status) {
    switch (status) {
      case 2:
        return GroundStationStatusEnum.ONLINE;
      case 1:
        return GroundStationStatusEnum.TESTING;
      case 0:
        return GroundStationStatusEnum.OFFLINE;
      default:
        return GroundStationStatusEnum.ONLINE;
    }
  }

  /// Gets a [GroundStationEntity] from the given [map].
  factory GroundStationEntity.fromMap(Map map) {
    return GroundStationEntity(
      id: map['id'],
      name: map['name'],
      lat: map['lat'],
      lng: map['lng'],
      status: GroundStationEntity.parseStatus(map['status']),
    );
  }
}
