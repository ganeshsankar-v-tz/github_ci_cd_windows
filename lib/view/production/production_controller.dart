//production_controller

import 'dart:ui';

import 'package:get/get.dart';

class production_controller extends GetxController with StateMixin {
  List<Map<String, dynamic>> list = <Map<String, String>>[].obs;
  List<Map<String, dynamic>> filterList = <Map<String, String>>[].obs;

  @override
  void onInit() async {
    super.onInit();
    filterList = list = [
      {
        'title': 'Loom Declaration',
        'icon': 'assets/Production Modules Icons/loom_decilaration.png',
        'color': Color(0xFFFFF6EC),
      },
      {
        'title': 'Weaving',
        'icon': 'assets/Production Modules Icons/weaving.png',
        'color': Color(0xFFF5ECFF),
      },
      {
        'title': 'Wages Bill',
        'icon': 'assets/Production Modules Icons/wages_bill.png',
        'color': Color(0xFFFFEEEE),
      },
    ];
  }
  searchFilter(var search) {
    if (search.isNotEmpty) {
      filterList = list
          .where((element) =>
          element['title'].toLowerCase().contains(search.toLowerCase()))
          .toList();
    } else {
      filterList = list;
    }
    change(filterList);
  }
}

