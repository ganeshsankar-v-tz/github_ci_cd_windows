import 'dart:convert';
import 'package:get/get.dart';
import '../../../http/api_repository.dart';

import '../../../model/color_matching_list_data.dart';

class ColorMatchingController extends GetxController with StateMixin {
  List<ColorMatchingListData> products = <ColorMatchingListData>[].obs;

  @override
  void onInit() async {
    change(products = await productInfo());

    super.onInit();
  }

  Future<List<ColorMatchingListData>> productInfo() async {
    List<ColorMatchingListData> result = [];
    await HttpRepository.apiRequest(HttpRequestType.get, 'api/colourmatchnig')
        .then((response) {
      var json = jsonDecode(response.data);
      if (response.success) {
        print(response.success);
        var data = json['data'];
        print(data);
        result = (data['data'] as List)
            .map((i) => ColorMatchingListData.fromJson(i))
            .toList();

        print(result);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }
}
