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

  String _ip = '';
  String _port = '';

  final _ipController = TextEditingController();
  final _portController = TextEditingController();

  @override
  void initState() {
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
        _ip = ips.first.addresses.first.address;
        _ipController.text = _ip;
      });
    } on Exception {
      setState(() {
        _ip = '';
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
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                          _connected
                              ? 'Connected'
                              : 'Establish connection to the system',
                          style: TextStyle(
                              color: _connected
                                  ? ThemeColors.success
                                  : Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20))),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Input(
                          controller: _ipController,
                          label: 'IP',
                          hint: '192.168.10.21',
                          onChange: (value) {
                            setState(() {
                              _ip = value;
                            });
                          })),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Input(
                          controller: _portController,
                          label: 'Port',
                          hint: '3000',
                          onChange: (value) {
                            setState(() {
                              _port = value;
                            });
                          })),
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
              ))
            ],
          )),
    );
  }
}
