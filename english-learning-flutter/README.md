# American English — Flutter learning app

One shared Flutter/Dart project for Android and Windows, retaining the existing Android application ID `uz.education.inglizcha` and displayed name **American English**.

## Implemented features

- Premium navy/blue interface with responsive layouts, compact glass-inspired mobile navigation, and light/dark/system modes. A first install defaults to dark; any existing saved theme choice is respected.
- English, Russian, and Uzbek interface locales.
- A 23-lesson guided grammar path with dedicated A1, A2, B1, B2, C1, and C2 pages. Lessons include Uzbek explanations, English examples with Uzbek translations, exercises, and quiz answers. Original lesson IDs 0–8 are retained so existing completion records still point to the same lessons.
- Offline 1,000-entry English–Uzbek vocabulary dataset; search, CEFR filtering, favorites, learned-word markers, pronunciation practice, and quizzes are preserved.
- AI English conversation through the configured OpenAI-compatible Chat Completions endpoint. Spoken input uses the device speech recognizer (English US) and is sent as a real transcript to that API; AI replies can be read aloud with the device TTS engine. Both require supported device services; the AI additionally requires network access and the user's own provider API key. Windows speech recognition support is plugin-beta and must be verified on a Windows device.
- Local progress: learned words, favorites, lesson completion, quiz results, and statistics remain on the device. The AI API key uses platform secure storage.
- The supplied app icon is used by the Android launcher, Windows executable, and in-app header.

## Authentication and cloud sync status

Google sign-in and cloud progress synchronization are **not implemented**. This project currently has no Firebase project configuration (`google-services.json`/`firebase_options.dart`), Google OAuth client IDs, or Google sign-in/Firestore dependencies. Progress is local only; do not treat it as synchronized or backed up. No account or sync feature has been tested.

To enable it later, first create/choose a Firebase project; register Android application ID `uz.education.inglizcha` and add the signing certificate SHA-1/SHA-256 fingerprints; enable Google in Firebase Authentication; generate the Android configuration and web/server OAuth client ID; then decide on a cloud database and deploy per-user security rules that restrict each record to its authenticated UID. Windows Google OAuth needs its own desktop OAuth/redirect setup. Review provider limits/billing before choosing services. Only after those choices/configuration are supplied should dependencies, sign-in, data migration, security rules, and cross-device tests be implemented.

## Build

- Android: from the project root run `flutter build apk --release` or `build_android.bat`. The batch script also runs `flutter analyze` and `flutter test`. Output: `dist/American-English-Android-release.apk` (script copy) and `build/app/outputs/flutter-apk/app-release.apk` (Flutter output).
- Windows: from a Windows 10/11 x64 machine with Flutter and Visual Studio 2022 / Build Tools **Desktop development with C++** installed, run `build_windows.bat`. It runs analysis/tests, builds the native Windows runner, and gathers the EXE with runtime files. Outputs: `dist/American-English-Windows-x64/american_english.exe` and `dist/American-English-Windows-x64.zip`.
- A Windows desktop build must run on Windows. This Linux sandbox cannot produce or verify a native Windows EXE.

## Install

- Android: transfer the APK to the phone, open it, allow the file manager to install unknown apps when Android asks, then install. Alternatively, use `adb install -r dist/American-English-Android-release.apk` with USB debugging enabled.
- Windows: extract the ZIP and launch `american_english.exe` inside the resulting folder. Keep the `data` folder and DLLs next to the EXE.

See [README_UZ.md](README_UZ.md) for detailed Uzbek setup, build, and installation instructions, and [SOURCES.md](SOURCES.md) for dataset/platform provenance.

## Latest implementation verification

Android release build completed on 2026-10-13. The separately preserved deliverable is `/home/ubuntu/builds/American-Speaking-AI-2026-10-13/American-English-v1.1.0-CEFR-voice.apk` (54,686,141 bytes, SHA-256 `566656fcf5c5c83bf5956a5ad8ad9c4d588de4ea9841b76fb45c2966fc4cfdc9`). APK metadata confirms package `uz.education.inglizcha`, version `1.1.0` / version code `2`, and launcher name `American English`; v2 signature and archive integrity were verified. The earlier APK in `dist/` was left untouched.

`flutter analyze` completed with no issues and all 12 Flutter tests passed, including the bundled 1,000-word data check and a phone-sized CEFR lesson/quiz/progress flow. No physical Android device was connected in this build environment. Microphone recognition, TTS output, and a request to a real external AI provider therefore still need device/provider testing. Configure your own API key and review the provider's limits or charges before use.

Windows EXE generation was not performed here: the active build host is Linux. Run `build_windows.bat` on Windows 10/11 x64 after installing Flutter and Visual Studio Build Tools with the C++ desktop workload. Google authentication and cloud synchronization also remain intentionally unimplemented pending Firebase/OAuth project configuration and a database/security design.
