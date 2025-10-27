import 'dart:convert';
import 'dart:ui';

import 'package:abtxt/model/YarnOpeningStockResponse.dart';
import 'package:get/get.dart';
import '../../../utils/app_utils.dart';
import '../../../http/api_repository.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/YarnModel.dart';

class YarnOpeningStockController extends GetxController with StateMixin {
  List<YarnModel> YarnName = <YarnModel>[].obs;
  List<NewColorModel> ColorName = <NewColorModel>[].obs;
  @override
  void onInit() async {
    change(YarnName = await yarnInfo());
    change(ColorName = await colorInfo());


    super.onInit();
  }
  // Yarn Name
  Future<List<YarnModel>> yarnInfo() async {
    List<YarnModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/yarn/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data'];
        print(data);
        print('----------------------------------------------------');
        result = (data as List).map((i) => YarnModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  // Color Name
  Future<List<NewColorModel>> colorInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data'];
        print(data);
        print('----------------------------------------------------');
        result = (data as List).map((i) => NewColorModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> YarOpeningStock({var page = "1",var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(
        HttpRequestType.get, 'api/yarnopening?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List).map((i) => YarnOpeningStockModel.fromJson(i)).toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <YarnOpeningStockModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void add(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.upload, 'api/addYarnOpen', formDatas: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void edit(var request, var id) async {
    await HttpRepository.apiRequest(HttpRequestType.upload, 'api/updateYarnOpen/$id', formDatas: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  Future<dynamic> delete(var id) async {
    print('delete');
    await HttpRepository.apiRequest(HttpRequestType.delete, 'api/yarnopening/$id')
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
