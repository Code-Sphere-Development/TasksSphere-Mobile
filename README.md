# TasksSphere

Task App for CodeSphere

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Fehler- und Log-Tracking (GlitchTip)

Die App meldet Fehler, Logs und Performance-Daten über `sentry_flutter` an eine
selbst gehostete GlitchTip-Instanz. Die DSN steht nicht im Code, sondern wird beim
Build übergeben:

```sh
flutter build apk --release --dart-define=SENTRY_DSN=<DSN aus GlitchTip, Projekt taskssphere-mobile>
```

- Ohne `SENTRY_DSN` wird Sentry nicht initialisiert – kein Tracking.
- Umgebung: `production` im Release-, sonst `debug`; überschreibbar mit
  `--dart-define=SENTRY_ENVIRONMENT=<name>`.
- In der CI kommt die DSN aus dem Repository-Secret `SENTRY_DSN`.
