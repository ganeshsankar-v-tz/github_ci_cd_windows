import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../http/api_repository.dart';
import '../../../../model/FirmModel.dart';
import '../../../../../model/LedgerModel.dart';
import '../../../../model/NewColorModel.dart';
import '../../../../model/TaxFixingModel.dart';
import '../../../../model/YarnModel.dart';
import '../../../../model/YarnStockBalanceModel.dart';
import '../../../../model/credit_note/YarnSaleReturnSlipNoModel.dart';
import '../../../../utils/app_utils.dart';

class YarnSaleReturnController extends GetxController with StateMixin {
  List<FirmModel> firmNameDropdown = <FirmModel>[].obs;
  List<LedgerModel> customerNameDropdown = <LedgerModel>[].obs;
  List<TaxFixingModel> taxFix = <TaxFixingModel>[].obs;
  List<LedgerModel> ledgerByTax = <LedgerModel>[].obs;
  List<YarnSaleReturnSlipNoModel> slipNoDropdown =
      <YarnSaleReturnSlipNoModel>[].obs;

  // AddItem
  List<YarnModel> yarnNameDropdown = <YarnModel>[].obs;
  List<NewColorModel> colorNameDropdown = <NewColorModel>[].obs;

  @override
  void onInit() async {
    firmInfo();
    customerInfo();
    YarnInfo();
    ColorInfo();
    change(ledgerByTax = await ledgerByTaxCalling());
    change(null, status: RxStatus.success());

    super.onInit();
  }

  Future<List<YarnSaleReturnSlipNoModel>> slipNoDetails(
      var type, var firmId, var ledgerId) async {
    List<YarnSaleReturnSlipNoModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/credit_note/sale/slip/list?credit_note_type=$type&firm_id=$firmId&customer_id=$ledgerId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((e) => YarnSaleReturnSlipNoModel.fromJson(e))
            .toList();

        slipNoDropdown = result;
        update();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
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

  /// this  methode Used For Display Extra Gst Values in Gst Calculation Table
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
        print('error: ${json['message']}');
      }
    });
    change(firmNameDropdown = result);
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
        print('error: ${json['message']}');
      }
    });
    change(customerNameDropdown = result);
    return result;
  }

  // AddItem
  // Yarn
  Future<List<YarnModel>> YarnInfo() async {
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
    change(yarnNameDropdown = result);
    return result;
  }

  // Color Name
  Future<List<NewColorModel>> ColorInfo() async {
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
    change(colorNameDropdown = result);
    return result;
  }

  /// pdf
  Future<String?> yarnSalePdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/yarns_sales_print_pdf?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  Future<List<dynamic>> yarnsale({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/yarnsale?$query')
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
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/credit/note',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: true);
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
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
        print('error: $error');
      }
    });
  }

  /// Check The Yarn Balance In Stocks
  Future<YarnStockBalanceModel?> yarnStockBalance(
      var yarnId, var colorId, var stockIn) async {
    change(null, status: RxStatus.loading());
    YarnStockBalanceModel? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/overall_balance_yarn_stock?yarn_id=$yarnId&color_id=$colorId&stock_in=$stockIn')
        .then((response) {
      change(null, status: RxStatus.success());
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
}
