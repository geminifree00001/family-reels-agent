@echo off
rem family-reels-agent updater launcher (v4)
rem This file never changes. All update logic lives in updater.ps1 on GitHub.
set FRA_DIR=%~dp0
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/geminifree00001/family-reels-agent/main/updater.ps1' -UseBasicParsing -OutFile $env:TEMP\fra-updater.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\fra-updater.ps1"
del "%TEMP%\fra-updater.ps1" 2>nul
pause
