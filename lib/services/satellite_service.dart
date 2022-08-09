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

  /// Builds and returns a satellite `Placemark` entity according to the given
  /// [satellite], [tle], [transmitters] and more.
  PlacemarkEntity buildPlacemark(
    SatelliteEntity satellite,
    TLEEntity tle,
    List<TransmitterEntity> transmitters,
    bool balloon,
    double orbitPeriod, {
    LookAtEntity? lookAt,
    bool updatePosition = true,
  }) {
    LookAtEntity lookAtObj;

    if (lookAt == null) {
      final coord = tle.read();

      lookAtObj = LookAtEntity(
        lng: coord['lng']!,
        lat: coord['lat']!,
        altitude: coord['alt']!,
        range: '400000',
        tilt: '60',
        heading: '0',
      );
    } else {
      lookAtObj = lookAt;
    }

    final point = PointEntity(
      lat: lookAtObj.lat,
      lng: lookAtObj.lng,
      altitude: lookAtObj.altitude,
    );

    satellite.tle = tle;

    return PlacemarkEntity(
      id: satellite.id,
      name: '${satellite.name} (${satellite.getStatusLabel().toUpperCase()})',
      lookAt: updatePosition ? lookAtObj : null,
      point: point,
      description: satellite.citation,
      balloonContent:
          balloon ? satellite.balloonContent(transmitters.length) : '',
      icon: 'satellite.png',
      line: LineEntity(
        id: satellite.id,
        altitudeMode: 'absolute',
        coordinates: satellite.getOrbitCoordinates(step: orbitPeriod),
      ),
    );
  }

  /// Builds an `orbit` KML based on the given [satellite] and [tle].
  ///
  /// Returns a [String] that represents the `orbit` KML.
  String buildOrbit(SatelliteEntity satellite, TLEEntity tle,
      {LookAtEntity? lookAt}) {
    LookAtEntity lookAtObj;

    if (lookAt == null) {
      final coord = tle.read();

      lookAtObj = LookAtEntity(
        lng: coord['lng']!,
        lat: coord['lat']!,
        altitude: coord['alt']!,
        range: '400000',
        tilt: '60',
        heading: '0',
      );
    } else {
      lookAtObj = lookAt;
    }

    return OrbitEntity.buildOrbit(OrbitEntity.tag(lookAtObj));
  }
}
