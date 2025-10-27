import 'dart:convert';

import 'package:abtxt/model/TwisterWarpingLotModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/AccountTypeModel.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/TwisterWarpingModel.dart';
import '../../../model/WarpDesignSheetModel.dart';
import '../../../model/YarnModel.dart';
import '../../../utils/app_utils.dart';

class TwistingOrWarpingController extends GetxController with StateMixin {
  List<LedgerModel> WarperName = <LedgerModel>[].obs;
  List<FirmModel> firmDropdown = <FirmModel>[].obs;
  List<AccountTypeModel> Account = <AccountTypeModel>[].obs;
  List<YarnModel> Yarn = <YarnModel>[].obs;
  List<NewColorModel> Color = <NewColorModel>[].obs;
  List<WarpDesignSheetModel> WarpdesignSheet = <WarpDesignSheetModel>[].obs;
  List<TwisterWarpingLotModel> lot = <TwisterWarpingLotModel>[].obs;
  @override
  void onInit() async {
    change(firmDropdown = await firmInfo());
    change(Account = await AccountInfo());
    change(WarperName = await warperNameInfo());
    change(WarpdesignSheet = await warpDesignInfo());
    change(Color = await ColorInfo());
    change(Yarn = await YarnInfo());
    change(lot = await lotDisplay());
    super.onInit();
  }

  // Lot
  Future<List<TwisterWarpingLotModel>> lotDisplay() async {
    List<TwisterWarpingLotModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/lot_list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        print(data);
        result = (data as List)
            .map((i) => TwisterWarpingLotModel.fromJson(i))
            .toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  // Warp Design Sheet
  Future<List<WarpDesignSheetModel>> warpDesignInfo() async {
    List<WarpDesignSheetModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/warpdesign')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        print(data);
        result = (data as List)
            .map((i) => WarpDesignSheetModel.fromJson(i))
            .toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  // ColorName
  Future<List<NewColorModel>> ColorInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        print(data);
        result = (data as List).map((i) => NewColorModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  // YarnName
  Future<List<YarnModel>> YarnInfo() async {
    List<YarnModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/yarn')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        print(data);
        result = (data as List).map((i) => YarnModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  // Account Type
  Future<List<AccountTypeModel>> AccountInfo() async {
    List<AccountTypeModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/account_type')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        print(data);
        result =
            (data as List).map((i) => AccountTypeModel.fromJson(i)).toList();

        print(result);
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
    return result;
  }

  // warper Name
  Future<List<LedgerModel>> warperNameInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/ledger')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        print(data);
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> twister({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/twister_list_pagination?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list =
            (data as List).map((i) => TwisterWarpingModel.fromJson(i)).toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <TwisterWarpingModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void addTwister(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/add_twister',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('add_twister: $json');
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('testing: ${error}');
      }
    });
  }

  void updateTwister(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/update_twister',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('addTwister: $json');
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  Future<dynamic> deleteTwister(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/delete_twister/$id')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void addLot(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/lot_create',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('add_twisterLot: $json');
        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('testing: ${error}');
      }
    });
  }
}
