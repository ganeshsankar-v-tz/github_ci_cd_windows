import 'dart:convert';
import 'package:get/get.dart';
import '../../../http/api_repository.dart';
import '../../../model/warping_design_charges_config_model.dart';
import '../../../utils/app_utils.dart';
import '../../../model/NewWarpModel.dart';

class WarpingDesignChargesConfigController extends GetxController with StateMixin {

  List<NewWarpModel> warpDesign = <NewWarpModel>[].obs;
  Map<String, dynamic> request = <String, dynamic>{};

  @override
  void onInit() async {
    change(warpDesign = await warpDesignApi());
    super.onInit();
  }
  Future<List<NewWarpModel>> warpDesignApi() async {
    List<NewWarpModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/newwrap')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        print(data);
        result = (data as List).map((i) => NewWarpModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> warpDesignCharges ({var page = "1",var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/warp_design_change_list?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list =
        (data as List).map((i) => WarpDesignChargesConfigModel.fromJson(i)).toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <WarpDesignChargesConfigModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void add(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/warp_design_change_add',
        requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('$json');
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
      }
    });
  }

  void edit(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/warp_design_change_update',
        requestBodydata: request)
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
    await HttpRepository.apiRequest(HttpRequestType.delete, 'api/warp_design_change_delete/$id')
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
