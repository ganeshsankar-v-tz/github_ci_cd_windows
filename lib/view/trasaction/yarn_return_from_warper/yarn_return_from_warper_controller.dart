import 'dart:convert';

import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/WarperBalanceDetailsModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/YarnModel.dart';
import '../../../utils/app_utils.dart';

class YarnReturnFromWarperController extends GetxController with StateMixin {
  List<LedgerModel> Warper = <LedgerModel>[].obs;

  // AddItem
  List<YarnModel> yarnName = <YarnModel>[].obs;
  List<NewColorModel> colorName = <NewColorModel>[].obs;
  List<WarperBalanceDetailsModel> deliveredDetails =
      <WarperBalanceDetailsModel>[].obs;
  List<FirmModel> firmDropdown = <FirmModel>[].obs;

  int? warperId;
  var filterData;
  Map<String, dynamic> request = <String, dynamic>{};
  var itemList = <dynamic>[];

  @override
  void onInit() async {
    warperInfo();
    change(firmDropdown = await firmInfo());

    super.onInit();
  }

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
    change(Warper = result);
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
    return result;
  }

/*  // AddItem
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
  }*/

  Future<List<dynamic>> yarnReturnfromWarper({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/return_warper_list?$query')
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

  /// pdf
  Future<String?> yarnReturnFromWarperPdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warpper_retrun_yarn?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/return_warper_add',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  void edit(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/return_warper_update',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/warpper_yarn_return_delete?id=$id&password=$password')
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

  ///  Warper Id, Yarn Id And Color Id By Yarn Balance
  Future<List<WarperBalanceDetailsModel>> warperYarnStockBalance(
      var warperId) async {
    change(null, status: RxStatus.loading());
    List<WarperBalanceDetailsModel> result = [];
    List<YarnModel> yarnResult = [];
    List<NewColorModel> colorResult = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/yarn_Stock_from_warper?warper_id=$warperId')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => WarperBalanceDetailsModel.fromJson(i))
            .toList();

        Set<int> yarnIds = {};
        Set<int> colorIds = {};
        for (var e in data) {
          var yarnModel = YarnModel(id: e["yarn_id"], name: e["yarn_name"]);

          var colorModel =
              NewColorModel(id: e["color_id"], name: e["color_name"]);

          if (!yarnIds.contains(yarnModel.id)) {
            yarnResult.add(yarnModel);
            yarnIds.add(yarnModel.id ?? 0);
          }

          if (!colorIds.contains(colorModel.id)) {
            colorResult.add(colorModel);
            colorIds.add(colorModel.id ?? 0);
          }
        }
      } else {
        print('error: ${json['message']}');
      }
    });
    change(deliveredDetails = result);
    change(yarnName = yarnResult);
    change(colorName = colorResult);
    return result;
  }
}
