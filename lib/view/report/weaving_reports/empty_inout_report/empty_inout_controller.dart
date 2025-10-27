import 'dart:convert';

import 'package:get/get.dart';

import '../../../../http/api_repository.dart';
import '../../../../model/ProductInfoModel.dart';
import '../../../../model/WarpDesignModel.dart';

class EmptyInOutReportController extends GetxController with StateMixin {
  List<ProductInfoModel> productNameList = <ProductInfoModel>[].obs;
  List<WarpDesignModel> warpDesignDropdown = <WarpDesignModel>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};
  int? weaverId;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    productNameInfo();
    warpDesignInfo();

    super.onInit();
  }

  Future<List<WarpDesignModel>> warpDesignInfo() async {
    List<WarpDesignModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_design_list_in_roller')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => WarpDesignModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(warpDesignDropdown = result);
    return result;
  }

  Future<List<ProductInfoModel>> productNameInfo() async {
    List<ProductInfoModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/productinfolist/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => ProductInfoModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(productNameList = result);
    return result;
  }

  Future<String?> emptyInoutReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rolling_empty_inout_report?$query')
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
