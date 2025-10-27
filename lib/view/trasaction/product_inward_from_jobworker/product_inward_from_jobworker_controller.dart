import 'dart:convert';

import 'package:abtxt/model/JobWorkerDcNoIdByDetails.dart';
import 'package:abtxt/model/job_work_inward_models/JobWorkInwardOrderedWork.dart';
import 'package:abtxt/model/job_work_inward_models/JobWorkInwardProductDetailsModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/payment_models/PayDetailsHistoryModel.dart';
import '../../../utils/app_utils.dart';

class ProductInwardFromJobWorkerController extends GetxController
    with StateMixin {
  List<FirmModel> firmNameList = <FirmModel>[].obs;
  List<LedgerModel> jobWorkerName = <LedgerModel>[].obs;
  List<LedgerModel> accountDropDown = <LedgerModel>[].obs;
  List<JobWorkerIdByDcNo> dcNo = <JobWorkerIdByDcNo>[].obs;
  List<JobWorkInwardOrderedWork> orderedWork = <JobWorkInwardOrderedWork>[].obs;
  List<JobWorkInwardProductDetailsModel> productNameDetails =
      <JobWorkInwardProductDetailsModel>[].obs;
  var itemList = <dynamic>[];
  var filterData;

  int? dcRecNo;

  @override
  void onInit() async {
    change(firmNameList = await firmNameInfo());
    change(jobWorkerName = await ledgerInfo());
    change(accountDropDown = await accountInfo());
    super.onInit();
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
            HttpRequestType.get, 'api/rollbased?ledger_role=job_worker')
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

  /// JobWorker Id By Dc No Details
  Future<List<JobWorkerIdByDcNo>> dcNoInfo(var jobWorkerId) async {
    change(null, status: RxStatus.loading());
    List<JobWorkerIdByDcNo> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/dc_list_using_job_workerid?job_worker_id=$jobWorkerId')
        .then((response) {
      var json = jsonDecode(response.data);
      change(null, status: RxStatus.success());
      if (response.success) {
        var data = json["data"];
        result =
            (data as List).map((i) => JobWorkerIdByDcNo.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(dcNo = result);
    return result;
  }

  /// Display The Selected DcNo Details
  Future<List<JobWorkerDcNoIdByDetails>> dcNoIdByDetails(var dcRecNo) async {
    List<JobWorkerDcNoIdByDetails> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/dc_details_using_dc_no?dc_rec_no=$dcRecNo')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json["data"];
        result = (data as List)
            .map((i) => JobWorkerDcNoIdByDetails.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  /// Get the ordered word details using dc rec no
  Future<List<JobWorkInwardOrderedWork>> dcNoBuOrderedWorksDetails(
      var dcRecNo) async {
    change(null, status: RxStatus.loading());
    List<JobWorkInwardOrderedWork> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/orderlist_using_dc_rec_no?dc_rec_no=$dcRecNo')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json["data"];
        result = (data as List)
            .map((i) => JobWorkInwardOrderedWork.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(orderedWork = result);
    return result;
  }

  /// Get the product details using dc rec no and ordered work id
  Future<List<JobWorkInwardProductDetailsModel>> productDetails(
      var dcRecNo, orderId) async {
    change(null, status: RxStatus.loading());
    List<JobWorkInwardProductDetailsModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/Product_details_using_dc_orderid?dc_rec_no=$dcRecNo&order_id=$orderId')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json["data"];
        result = (data as List)
            .map((i) => JobWorkInwardProductDetailsModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(productNameDetails = result);
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

  Future<List<dynamic>> productInwardFromJobWorker(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/inward_job_work?$query')
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
            HttpRequestType.post, 'api/inward_job_work_add',
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
            HttpRequestType.post, 'api/inward_job_work_update',
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
            'api/jobwork_inward_delete?id=$id&password=$password')
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
            HttpRequestType.get, 'api/job_worker_payment_history?$query')
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
  Future<String?> jobWorkInwardReport({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/job_work_inward_print?$query')
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

class JobWorkerIdByDcNo {
  int? id;
  int? dcNo;
  String? firmName;
  String? eDate;
  String? firmShortCode;
  int? deliveryQty;

  JobWorkerIdByDcNo({
    this.id,
    this.dcNo,
    this.firmName,
    this.eDate,
    this.firmShortCode,
    this.deliveryQty,
  });

  JobWorkerIdByDcNo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dcNo = json['dc_no'];
    firmName = json['firm_name'];
    eDate = json['e_date'];
    firmShortCode = json['firm_short_code'];
    deliveryQty = json['delivery_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dc_no'] = dcNo;
    data['firm_name'] = firmName;
    data['e_date'] = eDate;
    data['firm_short_code'] = firmShortCode;
    data['delivery_qty'] = deliveryQty;
    return data;
  }

  @override
  String toString() {
    return "$dcNo";
  }
}
