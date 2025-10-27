import 'dart:convert';

import 'package:abtxt/model/JariTwistingModel.dart';
import 'package:abtxt/model/MachineDetailsModel.dart';
import 'package:abtxt/model/jari_twinsting_yarn_inward_V2/JariTwistingInwardV2Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../utils/app_utils.dart';
import '../jari_twisting_yarn_inward/jari_twisting_yarn_inward_controller.dart';

class JariTwistingYarnInwardControllerV2 extends GetxController
    with StateMixin {
  List<LedgerModel> twisterName = <LedgerModel>[].obs;
  List<FirmModel> firmDetails = <FirmModel>[].obs;
  List<LedgerModel> wagesAccountList = <LedgerModel>[].obs;
  List<NewColorModel> colorDetails = <NewColorModel>[].obs;
  List<MachineDetailsModel> machineDetails = <MachineDetailsModel>[].obs;
  List<JariTwistingModel> yarnDetails = <JariTwistingModel>[].obs;
  List<LedgerModel> operatorDetails = <LedgerModel>[].obs;

  final RxString wagesType = RxString("");
  final RxDouble wages = RxDouble(0.0);

  String yarnName = "";

  Map<String, dynamic> request = <String, dynamic>{};
  var filterData;

  @override
  void onInit() async {
    operatorInfo();
    yarnInfo();
    accountInfo();
    machineInfo();
    colorInfo();
    change(null, status: RxStatus.success());
    change(firmDetails = await firmInfo());
    super.onInit();
  }

  // list API
  Future<List<JariTwistingInwardV2Model>> jariTwistingYarnInward(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<JariTwistingInwardV2Model> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/twisting_yarn_inward_list?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        result = (data as List)
            .map((i) => JariTwistingInwardV2Model.fromJson(i))
            .toList();
      } else {
        var error = jsonDecode(response.data);
        debugPrint(error);
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/twisting_yarn_inward_post',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: ${error['message']}');
      }
    });
  }

  void edit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/twisting_yarn_inward_update',
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
            'api/twisting_yarn_inward_delete?id=$id&password=$password')
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

  Future<List<LedgerModel>> operatorInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=operator')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    change(operatorDetails = result);
    return result;
  }

//   Firm Name
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
        debugPrint('error: ${json['message']}');
      }
    });
    change(wagesAccountList = result);
    return result;
  }

  Future<List<JariTwistingConsumedYarnsModel>> yarnIdByConsumedYarn(
      var yarnId) async {
    List<JariTwistingConsumedYarnsModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/jari_twisting_consumed_yarns?yarn_id=$yarnId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => JariTwistingConsumedYarnsModel.fromJson(i))
            .toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<MachineDetailsModel>> machineInfo() async {
    change(null, status: RxStatus.loading());
    List<MachineDetailsModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/machine_payment_list')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        result =
            (data as List).map((i) => MachineDetailsModel.fromJson(i)).toList();
      } else {
        var error = jsonDecode(response.data);
        debugPrint(error);
      }
    });
    change(machineDetails = result);
    return result;
  }

  Future<List<NewColorModel>> colorInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => NewColorModel.fromJson(i)).toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    change(colorDetails = result);
    return result;
  }

  Future<List<JariTwistingModel>> yarnInfo() async {
    List<JariTwistingModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/get_yarns_from_jaritwisting')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => JariTwistingModel.fromJson(i)).toList();
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    change(yarnDetails = result);
    return result;
  }

  Future<String?> addNewOperator(var request) async {
    change(null, status: RxStatus.loading());
    String? result;
    await HttpRepository.apiRequest(HttpRequestType.upload, 'api/add_ledger',
            formDatas: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        Get.back();
        result = "success";
        AppUtils.showSuccessToast(message: "Added successfully");
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: $error');
      }
    });
    return result;
  }
}
