import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:satnogs_visualization_tool/entities/settings_entity.dart';
import 'package:satnogs_visualization_tool/entities/ssh_entity.dart';
import 'package:satnogs_visualization_tool/services/lg_service.dart';
import 'package:satnogs_visualization_tool/services/settings_service.dart';
import 'package:satnogs_visualization_tool/services/ssh_service.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';
import 'package:satnogs_visualization_tool/utils/snackbar.dart';
import 'package:satnogs_visualization_tool/widgets/button.dart';
import 'package:satnogs_visualization_tool/widgets/input.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  SettingsService get _settingsService => GetIt.I<SettingsService>();
  SSHService get _sshService => GetIt.I<SSHService>();
  LGService get _lgService => GetIt.I<LGService>();

  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _pwController = TextEditingController();

  late TabController _tabController;

  bool _connected = false;
  bool _loading = false;
  bool _canceled = false;

  bool _clearingKml = false;
  bool _rebooting = false;
  bool _relaunching = false;
  bool _shuttingDown = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initNetworkState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  /// Initializes and sets the network connection form.
  void _initNetworkState() async {
    try {
      final settings = _settingsService.getSettings();

      setState(() {
        _usernameController.text = settings.username;
        _portController.text = settings.port.toString();
        _pwController.text = settings.password;
      });

      if (settings.ip.isNotEmpty) {
        setState(() {
          _ipController.text = settings.ip;
        });

        _checkConnection();
        return;
      }

      final ips = await NetworkInterface.list(type: InternetAddressType.IPv4);

      if (ips.isEmpty || ips.first.addresses.isEmpty) {
        return;
      }

      setState(() {
        _ipController.text = ips.first.addresses.first.address;
      });

      _checkConnection();
    } on Exception {
      setState(() {
        _ipController.text = '';
      });
    }
  }

  /// Checks and sets the connection status according to the form info.
  Future<void> _checkConnection() async {
    _timer?.cancel();

    setState(() {
      _timer = null;
      _loading = true;
      _canceled = false;
    });

    _setSSH();

    try {
      if (_ipController.text.isEmpty ||
          _usernameController.text.isEmpty ||
          _portController.text.isEmpty) {
        return setState(() {
          _loading = false;
        });
      }

      final timer = Timer(const Duration(seconds: 5), () {
        showSnackbar(context, 'Connection failed');

        setState(() {
          _loading = false;
          _connected = false;
          _canceled = true;
        });
      });

      setState(() {
        _timer = timer;
      });

      final result = await _sshService.connect();
      _timer?.cancel();

      if (!_canceled) {
        setState(() {
          _connected = result == 'session_connected';
        });

        if (result == 'session_connected') {
          await _lgService.setLogos();
        }
      }
    } on Exception catch (e) {
      // ignore: avoid_print
      print('$e');
      if (!_canceled) {
        setState(() {
          _connected = false;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('$e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  /// Sets the SSH client info based into the form.
  void _setSSH() {
    _sshService.setClient(SSHEntity(
      host: _ipController.text,
      passwordOrKey: _pwController.text,
      port: int.parse(_portController.text),
      username: _usernameController.text,
    ));
  }

  /// Connects to the a machine according to the form info.
  void _onConnect() async {
    setState(() {
      _loading = true;
    });

    await _settingsService.setSettings(
      SettingsEntity(
          ip: _ipController.text,
          password: _pwController.text,
          port: int.parse(_portController.text),
          username: _usernameController.text),
    );

    await _checkConnection();

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        shadowColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          splashRadius: 24,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.build_rounded),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: ThemeColors.primaryColor,
          labelColor: ThemeColors.primaryColor,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(
              icon: Icon(Icons.connected_tv_rounded),
              text: 'Connection',
            ),
            Tab(
              icon: Icon(Icons.south_america),
              text: 'Liquid Galaxy',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConnectionSettings(),
          _buildLGSettings(),
        ],
      ),
    );
  }

  /// Builds the connection settings/form.
  Widget _buildConnectionSettings() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Establish connection to the system',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                _connected ? 'Connected' : 'Disconnected',
                style: TextStyle(
                  color: _connected ? ThemeColors.success : ThemeColors.alert,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Input(
                controller: _usernameController,
                label: 'Username',
                hint: 'username',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.person_rounded, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Input(
                controller: _pwController,
                label: 'Password',
                hint: 'p@ssw0rd',
                obscure: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.key_rounded, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Input(
                controller: _ipController,
                label: 'IP',
                hint: '192.168.10.21',
                type: TextInputType.number,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.router_rounded, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Input(
                controller: _portController,
                label: 'Port',
                hint: '3000',
                type: TextInputType.number,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.account_tree_rounded, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Button(
                label: 'Connect',
                width: 140,
                height: 48,
                loading: _loading,
                icon: Icon(
                  Icons.connected_tv_rounded,
                  color: ThemeColors.backgroundColor,
                ),
                onPressed: _onConnect,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the Liquid Galaxy tasks.
  Widget _buildLGSettings() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Control your system',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                _connected ? 'Connected' : 'Disconnected',
                style: TextStyle(
                  color: _connected ? ThemeColors.success : ThemeColors.alert,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
            _buildLGTaskButton(
              'Clear KML + logos',
              Icons.cleaning_services_rounded,
              () async {
                setState(() {
                  _clearingKml = true;
                });

                try {
                  await _lgService.clearKml(keepLogos: false);
                } finally {
                  setState(() {
                    _clearingKml = false;
                  });
                }
              },
              loading: _clearingKml,
            ),
            _buildLGTaskButton(
              'Relaunch',
              Icons.reset_tv_rounded,
              () async {
                setState(() {
                  _relaunching = true;
                });

                try {
                  await _lgService.relaunch();
                } finally {
                  setState(() {
                    _relaunching = false;
                  });
                }
              },
              loading: _relaunching,
            ),
            _buildLGTaskButton(
              'Reboot',
              Icons.restart_alt_rounded,
              () async {
                setState(() {
                  _rebooting = true;
                });

                try {
                  await _lgService.reboot();
                } finally {
                  setState(() {
                    _rebooting = false;
                  });
                }
              },
              loading: _rebooting,
            ),
            _buildLGTaskButton(
              'Power off',
              Icons.power_settings_new_rounded,
              () async {
                setState(() {
                  _shuttingDown = true;
                });

                try {
                  await _lgService.shutdown();
                  setState(() {
                    _connected = false;
                  });
                } finally {
                  setState(() {
                    _shuttingDown = false;
                  });
                }
              },
              loading: _shuttingDown,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the tasks button.
  Widget _buildLGTaskButton(
    String label,
    IconData icon,
    Function() onPressed, {
    bool loading = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Button(
        label: label,
        width: 300,
        height: 48,
        color: _connected ? ThemeColors.primaryColor : Colors.grey,
        loading: loading,
        onPressed: () {
          if (!_connected || loading) {
            return;
          }

          onPressed();
        },
        icon: Icon(
          icon,
          color: ThemeColors.backgroundColor,
        ),
      ),
    );
  }
}
