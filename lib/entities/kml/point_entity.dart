/// Class that represents the `point` entity, which has its properties and
/// methods.
class PointEntity {
  /// Property that defines the point `latitude`.
  double lat;

  /// Property that defines the point `longitude`.
  double lng;

  /// Property that defines the point `altitude`.
  double altitude;

  /// Property that defines the look at `altitude mode`.
  ///
  /// Defaults to `relativeToGround`.
  String altitudeMode;

  /// Property that defines the point `draw order`.
  ///
  /// Defaults to `1`.
  int drawOrder;

  PointEntity({
    this.drawOrder = 1,
    this.altitudeMode = 'relativeToGround',
    required this.lat,
    required this.lng,
    required this.altitude,
  });

  /// Property that defines the point `tag` according to its current properties.
  ///
  /// Example
  /// ```
  /// Point point = Point(lat: 30, lng: -74, altitude: 600)
  /// point.tag => '''
  ///   <Point>
  ///     <gx:drawOrder>1</gx:drawOrder>
  ///     <gx:altitudeMode>relativeToGround</gx:altitudeMode>
  ///     <coordinates>-74,30,600</coordinates>
  ///   </Point>
  /// '''
  /// ```
  String get tag => '''
      <Point>
        <gx:drawOrder>$drawOrder</gx:drawOrder>
        <gx:altitudeMode>$altitudeMode</gx:altitudeMode>
        <coordinates>$lng,$lat,$altitude</coordinates>
      </Point>
    ''';

  /// Returns a [Map] from the current [PointEntity].
  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
      'altitude': altitude,
      'altitudeMode': altitudeMode,
      'drawOrder': drawOrder,
    };
  }

  /// Returns a [PointEntity] from the given [map].
  factory PointEntity.fromMap(Map<String, dynamic> map) {
    return PointEntity(
      lat: map['lat'],
      lng: map['lng'],
      altitude: map['altitude'],
      altitudeMode: map['altitudeMode'],
      drawOrder: map['drawOrder'],
    );
  }
}
