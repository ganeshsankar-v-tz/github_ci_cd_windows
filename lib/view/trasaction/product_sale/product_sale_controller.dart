import 'dart:convert';

import 'package:abtxt/model/DcNoIdByCustomerDetails.dart';
import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/TaxFixingModel.dart';
import 'package:abtxt/model/product_sale/ProductOrderDetailsModel.dart';
import 'package:abtxt/model/vehicle_details/VehicleDetailsModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../http/api_repository.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../utils/app_utils.dart';

class ProductSaleController extends GetxController with StateMixin {
  List<FirmModel> firmName = <FirmModel>[].obs;
  List<ProductInfoModel> productName = <ProductInfoModel>[].obs;
  List<LedgerModel> customerDropdown = <LedgerModel>[].obs;
  List<VehicleDetailsModel> vehicleDetailsList = <VehicleDetailsModel>[].obs;
  List<LedgerModel> accountDropdown = <LedgerModel>[].obs;
  Rxn<DcNoIdByCustomerDetails> customerDetails = Rxn<DcNoIdByCustomerDetails>();
  List<LedgerModel> ledgerByTax = <LedgerModel>[].obs;
  List<ProductOrderDetailsModel> orderDetails =
      <ProductOrderDetailsModel>[].obs;

  RxBool getBackBoolean = RxBool(false);
  var filterData;

  int? customerId;
  var itemList = <dynamic>[];

  @override
  void onInit() async {
    accountInfo();
    firmInfo();
    customerInfo();
    ledgerByTaxCalling();
    productInfo();
    vehicleDetails();
    super.onInit();
  }

  Future<List<VehicleDetailsModel>> vehicleDetails() async {
    change(null, status: RxStatus.loading());
    List<VehicleDetailsModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/transport_list')
        .then((response) {
      if (response.success) {
        change(null, status: RxStatus.success());
        var json = jsonDecode(response.data);
        var data = json['data'];
        result = (data as List).map((i) => VehicleDetailsModel.fromJson(i)).toList();
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(vehicleDetailsList = result);
    return result;
  }

  Future<List<ProductInfoModel>> productInfo() async {
    List<ProductInfoModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/productinfolist/list?saree_for=sales')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => ProductInfoModel.fromJson(i)).toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    change(productName = result);
    return result;
  }

  /// Ledger By Tax Api call
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
        debugPrint('error: ${json['message']}');
      }
    });
    change(ledgerByTax = result);
    return result;
  }

  // Firm
  Future<List<FirmModel>> firmInfo() async {
    List<FirmModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/firm/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => FirmModel.fromJson(i)).toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    change(firmName = result);
    return result;
  }

  // Customer Name
  Future<List<LedgerModel>> customerInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=customer')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    change(customerDropdown = result);
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
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  // Account Type
  Future<List<LedgerModel>> accountInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/ledger_by?account_type=Sales Accounts')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    change(accountDropdown = result);
    return result;
  }

  Future<List<DcNoIdByCustomerDetails>> dcNoIdByCustomerDetails(
      var dcRecNo) async {
    List<DcNoIdByCustomerDetails> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/product_sale_data_using_dc_no?dc_rec_no=$dcRecNo')
        .then((response) {
      var json = jsonDecode(response.data);
      change(null, status: RxStatus.success());
      if (response.success) {
        var data = json['data']["data"];
        result = (data as List)
            .map((i) => DcNoIdByCustomerDetails.fromJson(i))
            .toList();
        if (result.isNotEmpty) {
          customerDetails.value = result[0];
          change(customerDetails);
        }
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  /// pdf
  productSalePdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }

    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/product_sale_pdf?$query')
        .then((response) async {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        if (data!.isNotEmpty && data != null) {
          final Uri url = Uri.parse(data);
          if (!await launchUrl(url)) {
            throw Exception('Error : $response');
          }
        }
      } else {}
    });
  }

  Future<List<dynamic>> productSaleList({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/product_sale_list?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        list = json['data'];
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: ${error['message']}');
      }
    });
    change(null, status: RxStatus.success());
    return list;
  }

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/product_sale_store',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        var id = json['data']['id'];
        alertDialog("$id", json["message"]);
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: $error');
      }
    });
  }

  void edit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/product_sale_update',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        debugPrint('$error');
      }
    });
  }

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/product_sale_delete?id=$id&password=$password')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: $error');
      }
    });
  }

  Future<dynamic> productStockBalance(var productId) async {
    change(null, status: RxStatus.loading());
    dynamic result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/product_stock_details?product_id=$productId')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data']["total_stock"];
        result = data;
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<ProductOrderDetailsModel>> orderNoDetailsInfo(int id) async {
    List<ProductOrderDetailsModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/product_order_no_list?customer_id=$id')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => ProductOrderDetailsModel.fromJson(i))
            .toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    change(orderDetails = result);
    return result;
  }

  Future<List<dynamic>> oderNiByDetails(String orderNo) async {
    List<dynamic> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/product_order_item_details?order_no=$orderNo')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = data;
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> lastYarnPurchaseDetails(var productId, var customerId) async {
    dynamic result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/latest_product_sale_list?product_id=$productId&customer_id=$customerId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = data;
      } else {
        debugPrint('error: $json');
      }
    });
    return result;
  }

  printDialog(String id, {bool getBack = true}) async {
    print("object $id");
    if (id.isEmpty) {
      return;
    }

    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: SizedBox(
          height: 250,
          width: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Print Type",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  var request = {'id': id, 'pdf_format': "original"};
                  Get.back();
                  if (getBack) {
                    Get.back(result: 'success');
                  }
                  productSalePdf(request: request);
                },
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(Size(Get.width, 46)),
                  foregroundColor:
                      WidgetStateProperty.resolveWith((states) => Colors.white),
                  shape: WidgetStateProperty.resolveWith((s) =>
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0))),
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.focused)) {
                      return const Color(0xFF5700BC);
                    }
                    return Colors.blue;
                  }),
                ),
                child: const Text('Original'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  var request = {'id': id, 'pdf_format': "duplicate"};
                  Get.back();
                  if (getBack) {
                    Get.back(result: 'success');
                  }
                  productSalePdf(request: request);
                },
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(Size(Get.width, 46)),
                  foregroundColor:
                      WidgetStateProperty.resolveWith((states) => Colors.white),
                  shape: WidgetStateProperty.resolveWith((s) =>
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0))),
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.focused)) {
                      return const Color(0xFF5700BC);
                    }
                    return Colors.blue;
                  }),
                ),
                child: const Text('Duplicate'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  var request = {'id': id, 'pdf_format': "triplicate"};
                  Get.back();
                  if (getBack) {
                    Get.back(result: 'success');
                  }
                  productSalePdf(request: request);
                },
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(Size(Get.width, 46)),
                  foregroundColor:
                      WidgetStateProperty.resolveWith((states) => Colors.white),
                  shape: WidgetStateProperty.resolveWith((s) =>
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0))),
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.focused)) {
                      return const Color(0xFF5700BC);
                    }
                    return Colors.blue;
                  }),
                ),
                child: const Text('Triplicate'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  var request = {'id': id, 'pdf_format': "all"};
                  Get.back();
                  if (getBack) {
                    Get.back(result: 'success');
                  }
                  productSalePdf(request: request);
                },
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(Size(Get.width, 46)),
                  foregroundColor:
                      WidgetStateProperty.resolveWith((states) => Colors.white),
                  shape: WidgetStateProperty.resolveWith((s) =>
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0))),
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.focused)) {
                      return const Color(0xFF5700BC);
                    }
                    return Colors.blue;
                  }),
                ),
                child: const Text('All'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  alertDialog(String id, var message) {
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
                      Get.back();
                      printDialog(id, getBack: true);
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
