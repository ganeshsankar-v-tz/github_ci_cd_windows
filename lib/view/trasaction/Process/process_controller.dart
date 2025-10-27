import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/AccountTypeModel.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/ProcessPureSilkModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../utils/app_utils.dart';

class ProcessController extends GetxController with StateMixin {
  List<FirmModel> firmName = <FirmModel>[].obs;
  List<LedgerModel> ledgerDropdown = <LedgerModel>[].obs;
  List<ProductInfoModel> productDropdown = <ProductInfoModel>[].obs;

  List<LedgerModel> ProcessorName = <LedgerModel>[].obs;
  List<AccountTypeModel> Account = <AccountTypeModel>[].obs;
  @override
  void onInit() async {
    change(ledgerDropdown = await ledgerInfo());
    change(firmName = await firmNameInfo());
    change(productDropdown = await productInfo());

    change(Account = await AccountInfo());
    change(ProcessorName = await processorInfo());
    super.onInit();
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
        print('----------------------------------------------------');
        result =
            (data as List).map((i) => AccountTypeModel.fromJson(i)).toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  // Processor
  Future<List<LedgerModel>> processorInfo() async {
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

  //Product name
  Future<List<ProductInfoModel>> productInfo() async {
    List<ProductInfoModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/productinfolist/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];

        print('=======');
        result = (data['data'] as List)
            .map((i) => ProductInfoModel.fromJson(i))
            .toList();
        print('----------------------------------------------------');
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  //Ledger name
  Future<List<LedgerModel>> ledgerInfo() async {
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

  //Firm Name
  Future<List<FirmModel>> firmNameInfo() async {
    List<FirmModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/firm/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        print(data);
        result = (data as List).map((i) => FirmModel.fromJson(i)).toList();
        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<dynamic> process_get({var page = "1"}) async {
    dynamic result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/process_list?page=$page')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        var data = json['data']['data'];
        var list = (data as List)
            .map((i) => ProcessPureSilkModel.fromJson(i))
            .toList();
        var totalPage = (json['data']['last_page']);
        result = {"list": list, "totalPage": totalPage};
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error['message']}');
        result = {"list": <ProcessPureSilkModel>[], "totalPage": 1};
      }
    });
    return result;
  }

  void addProcess(var request) async {
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/add_process',
            requestBodydata: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);

        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void updateProcess(var request, var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.upload, 'api/update_process/$id',
            formDatas: request)
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);

        Get.back();
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  Future<dynamic> deleteProcess(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/delete_process/$id')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);

        AppUtils.showSuccessToast(message: "${json["message"]}");
        //ledgers(page: '1');
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }
}
