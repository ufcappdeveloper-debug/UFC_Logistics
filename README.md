# UFC Logistics

Flutter mobile app for Android and iOS (`sa.com.ufc.logistics`).

## Release 1.0.22 (33)

- Flutter 3.44.3, pinned in `.fvmrc`.
- Android: compile/target API 36, minimum Android 7 (API 24).
- iOS: minimum iOS 15, built with the installed Xcode 27.2 SDK.
- Android controls respect bottom and landscape system navigation insets.

## Build and verify

```sh
fvm flutter pub get
fvm flutter analyze lib test --no-fatal-infos --no-fatal-warnings
fvm flutter test
fvm flutter build appbundle --release
fvm flutter build ipa --release --export-method app-store
```

Android output: `build/app/outputs/bundle/release/app-release.aab`.
iOS output: `build/ios/ipa/Logistics.ipa`.

Android release signing uses the existing local `android/key.properties` and
upload keystore. Keep signing credentials out of version control.
iOS uploads require a valid App Store Connect session in Xcode Settings.

## Localization

```sh
fvm flutter pub run easy_localization:generate --source-dir ./assets/lang --output-dir ./lib/generated/
```
