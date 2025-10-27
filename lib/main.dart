import 'package:abtxt/language/translation_service.dart';
import 'package:abtxt/network/network_binding.dart';
import 'package:abtxt/router.dart';
import 'package:abtxt/utils/app_theme.dart';
import 'package:abtxt/utils/color_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (GetPlatform.isWindows || GetPlatform.isMacOS) {
    setWindowMinSize(const Size(1500, 850));
  }
  await GetStorage.init();

  const flavor = String.fromEnvironment('FLAVOR');
  String envFile;
  switch (flavor) {
    case 'dev':
      envFile = '.env.dev';
      break;
    case 'live':
      envFile = '.env.live';
      break;
    default:
      envFile = '.env.dev';
      break;
  }
  await dotenv.load(fileName: envFile);

  runApp(const MyApp());
  NetworkBinding.init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? locale;

  @override
  void didChangeDependencies() {
    /*getLocale().then((Locale getLocale) {
      setState(() {
        locale = getLocale;
      });
    });*/
    initialTheme();
    super.didChangeDependencies();
  }

  Locale setLocale() {
    return locale ?? Get.deviceLocale!;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      debugShowCheckedModeBanner: false,
      color: ColorResource.primaryColor,
      theme: AppTheme().lightTheme,
      themeMode: ThemeMode.light,
      darkTheme: AppTheme().darkTheme,
      locale: setLocale(),
      fallbackLocale: const Locale('en', 'US'),
      translationsKeys: TranslationService().keys,
      defaultTransition: Transition.fade,
      initialRoute: '/',
      getPages: AppRouter.routes,
      // initialBinding: NetworkBinding(),
    );
  }
}
