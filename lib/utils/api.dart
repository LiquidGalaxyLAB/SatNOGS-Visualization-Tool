/// Class that contains API related utils.
class API {
  /// Property that defines the SatNOGS API URL.
  ///
  /// https://db.satnogs.org/api
  static const baseUrl = 'https://db.satnogs.org/api';

  /// Property that defines the SatNOGS API Network URL.
  ///
  /// https://network.satnogs.org
  static const baseNetworkUrl = 'https://network.satnogs.org';

  /// Builds and returns a query according to the given [params].
  ///
  /// Example
  /// ```
  /// String query = API.buildQuery({
  ///   'sat_id': '1234567890abcdef',
  ///   'in_orbit': '',
  ///   'status': 'alive'
  /// });
  /// print(query); => 'sat_id=1234567890abcdef&in_orbit=&status=alive'
  /// ```
  static String buildQuery(Map<String, String>? params) {
    if (params == null) {
      return '';
    }

    String query = '';

    for (var element in params.entries) {
      if (element.key.isEmpty) {
        continue;
      }

      if (query.isNotEmpty) {
        query += '&';
      }

      query += '${element.key}=${element.value}';
    }

    return query;
  }
}
