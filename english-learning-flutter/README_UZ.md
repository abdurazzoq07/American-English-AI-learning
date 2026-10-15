# American English — Flutter ilovasi

O‘zbek tilida ingliz tilini o‘rganishga mo‘ljallangan, Android va Windows uchun bitta Flutter/Dart codebase. Android Studio IDE talab qilinmaydi: VS Code, Flutter SDK va terminal yetarli.

## Ilovadagi imkoniyatlar

- **AI inglizcha suhbat:** OpenAI-compatible Chat Completions API. Matn yozing yoki English (US) nutqni mikrofonda tanitib yuboring; haqiqiy AI javobi qurilmaning TTS ovozi bilan eshittirilishi mumkin. Provider URL, model va API kalitini ilova sozlamasiga kiriting.
- **1000 ta offline so‘z:** Uzbek tarjima, CEFR daraja, IPA talaffuz, inglizcha misol va Uzbek tarjimasi; qidiruv, daraja filtri, sevimlilar va o‘rganilgan belgisi.
- **Talaffuz mashqi:** inglizcha namunaviy ovozni eshiting, mikrofonga takrorlang va qurilma speech-recognition natijasini solishtiring.
- **CEFR grammatika yo‘li:** A1, A2, B1, B2, C1 va C2 uchun alohida sahifalar, 23 mavzuli dars, Uzbekcha izoh, English misollari va Uzbek tarjimasi, interaktiv testlar.
- **Test va statistika:** o‘rganilgan so‘zlar, darslar, suhbatlar va pronunciation ko‘rsatkichlari.
- **Mahalliy saqlash:** o‘rganilgan so‘zlar, sevimlilar, dars yakuni, test natijalari va statistika qurilmada saqlanadi. API kalit esa Android/Windows himoyalangan omborida saqlanadi; cloud sync yoqilmagan.
- **Oflayn:** lug‘at, grammatika va progress internetsiz ishlaydi. AI suhbat internet va provider API kalitini talab qiladi.
- **Yagona ilova belgisi:** siz bergan rasm Android launcher belgisi, Windows `.ico` va ilova yuqori panelida ishlatiladi.
- **Uch tilli interfeys:** ilova tili tizimga mos ravishda yoki sozlamalardan English, Русский, O‘zbekcha qilib tanlanadi.
- **Mavzular:** premium navy/blue dizayn; birinchi o‘rnatishda Qorong‘i rejim, shuningdek Yorug‘ yoki Tizim bo‘yicha ko‘rinish tanlovi. Avval saqlangan foydalanuvchi tanlovi o‘zgarmaydi.

Ilova tilini va mavzuni yuqori o‘ngdagi **Sozlamalar** tugmasidan o‘zgartiring; tanlov qurilmada eslab qolinadi. Bu interfeys tili bo‘lib, o‘quv mazmuni English–Uzbek yo‘nalishida qoladi: izoh va tarjimalar Uzbek tilida, English namunalar esa English tilida ko‘rsatiladi. Mobil navigatsiya xiralashtirilgan, yumaloq glass-inspired ko‘rinishga ega.

Statistikadagi “daqiqa” taxminiy hisob: yakunlangan AI javobi yoki grammar darsi har biri 5 daqiqalik mashg‘ulot sifatida qo‘shiladi; bu fon stopwatch’i emas.

## Minimal muhit

### Har ikki platforma

1. VS Code (Dart va Flutter extensions).
2. Flutter stable SDK (Dart Flutter bilan keladi), `flutter` PATH ichida.
3. VS Code integrated terminal yoki PowerShell.

Tekshirish:

```powershell
flutter --version
flutter doctor -v
```

### Android (Android Studio IDE shart emas)

Android SDK Command-line Tools, Android SDK Platform (API 36 tavsiya etiladi), Build-Tools, Platform-Tools (`adb`) va to‘liq JDK 17+ kerak. `javac -version` ishlashini tekshiring — faqat JRE build uchun yetmaydi. SDK yo‘lini o‘z o‘rnatishingizga moslang:

```powershell
flutter config --android-sdk "$env:LOCALAPPDATA\Android\Sdk"
flutter doctor --android-licenses
flutter doctor -v
```

Litsenziya matnlarini ko‘rib, o‘zingiz qabul qiling. Fizik Android qurilmada **Developer options** va **USB debugging** ni yoqing, USB bilan ulang, ruxsat so‘rovini tasdiqlang:

```powershell
flutter devices
```

Emulator shart emas.

### Windows desktop

Windows `.exe`ni **Windows 10/11 x64** kompyuterida build qilish kerak. Flutter Windows buildi Visual Studio 2022 yoki Visual Studio Build Tools talab qiladi; Installer ichida **Desktop development with C++** workloadini tanlang. Faqat buildga kerak bo‘ladigan MSVC v143, Windows 10/11 SDK, CMake va secure storage uchun C++ ATL componentlarini qo‘shing. Visual Studio Code — alohida editor, C++ kompilyator emas. `build_windows.bat` Visual Studio Installer orqali `VsDevCmd`ni topib, native compiler muhitini o‘zi sozlaydi.

Tekshirish:

```powershell
flutter doctor -v
where.exe cl
where.exe cmake
```

Linux yoki macOS muhitida Flutter Windows binarysi native tarzda build qilinmaydi.

## Loyihani ochish va tahlil

```powershell
cd english-learning-flutter
code .
flutter pub get
flutter analyze
```

## Android APK buildi

Windows terminalida:

```powershell
.\build_android.bat
```

Yoki to‘g‘ridan-to‘g‘ri:

```powershell
flutter build apk --release
```

Asl natija:

```text
build\app\outputs\flutter-apk\app-release.apk
```

Batch muvaffaqiyatli tugasa, nusxa:

```text
dist\American-English-Android-release.apk
```

`build_android.bat` Flutter va Android SDK yo‘lini tekshiradi, `flutter pub get`, `flutter analyze`, `flutter test`, `flutter build apk --release` ni bajaradi va APK borligini tasdiqlaydi.

Hozirgi Gradle template release APKni Flutter debug signing kaliti bilan imzolaydi; telefonga qo‘lda o‘rnatish uchun mos, ammo Google Play’ga chiqarishdan oldin o‘zingizning production keystore va signing config’ingizni sozlang.

## Windows EXE buildi va tarqatish

Visual Studio C++ komponentlari o‘rnatilgan Windows terminalida:

```powershell
.\build_windows.bat
```

Yoki:

```powershell
flutter build windows --release
```

Kutiladigan Flutter natijasi:

```text
build\windows\x64\runner\Release\american_english.exe
```

Batch EXE bilan birga kerakli runtime DLL va `data` katalogini yig‘adi:

```text
dist\American-English-Windows-x64\american_english.exe
dist\American-English-Windows-x64.zip
```

Flutter EXE odatda yakka fayl emas. ZIP ichidagi runtime fayllarni EXE yonida qoldiring.

## Androidga o‘rnatish

1. `American-English-Android-release.apk` ni USB, Nearby Share yoki boshqa ishonchli usul bilan telefonga o‘tkazing.
2. Telefonda APKni oching. Android so‘rasa, shu fayl menejeri uchun **Install unknown apps / Bu manbadan o‘rnatishga ruxsat** ni yoqing.
3. O‘rnatishni tasdiqlang va **American English** ni ishga tushiring.
4. Talaffuz uchun mikrofon ruxsatini bering. Qurilmada English (US) speech recognition xizmati bo‘lishi kerak.

USB debugging yoqilgan qurilmaga ADB orqali:

```powershell
adb install -r .\dist\American-English-Android-release.apk
```

## Windowsga o‘rnatish/ishga tushirish

1. `American-English-Windows-x64.zip` ni oching.
2. Ichidagi `American-English-Windows-x64` papkasini masalan `C:\Apps\American English` ga ko‘chiring.
3. Papkadagi `american_english.exe` ni oching. `data` katalogi va DLL fayllarni yonida qoldiring.
4. VC++ runtime haqida ogohlantirish chiqsa, Microsoft Visual C++ Redistributable 2015–2022 x64 ni o‘rnating.

## AI sozlash

Ilovaning yuqori o‘ng sozlamasiga kiring:

- API manzili: odatda `https://api.openai.com/v1`;
- model: provider hisobingiz qo‘llaydigan model, masalan `gpt-5-mini`;
- API kalit: provider bergan kalit.

AI so‘rovi qurilmadan bevosita providerga boradi. Kalit source yoki buildga qo‘shilmaydi; Android Keystore/Windows himoyalangan saqlash mexanizmida saqlanadi. Internet va provider limiti/to‘lovi talab qilinishi mumkin. Mikrofon English (US) transkriptini yuboradi; nutqni tanish xizmati va mikrofonga ruxsat kerak. AI javobi speaker tugmasi orqali qurilma TTS xizmati bilan eshitiladi. Bu usul fonema darajasida talaffuz ballini bermaydi; Windows speech recognition qo‘llovi beta va Windows qurilmada alohida sinov talab qiladi.

## Google sign-in va bulutli sinxronizatsiya — hozircha yoqilmagan

Bu build/proyekt snapshot’ta Firebase/Google OAuth sozlamalari yo‘q: `google-services.json`, `firebase_options.dart`, OAuth client ID, Google Sign-In yoki cloud database paketi mavjud emas. Shu sababli Google hisobiga kirish va qurilmalararo sinxronizatsiya **amalga oshirilmagan va sinovdan o‘tmagan**. Barcha progress hozircha faqat shu qurilmada qoladi.

Keyinchalik xavfsiz ulash uchun egasi quyidagilarni tayyorlashi kerak:

1. Firebase loyihasini yarating yoki tanlang, Android ilovasini aynan `uz.education.inglizcha` application ID bilan ro‘yxatdan o‘tkazing.
2. Ishlatiladigan signing sertifikatning SHA-1 va SHA-256 fingerprintlarini Firebase’ga kiriting.
3. Firebase Authentication’da Google provayderini yoqing; Android `google-services.json` va kerakli Web/server OAuth client ID’ni yarating. Windows Google OAuth uchun alohida desktop OAuth/redirect sozlamasi kerak bo‘ladi.
4. Cloud database tanlang va har bir yozuv faqat autentifikatsiya qilingan foydalanuvchining UID’siga tegishli bo‘lishini qat’iy tekshiruvchi xavfsizlik qoidalarini belgilang.
5. Billing/kvotalarni ko‘rib chiqing. Konfiguratsiya va xizmat tanlovi aniq bo‘lgach, dependencies, xavfsiz login, lokal progress migratsiyasi va Android/Windows qurilmalararo sinovlarni alohida qo‘shish mumkin.

Hozir ilovada ishlamaydigan login/sync tugmasi ko‘rsatilmaydi va foydalanuvchi progressi serverga yuborilmaydi.

## 1000 so‘zli kontent

Inglizcha headwordlar [first20hours/google-10000-english](https://github.com/first20hours/google-10000-english) frequency ro‘yxatidagi birinchi 1000 lotin harfli so‘zdan tanlanadi. Repository README manbani Google Trillion Word Corpus asosidagi chastota ro‘yxati deb ta’riflaydi. Uzbek tarjima, CEFR, IPA va misollar `assets/vocabulary.json` ichida. Generator 1000 unikal headword, ketma-ketlik va barcha required fieldlar to‘liqligini tekshiradi. CEFR/IPA/tarjima/misollar AI yordamida yaratilgan va schema bo‘yicha tekshirilgan; bu professional ona tili muharriri tasdig‘i degani emas. Ommaviy/tijoriy tarqatishdan oldin upstream word-list litsenziyasini ham alohida tekshiring; batafsil manbalar `SOURCES.md` da.

Qayta yaratish: Python 3, `OPENAI_API_BASE` va `OPENAI_API_KEY` environment variable’lari bilan `python tooling/generate_vocabulary.py` ni ishga tushiring. API credentiallarni Git yoki ilova binaryga commit qilmang.

## Tuzilma

```text
lib/main.dart                    responsive navigation/theme
lib/models/                      lug‘at modeli
lib/screens/                     navy dashboard, voice AI chat, lug‘at, mashq, CEFR sahifalar, statistika
lib/data/cefr_lessons.dart       A1–C2 uchun 23 dars, misol va quizlar
lib/services/                    mahalliy progress va AI service
assets/vocabulary.json           1000 offline so‘z
assets/app_icon_source.png       asl kvadrat icon rasmi
assets/app_icon.png              ilova ichidagi belgi
android/app/src/main/res/mipmap-* launcher icon o‘lchamlari
windows/runner/resources/app_icon.ico Windows icon resursi
tooling/generate_app_icons.py    Android va Windows icon o‘lchamlarini tayyorlash
android/                         native Android host
windows/                         native Windows host
build_android.bat                Android release APK
build_windows.bat                Windows EXE + portable runtime ZIP
```

Iconlarni asl rasmdan qayta yaratish kerak bo‘lsa, Python 3 va Pillow o‘rnating: `python -m pip install Pillow`, so‘ng `python tooling/generate_app_icons.py` ni ishga tushiring. Oddiy Android yoki Windows build uchun iconlar allaqachon loyihaga kiritilgan.

## Shu o‘zgarishdagi build va tekshiruv

2026-10-13 da yangilangan Android release APK muvaffaqiyatli build qilindi. Aniq fayl: `/home/ubuntu/builds/American-Speaking-AI-2026-10-13/American-English-v1.1.0-CEFR-voice.apk` (54,686,141 bayt; SHA-256 `566656fcf5c5c83bf5956a5ad8ad9c4d588de4ea9841b76fb45c2966fc4cfdc9`). `aapt` package `uz.education.inglizcha`, version `1.1.0` (code 2) va launcher nomi `American English` ekanini ko‘rsatdi; `apksigner` v2 imzoni, `unzip -t` APK yaxlitligini tasdiqladi. Oldingi tarqatilgan APK nusxasi `dist` papkasida o‘zgartirilmay qoldi.

Yakuniy tekshiruv: `flutter analyze` — muammosiz; `flutter test` — 12 ta test o‘tdi. Testlar 1000 so‘zli dataset, tarjima, barcha olti CEFR daraja, eski 0–8 dars ID’lari, test natijasini va dars yakunini lokal saqlashni qamrab oladi. APK shu Linux build muhitida Android telefonida o‘rnatib ko‘rilmadi. Mikrofon/TTS va tashqi AI provider bilan haqiqiy qurilma sinovi ham bajarilmadi; qurilma speech xizmatlari, Internet va o‘zingizning API kalitingiz talab qilinadi.

Windows `.exe` bu Ubuntu/Linux hostida **build qilinmadi**. Windows EXE va runtime ZIP yaratish uchun Windows 10/11 x64 qurilmada Flutter’ni sozlang, Visual Studio 2022 Build Tools’da **Desktop development with C++** (MSVC v143, Windows SDK, CMake) o‘rnating, VS Code terminalini ochib `flutter doctor -v`, keyin `.\build_windows.bat` (PowerShell’da `.\build_windows.bat`) ni ishga tushiring. Script `flutter analyze`, `flutter test` va `flutter build windows --release` ni bajaradi. Kutiladigan natijalar `dist\American-English-Windows-x64\american_english.exe` va `dist\American-English-Windows-x64.zip`; Linuxda ularni hosil qilib bo‘lmaydi.
