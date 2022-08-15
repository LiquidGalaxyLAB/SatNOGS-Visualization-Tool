/// Class that defines the `tour` entity, which contains its properties and
/// methods.
class TourEntity {
  /// Property that defines the tour [name].
  String name;

  /// Property that defines the animated [placemark] id.
  String placemarkId;

  /// Property that defines the tour [initial coordinate].
  Map<String, double> initialCoordinate;

  /// Property that defines the placemark tour [coordinates].
  List<Map<String, double>> coordinates;

  TourEntity({
    required this.name,
    required this.placemarkId,
    required this.initialCoordinate,
    required this.coordinates,
  });

  /// Returns a KML based on the current tour.
  String get tourKml => '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    <name>Tour</name>
    <open>1</open>
    <Folder>
      $tag
    </Folder>
  </Document>
</kml>
  ''';

  /// Gets the tour tag according to its [name], [placemarkId] and [coordinates].
  String get tag => '''
    <gx:Tour>
      <name>$name</name>
      <gx:Playlist>
        $_updates
      </gx:Playlist>
    </gx:Tour>
  ''';

  /// Gets all animation updates from the current [placemarkId] and [coordinates].
  String get _updates {
    String updates = '';

    double heading = 0;
    for (var coord in coordinates) {
      if (heading >= 360) {
        heading -= 360;
      }

      final lng = coord['lng'];
      final lat = coord['lat'];
      final alt = coord['altitude'];

      heading += 1;
      updates += '''
        <gx:FlyTo>
          <gx:duration>0.4</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>$lng</longitude>
            <latitude>$lat</latitude>
            <altitude>$alt</altitude>
            <heading>$heading</heading>
            <tilt>30</tilt>
            <range>10000000</range>
            <gx:altitudeMode>relativeToGround</gx:altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:AnimatedUpdate>
          <gx:duration>0.7</gx:duration>
          <Update>
            <targetHref/>
            <Change>
              <Placemark targetId="$placemarkId">
                <Point>
                  <coordinates>$lng,$lat,$alt</coordinates>
                </Point>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>
      ''';
    }

    updates += '''
        <gx:Wait>
          <gx:duration>2</gx:duration>
        </gx:Wait>

        <gx:AnimatedUpdate>
          <gx:duration>0</gx:duration>
          <Update>
            <targetHref/>
            <Change>
              <Placemark targetId="$placemarkId">
                <Point>
                  <coordinates>${initialCoordinate['lng']},${initialCoordinate['lat']},${initialCoordinate['altitude']}</coordinates>
                </Point>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>

        <gx:FlyTo>
          <gx:duration>5</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>${initialCoordinate['lng']}</longitude>
            <latitude>${initialCoordinate['lat']}</latitude>
            <altitude>${initialCoordinate['altitude']}</altitude>
            <heading>0</heading>
            <tilt>60</tilt>
            <range>4000000</range>
            <gx:altitudeMode>relativeToGround</gx:altitudeMode>
          </LookAt>
        </gx:FlyTo>
    ''';

    return updates;
  }

  /// Returns a [Map] from the current [TourEntity].
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'placemarkId': placemarkId,
      'initialCoordinate': initialCoordinate,
      'coordinates': coordinates,
    };
  }

  /// Returns a [TourEntity] from the given [map].
  factory TourEntity.fromMap(Map<String, dynamic> map) {
    return TourEntity(
      name: map['name'],
      placemarkId: map['placemarkId'],
      initialCoordinate: map['initialCoordinate'],
      coordinates: map['coordinates'],
    );
  }
}
