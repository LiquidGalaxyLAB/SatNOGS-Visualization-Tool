import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:satnogs_visualization_tool/entities/tle_entity.dart';
import 'package:satnogs_visualization_tool/services/local_storage_service.dart';
import 'package:satnogs_visualization_tool/utils/api.dart';
import 'package:satnogs_visualization_tool/utils/storage_keys.dart';

/// Service that deals with all TLE data management.
class TLEService {
  LocalStorageService get _localStorageService =>
      GetIt.I<LocalStorageService>();

  /// Property that defines the TLE access endpoint.
  final _endpoint = 'tle';

  /// Gets one TLE from the database according to the given [satelliteId].
  Future<TLEEntity?> getOne(String satelliteId) async {
    final response = await http.get(
        Uri.parse('${API.baseUrl}/$_endpoint/?sat_id=$satelliteId'),
        headers: {'Authorization': 'Token ' + dotenv.env['API_KEY']!});

    final res = json.decode(response.body) as List<dynamic>;
    return res.isNotEmpty ? TLEEntity.fromMap(res[0]) : null;
  }

  /// Gets multiple TLEs from the database.
  Future<List<TLEEntity>> getMany({
    bool synchronize = false,
    bool offline = false,
  }) async {
    final hasLocal = _localStorageService.hasItem(StorageKeys.tle);

    if ((!synchronize || offline) && hasLocal) {
      List<dynamic> localTLEs =
          json.decode(_localStorageService.getItem(StorageKeys.tle));

      return localTLEs.map((s) => TLEEntity.fromMap(s)).toList();
    }

    final response = await http.get(Uri.parse('${API.baseUrl}/$_endpoint'),
        headers: {'Authorization': 'Token ' + dotenv.env['API_KEY']!});

    _localStorageService.setItem(StorageKeys.tle, response.body);

    final res = json.decode(response.body) as List<dynamic>;
    return res.map((s) => TLEEntity.fromMap(s)).toList();
  }
}
