import 'dart:convert';

import 'package:abtxt/model/weaving_models/WarpOrYarnDeliveryListModel.dart';
import 'package:abtxt/model/weaving_models/WarpOrYarnWeaverDetailsModel.dart';
import 'package:abtxt/model/weaving_models/WeaverCurrentProductModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../http/api_repository.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/LoomGroup.dart';
import '../../../model/LoomModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../model/WarpType.dart';
import '../../../model/YarnStockBalanceModel.dart';
import '../../../model/weaving_models/WeaverByLoomStatusModel.dart';
import '../../../model/weaving_models/WeavingWarpDeliveryModel.dart';
import '../../../utils/app_utils.dart';

class EmptyInOutController extends GetxController with StateMixin {
  List<LedgerModel> WeaverName = <LedgerModel>[].obs;
  List<NewWarpModel> warpDesignDropdown = <NewWarpModel>[].obs;
  RxList<WeavingWarpDeliveryModel> warpDetails =
      RxList<WeavingWarpDeliveryModel>();
  List<WarpType> warpTypeList = <WarpType>[].obs;
  Rxn<WarpOrYarnWeaverDetailsModel> weaverDetails =
      Rxn<WarpOrYarnWeaverDetailsModel>();
  List<WeaverByLoomStatusModel> warpStatus = <WeaverByLoomStatusModel>[].obs;
  List<LoomGroup> loomList = <LoomGroup>[].obs;
  List<NewWarpModel> newWarpDropDown = <NewWarpModel>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};

  var lastAddedDetails;
  var itemList = <dynamic>[];
  var filterData;

  int? weaverId;
  bool? mainWarpDeliverStatus;
  RxBool getBackBoolean = RxBool(false);

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    change(WeaverName = await weaverNameInfo());
    newWarpInfo();
    super.onInit();
  }

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

  /// Check The Warp Or Yarn Already Added In Same Date Or Not
  Future<bool?> samDateProductAddedOrNot(var weaverId, var date) async {
    bool? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/warp_yarn_avl_in_same_date?weaver_id=$weaverId&e_date=$date')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = data;
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  /// Check The Yarn Balance In Stocks
  Future<YarnStockBalanceModel?> yarnStockBalance(
      var yarnId, var colorId, var stockIn) async {
    YarnStockBalanceModel? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/overall_balance_yarn_stock?yarn_id=$yarnId&color_id=$colorId&stock_in=$stockIn')
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

  /// Weaver Loom By Warp Status
  Future<List<WeaverByLoomStatusModel>> loomWarpStatus(
      var weaverId, var loomNo) async {
    List<WeaverByLoomStatusModel> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/loom_status_weav_no_using_loomno?weaver_id=$weaverId&loom_no=$loomNo')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => WeaverByLoomStatusModel.fromJson(i))
            .toList();
        result = result
          ..sort((a, b) => "${a.currentStatus}"
              .length
              .compareTo("${b.currentStatus}".length));
      } else {
        print('error: ${json['message']}');
      }
    });
    change(warpStatus = result);
    return result;
  }

  /// Challan No By Update The Weaver Details
  Future<WarpOrYarnWeaverDetailsModel> weaverDetailByChallanNo(
      var challanNo, var recNo) async {
    dynamic result;
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/warp_yarn_delivery_datas_using_challan_no?rec_no=$recNo&challan_no=$challanNo')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = WarpOrYarnWeaverDetailsModel.fromJson(data);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  /// List Screen Response With Filter
  Future<List<WarpOrYarnDeliveryListModel>> emptyInoutListApiCall(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<WarpOrYarnDeliveryListModel> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_delivery?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        list = (data as List)
            .map((i) => WarpOrYarnDeliveryListModel.fromJson(i))
            .toList();
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(null, status: RxStatus.success());
    return list;
  }

//   Weaver Name
  Future<List<LedgerModel>> weaverNameInfo() async {
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

  /// Pdf
  Future<String?> emptyInOutPdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/empty_in_out_t_printer?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  /// Weaver Name by Loom No and Warp Status
  Future<List<LoomGroup>> loomInfo(var id) async {
    List<LoomGroup> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/weavingloom?weaver_id=$id')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        final gMap = (data as List).groupBy((m) => m['sub_weaver_no']);
        result = gMap.entries.map((entry) {
          var looms = (entry.value).map((i) => LoomModel.fromJson(i)).toList();
          return LoomGroup(loomNo: entry.key, looms: looms);
        }).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(loomList = result);
    return result;
  }

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/warp_yarn_delivery_post_v2',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        var id = json['data']['id'];
        var challanNo = json['data']['challan_no'];
        var message = json["message"];
        if (id != null) {
          _printDialog('$id', challanNo, message);
        }
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  _printDialog(String id, challanNo, var message) {
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
                        side: const BorderSide(color: Colors.red),
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
                        side: const BorderSide(color: Colors.blue),
                      ),
                      autofocus: true,
                      onPressed: () async {
                        var request = {'id': id, "challan_no": challanNo};
                        String? response =
                            await emptyInOutPdf(request: request);
                        final Uri url = Uri.parse(response!);
                        Get.back();
                        Get.back(result: 'success');
                        if (!await launchUrl(url)) {
                          throw Exception('Error : $response');
                        }
                      },
                      child: const Text(
                        "PDF",
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
                        side: const BorderSide(color: Colors.blue),
                      ),
                      autofocus: true,
                      onPressed: () async {
                        String? response =
                            await labelPrintPdf(int.tryParse(id)!);
                        final Uri url = Uri.parse(response!);
                        Get.back();
                        Get.back(result: 'success');
                        if (!await launchUrl(url)) {
                          throw Exception('Error : $response');
                        }
                      },
                      child: const Text(
                        "LABEL",
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

  void edit(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/warp_yarn_delivery_update_v2',
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

  /// Weaver Product By Warp Details
  Future<void> warpInfo(var productId) async {
    await HttpRepository.apiRequest(
      HttpRequestType.get,
      'api/item_details?product_id=$productId',
      requestBodydata: request,
    ).then((response) async {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        warpTypeList = (data as List).map((i) => WarpType.fromJson(i)).toList();
        change(warpTypeList);
      } else {
        print('error: ${json['message']}');
      }
    });
  }

  Future<dynamic> delete(var id, var password) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/delete_warp_yarn_delivery?id=$id&password=$password')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error["message"]}');
      }
    });
  }

  Future<dynamic> selectedRowDelete(var id, var weavingAcId) async {
    String? result;
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/warp_yarn_delivery_item_remove?id=$id&weaving_ac_id=$weavingAcId')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        result = json["data"];
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error["message"]}');
      }
    });
    return result;
  }

  /// Weaver current product details
  Future<List<WeaverCurrentProductModel>> weaverCurrentProducts(
      var weaverId, var loomNo) async {
    List<WeaverCurrentProductModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/get_warp_details_in_warpyarn_delivery?weaver_id=$weaverId&loom=$loomNo')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => WeaverCurrentProductModel.fromJson(i))
            .toList();
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
            HttpRequestType.get, 'api/label_bobin_print/$id')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  Future<dynamic> runningWarpDetails(int weaverId, String loomNo) async {
    dynamic result;
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/running_warp_details?weaver_id=$weaverId&loom_no=$loomNo')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = data;
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }
}
