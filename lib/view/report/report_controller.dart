import 'dart:convert';

import 'package:abtxt/model/report_models/FinishedWarpsModel.dart';
import 'package:abtxt/model/report_models/WeavingWarpReportModel.dart';
import 'package:get/get.dart';

import '../../http/api_repository.dart';
import '../../model/FirmModel.dart';
import '../../model/LedgerModel.dart';
import '../../model/LoomModel.dart';
import '../../model/YarnModel.dart';
import '../../utils/app_utils.dart';

class ReportController extends GetxController with StateMixin {
  List<LedgerModel> weaverList = <LedgerModel>[].obs;
  List<LedgerModel> supplierList = <LedgerModel>[].obs;
  List<FirmModel> firmName = <FirmModel>[].obs;
  List<YarnModel> yarnDropdown = <YarnModel>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};
  final loomList = <LoomModel>[].obs;

  @override
  void onInit() async {
    change(firmName = await firmNameInfo());
    change(supplierList = await supplier());
    change(yarnDropdown = await yarnInfo());

    super.onInit();
  }

//Yarn Name
  Future<List<YarnModel>> yarnInfo() async {
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
    return result;
  }

// Supplier Name
  Future<List<LedgerModel>> supplier() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=supplier')
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

// Firm Name
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

  Future<String?> yarnPurchaseReport({var request = const {}}) async {
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/yarn__reports?$query')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  Future<void> fetchLoomInfo(var id) async {
    dynamic loomInfoResult = await loomInfo(id);
    loomList.assignAll(loomInfoResult);
  }

  Future<List<LedgerModel>> weaver() async {
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

  Future<List<FinishedWarpsModel>> finishedWarps() async {
    List<FinishedWarpsModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/finised_warp_list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => FinishedWarpsModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<LoomModel>> loomInfo(var id) async {
    List<LoomModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/weavingloom?weaver_id=$id')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        if (data.isEmpty) {
          AppUtils.showErrorToast(
              message: ' There is no Loom \n Create New Loom for Weaver');
        }
        result = (data as List).map((i) => LoomModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<WeavingWarpReportModel>> weavingWarpReports() async {
    var weaverId = request['weaver_id'];
    var loomId = request['loom_id'];
    List<WeavingWarpReportModel> list = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/weavings_warp_reports?weaver_id=$weaverId&loom=$loomId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        list = (data as List)
            .map((i) => WeavingWarpReportModel.fromJson(i))
            .toList();
      } else {
        // _dialogBuilder(json["message"]);
      }
    });
    return list;
  }
}
