/// Entity that represents the `settings`, with all of its properties and methods.
class SettingsEntity {
  /// Property that defines the Liquid Galaxy master username.
  /// Defaults to 'lg'.
  String username;

  /// Property that defines the Liquid Galaxy master password.
  String password;

  /// Property that defines the Liquid Galaxy master IP.
  String ip;

  /// Property that defines the Liquid Galaxy master SSH port.
  /// Defaults to 22.
  int port;

  SettingsEntity(
      {this.username = 'lg', this.password = '', this.ip = '', this.port = 22});

  /// Turns a `Map` into a `SettingsEntity`.
  factory SettingsEntity.fromMap(Map<String, dynamic> map) {
    return SettingsEntity(
        username: map['username'],
        password: map['password'],
        ip: map['ip'],
        port: map['port']);
  }

  /// Return a `Map` from the current `SettingsEntity`.
  Map<String, dynamic> toMap() => {
        'username': username,
        'password': password,
        'ip': ip,
        'port': port,
      };
}
