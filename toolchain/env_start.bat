@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass "& {& '%~dp0scripts\env_start.ps1' %*}"