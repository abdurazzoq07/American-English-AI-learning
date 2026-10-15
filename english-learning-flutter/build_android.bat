@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo [1/4] Flutter SDK tekshirilmoqda...
where flutter >nul 2>nul
if errorlevel 1 (
  echo XATO: Flutter PATH da topilmadi. Flutter SDK bin papkasini PATH ga qo‘shing.
  exit /b 1
)

set "SDK=%ANDROID_HOME%"
if "%SDK%"=="" set "SDK=%ANDROID_SDK_ROOT%"
if "%SDK%"=="" (
  echo XATO: ANDROID_HOME yoki ANDROID_SDK_ROOT sozlanmagan.
  echo Android SDK Command-line Tools, platform-tools, Android SDK Platform va Build Tools o‘rnating.
  exit /b 1
)
call flutter config --android-sdk "%SDK%"
if errorlevel 1 (
  echo XATO: Flutter Android SDK manzili sozlanmadi: %SDK%
  exit /b 1
)

echo [2/4] Paketlar va Dart tekshiruvi...
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
  echo XATO: flutter test muvaffaqiyatsiz; APK build to‘xtatildi.
  exit /b 1
)

echo [3/4] Android release APK build qilinmoqda...
call flutter build apk --release
if errorlevel 1 (
  echo XATO: Android APK build muvaffaqiyatsiz. Yuqoridagi Flutter/Gradle xabarlarini ko‘ring.
  exit /b 1
)

set "APK=%~dp0build\app\outputs\flutter-apk\app-release.apk"
if not exist "%APK%" (
  echo XATO: Flutter build 0 kod bilan tugadi, lekin APK topilmadi: %APK%
  exit /b 1
)
if not exist "%~dp0dist" mkdir "%~dp0dist"
copy /y "%APK%" "%~dp0dist\American-English-Android-release.apk" >nul
if errorlevel 1 (
  echo XATO: APK dist papkasiga ko‘chirilmadi.
  exit /b 1
)

echo.
echo MUVAFFAQIYAT: haqiqiy Android APK yaratildi:
echo %~dp0dist\American-English-Android-release.apk
echo Flutter build manzili: %APK%
echo Telefonga o‘rnatish: APKni telefonga ko‘chiring va oching. So‘ralganda ushbu manbadan ilova o‘rnatishga ruxsat bering.
exit /b 0
