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

import '../../../../http/api_repository.dart';
import '../../../../model/ProductInfoModel.dart';
import '../../../../model/credit_note/ProductSaleReturnSlipNoModel.dart';
import '../../../../utils/app_utils.dart';

class ProductSalesReturnController extends GetxController with StateMixin {
  List<FirmModel> firmName = <FirmModel>[].obs;
  List<ProductInfoModel> productName = <ProductInfoModel>[].obs;
  List<LedgerModel> customerDropdown = <LedgerModel>[].obs;
  List<VehicleDetailsModel> vehicleDetailsList = <VehicleDetailsModel>[].obs;
  List<LedgerModel> accountDropdown = <LedgerModel>[].obs;
  Rxn<DcNoIdByCustomerDetails> customerDetails = Rxn<DcNoIdByCustomerDetails>();
  List<LedgerModel> ledgerByTax = <LedgerModel>[].obs;
  List<ProductOrderDetailsModel> orderDetails =
      <ProductOrderDetailsModel>[].obs;
  List<ProductSaleReturnSlipNoModel> slipNoDropdown =
      <ProductSaleReturnSlipNoModel>[].obs;

  @override
  void onInit() async {
    accountInfo();
    firmInfo();
    customerInfo();
    ledgerByTaxCalling();
    productInfo();
    vehicleDetails();
    change(null, status: RxStatus.success());
    super.onInit();
  }

  Future<List<ProductSaleReturnSlipNoModel>> slipNoDetails(
      var type, var firmId, var ledgerId) async {
    List<ProductSaleReturnSlipNoModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/credit_note/sale/slip/list?credit_note_type=$type&firm_id=$firmId&customer_id=$ledgerId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((e) => ProductSaleReturnSlipNoModel.fromJson(e))
            .toList();

        slipNoDropdown = result;
        update();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
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
        result =
            (data as List).map((i) => VehicleDetailsModel.fromJson(i)).toList();
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
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/credit/note',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: true);
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: $error');
      }
    });
  }

  void edit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.put, 'api/credit/note/$id',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: true);
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        debugPrint('$error');
      }
    });
  }

  Future<dynamic> selectedDebitNoteDetails(var id) async {
    change(null, status: RxStatus.loading());
    var list = {};
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/credit_note/slip/details/$id')
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
}
