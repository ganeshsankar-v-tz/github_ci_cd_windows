import 'dart:convert';

import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/payment_models/AccountDetailsModel.dart';
import 'package:abtxt/model/payment_models/AdvanceAmountDetailsModel.dart';
import 'package:abtxt/model/payment_models/LedgerBySlipDetails.dart';
import 'package:abtxt/model/payment_models/PaymentV2Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../http/api_repository.dart';
import '../../../model/AccountModel.dart';
import '../../../utils/app_utils.dart';

class PaymentV2Controller extends GetxController with StateMixin {
  List<FirmModel> firmDropdown = <FirmModel>[].obs;
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  List<LedgerModel> allLedgerNames = <LedgerModel>[].obs;
  List<AccountModel> paymentAccounts = <AccountModel>[].obs;
  List<AccountModel> debitAccounts = <AccountModel>[].obs;
  List<AdvanceAmountDetailsModel> advanceAmountList =
      <AdvanceAmountDetailsModel>[].obs;
  List<AccountDetailsModel> accountNumberList = <AccountDetailsModel>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};
  var itemTableSlipList = <dynamic>[];
  var filterData;

  /// Selected Slip Amount Total
  double totalAmount = 0.0;

  /// Total Paid Amount
  double paidTotal = 0.0;

  /// Payment Balance
  double paymentAmount = 0.0;
  int? ledgerId;

  /// Pay Screen Validation Purpose
  String payType = "";

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    // allLedgerInfo();
    change(firmDropdown = await firmInfo());
    change(paymentAccounts = await paymentAccountInfo());
    change(debitAccounts = await debitAccountInfo());
    super.onInit();
  }

  Future<List<AdvanceAmountDetailsModel>> advanceAmountDetails(
      var ledgerId) async {
    List<AdvanceAmountDetailsModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/Advance_mid_amount_details_using_ledger_id?ledger_id=$ledgerId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => AdvanceAmountDetailsModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(advanceAmountList = result);
    return result;
  }

  Future<List<AccountDetailsModel>> accountDetails(var ledgerId) async {
    List<AccountDetailsModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/get_weaver_account_details?weaver_id=$ledgerId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => AccountDetailsModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(accountNumberList = result);
    return result;
  }

  Future<List<AccountModel>> paymentAccountInfo() async {
    List<AccountModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/account_list?ac_type_1=Payment Type Account')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => AccountModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<AccountModel>> debitAccountInfo() async {
    List<AccountModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/account_list?ac_type_1=Advance Amount')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => AccountModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<FirmModel>> firmInfo() async {
    change(null, status: RxStatus.loading());
    List<FirmModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/firm/list')
        .then((response) {
      change(null, status: RxStatus.success());
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

  Future<List<LedgerModel>> ledgerInfo(var roll) async {
    change(null, status: RxStatus.loading());
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=$roll')
        .then((response) {
      change(null, status: RxStatus.success());
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

  // /// Used For Filter Screen
  // Future<List<LedgerModel>> allLedgerInfo() async {
  //   List<LedgerModel> result = [];
  //   await HttpRepository.apiRequest(
  //           HttpRequestType.get, 'api/rollbased?ledger_role=all')
  //       .then((response) {
  //     var json = jsonDecode(response.data);
  //     if (response.success) {
  //       var data = json['data'];
  //       result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
  //     } else {
  //       print('error: ${json['message']}');
  //     }
  //   });
  //   change(allLedgerNames = result);
  //   return result;
  // }

  Future<List<LedgerBySlipDetails>> ledgerBySlipDetails(
      var ledgerId, var paymentType) async {
    List<LedgerBySlipDetails> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/get_job_details_using_ledger_id?ledger_id=$ledgerId&payment_type=$paymentType')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];

        var res =
            (data as List).map((i) => LedgerBySlipDetails.fromJson(i)).toList();

        for (var element in res) {
          bool isExist = _checkSlipAlreadyExits(element.id);
          if (!isExist) {
            result.add(element);
          }
        }
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  _checkSlipAlreadyExits(id) {
    var exists =
        itemTableSlipList.any((element) => element["slip_rec_no"] == id);
    return exists;
  }

  // PaymentV2Model
  Future<List<PaymentV2Model>> paymentList({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<PaymentV2Model> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/payment_list_v3?$query')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => PaymentV2Model.fromJson(i)).toList();
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  /// pdf
  Future<String?> paymentPdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/payment_v3_pdf?$query')
        .then((response) {
      var json = jsonDecode(response.data);
      change(null, status: RxStatus.success());
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/payment_list_v3_add',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        var id = json['data']['id'];
        // Get.back(result: 'success');
        // AppUtils.showSuccessToast(message: "${json["message"]}");
        if (id != null) {
          _printDialog('$id', json["message"]);
        }
      } else {
        var error = jsonDecode(response.data);
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
                        String? response = await paymentPdf(request: request);
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

  void edit(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/payment_list_v3_update',
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
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/delete_payment?id=$id&password=$password')
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
}
