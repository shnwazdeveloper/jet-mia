# Jet Mia Changelog

## 1.17.2+60 (2026-05-16)

- Fixed Windows and Android file transfers failing after the receiver accepted the request.
- Published Windows as a single `jet_mia_windows_x64.exe` installer instead of a ZIP file.
- Kept the installer clean by bundling only the Jet Mia runtime files needed to run the app.

## 1.17.1+59 (2026-05-16)

- Updated the visible app screens to use Jet Mia branding.
- Updated About, Settings, Donate, Privacy Policy, homepage, and source links for SHNWAZX/jet-mia.
- Replaced upstream donation buttons with Jet Mia support links.
- Fixed the Windows GitHub artifact so users download the full ZIP bundle with plugin DLLs, including connectivity_plus_plugin.dll.
- Kept Android APK builds published as the Jet Mia APK artifact.
- Fixed stale file-transfer sessions where Windows stayed queued and Android showed "recipient busy" after a failed upload.
- Added optional update notifications with an "Update now" action that opens the latest GitHub release.
- Renamed release downloads to `jet_mia.apk` and `jet_mia_windows_x64.zip`.
- Cleaned the Windows ZIP so it only contains the portable runtime bundle and no shortcut or developer files.
