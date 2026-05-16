# UNCOMMENT THESE LINES TO BUILD FROM LATEST COMMIT
# git reset --hard origin/main
# git pull

cd app

fvm flutter clean
fvm flutter pub get
fvm flutter build windows

if (!(Test-Path build/windows/x64/runner/Release/connectivity_plus_plugin.dll)) {
  throw "Windows bundle is missing connectivity_plus_plugin.dll"
}

Compress-Archive -Path build/windows/x64/runner/Release/* -DestinationPath Jet-Mia-XXX-windows-x64.zip

cd ..

Write-Output 'Generated Windows zip!'
