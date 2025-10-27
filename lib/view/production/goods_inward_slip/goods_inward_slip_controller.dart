import 'dart:convert';

import 'package:abtxt/model/saree_checker/SareeCheckerModel.dart';
import 'package:abtxt/model/weaving_models/GoodsInwardDetailsModel.dart';
import 'package:abtxt/model/weaving_models/GoodsInwardListModel.dart';
import 'package:abtxt/model/weaving_models/GoodsInwardOtherWarpModel.dart';
import 'package:abtxt/model/weaving_models/ProductDetailsGoodsInwardModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/LoomGroup.dart';
import '../../../model/LoomModel.dart';
import '../../../model/weaving_models/WeaverByLoomStatusModel.dart';
import '../../../model/weaving_models/WeavingProductListModel.dart';
import '../../../model/weaving_models/weft_balance/PrivateWeftRequirementListModel.dart';

class GoodsInwardSlipController extends GetxController with StateMixin {
  List<LedgerModel> WeaverName = <LedgerModel>[].obs;
  List<LoomGroup> loomList = <LoomGroup>[].obs;
  List<WeaverByLoomStatusModel> warpStatus = <WeaverByLoomStatusModel>[].obs;
  List<WeavingProductListModel> productDetails =
      <WeavingProductListModel>[].obs;
  List<SareeCheckerModel> sareChecker = <SareeCheckerModel>[].obs;
  List<GoodsInwardOtherWarpModel> otherWarpId =
      <GoodsInwardOtherWarpModel>[].obs;

  var itemList = <dynamic>[];
  var filterData;
  RxBool paymentSaveToApiCall = RxBool(false);
  RxBool getBackBoolean = RxBool(false);
  RxInt pendingQty = RxInt(0);

  var lastAddDetails;
  num balanceQty = 0;
  int? weaverId;

  /// ( Alt + C )  to save the date details
  int? id;
  int? challanNo;
  String? date;
  bool shortCutToSave = false;

  Map<String, dynamic> request = <String, dynamic>{};

  @override
  void onInit() async {
    weaverNameInfo();
    productInfo();
    sareeCheckerDetails();
    super.onInit();
  }

  Future<List<String>> otherWarpIdDetails(int weavingAcId) async {
    List<GoodsInwardOtherWarpModel> result = [];

    String? lastWarpId;
    List<String> lastWarpIds = [];

    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/transfer_other_warp_list_V2?weaving_ac_id=$weavingAcId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data']["balance_warp"];
        lastWarpId = json["data"]["lastest_warp"];
        if (lastWarpId != null) {
          lastWarpIds = lastWarpId!.split(",");
        }

        result = (data as List)
            .map((i) => GoodsInwardOtherWarpModel.fromJson(i))
            .toList();
        var list = result;
        var localData = itemList.where((e) => e['sync'] == 0).toList();

        /// local data loop
        for (var item in localData) {
          /// local data in side other warp id loop
          List<String?> selectedWarpId =
              item["used_other_warp"].toString().split(",");

          for (var warpId in selectedWarpId) {
            /// API warp id loop
            for (int i = 0; i < list.length; i++) {
              if (warpId == list[i].otherWarpid) {
                double meter =
                    (double.tryParse("${list[i].balanceMeter}") ?? 0.0) -
                        item["inward_meter"];
                list[i].balanceMeter = meter;
              }
            }
          }
        }
      } else {
        print('error: ${json['message']}');
      }
    });
    change(otherWarpId = result);
    return lastWarpIds;
  }

  /// Weaver Id By Loom No Call
  Future<List<LoomGroup>> loomInfo(var id) async {
    List<LoomGroup> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/goods_inward_weavingloom?weaver_id=$id')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
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

  Future<List<WeavingProductListModel>> productInfo() async {
    List<WeavingProductListModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/product_dropdown_list?used_for=Weaving')
        .then((response) {
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
    change(productDetails = result);
    return result;
  }

  /// Check The Goods Inward Already Added In Same Date Or Not
  Future<bool?> samDateGoodInwardOrNot(var weaverId, var date) async {
    bool? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/goods_avl_in_same_date?weaver_id=$weaverId&e_date=$date')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = data;
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<bool?> weftChecking(
      var weaverId, var loomNo, var currentStatus, var productId) async {
    bool? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/goods_weft_checking?weaver_id=$weaverId&loom_no=$loomNo&current_status=$currentStatus&product_id=$productId')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = data;
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  /// Weaver Loom By Warp Status
  Future<List<WeaverByLoomStatusModel>> loomWarpStatus(
      var weaverId, var loomNo) async {
    List<WeaverByLoomStatusModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/loom_status_weav_no_using_loomno?weaver_id=$weaverId&loom_no=$loomNo')
        .then((response) {
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
    change(warpStatus = result);
    return result;
  }

  ///  Loom Id By Get The Weaver Deliver Product Details
  Future<ProductDetailsGoodsInwardModel> loomByProductDetails(
      var loomNo, var weaverId, var status) async {
    dynamic result;
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/get_details_using_loom_status?weaver_id=$weaverId&current_status=$status&loom=$loomNo')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = ProductDetailsGoodsInwardModel.fromJson(data);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

//   Weaver Name
  Future<List<LedgerModel>> weaverNameInfo() async {
    change(null, status: RxStatus.loading());
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=weaver')
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
    change(WeaverName = result);
    return result;
  }

  /// Challan No By Update The Weaver Details
  Future<GoodsInwardDetailsModel> challanNoByDetails(
      var challanNo, var recNo) async {
    dynamic result;
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/goods_datas_get_from_challan_no?challan_no=$challanNo&rec_no=$recNo')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = GoodsInwardDetailsModel.fromJson(data);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  /// Goods Inward List Screen Details With Filter
  Future<List<GoodsInwardListModel>> goodsInward(
      {var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<GoodsInwardListModel> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/goodsinward_list?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        list = (data as List)
            .map((i) => GoodsInwardListModel.fromJson(i))
            .toList();
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(null, status: RxStatus.success());
    return list;
  }

  /// Pdf
  Future<String?> goodsInwardSlipPdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/goods_inward_slip_pdf?$query')
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
            HttpRequestType.post, 'api/goodsinward_add_v2',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        // _dialogBuilder('${json["message"]}');
        // AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: $error');
      }
    });
  }

  void edit(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/goodsinward_update_v2?id=$id',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
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

  Future<dynamic> delete(var id, var password) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/goods_inward_delete?id=$id&password=$password')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: 'success');
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error["message"]}');
      }
    });
  }

  Future<dynamic> selectedRowDelete(
      var rowId, var weavingAcId, var recordNo) async {
    var result = {};
    await HttpRepository.apiRequest(HttpRequestType.delete,
            'api/goods_inward_item_remove?row_no=$rowId&weaving_ac_id=$weavingAcId&gi_slip_rec_no=$recordNo')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        result = {"status": json["data"], "message": json["message"]};
      } else {
        var error = jsonDecode(response.data);
        result = {"status": "false", "message": "${error["message"]}"};
      }
    });
    return result;
  }

  Future<List<SareeCheckerModel>> sareeCheckerDetails() async {
    List<SareeCheckerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/saree_checker_dropdown_list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => SareeCheckerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(sareChecker = result);
    return result;
  }

  Future<dynamic> shortCuteAdd(var request) async {
    var result = {};
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/goodsinward_add',
            requestBodydata: request)
        .then(
      (response) {
        if (response.success) {
          var json = jsonDecode(response.data);
          result = json["data"];
        } else {
          var error = jsonDecode(response.data);
          debugPrint('error: $error');
        }
      },
    );
    return result;
  }

  void shortCuteEdit(var request, var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/goodsinward_update?id=$id',
            requestBodydata: request)
        .then(
      (response) {
        if (response.success) {
          var json = jsonDecode(response.data);
        } else {
          var error = jsonDecode(response.data);
          debugPrint('error: $error');
        }
      },
    );
  }

  pendingQtyCalculation() {
    int qty = 0;

    for (var item in itemList) {
      if (item['pending'] == "Yes") {
        qty += int.tryParse("${item['inward_qty']}") ?? 0;
      }
    }

    pendingQty.value = qty;
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
