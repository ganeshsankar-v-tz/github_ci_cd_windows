import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../http/api_repository.dart';
import '../../model/administrator/AdministratorModel.dart';

class UserPermissionController extends GetxController with StateMixin {
  var box = GetStorage();
  AdministratorModel item = Get.arguments;

  var list = [];
  var filterList = [];

  @override
  void onInit() async {
    super.onInit();
    change(null, status: RxStatus.success());
    userPermissions(item.id);
  }

  userPermissions(var id) async {
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/get_permission_list?user_id=$id')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        filterList = list = json['data'];
        change(filterList, status: RxStatus.success());
      } else {
        print('error: ${json['message']}');
      }
    });
  }

  userPermission(var request) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
      HttpRequestType.post,
      'api/add_permission',
      requestBodydata: request,
    ).then((response) {
      var json = jsonDecode(response.data);
      change(null, status: RxStatus.success());
      if (response.success) {
        userPermissions(item.id);
      } else {
        print('error: ${json['message']}');
      }
    });
  }
}
