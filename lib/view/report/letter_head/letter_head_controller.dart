import 'dart:convert';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';

class LetterHeadController extends GetxController with StateMixin {
  List<FirmModel> firmName = <FirmModel>[].obs;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    change(firmName = await firmNameInfo());
    super.onInit();
  }

  Future<List<FirmModel>> firmNameInfo() async {
    List<FirmModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/firm/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => FirmModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  letterPadeUpdate(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/notepad',
            requestBodydata: request)
        .then((response) async {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['pdf_url'];

        if (data != null) {
          final Uri url = Uri.parse(data);
          if (!await launchUrl(url)) {
            throw Exception('Could not launch $data');
          }
        }
        Get.back();
      } else {
        print('error: ${json['message']}');
      }
    });
  }
}
