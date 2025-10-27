import 'dart:convert';

import 'package:abtxt/model/AccountModel.dart';
import 'package:abtxt/model/LoomGroup.dart';
import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/WarpExcessModel.dart';
import 'package:abtxt/model/WarpType.dart';
import 'package:abtxt/model/WeavingEntryTypeModel.dart';
import 'package:abtxt/model/YarnModel.dart';
import 'package:abtxt/model/weaving_models/WeaverByLoomStatusModel.dart';
import 'package:abtxt/model/weaving_models/WeaverLoomDetailsModel.dart';
import 'package:abtxt/model/weaving_models/WeavingFinishListModel.dart';
import 'package:abtxt/model/weaving_models/WeavingOtherWarpBalanceModel.dart';
import 'package:abtxt/model/weaving_models/WeavingProductListModel.dart';
import 'package:abtxt/model/weaving_models/WeavingRunningProductModel.dart';
import 'package:abtxt/model/weaving_models/WeavingWarpDeliveryModel.dart';
import 'package:abtxt/model/weaving_models/weft_balance/OverAllWeftBalanceModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/LoomModel.dart';
import '../../../model/WeavingAccount.dart';
import '../../../model/WeavingListModel.dart';
import '../../../model/YarnStockBalanceModel.dart';
import '../../../model/payment_models/PayDetailsHistoryModel.dart';
import '../../../model/warp_id_details/NewWarpIdDetailsModel.dart';
import '../../../model/weaving_models/WeaverTransferYarnModel.dart';
import '../../../model/weaving_models/WeavingProductApprovalModel.dart';
import '../../../model/weaving_models/weft_balance/OtherWarpBalanceModel.dart';
import '../../../model/weaving_models/weft_balance/PrivateWeftRequirementListModel.dart';
import '../../../utils/app_utils.dart';
import '../../dashboard2/dashboard2_controller.dart';

class WeavingController extends GetxController with StateMixin {
  List<WeaverLoomDetailsModel> weaverList = <WeaverLoomDetailsModel>[].obs;
  RxList<WeavingAccount> weavingAccountList = RxList<WeavingAccount>([]);

  // List<LoomModel> loomList = <LoomModel>[].obs;
  List<LoomGroup> loomList = <LoomGroup>[].obs;
  List<FirmModel> firm_dropdown = <FirmModel>[].obs;
  List<WeavingProductListModel> productDropdown =
      <WeavingProductListModel>[].obs;
  List<NewColorModel> colorDropdown = <NewColorModel>[].obs;
  List<YarnModel> yarnDropdown = <YarnModel>[].obs;
  List<WarpType> warpTypeList = <WarpType>[].obs;
  List<WarpExcessModel> warpExcess = <WarpExcessModel>[].obs;
  List<WeaverTransferYarnModel> transferYarn = <WeaverTransferYarnModel>[].obs;
  List<WeavingOtherWarpBalanceModel> transferWarp =
      <WeavingOtherWarpBalanceModel>[].obs;

  /// Warp Deliver Entry Type -> Warp Id By Details
  List<WeavingWarpDeliveryModel> warpDetails = <WeavingWarpDeliveryModel>[].obs;

  /// Account Info By Entry Type
  List<AccountModel> paymentAccount = <AccountModel>[].obs;
  List<AccountModel> debitAccount = <AccountModel>[].obs;
  List<LedgerModel> newRecordAccount = <LedgerModel>[].obs;

  /// weaver By Loom Details For Transfer Entry Types
  List<WeaverByLoomStatusModel> loomStatus = <WeaverByLoomStatusModel>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};
  List<dynamic> itemList = <dynamic>[];

  /// weaver over all yarn stock details get by API
  List<WeftBalance> weaverYarnStockApiValue = <WeftBalance>[].obs;

  /// weaver over all other warp stock details get by API
  List<OtherWarpBalanceModel> weaverOtherWarpStockApiValue =
      <OtherWarpBalanceModel>[].obs;

  num? productWages;
  num? productMeter;
  int? productId;
  int? weaverId;
  num? debitAmount;
  num? creditAmount;
  num? bmIn;
  num? bmOut;
  num? bbnIn;
  num? bbnOut;
  num? shtIn;
  num? shtOut;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    change(weaverList = await weaver());
    firmInfo();
    productInfo();
    colorInfo();
    yarnInfo();
    newRecordAccountInfo();
    //change(firm_dropdown = await firmInfo());
    // change(productDropdown = await productInfo());
    // change(colorDropdown = await colorInfo());
    // change(yarnDropdown = await yarnInfo());

    /// Account Info By Entry Type
    // change(paymentAccount = await paymentAccountInfo());
    // change(debitAccount = await debitAccountInfo());
    // change(newRecordAccount = await newRecordAccountInfo());
    super.onInit();
  }

  Future<NewWarpIdDetailsModel?> newWarpIdForWarpDropout() async {
    NewWarpIdDetailsModel? result;
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_dropout_newwarp_id')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = NewWarpIdDetailsModel.fromJson(data);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  /// New Record Screen Weaver And Loom By Running Product Id
  Future<WeavingRunningProductModel?> getRunningProductId(
      var weaverId, var loomNo) async {
    change(null, status: RxStatus.loading());
    WeavingRunningProductModel? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/get_product_id_using_loom_weaver_id?weaver_id=$weaverId&loom_no=$loomNo')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = WeavingRunningProductModel.fromJson(data);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  /// Add Item Weaver Id By Loom Status
  Future<List<WeaverByLoomStatusModel>> transferLoomStatus(
      var weaverId, var loomNo, var weavingAcId) async {
    loomStatus.clear();
    List<WeaverByLoomStatusModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/transfer_looms_status?weaver_id=$weaverId&loom_no=$loomNo&weaving_ac_id=$weavingAcId')
        .then((response) async {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => WeaverByLoomStatusModel.fromJson(i))
            .toList();
        result = result
          ..sort((a, b) => "${a.currentStatus}"
              .length
              .compareTo("${b.currentStatus}".length));
      } else {
        print('error: ${json['message']}');
      }
    });
    change(loomStatus = result);
    return result;
  }

  /// Weaver Payment Details History
  Future<List<PayDetailsHistoryModel>> paymentHistory(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<PayDetailsHistoryModel> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/weaver_payment_history?$query')
        .then((response) {
      change(null, status: RxStatus.success());
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
    return list;
  }

  /// Weft Balance used for Transfer Yarn Screen
  Future<List<WeaverTransferYarnModel>> transferYarnBalance(
      var weavingId) async {
    transferYarn.clear();
    change(null, status: RxStatus.loading());
    List<WeaverTransferYarnModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/weaver_yarn_stock_qty?weaving_ac_id=$weavingId')
        .then((response) async {
      var json = jsonDecode(response.data);
      change(null, status: RxStatus.success());
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => WeaverTransferYarnModel.fromJson(i))
            .toList();

        var list = result;
        var localTransferYarn = itemList.where((e) => e['sync'] == 0).toList();
        for (var item in localTransferYarn) {
          if (item['entry_type'] == 'Trsfr - Yarn') {
            list.removeWhere((e) => e.yarnId == item['yarn_id']);
          } else if (item["entry_type"] == "Yarn Wastage") {
            for (int i = 0; i < list.length; i++) {
              var d = list[i];
              if (d.yarnId == item['yarn_id']) {
                var bal = (double.tryParse("${list[i].weftBalance}") ?? 0) -
                    item['yarn_qty'];
                list[i].weftBalance = bal;
              }
            }
          }
        }
        transferYarn = list;
        change(transferYarn);
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
    return result;
  }

  /// Other Warp Balance -> Transfer Warp
  Future<List<WeavingOtherWarpBalanceModel>> otherWarpBalance(
      var weavingId) async {
    transferWarp.clear();
    change(null, status: RxStatus.loading());
    List<WeavingOtherWarpBalanceModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/transfer_other_warp_list_V2?weaving_ac_id=$weavingId')
        .then((response) async {
      var json = jsonDecode(response.data);
      change(null, status: RxStatus.success());
      if (response.success) {
        var data = json['data']["balance_warp"];
        result = (data as List)
            .map((i) => WeavingOtherWarpBalanceModel.fromJson(i))
            .toList();

        var list = result;

        var localTransferWarp = itemList.where((e) => e['sync'] == 0).toList();

        /// calculate the local added warp qty and meter values
        /// warp dropout and transfer warp details is removed
        /// warp excess qty and meter values add
        /// warp shortage qty and meter values less

        for (var item in localTransferWarp) {
          if (item['entry_type'] == 'Warp-Dropout' ||
              item["entry_type"] == "Trsfr - Warp") {
            list.removeWhere((e) => e.warpDesignId == item['warp_design_id']);
          } else if (item["entry_type"] == "Warp Excess") {
            for (int i = 0; i < list.length; i++) {
              var d = list[i];
              if (d.warpDesignId == item['warp_design_id']) {
                int balQty = (int.tryParse("${list[i].balanceQty}") ?? 0) +
                    (int.tryParse("${item['warp_qty']}") ?? 0);

                double balMeter =
                    (double.tryParse("${list[i].balanceMeter}") ?? 0) +
                        (double.tryParse("${item['meter']}") ?? 0);

                list[i].balanceQty = balQty;
                list[i].balanceMeter = balMeter;
              }
            }
          } else if (item["enter_type"] == "Warp Shortage") {
            for (int i = 0; i < list.length; i++) {
              var d = list[i];
              if (d.warpDesignId == item['warp_design_id']) {
                int balQty = (int.tryParse("${list[i].balanceQty}") ?? 0) -
                    (int.tryParse("${item['warp_qty']}") ?? 0);

                double balMeter =
                    (double.tryParse("${list[i].balanceMeter}") ?? 0) -
                        (double.tryParse("${item['meter']}") ?? 0);

                list[i].balanceQty = balQty;
                list[i].balanceMeter = balMeter;
              }
            }
          }
        }
        transferWarp = list;
        change(transferWarp);
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
    return result;
  }

  // color
  Future<List<NewColorModel>> colorInfo() async {
    change(null, status: RxStatus.loading());
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color/list')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => NewColorModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(colorDropdown = result);
    return result;
  }

  /// Add item entry type Api call
  Future<List<WeavingEntryTypeModel>> entryType(var weavingAcId) async {
    List<WeavingEntryTypeModel> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/Weaving_ac_entry_type?weaving_ac_id=$weavingAcId')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => WeavingEntryTypeModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> weavingByWeaverIdAndLoomNo(var weaverId, var loomNo) async {
    var result = {};
    List<WeavingAccount> list = [];
    weavingAccountList.clear();
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/weaving_by_weaverid_loomno?weaver_id=$weaverId&loom_no=$loomNo')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        list = (data as List).map((i) => WeavingAccount.fromJson(i)).toList();
        list = list
          ..sort((a, b) => '${a.currentStatus}'
              .length
              .compareTo('${b.currentStatus}'.length));

        weavingAccountList.addAll(list);
        result = {'status': true, 'data': list};
      } else {
        result = {'status': false, 'data': json["message"]};
      }
    });
    return result;
  }

  // yarn
  Future<List<YarnModel>> yarnInfo() async {
    change(null, status: RxStatus.loading());
    List<YarnModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/yarn_list?yarn_type=Other')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => YarnModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(yarnDropdown = result);
    return result;
  }

  /// Account Types
  var paymentAccounts = "ac_type_1=Bank OD A/c&ac_type_2=Cash-in-hand";
  var debitAccounts = "ac_type_1=Sundry Creditors";
  var newRecordAccounts =
      "ac_type_1=Sundry Creditors&ac_type_2=Direct Expenses";

  /// Account Info For Payment Entry Type
  Future<List<AccountModel>> paymentAccountInfo() async {
    change(null, status: RxStatus.loading());
    List<AccountModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/account_list?$paymentAccounts')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => AccountModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(paymentAccount = result);
    return result;
  }

  /// Account Info For Debit Entry Type
  Future<List<AccountModel>> debitAccountInfo() async {
    change(null, status: RxStatus.loading());
    List<AccountModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/account_list?$debitAccounts')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => AccountModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(debitAccount = result);
    return result;
  }

  /// Account Info For New Record Creation
  Future<List<LedgerModel>> newRecordAccountInfo() async {
    change(null, status: RxStatus.loading());
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/ledger_by?account_type=Direct Expenses')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(newRecordAccount = result);
    return result;
  }

  /// Weaver Product By Warp Details
  Future<void> warpInfo(var productId) async {
    warpTypeList.clear();
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
      HttpRequestType.get,
      'api/item_details?product_id=$productId',
      requestBodydata: request,
    ).then((response) async {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        warpTypeList = (data as List).map((i) => WarpType.fromJson(i)).toList();
        change(warpTypeList);
      } else {
        print('error: ${json['message']}');
      }
    });
  }

  /// Excess, Shortage, Dropout And Transfer Warp info
  Future<void> warpExcessInfo(var id) async {
    warpExcess.clear();
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_excess_et_v2?weaving_ac_id=$id',
            requestBodydata: request)
        .then((response) async {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        var list =
            (data as List).map((i) => WarpExcessModel.fromJson(i)).toList();
        var localWarpDelivery = itemList.where((e) => e['sync'] == 0).toList();

        /// calculate the local added warp qty and meter values
        /// warp dropout and transfer warp details is removed
        /// warp excess qty and meter values add
        /// warp shortage qty and meter values less

        for (var item in localWarpDelivery) {
          if (item['entry_type'] == 'Warp-Dropout' ||
              item["entry_type"] == "Trsfr - Warp") {
            list.removeWhere((e) => e.warpDesignId == item['warp_design_id']);
          } else if (item["entry_type"] == "Warp Excess") {
            for (int i = 0; i < list.length; i++) {
              var d = list[i];
              if (d.warpDesignId == item['warp_design_id']) {
                int balQty = (int.tryParse("${list[i].balanceQty}") ?? 0) +
                    (int.tryParse("${item['warp_qty']}") ?? 0);

                double balMeter =
                    (double.tryParse("${list[i].balanceMeter}") ?? 0) +
                        (double.tryParse("${item['meter']}") ?? 0);

                list[i].balanceQty = balQty;
                list[i].balanceMeter = balMeter;
              }
            }
          } else if (item["entry_type"] == "Warp Shortage") {
            for (int i = 0; i < list.length; i++) {
              var d = list[i];
              if (d.warpDesignId == item['warp_design_id']) {
                int balQty = (int.tryParse("${list[i].balanceQty}") ?? 0) -
                    (int.tryParse("${item['warp_qty']}") ?? 0);

                double balMeter =
                    (double.tryParse("${list[i].balanceMeter}") ?? 0) -
                        (double.tryParse("${item['meter']}") ?? 0);

                list[i].balanceQty = balQty;
                list[i].balanceMeter = balMeter;
              }
            }
          }
        }
        warpExcess = list;
        change(warpExcess);
      } else {
        print('error: ${json['message']}');
      }
    });
  }

  /// Product Name For New record Screen
  Future<List<WeavingProductListModel>> productInfo() async {
    change(null, status: RxStatus.loading());
    List<WeavingProductListModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/product_dropdown_list?used_for=Weaving')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => WeavingProductListModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(productDropdown = result);
    return result;
  }

  //Dropdown  Firm API call

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
    change(firm_dropdown = result);
    return result;
  }

  Future<List<WeaverLoomDetailsModel>> weaver() async {
    List<WeaverLoomDetailsModel> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/weaver_list_with_loom_count')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => WeaverLoomDetailsModel.fromJson(i))
            .toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<LoomGroup>> loomInfo(var id) async {
    List<LoomGroup> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/weavingloom?weaver_id=$id')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        if (data.isEmpty) {
          AppUtils.showErrorToast(
              message: ' There is no Loom \n Create New Loom for Weaver');
        }
        //var result = (data as List).map((i) => LoomModel.fromJson(i)).toList();
        final gMap = (data as List).groupBy((m) => m['sub_weaver_no']);
        result = gMap.entries.map((entry) {
          var looms = (entry.value).map((i) => LoomModel.fromJson(i)).toList();
          return LoomGroup(loomNo: entry.key, looms: looms);
        }).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(loomList = result);
    return result;
  }

  /// Warp Delivery Warp Details. Roller Inward Warps Only
  Future<List<WeavingWarpDeliveryModel>> warpDelivery(
      int warpDesignId, weaverId, subWeaverNo) async {
    warpDetails.clear();
    change(null, status: RxStatus.loading());
    List<WeavingWarpDeliveryModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/warp_delivery_list_using_warpdesignid_v2?warp_design_id=$warpDesignId&weaver_id=$weaverId&sub_weaver_no=$subWeaverNo')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        var list = (data as List)
            .map((i) => WeavingWarpDeliveryModel.fromJson(i))
            .toList();
        var localWarpDelivery = itemList
            .where((e) => e['sync'] == 0 && e['entry_type'] == 'Warp Delivery')
            .toList();
        for (var item in localWarpDelivery) {
          list.removeWhere((e) => e.newWarpId == item['warp_id']);
        }
        warpDetails = list;
        change(warpDetails);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> paginatedList({var page = "1"}) async {
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/weavings_list?page=$page')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list =
            (data as List).map((i) => WeavingListModel.fromJson(i)).toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        result = {"list": <WeavingListModel>[], "totalPage": 1};
      }
    });
    return result;
  }

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/weavings_add',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        change(null, status: RxStatus.success());
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        change(null, status: RxStatus.success());
        print('error: $error');
      }
    });
  }

  Future<dynamic> itemTableRowDelete(var rowId, var password) async {
    var result = {};
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/weaving_row_remove?row_id=$rowId&password=$password')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        result = {'data': json["data"]};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error["message"]}');
      }
    });
    return result;
  }

  void edit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/weavings_update',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        change(null, status: RxStatus.success());
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        change(null, status: RxStatus.success());
        print('$error');
      }
    });
  }

  Future<String?> delete(var id, var password) async {
    String? result;
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/weaving_delete?weaving_ac_id=$id&password=$password')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        result = "success";
        // Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error["message"]}');
      }
    });
    return result;
  }

  /// Weaving New Record Add
  void weavingNewRecAdd(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.upload, 'api/weaving_ac_v5_add',
            formDatas: request)
        .then((response) async {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        await Get.find<DashBoard2Controller>().weavingProduct();
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
      }
    });
  }

  Future<bool> weavingChecking(var weaverId, var loomId) async {
    change(null, status: RxStatus.loading());

    final response = await HttpRepository.apiRequest(
      HttpRequestType.get,
      'api/weaving_ac_v5_already_exists?weaver_id=$weaverId&loom_id=$loomId',
    );

    change(null, status: RxStatus.success());

    if (response.success) {
      final json = jsonDecode(response.data);
      final alreadyExists = json['data'];

      if (alreadyExists) {
        AppUtils.infoAlert(
            message: 'Already New Weaving account pending for Admin Approval, please wait for approval.',);
        return false;
      }

      return true;
    } else {
      AppUtils.showErrorToast(
          message: 'Failed to check weaving account existence.');
      return false;
    }
  }

  /// Weaving New Record Edit
  void weavingNewRecEdit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.upload, 'api/weaving_ac_update_v2',
            formDatas: request)
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

  Future<dynamic> finishWeaving(String password) async {
    var id = request['weaving_ac_id'];
    var result = {};
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post,
            'api/weaving_ac_finish_v2?weaving_ac_id=$id&password=$password')
        .then((response) async {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = {'status': true, 'data': data};
      } else {
        WeavingFinishListModel? list;
        var data = json['data'];
        list = WeavingFinishListModel.fromJson(data);
        result = {'status': false, 'data': list};
      }
    });

    return result;
  }

  Future<dynamic> addWeavingLogs(List itemList) async {
    var list = itemList.where((e) => e['sync'] == 0).toList();
    for (var item in list) {
      item
        ..remove("sync")
        ..remove("product_name")
        ..remove('warp_design_name')
        ..remove('design_no');
    }
    if (list.isEmpty) {
      return [];
    }
    //list.where((Map<String, dynamic> e) => e.remove(key)).toList();
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/weavings_addons_v2',
            requestBodydata: list)
        .then((response) {
      change(null, status: RxStatus.success());
    });
    return [];
  }

  Future<List<dynamic>> weavingLogs(var weavingId) async {
    List<dynamic> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/weaving_item_list?weaving_ac_id=$weavingId')
        .then((response) async {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        result = json['data'];
        //result = (data as List).map((i) => NewColorModel.fromJson(i)).toList();
      }
    });
    return result;
  }

  void goodsInwardWagesChange(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/weaving_credit_edit',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
      } else {
        var error = jsonDecode(response.data);
        AppUtils.showErrorToast(message: "$error");
      }
    });
  }

  /// Check The Yarn Balance In Stocks
  Future<YarnStockBalanceModel?> yarnStockBalance(
      var yarnId, var colorId, var stockIn) async {
    YarnStockBalanceModel? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/overall_balance_yarn_stock?yarn_id=$yarnId&color_id=$colorId&stock_in=$stockIn')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = YarnStockBalanceModel.fromJson(data);
      } else {
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  /// Selected weaver to hand over the overall loom, with the remaining yarn quantity
  Future<List<WeftBalance>> weaverOverAllYarnStock(
      var weaverId, var loomNo) async {
    List<WeftBalance> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/all_weft_balance_v2?weaver_id=$weaverId&loom=$loomNo')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data']["weft_balance"];
        result = (data as List).map((i) => WeftBalance.fromJson(i)).toList();
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: $error');
      }
    });
    return result;
  }

  /// Selected weaver to hand over the overall loom, with the remaining warp meter
  Future<List<OtherWarpBalanceModel>> weaverOverAllOtherWarp(
      var weaverId, var loomNo) async {
    List<OtherWarpBalanceModel> result = [];
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/other_warp_balance?weaver_id=$weaverId&loom=$loomNo')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List)
            .map((i) => OtherWarpBalanceModel.fromJson(i))
            .toList();
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: $error');
      }
    });
    return result;
  }

  /// check the dropout warp id available status
  /// if success is true allow to add the warpId
  Future<String?> dropOutWarpIdCheck(var warpId) async {
    String? result;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/dropoutwarp_avl_chk?warp_id=$warpId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = data;
      } else {
        result = "False";
        debugPrint('error: ${json['message']}');
      }
    });
    return result;
  }

  /// Wages Change List based on the selected weaver, loom and product
  wagesChangeListDetails(var id) async {
    change(null, status: RxStatus.loading());
    var result = [];

    await HttpRepository.apiRequest(
      HttpRequestType.get,
      'api/weaving/entries/list/$id',
    ).then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        result = json["data"];
      } else {
        var error = jsonDecode(response.data);
        AppUtils.showErrorToast(message: "$error");
      }
    });
    return result;
  }

  Future<PrivateWeftRequirementListModel?> weavingAcIdByPrivateWeftDetails(
      var weavingAcId, var productId) async {
    PrivateWeftRequirementListModel? result;
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/get_common_weft_req_for_priweft?weaving_ac_id=$weavingAcId&product_id=$productId')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = PrivateWeftRequirementListModel.fromJson(data);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }
}
