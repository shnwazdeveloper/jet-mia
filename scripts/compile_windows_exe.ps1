cd app

fvm flutter clean
fvm flutter pub get
fvm flutter build windows

Remove-Item "D:\inno" -Force  -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path "D:\inno"
Copy-Item -Path "build\windows\x64\runner\Release\*" -Destination "D:\inno" -Recurse
Copy-Item -Path "assets\packaging\logo.ico" -Destination "D:\inno"

if (!(Test-Path "D:\inno\connectivity_plus_plugin.dll")) {
  throw "Windows installer staging folder is missing connectivity_plus_plugin.dll"
}

cd ..

Copy-Item -Path "scripts\windows\x64\*" -Destination "D:\inno" -Recurse
Remove-Item "D:\inno-result" -Force  -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path "D:\inno-result"
iscc .\scripts\compile_windows_exe-inno.iss

Write-Output 'Generated Windows exe installer!'
