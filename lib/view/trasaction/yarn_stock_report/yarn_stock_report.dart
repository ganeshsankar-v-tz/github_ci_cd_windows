import 'dart:convert';

import 'package:abtxt/model/YarnStockReportModel.dart';
import 'package:abtxt/view/trasaction/yarn_stock_report/yarn_stock_report2.dart';
import 'package:abtxt/view/trasaction/yarn_stock_report/yarn_stock_report_controller.dart';
import 'package:abtxt/view/trasaction/yarn_stock_report/yarn_stockreport_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridTable.dart';

List<Map<String, dynamic>> paginatedOrders = [];
MyDataSource dataSource = MyDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class YarnStockReport extends StatefulWidget {
  const YarnStockReport({Key? key}) : super(key: key);
  static const String routeName = '/YarnStockReport';

  @override
  State<YarnStockReport> createState() => _State();
}

class _State extends State<YarnStockReport> {
  late YarnStockReportController controller;

  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = MyDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnStockReportController>(builder: (controller) {
      this.controller = controller;
      return Scaffold(
          appBar: AppBar(
            title: const Text('Transaction / Yarn Stock Report'),
            centerTitle: false,
            elevation: 0,
          ),
          body: MySFDataGridTable(
            columns: [
              GridColumn(
                columnName: 'yarn_name',
                label: const MyDataGridHeader(title: 'Yarn Name'),
              ),
              GridColumn(
                columnName: 'stock',
                label: const MyDataGridHeader(title: 'Stock'),
              ),
              GridColumn(
                columnName: 'office',
                label: const MyDataGridHeader(title: 'office'),
              ),
              GridColumn(
                columnName: 'godown',
                label: const MyDataGridHeader(title: 'godown'),
              ),
              GridColumn(
                columnName: 'inprogress',
                label: const MyDataGridHeader(title: 'In Progress'),
              ),
              GridColumn(
                columnName: 'sale',
                label: const MyDataGridHeader(title: 'Sale'),
              ),
              GridColumn(
                columnName: 'sale_return',
                label: const MyDataGridHeader(title: 'Sale Retrun'),
              ),
              GridColumn(
                columnName: 'purchase',
                label: const MyDataGridHeader(title: 'Purchase'),
              ),
              GridColumn(
                columnName: 'purchase_return',
                label: const MyDataGridHeader(title: 'Purchase Return'),
              ),
            ],
            source: dataSource,
            totalPage: totalPage,
            rowsPerPage: _rowsPerPage,
            isLoading: controller.status.isLoading,
            onRowsPerPageChanged: (var page) {
              _rowsPerPage = page!;
              dataSource.notifyListeners();
            },
            onRowSelected: (index) async {
              /*var item = paginatedOrders[index];
              await Get.toNamed(YarnStockReportHistory.routeName, arguments: {"item": item});
              dataSource.notifyListeners();*/
              Get.to(YarnStockReport2());
            },
          ));
    });
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource() {
    buildPaginatedDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(builder: (context, constraints) {
          return Text(e.value.toString(), overflow: TextOverflow.ellipsis);
        }),
      );
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (newPageIndex < totalPage) {
      YarnStockReportController controller = Get.find();
      var result = await controller.yarnStock(
          page: '${newPageIndex + 1}', limit: _rowsPerPage);
      //paginatedOrders = result['list'];
      //var dd = '{"yarn_id":68,"yarn_name":"110 Karishma - RED","stock":1000,"sales_details":300,"progroess_details":0,"inward_total":0,"delivery_total":0,"stock_total":1000}';
      //var item = YarnStockReportModel.fromJson(jsonDecode(dd) as Map<String, dynamic>);
      var dd = {
        "yarn_id": 68,
        "yarn_name": "110 Karishma - RED",
        "stock": 1200,
        "office": 500,
        "godown": 700,
        "inprogress": 1500,
        "sale": 1050,
        "sale_return": 0,
        "purchase": 5450,
        "purchase_return": 500,
      };

      paginatedOrders = [dd];
      // totalPage = result['totalPage'];
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      paginatedOrders = [];
    }

    return true;
  }

  void buildPaginatedDataGridRows() {
    dataGridRows = paginatedOrders.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'yarn_name', value: e['yarn_name']),
        DataGridCell(columnName: 'stock', value: e['stock']),
        DataGridCell(columnName: 'office', value: e['office']),
        DataGridCell(columnName: 'godown', value: e['godown']),
        DataGridCell(columnName: 'inprogress', value: e['inprogress']),
        DataGridCell(columnName: 'sale', value: e['sale']),
        DataGridCell(columnName: 'sale_return', value: e['sale_return']),
        DataGridCell(columnName: 'purchase', value: e['purchase']),
        DataGridCell(columnName: 'purchase_return', value: e['purchase_return']),
      ]);
    }).toList(growable: false);
  }
}
