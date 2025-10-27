import 'dart:ui';

import 'package:get/get.dart';

class DashBoard3Controller extends GetxController with StateMixin {
  List<Map<String, dynamic>> list = <Map<String, String>>[].obs;

  @override
  void onInit() async {
    super.onInit();
    list = [
      //1
      {
        'title': 'Ledger',
        'icon': 'assets/Dashboard Shortcut Icons/ledger.png',
        'color': Color(0xFFF5ECFF),
      },
      //2
      {
        'title': 'New Yarn',
        'icon': 'assets/Dashboard Shortcut Icons/yarn.png',
        'color': Color(0xFFF3F3FF),
      },
      //3
      {
        'title': 'Product Info',
        'icon': 'assets/Dashboard Shortcut Icons/ProductInfo.png',
        'color': Color(0xFFFFF6EB),
      },
      //Yarn Purchase
      //4
      {
        'title': 'Yarn Purchase',
        'icon': 'assets/Transaction Modules Icons/yarn_purchase.png',
        'color': Color(0xFFFFF6EB),
      },
      // 5
      {
        'title': 'Yarn Sale',
        'icon': 'assets/Dashboard Shortcut Icons/yarnsale.png',
        'color': Color(0xFFFFF6EB),
      },
      // 6
      {
        'title': 'Product Purchase',
        'icon': 'assets/Dashboard Shortcut Icons/product_purchase.png',
        'color': Color(0xFFFFF6EB),
      },
      //7
      {
        'title': 'Warp Order',
        'icon': 'assets/Dashboard Shortcut Icons/warporder.png',
        'color': Color(0xFFFFF6EB),
      },
      // 8
      {
        'title': 'Warp Sale',
        'icon': 'assets/Dashboard Shortcut Icons/warpsale.png',
        'color': Color(0xFFFFF6EB),
      },
      // 9
      {
        'title': 'Yarn Delivery To Warper',
        'icon': 'assets/Dashboard Shortcut Icons/yarn_delivery_to_warper.png',
        'color': Color(0xFFFFF6EB),
      },
      //10
      {
        'title': 'Warp Inward',
        'icon': 'assets/Dashboard Shortcut Icons/warp Inward.png',
        'color': Color(0xFFFFF6EB),
      },
      //11
      {
        'title': 'Jari Twisting',
        'icon': 'assets/Dashboard Shortcut Icons/Jaritwisting.png',
        'color': Color(0xFFFFF6EB),
      },
      //12
      {
        'title': 'Product DC to Customer',
        'icon': 'assets/Dashboard Shortcut Icons/product dc to customer.png',
        'color': Color(0xFFFFF6EB),
      },
      //13
      {
        'title': 'Product Sale',
        'icon': 'assets/Dashboard Shortcut Icons/product_sales.png',
        'color': Color(0xFFFFF6EB),
      },
      //14
      {
        'title': 'Product Jobwork Delivery',
        'icon': 'assets/Dashboard Shortcut Icons/Jobwork_delivery.png',
        'color': Color(0xFFFFF6EB),
      },
      //15

      {
        'title': 'Product Jobwork Inward',
        'icon': 'assets/Dashboard Shortcut Icons/jobwork_inward.png',
        'color': Color(0xFFFFF6EB),
      },
      //16
      {
        'title': 'Payment',
        'icon': 'assets/Dashboard Shortcut Icons/Payment.png',
        'color': Color(0xFFFFF6EB),
      },
      // Goods Inward Slip
      // 17
      {
        'title': 'Goods Inward Slip',
        'icon': 'assets/Dashboard Shortcut Icons/Goods_Inward_Slip.png',
        'color': Color(0xFFFFF6EB),
      },
      // 18
      {
        'title': 'Wages Bill',
        'icon': 'assets/Dashboard Shortcut Icons/wages_bill.png',
        'color': Color(0xFFFFF6EB),
      },
      // Warp or Yarn Delivery Slip
      // 19

      {
        'title': 'Warp or Yarn Delivery Slip',
        'icon':
            'assets/Dashboard Shortcut Icons/warp or yarn delivery bill.png',
        'color': Color(0xFFFFF6EB),
      },
      // 20
      {
        'title': 'Weaving',
        'icon': 'assets/Dashboard Shortcut Icons/weaving.png',
        'color': Color(0xFFFFF6EB),
      },
      // {
      //   'title': 'Firm',
      //   'icon': 'assets/Basics Modules Icons/firm.png',
      //   'color': Color(0xFFFFF1F1),
      // },
      // //2
      // {
      //   'title': 'Account',
      //   'icon': 'assets/Basics Modules Icons/account.png',
      //   'color': Color(0xFFFFF2FC),
      // },
      // //4
      // {
      //   'title': 'New Colour',
      //   'icon': 'assets/Basics Modules Icons/new_color.png',
      //   'color': Color(0xFFFFF6EB),
      // },
      // //5
      // {
      //   'title': 'New Unit',
      //   'icon': 'assets/Basics Modules Icons/new_unit.png',
      //   'color': Color(0xFFE7FAFF),
      // },
      // //6
      // {
      //   'title': 'Cops-Reel',
      //   'icon': 'assets/Basics Modules Icons/cops_reel.png',
      //   'color': Color(0xFFE5FFF8),
      // },
      // //7
      //
      // //8
      // {
      //   'title': 'Winding Yarn Conversions',
      //   'icon': 'assets/Basics Modules Icons/winding_yarn_conversion.png',
      //   'color': Color(0xFFFFEEEE),
      // },
      // //9
      // {
      //   'title': 'Warp Design Sheet',
      //   'icon': 'assets/Basics Modules Icons/warp_design sheet.png',
      //   'color': Color(0xFFF8F2FF),
      // },
      // //10
      // {
      //   'title': 'Warp Group',
      //   'icon': 'assets/Basics Modules Icons/warp_group.png',
      //   'color': Color(0xFFE7FAFF),
      // },
      // //11
      // {
      //   'title': 'New Warp',
      //   'icon': 'assets/Basics Modules Icons/new_warp.png',
      //   'color': Color(0xFFFFFEE3),
      // },
      // //12
      // {
      //   'title': 'Warping Wages Config',
      //   'icon': 'assets/Basics Modules Icons/warping_wages_config.png',
      //   'color': Color(0xFFFFEEEE),
      // },
      // //warping_design_charges_config.png
      // //13_1
      // {
      //   'title': 'Warping Design Charges Config',
      //   'icon': 'assets/Basics Modules Icons/warping_design_charges_config.png',
      //   'color': Color(0xFFFFF6EB),
      // },
      // //13
      // {
      //   'title': 'Warp Supplier Single yarn Rate',
      //   'icon':
      //   'assets/Basics Modules Icons/warp_supplier_single_yarn_rate.png',
      //   'color': Color(0xFFF8F2FF),
      // },
      // //14
      // {
      //   'title': 'Product Group',
      //   'icon': 'assets/Basics Modules Icons/product_group.png',
      //   'color': Color(0xFFDBFFF6),
      // },
      // //15
      //
      // //16
      // {
      //   'title': 'Product Image',
      //   'icon': 'assets/Basics Modules Icons/product_image.png',
      //   'color': Color(0xFFF5EDFF),
      // },
      // //17
      // {
      //   'title': 'Product Weft Requirement',
      //   'icon': 'assets/Basics Modules Icons/product_weft_requirement.png',
      //   'color': Color(0xFFE8FBFF),
      // },
      // //18
      // {
      //   'title': 'Product Job Work',
      //   'icon': 'assets/Basics Modules Icons/product_jobwork.png',
      //   'color': Color(0xFFF4EBFF),
      // },
      // //19
      //
      // {
      //   'title': 'Color Matching',
      //   'icon': 'assets/Basics Modules Icons/color_matching.png',
      //   'color': Color(0xFFF3FFDA),
      // },
      // //20
      // {
      //   'title': 'Costing Entry',
      //   'icon': 'assets/Basics Modules Icons/costing_entry.png',
      //   'color': Color(0xFFE1F9FF),
      // },
      // //21
      // {
      //   'title': 'Costing Change',
      //   'icon': 'assets/Basics Modules Icons/costing_change.png',
      //   'color': Color(0xFFFFF2FC),
      // },
      // //22
      // {
      //   'title': 'Yarn Opening Stock',
      //   'icon': 'assets/Basics Modules Icons/yarn_opening_stock.png',
      //   'color': Color(0xFFFFF6EB),
      // },
      // //23
      // {
      //   'title': 'Warp Opening Stock',
      //   'icon': 'assets/Basics Modules Icons/warp_opening_stock.png',
      //   'color': Color(0xFFDBFFF6),
      // },
      // //24
      // {
      //   'title': 'Product Opening Stock',
      //   'icon': 'assets/Basics Modules Icons/product_opening_stock.png',
      //   'color': Color(0xFFF7E8FF),
      // },
      // //25
      //
      // {
      //   'title': 'Empty Opening Stock',
      //   'icon': 'assets/Basics Modules Icons/product_opening_stock.png',
      //   'color': Color(0xFFFFEEEE),
      //
      // },
    ];
  }
}
