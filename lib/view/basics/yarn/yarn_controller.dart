import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/NewUnitModel.dart';
import '../../../utils/app_utils.dart';

class YarnController extends GetxController with StateMixin {
  Map<String, dynamic> request = <String, dynamic>{};

  List<NewUnitModel> unitDropdown = <NewUnitModel>[].obs;
  var filterData;

  @override
  void onInit() async {
    unitInfo();
    change(null, status: RxStatus.success());
    super.onInit();
  }

  //New Yarn Name
  Future<List<NewUnitModel>> unitInfo() async {
    List<NewUnitModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/unit/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => NewUnitModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(unitDropdown=result);
    return result;
  }

  Future<List<dynamic>> yarn({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/yarn?$query')
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

  void addyarn(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/yarn',
            //  requestBodydata: request)
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void updateyarn(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/updateYarn',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/delete_yarn?id=$id&password=$password')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error["message"]}');
      }
    });
  }
}
