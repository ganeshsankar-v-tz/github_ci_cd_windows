import 'package:abtxt/model/RetailSaleModel.dart';
import 'package:abtxt/view/trasaction/retail_sale/add_retail_sale.dart';
import 'package:abtxt/view/trasaction/retail_sale/retail_sale_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';

List<RetailSaleModel> paginatedOrders = [];
RetailSaleDataSource dataSource = RetailSaleDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class RetailSale extends StatefulWidget {
  const RetailSale({Key? key}) : super(key: key);
  static const String routeName = '/retail_sale';

  @override
  State<RetailSale> createState() => _State();
}

class _State extends State<RetailSale> {
  late RetailSaleController controller;

  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = RetailSaleDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RetailSaleController>(builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
          KeyAction(
            LogicalKeyboardKey.keyN,
            'Add', () => Get.toNamed(AddRetailSale.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Transaction / Retail Sale'),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item = await Get.toNamed(AddRetailSale.routeName);
                  dataSource.notifyListeners();
                },
                icon: const Icon(Icons.add),
                label: const Text('ADD'), // <-- Text
              ),
              const SizedBox(width: 15)
            ],
          ),
          body: MySFDataGridTable(
            columns: [
              GridColumn(
                width: 80,
                columnName: 'id',
                label: const MyDataGridHeader(title: 'ID'),
              ),
              GridColumn(
                width: 120,
                columnName: 'Date',
                label: const MyDataGridHeader(title: 'Date'),
              ),
              GridColumn(
                columnName: 'customer',
                label: const MyDataGridHeader(title: 'Customer'),
              ),
              GridColumn(
                columnName: 'salesNo',
                label: const MyDataGridHeader(title: 'Sales No'),
              ),
              GridColumn(
                columnName: 'cashBankAc',
                label: const MyDataGridHeader(title: 'Cash / Bank A/c'),
              ),
              GridColumn(
                columnName: 'salesAc',
                label: const MyDataGridHeader(title: 'Sales A/c'),
              ),
              GridColumn(
                columnName: 'cellNo',
                label: const MyDataGridHeader(title: 'Cell No'),
              ),
              GridColumn(
                columnName: 'amount',
                label: const MyDataGridHeader(title: 'Amount (Rs)'),
              ),
            ],
            source: dataSource,
            totalPage: totalPage,
            rowsPerPage: _rowsPerPage,
            isLoading: controller.status.isLoading,
            onRowsPerPageChanged: (var page) {
              _rowsPerPage = page;
              dataSource.notifyListeners();
            },
            onRowSelected: (index) async {
              var item = paginatedOrders[index];
              await Get.toNamed(AddRetailSale.routeName,
                  arguments: {"item": item});
              dataSource.notifyListeners();
            },
          ),
        ),
      );
    });
  }
}

class RetailSaleDataSource extends DataGridSource {
  RetailSaleDataSource() {
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
      RetailSaleController controller = Get.find();
      var result = await controller.retailSale(
          page: '${newPageIndex + 1}', limit: _rowsPerPage);
      paginatedOrders = result['list'];
      totalPage = result['totalPage'];
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      paginatedOrders = [];
    }

    return true;
  }

  void buildPaginatedDataGridRows() {
    dataGridRows = paginatedOrders.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'id', value: dataGridRow.id),
        DataGridCell(columnName: 'Date', value: dataGridRow.salesDate),
        DataGridCell(columnName: 'customer', value: dataGridRow.coustomerName),
        DataGridCell(columnName: 'salesNo', value: dataGridRow.salesNo),
        DataGridCell(columnName: 'cashBankAc', value: dataGridRow.cash),
        DataGridCell(columnName: 'salesAc', value: dataGridRow.accountName),
        DataGridCell(columnName: 'cellNo', value: dataGridRow.cellNo),
        DataGridCell(columnName: 'amount', value: dataGridRow.totalAmount),
      ]);
    }).toList(growable: false);
  }
}
