import 'dart:convert';

import 'package:abtxt/model/product_sale/ProductSalesModel.dart';
import 'package:abtxt/view/trasaction/product_sales_calender_view/product_sales_calender_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../http/api_repository.dart';

import '../../../model/ProductInfoModel.dart';

class ProductSalesCalenderController extends GetxController with StateMixin {
  List<ProductInfoModel> products = <ProductInfoModel>[].obs;

  var calenderList = <Appointment>[].obs;
  late MeetingDataSource dataSource;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  productSaleList({var request = const {}}) async {
    final query = request.entries.map((e) => '${e.key}=${e.value}').join('&');
    change(null, status: RxStatus.loading());

    calenderList.clear();
    List<ProductSalesModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/product_sale_list?$query')
        .then((response) {
      if (response.success) {
        var json = jsonDecode(response.data);
        result = (json['data'] as List)
            .map((e) => ProductSalesModel.fromJson(e))
            .toList();

        calenderList.value = result.map(
          (e) {
            DateTime start = DateTime.parse("${e.eDate}");
            DateTime end = DateTime.parse("${e.eDate}");
            start = DateTime(start.year, start.month, start.day, 0, 0);
            end = DateTime(end.year, end.month, end.day, 23, 59);

            var subject = "";

            if (e.productSaleDetails != null &&
                e.productSaleDetails!.isNotEmpty) {
              if (e.productSaleDetails!.length > 1) {
                subject =
                    "${e.customerName ?? ""} - ${e.productSaleDetails?.first.productName ?? ""} ${e.productSaleDetails?.first.qty ?? ""} + ${e.productSaleDetails!.length - 1} more";
              } else {
                subject =
                    "${e.customerName ?? ""} - ${e.productSaleDetails?.first.productName ?? ""} ${e.productSaleDetails?.first.qty ?? ""}";
              }
            }

            return Appointment(
              startTime: start,
              endTime: end,
              subject: subject,
              notes: jsonEncode(e),
            );
          },
        ).toList();

        dataSource.notifyListeners(
            CalendarDataSourceAction.reset, calenderList);
      } else {
        var error = jsonDecode(response.data);
        debugPrint('error: ${error['message']}');
      }
    });
    change(null, status: RxStatus.success());
  }

/*Future<List<ProductInfoModel>> productInfo() async {
    change(null, status: RxStatus.loading());
    List<ProductInfoModel> result = [];
    await HttpRepository.apiRequest(
            HttpRequestType.get, 'api/productinfolist/list')
        .then((response) {
      change(null, status: RxStatus.success());
      var json = jsonDecode(response.data);
      if (response.success) {
        list = (data as List)
            .map((e) => ProductCalenderModel.fromJson(e))
            .toList();

        calenderList.value = list.map(
          (e) {
            DateTime start = DateTime.parse("${e.eDate}");
            DateTime end = DateTime.parse("${e.eDate}");
            start = DateTime(start.year, start.month, start.day, 0, 0);
            end = DateTime(end.year, end.month, end.day, 23, 59);

            var subject = "";

            if (e.item != null && e.item!.isNotEmpty) {
              if (e.item!.length > 1) {
                subject =
                    "${e.customerName ?? ""} - ${e.item?.first.productName ?? ""} ${e.item?.first.qty ?? ""} + ${e.item!.length - 1} more";
              } else {
                subject =
                    "${e.customerName ?? ""} - ${e.item?.first.productName ?? ""} ${e.item?.first.qty ?? ""}";
              }
            }

            return Appointment(
              startTime: start,
              endTime: end,
              subject: subject,
              notes: jsonEncode(e),
            );
          },
        ).toList();

        dataSource.notifyListeners(
            CalendarDataSourceAction.reset, calenderList);
      } else {
        print('error: ${json['message']}');
      }
    });
    return result;
  }*/
}
