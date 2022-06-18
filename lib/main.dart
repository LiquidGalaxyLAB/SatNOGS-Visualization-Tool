import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:satnogs_visualization_tool/services/local_storage_service.dart';
import 'package:satnogs_visualization_tool/services/settings_service.dart';
import 'package:satnogs_visualization_tool/services/ssh_service.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';
import 'package:satnogs_visualization_tool/screens/home.dart';

/// Registers all services into the application.
void setupServices() {
  GetIt.I.registerLazySingleton(() => LocalStorageService());
  GetIt.I.registerLazySingleton(() => SettingsService());
  GetIt.I.registerLazySingleton(() => SSHService());
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();

  GetIt.I<LocalStorageService>().loadStorage();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SatNOGS Visualization Tool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: MaterialColor(ThemeColors.backgroundColorHex,
              ThemeColors.backgroundColorMaterial),
          scaffoldBackgroundColor: ThemeColors.backgroundColor),
      home: const HomePage(),
    );
  }
}
