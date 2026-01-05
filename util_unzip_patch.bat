@echo off
setlocal EnableExtensions

set "ROOT=%~dp0"
pushd "%ROOT%" >nul

for /f "usebackq delims=" %%Z in (`
  powershell -NoLogo -NoProfile -Command ^
    "$z = Get-ChildItem -LiteralPath '.' -Filter '*.zip' -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1; if($z){$z.Name}"
`) do set "ZIP=%%Z"

if not defined ZIP (
  echo No .zip files found in: "%ROOT%"
  popd >nul
  pause
  exit /b 2
)

echo Using zip: "%ZIP%"
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command ^
  "Expand-Archive -LiteralPath '%ZIP%' -DestinationPath '.' -Force"

set "ERR=%ERRORLEVEL%"
if not "%ERR%"=="0" (
  echo Unzip failed with exit code %ERR%.
  popd >nul
  pause
  exit /b %ERR%
)

echo Done: extracted "%ZIP%" to "%ROOT%" (overwrites enabled).
popd >nul
pause
exit /b 0
