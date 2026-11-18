import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// Stabile Kennung des Geraets, wie sie der Server fuer Push-Geraete und
/// Sitzungen verwendet.
class DeviceIdentity {
  DeviceIdentity._();

  /// Liefert null, wenn das Geraet keine Kennung preisgibt.
  static Future<String?> id() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (kIsWeb) {
        return 'web_browser';
      } else if (Platform.isAndroid) {
        return (await deviceInfo.androidInfo).id;
      } else if (Platform.isIOS) {
        return (await deviceInfo.iosInfo).identifierForVendor;
      } else if (Platform.isMacOS) {
        return (await deviceInfo.macOsInfo).systemGUID;
      }
    } catch (e) {
      debugPrint("Error getting device info: $e");
    }
    return null;
  }

  /// Kennung fuer die Anmeldung. Im Browser teilen sich alle Fenster dieselbe
  /// Platzhalter-Kennung; ein Login dort darf die Sitzung eines anderen
  /// Browsers nicht ersetzen.
  static Future<String?> forLogin() async => kIsWeb ? null : await id();
}
