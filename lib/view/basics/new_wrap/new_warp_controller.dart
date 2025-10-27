import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/WarpGroupModel.dart';
import '../../../model/YarnModel.dart';
import '../../../utils/app_utils.dart';

class NewWarpController extends GetxController with StateMixin {
  List<WarpGroupModel> groups = <WarpGroupModel>[].obs;

  List<YarnModel> yarnName = <YarnModel>[].obs;
  List<NewColorModel> colorName = <NewColorModel>[].obs;

  String? warpType;
  var lastYarn;
  var itemList = <dynamic>[];
  var filterData;

  int totalEnds = 0;
  Map<String, dynamic> request = <String, dynamic>{};
  @override
  void onInit() async {
    groupNameInfo();
    yarnNameInfo();
    change(null, status: RxStatus.success());
    change(colorName = await colorNameInfo());
    super.onInit();
  }

  //Color Name
  Future<List<NewColorModel>> colorNameInfo() async {
    List<NewColorModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/color/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => NewColorModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }

  //Yarn Name
  Future<List<YarnModel>> yarnNameInfo() async {
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
    change(yarnName = result);
    return result;
  }

  //Group Name
  Future<List<WarpGroupModel>> groupNameInfo() async {
    List<WarpGroupModel> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/warpgroup/list')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = (data as List).map((i) => WarpGroupModel.fromJson(i)).toList();
      } else {
        print('error: ${json['message']}');
      }
    });
    change(groups = result);
    return result;
  }

  Future<List<dynamic>> newWrapList({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());
    List<dynamic> list = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/newwrap?$query')
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

  void addNewwarps(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/newwrap',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
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

  void updateNewWarps(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(HttpRequestType.post, 'api/newwarpupdate',
            requestBodydata: request)
        .then((response) {
      change(null, status: RxStatus.success());
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

  Future<dynamic> delete(var id, var password) async {
    await HttpRepository.apiRequest(
            HttpRequestType.delete, 'api/delete_warp?id=$id&password=$password')
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
