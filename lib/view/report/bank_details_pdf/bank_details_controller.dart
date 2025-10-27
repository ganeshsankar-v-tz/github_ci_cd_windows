import 'dart:convert';

import 'package:get/get.dart';

import '../../../../http/api_repository.dart';
import '../../../../model/LedgerModel.dart';

class BankDetailsController extends GetxController with StateMixin {
  RxList<LedgerModel> ledgerDropdown = RxList(<LedgerModel>[]);
  late Uri overAllReportPdfUrl;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  // Weaver Name
  Future<List<LedgerModel>> ledgerInfo(var role) async {
    change(null, status: RxStatus.loading());
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
        HttpRequestType.get, 'api/rollbased?ledger_role=$role')
        .then((response) {
      change(null, status: RxStatus.success());
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

  /// PDF
  Future<List<dynamic>> bankDetails({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/loom_account_details_pdf?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        list = json["data"]["bank_info"];
        overAllReportPdfUrl = Uri.parse(json["data"]["report_url"]);
      } else {
        var error = jsonDecode(response.data);
      }
    });
    return list;
  }
}
