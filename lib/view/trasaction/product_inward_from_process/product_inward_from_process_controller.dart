import 'dart:convert';

import 'package:abtxt/model/ProcessorDcNoIdByDetailsModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/payment_models/PayDetailsHistoryModel.dart';
import '../../../model/process_inward/ProcessInwardProcessTypeModel.dart';
import '../../../model/process_inward/ProcessInwardProductNameModel.dart';
import '../../../utils/app_utils.dart';

class ProductInwardFromProcessController extends GetxController
    with StateMixin {
  List<FirmModel> firmName = <FirmModel>[].obs;
  List<LedgerModel> processorName = <LedgerModel>[].obs;
  List<LedgerModel> accountDropDown = <LedgerModel>[].obs;
  List<ProcessorIdByDcNoModel> dcNo = <ProcessorIdByDcNoModel>[].obs;
  List<ProcessInwardProcessTypeModel> processType =
      <ProcessInwardProcessTypeModel>[].obs;
  List<ProcessInwardProductNameModel> productName =
      <ProcessInwardProductNameModel>[].obs;

  var itemList = <dynamic>[];

  // Map<String, dynamic> request = <String, dynamic>{};
  var filterData;
  int? dcRecNo;

  @override
  void onInit() async {
    change(firmName = await firmNameInfo());
    change(processorName = await ledgerInfo());
    change(accountDropDown = await accountInfo());
    super.onInit();
  }

  Future<List<ProcessInwardProcessTypeModel>> dcNoByProcessTypesDetails(
      var dcRecNo) async {
    change(null, status: RxStatus.loading());
    List<ProcessInwardProcessTypeModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/process_order_list?dc_rec_no=$dcRecNo')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json["data"];
        result = (data as List)
            .map((i) => ProcessInwardProcessTypeModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(processType = result);
    return result;
  }

  Future<List<ProcessInwardProductNameModel>> productNameDetails(
      var dcRecNo, var processType) async {
    change(null, status: RxStatus.loading());
    List<ProcessInwardProductNameModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/Process_Product_details_using_dc_ptotype?dc_rec_no=$dcRecNo&process_type=$processType')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json["data"];
        result = (data as List)
            .map((i) => ProcessInwardProductNameModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(productName = result);
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
    return result;
  }

  /// Selected Processor Id By Get DcNo
  Future<List<ProcessorIdByDcNoModel>> processorIdByDcNo(
      var processorId) async {
    change(null, status: RxStatus.loading());
    List<ProcessorIdByDcNoModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/dc_list_using_processor_id?processor_id=$processorId')
        .then((response) {
      var json = jsonDecode(response.data);
      change(null, status: RxStatus.success());
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => ProcessorIdByDcNoModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(dcNo = result);
    return result;
  }

  /// Selected DcNo Id By Get Item Details
  Future<List<ProcessorDcNoIdByDetailsModel>> dcNoIdByDetails(
      var dcRecNo) async {
    List<ProcessorDcNoIdByDetailsModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/process_delivery_details_using_dc_no?dc_rec_no=$dcRecNo')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => ProcessorDcNoIdByDetailsModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
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

  Future<List<dynamic>> productInwardFromProcess(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/process_inward?$query')
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
            HttpRequestType.post, 'api/process_inward_add',
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

  void edit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/process_inward_update',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
        Get.back();
      }
    });
  }

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/process_inward_delete?id=$id&password=$password')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  Future<List<PayDetailsHistoryModel>> payDetails(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<PayDetailsHistoryModel> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/processor_payment_history?$query')
        .then((response) {
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
    change(null, status: RxStatus.success());
    return list;
  }

  /// pdf
  Future<String?> processInwardReport({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/required?$query')
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

class ProcessorIdByDcNoModel {
  int? id;
  int? dcNo;

  String? firmName;
  String? firmShortCode;
  String? eDate;

  ProcessorIdByDcNoModel({
    this.id,
    this.dcNo,
    this.firmName,
    this.firmShortCode,
    this.eDate,
  });

  ProcessorIdByDcNoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dcNo = json['dc_no'];
    firmName = json['firm_name'];
    firmShortCode = json['firm_short_code'];
    eDate = json['e_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dc_no'] = dcNo;
    data['firm_name'] = firmName;
    data['firm_short_code'] = firmShortCode;
    data['e_date'] = eDate;
    return data;
  }

  @override
  String toString() {
    return "$dcNo";
  }
}
