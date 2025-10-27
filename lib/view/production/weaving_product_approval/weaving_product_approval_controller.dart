import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/weaving_models/WeavingProductApprovalModel.dart';
import '../../../utils/app_utils.dart';

class WeavingProductApprovalController extends GetxController with StateMixin {
  List<WeavingProductApprovalModel> weavingPendingProductApprovalList = [];
  var filterData;


  @override
  void onInit() {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  Future<void> weavingProduct(var request) async {
    change(null, status: RxStatus.loading());
    List<WeavingProductApprovalModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/weaving_ac_v5_get?$request')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        result = (json['data'] as List)
            .map((e) => WeavingProductApprovalModel.fromJson(e))
            .toList();
        weavingPendingProductApprovalList = result;
      } else {
        var error = jsonDecode(response.data);
      }
    });
  }

  Future<void> weavingStatusChange(var request, int id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.put, 'api/weaving_ac_v5_update/$id',
            requestBodydata: request)
        .then((response) async {
      change(null, status: RxStatus.success());
      if (response.success) {
        await weavingProduct("status[0]=Pending");
        AppUtils.showSuccessToast(
            message: response.message ?? 'Status updated successfully');
      } else {
        var error = jsonDecode(response.data);
        AppUtils.showErrorToast(message: error['error']);
      }
    });
  }
}
