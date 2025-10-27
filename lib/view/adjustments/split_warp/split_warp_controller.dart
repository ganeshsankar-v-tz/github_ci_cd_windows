import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../model/WarpDesignSheetModel.dart';
import '../../../utils/app_utils.dart';

class SplitWarpController extends GetxController with StateMixin {
  List<NewWarpModel> newWarp = <NewWarpModel>[].obs;
  List<NewColorModel> colorDropdown = <NewColorModel>[].obs;
  List<SplitWarpWarpIdItemTableModel> warpIdDropdown =
      <SplitWarpWarpIdItemTableModel>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};
  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    change(newWarp = await newWarpInfo());
    change(colorDropdown = await colorInfo());
    super.onInit();
  }

  // Color Name
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

  //Warp Design Name
  Future<List<WarpDesignSheetModel>> warpDesignInfo() async {
    List<WarpDesignSheetModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/newwrap/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => WarpDesignSheetModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  //New warp
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

  Future<List<dynamic>> splitWarp({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/split_warp_list?$query')
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

  void add(var request) async {
    change(null, status: RxStatus.loading());

    await HttpRepository.apiRequest(HttpRequestType.post, 'api/split_warp_add',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  /// WarpDesign Id By Warp Id And Details
  Future<List<SplitWarpWarpIdItemTableModel>> warpIdNoDropdown(
      var warpId) async {
    List<SplitWarpWarpIdItemTableModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/get_warp_design_id_to_warp_detail?warp_design_id=$warpId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => SplitWarpWarpIdItemTableModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(warpIdDropdown = result);
    return result;
  }

  void edit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/split_warp_update',
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
    print('delete');
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/split_warp_delete/$id')
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
}

class SplitWarpWarpIdItemTableModel {
  String? warpId;
  int? metre;
  String? emptyType;
  int? emptyQty;
  int? sheet;
  String? warpColor;
  int? warpDesignId;
  String? wrapCondition;
  String? designName;

  SplitWarpWarpIdItemTableModel(
      {this.warpId,
      this.metre,
      this.emptyType,
      this.emptyQty,
      this.sheet,
      this.warpColor,
      this.warpDesignId,
      this.wrapCondition,
      this.designName});

  SplitWarpWarpIdItemTableModel.fromJson(Map<String, dynamic> json) {
    warpId = json['warp_id'];
    metre = json['metre'];
    emptyType = json['empty_type'];
    emptyQty = json['empty_qty'];
    sheet = json['sheet'];
    warpColor = json['warp_color'];
    warpDesignId = json['warp_design_id'];
    wrapCondition = json['wrap_condition'];
    designName = json['design_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['warp_id'] = this.warpId;
    data['metre'] = this.metre;
    data['empty_type'] = this.emptyType;
    data['empty_qty'] = this.emptyQty;
    data['sheet'] = this.sheet;
    data['warp_color'] = this.warpColor;
    data['warp_design_id'] = this.warpDesignId;
    data['wrap_condition'] = this.wrapCondition;
    data['design_name'] = this.designName;
    return data;
  }

  @override
  String toString() {
    return '${warpId}';
  }
}
