import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:TasksSphere/main.dart' as app;

/// Nimmt die Bilder fuer den App Store auf.
///
/// Aufruf gegen ein Backend mit vorzeigbaren Daten:
///
///   SCREENSHOT_DIR=build/screenshots flutter drive \
///     --driver=test_driver/integration_test.dart \
///     --target=integration_test/screenshots_test.dart \
///     -d `<simulator>` \
///     --dart-define=API_BASE_URL=http://127.0.0.1:8010/api \
///     --dart-define=SCREENSHOT_TOKEN=`<Sanctum-Token>` \
///     --dart-define=SCREENSHOT_USER='{"id":2,"name":"..."}'
///
/// Die Anmeldung wird direkt in die Preferences geschrieben - im Prozess der
/// App, also am richtigen Ort. Von aussen laesst sich das im Simulator nicht
/// zuverlaessig setzen.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const token = String.fromEnvironment('SCREENSHOT_TOKEN');
  const user = String.fromEnvironment('SCREENSHOT_USER');

  Future<void> settle(WidgetTester tester, [int seconds = 3]) async {
    // pumpAndSettle haengt bei laufenden Animationen und Netzabrufen;
    // eine feste Wartezeit ist hier ehrlicher.
    await tester.pump(Duration(seconds: seconds));
    await tester.pump(const Duration(milliseconds: 300));
  }

  /// Wartet, bis der Finder etwas findet - der App-Start (Firebase, Netz) dauert
  /// unterschiedlich lang, eine feste Wartezeit reicht nicht immer.
  Future<void> waitFor(WidgetTester tester, Finder finder, {int seconds = 40}) async {
    for (var i = 0; i < seconds * 2; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (finder.evaluate().isNotEmpty) return;
    }
    throw StateError('Nicht gefunden nach $seconds s: $finder');
  }

  Future<void> shot(WidgetTester tester, String name) async {
    await settle(tester, 1);
    await binding.takeScreenshot(name);
  }

  /// Zurueck ueber den Navigator statt pageBack(): die Ansichten haben eigene
  /// Zurueck-Knoepfe, die pageBack() nicht erkennt.
  Future<void> goBack(WidgetTester tester) async {
    tester.state<NavigatorState>(find.byType(Navigator).first).pop();
    await settle(tester, 2);
  }

  Future<void> openDrawer(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.menu));
    await settle(tester, 1);
  }

  testWidgets('App-Store-Bilder', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('storage_mode', 'cloud');
    await prefs.setString('auth_token', token);
    await prefs.setString('user_data', user.isNotEmpty ? user : jsonEncode({'id': 0, 'name': ''}));

    app.main();
    await waitFor(tester, find.byIcon(Icons.menu));
    await settle(tester, 3);

    // 1 - Aufgaben
    await shot(tester, '01-aufgaben');

    // 2 - Listen
    await openDrawer(tester);
    await tester.tap(find.text('Listen'));
    await settle(tester, 4);
    await shot(tester, '02-listen');

    // 3 - Eine Checkliste
    await tester.tap(find.text('Einkauf').first);
    await settle(tester, 3);
    await shot(tester, '03-checkliste');
    await goBack(tester); // Checkliste -> Listen
    await goBack(tester); // Listen -> Aufgaben

    // 4 - Kalender
    await openDrawer(tester);
    await tester.tap(find.text('Kalender'));
    await settle(tester, 4);
    await shot(tester, '04-kalender');
    await goBack(tester);

    // 5 - Drawer mit Rechtlichem
    await openDrawer(tester);
    await shot(tester, '05-menue');
  });
}
