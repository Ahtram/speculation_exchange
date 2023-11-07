import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'DO_SPACE_ACCESS_KEY', obfuscate: true)
  static String doSpaceAccessKey = _Env.doSpaceAccessKey;

  @EnviedField(varName: 'DO_SPACE_SECRET', obfuscate: true)
  static String doSpaceSecret = _Env.doSpaceSecret;
}