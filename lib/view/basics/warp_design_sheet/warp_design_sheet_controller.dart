import 'dart:convert';
import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/WarpDesignSheetModel.dart';
import 'package:get/get.dart';
import '../../../model/YarnModel.dart';
import '../../../http/api_repository.dart';
import '../../../utils/app_utils.dart';

class WarpDesignSheetController extends GetxController with StateMixin {
  List<YarnModel> yarn_dropdown = <YarnModel>[].obs;
  List<NewColorModel> color_dropdown = <NewColorModel>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};
  @override
  void onInit() async {
    change(yarn_dropdown = await yarnNameInfo());
    change(color_dropdown = await colorInfo());
    super.onInit();
  }
  Future<List<NewColorModel>> colorInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        print(data);
        result = (data as List).map((i) => NewColorModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }
  Future<List<YarnModel>> yarnNameInfo() async {
    List<YarnModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/yarn')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        result = (data as List).map((i) => YarnModel.fromJson(i)).toList();
        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }
  Future<dynamic> warpDesignSheet({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warpdesign?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => WarpDesignSheetModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <WarpDesignSheetModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void addWarpDesignSheet(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/warpdesign',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        // print('addwarpDesignSheet: $json');
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void updateWarpDesignSheet(var request, String id) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/warpdesign',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        //  print('addLedger: $json');
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  Future<dynamic> deleteWarpDesignSheet(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/warpdesign/$id')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        AppUtils.showSuccessToast(message: "${json["message"]}");
        //ledgers(page: '1');
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
