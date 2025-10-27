import 'dart:convert';

import 'package:abtxt/http/http_urls.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../http/api_repository.dart';
import '../mainscreen/mainscreen.dart';

class SplashController extends GetxController with StateMixin {
  var localVersion = AppUtils().appVersion;
  var apiVersion = "";
  var box = GetStorage();

  @override
  void onInit() async {
    appVersionGetInApi();
    super.onInit();
  }

  appVersionGetInApi() async {
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/version_controller_get')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        String token = box.read("token") ?? "";
        var data = json['data'];
        var version = data['version'];
        if (localVersion == version) {
          if (token.isEmpty) {
            Get.offAllNamed(Login.routeName);
          } else {
            Get.offAllNamed(MainScreen.routeName);
          }
        } else {
          _dialog(data);
        }
      } else {
        print('error: ${json['message']}');
      }
    });
  }

  _dialog(data) {
    Get.defaultDialog(
      title: '',
      titleStyle: const TextStyle(
        fontSize: 0,
      ),
      barrierDismissible: false,
      radius: 4,
      content: Container(
        padding: EdgeInsets.all(16),
        width: 450,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "New Update Available!",
              style: TextStyle(
                color: Colors.red,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Version: ${data['version']}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 16,
            ),
            Text('${data['comments']}')
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
              autofocus: true,
              onPressed: () async {
                final Uri url = Uri.parse(HttpUrl.baseUrl + data['file_path']);
                if (!await launchUrl(url)) {
                  throw Exception('Error : $url');
                }
              },
              child: Text('DOWNLOAD'),
            ),
          ],
        ),
      ],
    );
  }
}
