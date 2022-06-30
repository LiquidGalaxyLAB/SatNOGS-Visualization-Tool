import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:satnogs_visualization_tool/entities/ground_station_entity.dart';
import 'package:satnogs_visualization_tool/enums/ground_station_status_enum.dart';
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
  Future<GroundStationEntity> getOne(int id) async {
    final response = await http.get(
      Uri.parse('${API.baseNetworkUrl}/$_endpoint/$id'),
      headers: _requestHeaders,
    );

    final res = response.body;

    // TODO: implement the html info extraction
    // return GroundStationEntity.fromMap(res);
    return GroundStationEntity(
        id: id,
        name: 'name',
        lat: 38.555972,
        lng: -78.062523,
        status: GroundStationStatusEnum.OFFLINE);
  }

  /// Gets multiple ground stations from the database.
  Future<List<GroundStationEntity>> getMany({bool synchronize = false}) async {
    final hasLocal = _localStorageService.hasItem(StorageKeys.groundStations);

    if (!synchronize && hasLocal) {
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
}
