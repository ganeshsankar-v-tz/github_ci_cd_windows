import 'package:abtxt/view/trasaction/warp_order/add_warp_order.dart';
import 'package:abtxt/view/trasaction/warp_order/warp_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/warp_order_model.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';

List<WarpsOrder> paginatedOrders = [];
WarpOrderDataSource dataSource = WarpOrderDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class WarpOrder extends StatefulWidget {
  const WarpOrder({Key? key}) : super(key: key);
  static const String routeName = '/WarpOrder';

  @override
  State<WarpOrder> createState() => _State();
}

class _State extends State<WarpOrder> {
  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = WarpOrderDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpOrderController>(builder: (controller) {
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
          KeyAction(
            LogicalKeyboardKey.keyN,
            'Add', () => Get.toNamed(AddWarpOrder.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Transaction / Warp Order'),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item = await Get.toNamed(AddWarpOrder.routeName);
                  dataSource.notifyListeners();
                },
                icon: Icon(Icons.add),
                label: Text('ADD'), // <-- Text
              ),
              SizedBox(width: 15)
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
                columnName: 'LedgerName',
                label: const MyDataGridHeader(title: 'Ledger Name'),
              ),
              GridColumn(
                columnName: 'WeaverName',
                label: const MyDataGridHeader(title: 'Weaver Name'),
              ),
              GridColumn(
                columnName: 'LoomNo',
                label: const MyDataGridHeader(title: 'Loom No'),
              ),
              GridColumn(
                columnName: 'ProductName',
                label: const MyDataGridHeader(title: 'Product Name'),
              ),
              GridColumn(
                columnName: 'WarpDesign',
                label: const MyDataGridHeader(title: 'Warp Design'),
              ),
              GridColumn(
                columnName: 'WarpColors',
                label: const MyDataGridHeader(title: 'Warp Colors'),
              ),
              GridColumn(
                width: 100,
                columnName: 'action',
                label: const MyDataGridHeader(title: 'Actions'),
                allowFiltering: false,
                allowSorting: false,
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
          ),
        ),
      );
    });
  }
}

class WarpOrderDataSource extends DataGridSource {
  WarpOrderDataSource() {
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
          if (e.columnName == 'button') {
            return MyEditDelete(
              onEditPressed: () async {
                var id = row.getCells()[0].value;
                int index =
                    paginatedOrders.indexWhere((element) => element.id == id);
                var item = paginatedOrders[index];
                await Get.toNamed(AddWarpOrder.routeName,
                    arguments: {"item": item});
                dataSource.notifyListeners();
              },
              onDeletePressed: () async {
                var id = row.getCells()[0].value.toString();
                WarpOrderController controller = Get.find();
                await controller.deletewarporders(id);
                dataSource.notifyListeners();
              },
            );
          } else {
            return Text(e.value.toString(), overflow: TextOverflow.ellipsis);
          }
        }),
        //child: Text(e.value.toString()),
      );
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (newPageIndex < totalPage) {
      WarpOrderController controller = Get.find();
      var result = await controller.warporders(
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
        DataGridCell(columnName: 'Id', value: dataGridRow.id),
        DataGridCell(columnName: 'Date', value: dataGridRow.orderDate),
        DataGridCell(columnName: 'LedgerName', value: dataGridRow.ledgerName),
        DataGridCell(columnName: 'WeaverName', value: dataGridRow.weaverName),
        DataGridCell(columnName: 'LoomNo', value: dataGridRow.loomNo),
        DataGridCell(columnName: 'ProductName', value: dataGridRow.productName),
        DataGridCell(columnName: 'WarpDesign', value: dataGridRow.warpDesign),
        DataGridCell(
            columnName: 'WarpColors', value: dataGridRow.warpColor?.warpColor),
        const DataGridCell(columnName: 'button', value: null),
      ]);
    }).toList(growable: false);
  }
}
