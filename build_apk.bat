@echo off
set PATH=C:\Program Files\Git\cmd;%PATH%
cd /d "e:\omnia\NTI\Kafil Project\mavin_wear"
echo ===== Running flutter pub get =====
flutter pub get
echo ===== Building APK =====
flutter build apk --release
echo ===== Done =====
pause
