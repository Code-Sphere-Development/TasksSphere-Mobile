/// Zentrale Adressen der Anwendung.
///
/// Die API-Adresse laesst sich zur Bauzeit ueberschreiben, etwa fuer eine lokale
/// Instanz oder Screenshots:
///
///     flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000/api
///
/// Ohne Angabe gilt die Produktion.
class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://tasks.code-sphere.de/api',
  );

  /// Die Weboberflaeche liegt eine Ebene ueber der API.
  static String get webBaseUrl =>
      apiBaseUrl.endsWith('/api') ? apiBaseUrl.substring(0, apiBaseUrl.length - 4) : apiBaseUrl;

  static Uri get imprintUrl => Uri.parse('$webBaseUrl/impressum');
  static Uri get privacyUrl => Uri.parse('$webBaseUrl/datenschutz');
  static Uri get contactUrl => Uri.parse('$webBaseUrl/kontakt');
}
