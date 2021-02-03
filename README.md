# TodayYoutuber

서로간에 유튜브 채널 목록을 공유할 수 있는 앱입니다.
서비스명 : Tube Shaker (임시)

## 메인 서비스 화면

### Bottom navigation 기준

1번째 화면 - 보관함 : 내가 좋아하는 채널 목록을 카테고리 별로 저장
2번째 화면 - 설정 화면

### 채널 추가하기 화면

사용자가 유튜브 앱에서 공유하기를 통해 진입하면 해당 채널 정보가 파싱 됨.

### 공유하기 화면

사용자가 공유할 채널은 선택

### 공유받은 채널 추가하기

사용자가 다이나믹 링크를 통해 진입한 경우, 공유받은 채널 중 원하는 채널을 선택하여 내 채널 목록에 추가.

## 프로젝트 파일 구조

### MVVM 설계

Model : 어플리케이션에서 사용되는 데이터와 그 데이터를 처리하는 부분입니다.
View : 사용자에서 보여지는 UI 부분입니다.
View Model : View를 표현하기 위해 만든 View를 위한 Model입니다. View를 나타내 주기 위한 Model이자 View를 나타내기 위한 데이터 처리를 하는 부분입니다.

[Reference](https://beomy.tistory.com/43)

### 파일 구조

파일 구조는 추가 업데이트 될 수 있는 파일들을 고려해 디렉토리까지만 표기합니다

```bash
├── common : 전체 프로젝트에서 공통적으로 쓰이는 요소를 모아둔 디렉토리.
├── database : 내부 db에 접근하기 위한 파일들을 모아둔 디렉토리
├── models : mvvm 패턴 중 model 역할의 파일을 모아둔 디렉토리
└── pages : mvvm 패턴 중 view 역할의 파일을 모아둔 디렉토리
    └── home - 홈 화면에 사용되는 ViewModel, Widget, Screen 파일을 모아둔 디렉토리.
```

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

## Special Thanks to

Aqudi : 해당 프로젝트에 사용된 Logger 라이브러리를 알려주셨습니다.
edhjs : README 파일의 형식을 잡아주셨습니다.
deviankim : 이 프로젝트가 수행된 스터디를 리딩해 주셨습니다.
스타디 flutter 5기(중급반) : 인사이트를 공유해 주셨습니다.