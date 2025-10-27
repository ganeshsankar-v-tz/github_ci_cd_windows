import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppTheme {
  ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    primaryColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0.2,
      titleTextStyle: TextStyle(fontSize: 16, color: Color(0xFF141414)),
      centerTitle: false,
    ),
  );

  ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    primaryColor: Colors.black,
  );
}

updateThemeStatus(bool themeStatus) async {
  //Theme status 'true' -> light theme, 'false' -> Dark theme.
  var box = GetStorage();
  box.write('appTheme', themeStatus);
  Get.changeThemeMode(themeStatus ? ThemeMode.light : ThemeMode.dark);
}

initialTheme() async {
  var box = GetStorage();
  RxBool isLight = box.read('appTheme') ?? true.obs;
  var gatTheme = await isLight.value;
  Get.changeThemeMode(gatTheme ? ThemeMode.light : ThemeMode.dark);
}

Future<bool> getThemeStatus() async {
  var box = GetStorage();
  bool themeStatus = box.read('appTheme') ?? true;
  return themeStatus;
}
