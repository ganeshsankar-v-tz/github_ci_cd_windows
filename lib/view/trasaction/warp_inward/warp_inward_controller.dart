import 'dart:convert';

import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/NewWarpModel.dart';
import 'package:abtxt/model/NweWarpWagingConfigModel.dart';
import 'package:abtxt/model/YarnModel.dart';
import 'package:abtxt/model/warp_id_details/NewWarpIdDetailsModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../http/api_repository.dart';
import '../../../model/LoomModel.dart';
import '../../../utils/app_utils.dart';

class WarpInwardController extends GetxController with StateMixin {
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  List<LedgerModel> weaverDropdown = <LedgerModel>[].obs;
  List<FirmModel> firmDropdown = <FirmModel>[].obs;
  List<LedgerModel> purchaseAccountDropdown = <LedgerModel>[].obs;
  List<NewWarpModel> newWarpDropDown = <NewWarpModel>[].obs;
  List<NewColorModel> colorDropdown = <NewColorModel>[].obs;
  List<YarnModel> yarnDropdown = <YarnModel>[].obs;
  List<WarpInwardDetailsModel> detailsData = <WarpInwardDetailsModel>[].obs;
  List<LoomModel> loomList = <LoomModel>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};
  var filterData;

  var warperName = "";
  var warpDesign = "";

  @override
  void onInit() async {
    newWarpInfo();
    change(ledgerDropdown = await ledgerInfo());
    change(weaverDropdown = await weaverInfo());
    change(firmDropdown = await firmInfo());
    change(purchaseAccountDropdown = await purchaseAccount());
    change(colorDropdown = await colorInfo());
    change(yarnDropdown = await yarnnameInfo());
    super.onInit();
  }

  Future<List<LoomModel>> loomInfo(var id) async {
    List<LoomModel> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/active_looms_only?weaver_id=$id')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LoomModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(loomList = result);
    return result;
  }

  /// Weaver Id  New Warp Id Get
  Future<NewWarpIdDetailsModel?> warpIDDetails(var weaverId, var eDate) async {
    NewWarpIdDetailsModel? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/last_warpid_using_weaver_id_warpinward_v2?warper_id=$weaverId&e_date=$eDate')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = NewWarpIdDetailsModel.fromJson(data);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<dynamic>> warpInward({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_inward_list?$query')
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

  /// Pdf
  Future<String?> warpInwardPdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_inward_print?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/warp_inward_store',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        var id = json['data']['id'];
        var message = json["message"];
        _printDialog(id, message);
        // Get.back(result: 'success');
        // AppUtils.showSuccessToast(message: "${json["message"]}");
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
            HttpRequestType.post, 'api/warp_inward_edit',
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
            'api/warp_inward_delete?id=$id&password=$password')
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

  // Dropdown ledger api call
  Future<List<LedgerModel>> ledgerInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=warper')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<LedgerModel>> weaverInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=weaver')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<WarpInwardDetailsModel>> detailsColumnData() async {
    List<WarpInwardDetailsModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/already_added_details_data')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => WarpInwardDetailsModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(detailsData = result);
    return result;
  }

  // Dropdown ledger api call
  Future<List<FirmModel>> firmInfo() async {
    List<FirmModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/firm/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => FirmModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  // Dropdown ledger api call
  Future<List<LedgerModel>> purchaseAccount() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/ledger_by?account_type=Direct Expenses')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  // Dropdown ledger api call
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
    change(newWarpDropDown = result);
    return result;
  }

  /// send the Warp Design Id And Get The Details
  Future<List<NweWarpWagingConfigModel>> warpDesignUsingByWarpInfo(
      var warpDesignId) async {
    List<NweWarpWagingConfigModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/warp_details_using_by_warp_design?Warp_design_id=$warpDesignId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => NweWarpWagingConfigModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

//Dropdown Color API call
  Future<List<NewColorModel>> colorInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color/list')
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

  // Dropdown yarnName Api call
  Future<List<YarnModel>> yarnnameInfo() async {
    List<YarnModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/yarn/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => YarnModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<String?> labelPrintPdf(int id) async {
    change(null, status: RxStatus.loading());
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/label_warp_inward_print/$id')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  _printDialog(int id, var message) {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Center(child: Text("Do you want print?")),
        titleTextStyle: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.w600, color: Colors.red),
        content: SizedBox(
          height: 75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "$message",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      foregroundColor: Colors.red,
                      side:
                          const BorderSide(color: Colors.red), //// Border color
                    ),
                    onPressed: () {
                      Get.back();
                      Get.back(result: 'success');
                    },
                    child: const Text(
                      "NO",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      foregroundColor: Colors.blue,
                      side: const BorderSide(
                          color: Colors.blue), //// Border color
                    ),
                    autofocus: true,
                    onPressed: () async {
                      String? response = await labelPrintPdf(id);
                      final Uri url = Uri.parse(response!);
                      Get.back();
                      Get.back(result: 'success');
                      if (!await launchUrl(url)) {
                        throw Exception('Error : $response');
                      }
                    },
                    child: const Text(
                      "YES",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WarpInwardDetailsModel {
  String? details;

  WarpInwardDetailsModel({this.details});

  WarpInwardDetailsModel.fromJson(Map<String, dynamic> json) {
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['details'] = details;
    return data;
  }

  @override
  String toString() {
    return "$details";
  }
}
