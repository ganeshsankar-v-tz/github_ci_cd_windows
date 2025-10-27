import 'dart:convert';
import 'package:get/get.dart';
import '../../../http/api_repository.dart';
import '../../../model/LedgerModel.dart';

class JobWorkController extends GetxController with StateMixin {
  @override
  void onInit() async {
    super.onInit();
  }

  Future<dynamic> ledgers({var page = "1"}) async {
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/ledger?page=$page')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['ledger']['data'];
        var list = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
        var totalPage = (json['data']['ledger']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <LedgerModel>[], "totalPage": 1};
      }
    });
    return result;
  }

  void addLedger(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.upload, 'api/ledger',
            formDatas: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('addLedger: $json');
        Get.back();
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void updateLedger(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.upload, 'api/update_ledger',
            formDatas: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('addLedger: $json');
        Get.back();
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  Future<dynamic> deleteLedger(var id) async {
    await HttpRepository.apiRequest(HttpRequestType.delete, 'api/ledger/$id')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        //ledgers(page: '1');
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
