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

  GroundStationEntity({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.status,
  });

  /// Gets the balloon content from the current ground station and from the
  /// given [map].
  String balloonContent(Map<String, dynamic> map) => '''
    <b><font size="+2">$name <font color="#5D5D5D">(${getStatusLabel().toUpperCase()})</font></font></b>
    <br/><br/>
    ${map.entries.map((e) => '\n<b>${e.key}:</b> ${e.value}').join('\n<br/>')}
  ''';

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

  /// Gets the status label.
  ///
  /// Example
  /// ```
  /// final groundStation = GroundStationEntity(status: GroundStationStatusEnum.ONLINE);
  /// groundStation.getStatusLabel(); => 'Online'
  /// ```
  String getStatusLabel() {
    switch (status) {
      case GroundStationStatusEnum.ONLINE:
        return 'Online';
      case GroundStationStatusEnum.TESTING:
        return 'Testing';
      case GroundStationStatusEnum.OFFLINE:
        return 'Offline';
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
