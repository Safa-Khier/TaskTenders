import 'package:local_auth/local_auth.dart';

class AuthLocalService {
  static Future<bool> authenticate() async {
    final LocalAuthentication localAuth = LocalAuthentication();
    bool authenticated = false;
    try {
      final bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      if (canCheckBiometrics) {
        authenticated = await localAuth.authenticate(
          localizedReason: 'Authenticate to access the app',
        );
        return authenticated;
      }
    } catch (e) {
      print(e);
      return authenticated;
    }
    return authenticated;
  }
}
