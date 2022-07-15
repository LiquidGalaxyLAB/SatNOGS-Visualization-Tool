import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:satnogs_visualization_tool/entities/transmitter_entity.dart';
import 'package:satnogs_visualization_tool/services/local_storage_service.dart';
import 'package:satnogs_visualization_tool/utils/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:satnogs_visualization_tool/utils/storage_keys.dart';

/// Service that deals with all transmitter data management.
class TransmitterService {
  LocalStorageService get _localStorageService =>
      GetIt.I<LocalStorageService>();

  /// Property that defines the transmitter access endpoint.
  final _endpoint = 'transmitters';

  /// Gets one transmitter from the database according to the given [uuid].
  Future<TransmitterEntity> getOne(String uuid, {List<String>? join}) async {
    final response = await http.get(
        Uri.parse('${API.baseUrl}/$_endpoint/$uuid/?format=json'),
        headers: {'Authorization': 'Token ' + dotenv.env['API_KEY']!});

    final res = json.decode(response.body) as Map;
    return TransmitterEntity.fromMap(res);
  }

  /// Gets multiple transmitters from the database based on the given [params].
  Future<List<TransmitterEntity>> getMany(
      {Map<String, String>? params,
      List<String>? join,
      bool synchronize = false,
      bool offline = false}) async {
    final hasLocal = _localStorageService.hasItem(StorageKeys.transmitters);

    if ((!synchronize || offline) && hasLocal) {
      List<dynamic> localTransmitters =
          json.decode(_localStorageService.getItem(StorageKeys.transmitters));

      return localTransmitters
          .map((t) => TransmitterEntity.fromMap(t))
          .toList();
    }

    String query = API.buildQuery(params);

    final response = await http.get(
        Uri.parse('${API.baseUrl}/$_endpoint/?format=json&$query'),
        headers: {'Authorization': 'Token ' + dotenv.env['API_KEY']!});

    _localStorageService.setItem(StorageKeys.transmitters, response.body);

    final res = json.decode(response.body) as List<dynamic>;
    return res.map((t) => TransmitterEntity.fromMap(t)).toList();
  }
}
