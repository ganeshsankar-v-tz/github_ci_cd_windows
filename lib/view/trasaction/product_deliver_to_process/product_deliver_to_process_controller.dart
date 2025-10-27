import 'dart:convert';

import 'package:abtxt/model/ProcessTypeModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../model/TaxFixingModel.dart';
import '../../../utils/app_utils.dart';

class ProductDeliverToProcessController extends GetxController with StateMixin {
  List<FirmModel> firmName = <FirmModel>[].obs;
  List<LedgerModel> processName = <LedgerModel>[].obs;
  List<ProductInfoModel> productName = <ProductInfoModel>[].obs;
  List<ProcessTypeModel> processType = <ProcessTypeModel>[].obs;
  List<LedgerModel> ledgerByTax = <LedgerModel>[].obs;
  Map<String, dynamic> request = <String, dynamic>{};
  var filterData;

  int? slipId;

  @override
  void onInit() async {
    ledgerInfo();
    productInfo();
    processTypeInfo();
    change(firmName = await firmNameInfo());
    change(ledgerByTax = await ledgerByTaxCalling());
    super.onInit();
  }

  Future<List<LedgerModel>> ledgerByTaxCalling() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/ledger_by_tax_Calculation_drop_down')
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

  Future<List<TaxFixingModel>> taxFixing(String entryType) async {
    List<TaxFixingModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/tax_fixing?entry_type=$entryType')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => TaxFixingModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<ProductInfoModel>> productInfo() async {
    List<ProductInfoModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/product_dropdown_list?used_for=Job work')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => ProductInfoModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(productName = result);
    return result;
  }

  Future<List<ProcessTypeModel>> processTypeInfo() async {
    List<ProcessTypeModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/process_type/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => ProcessTypeModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(processType = result);
    return result;
  }

  Future<List<LedgerModel>> ledgerInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=processor')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(processName = result);
    return result;
  }

  Future<List<FirmModel>> firmNameInfo() async {
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

  Future<List<dynamic>> productDeliverToProcess(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/process_delivery?$query')
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
      HttpRequestType.post,
      'api/process_delivery_add',
      requestBodydata: request,
    ).then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      var id = json['data']['id'];
      // Get.back(result: 'success');
      // AppUtils.showSuccessToast(message: "${json["message"]}");
      if (id != null) {
        _printDialog('$id', json["message"]);
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
                            await processDeliveryReport(request: request);
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
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/process_delivery_udpate',
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
        Get.back();
      }
    });
  }

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/process_delivery_delete?id=$id&password=$password')
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

  Future<String?> processDeliveryReport({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/process_delivery_report?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  // check the selected row is not inward in process inward
  // if any one qty is inward not allow to update
  Future<String?> rowUpdateCheckApi(int? id, productId, processType) async {
    String? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/update_process_delivery_row?id=$id&product_id=$productId&process_type=$processType')
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
}
