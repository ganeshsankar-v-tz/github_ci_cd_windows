import 'dart:convert';

import 'package:abtxt/model/WinderInwardYarnColorQtyModel.dart';
import 'package:abtxt/model/YarnInWardWinderModel.dart';
import 'package:abtxt/model/YarnStockBalanceModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/YarnModel.dart';
import '../../../utils/app_utils.dart';

class YarnInwardFromWinderController extends GetxController with StateMixin {
  List<LedgerModel> ledger_dropdown = <LedgerModel>[].obs;
  List<YarnModel> yarn_dropdown = <YarnModel>[].obs;
  List<NewColorModel> color_dropdown = <NewColorModel>[].obs;
  List<WinderIdByDcNoModel> dcNo = <WinderIdByDcNoModel>[].obs;
  List<WinderInwardYarnColorQtyModel> deliveredDetails =
      <WinderInwardYarnColorQtyModel>[].obs;
  Map<String, dynamic> request = <String, dynamic>{};

  var itemList = <dynamic>[];
  var filterData;
  WinderIdByDcNoModel lastDcNo = WinderIdByDcNoModel(dcNo: "");

  @override
  void onInit() async {
    ledgerInfo();
    super.onInit();
  }

  /// pdf
  Future<String?> yarnInwardFromWinder({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/yarn_inwards_winder_pdf?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  /// Get The Dc No In Yarn Delver To Winder
  Future<List<WinderIdByDcNoModel>> winderIdByDcNo(var winderId) async {
    change(null, status: RxStatus.loading());
    List<WinderIdByDcNoModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/deliverd_yarn_dc_no_by_winder_id?winder_id=$winderId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => WinderIdByDcNoModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(dcNo = result, status: RxStatus.success());
    return result;
  }

  /// dc no rec no to get the delivered
  /// yarn name, color name and qty

  Future<List<WinderInwardYarnColorQtyModel>> dcRecNobYYarnColorAndQty(
      var id) async {
    change(null, status: RxStatus.loading());
    List<WinderInwardYarnColorQtyModel> result = [];
    List<YarnModel> yarnResult = [];
    List<NewColorModel> colorResult = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/deliverd_yarn_and_color_by_rec_dc_no_2?rec_dc_no=$id')
        .then((response) {
      var json = jsonDecode(response.data);
      change(null, status: RxStatus.success());
      if (response.success) {
        var data = json['data'];

        result = (data as List)
            .map((i) => WinderInwardYarnColorQtyModel.fromJson(i))
            .toList();
        Set<int> yarnIds = {};
        Set<int> colorIds = {};

        for (var e in data) {
          var yarnModel = YarnModel(id: e["yarn_id"], name: e["yarn_name"]);

          var colorModel =
              NewColorModel(id: e["color_id"], name: e["color_name"]);

          if (!yarnIds.contains(yarnModel.id)) {
            yarnResult.add(yarnModel);
            yarnIds.add(yarnModel.id ?? 0);
          }

          if (!colorIds.contains(colorModel.id)) {
            colorResult.add(colorModel);
            colorIds.add(colorModel.id ?? 0);
          }
        }
      } else {
        print('error: ${json['message']}');
      }
    });
    change(deliveredDetails = result);
    change(yarn_dropdown = yarnResult);
    change(color_dropdown = colorResult);
    return result;
  }

  /// Yarn And Color By Wider Stock Check

  Future<YarnStockBalanceModel?> winderStock(
      var yarnId, var colourId, var dcNoId) async {
    YarnStockBalanceModel? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/deliverd_yarn_stock_using_yarn_color_and_rec_dc_no?rec_dc_no=$dcNoId&yarn_id=$yarnId&color_id=$colourId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = YarnStockBalanceModel.fromJson(data);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  //Ledger name
  Future<List<LedgerModel>> ledgerInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=winder')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(ledger_dropdown = result);
    return result;
  }

  Future<List<YarnInWardWinderModel>> paginatedList(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<YarnInWardWinderModel> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/yarn_inward_from_winder?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        list = (data as List)
            .map((i) => YarnInWardWinderModel.fromJson(i))
            .toList();
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(null, status: RxStatus.success());
    return list;
  }

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/add_yarn_inward_from_winder',
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

  void edit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/update_yarn_inward_from_winder',
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

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/winder_yarn_inward_delete?id=$id&password=$password')
        .then((response) {
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

  Future<bool> selectedRowRemove(var id) async {
    bool result = false;
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/winder/inward/item/remove/$id')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        result = true;
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: $error');
      }
    });
    return result;
  }
}

/// This Model Used For WiderIdByDcNo Method

class WinderIdByDcNoModel {
  int? id;
  String? dcNo;
  String? eDate;
  String? yarnNames;

  WinderIdByDcNoModel({
    this.id,
    this.dcNo,
    this.eDate,
    this.yarnNames,
  });

  WinderIdByDcNoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dcNo = json['dc_no'];
    eDate = json['e_date'];
    yarnNames = json['yarn_names'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dc_no'] = dcNo;
    data['yarn_names'] = yarnNames;
    return data;
  }

  @override
  String toString() {
    return "$dcNo";
  }
}
