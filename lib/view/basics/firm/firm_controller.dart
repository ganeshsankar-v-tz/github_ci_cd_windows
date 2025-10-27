import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/area_model.dart';
import '../../../model/city_model.dart';
import '../../../model/country_model.dart';
import '../../../model/state_model.dart';
import '../../../utils/app_utils.dart';

class FirmController extends GetxController with StateMixin {
  List<AreaModel> areas = <AreaModel>[].obs;
  List<CityModel> citys = <CityModel>[].obs;
  List<StateModel> states = <StateModel>[].obs;
  List<Country_Model> countrys = <Country_Model>[].obs;

  Map<String, dynamic> request = <String, dynamic>{};

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    change(areas = await areaInfo());
    change(citys = await cityInfo());
    change(states = await stateInfo());
    change(countrys = await countryInfo());
    super.onInit();
  }

  //Country Dropdown
  Future<List<Country_Model>> countryInfo() async {
    List<Country_Model> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/country')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data']['data'];
        result = (data as List).map((i) => Country_Model.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  //State Dropdown
  Future<List<StateModel>> stateInfo() async {
    List<StateModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/state')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data']['data'];
        result = (data as List).map((i) => StateModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  //City Dropdown
  Future<List<CityModel>> cityInfo() async {
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

  //Area Name
  Future<List<AreaModel>> areaInfo() async {
    List<AreaModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/area')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data']['data'];
        result = (data as List).map((i) => AreaModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  Future<List<dynamic>> firms({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/firm?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        list = json['data']['data'];
      } else {
        var error = jsonDecode(response.data);
      }
    });
    change(null, status: RxStatus.success());
    return list;
  }

  void addFirm(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.upload, 'api/addfirm',
            formDatas: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  void updateFirm(var request, var id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.upload, 'api/updatefirm/post/$id',
            formDatas: request)
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        Get.back(result: "success");
        AppUtils.showSuccessToast(message: "${json["message"]}");
      } else {
        var error = jsonDecode(response.data);
        print('error: ${error}');
      }
    });
  }

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/delete_firm?id=$id&password=$password')
        .then((response) {
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
}
