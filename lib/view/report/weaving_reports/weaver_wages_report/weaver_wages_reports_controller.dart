import 'dart:convert';

import 'package:get/get.dart';

import '../../../../http/api_repository.dart';
import '../../../../model/FirmModel.dart';
import '../../../../model/LedgerModel.dart';

class WeaverWagesListReportController extends GetxController with StateMixin {
  List<LedgerModel> ledgerlistweavers = <LedgerModel>[].obs;
  List<FirmModel> firmDropdown = <FirmModel>[].obs;

  @override
  void onInit() async {
    change(ledgerlistweavers = await ledger());
    change(firmDropdown = await firmInfo());

    super.onInit();
  }

//Firm Name

  Future<List<FirmModel>> firmInfo() async {
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

  // Weaver Name
  Future<List<LedgerModel>> ledger() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=weaver')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<dynamic>> weaverWages({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/Required?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        list = json['data'];
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(null, status: RxStatus.success());
    return list;
  }

  Future<String?> weaverWagesReport({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'requirement_api?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);

      if (response.success) {
        url = json['data'];

        print(url);
      } else {}
    });
    return url;
  }
}
