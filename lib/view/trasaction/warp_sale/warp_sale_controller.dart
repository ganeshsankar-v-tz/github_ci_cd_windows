import 'dart:convert';

import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/WarpDesignModel.dart';
import 'package:abtxt/model/WarpSaleModel.dart';
import 'package:abtxt/model/WarpSaleWarpIdModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/TaxFixingModel.dart';
import '../../../model/vehicle_details/VehicleDetailsModel.dart';
import '../../../utils/app_utils.dart';

class WarpSaleController extends GetxController with StateMixin {
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  List<FirmModel> firmDropdown = <FirmModel>[].obs;
  List<LedgerModel> accountDropdown = <LedgerModel>[].obs;
  List<WarpDesignModel> designSheetDropdown = <WarpDesignModel>[].obs;
  List<WarpSaleWarpIdModel> warpIdDetails = <WarpSaleWarpIdModel>[].obs;
  List<LedgerModel> ledgerByTax = <LedgerModel>[].obs;
  List<VehicleDetailsModel> vehicleDetailsList = <VehicleDetailsModel>[].obs;


  var filterData;
  var itemList = <dynamic>[];
  var warpName = "";

  @override
  void onInit() async {
    ledgerInfo();
    firmInfo();
    accountInfo();
    designInfo();
    ledgerByTaxCalling();
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

  Future<List<WarpSaleModel>> warpSaleListApi({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<WarpSaleModel> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_sale?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        list = (data as List).map((i) => WarpSaleModel.fromJson(i)).toList();
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(null, status: RxStatus.success());
    return list;
  }

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/warp_sale',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
      }
    });
  }

  void edit(var request,var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.put, 'api/warp_sale/$id',
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
            'api/warp_sale/$id?password=$password')
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

  Future<List<LedgerModel>> ledgerInfo() async {
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
    change(ledgerDropdown = result);
    return result;
  }

  // Dropdown Firm api call
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
    change(firmDropdown = result);

    return result;
  }

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
        print('error: ${json['message']}');
      }
    });
    change(accountDropdown = result);
    return result;
  }

  // Dropdown DesignSheet api call
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
    change(designSheetDropdown = result);
    return result;
  }

  Future<List<WarpSaleWarpIdModel>> warpIdDetailsApi(var warpDesignId) async {
    List<WarpSaleWarpIdModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/sale_warps_only?warp_design_id=$warpDesignId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        var res =
            (data as List).map((i) => WarpSaleWarpIdModel.fromJson(i)).toList();
        for (var element in res) {
          bool isExist = _checkWarpIdAlreadyExits(element.newWarpId);
          if (!isExist) {
            result.add(element);
          }
        }
      } else {
        print('error: ${json['message']}');
      }
    });
    change(warpIdDetails = result);
    return result;
  }

  _checkWarpIdAlreadyExits(warpId) {
    var exists = itemList.any((element) => element['warp_id'] == warpId);
    return exists;
  }

  /// pdf
  Future<String?> warpSalePdf(var id) async {
    change(null, status: RxStatus.loading());

    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_sale_pdf/$id')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }
}
