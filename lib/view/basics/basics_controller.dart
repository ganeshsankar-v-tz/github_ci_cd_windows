import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasicController extends GetxController with StateMixin {
  List<Map<String, dynamic>> list = <Map<String, String>>[].obs;
  List<Map<String, dynamic>> filterList = <Map<String, String>>[].obs;

  @override
  void onInit() async {
    super.onInit();
    filterList = list = [
      //1
      {
        'title': 'Firm',
        'icon': 'assets/Basics Modules Icons/firm.png',
        'color': Color(0xFFFFF1F1),
      },
      //2
      {
        'title': 'Account',
        'icon': 'assets/Basics Modules Icons/account.png',
        'color': Color(0xFFFFF2FC),
      },
      //3
      {
        'title': 'Ledger',
        'icon': 'assets/Basics Modules Icons/ledger.png',
        'color': Color(0xFFF5ECFF),
      },
      //4
      {
        'title': 'New Colour',
        'icon': 'assets/Basics Modules Icons/new_color.png',
        'color': Color(0xFFFFF6EB),
      },
      //5
      {
        'title': 'New Unit',
        'icon': 'assets/Basics Modules Icons/new_unit.png',
        'color': Color(0xFFE7FAFF),
      },
      //6
      {
        'title': 'Cops-Reel',
        'icon': 'assets/Basics Modules Icons/cops_reel.png',
        'color': Color(0xFFE5FFF8),
      },
      //7
      {
        'title': 'New Yarn',
        'icon': 'assets/Basics Modules Icons/new_yarn.png',
        'color': Color(0xFFF3F3FF),
      },
      //8
      {
        'title': 'Winding Yarn Conversions',
        'icon': 'assets/Basics Modules Icons/winding_yarn_conversion.png',
        'color': Color(0xFFFFEEEE),
      },
      //9
      {
        'title': 'Warp Design Sheet',
        'icon': 'assets/Basics Modules Icons/warp_design sheet.png',
        'color': Color(0xFFF8F2FF),
      },
      //10
      {
        'title': 'Warp Group',
        'icon': 'assets/Basics Modules Icons/warp_group.png',
        'color': Color(0xFFE7FAFF),
      },
      //11
      {
        'title': 'New Warp',
        'icon': 'assets/Basics Modules Icons/new_warp.png',
        'color': Color(0xFFFFFEE3),
      },
      //12
      {
        'title': 'Warping Wages Config',
        'icon': 'assets/Basics Modules Icons/warping_wages_config.png',
        'color': Color(0xFFFFEEEE),
      },
      //warping_design_charges_config.png
      //13_1
      {
        'title': 'Warping Design Charges Config',
        'icon': 'assets/Basics Modules Icons/warping_design_charges_config.png',
        'color': Color(0xFFFFF6EB),
      },
      //13
      {
        'title': 'Warp Supplier Single yarn Rate',
        'icon':
            'assets/Basics Modules Icons/warp_supplier_single_yarn_rate.png',
        'color': Color(0xFFF8F2FF),
      },
      //14
      {
        'title': 'Product Group',
        'icon': 'assets/Basics Modules Icons/product_group.png',
        'color': Color(0xFFDBFFF6),
      },
      //15
      {
        'title': 'Product Info',
        'icon': 'assets/Basics Modules Icons/product_info.png',
        'color': Color(0xFFFFF6EB),
      },
      //16
      {
        'title': 'Product Image',
        'icon': 'assets/Basics Modules Icons/product_image.png',
        'color': Color(0xFFF5EDFF),
      },
      //17
      {
        'title': 'Product Weft Requirement',
        'icon': 'assets/Basics Modules Icons/product_weft_requirement.png',
        'color': Color(0xFFE8FBFF),
      },
      //18
      {
        'title': 'Product Job Work',
        'icon': 'assets/Basics Modules Icons/product_jobwork.png',
        'color': Color(0xFFF4EBFF),
      },
      //19

      {
        'title': 'Color Matching',
        'icon': 'assets/Basics Modules Icons/color_matching.png',
        'color': Color(0xFFF3FFDA),
      },
      //20
      {
        'title': 'Costing Entry',
        'icon': 'assets/Basics Modules Icons/costing_entry.png',
        'color': Color(0xFFE1F9FF),
      },
      //21
      {
        'title': 'Costing Change',
        'icon': 'assets/Basics Modules Icons/costing_change.png',
        'color': Color(0xFFFFF2FC),
      },
      //22
      {
        'title': 'Yarn Opening Stock',
        'icon': 'assets/Basics Modules Icons/yarn_opening_stock.png',
        'color': Color(0xFFFFF6EB),
      },
      //23
      {
        'title': 'Warp Opening Stock',
        'icon': 'assets/Basics Modules Icons/warp_opening_stock.png',
        'color': Color(0xFFDBFFF6),
      },
      //24
      {
        'title': 'Product Opening Stock',
        'icon': 'assets/Basics Modules Icons/product_opening_stock.png',
        'color': Color(0xFFF7E8FF),
      },
      //25

      {
        'title': 'Empty Opening Stock',
        'icon': 'assets/Basics Modules Icons/product_opening_stock.png',
        'color': Color(0xFFFFEEEE),
      },
      //26
      {
        'title': 'Ledger Opening Balance',
        'icon': 'assets/Basics Modules Icons/ledger_opening_balance.png',
        'color': Color(0xFFF3F3FF),
      },
      //27
      {
        'title': 'Opening Closing Stock Value',
        'icon': 'assets/Basics Modules Icons/opning_closing_stockvalue.png',
        'color': Color(0xFFE6E6F6),
      },
      //28
      {
        'title': 'Dyer Order Opening Balance',
        'icon': 'assets/Basics Modules Icons/dyer_order_opening_balance.png',
        'color': Color(0xFFE1FAFB),
      },

      //29
      {
        'title': 'Dyer Yarn Opening Balance',
        'icon': 'assets/Basics Modules Icons/dyer_yarn_opening_balance.png',
        'color': Color(0xFFF4F3FF),
      },
      //30

      {
        'title': 'Dyer Warp Opening Balance',
        'icon': 'assets/Basics Modules Icons/dyer_warp_opening_balance.png',
        'color': Color(0xFFF3FFDB),
      },
      //31
      {
        'title': 'Warp Yarn Opening Balance',
        'icon': 'assets/Basics Modules Icons/warper_yarn_opening_balance.png',
        'color': Color(0xFFF3FFDB),
      },
      //32
      {
        'title': 'Roller Warp Opening Balance',
        'icon': 'assets/Basics Modules Icons/roller_warp_opening_balance.png',
        'color': Color(0xFFE5FFF9),
      },
      //33
      {
        'title': 'Winding Yarn Opening Balance',
        'icon': 'assets/Basics Modules Icons/warper_yarn_opening_balance.png',
        'color': Color(0xFFE8FBFF),
      },
      //34
      {
        'title': 'Empty Beam',
        'icon': 'assets/Basics Modules Icons/yarn_opening_stock.png',
        'color': Color(0xFFFFF6EB),
      },
      //35
      {
        'title': 'Process Product Opening Balance',
        'icon':
            'assets/Basics Modules Icons/process_product_opening_balance.png',
        'color': Color(0xFFFFFEE3),
      },
      //36
      {
        'title': 'Job Work Product Opening Balance',
        'icon':
            'assets/Basics Modules Icons/jobwork_product_opening_balance.png',
        'color': Color(0xFFF3F3FF),
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
