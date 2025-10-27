import 'dart:convert';

import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/RollerInwardWarpDetails.dart';
import 'package:abtxt/model/WarpDesignModel.dart';
import 'package:abtxt/model/payment_models/PayDetailsHistoryModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LoomModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../model/warp_id_details/NewWarpIdDetailsModel.dart';
import '../../../utils/app_utils.dart';

class WarpInwardFromRollerController extends GetxController with StateMixin {
  List<FirmModel> firmDropdown = <FirmModel>[].obs;
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  List<LedgerModel> accountDropdown = <LedgerModel>[].obs;
  List<NewColorModel> colorDropdown = <NewColorModel>[].obs;
  List<WarpDesignModel> warpDesignDropdown = <WarpDesignModel>[].obs;
  List<NewWarpModel> warpDesignList = <NewWarpModel>[].obs;
  RxList<RollerInwardWarpDetails> warpDesignIdByWarpDetails =
      RxList<RollerInwardWarpDetails>();
  List<LoomModel> loomList = <LoomModel>[].obs;
  List<LedgerModel> weaverDropdown = <LedgerModel>[].obs;

  var lastWarp;
  var itemList = <dynamic>[];
  int? rollerId;
  var filterData;

  RxBool getBackBoolean = RxBool(false);

  String? warpID;

  @override
  void onInit() async {
    ledgerInfo();
    accountInfo();
    change(weaverDropdown = await weaverInfo());
    change(firmDropdown = await firmInfo());
    change(colorDropdown = await colorInfo());
    change(warpDesignList = await warpDesignName());

    super.onInit();
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

  /// Last Warp Id Details
  Future<NewWarpIdDetailsModel?> warpIdInfo(var rollerId, var eDate) async {
    NewWarpIdDetailsModel? result;
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/last_warp_id_warp_delivery_roller_using_roller_id_v2?roller_id=$rollerId&e_date=$eDate')
        .then((response) {
      change(null, status: RxStatus.success());
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

  /// pdf
  Future<String?> warpInwardFromRollerPdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/roler_Warp_inward_print?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  Future<List<dynamic>> warpInward({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/inward_roller_list?$query')
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

  void addInward(var request) async {
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/roller_inward_store',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var id = json['data']['id'];
        var message = json["message"];
        _printDialog(id, message);
        // Get.back(result: 'success');
        // AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  void updateInward(var request) async {
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/roller_inward_edit',
            requestBodydata: request)
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

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/roller_warp_inward_delete?id=$id&password=$password')
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

  //Ledger Name Dropdown Api Call
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
    change(accountDropdown = result);
    return result;
  }

  /// Roller Id By Warp Design Api Call
  Future<List<WarpDesignModel>> warpDesignInfo(var rollerId) async {
    List<WarpDesignModel> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/get_warp_design_id_from_warp_delivery_roller?roller_id=$rollerId')
        .then((response) {
      var json = jsonDecode(response.data);
      change(null, status: RxStatus.success());
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

  /// Warp Id By Warp Details
  Future<List<RollerInwardWarpDetails>> warpIdByWarpDetails(
      var warpDesignId, var rollerId) async {
    List<RollerInwardWarpDetails> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/deliverd_warp_details_using_warpdesignid?warp_design_id=$warpDesignId&roller_id=$rollerId')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json["data"];
        var res = (data as List)
            .map((i) => RollerInwardWarpDetails.fromJson(i))
            .toList();

        for (var element in res) {
          bool isExist = _checkWarpIdAlreadyExits(element.oldWarpId);
          if (!isExist) {
            result.add(element);
          }
        }

        warpDesignIdByWarpDetails.value = result;
      } else {
        print('error: ${json['message']}');
      }
    });

    return result;
  }

  _checkWarpIdAlreadyExits(oldWarpId) {
    var exists = itemList.any((element) => element['old_warp_id'] == oldWarpId);
    return exists;
  }

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

  Future<List<PayDetailsHistoryModel>> payDetails(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<PayDetailsHistoryModel> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/roller_payment_history?$query')
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

  /// Check if the selected row's warp ID has been delivered to the weaver.
  /// If the warp has been delivered, do not allow removal.
  Future<String?> rowRemoveCheck(
      var rowId, var rollerInwardId, var newWarpId) async {
    String? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/roller_inward_item_remove_alart?row_id=$rowId&roller_inward_id=$rollerInwardId&new_warp_id=$newWarpId')
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
            HttpRequestType.get, 'api/label_roller_inward_print/$id')
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

  Future<String> weaverAndLoomChange(var request) async {
    String result = "";
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/warp_allocation_update',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        result = "success";
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
    return result;
  }
}
