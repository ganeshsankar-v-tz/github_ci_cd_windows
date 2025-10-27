import 'dart:convert';

import 'package:abtxt/model/CostingChangeHeaderValuesModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../utils/app_utils.dart';

class CostingChangeListController extends GetxController with StateMixin {
  List<CostingChangeHeadersModel> headers = <CostingChangeHeadersModel>[].obs;
  // Map<String, dynamic> request = <String, dynamic>{};

  @override
  void onInit() async {
    super.onInit();
    change(headers = await headerInfo());
  }

  void add(var header, var newValue) async {
    await HttpRepository.apiRequest(
      HttpRequestType.post,
      'api/costing_change_add?header=$header&new_value=$newValue',
    ).then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
        Get.back();
      }
    });
  }

  Future<List<CostingChangeHeadersModel>> headerInfo() async {
    List<CostingChangeHeadersModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/header_dropdown')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => CostingChangeHeadersModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<CostingChangeHeaderValuesModel>> changeCostingValue(
      var header, var newValue) async {
    List<CostingChangeHeaderValuesModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/header_data?header=$header&new_value=$newValue')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => CostingChangeHeaderValuesModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }
}

class CostingChangeHeadersModel {
  String? header;

  CostingChangeHeadersModel({this.header});

  CostingChangeHeadersModel.fromJson(Map<String, dynamic> json) {
    header = json['header'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['header'] = header;
    return data;
  }

  @override
  String toString() {
    return "$header";
  }
}
