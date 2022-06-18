// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:satnogs_visualization_tool/entities/ssh_entity.dart';
import 'package:ssh/ssh.dart';

/// Service that deals with the SSH management.
class SSHService {
  /// Property that defines the SSH client instance.
  late SSHClient _client;

  /// Sets a client with the given [ssh] info.
  void setClient(SSHEntity ssh) {
    _client = SSHClient(
        host: ssh.host,
        port: ssh.port,
        username: ssh.username,
        passwordOrKey: ssh.passwordOrKey);
  }

  /// Connects to the current client, executes a command into
  /// it and then disconnects.
  Future<void> execute(String command) async {
    String result = await connect();

    if (result == 'session_connected') {
      await _client.execute(command);
    }

    await disconnect();
  }

  /// Connects to a machine using the current client.
  Future<String> connect() async {
    return _client.connect();
  }

  /// Disconnects from the a machine using the current client.
  Future<SSHClient> disconnect() async {
    await _client.disconnect();
    return _client;
  }
}
