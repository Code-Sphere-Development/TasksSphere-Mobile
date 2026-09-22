import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// Nimmt die Bilder entgegen, die der Test auf dem Geraet aufnimmt, und legt
/// sie im Ordner ab, den SCREENSHOT_DIR vorgibt (Standard: build/screenshots).
Future<void> main() async {
  final dir = Directory(Platform.environment['SCREENSHOT_DIR'] ?? 'build/screenshots')
    ..createSync(recursive: true);

  await integrationDriver(
    onScreenshot: (String name, List<int> bytes, [Map<String, Object?>? args]) async {
      File('${dir.path}/$name.png').writeAsBytesSync(bytes);
      return true;
    },
  );
}
