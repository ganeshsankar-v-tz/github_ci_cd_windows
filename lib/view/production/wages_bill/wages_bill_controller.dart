import 'dart:convert';

import 'package:abtxt/model/AccountModel.dart';
import 'package:abtxt/model/weaving_models/WeaverrInwardGoodsDetailsModel.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/weaving_models/WagesBillChallanByDetailsModel.dart';
import '../../../model/weaving_models/WagesBillListModel.dart';
import '../../../model/weaving_models/WeaverAdvanceDetailsModel.dart';
import '../../../utils/app_utils.dart';

class WagesbillController extends GetxController with StateMixin {
  List<LedgerModel> weaverList = <LedgerModel>[].obs;
  List<AccountModel> accountTypeList = <AccountModel>[].obs;
  List<LedgerModel> debitAccountTypeList = <LedgerModel>[].obs;
  List<WeaverAdvanceDetailsModel> advDetails =
      <WeaverAdvanceDetailsModel>[].obs;
  List<WeaverInwardGoodsDetailsModel> goodsDetails =
      <WeaverInwardGoodsDetailsModel>[].obs;

  Map<String, dynamic> REQUEST = <String, dynamic>{};
  double balanceAmount = 0;
  @override
  void onInit() async {
    change(weaverList = await ledgerInfo());
    change(accountTypeList = await paymentAccountInfo());
    change(debitAccountTypeList = await debitAccountInfo());
    super.onInit();
  }

  /// Account Info For Payment Entry Type
  Future<List<AccountModel>> paymentAccountInfo() async {
    List<AccountModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/account_list?ac_type_1=Cash-in-hand')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => AccountModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  /// Account Info For Debit Entry Type
  Future<List<LedgerModel>> debitAccountInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/append_role?')
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

  /// Inward Goods Details For Payment
  Future<List<WeaverInwardGoodsDetailsModel>> goodsInwardDetails(
      var weaverId) async {
    List<WeaverInwardGoodsDetailsModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/Goods_inward_details_using_weaver_id?weaver_id=$weaverId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => WeaverInwardGoodsDetailsModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(goodsDetails = result);
    return result;
  }

  /// Weaver Id By Advance Amount Details
  Future<List<WeaverAdvanceDetailsModel>> advAmountDetails(var weaverId) async {
    List<WeaverAdvanceDetailsModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/get_append_ledger_details_using_weaver_id?weaver_id=$weaverId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => WeaverAdvanceDetailsModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(advDetails = result);
    return result;
  }

  /// Challan No By Update Details
  Future<WagesBillChallanByDetailsModel> challanNoByDetails(
      var challanNo, var acNo) async {
    dynamic result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/wages_bill_datas_using_challan_no?challan_no=$challanNo&rec_no=$acNo')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = WagesBillChallanByDetailsModel.fromJson(data);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  /// List Screen Details With Filter
  Future<List<WagesBillListModel>> wagesBill({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<WagesBillListModel> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/wages_list?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        list =
            (data as List).map((i) => WagesBillListModel.fromJson(i)).toList();
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(null, status: RxStatus.success());
    return list;
  }

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/wages_bill_add',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        change(null, status: RxStatus.success());
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        change(null, status: RxStatus.success());
        print('error: ${error}');
      }
    });
  }
}
