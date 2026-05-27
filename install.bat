@echo off
setlocal EnableExtensions EnableDelayedExpansion
title PAPI Central Installer
color 0B
cls

echo.
echo  ==========================================================
echo     ^>^>^>   PAPI Central  ^|  Automated Installer   ^<^<^<
echo  ==========================================================
echo.
echo  This will install PAPI Central on your computer and open
echo  the setup wizard to configure your AI API keys.
echo.

:: ── Choose install directory ──────────────────────────────────────
set "DEFAULT_DIR=%USERPROFILE%\Desktop\PAPI-Central"
echo  Where would you like to install PAPI Central?
echo  Press ENTER to accept the default location.
echo.
set /p "INSTALL_DIR=  Install to [%DEFAULT_DIR%]: "
if "!INSTALL_DIR!"=="" set "INSTALL_DIR=%DEFAULT_DIR%"

:: Strip surrounding quotes if user typed them
set "INSTALL_DIR=!INSTALL_DIR:"=!"

echo.
echo  Installing to: !INSTALL_DIR!
echo.

:: ── Create target directory ───────────────────────────────────────
if not exist "!INSTALL_DIR!" (
    md "!INSTALL_DIR!" 2>nul
    if errorlevel 1 (
        echo  [ERROR] Could not create "!INSTALL_DIR!"
        echo  Try choosing a location inside your user folder,
        echo  or run this installer as Administrator.
        echo.
        pause
        exit /b 1
    )
    echo  [OK] Created install folder.
) else (
    echo  [OK] Folder already exists — files will be updated.
)

:: ── Copy files (skip installer artefacts and git internals) ───────
echo  Copying files ...
robocopy "%~dp0." "!INSTALL_DIR!" /E /NJH /NJS /NFL /NDL ^
  /XD ".git" ".github" "node_modules" "_papi_backup" "Secrets2" ^
  /XF "install.bat" "install-exclude.txt" "*.lnk" "Thumbs.db" "desktop.ini" ^
  > nul

:: robocopy exit codes 0-7 are success / partial success
if !errorlevel! GTR 7 (
    echo  [ERROR] File copy failed with code !errorlevel!
    pause
    exit /b 1
)
echo  [OK] Files copied.

:: ── Create desktop shortcut (.url) ───────────────────────────────
echo  Creating desktop shortcut ...
set "SHORTCUT=%USERPROFILE%\Desktop\PAPI Central.url"
(
  echo [InternetShortcut]
  echo URL=file:///!INSTALL_DIR:\=/!/index.html
  echo IconFile=%SystemRoot%\System32\shell32.dll
  echo IconIndex=14
) > "!SHORTCUT!"
echo  [OK] Shortcut created on Desktop.

:: ── Open setup wizard in default browser ─────────────────────────
echo.
echo  ==========================================================
echo     Installation complete!
echo     Opening the API key setup wizard...
echo  ==========================================================
echo.
echo  You will be asked to get free API keys from:
echo    - OpenAI   (required)
echo    - Claude   (recommended)
echo    - Gemini   (recommended)
echo.
echo  Each step will open the provider website in your browser.
echo.
timeout /t 4 /nobreak > nul
start "" "!INSTALL_DIR!\setup.html"

exit /b 0
