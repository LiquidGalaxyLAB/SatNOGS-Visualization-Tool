import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:satnogs_visualization_tool/entities/satellite_entity.dart';
import 'package:satnogs_visualization_tool/utils/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service that deals with all satellite data management.
class SatelliteService {
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
      {Map<String, String>? params, List<String>? join}) async {
    String query = API.buildQuery(params);

    final response = await http.get(
        Uri.parse('${API.baseUrl}/$_endpoint/?format=json&$query'),
        headers: {'Authorization': 'Token ' + dotenv.env['API_KEY']!});

    final res = json.decode(response.body) as List<dynamic>;
    return res.map((s) => SatelliteEntity.fromMap(s)).toList();
  }
}
