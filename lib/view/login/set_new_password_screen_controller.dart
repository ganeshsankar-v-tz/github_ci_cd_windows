import 'dart:convert';
import 'package:abtxt/view/login/reset_successfully_screen.dart';
import 'package:get/get.dart';
import '../../http/api_repository.dart';
import '../../utils/app_utils.dart';

class SetNewPasswordScreenController extends GetxController with StateMixin {
  void onInit() async {}
  void resetpass(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/reset_password',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('resetpass: $json');
        // Get.back();
        Get.offAllNamed(ResetSuccessfullyScreen.routeName);
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
