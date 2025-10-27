import 'package:abtxt/model/WarpOpeningStockModel.dart';
import 'package:abtxt/view/basics/warp_opening_stock/add_warp_opening_stock.dart';
import 'package:abtxt/view/basics/warp_opening_stock/warp_opening_stock_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';

List<WarpOpeningStockModel> paginatedOrders = [];
WarpOpeningStockDataSource dataSource = WarpOpeningStockDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class WarpOpeningStock extends StatefulWidget {
  const WarpOpeningStock({Key? key}) : super(key: key);
  static const String routeName = '/warp_opening_stock';

  @override
  State<WarpOpeningStock> createState() => _State();
}

class _State extends State<WarpOpeningStock> {
  late WarpOpeningStockController controller;
  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = WarpOpeningStockDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpOpeningStockController>(builder: (controller) {
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
            'Add', () => Get.toNamed(AddWarpOpeningStock.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Basic Info / Warp Opening Stock'),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item = await Get.toNamed(AddWarpOpeningStock.routeName);
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
                columnName: 'date',
                label: const MyDataGridHeader(title: 'Date'),
              ),
              GridColumn(
                columnName: 'warp_design_name',
                label: const MyDataGridHeader(title: 'Warp Design'),
              ),
              GridColumn(
                columnName: 'warp_type',
                label: const MyDataGridHeader(title: 'Warp Type'),
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
              await Get.toNamed(AddWarpOpeningStock.routeName,
                  arguments: {"item": item});
              dataSource.notifyListeners();
            },
          ),
        ),
      );
    });
  }
}

class WarpOpeningStockDataSource extends DataGridSource {
  WarpOpeningStockDataSource() {
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
        padding: EdgeInsets.all(8.0),
        child: LayoutBuilder(builder: (context, constraints) {
          if (e.columnName == 'button') {
            return MyEditDelete(
              onEditPressed: () async {
                var id = row.getCells()[0].value;
                int index =
                    paginatedOrders.indexWhere((element) => element.id == id);
                var item = paginatedOrders[index];
                await Get.toNamed(AddWarpOpeningStock.routeName,
                    arguments: {"item": item});
                dataSource.notifyListeners();
              },
              onDeletePressed: () async {
                var id = row.getCells()[0].value.toString();
                WarpOpeningStockController controller = Get.find();
                await controller.delete(id);
                dataSource.notifyListeners();
              },
            );
          } else {
            return Text(e.value.toString(), overflow: TextOverflow.ellipsis);
          }
        }),
      );
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (newPageIndex < totalPage) {
      WarpOpeningStockController controller = Get.find();
      var result = await controller.warpOpeningStock(
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
        DataGridCell(
          columnName: 'date',
          value: dataGridRow.date,
        ),
        DataGridCell(
            columnName: 'warp_design_name', value: dataGridRow.warpDesignName),
        DataGridCell(columnName: 'warp_type', value: dataGridRow.warpType),

      ]);
    }).toList(growable: false);
  }
}
