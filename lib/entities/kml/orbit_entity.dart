import 'package:satnogs_visualization_tool/entities/kml/look_at_entity.dart';

/// Class that defines the `orbit` entity, which contains its properties and
/// methods.
class OrbitEntity {
  /// Generates the `orbit` tag based on the given [lookAt].
  static String tag(LookAtEntity lookAt) {
    String content = '';

    double heading = double.parse(lookAt.heading);
    int orbit = 0;

    while (orbit <= 36) {
      if (heading >= 360) {
        heading -= 360;
      }

      content += '''
            <gx:FlyTo>
              <gx:duration>1.2</gx:duration>
              <gx:flyToMode>smooth</gx:flyToMode>
              <LookAt>
                  <longitude>${lookAt.lng}</longitude>
                  <latitude>${lookAt.lat}</latitude>
                  <heading>$heading</heading>
                  <tilt>60</tilt>
                  <range>${lookAt.range}</range>
                  <gx:fovy>60</gx:fovy>
                  <altitude>${lookAt.altitude}</altitude>
                  <gx:altitudeMode>${lookAt.altitudeMode}</gx:altitudeMode>
              </LookAt>
            </gx:FlyTo>
          ''';

      heading += 10;
      orbit += 1;
    }

    return content;
  }

  /// Builds and returns the `orbit` KML based on the given [content].
  static String buildOrbit(String content) => '''
<?xml version="1.0" encoding="UTF-8"?>
      <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
        <gx:Tour>
          <name>Orbit</name>
          <gx:Playlist> 
            $content
          </gx:Playlist>
        </gx:Tour>
      </kml>
    ''';
}
