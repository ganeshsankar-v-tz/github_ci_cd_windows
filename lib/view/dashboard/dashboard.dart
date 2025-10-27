import 'package:abtxt/view/dashboard/dashboard_controller.dart';
import 'package:abtxt/view/dashboard/product_sales_analysis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constant.dart';
import '../../widgets/MyDropdownButtonFormField.dart';
import '../../widgets/MyTotalTile.dart';
import '../../widgets/bar_chart_graph.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DashboardController controller = Get.put(DashboardController());

  @override
  void initState() {
    //controller.saleAnalysis({'year': '${Constants.YEARS[0]}'});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9F3FF),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _amountAnalysis(),
                          ProductSalesAnalysis(),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      children: [
                        _yarnStock(),
                        _warpStock(),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 400,
              )
            ],
          ),
        ),
      );
    });
  }

  _amountAnalysis() {
    return controller.obx(
      (state) {
        var totalAmount = {
          'title': 'Total Amount',
          'amount': '₹${controller.profitAmount}',
          'description': '₹25k today',
          'color': [
            Color(0xFF9795D4),
            Color(0xCC9795D4),
          ],
        };
        var salesAmount = {
          'title': 'Sales Amount',
          'amount': '₹${controller.salesAmount}',
          'description': '₹25k today',
          'color': [
            Color(0xFF9795D4),
            Color(0xCC9795D4),
          ],
        };
        var purchaseAmount = {
          'title': 'Purchase Amount',
          'amount': '₹${controller.purchaseAmount}',
          'description': '₹25k today',
          'color': [
            Color(0xFF9795D4),
            Color(0xCC9795D4),
          ],
        };
        return Container(
          margin: EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                MyTotalTile(
                  item: totalAmount,
                ),
                MyTotalTile(
                  item: salesAmount,
                ),
                MyTotalTile(
                  item: purchaseAmount,
                ),
              ],
            ),
          ),
        );
      },
      onLoading: Container(
          height: 100, child: Center(child: CupertinoActivityIndicator())),
      onEmpty: Container(height: 100, child: Center(child: Text('Empty'))),
    );

    /*return Container(
      height: 180,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return MyTotalTile(item: list[index]);
        },
      ),
    );*/

    /*return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          MyTotalTile(),
          MyTotalTile(),
          MyTotalTile(),
          MyTotalTile(),
        ],
      ),
    );*/
  }

  _yarnStock() {
    /*if (controller.yarStockLoading) {
      return Center(child: CircularProgressIndicator());
    }*/
    return Visibility(
      visible: controller.yarnStockList.isNotEmpty,
      child: Card(
        margin: EdgeInsets.all(16),
        child: Container(
          padding: EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Yarn Stock',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Divider(),
              Table(children: [
                TableRow(children: [
                  Text(
                    'Yarn Name',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF5654D8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Status',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF5654D8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Stock',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF5654D8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
                TableRow(children: [
                  SizedBox(height: 4),
                  SizedBox(height: 4),
                  SizedBox(height: 4),
                ]),
                ...controller.yarnStockList.map((item) {
                  return TableRow(children: [
                    Text(
                      '${item.name}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF696969),
                      ),
                    ),
                    Text(
                      '${item.status}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF696969),
                      ),
                    ),
                    Text(
                      '${item.stockIn}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF696969),
                      ),
                    ),
                  ]);
                }),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  _warpStock() {
    return Visibility(
      visible: controller.warpStockList.isNotEmpty,
      child: Card(
        margin: EdgeInsets.all(16),
        child: Container(
          padding: EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Warp Stock',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Divider(),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    Text(
                      'S.NO',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF5654D8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Warp Design',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF5654D8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Stock',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF5654D8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    SizedBox(height: 4),
                    SizedBox(height: 4),
                    SizedBox(height: 4),
                  ]),
                  ...controller.warpStockList.map((item) {
                    return TableRow(children: [
                      Text(
                        '${item.id}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF696969),
                        ),
                      ),
                      Text(
                        '${item.design_name}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF696969),
                        ),
                      ),
                      Text(
                        '${item.total_ends}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF696969),
                        ),
                      ),
                    ]);
                  }),
                ],
              ),
              /*DataTable(
                dividerThickness: 0.0,
                sortColumnIndex: 0,
                sortAscending: true,
                columns: <DataColumn>[
                  DataColumn(
                      label: Text(
                    "S.NO",
                    style: TextStyle(color: Color(0xFF5654D8)),
                  )),
                  DataColumn(
                      label: Text("Warp Design",
                          style: TextStyle(color: Color(0xFF5654D8)))),
                  DataColumn(
                      label: Text("Stock",
                          style: TextStyle(color: Color(0xFF5654D8)))),
                ],
                rows: controller.warpStockList.map(
                  (user) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            '${user.id}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${user.design_name}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${user.total_ends}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    );
                  },
                ).toList(),
              ),*/
            ],
          ),
        ),
      ),
    );
  }

/* _chart() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Container(
        color: Colors.white,
        width: Get.width,
        padding: EdgeInsets.all(16),
        child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 12, bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Product Sales Analysis',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          MyDropdownButtonFormField(
                            onChanged: (value) {
                              controller.saleAnalysis({'year': '${value}'});
                            },
                            controller: yearController,
                            hintText: "",
                            items: Constants.YEARS,
                          ),
                        ],
                      ),
                      controller.salesAnalysisList.isNotEmpty ? Text(
                        '₹${controller.productSales}',
                        style: TextStyle(),
                      ) : Container(),
                    ],
                  ),
                ),
                controller.salesAnalysisList.isNotEmpty
                    ? BarChartGraph(
                        list: controller.salesAnalysisList.toList(),
                      )
                    : Container(
                        height: 200,
                      ),
              ],
            )),
      ),
    );
  }*/
}
