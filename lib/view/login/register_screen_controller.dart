import 'dart:convert';
import 'package:get/get.dart';
import '../../http/api_repository.dart';
import '../../utils/app_utils.dart';
import 'login.dart';

class RegisterScreenController extends GetxController with StateMixin {
  void onInit() async {}
  void register(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/register',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('add: $json');
        // Get.back();
        Get.offAllNamed(Login.routeName);
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
