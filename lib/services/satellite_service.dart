import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:satnogs_visualization_tool/entities/kml/kml_entity.dart';
import 'package:satnogs_visualization_tool/entities/kml/line_entity.dart';
import 'package:satnogs_visualization_tool/entities/kml/look_at_entity.dart';
import 'package:satnogs_visualization_tool/entities/kml/orbit_entity.dart';
import 'package:satnogs_visualization_tool/entities/kml/placemark_entity.dart';
import 'package:satnogs_visualization_tool/entities/kml/point_entity.dart';
import 'package:satnogs_visualization_tool/entities/satellite_entity.dart';
import 'package:satnogs_visualization_tool/entities/tle_entity.dart';
import 'package:satnogs_visualization_tool/entities/transmitter_entity.dart';
import 'package:satnogs_visualization_tool/services/local_storage_service.dart';
import 'package:satnogs_visualization_tool/utils/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:satnogs_visualization_tool/utils/storage_keys.dart';

/// Service that deals with all satellite data management.
class SatelliteService {
  LocalStorageService get _localStorageService =>
      GetIt.I<LocalStorageService>();

  /// Property that defines the satellite access endpoint.
  final _endpoint = 'satellites';

  /// Gets one satellite from the database according to the given [id].
  Future<SatelliteEntity> getOne(String id, {List<String>? join}) async {
    final response = await http.get(
        Uri.parse('${API.baseUrl}/$_endpoint/$id/?format=json'),
        headers: {'Authorization': 'Token ' + dotenv.env['API_KEY']!});

    final res = json.decode(response.body) as Map;
    return SatelliteEntity.fromMap(res);
  }

  /// Gets multiple satellites from the database based on the given [params].
  Future<List<SatelliteEntity>> getMany({
    Map<String, String>? params,
    List<String>? join,
    bool synchronize = false,
    bool offline = false,
  }) async {
    final hasLocal = _localStorageService.hasItem(StorageKeys.satellites);

    if ((!synchronize || offline) && hasLocal) {
      List<dynamic> localSatellites =
          json.decode(_localStorageService.getItem(StorageKeys.satellites));

      return localSatellites.map((s) => SatelliteEntity.fromMap(s)).toList();
    }

    String query = API.buildQuery(params);

    final response = await http.get(
        Uri.parse('${API.baseUrl}/$_endpoint/?format=json&$query'),
        headers: {'Authorization': 'Token ' + dotenv.env['API_KEY']!});

    _localStorageService.setItem(StorageKeys.satellites, response.body);

    final res = json.decode(response.body) as List<dynamic>;
    return res.map((s) => SatelliteEntity.fromMap(s)).toList();
  }

  /// Builds and returns a satellite `KML` [String] according to the given
  /// [satellite], [tle] and [transmitters].
  KMLEntity buildKml(
    SatelliteEntity satellite,
    TLEEntity tle,
    List<TransmitterEntity> transmitters,
  ) {
    final coord = tle.read();

    final lookAt = LookAtEntity(
      lng: coord['lng']!,
      lat: coord['lat']!,
      altitude: coord['alt']! * 1,
      range: (coord['alt']! * 3).toString(),
      tilt: '60',
      heading: '0',
    );

    final point = PointEntity(
      lat: lookAt.lat,
      lng: lookAt.lng,
      altitude: lookAt.altitude,
    );

    final placemark = PlacemarkEntity(
      id: satellite.id,
      name: '${satellite.name} (${satellite.getStatusLabel().toUpperCase()})',
      lookAt: lookAt,
      point: point,
      description: satellite.citation,
      balloonContent: satellite.balloonContent(transmitters.length),
      icon: 'satellite.png',
      line: LineEntity(
        id: satellite.id,
        coordinates: LineEntity.generateMockedLine(
          point.lng,
          point.lat,
          point.altitude,
        ),
      ),
    );

    // final screenOverlay = ScreenOverlayEntity(
    //   name: satellite.name,
    //   icon: 'http://lg1:81/satellite.png',
    //   overlayX: 1,
    //   overlayY: 1,
    //   screenX: 1,
    //   screenY: 1,
    //   sizeX: 200,
    //   sizeY: 300,
    // );

    return KMLEntity(
      name: satellite.name.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''),
      content: placemark.tag,
      // screenOverlay: screenOverlay.tag,
    );
  }

  /// Builds an `orbit` KML based on the given [satellite] and [tle].
  ///
  /// Returns a [String] that represents the `orbit` KML.
  String buildOrbit(SatelliteEntity satellite, TLEEntity tle) {
    final coord = tle.read();

    final lookAt = LookAtEntity(
      lng: coord['lng']!,
      lat: coord['lat']!,
      altitude: coord['alt']! * 1,
      range: (coord['alt']! * 3).toString(),
      tilt: '60',
      heading: '0',
    );

    return OrbitEntity.buildOrbit(OrbitEntity.tag(lookAt));
  }
}
