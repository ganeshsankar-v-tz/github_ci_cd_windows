import 'dart:ui';

import 'package:get/get.dart';

class TransactionController extends GetxController with StateMixin {
  List<Map<String, dynamic>> list = <Map<String, String>>[].obs;
  List<Map<String, dynamic>> filterList = <Map<String, String>>[].obs;

  @override
  void onInit() async {
    super.onInit();

    filterList = list = [
      //1
      {
        'title': 'Yarn Purchase',
        'icon': 'assets/Transaction Modules Icons/yarn_purchase.png',
        'color': Color(0xFFFFF2FC),
      },
      //2
      {
        'title': 'Yarn Purchase Return',
        'icon':
            'assets/Transaction Modules Icons/yarn_purchase_return_ icon.png',
        'color': Color(0xFFF5ECFF),
      },
      //3
      {
        'title': 'Yarn Sales',
        'icon': 'assets/Transaction Modules Icons/yarn_sale.png',
        'color': Color(0xFFFFF2FC),
      },
      //4
      {
        'title': 'Yarn Stock Report',
        'icon': 'assets/Transaction Modules Icons/yarn_stock_report.png',
        'color': Color(0xFFFFF1F1),
      },
      //5
      {
        'title': 'Yarn Sales Return',
        'icon': 'assets/Transaction Modules Icons/yarn_purchase_return.png',
        'color': Color(0xFFFFF6EB),
      },
      //6

      {
        'title': 'Yarn Delivery to Winder',
        'icon': 'assets/Transaction Modules Icons/yarn_delivery_to_winder.png',
        'color': Color(0xFFF8F2FF),
      },
      //7
      {
        'title': 'Yarn Inward from Winder',
        'icon': 'assets/Transaction Modules Icons/yarn_inward_from_winder.png',
        'color': Color(0xFFE7FAFF),
      },
      //8
      {
        'title': 'Yarn Delivery to Dyer',
        'icon': 'assets/Transaction Modules Icons/yarn_delivery_to _dyer.png',
        'color': Color(0xFFE9FFFB),
      },
      //9
      {
        'title': 'Yarn Inward from Dyer',
        'icon': 'assets/Transaction Modules Icons/yarn_inward_from_dyer.png',
        'color': Color(0xFFFFFEE3),
      },
      //10
      {
        'title': 'Warp Delivery to Dyer',
        'icon': 'assets/Transaction Modules Icons/warp__delivery_to_dyer.png',
        'color': Color(0xFFF5EDFF),
      },
      //11
      {
        'title': 'Warp Inward From Dyer',
        'icon': 'assets/Transaction Modules Icons/warp_ inward_from_dyer.png',
        'color': Color(0xFFFFFEE3),
      },
      //12
      {
        'title': 'Warp Delivery To Roller',
        'icon': 'assets/Transaction Modules Icons/warp_delivery_to_roller.png',
        'color': Color(0xFFF5EDFF),
      },
      //13
      {
        'title': 'Warp Inward From Roller',
        'icon': 'assets/Transaction Modules Icons/warp_inward_from_roller.png',
        'color': Color(0xFFFFF1F1),
      },
      //14
      {
        'title': 'Warp Order',
        'icon': 'assets/Transaction Modules Icons/warp_order.png',
        'color': Color(0xFFE8FBFF),
      },
      //15
      {
        'title': 'Yarn Delivery to Warper',
        'icon':
            'assets/Transaction Modules Icons/yarn_delivery_from_warper.png',
        'color': Color(0xFFFFF1F1),
      },
      //16
      {
        'title': 'Yarn Return from Warper',
        'icon': 'assets/Transaction Modules Icons/yarn_return_from_warper.png',
        'color': Color(0xFFE2FAFC),
      },
      //17
      {
        'title': 'Yarn Shortage Adjustment',
        'icon': 'assets/Transaction Modules Icons/yarn_shortage_adjustment.png',
        'color': Color(0xFFFFFEE3),
      },
      //18
      {
        'title': 'Warp Inward',
        'icon': 'assets/Transaction Modules Icons/warp_inward.png',
        'color': Color(0xFFEFE6F9),
      },
      //19
      {
        'title': 'Twisting or Warping',
        'icon': 'assets/Transaction Modules Icons/twisting_or_warping.png',
        'color': Color(0xFFE7FAFF),
      },
      //20

      {
        'title': 'Warp or Yarn Dyeing',
        'icon': 'assets/Transaction Modules Icons/warp_or_yarn_Dying.png',
        'color': Color(0xFFE5FFF8),
      },
      //21

      {
        'title': 'Job Work Pure Silk',
        'icon': 'assets/Transaction Modules Icons/job_Work.png',
        'color': Color(0xFFF3F3FF),
      },
      //22
      {
        'title': 'Process Pure Silk',
        'icon': 'assets/Transaction Modules Icons/process.png',
        'color': Color(0xFFFFEEEE),
      },
      //23
      {
        'title': 'Product Purchase',
        'icon': 'assets/Transaction Modules Icons/product_purchase.png',
        'color': Color(0xFFFFF1F1),
      },
      //24

      {
        'title': 'Product Purchase Return',
        'icon': 'assets/Transaction Modules Icons/product_purchase_return.png',
        'color': Color(0xFFFFFEE3),
      },
      //25
      {
        'title': 'Product Order',
        'icon': 'assets/Transaction Modules Icons/product_order.png',
        'color': Color(0xFFE2FAFC),
      },
      //26
      {
        'title': 'Product D.C to Customer',
        'icon': 'assets/Transaction Modules Icons/product_dc_to_customer.png',
        'color': Color(0xFFE2FAFC),
      },
      //27
      {
        'title': 'Product Return from Customer',
        'icon':
            'assets/Transaction Modules Icons/product_return_from_customer.png',
        'color': Color(0xFFFFF6EB),
      },
      //28
      {
        'title': 'Product Sale',
        'icon': 'assets/Transaction Modules Icons/product_sales.png',
        'color': Color(0xFFFFF1F1),
      },
      //29

      {
        'title': 'Product Sales Return',
        'icon': 'assets/Transaction Modules Icons/product_sales_return.png',
        'color': Color(0xFFF5EDFF),
      },
      //30
      {
        'title': 'Transport Copy',
        'icon': 'assets/Transaction Modules Icons/transport_copy.png',
        'color': Color(0xFFF5EDFF),
      },
      //31
      {
        'title': 'Handloom Certificate',
        'icon': 'assets/Transaction Modules Icons/handloom_certificate.png',
        'color': Color(0xFFF3FFE7),
      },
      //32
      {
        'title': 'Retail Sales',
        'icon': 'assets/Transaction Modules Icons/retail_sale.png',
        'color': Color(0xFFE3FFFA),
      },
      //33
      {
        'title': 'Warp Purchase',
        'icon': 'assets/Transaction Modules Icons/warp_purchase.png',
        'color': Color(0xFFFFFEE3),
      },
      //34
      {
        'title': 'Warp Sales',
        'icon': 'assets/Transaction Modules Icons/warp_sale.png',
        'color': Color(0xFFFFF2FC),
      },

      //36
      {
        'title': 'Empty (Beam / Bobbin) Delivery / Inward',
        'icon':
            'assets/Transaction Modules Icons/empty_beambobbin_delivery_inward.png',
        'color': Color(0xFFF3FFE8),
      },
      //36
      {
        'title': 'Jari Twisting',
        'icon':
            'assets/Transaction Modules Icons/empty_beambobbin_delivery_inward.png',
        'color': Color(0xFFF3FFE8),
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
