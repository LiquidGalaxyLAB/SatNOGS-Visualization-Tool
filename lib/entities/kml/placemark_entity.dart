import 'package:satnogs_visualization_tool/entities/kml/line_entity.dart';
import 'package:satnogs_visualization_tool/entities/kml/look_at_entity.dart';
import 'package:satnogs_visualization_tool/entities/kml/point_entity.dart';

/// Class that defines the `placemark` entity, which contains its properties and
/// methods.
class PlacemarkEntity {
  /// Property that defines the placemark `id`.
  String id;

  /// Property that defines the placemark `name`.
  String name;

  /// Property that defines the placemark `description`.
  String? description;

  /// Property that defines the placemark `icon` image URL.
  String? icon;

  /// Property that defines the placemark `balloon` content.
  String balloonContent;

  /// Property that defines the placemark `look at` entity.
  LookAtEntity? lookAt;

  /// Property that defines the placemark `point` entity.
  PointEntity point;

  /// Property that defines the placemark `line` entity.
  LineEntity line;

  PlacemarkEntity({
    this.description,
    this.icon,
    this.balloonContent = '',
    required this.id,
    required this.name,
    required this.lookAt,
    required this.point,
    required this.line,
  });

  /// Property that defines the placemark `tag` according to its current
  /// properties.
  String get tag => '''
    <Style id="high-$id">
      <IconStyle>
        <scale>3.0</scale>
        <Icon>
          <href>http://lg1:81/$icon</href>
        </Icon>
        <hotSpot x="0.5" y="0.5" xunits="fraction" yunits="fraction" />
      </IconStyle>
    </Style>
    <Style id="normal-$id">
      <IconStyle>
        <scale>2.5</scale>
        <Icon>
          <href>http://lg1:81/$icon</href>
        </Icon>
        <hotSpot x="0.5" y="0.5" xunits="fraction" yunits="fraction" />
      </IconStyle>
      <BalloonStyle>
        <bgColor>ffffffff</bgColor>
        <text><![CDATA[
          $balloonContent
        ]]></text>
      </BalloonStyle>
    </Style>
    <Style id="line-$id">
      <LineStyle>
        <color>ff4444ff</color>
        <colorMode>normal</colorMode>
        <width>5.0</width>
        <gx:outerColor>ff4444ff</gx:outerColor>
        <gx:outerWidth>0.0</gx:outerWidth>
        <gx:physicalWidth>0.0</gx:physicalWidth>
        <gx:labelVisibility>0</gx:labelVisibility>
      </LineStyle>
      <PolyStyle>
        <color>00000000</color>
      </PolyStyle>
    </Style>
    <StyleMap id="$id">
      <Pair>
        <key>normal</key>
        <styleUrl>normal-$id</styleUrl>
      </Pair>
      <Pair>
        <key>highlight</key>
        <styleUrl>high-$id</styleUrl>
      </Pair>
    </StyleMap>
    <Placemark>
      <name>$name</name>
      <description><![CDATA[$description]]></description>
      ${lookAt == null ? '' : lookAt!.tag}
      <styleUrl>$id</styleUrl>
      ${point.tag}
      <gx:balloonVisibility>${balloonContent.isEmpty ? 0 : 1}</gx:balloonVisibility>
    </Placemark>
    <Placemark>
      <name>Orbit - $name</name>
      <styleUrl>line-$id</styleUrl>
      ${line.tag}
    </Placemark>
  ''';

  /// Returns a [Map] from the current [PlacemarkEntity].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description ?? '',
      'icon': icon ?? '',
      'lookAt': lookAt?.toMap(),
      'point': point.toMap()
    };
  }

  /// Returns a [PlacemarkEntity] from the given [map].
  factory PlacemarkEntity.fromMap(Map<String, dynamic> map) {
    return PlacemarkEntity(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      icon: map['icon'],
      lookAt:
          map['lookAt'] != null ? LookAtEntity.fromMap(map['lookAt']) : null,
      point: PointEntity.fromMap(map['point']),
      line: LineEntity.fromMap(map['line']),
    );
  }
}
