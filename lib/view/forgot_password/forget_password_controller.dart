import 'dart:convert';
import 'package:get/get.dart';
import '../../http/api_repository.dart';
import '../../utils/app_utils.dart';
import 'otp_screen.dart';

class ForgetPasswordController extends GetxController with StateMixin {
  @override
  void onInit() {
    change(null, status: RxStatus.success());
    super.onInit();
  }
  void requestOTP(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/requestOtp',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.toNamed(OtpScreen.routeName);
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
