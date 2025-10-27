import 'dart:convert';

import 'package:get/get.dart';

import '../../../../http/api_repository.dart';
import '../../../../model/saree_checker/SareeCheckerModel.dart';

class SareeCheckerReportController extends GetxController with StateMixin {
  List<SareeCheckerModel> sareeCheckerDetails = <SareeCheckerModel>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};
  int? weaverId;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    warpDesignInfo();

    super.onInit();
  }

  Future<List<SareeCheckerModel>> warpDesignInfo() async {
    List<SareeCheckerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/saree_checker_list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => SareeCheckerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(sareeCheckerDetails = result);
    return result;
  }


  Future<String?> sareeCheckerReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/saree_checkers/report?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }
}
