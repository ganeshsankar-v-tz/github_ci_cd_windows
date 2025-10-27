import 'package:abtxt/model/YarnOpeningStockResponse.dart';
import 'package:abtxt/view/basics/yarn_opening_stock/add_yarn_opening_stock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';
import 'yarn_opening_stock_controller.dart';

List<YarnOpeningStockModel> paginatedOrders = [];
YarnOpeningStockDataSource dataSource = YarnOpeningStockDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class YarnOpeningStock extends StatefulWidget {
  const YarnOpeningStock({Key? key}) : super(key: key);
  static const String routeName = '/yarn_stock';

  @override
  State<YarnOpeningStock> createState() => _State();
}

class _State extends State<YarnOpeningStock> {
  late YarnOpeningStockController controller;
  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = YarnOpeningStockDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnOpeningStockController>(builder: (controller) {
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
            'Add', () => Get.toNamed(AddYarnOpeningStock.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text('Basic Info / Yarn Opening Stock'),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item = await Get.toNamed(AddYarnOpeningStock.routeName);
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
                columnName: 'created_at',
                label: const MyDataGridHeader(title: 'Date'),
              ),
              GridColumn(
                columnName: 'yarn_name',
                label: const MyDataGridHeader(title: 'Yarn Name'),
              ),
              GridColumn(
                columnName: 'colour_name',
                label: const MyDataGridHeader(title: 'Color Name'),
              ),
              GridColumn(
                columnName: 'total_qty',
                label: const MyDataGridHeader(title: 'Quantity'),
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
              await Get.toNamed(AddYarnOpeningStock.routeName,
                  arguments: {"item": item});
              dataSource.notifyListeners();
            },
          ),
        ),
      );
    });
  }
}

class YarnOpeningStockDataSource extends DataGridSource {
  YarnOpeningStockDataSource() {
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
                await Get.toNamed(AddYarnOpeningStock.routeName,
                    arguments: {"item": item});
                dataSource.notifyListeners();
              },
              onDeletePressed: () async {
                var id = row.getCells()[0].value.toString();
                YarnOpeningStockController controller = Get.find();
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
      YarnOpeningStockController controller = Get.find();
      var result = await controller.YarOpeningStock(
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
            columnName: 'created_at',
            value: dataGridRow.createdAt),
        DataGridCell(columnName: 'yarn_name', value: dataGridRow.yarnName),
        DataGridCell(columnName: 'color_name', value: dataGridRow.colourName),
        DataGridCell(columnName: 'total_qty', value: dataGridRow.totalQty),
      ]);
    }).toList(growable: false);
  }
}
