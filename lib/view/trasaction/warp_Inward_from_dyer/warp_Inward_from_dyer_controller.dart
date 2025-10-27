import 'dart:convert';

import 'package:abtxt/model/NewWarpModel.dart';
import 'package:abtxt/model/WarpDesignModel.dart';
import 'package:abtxt/model/WarpInwardFromdyerModel.dart';
import 'package:abtxt/model/WarpInwardWarpDetailsModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/payment_models/PayDetailsHistoryModel.dart';
import '../../../model/warp_id_details/NewWarpIdDetailsModel.dart';
import '../../../utils/app_utils.dart';

class WarpInwardFromDyerController extends GetxController with StateMixin {
  List<LedgerModel> dyerNameDropDown = <LedgerModel>[].obs;
  List<LedgerModel> accountDropDown = <LedgerModel>[].obs;
  List<WarpDesignModel> warpDesignDropDown = <WarpDesignModel>[].obs;
  RxList<WarpInwardWarpDetailsModel> designIdByWarpDetails =
      RxList<WarpInwardWarpDetailsModel>();
  List<NewColorModel> colorDropdown = <NewColorModel>[].obs;
  List<FirmModel> firmDropdown = <FirmModel>[].obs;
  List<NewWarpModel> warpDesignList = <NewWarpModel>[].obs;

  int? dyerId;
  var lastWarp;
  var itemList = <dynamic>[];
  var filterData;

  RxBool getBackBoolean = RxBool(false);

  List<Map<String, dynamic>> request = [];

  String? warpID;

  @override
  void onInit() async {
    dyerNameInfo();
    accountInfo();
    change(colorDropdown = await colorInfo());
    change(firmDropdown = await firmInfo());
    change(warpDesignList = await warpDesignName());

    super.onInit();
  }

  Future<List<NewWarpModel>> warpDesignName() async {
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

  // ColorDropDown
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

  // DyerName
  Future<List<LedgerModel>> dyerNameInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=dyer')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(dyerNameDropDown = result);
    return result;
  }

  // Account
  Future<List<LedgerModel>> accountInfo() async {
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
    change(accountDropDown = result);
    return result;
  }

  /// Last Warp Id Details
  Future<NewWarpIdDetailsModel?> warpIdInfo(var dyerId, var eDate) async {
    NewWarpIdDetailsModel? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/last_warp_id_warp_delivery_dyer_using_dyer_id_v2?dyer_id=$dyerId&e_date=$eDate')
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

  /// Delivered Warp List By Dyer Id
  Future<List<WarpDesignModel>> warpDesignInfo(var dyerId) async {
    change(null, status: RxStatus.loading());
    List<WarpDesignModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/delivered_warp_list_by_dyer_id?dyer_id=$dyerId')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => WarpDesignModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(warpDesignDropDown = result);
    return result;
  }

  /// Send The Warp Design id And Get The Delivered Warp Details
  Future<List<WarpInwardWarpDetailsModel>> warpDesignIdDetails(
      var warpDesignId, var dyerId) async {
    List<WarpInwardWarpDetailsModel> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/delivered_warp_details?warp_design_id=$warpDesignId&dyer_id=$dyerId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        var res = (data as List)
            .map((i) => WarpInwardWarpDetailsModel.fromJson(i))
            .toList();

        for (var element in res) {
          bool isExist = _checkWarpIdAlreadyExits(element.warpId);
          if (!isExist) {
            result.add(element);
          }
        }

        designIdByWarpDetails.value = result;
      } else {
        print('error: ${json['message']}');
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  _checkWarpIdAlreadyExits(oldWarpId) {
    var exists = itemList.any((element) => element['old_warp_id'] == oldWarpId);
    return exists;
  }

  /// pdf
  Future<String?> warpInwardFromDyerPdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/dyer_Warp_inward_print?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  Future<List<WarpInwardFromDyerModel>> warpInwardDyer(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<WarpInwardFromDyerModel> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/inward_dyer_list?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        list = (data as List)
            .map((i) => WarpInwardFromDyerModel.fromJson(i))
            .toList();
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(null, status: RxStatus.success());
    return list;
  }

  void addwarpInward(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/inward_dyer_store',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        var id = json['data']['id'];
        var message = json["message"];
        _printDialog(id, message);
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  void updatewarpInward(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/inward_dyer_edit',
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

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/dyer_warp_inward_delete?id=$id&password=$password')
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

  Future<List<PayDetailsHistoryModel>> payDetails(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<PayDetailsHistoryModel> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/dyer_payment_history?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        list = (data as List)
            .map((i) => PayDetailsHistoryModel.fromJson(i))
            .toList();
      } else {
        var error = jsonDecode(response.data);
      }
    });
    return list;
  }

  /// Check if the selected row's warp ID has been delivered to the roller.
  /// If the warp has been delivered, do not allow removal.
  Future<String?> rowRemoveCheck(
      var rowId, var dyerInwardId, var newWarpId) async {
    String? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/dyer_inward_item_remove_alart?row_id=$rowId&dyer_inward_id=$dyerInwardId&new_warp_id=$newWarpId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = data;
      } else {
        result = "False";
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<String?> labelPrintPdf(int id) async {
    change(null, status: RxStatus.loading());
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/label_dyer_inward_print/$id')
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
