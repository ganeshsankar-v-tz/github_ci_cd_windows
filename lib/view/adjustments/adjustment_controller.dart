import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdjustmentController extends GetxController with StateMixin {
  List<Map<String, dynamic>> list = <Map<String, String>>[].obs;
  List<Map<String, dynamic>> filterList = <Map<String, String>>[].obs;

  @override
  void onInit() async {
    super.onInit();
    filterList = list = [
      //1
      {
        'title': 'Yarn Stock',
        'icon': 'assets/Adjustment Modules Icons/yarn_stock_adjustment.png',
        'color': Color(0xFFFFF1F1),
      },
      //2
      {
        'title': 'Product Stock',
        'icon': 'assets/Adjustment Modules Icons/product_stock_adjustment.png',
        'color': Color(0xFFDCFFF7),
      },
      //3
      {
        'title': 'Product Integration',
        'icon': 'assets/Adjustment Modules Icons/producti.png',
        'color': Color(0xFFFFF6EC),
      },
      //4
      {
        'title': 'Alternative Warp Design',
        'icon': 'assets/Adjustment Modules Icons/alternativewarp.png',
        'color': Color(0xFFF5EDFF),
      },
      //5
      {
        'title': 'Warp Merging',
        'icon': 'assets/Adjustment Modules Icons/warpmerging.png',
        'color': Color(0xFFE8FBFF),
      },

      {
        'title': 'Split Warp',
        'icon': 'assets/Adjustment Modules Icons/splitwarp.png',
        'color': Color(0xFFE5FFF9),
      },
      {
        'title': 'Color Matching',
        'icon': 'assets/Adjustment Modules Icons/color_matching.png',
        'color': Color(0xFFF5ECFF),
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

