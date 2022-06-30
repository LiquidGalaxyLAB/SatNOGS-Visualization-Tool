/// Entity that represents the `ssh`, with all of its properties and methods.
class SSHEntity {
  /// Property that defines the SSH host address.
  ///
  /// Example
  /// ```
  /// '192.168.0.1'
  /// ```
  String host;

  /// Property that defines the SSH port. Defaults to 22.
  int port;

  /// Property that defines the SSH machine username.
  String username;

  /// Property that defines the SSH machine password or RSA private key.
  String passwordOrKey;

  SSHEntity(
      {this.host = '',
      this.port = 22,
      this.username = '',
      this.passwordOrKey = ''});
}
