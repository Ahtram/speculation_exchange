import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'NEXTCLOUD_LOGIN_URL', obfuscate: true)
  static String nextcloudLoginUrl = _Env.nextcloudLoginUrl;

  @EnviedField(varName: 'NEXTCLOUD_LOGIN_NAME', obfuscate: true)
  static String nextcloudLoginName = _Env.nextcloudLoginName;

  @EnviedField(varName: 'NEXTCLOUD_LOGIN_PASSWORD', obfuscate: true)
  static String nextcloudLoginPassword = _Env.nextcloudLoginPassword;
}