# Jet Mia

Jet Mia is an open-source local file sharing app. It lets nearby devices share files and messages over the local network without requiring an internet connection.

## Downloads

GitHub Actions builds the Android APK and Windows EXE installer from the `main` branch.

- Android: download `jet_mia.apk`.
- Windows: download `jet_mia_windows_x64.exe`, run it, then open Jet Mia from the Start menu.

Do not run a copied standalone `jet_mia.exe` by itself on Windows. Flutter desktop apps need the DLL files and `data` folder next to the EXE, so the GitHub release provides a single installer EXE that places everything correctly.

## Building

Run these commands from the `app` directory after installing Flutter and Rust:

```bash
flutter pub get
flutter build apk --release
flutter build windows --release
```

The Windows release output is in `app/build/windows/x64/runner/Release/`. To create the single Windows installer EXE, run `.\scripts\compile_windows_exe.ps1` from the repository root.
