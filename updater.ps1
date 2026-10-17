# family-reels-agent updater (runs on the user's Windows PC)
# Downloaded fresh from GitHub on every run, so this logic can be updated freely.
# Target folder is passed in via the FRA_DIR environment variable (set by update.bat).

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$repo = 'geminifree00001/family-reels-agent'
$target = $env:FRA_DIR
if (-not $target) { $target = (Get-Location).Path }

Write-Host '[family-reels-agent] update check...'

$remoteVer = ''
try {
  $remoteVer = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/$repo/main/VERSION" -UseBasicParsing).Content.Trim()
} catch {
  Write-Host 'version check failed, downloading anyway...'
}

$localVer = 'none'
$verFile = Join-Path $target 'VERSION'
if (Test-Path $verFile) { $localVer = (Get-Content $verFile -Raw).Trim() }

Write-Host "local: $localVer / latest: $remoteVer"
if ($remoteVer -and ($localVer -eq $remoteVer)) {
  Write-Host 'already up to date.'
  return
}

Write-Host 'downloading latest files...'
$tmpZip = Join-Path $env:TEMP 'fra-update.zip'
$tmpDir = Join-Path $env:TEMP 'fra-update'
Invoke-WebRequest -Uri "https://github.com/$repo/archive/refs/heads/main.zip" -OutFile $tmpZip
if (Test-Path $tmpDir) { Remove-Item -Recurse -Force $tmpDir }
Expand-Archive -Path $tmpZip -DestinationPath $tmpDir -Force

$src = Join-Path $tmpDir 'family-reels-agent-main'
Copy-Item -Path (Join-Path $src '*') -Destination $target -Recurse -Force

Remove-Item $tmpZip -Force -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue

$newVer = (Get-Content (Join-Path $target 'VERSION') -Raw).Trim()
Write-Host "updated to $newVer."
