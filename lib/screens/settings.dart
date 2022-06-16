import 'dart:io';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    _usernameController.text = 'lg';
    _portController.text = '22';

    super.initState();
    _initNetworkState();
  }

  void _initNetworkState() async {
    try {
      final ips = await NetworkInterface.list(type: InternetAddressType.IPv4);

      if (ips.isEmpty || ips.first.addresses.isEmpty) {
        return;
      }

      setState(() {
        _ipController.text = ips.first.addresses.first.address;
      });
    } on Exception {
      setState(() {
        _ipController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        shadowColor: Colors.transparent,
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
                        hint: 'lg',
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
                        hint: '••••••••',
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
                          onPressed: () async {
                            // TODO: Implement connection logic.

                            setState(() {
                              _loading = true;
                            });

                            await Future.delayed(const Duration(seconds: 2));

                            setState(() {
                              _connected = !_connected;
                              _loading = false;
                            });
                          })),
                ],
              )))
            ],
          )),
    );
  }
}
