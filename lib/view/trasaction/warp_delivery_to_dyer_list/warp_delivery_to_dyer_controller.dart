import 'dart:convert';

import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/WarpDesignModel.dart';
import 'package:abtxt/model/WarpDetailsByWarpDesignIdModel.dart';
import 'package:abtxt/model/saree_checker/SareeCheckerModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../http/api_repository.dart';
import '../../../utils/app_utils.dart';

class WarpDeliveryToDyerController extends GetxController with StateMixin {
  List<NewColorModel> colorDropdown = <NewColorModel>[].obs;
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  List<WarpDesignModel> warpDesignDropdown = <WarpDesignModel>[].obs;
  List<dynamic> dyerBalanceWarp = <dynamic>[].obs;
  RxList<WarpDetailsByWarpDesignIdModel> warpIdList =
      RxList<WarpDetailsByWarpDesignIdModel>();
  List<SareeCheckerModel> warpCheckerDropdown = <SareeCheckerModel>[].obs;

  var lastWarp;
  var itemList = <dynamic>[];
  var filterData;

  RxBool getBackBoolean = RxBool(false);

  @override
  void onInit() async {
    colorInfo();
    ledgerInfo();
    warpDesignInfo();
    warpCheckerDetails();
    super.onInit();
  }

  Future<List<dynamic>> dyerWarpBalanceDetails(var rollerId) async {
    dyerBalanceWarp.clear();
    List<dynamic> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/dyer_balance_warp_list?dyer_id=$rollerId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        result = json['data'];
      } else {
        print('error: ${json['message']}');
      }
    });
    change(dyerBalanceWarp = result);
    return result;
  }

  /// pdf
  Future<String?> warpDeliveryToDyerPdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/dyer_Warp_delivery?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  Future<List<dynamic>> paginatedList({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_dyer_list?$query')
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
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/dyer_delivery_store',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        var id = json['data']['id'];
        // AppUtils.showSuccessToast(message: "${json["message"]}");
        if (id != null) {
          _printDialog('$id', json["message"]);
        }
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  _printDialog(String id, var message) {
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
                        var request = {'id': id};
                        String? response =
                            await warpDeliveryToDyerPdf(request: request);
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

  void edit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/warp_dyer_edit',
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
            'api/dyer_warp_delivery_delete?id=$id&password=$password')
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

  //Color Name Dropdown Api Call
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
    change(colorDropdown = result);
    return result;
  }

  //Ledger Name Dropdown Api Call
  Future<List<LedgerModel>> ledgerInfo() async {
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
    change(ledgerDropdown = result);
    return result;
  }

  //WarpDesign Dropdown Api Call
  Future<List<WarpDesignModel>> warpDesignInfo() async {
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

  /// Warp Details by Warp Design Id Api Call. Use This Api in Bottom Sheet For Warp id Select to fill the values
  Future<List<WarpDetailsByWarpDesignIdModel>> warpDetailsByWarpDesignId(
      var warpDesignId,
      {bool isFilter = true}) async {
    change(null, status: RxStatus.loading());
    List<WarpDetailsByWarpDesignIdModel> result = [];
    warpIdList.clear();
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/warp_details_using_warp_design_v2?warp_design_id=$warpDesignId')
        .then((response) {
      var json = jsonDecode(response.data);
      change(null, status: RxStatus.success());
      if (response.success) {
        var data = json['data'];
        var res = (data as List)
            .map((i) => WarpDetailsByWarpDesignIdModel.fromJson(i))
            .toList();

        if (isFilter) {
          for (var element in res) {
            bool isExist = _checkWarpIdAlreadyExits(element.warpId);
            if (!isExist) {
              result.add(element);
            }
          }
        } else {
          result = res;
        }

        change(warpIdList.value = result);
      } else {
        print('error: ${json['message']}');
      }
    });
    //change(warpId = result);
    return result;
  }

  _checkWarpIdAlreadyExits(oldWarpId) {
    var exists = itemList.any((element) => element['warp_id'] == oldWarpId);
    return exists;
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
