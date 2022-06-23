import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:satnogs_visualization_tool/entities/settings_entity.dart';
import 'package:satnogs_visualization_tool/entities/ssh_entity.dart';
import 'package:satnogs_visualization_tool/services/settings_service.dart';
import 'package:satnogs_visualization_tool/services/ssh_service.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';
import 'package:satnogs_visualization_tool/widgets/button.dart';
import 'package:satnogs_visualization_tool/widgets/input.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _connected = false;
  bool _loading = false;

  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _pwController = TextEditingController();

  SettingsService get _settingsService => GetIt.I<SettingsService>();
  SSHService get _sshService => GetIt.I<SSHService>();

  @override
  void initState() {
    super.initState();
    _initNetworkState();
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
    setState(() {
      _loading = true;
    });

    _setSSH();

    try {
      final result = await _sshService.connect();

      setState(() {
        _connected = result == 'session_connected';
      });

      _sshService.disconnect();
    } on Exception catch (_) {
      setState(() {
        _connected = false;
      });
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

    await _settingsService.setSettings(SettingsEntity(
        ip: _ipController.text,
        password: _pwController.text,
        port: int.parse(_portController.text),
        username: _usernameController.text));

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
            }),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.build_rounded),
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Establish connection to the system',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20)),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(_connected ? 'Connected' : 'Disconnected',
                          style: TextStyle(
                              color: _connected
                                  ? ThemeColors.success
                                  : ThemeColors.alert,
                              fontWeight: FontWeight.w500,
                              fontSize: 20))),
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
                      )),
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
                      )),
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
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Input(
                        controller: _portController,
                        label: 'Port',
                        hint: '3000',
                        type: TextInputType.number,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(Icons.account_tree_rounded,
                              color: Colors.grey),
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Button(
                          label: 'Connect',
                          width: 140,
                          height: 48,
                          loading: _loading,
                          icon: Icon(Icons.connected_tv_rounded,
                              color: ThemeColors.backgroundColor),
                          onPressed: _onConnect)),
                ],
              )))
            ],
          )),
    );
  }
}
