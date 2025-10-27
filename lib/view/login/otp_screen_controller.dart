import 'dart:convert';
import 'package:abtxt/view/login/set_new_password_screen.dart';
import 'package:get/get.dart';
import '../../http/api_repository.dart';
import '../../utils/app_utils.dart';

class OTP_ScreenController extends GetxController with StateMixin {
  void onInit() async {}
  void otpScreen(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.upload, 'api/verifyOtp',
            formDatas: request)
        .then((response) {
      print('Eswar------------------');
      print(response.success);
      if (response.success) {
        var json = jsonDecode(response.data);
        print('Eswar: $json');
        // Get.back();
        Get.offAllNamed(SetNewPasswordScreen.routeName);
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void resendAgain(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/requestOtp',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        // print('add: $json');

        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
