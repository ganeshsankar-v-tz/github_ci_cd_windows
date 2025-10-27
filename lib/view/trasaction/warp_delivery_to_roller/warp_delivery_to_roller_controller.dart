import 'dart:convert';

import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/WarpDesignModel.dart';
import 'package:abtxt/view/trasaction/warp_inward/warp_inward_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../http/api_repository.dart';
import '../../../model/RollerDeliverWarpDetails.dart';
import '../../../model/saree_checker/SareeCheckerModel.dart';
import '../../../utils/app_utils.dart';

class WarpDeliveryToRollerController extends GetxController with StateMixin {
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  List<WarpDesignModel> warpDesignDropdown = <WarpDesignModel>[].obs;
  List<NewColorModel> colorDropdown = <NewColorModel>[].obs;
  List<dynamic> rollerBalanceWarp = <dynamic>[].obs;
  RxList<RollerDeliverWarpDetails> warpIdList =
      RxList<RollerDeliverWarpDetails>();
  List<WarpInwardDetailsModel> detailsData = <WarpInwardDetailsModel>[].obs;
  List<SareeCheckerModel> warpCheckerDropdown = <SareeCheckerModel>[].obs;

  var lastWarp;
  var itemList = <dynamic>[];
  var filterData;

  RxBool getBackBoolean = RxBool(false);

  @override
  void onInit() async {
    ledgerInfo();
    designInfo();
    colorInfo();
    warpCheckerDetails();
    super.onInit();
  }

  /// warp inward details column data
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

  Future<List<dynamic>> rollerWarpBalanceDetails(var rollerId) async {
    rollerBalanceWarp.clear();
    List<dynamic> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/roller_balance_warp_list?roller_id=$rollerId')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        result = json['data'];
      } else {
        print('error: ${json['message']}');
      }
    });
    change(rollerBalanceWarp = result);
    return result;
  }

  /// pdf
  Future<String?> warpDeliverytoRollerPdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/roller_delivery_print?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  Future<List<dynamic>> rollerDWarp({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_delivery_to_roller_list?$query')
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

  void addwarpdroller(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/roller_delivery_store',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        var id = json['data']['id'];
        var dcNo = json['data']['dc_no'];
        // AppUtils.showSuccessToast(message: "${json["message"]}");
        if (id != null) {
          _printDialog('$id', "$dcNo", json["message"]);
        }
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  _printDialog(String id, dcNo, var message) {
    Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400),
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
                        side: const BorderSide(
                            color: Colors.red), //// Border color
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
                        var request = {'id': id, "dc_no": dcNo};
                        String? response =
                            await warpDeliverytoRollerPdf(request: request);
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
        ));
  }

  void updatewarpdroller(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/roller_delivery_edit',
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
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/roller_warp_delivery_delete?id=$id&password=$password')
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

  // ledger Name Dropdown api call
  Future<List<LedgerModel>> ledgerInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=roller')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(ledgerDropdown = result);
    return result;
  }

  Future<List<RollerDeliverWarpDetails>> wapDetailsByWarpId(var warpId) async {
    List<RollerDeliverWarpDetails> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/warp_details_in_warp_delivery_roller?warp_design_id=$warpId')
        .then((response) {
      var json = jsonDecode(response.data);
      change(null, status: RxStatus.success());
      if (response.success) {
        var data = json['data'];
        var res = (data as List)
            .map((i) => RollerDeliverWarpDetails.fromJson(i))
            .toList();

        for (var element in res) {
          bool isExist = _checkWarpIdAlreadyExits(element.warpId);
          if (!isExist) {
            result.add(element);
          }
        }

        warpIdList.value = result;
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  _checkWarpIdAlreadyExits(oldWarpId) {
    var exists = itemList.any((element) => element['warp_id'] == oldWarpId);
    return exists;
  }

  // Warp Design Dropdown api call
  Future<List<WarpDesignModel>> designInfo() async {
    List<WarpDesignModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_design_list_in_roller')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => WarpDesignModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(warpDesignDropdown = result);
    return result;
  }

  // Color Name Dropdown api call
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

  Future<List<SareeCheckerModel>> warpCheckerDetails() async {
    List<SareeCheckerModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/warp/checker')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => SareeCheckerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(warpCheckerDropdown = result);
    return result;
  }

}

class WarpDeliverDetailsModel {
  String? details;

  WarpDeliverDetailsModel({this.details});

  WarpDeliverDetailsModel.fromJson(Map<String, dynamic> json) {
    details = json['warp_det'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['warp_det'] = details;
    return data;
  }

  @override
  String toString() {
    return "$details";
  }
}
