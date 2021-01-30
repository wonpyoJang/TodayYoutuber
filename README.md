# TodayYoutuber(Tube Shaker)

서로간에 유튜브 채널 목록을 공유할 수 있는 앱입니다.

### 1. 빌드 방법

```bash
   git clone https://github.com/wonpyoJang/TodayYoutuber.git
   cd TodayYoutuber
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   flutter run --release
```

### 2. 개발자 개발 환경

```bash
~/workplace/study/stard/TodayYoutuber dev
❯ flutter doctor -v
[✓] Flutter (Channel stable, 1.22.5, on macOS 11.1 20C69 darwin-x64, locale en-KR)
    • Flutter version 1.22.5 at /Users/jang-wonpyo/development/flutter
    • Framework revision 7891006299 (7 weeks ago), 2020-12-10 11:54:40 -0800
    • Engine revision ae90085a84
    • Dart version 2.10.4

[!] Android toolchain - develop for Android devices (Android SDK version 29.0.3)
    • Android SDK at /Users/jang-wonpyo/Library/Android/sdk
    • Platform android-30, build-tools 29.0.3
    • ANDROID_HOME = /Users/jang-wonpyo/Library/Android/sdk/
    • Java binary at: /Applications/Android Studio.app/Contents/jre/jdk/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 1.8.0_242-release-1644-b3-6222593)
    ✗ Android license status unknown.
      Run `flutter doctor --android-licenses` to accept the SDK licenses.
      See https://flutter.dev/docs/get-started/install/macos#android-setup for more details.

[✓] Xcode - develop for iOS and macOS (Xcode 12.4)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Xcode 12.4, Build version 12D4e
    • CocoaPods version 1.10.0

[✓] Android Studio (version 4.0)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin version 46.0.2
    • Dart plugin version 193.7361
    • Java version OpenJDK Runtime Environment (build 1.8.0_242-release-1644-b3-6222593)

[✓] VS Code (version 1.52.1)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.18.1


[✓] Connected device (1 available)
    • sdk gphone x86 (mobile) • emulator-5554 • android-x86 • Android 11 (API 30) (emulator)

! Doctor found issues in 1 category.
```
