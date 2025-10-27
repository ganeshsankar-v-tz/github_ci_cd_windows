import 'dart:convert';

import 'package:abtxt/model/JariTwistingModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../utils/app_utils.dart';

class JariTwistingYarnInwardController extends GetxController with StateMixin {
  List<LedgerModel> warperList = <LedgerModel>[].obs;
  List<FirmModel> Firm = <FirmModel>[].obs;
  List<LedgerModel> wagesAccountList = <LedgerModel>[].obs;
  List<JariTwistingModel> Yarn = <JariTwistingModel>[].obs;
  List<NewColorModel> Color = <NewColorModel>[].obs;

  var yarnName = '';
  var warperName = "";

  Map<String, dynamic> request = <String, dynamic>{};
  var filterData;

  @override
  void onInit() async {
    warperInfo();
    WagesAccountInfo();
    YarnInfo();
    ColorInfo();
    change(Firm = await firmInfo());

    super.onInit();
  }

//   Warper Name

  Future<List<LedgerModel>> warperInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=warper')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(warperList = result);
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
        print('error: ${json['message']}');
      }
    });
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
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<LedgerModel>> WagesAccountInfo() async {
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
    change(wagesAccountList = result);
    return result;
  }

  // Yarn
  Future<List<JariTwistingModel>> YarnInfo() async {
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
        print('error: ${json['message']}');
      }
    });
    change(Yarn = result);
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
    change(Color = result);
    return result;
  }

  /// pdf
  Future<String?> jariTwistingYarnInwardPdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warpper_jari_inward_print?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  Future<List<dynamic>> jariTwistingYarnInward({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/jari_twisting_yarn_inward_list?$query')
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
            HttpRequestType.post, 'api/jari_twisting_yarn_inward_add',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
      }
    });
  }

  void edit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/jari_twisting_yarn_inward_update',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('$error');
      }
    });
  }

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/jari_twisting_yarn_inward_delete?id=$id&password=$password')
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
}

class JariTwistingConsumedYarnsModel {
  late num usage;
  int? yarnId;
  int? colorId;
  String? colorName;
  String? yarnName;

  JariTwistingConsumedYarnsModel({
    required this.usage,
    this.yarnId,
    this.colorId,
    this.colorName,
    this.yarnName,
  });

  JariTwistingConsumedYarnsModel.fromJson(Map<String, dynamic> json) {
    usage = json['usage'];
    yarnId = json['yarn_id'];
    colorId = json['color_id'];
    colorName = json['color_name'];
    yarnName = json['yarn_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['usage'] = usage;
    data['yarn_id'] = yarnId;
    data['color_id'] = colorId;
    data['color_name'] = colorName;
    data['yarn_name'] = yarnName;
    return data;
  }
}
