import 'dart:convert';
import 'dart:ui';

import 'package:abtxt/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../http/api_repository.dart';
import '../../model/weaving_models/WeavingProductApprovalModel.dart';

class DashBoard2Controller extends GetxController with StateMixin {
  List<Map<String, dynamic>> list = <Map<String, String>>[].obs;
  List<WeavingProductApprovalModel> weavingPendingProductApprovalList = [];

  @override
  void onInit() async {
    super.onInit();
    change(null, status: RxStatus.success());
    list = [
      {
        'title': 'Ledger',
        'icon': 'assets/Dashboard Shortcut Icons/ledger.png',
        'color': const Color(0xFFF5ECFF),
      },
      {
        'title': 'Goods Inward Slip',
        'icon': 'assets/Dashboard Shortcut Icons/Goods_Inward_Slip.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'Warp or Yarn Delivery Slip',
        'icon':
            'assets/Dashboard Shortcut Icons/warp or yarn delivery bill.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'Empty in - Out',
        'icon': 'assets/Dashboard Shortcut Icons/empty_in_out.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'Weaving',
        'icon': 'assets/Dashboard Shortcut Icons/weaving.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'Payment',
        'icon': 'assets/Dashboard Shortcut Icons/Payment.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'Warp Delivery To Roller',
        'icon': 'assets/Dashboard Shortcut Icons/warp_delivery_to_roller.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'Warp Inward From Roller',
        'icon': 'assets/Dashboard Shortcut Icons/warp_inward_from_roller.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'Warp Delivery To Dyer',
        'icon': 'assets/Dashboard Shortcut Icons/warp__delivery_to_dyer.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'Warp Inward From Dyer',
        'icon': 'assets/Dashboard Shortcut Icons/warp_ inward_from_dyer.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'Warp Search',
        'icon': 'assets/Dashboard Shortcut Icons/search.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'New Yarn',
        'icon': 'assets/Dashboard Shortcut Icons/yarn.png',
        'color': const Color(0xFFF3F3FF),
      },
      {
        'title': 'Product Info',
        'icon': 'assets/Dashboard Shortcut Icons/ProductInfo.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'Yarn Purchase',
        'icon': 'assets/Transaction Modules Icons/yarn_purchase.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'Yarn Delivery To Warper',
        'icon': 'assets/Dashboard Shortcut Icons/yarn_delivery_to_warper.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'Jari Twisting - Yarn Inward',
        'icon': 'assets/Transaction Modules Icons/yarn_return_from_warper.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'Warp Inward',
        'icon': 'assets/Dashboard Shortcut Icons/warp Inward.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'Product Sale',
        'icon': 'assets/Dashboard Shortcut Icons/product_sales.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'Product Jobwork Delivery',
        'icon': 'assets/Dashboard Shortcut Icons/Jobwork_delivery.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'Product Jobwork Inward',
        'icon': 'assets/Dashboard Shortcut Icons/jobwork_inward.png',
        'color': const Color(0xFFFFF6EB),
      },
      {
        'title': 'Warp Tracking',
        'icon': 'assets/Dashboard Shortcut Icons/tracking_icon.png',
        'color': const Color(0xFFFFF6EB),
      },
    ];
  }

  Future<void> weavingProduct() async {
    change(null, status: RxStatus.loading());
    List<WeavingProductApprovalModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/weaving_ac_v5_get?status[0]=Pending')
        .then((response) {
      change(null, status: RxStatus.success());
      if (response.success) {
        var json = jsonDecode(response.data);
        result = (json['data'] as List)
            .map((e) => WeavingProductApprovalModel.fromJson(e))
            .toList();
        weavingPendingProductApprovalList = result;
      } else {
        var error = jsonDecode(response.data);
      }
    });
  }

  Future<void> weavingStatusChange(var request, int id) async {
    change(null, status: RxStatus.loading());
    await HttpRepository.apiRequest(
            HttpRequestType.put, 'api/weaving_ac_v5_update/$id',
            requestBodydata: request)
        .then((response) async {
      change(null, status: RxStatus.success());
      if (response.success) {
        await weavingProduct();
        AppUtils.showSuccessToast(
            message: response.message ?? 'Status updated successfully');
      } else {
        var error = jsonDecode(response.data);
        AppUtils.showErrorToast(message: error['error']);
      }
    });
  }
}
