import 'dart:convert';

import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/banking_report_model/SelectedBankingReportModel.dart';
import 'package:get/get.dart';

import '../../../../http/api_repository.dart';
import '../../../../model/banking_report_model/BankingReportModel.dart';

class BankingReportController extends GetxController with StateMixin {
  List<FirmModel> firmDropdown = <FirmModel>[].obs;
  var filterData;
  var completedFilterData;

  /// this is used for payment to details showing purpose
  RxBool isPaymentTo = false.obs;

  // this is used for ConformationList screen API refresh
  RxBool apiCall = RxBool(false);

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    firmInfo();
    super.onInit();
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
    change(firmDropdown = result);
    return result;
  }

// Retrieve payment details in the payment module.
  Future<List<BankingReportModel>> paymentReport(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<BankingReportModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/payment_report?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => BankingReportModel.fromJson(i))
            .toList();
      } else {
        var error = jsonDecode(response.data);
      }
    });
    return result;
  }

// Submit the selected slip and account details for confirmation.
  Future<String?> upComingPost(var request) async {
    change(null, status: RxStatus.loading());
    String? result;
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/Payment_Banking_add',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        result = "success";
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
      }
    });
    return result;
  }

// Fetch submitted details for secondary confirmation.
  Future<List<dynamic>> userConformationListApi() async {
    change(null, status: RxStatus.loading());
    List<dynamic> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/secondary_confirmation_list')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = data;
      } else {
        var error = jsonDecode(response.data);
      }
    });
    return result;
  }

// Confirm the details for admin approval.
  Future<String?> userConformationRequest(var request) async {
    change(null, status: RxStatus.loading());
    String? result;
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/secondary_confirmation',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        result = "success";
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
      }
    });
    return result;
  }

  Future<List<dynamic>> poList({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/po_list?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        list = json['data'];
      } else {
        var error = jsonDecode(response.data);
      }
    });
    return list;
  }

  Future<String?> poConformationRequest(var request) async {
    change(null, status: RxStatus.loading());
    String? result;
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/po_confirmation',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        result = "success";
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
      }
    });
    return result;
  }

  Future<String?> poPdfGeneration(int id) async {
    change(null, status: RxStatus.loading());
    var url;
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/gst_pdf/$id')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

// Retrieve secondary details for admin confirmation.
  Future<List<dynamic>> approvalDetails() async {
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/baking_report_approved_status')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        list = json['data'];
      } else {
        var error = jsonDecode(response.data);
      }
    });
    return list;
  }

// Admin approval for submitted details to proceed with the transaction.
  Future<String?> adminApproveRequest(var request) async {
    change(null, status: RxStatus.loading());
    String? result;
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/baking_report_approved',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        result = "success";
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
      }
    });
    return result;
  }

  // Admin decline for submitted details to alter.
  Future<String?> adminDeclineRequest(var request) async {
    change(null, status: RxStatus.loading());
    String? result;
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/admin_decline_approved',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        result = "success";
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
      }
    });
    return result;
  }

// Fetch in-progress details.
  Future<List<dynamic>> inProcessGetList({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/payment_bank_report_Inprogess?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        list = json['data'];
      } else {
        var error = jsonDecode(response.data);
      }
    });
    return list;
  }

// Mark in-progress details as completed.
  Future<String?> transactionIdToComplete(var request) async {
    change(null, status: RxStatus.loading());
    String? result;
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/transaction_no_update',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        result = "success";
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
      }
    });
    return result;
  }

// Retrieve the completed list details.
  Future<List<dynamic>> completedGetList({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/Payment_Banking_Completed_list?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        list = json['data'];
      } else {
        var error = jsonDecode(response.data);
      }
    });
    return list;
  }

// This API is used to fetch child details.
// Statuses: Confirmation, Admin Confirmation, In Progress, Completed.
  Future<SelectedBankingReportModel?> selectedRowItemDetails(int id) async {
    change(null, status: RxStatus.loading());
    SelectedBankingReportModel? result;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/slip_child_details?id=$id')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = SelectedBankingReportModel.fromJson(data);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

// Retrieve reports for completed and in-progress details.
  Future<String?> reportApiCall(int id, String format) async {
    change(null, status: RxStatus.loading());
    var url;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/payment_report_generation?id=$id&format=$format')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

// Remove the selected row from the slip via API in the confirmation state.
  Future<String?> selectedRowRemove(var request) async {
    change(null, status: RxStatus.loading());
    String? result;
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/selected_row_removed',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        result = "success";
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
      }
    });
    return result;
  }

// Add new amount details to an existing slip in the confirmation state.
  Future<String?> newDetailsAdd(int id, var request) async {
    change(null, status: RxStatus.loading());
    String? result;
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/update_banking_list/$id',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        result = "success";
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
      }
    });
    return result;
  }
}
