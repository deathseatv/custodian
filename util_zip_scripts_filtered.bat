@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "FILTERS=cba_"  REM separate multiple with ;  e.g. cba_;enemy;boss
for %%I in ("%~dp0.") do set "ROOT=%%~fI"
set "ZIP=%ROOT%\scripts.zip"
set "STAGE=%TEMP%\gml_stage_%RANDOM%%RANDOM%"

if exist "%ZIP%" del /f /q "%ZIP%" >nul 2>&1
if exist "%STAGE%" rmdir /s /q "%STAGE%" >nul 2>&1
mkdir "%STAGE%" >nul 2>&1

powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop';" ^
  "$root='%ROOT%'; $stage='%STAGE%'; $zip='%ZIP%';" ^
  "$filters=('%FILTERS%'.Split(';') | ForEach-Object { $_.Trim() } | Where-Object { $_ });" ^
  "if(Test-Path $zip){Remove-Item -Force $zip};" ^
  "New-Item -ItemType Directory -Force -Path (Join-Path $stage 'scripts') | Out-Null;" ^
  "New-Item -ItemType Directory -Force -Path (Join-Path $stage 'objects') | Out-Null;" ^
  "$files=@();" ^
  "if(Test-Path (Join-Path $root 'scripts')){ $files += Get-ChildItem -LiteralPath (Join-Path $root 'scripts') -Recurse -File -Filter '*.gml' }" ^
  "if(Test-Path (Join-Path $root 'objects')){ $files += Get-ChildItem -LiteralPath (Join-Path $root 'objects') -Recurse -File -Filter '*.gml' }" ^
  "if($filters.Count -gt 0){" ^
  "  $files = $files | Where-Object { $n=$_.Name; foreach($f in $filters){ if($n -match [regex]::Escape($f)){ return $true } } return $false }" ^
  "}" ^
  "Write-Host ('Matched ' + $files.Count + ' .gml files');" ^
  "if($files.Count -eq 0){ throw 'No matching files.' }" ^
  "foreach($f in $files){" ^
  "  $rel = $f.FullName.Substring($root.Length).TrimStart('\');" ^
  "  $dst = Join-Path $stage $rel;" ^
  "  $dir = Split-Path -Parent $dst;" ^
  "  New-Item -ItemType Directory -Force -Path $dir | Out-Null;" ^
  "  Copy-Item -LiteralPath $f.FullName -Destination $dst -Force;" ^
  "}" ^
  "$toZip=@();" ^
  "if(Test-Path (Join-Path $stage 'scripts')){ if((Get-ChildItem (Join-Path $stage 'scripts') -Recurse -File | Measure-Object).Count -gt 0){ $toZip += (Join-Path $stage 'scripts') } }" ^
  "if(Test-Path (Join-Path $stage 'objects')){ if((Get-ChildItem (Join-Path $stage 'objects') -Recurse -File | Measure-Object).Count -gt 0){ $toZip += (Join-Path $stage 'objects') } }" ^
  "if($toZip.Count -eq 0){ throw 'Nothing to zip after staging.' }" ^
  "Compress-Archive -LiteralPath $toZip -DestinationPath $zip -Force;" ^
  "Write-Host ('Created: ' + $zip)"

set "ERR=%ERRORLEVEL%"
rmdir /s /q "%STAGE%" >nul 2>&1

if not "%ERR%"=="0" (
  echo Failed (exit %ERR%).
) else (
  echo Done.
)

pause
exit /b %ERR%
