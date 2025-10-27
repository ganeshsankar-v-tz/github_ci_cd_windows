import 'dart:convert';

import 'package:abtxt/model/LoginResponse.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../http/api_repository.dart';
import '../mainscreen/mainscreen.dart';

class LoginController extends GetxController with StateMixin {
  late GetStorage box;

  @override
  void onInit() async {
    super.onInit();
    change(null, status: RxStatus.success());
    box = GetStorage();
  }

  void login(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/login',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        var userDetail = data['user_details'];
        var loginResponse = LoginResponse.fromJson(data);

        box.write("token", loginResponse.token);
        box.write("user_name", userDetail['user_name']);
        box.write("name", userDetail['name']);
        box.write("user_type", userDetail['user_type']);
        box.write("id", userDetail['id']);
        var permissionList = data['user_permission_list'] as List;
        for (var per in permissionList) {
          box.write(per['permission'], per['access']);
        }
        Get.offAllNamed(MainScreen.routeName);
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }
}
