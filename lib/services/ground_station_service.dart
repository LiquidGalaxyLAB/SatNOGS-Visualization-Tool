import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:satnogs_visualization_tool/entities/ground_station_entity.dart';
import 'package:satnogs_visualization_tool/entities/kml/kml_entity.dart';
import 'package:satnogs_visualization_tool/entities/kml/line_entity.dart';
import 'package:satnogs_visualization_tool/entities/kml/look_at_entity.dart';
import 'package:satnogs_visualization_tool/entities/kml/orbit_entity.dart';
import 'package:satnogs_visualization_tool/entities/kml/placemark_entity.dart';
import 'package:satnogs_visualization_tool/entities/kml/point_entity.dart';
import 'package:satnogs_visualization_tool/services/local_storage_service.dart';
import 'package:satnogs_visualization_tool/utils/api.dart';
import 'package:satnogs_visualization_tool/utils/storage_keys.dart';

/// Service that deals with all ground station data management.
class GroundStationService {
  LocalStorageService get _localStorageService =>
      GetIt.I<LocalStorageService>();

  /// Property that defines the ground station access endpoint.
  final _endpoint = 'stations';

  /// Property that defines the ground station request headers.
  final _requestHeaders = {
    'authority': 'network.satnogs.org',
    'accept': '/',
    'accept-language': 'pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7',
    'cookie': '_ga=GA1.2.2037232832.1654274873',
    'dnt': '1',
    'referer': 'https://network.satnogs.org/stations/',
    'x-requested-with': 'XMLHttpRequest',
  };

  /// Gets one ground station from the database according to the given [id].
  Future<Map<String, dynamic>> getOne(int id) async {
    final response = await http.get(
      Uri.parse('${API.baseNetworkUrl}/$_endpoint/$id'),
      headers: _requestHeaders,
    );

    final res = response.body;

    final el = Document().createElement('');
    el.innerHtml = res;

    final dataLines = el.querySelectorAll('.front-line');

    Map<String, dynamic> data = {};

    for (var e in dataLines) {
      final key = e.querySelector('.label');
      final value = e.querySelector('.front-data');

      if (key == null) {
        continue;
      }

      data[key.text] = value == null ? '' : value.text;
    }

    final elAntennas = el.querySelector('.antennas .front-data');
    final antennas = elAntennas?.children.length ?? 0;
    data['Antennas'] = antennas;

    return data;
  }

  /// Gets multiple ground stations from the database.
  Future<List<GroundStationEntity>> getMany(
      {bool synchronize = false, bool offline = false}) async {
    final hasLocal = _localStorageService.hasItem(StorageKeys.groundStations);

    if ((!synchronize || offline) && hasLocal) {
      List<dynamic> localStations =
          json.decode(_localStorageService.getItem(StorageKeys.groundStations));

      return localStations
          .map((gs) => GroundStationEntity.fromMap(gs))
          .toList();
    }

    final response = await http.get(
      Uri.parse('${API.baseNetworkUrl}/${_endpoint}_all'),
      headers: _requestHeaders,
    );

    _localStorageService.setItem(StorageKeys.groundStations, response.body);

    final res = json.decode(response.body) as List<dynamic>;
    return res.map((gs) => GroundStationEntity.fromMap(gs)).toList();
  }

  /// Builds and returns a satellite `KML` [String] according to the given
  /// [station].
  KMLEntity buildKml(
    GroundStationEntity station,
    bool balloon, {
    Map<String, dynamic>? extraData,
    bool updatePosition = true,
  }) {
    final lookAt = LookAtEntity(
      lng: station.lng,
      lat: station.lat,
      range: '1500',
      tilt: '60',
      heading: '0',
    );

    final point = PointEntity(
      lat: lookAt.lat,
      lng: lookAt.lng,
      altitude: lookAt.altitude,
    );

    final placemark = PlacemarkEntity(
      id: station.id.toString(),
      name: '${station.name} (${station.getStatusLabel().toUpperCase()})',
      lookAt: updatePosition ? lookAt : null,
      point: point,
      description: '',
      balloonContent:
          extraData != null && balloon ? station.balloonContent(extraData) : '',
      icon: 'station.png',
      line: LineEntity(id: station.id.toString(), coordinates: []),
    );

    return KMLEntity(
      name: station.name.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''),
      content: placemark.tag,
    );
  }

  /// Builds an `orbit` KML based on the given [station].
  ///
  /// Returns a [String] that represents the `orbit` KML.
  String buildOrbit(GroundStationEntity station) {
    final lookAt = LookAtEntity(
      lng: station.lng,
      lat: station.lat,
      range: '1500',
      tilt: '60',
      heading: '0',
    );

    return OrbitEntity.buildOrbit(OrbitEntity.tag(lookAt));
  }
}
