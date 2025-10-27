import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../model/WarpDesignSheetModel.dart';
import '../../../model/warp_order_model.dart';

class WarpOrderController extends GetxController with StateMixin {
  List<LedgerModel> ledgerName = <LedgerModel>[].obs;
  List<LedgerModel> weaverName = <LedgerModel>[].obs;
  List<ProductInfoModel> ProductName = <ProductInfoModel>[].obs;
  List<WarpDesignSheetModel> WarpdesignSheet = <WarpDesignSheetModel>[].obs;
  List<NewColorModel> colorDropdown = <NewColorModel>[].obs;
  @override
  void onInit() async {
    change(ledgerName = await ledgerNameInfo());
    change(weaverName = await weaverNameInfo());
    change(ProductName = await productNameInfo());
    change(WarpdesignSheet = await warpDesignInfo());
    change(colorDropdown = await colorInfo());
    super.onInit();
  }

  // Ledger Name
  Future<List<LedgerModel>> ledgerNameInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/ledger')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        print(data);
        print('----------------------------------------------------');
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  // Weaver Name
  Future<List<LedgerModel>> weaverNameInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/ledger')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        print(data);
        print('----------------------------------------------------');
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  // Product Name
  Future<List<ProductInfoModel>> productNameInfo() async {
    List<ProductInfoModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/productinfolist/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data']['data'];
        print(data);
        print('----------------------------------------------------');
        result =
            (data as List).map((i) => ProductInfoModel.fromJson(i)).toList();

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

//Dropdown Color API call
  Future<List<NewColorModel>> colorInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data']['data'];
        result = (data as List).map((i) => NewColorModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    print('colorInfo ${jsonEncode(result)}');
    return result;
  }

  Future<dynamic> warporders({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/warp_order_list?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List).map((i) => WarpsOrder.fromJson(i)).toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <WarpsOrder>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }

  void addwarporders(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/warp_order_add',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('addwarporders: $json');
        Get.back();
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void updatewarporders(var request) async {
    await HttpRepository.apiRequest(
            HttpRequestType.post, 'api/warp_order_update',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        print('addwarporders: $json');
        Get.back();
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  Future<dynamic> deletewarporders(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/warp_order_delete/$id')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        //ledgers(page: '1');
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
