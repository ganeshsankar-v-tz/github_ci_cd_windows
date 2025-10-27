import 'dart:convert';

import 'package:abtxt/model/city_model.dart';
import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../utils/app_utils.dart';

class ProductDcToCustomerController extends GetxController with StateMixin {
  List<FirmModel> firmName = <FirmModel>[].obs;
  List<LedgerModel> Customer = <LedgerModel>[].obs;
  List<ProductInfoModel> ProductName = <ProductInfoModel>[].obs;
  List<CityModel> placeDropdown = <CityModel>[].obs;
  List<LedgerModel> Transport = <LedgerModel>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};
  var filterData;

  @override
  void onInit() async {
    customerInfo();
    productInfo();
    change(firmName = await firmNameInfo());
    change(placeDropdown = await PlaceInfo());
    change(Transport = await transportInfo());

    super.onInit();
  }

  //Place

  //Transaport
  Future<List<LedgerModel>> transportInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=customer')
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

  // Product Name
  Future<List<ProductInfoModel>> productInfo() async {
    List<ProductInfoModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/product_dropdown_list?used_for=Sales')
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
    change(ProductName = result);
    return result;
  }

  // Customer Name
  Future<List<LedgerModel>> customerInfo() async {
    List<LedgerModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/rollbased?ledger_role=customer')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => LedgerModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(Customer = result);
    return result;
  }

  //Firm Name
  Future<List<FirmModel>> firmNameInfo() async {
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

  Future<List<dynamic>> productDcToCustomer({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/product_dc_customer_list?$query')
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
  Future<String?> productDCcustomerPdf({request = const {}}) async {
    change(null, status: RxStatus.loading());
    String query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    if (query.isEmpty) {
      return null;
    }
    var url;
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/product_dc_customer_print?$query')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        url = json['data'];
      } else {}
    });
    return url;
  }

/*  Future<dynamic> productDcToCustomer({var page = "1", var limit = "10"}) async {
    change(null, status: RxStatus.loading());
    dynamic result = [];
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/product_dc_customer_list?page=$page&limit=$limit')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data'];
        var list = (data as List)
            .map((i) => ProductDCtoCustomerModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        // print('error: ${error['message']}');
        result = {"list": <ProductDCtoCustomerModel>[], "totalPage": 1};
      }
    });
    change(null, status: RxStatus.success());
    return result;
  }*/

  void add(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/dc_customer_add',
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
            HttpRequestType.post, 'api/dc_customer_update',
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
            'api/product_dc_customer_delete?id=$id&password=$password')
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

  // City Dropdown
  Future<List<CityModel>> PlaceInfo() async {
    List<CityModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/city')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data']['data'];
        result = (data as List).map((i) => CityModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }
}
