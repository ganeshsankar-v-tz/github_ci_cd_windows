import 'dart:convert';

import 'package:abtxt/view/report/value_reports/weaver_main_warp_stock_value_report.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../model/ProductGroupModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../model/YarnModel.dart';

class ValueReportController extends GetxController with StateMixin {
  List<LedgerModel> ledgerDropdownWarper = <LedgerModel>[].obs;
  List<LedgerModel> ledgerlistweavers = <LedgerModel>[].obs;
  List<FirmModel> firmDropdown = <FirmModel>[].obs;
  List<NewWarpModel> warpDesignDropdown = <NewWarpModel>[].obs;
  List<ProductInfoModel> ProductNameList = <ProductInfoModel>[].obs;
  List<ProductGroupModel> groups = <ProductGroupModel>[].obs;
  List<NewColorModel> colorList = <NewColorModel>[].obs;
  List<YarnModel> yarnDropdown = <YarnModel>[].obs;
  List<LedgerModel> windersList = <LedgerModel>[].obs;

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

    super.onInit();
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
        print('error: ${json}');
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
        print(result);
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
            HttpRequestType.get, 'api/productinfolist/list')
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
  ///
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

  ///Yarn Stock Value Report
  Future<String?> yarnStockValueReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'required?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }


  ///Weaver Other Warp Stock Value Report
  Future<String?> WeaverOtherWarpStockValueReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
        HttpRequestType.get, 'required?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  ///Weaver Main Warp Stock Value Report
  Future<String?> WeaverMainWarpStockValueReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
        HttpRequestType.get, 'required?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  ///Weaver Yarn Stock Report
  Future<String?> weaverYarnStockReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
        HttpRequestType.get, 'required?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }


  ///Product Stock Value Report
  Future<String?> productStockValueReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
        HttpRequestType.get, 'required?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  /// Warp Stock Value Report
  Future<String?> warpStockValueReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'required?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  /// Warper Yarn Stock Value Report
  Future<String?> warperYarnStockValueReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
        HttpRequestType.get, 'required?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

  /// Winder  Yarn Stock Value Report
  Future<String?> winderYarnStockValueReport({var request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
        HttpRequestType.get, 'required?$query')
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
}
