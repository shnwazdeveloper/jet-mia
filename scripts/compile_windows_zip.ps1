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

$releaseDir = "build/windows/x64/runner/Release"
$packageDir = "build/windows/x64/runner/jet_mia_windows_x64"

if (Test-Path $packageDir) {
  Remove-Item -LiteralPath $packageDir -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $packageDir | Out-Null
Copy-Item "$releaseDir/jet_mia.exe" $packageDir
Copy-Item "$releaseDir/*.dll" $packageDir
Copy-Item "$releaseDir/data" $packageDir -Recurse

$blockedExtensions = @("*.lnk", "*.lib", "*.exp", "*.pdb")
foreach ($pattern in $blockedExtensions) {
  $blockedFiles = Get-ChildItem $packageDir -Recurse -File -Filter $pattern
  if ($blockedFiles) {
    throw "Windows ZIP contains unsupported file type: $($blockedFiles[0].FullName)"
  }
}

Compress-Archive -Path "$packageDir/*" -DestinationPath jet_mia_windows_x64.zip -Force

cd ..

Write-Output 'Generated Windows zip!'
