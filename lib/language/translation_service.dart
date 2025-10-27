import 'package:flutter/material.dart';
import 'package:abtxt/language/lang_ar.dart';
import 'package:abtxt/language/lang_en.dart';
import 'package:abtxt/language/lang_hi.dart';
import 'package:abtxt/language/lang_ta.dart';
import 'package:get/get.dart';

class TranslationService extends Translations {
  // static Locale? get locale => Get.deviceLocale;
  // static const fallbackLocale = Locale('en', 'US');
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': english,
        'ar': arabic,
        "hi": hindi,
        "ta": tamil,
      };
}
