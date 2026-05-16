$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$appDir = Join-Path $repoRoot "app"
$stagingDir = Join-Path $repoRoot "artifacts\jet_mia_installer_input"
$outputDir = Join-Path $repoRoot "artifacts"

function Invoke-Flutter {
  param([Parameter(ValueFromRemainingArguments = $true)][string[]] $FlutterArgs)

  if (Get-Command fvm -ErrorAction SilentlyContinue) {
    & fvm flutter @FlutterArgs
  } else {
    & flutter @FlutterArgs
  }
}

Push-Location $appDir
Invoke-Flutter clean
Invoke-Flutter pub get
Invoke-Flutter build windows --release
Pop-Location

$releaseDir = Join-Path $appDir "build\windows\x64\runner\Release"
if (!(Test-Path (Join-Path $releaseDir "jet_mia.exe"))) {
  throw "Windows bundle is missing jet_mia.exe"
}
if (!(Test-Path (Join-Path $releaseDir "connectivity_plus_plugin.dll"))) {
  throw "Windows bundle is missing connectivity_plus_plugin.dll"
}

Remove-Item $stagingDir -Force -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $stagingDir | Out-Null
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

Copy-Item -Path (Join-Path $releaseDir "jet_mia.exe") -Destination $stagingDir
Copy-Item -Path (Join-Path $releaseDir "*.dll") -Destination $stagingDir
Copy-Item -Path (Join-Path $releaseDir "data") -Destination $stagingDir -Recurse
Copy-Item -Path (Join-Path $repoRoot "scripts\windows\x64\*.dll") -Destination $stagingDir -ErrorAction SilentlyContinue
Copy-Item -Path (Join-Path $appDir "assets\packaging\logo.ico") -Destination (Join-Path $stagingDir "logo.ico")

$blockedExtensions = @("*.lnk", "*.lib", "*.exp", "*.pdb")
foreach ($pattern in $blockedExtensions) {
  $blockedFiles = Get-ChildItem $stagingDir -Recurse -File -Filter $pattern
  if ($blockedFiles) {
    throw "Windows installer input contains unsupported file type: $($blockedFiles[0].FullName)"
  }
}

$env:JET_MIA_SOURCE_DIR = (Resolve-Path $stagingDir).Path
$env:JET_MIA_OUTPUT_DIR = (Resolve-Path $outputDir).Path

$isccCandidates = @(
  "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
  "${env:ProgramFiles}\Inno Setup 6\ISCC.exe",
  "iscc"
)
$iscc = $isccCandidates | Where-Object { Get-Command $_ -ErrorAction SilentlyContinue } | Select-Object -First 1
if (!$iscc) {
  throw "ISCC.exe was not found. Install Inno Setup 6 and try again."
}

& $iscc (Join-Path $repoRoot "scripts\compile_windows_exe-inno.iss")

Write-Output "Generated $outputDir\jet_mia_windows_x64.exe"
