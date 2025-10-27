import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/AlternativeWarpDesignModel.dart';
import '../../../model/WarpDesignSheetModel.dart';
import '../../../utils/app_utils.dart';

class AltWarpDesignController extends GetxController with StateMixin {
  List<WarpDesignSheetModel> warpDesign = <WarpDesignSheetModel>[].obs;
  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    change(warpDesign = await warpDesignInfo());
    super.onInit();
  }

  //Warp Design Name
  Future<List<WarpDesignSheetModel>> warpDesignInfo() async {
    List<WarpDesignSheetModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/warpdesign')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data']['data'];
        print(data);
        result = (data as List)
            .map((i) => WarpDesignSheetModel.fromJson(i))
            .toList();
        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> paginatedList({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/alternative_warp_list?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('${(response.data)}');
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => AlternativeWarpDesignModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <AlternativeWarpDesignModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/alternative_warp_add',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        change(null, status: RxStatus.success());
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        change(null, status: RxStatus.success());
        print('error: ${error}');
      }
    });
  }

  void edit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/alternative_warp_update',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        change(null, status: RxStatus.success());
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        change(null, status: RxStatus.success());
        print('$error');
      }
    });
  }

  Future<dynamic> delete(var id) async {
    print('delete');
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/alternative_warp_delete/$id')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
