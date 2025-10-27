import 'dart:convert';

import 'package:abtxt/model/weaving_models/weft_balance/PrivateWeftRequirementListModel.dart';
import 'package:get/get.dart';

import '../../../../http/api_repository.dart';
import '../../../../model/YarnModel.dart';

class PrivateWeftRequirementController extends GetxController with StateMixin {
  List<YarnModel> yarnName = <YarnModel>[].obs;
  var itemList = <dynamic>[];

  @override
  void onInit() async {
    change(yarnName = await yarnNameInfo());

    super.onInit();
  }

  Future<PrivateWeftRequirementListModel?> weavingAcIdByPrivateWeftDetails(
      var weavingAcId, var productId) async {
    PrivateWeftRequirementListModel? result;
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/get_common_weft_req_for_priweft?weaving_ac_id=$weavingAcId&product_id=$productId')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = PrivateWeftRequirementListModel.fromJson(data);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<PrivateWeftRequirementListModel>> listScreen(
      var weavingAcId) async {
    List<PrivateWeftRequirementListModel> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/private_weft_balance_list?weaving_ac_id=$weavingAcId')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => PrivateWeftRequirementListModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<YarnModel>> yarnNameInfo() async {
    List<YarnModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/yarn/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => YarnModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  void edit(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/private_weft_req_v2',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        // AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        Get.back(result: 'failed');
      }
    });
  }
}
