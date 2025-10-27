import 'dart:convert';

import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/WarpOpeningStockModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/NewWarpModel.dart';
import '../../../utils/app_utils.dart';

class WarpOpeningStockController extends GetxController with StateMixin {
  List<NewColorModel> colorDropdown = <NewColorModel>[].obs;
  List<NewWarpModel> warpDesignDropdown = <NewWarpModel>[].obs;


  @override
  void onInit() async {
    change(colorDropdown = await colorInfo());
    change(warpDesignDropdown = await warpDesignInfo());
    super.onInit();
  }





  //Warp Design
  Future<List<NewWarpModel>> warpDesignInfo() async {
    List<NewWarpModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/newwrap')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        print(data);
        result = (data as List)
            .map((i) => NewWarpModel.fromJson(i))
            .toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

//
  Future<List<NewColorModel>> colorInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data['data'] as List)
            .map((i) => NewColorModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> warpOpeningStock({var page = "1",var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warpopenlist?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => WarpOpeningStockModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <WarpOpeningStockModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void add(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.upload, 'api/addWarpOpen',
            formDatas: request)
        .then((response) {
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

  void edit(var request, var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.upload, 'api/updateWarpOpen/$id',
            formDatas: request)
        .then((response) {
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

  Future<dynamic> delete(var id) async {
    print('delete');
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/deletewarpopen/$id')
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
