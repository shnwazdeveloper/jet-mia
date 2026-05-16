# Jet Mia

Jet Mia is an open-source local file sharing app. It lets nearby devices share files and messages over the local network without requiring an internet connection.

## Links

- Repository: https://github.com/SHNWAZX/jet-mia
- Privacy Policy: https://github.com/SHNWAZX/jet-mia/blob/main/PRIVACY.md
- Support: https://github.com/SHNWAZX

## Downloads

GitHub Actions builds the Android APK and Windows ZIP from the `main` branch.

- Android: download the `jet-mia-apk` artifact and install `jet-mia.apk`.
- Windows: download `jet-mia-windows-x64.zip`, extract the whole ZIP, then run `jet_mia.exe` from the extracted folder.

Do not run a copied standalone `jet_mia.exe` by itself on Windows. Flutter desktop apps need the DLL files next to the EXE, including `connectivity_plus_plugin.dll`.

## Building

Run these commands from the `app` directory after installing Flutter and Rust:

```bash
flutter pub get
flutter build apk --release
flutter build windows --release
```

The Windows release output is in `app/build/windows/x64/runner/Release/`. Keep that folder together when sharing the app.
