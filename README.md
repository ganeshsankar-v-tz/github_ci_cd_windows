# abtex

A new Flutter project.

> **Figma**
[https://www.figma.com/file/9BtlbCcFA1FrCTpJIek7Ka/AB-Textile-Web-Application-UI%2FUX?type=design&node-id=650-2745&mode=design&t=Es7t79j9XkrMm2RN-0](https://www.figma.com/file/9BtlbCcFA1FrCTpJIek7Ka/AB-Textile-Web-Application-UI/UX?type=design&node-id=650-2745&mode=design&t=Es7t79j9XkrMm2RN-0)
**

### How to get windows build

    flutter clean

- DEV
flutter build windows -t lib/main.dart --dart-define=FLAVOR=dev

- LIVE
flutter build windows -t lib/main.dart --dart-define=FLAVOR=live

 ### exe path: \build\windows\x64\Release\

### Command to run the build from terminal

- DEV
  flutter run -d windows -t lib/main.dart --dart-define=FLAVOR=dev

- LIVE
  flutter run -d windows -t lib/main.dart --dart-define=FLAVOR=live
