import 'package:get_it/get_it.dart';
import 'package:satnogs_visualization_tool/entities/kml/kml_entity.dart';
import 'package:satnogs_visualization_tool/entities/kml/look_at_entity.dart';
import 'package:satnogs_visualization_tool/services/file_service.dart';
import 'package:satnogs_visualization_tool/services/ssh_service.dart';

/// Service responsible for managing the data transfer between the app and the
/// Liquid Galaxy.
class LGService {
  SSHService get _sshService => GetIt.I<SSHService>();
  FileService get _fileService => GetIt.I<FileService>();

  final String _url = 'http://lg1:81';

  /// Puts the given [content] into the `/tmp/query.txt` file.
  Future<void> query(String content) async {
    await _sshService.execute('echo "$content" > /tmp/query.txt');
  }

  /// Uses the [query] method to fly to some place in Google Earth according to
  /// the given [lookAt].
  ///
  /// See [LookAtEntity].
  Future<void> flyTo(LookAtEntity lookAt) async {
    await query('flytoview=${lookAt.linearTag}');
  }

  /// Uses the [query] method to play some tour in Google Earth according to
  /// the given [tourName].
  Future<void> startTour(String tourName) async {
    await query('playtour=$tourName');
  }

  /// Uses the [query] method to stop all tours in Google Earth.
  Future<void> stopTour() async {
    await query('exittour=true');
  }

  /// Sends a the given [kml] to the Liquid Galaxy system.
  ///
  /// It also accepts a [List] of images represents by [Map]s. The [images] must
  /// have the following pattern:
  /// ```
  /// [
  ///   {
  ///     'name': 'img-1.png',
  ///     'path': 'path/to/img-1'
  ///   },
  ///   {
  ///     'name': 'img-2.png',
  ///     'path': 'path/to/img-2'
  ///   }
  /// ]
  /// ```
  Future<void> sendKml(KMLEntity kml,
      {List<Map<String, String>> images = const []}) async {
    final fileName = '${kml.name}.kml';

    await clearKml();

    for (var img in images) {
      final image = await _fileService.createImage(img['name']!, img['path']!);
      await _sshService.upload(image.path);
    }

    final kmlFile = await _fileService.createFile(fileName, kml.body);
    await _sshService.upload(kmlFile.path);

    await _sshService
        .execute('echo "$_url/$fileName" > /var/www/html/kmls.txt');
  }

  /// Sends and starts a `tour` into the Google Earth.
  Future<void> sendTour(String tourKml, String tourName) async {
    final fileName = '$tourName.kml';

    final kmlFile = await _fileService.createFile(fileName, tourKml);
    await _sshService.upload(kmlFile.path);

    await _sshService
        .execute('echo "\n$_url/$fileName" >> /var/www/html/kmls.txt');
  }

  /// Clears all `KMLs` from the Google Earth.
  Future<void> clearKml() async {
    await stopTour();
    await _sshService.execute('> /var/www/html/kmls.txt');
  }
}
