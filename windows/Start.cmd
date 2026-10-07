@echo off
setlocal
chcp 65001 >nul
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Bootstrap.ps1"
if errorlevel 1 (
  echo.
  echo 启动失败。请按任意键查看错误后退出。
  pause >nul
)
