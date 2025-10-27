import 'package:abtxt/view/trasaction/product_return_from_customer/product_return_from_customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/ProductReturnFromCustomerModel.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';
import 'add_product_return_from_customer.dart';

List<ProductReturnFromCustomerModel> paginatedOrders = [];
MyDataSource dataSource = MyDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class ProductReturnFromCustomer extends StatefulWidget {
  const ProductReturnFromCustomer({Key? key}) : super(key: key);
  static const String routeName = '/product_return_from_customer';

  @override
  State<ProductReturnFromCustomer> createState() => _State();
}

class _State extends State<ProductReturnFromCustomer> {
  late ProductReturnFromCustomerController controller;
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
    return GetBuilder<ProductReturnFromCustomerController>(
        builder: (controller) {
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
            'Add', () => Get.toNamed(AddProductReturnFromCustomer.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Transaction / Product Return From Customer'),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item =
                      await Get.toNamed(AddProductReturnFromCustomer.routeName);
                  dataSource.notifyListeners();
                },
                icon: const Icon(Icons.add),
                label: const Text('ADD'), // <-- Text
              ),
              const SizedBox(
                width: 15,
              )
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
                columnName: 'customerName',
                label: const MyDataGridHeader(title: 'Customer Name'),
              ),
              GridColumn(
                columnName: 'dCNo',
                label: const MyDataGridHeader(title: 'D.C No.'),
              ),
              GridColumn(
                columnName: 'details',
                label: const MyDataGridHeader(title: 'Details'),
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
              await Get.toNamed(AddProductReturnFromCustomer.routeName,
                  arguments: {"item": item});
              dataSource.notifyListeners();
            },
          ),
        ),
      );
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
        padding: const EdgeInsets.all(8),
        child: LayoutBuilder(builder: (context, constraints) {
          return Text(e.value.toString(), overflow: TextOverflow.ellipsis);
        }),
      );
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (newPageIndex < totalPage) {
      ProductReturnFromCustomerController controller = Get.find();
      var result = await controller.paginatedList(
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
        DataGridCell(columnName: 'date', value: dataGridRow.dcDate),
        DataGridCell(
            columnName: 'customerName', value: dataGridRow.customerName),
        DataGridCell(columnName: 'dCNo', value: dataGridRow.dcNo),
        DataGridCell(columnName: 'details', value: dataGridRow.details),
      ]);
    }).toList(growable: false);
  }
}
