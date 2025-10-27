import 'dart:convert';

import 'package:abtxt/model/app_history/AppHistoryModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/administrator/AdministratorModel.dart';

class AppHistoryController extends GetxController with StateMixin {
  List<AdministratorModel> userName = <AdministratorModel>[].obs;
  var filterData;

  @override
  void onInit() async {
    userNameDetails();
    super.onInit();
  }

  Future<List<AdministratorModel>> userNameDetails() async {
    List<AdministratorModel> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/user_list')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];

        result =
            (data as List).map((i) => AdministratorModel.fromJson(i)).toList();

        result = result
            .where(
                (element) => element.userType != "D" && element.userType != "F")
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(userName = result);
    return result;
  }

  Future<List<AppHistoryModel>> appHistoryDetails(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<AppHistoryModel> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/activity_logs?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        list = (data as List).map((i) => AppHistoryModel.fromJson(i)).toList();
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(null, status: RxStatus.success());
    return list;
  }
}
