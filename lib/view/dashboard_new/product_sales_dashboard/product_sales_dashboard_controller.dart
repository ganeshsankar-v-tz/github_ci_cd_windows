import 'dart:convert';

import 'package:get/get.dart';

import '../../../http/api_repository.dart';
import '../../../model/Dashborad/product_sale/ProductSaleDashboardModel.dart';

class ProductSalesDashboardController extends GetxController with StateMixin {
  @override
  void onInit() {
    super.onInit();
  }

  Future<ProductSaleDashboardModel?> productSaleDashboard(
      var year, month) async {
    change(null, status: RxStatus.loading());
    ProductSaleDashboardModel? result;
    await HttpRepository.apiRequest(HttpRequestType.get,
            'api/product_sale_dashboard?year=$year&month=$month')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        var data = json['data'];
        result = ProductSaleDashboardModel.fromJson(data);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }
}
