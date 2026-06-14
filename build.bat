@echo off
REM ════════════════════════════════════════════════════════════════════
REM  NISHAFFS v1.0 - DEPLOYMENT SCRIPT (Windows)
REM  Run this to build and prepare for app store submission
REM ════════════════════════════════════════════════════════════════════

setlocal enabledelayedexpansion

echo.
echo ═══════════════════════════════════════════════════════════════════
echo   NISHAFFS v1.0 - PRODUCTION BUILD SCRIPT
echo ═══════════════════════════════════════════════════════════════════
echo.

REM Step 1: Clean and get dependencies
echo 📦 Step 1: Setting up dependencies...
call flutter clean
call flutter pub get
call flutter pub upgrade

REM Step 2: Run analyzer
echo.
echo 🔍 Step 2: Code analysis...
call flutter analyze
if errorlevel 1 (
    echo ❌ Fix errors above before proceeding
    exit /b 1
)

REM Step 3: Format code
echo.
echo ✨ Step 3: Formatting code...
call dart format lib/ --set-exit-if-changed

REM Step 4: Build APK for Android
echo.
echo 🤖 Step 4: Building Android APK...
call flutter build apk --release
if errorlevel 1 (
    echo ❌ Android APK build failed
    exit /b 1
)
echo ✅ Android APK built

REM Step 5: Build AAB for Google Play
echo.
echo 📱 Step 5: Building Android App Bundle...
call flutter build appbundle --release
if errorlevel 1 (
    echo ❌ Android AAB build failed
    exit /b 1
)
echo ✅ Android AAB built

REM Step 6: Build iOS
echo.
echo 🍎 Step 6: Building iOS IPA...
call flutter build ipa --release
if errorlevel 1 (
    echo ❌ iOS build failed (Note: This requires macOS)
    echo Proceeding anyway...
)

echo.
echo ═══════════════════════════════════════════════════════════════════
echo ✅ BUILD COMPLETE - READY FOR APP STORE SUBMISSION
echo ═══════════════════════════════════════════════════════════════════
echo.
echo 📍 BUILD ARTIFACTS:
echo   • APK: build\app\outputs\apk\release\app-release.apk
echo   • AAB: build\app\outputs\bundle\release\app-release.aab
echo.
echo 🚀 NEXT STEPS:
echo   1. Android: Upload AAB to Google Play Console
echo   2. iOS: Open Xcode and create archive (requires macOS)
echo.
echo 📱 APP STORE LINKS:
echo   • Google Play: https://play.google.com/console
echo   • App Store: https://appstoreconnect.apple.com
echo.

pause
