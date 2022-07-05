import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:satnogs_visualization_tool/entities/satellite_entity.dart';
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
  Future<List<SatelliteEntity>> getMany(
      {Map<String, String>? params,
      List<String>? join,
      bool synchronize = false,
      bool offline = false}) async {
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
}
