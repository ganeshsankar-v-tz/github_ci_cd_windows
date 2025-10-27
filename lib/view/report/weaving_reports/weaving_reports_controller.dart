import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/LoomGroup.dart';
import '../../../model/LoomModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../model/ProductGroupModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../model/YarnModel.dart';
import '../../../utils/app_utils.dart';

class WeavingReportController extends GetxController with StateMixin {
  List<LedgerModel> ledgerDropdownWarper = <LedgerModel>[].obs;
  List<LedgerModel> ledgerlistweavers = <LedgerModel>[].obs;
  List<FirmModel> firmDropdown = <FirmModel>[].obs;
  List<NewWarpModel> warpDesignDropdown = <NewWarpModel>[].obs;
  List<ProductInfoModel> ProductNameList = <ProductInfoModel>[].obs;
  List<ProductGroupModel> groups = <ProductGroupModel>[].obs;
  List<NewColorModel> colorList = <NewColorModel>[].obs;
  List<YarnModel> yarnDropdown = <YarnModel>[].obs;
  List<LedgerModel> windersList = <LedgerModel>[].obs;
  List<LedgerModel> weaver = <LedgerModel>[].obs;
  List<LoomGroup> loomList = <LoomGroup>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};
  int? weaverId;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    change(firmDropdown = await firmInfo());
    change(ledgerDropdownWarper = await ledgerInfo());
    change(ledgerlistweavers = await ledger());
    change(warpDesignDropdown = await warpInfo());
    change(ProductNameList = await productInfo());
    change(groups = await groupInfo());
    change(yarnDropdown = await yarnInfo());
    change(colorList = await colorInfo());
    change(windersList = await winderInfo());
    change(weaver = await weaverInfo());

    super.onInit();
  }

  Future<List<LoomGroup>> loomInfo(var id) async {
    List<LoomGroup> result = [];
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

  Future<List<LedgerModel>> weaverInfo() async {
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

  // Color
  Future<List<NewColorModel>> colorInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => NewColorModel.fromJson(i)).toList();
      } else {
        print('error: $json');
      }
    });
    return result;
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

  /// Product Group List
  Future<List<ProductGroupModel>> groupInfo() async {
    List<ProductGroupModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/productgroup/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result =
            (data as List).map((i) => ProductGroupModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  /// Product Name
  Future<List<ProductInfoModel>> productInfo() async {
    List<ProductInfoModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/product_dropdown_list?used_for=Weaving')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];

        result =
            (data as List).map((i) => ProductInfoModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  /// Warp Design Sheet
  Future<List<NewWarpModel>> warpInfo() async {
    List<NewWarpModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/newwrap/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => NewWarpModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  ///Warp Purchase Report
  Future<String?> warpPurchaseReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warps_purchase_reports?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  /// Warp Sale Report
  Future<String?> warpSaleReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warps_sales_reports?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  ///Weaving Yarn Report
  Future<String?> weavingYarnDeliveryReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/weaving_yarn_delivery_report?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

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

  Future<List<LedgerModel>> ledgerInfo() async {
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
    return result;
  }

  Future<List<LedgerModel>> ledger() async {
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

  Future<List<LedgerModel>> winderInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=winder')
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

  /// Weaver Absent Report
  Future<String?> weaverAbsentReport({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/weaver_absent_report?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  /// Beam Bobbin Balance Report
  Future<String?> beamBalanceReport({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'requirement_api?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  /// Loom List
  Future<String?> loomlistReport({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/weaving_looms_list_report?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  /// Weaving Day Book
  Future<String?> WeavingDayBookReport({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/day_book_report?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  /// Weaving Goods Inward Report
  /*Future<String?> weavingGoodsInwardReport({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/goods_inward_reports?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
        print(url);
      } else {}
    });
    return url;
  }*/
  Future<String?> weavingGoodsInwardReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/goods_inward_reports?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  Future<String?> weavingPendingGoodsInwardReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/goods_inward_pending_slip?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        if(json['data'] == null) {
          AppUtils.infoAlert(message: json["message"] ?? "No Data Found");
          return null;
        }

        url = json['data'];
      } else {}
    });
    return url;
  }

  /// Weaving Yarn Stock Report
  Future<String?> weavingYarnStockReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(HttpRequestType.get, 'required?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  /// Yarn Delivery Balance Report
  Future<String?> yarnDeliveryBalanceReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(HttpRequestType.get, 'required?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  /// Warp Delivery Main Warp Report
  Future<String?> warpDeliveryMainWarpReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(HttpRequestType.get, 'required?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  /// Warp Delivery Other Warp Report
  Future<String?> warpDeliveryOtherWarpReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(HttpRequestType.get, 'required?$query')
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
