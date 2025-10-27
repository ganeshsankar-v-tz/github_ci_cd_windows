import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/dashboard_new/product_sales_dashboard/product_sales_dashboard_controller.dart';
import 'package:abtxt/view/dashboard_new/product_sales_dashboard/product_stock_table.dart';
import 'package:abtxt/view/dashboard_new/product_sales_dashboard/recent_sale_table.dart';
import 'package:abtxt/view/dashboard_new/product_sales_dashboard/top_selling_product_table.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../widgets/column_chart/MyColumnChart.dart';

class ProductSalesDashboard extends StatefulWidget {
  const ProductSalesDashboard({super.key});

  static const String routeName = '/product_sales_dashboard';

  @override
  State<ProductSalesDashboard> createState() => _ProductSalesDashboardState();
}

class _ProductSalesDashboardState extends State<ProductSalesDashboard> {
  ProductSalesDashboardController controller = Get.find();

  RxString totalSales = RxString("");
  RxString totalRevenue = RxString("");
  RxString totalCustomer = RxString("");
  RxString totalProduct = RxString("");

  List<dynamic> salesReportList = <dynamic>[];
  List<dynamic> productStockList = <dynamic>[];
  List<dynamic> topSellingProductList = <dynamic>[];
  List<dynamic> recentSaleList = <dynamic>[];

  late double width;
  late ProductStockDataSource productStockDataSource;
  late TopSellingProductDataSource topSellingProductDataSource;
  late RecentSaleDataSource recentSaleDataSource;

  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();

  int currentYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;
  int? selectedMonth;
  int? selectedYear;

  final List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    productStockDataSource = ProductStockDataSource(list: productStockList);
    topSellingProductDataSource =
        TopSellingProductDataSource(list: topSellingProductList);
    recentSaleDataSource = RecentSaleDataSource(list: recentSaleList);
    monthController.text = monthNames[currentMonth - 1];
    yearController.text = "$currentYear";
    selectedMonth = currentMonth;
    selectedYear = currentYear;

    yearDetails();
    _apiCall();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return GetBuilder<ProductSalesDashboardController>(
      builder: (controller) {
        return CoreWidget(
          backgroundColor: const Color(0xFFF5F5F5),
          loadingStatus: false,
          appBar: AppBar(
            title: const Text(
              "PRODUCT SALES DASHBOARD",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            actions: [
              const Text(
                "Filter",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 14),
              MyDropdownButtonFormField(
                width: 140,
                controller: yearController,
                hintText: "",
                items: yearDetails(),
                onChanged: (value) {
                  selectedYear = int.tryParse(value);
                  _apiCall();
                },
              ),
              const SizedBox(width: 10),
              MyDropdownButtonFormField(
                width: 140,
                controller: monthController,
                hintText: "",
                items: monthNames,
                onChanged: (value) {
                  var result =
                      monthNames.indexWhere((element) => element == value);
                  selectedMonth = result + 1;
                  _apiCall();
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Card Details
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(
                          () => myCardWidget(
                            imageUrl:
                                "assets/Product Sales Dashboard/totalsale_icon.png",
                            heading: "Total Sales",
                            content: totalSales.value,
                            color: const Color(0xFFD65B5B),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Obx(
                          () => myCardWidget(
                            imageUrl:
                                "assets/Product Sales Dashboard/totalrevenueicon.png",
                            heading: "Total Revenue",
                            content: totalRevenue.value,
                            color: const Color(0xFFF09111),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Obx(
                          () => myCardWidget(
                            imageUrl:
                                'assets/Product Sales Dashboard/totalcustomericon.png',
                            heading: "Total Customers",
                            content: totalCustomer.value,
                            color: const Color(0xFF3AAAE5),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Obx(
                          () => myCardWidget(
                            imageUrl:
                                'assets/Product Sales Dashboard/toalproducticon.png',
                            heading: "Total Product",
                            content: totalProduct.value,
                            color: const Color(0xFF9196FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// Chart Details and product stock
                  Row(
                    children: [
                      Flexible(
                        flex: 5,
                        child: myTableWidget(
                          width: width / .5,
                          imageUrl:
                              'assets/Product Sales Dashboard/salesreport.png',
                          heading: "Sales Report",
                          color: const Color(0xFFFFEAEA),
                          child: MyColumnChart(cartesianSeries: [
                            ColumnSeries<dynamic, String>(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              dataSource: salesReportList,
                              xValueMapper: (dynamic data, _) =>
                                  "${data["month"]}",
                              yValueMapper: (dynamic data, _) =>
                                  data["total_qty"],
                            ),
                          ]),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: myTableWidget(
                          width: width / .5,
                          imageUrl:
                              'assets/Product Sales Dashboard/productstock_icon.png',
                          heading: "Product Stock",
                          color: const Color(0xffE8F5FF),
                          child: ProductStockTable(
                              dataSource: productStockDataSource),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  /// Top Selling Product And Recent Sale
                  Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: myTableWidget(
                          width: width / .4,
                          imageUrl:
                              'assets/Product Sales Dashboard/topselling_icon.png',
                          heading: "Top Selling Product",
                          color: const Color(0xFFEBFFE5),
                          child: TopSellingProductTable(
                              dataSource: topSellingProductDataSource),
                        ),
                      ),
                      Flexible(
                        flex: 6,
                        child: myTableWidget(
                          width: width / .6,
                          imageUrl:
                              'assets/Product Sales Dashboard/recent_icon.png',
                          heading: "Recent Sale",
                          color: const Color(0x9DECE6D3),
                          child:
                              RecentSaleTable(dataSource: recentSaleDataSource),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget myCardWidget(
      {required String imageUrl, heading, content, required Color color}) {
    return Card(
      child: Container(
        height: 100,
        width: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: color),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Flexible(
                flex: 3,
                child: Image.asset(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$heading",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "$content",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myTableWidget(
      {required String imageUrl,
      heading,
      required Color color,
      required Widget child,
      required double width}) {
    return Card(
      child: Container(
        height: 400,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), color: color),
                    child: Image.asset(
                      imageUrl,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "$heading",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5),
              child
            ],
          ),
        ),
      ),
    );
  }

  List<String> yearDetails() {
    int startYear = 2024;

    List<String> yearList = List.generate(
      currentYear - startYear + 1,
      (index) => "${startYear + index}",
    );

    return yearList;
  }

  _apiCall() async {
    if (selectedYear == null && selectedMonth == null) {
      return;
    }

    var result =
        await controller.productSaleDashboard(selectedYear, selectedMonth);

    if (result != null) {
      totalProduct.value = "${result.totalProduct}";
      totalCustomer.value = "${result.totalCustomer}";
      totalRevenue.value = AppUtils().rupeeFormat.format(result.totalRevenu);
      totalSales.value = "${result.totalSale}";

      List<Map<String, dynamic>> monthsList = [
        {"month": "Jan", "number": 1},
        {"month": "Feb", "number": 2},
        {"month": "Mar", "number": 3},
        {"month": "Apr", "number": 4},
        {"month": "May", "number": 5},
        {"month": "Jun", "number": 6},
        {"month": "Jul", "number": 7},
        {"month": "Aug", "number": 8},
        {"month": "Sep", "number": 9},
        {"month": "Oct", "number": 10},
        {"month": "Nov", "number": 11},
        {"month": "Dec", "number": 12},
      ];

      /// product sales details
      for (var month in monthsList) {
        var monthData = result.salesReport!.firstWhereOrNull(
          (element) => element.toJson()["sale_month"] == month["number"],
        );

        salesReportList.add({
          "month": month["month"],
          "total_qty": monthData?.toJson()["total_qty"] ?? 0,
        });
      }

      productStockList.clear();
      productStockDataSource.updateDataGridRows();
      productStockDataSource.updateDataGridSource();

      topSellingProductList.clear();
      topSellingProductDataSource.updateDataGridRows();
      topSellingProductDataSource.updateDataGridSource();

      recentSaleList.clear();
      recentSaleDataSource.updateDataGridRows();
      recentSaleDataSource.updateDataGridSource();

      /// product stock details
      result.productStock?.forEach((element) {
        var response = element.toJson();
        productStockList.add(response);
        productStockDataSource.updateDataGridRows();
        productStockDataSource.updateDataGridSource();
      });

      /// top selling product list
      result.topSellingProduct?.forEach((element) {
        var response = element.toJson();
        topSellingProductList.add(response);
        topSellingProductDataSource.updateDataGridRows();
        topSellingProductDataSource.updateDataGridSource();
      });

      /// recent sale details
      result.recentSale?.forEach((element) {
        var response = element.toJson();
        recentSaleList.add(response);
        recentSaleDataSource.updateDataGridRows();
        recentSaleDataSource.updateDataGridSource();
      });
    }
  }
}
