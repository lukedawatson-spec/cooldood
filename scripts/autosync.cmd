@echo off
rem Double-click this to start auto-syncing with GitHub.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0autosync.ps1" %*
pause
