import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';

import '../http/api_repository.dart';
import '../model/FirmModel.dart';

class BaseController extends GetxController with StateMixin {
  final box = GetStorage();
  var FIRM_LIST = RxList<FirmModel>([]);

  @override
  void onInit() async {
    FIRM_LIST.value = await initFirm();
    super.onInit();
  }

  Future<List<FirmModel>> initFirm() async {
    print('initFirm');
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
}
