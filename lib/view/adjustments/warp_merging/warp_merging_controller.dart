import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../model/WarpDesignSheetModel.dart';
import '../../../utils/app_utils.dart';

class WarpMergingController extends GetxController with StateMixin {
  // List<WarpDesignSheetModel> warpDesign = <WarpDesignSheetModel>[].obs;
  List<NewWarpModel> newWarp = <NewWarpModel>[].obs;
  List<NewColorModel> colorDropdown = <NewColorModel>[].obs;
  List<WarpIDByWarpDetails> warpDetails = <WarpIDByWarpDetails>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};
  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    // change(warpDesign = await warpDesignInfo());
    change(newWarp = await newWarpInfo());
    change(colorDropdown = await colorInfo());
    super.onInit();
  }

  //
  Future<List<NewColorModel>> colorInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => NewColorModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  //New Warp
  Future<List<NewWarpModel>> newWarpInfo() async {
    List<NewWarpModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/newwrap/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];

        result = (data as List).map((i) => NewWarpModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  //Warp Design Name
  Future<List<WarpDesignSheetModel>> warpDesignInfo() async {
    List<WarpDesignSheetModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/warpdesign')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data']['data'];
        // print(data);
        result = (data as List)
            .map((i) => WarpDesignSheetModel.fromJson(i))
            .toList();
        // print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  //Get API
  Future<List<dynamic>> warpMerging({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_merge_list?$query')
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

  // void add(var request) async {
  //   change(null, status: RxStatus.loading());
  //   await HttpRepository.apiRequest(
  //           HttpRequestType.post, 'api/warp_merging_add',
  //           requestBodydata: request)
  //       .then((response) {
  //     if (response.success) {
  //       var json = jsonDecode(response.data);
  //       change(null, status: RxStatus.success());
  //       Get.back();
  //       AppUtils.showSuccessToast(message: "${json["message"]}");
  //     } else {
  //       var error = jsonDecode(response.data);
  //       change(null, status: RxStatus.success());
  //       print('error: ${error}');
  //     }
  //   });
  // }

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/warp_merging_add',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
        // _dialogBuilder('${json["message"]}');
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  void edit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/warp_merging_update',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('$error');
      }
    });
  }

  Future<dynamic> delete(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/warp_merging_delete/$id')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  /// WarpDesign Id By Warp Id And Details

  Future<List<WarpIDByWarpDetails>> warpDetailsDropdown(var warpId) async {
    List<WarpIDByWarpDetails> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/get_warp_id_no_to_warps_details?warp_design_id=$warpId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => WarpIDByWarpDetails.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(warpDetails = result);
    return result;
  }
}

///Warp Id by Warp Details:

class WarpIDByWarpDetails {
  String? warpId;
  int? prodQty;
  int? metre;
  String? warpCondition;
  String? emptyType;
  int? emptyQty;
  int? sheet;
  String? warpColor;

  WarpIDByWarpDetails(
      {this.warpId,
      this.prodQty,
      this.metre,
      this.warpCondition,
      this.emptyType,
      this.emptyQty,
      this.sheet,
      this.warpColor});

  WarpIDByWarpDetails.fromJson(Map<String, dynamic> json) {
    warpId = json['warp_id'];
    prodQty = json['prod_qty'];
    metre = json['metre'];
    warpCondition = json['warp_condition'];
    emptyType = json['empty_type'];
    emptyQty = json['empty_qty'];
    sheet = json['sheet'];
    warpColor = json['warp_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['warp_id'] = warpId;
    data['prod_qty'] = prodQty;
    data['metre'] = metre;
    data['warp_condition'] = warpCondition;
    data['empty_type'] = emptyType;
    data['empty_qty'] = emptyQty;
    data['sheet'] = sheet;
    data['warp_color'] = warpColor;
    return data;
  }

  @override
  String toString() {
    return '$warpId';
  }
}
