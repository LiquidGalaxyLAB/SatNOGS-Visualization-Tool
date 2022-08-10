import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:satnogs_visualization_tool/services/file_service.dart';
import 'package:satnogs_visualization_tool/services/ground_station_service.dart';
import 'package:satnogs_visualization_tool/services/lg_service.dart';
import 'package:satnogs_visualization_tool/services/local_storage_service.dart';
import 'package:satnogs_visualization_tool/services/satellite_service.dart';
import 'package:satnogs_visualization_tool/services/settings_service.dart';
import 'package:satnogs_visualization_tool/services/ssh_service.dart';
import 'package:satnogs_visualization_tool/services/tle_service.dart';
import 'package:satnogs_visualization_tool/services/transmitter_service.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';
import 'package:satnogs_visualization_tool/screens/home.dart';

/// Registers all services into the application.
void setupServices() {
  GetIt.I.registerLazySingleton(() => LocalStorageService());
  GetIt.I.registerLazySingleton(() => SettingsService());
  GetIt.I.registerLazySingleton(() => SSHService());
  GetIt.I.registerLazySingleton(() => SatelliteService());
  GetIt.I.registerLazySingleton(() => TLEService());
  GetIt.I.registerLazySingleton(() => GroundStationService());
  GetIt.I.registerLazySingleton(() => TransmitterService());
  GetIt.I.registerLazySingleton(() => LGService());
  GetIt.I.registerLazySingleton(() => FileService());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();

  await GetIt.I<LocalStorageService>().loadStorage();
  await dotenv.load(fileName: ".env");

  GetIt.I<SSHService>().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /// Sets the Liquid Galaxy logos into the rig.
  void setLogos() async {
    try {
      await GetIt.I<LGService>().setLogos();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    setLogos();

    return MaterialApp(
      title: 'SatNOGS Visualization Tool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          canvasColor: Colors.transparent,
          primarySwatch: MaterialColor(ThemeColors.backgroundColorHex,
              ThemeColors.backgroundColorMaterial),
          scaffoldBackgroundColor: ThemeColors.backgroundColor),
      home: const HomePage(),
    );
  }
}
