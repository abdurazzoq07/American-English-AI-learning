@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo [1/5] Flutter va Windows C++ build vositalari tekshirilmoqda...
where flutter >nul 2>nul
if errorlevel 1 (
  echo XATO: Flutter PATH da topilmadi.
  exit /b 1
)
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "%VSWHERE%" (
  echo XATO: Visual Studio Installer/vswhere.exe topilmadi.
  echo Visual Studio 2022 Build Tools va "Desktop development with C++" workloadini o‘rnating.
  exit /b 1
)
set "VSROOT="
for /f "usebackq tokens=*" %%I in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set "VSROOT=%%I"
if not defined VSROOT (
  echo XATO: MSVC C++ x64 kompilyatori aniqlanmadi.
  echo Visual Studio Installerda MSVC v143 va Windows 10/11 SDK komponentlarini tanlang.
  exit /b 1
)
if not exist "%VSROOT%\Common7\Tools\VsDevCmd.bat" (
  echo XATO: Visual Studio developer command environment topilmadi: %VSROOT%
  exit /b 1
)
call "%VSROOT%\Common7\Tools\VsDevCmd.bat" -arch=amd64 -host_arch=amd64 -no_logo
if errorlevel 1 (
  echo XATO: Visual Studio MSVC muhitini faollashtirib bo‘lmadi.
  exit /b 1
)
where cl >nul 2>nul
if errorlevel 1 (
  echo XATO: VsDevCmd ishga tushdi, ammo cl.exe topilmadi. MSVC v143 ni o‘rnating.
  exit /b 1
)
set "VSCMAKE=%VSROOT%\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin"
if exist "%VSCMAKE%\cmake.exe" set "PATH=%VSCMAKE%;%PATH%"
where cmake >nul 2>nul
if errorlevel 1 (
  echo XATO: CMake topilmadi. Visual Studio Installer orqali "C++ CMake tools for Windows" ni o‘rnating.
  exit /b 1
)
call flutter doctor -v
echo.

echo [2/5] Paketlar va Dart tahlili...
call flutter pub get
if errorlevel 1 (
  echo XATO: flutter pub get bajarilmadi.
  exit /b 1
)
call flutter analyze
if errorlevel 1 (
  echo XATO: flutter analyze muammolar topdi; build to‘xtatildi.
  exit /b 1
)
call flutter test
if errorlevel 1 (
  echo XATO: flutter test muvaffaqiyatsiz; Windows build to‘xtatildi.
  exit /b 1
)

echo [3/5] Windows x64 release build...
call flutter build windows --release
if errorlevel 1 (
  echo XATO: Windows EXE build muvaffaqiyatsiz. Flutter doctor -v natijasini tekshiring.
  exit /b 1
)

set "BUILD=%~dp0build\windows\x64\runner\Release"
if not exist "%BUILD%\american_english.exe" set "BUILD=%~dp0build\windows\runner\Release"
if not exist "%BUILD%\american_english.exe" (
  echo XATO: build yakunlangan, ammo american_english.exe topilmadi.
  echo Qidirilgan manzil: %BUILD%
  exit /b 1
)

echo [4/5] EXE va zarur runtime fayllari dist papkasiga yig‘ilmoqda...
set "DIST=%~dp0dist"
set "PACKAGE=%DIST%\American-English-Windows-x64"
if not exist "%DIST%" mkdir "%DIST%"
if exist "%PACKAGE%" rmdir /s /q "%PACKAGE%"
mkdir "%PACKAGE%"
xcopy "%BUILD%\*" "%PACKAGE%\" /E /I /H /Y >nul
if errorlevel 1 (
  echo XATO: Windows runtime bundle ko‘chirilmadi.
  exit /b 1
)
if not exist "%PACKAGE%\american_english.exe" (
  echo XATO: yig‘ilgan papkada EXE yo‘q.
  exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "Compress-Archive -Path '%PACKAGE%\*' -DestinationPath '%DIST%\American-English-Windows-x64.zip' -Force"
if errorlevel 1 (
  echo XATO: Windows ZIP tarqatmasi yaratilmadi.
  exit /b 1
)

echo [5/5] Windows tarqatmasi tayyor.
echo EXE: %PACKAGE%\american_english.exe
echo To‘liq runtime bundle: %PACKAGE%
echo Ko‘chirish uchun ZIP: %DIST%\American-English-Windows-x64.zip
echo O‘rnatish: ZIPni oching, American-English-Windows-x64 papkasini kerakli joyga ko‘chiring va american_english.exe ni ishga tushiring.
echo Agar Windows VC++ runtime haqida xabar bersa, Visual C++ Redistributable 2015-2022 x64 o‘rnating.
exit /b 0
