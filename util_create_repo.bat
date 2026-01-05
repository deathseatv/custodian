@echo off
setlocal EnableExtensions

cd /d "%~dp0"

git rev-parse --is-inside-work-tree >nul 2>&1
if %errorlevel%==0 (
  echo Git repo detected: "%CD%"
  goto :done
)

if exist ".git" (
  echo ".git" exists but repo not detected. Not modifying.
  goto :done
)

git init >nul 2>&1
if %errorlevel%==0 (
  echo Initialized Git repo: "%CD%"
) else (
  echo Failed to initialize Git repo. Is Git installed and on PATH?
)

:done
pause
exit /b 0
