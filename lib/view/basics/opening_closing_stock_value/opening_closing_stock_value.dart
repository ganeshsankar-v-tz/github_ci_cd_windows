import 'package:abtxt/view/basics/opening_closing_stock_value/add_opening_closing_stock_value.dart';
import 'package:abtxt/view/basics/opening_closing_stock_value/opening_closing_stock_value_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/OpeningClosingStockValueModel.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridTable.dart';

List<OpeningClosingStockValueModel> paginatedOrders = [];
OpeningClosingStockValueDataSource dataSource =
    OpeningClosingStockValueDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class OpeningClosingStockValue extends StatefulWidget {
  const OpeningClosingStockValue({Key? key}) : super(key: key);
  static const String routeName = '/OpeningClosingStockValue';

  @override
  State<OpeningClosingStockValue> createState() => _State();
}

class _State extends State<OpeningClosingStockValue> {
  late OpeningClosingStockValueController controller;
  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = OpeningClosingStockValueDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OpeningClosingStockValueController>(
        builder: (controller) {
      this.controller = controller;
      return Scaffold(
        appBar: AppBar(
          title: Text('Basic Info / Opening Closing Stock Value'),
          centerTitle: false,
          elevation: 0,
          actions: [
            ElevatedButton.icon(
              onPressed: () async {
                var item =
                    await Get.toNamed(AddOpeningClosingStockValue.routeName);
                dataSource.notifyListeners();
              },
              icon: Icon(Icons.add),
              label: Text('ADD'), // <-- Text
            ),
            SizedBox(
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
              columnName: 'a/c Session',
              label: const MyDataGridHeader(title: 'A / C Session'),
            ),
            GridColumn(
              columnName: 'Firm',
              label: const MyDataGridHeader(title: 'Firm'),
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
            await Get.toNamed(AddOpeningClosingStockValue.routeName,
                arguments: {"item": item});
            dataSource.notifyListeners();
          },
        ),
      );
    });
  }
}

class OpeningClosingStockValueDataSource extends DataGridSource {
  OpeningClosingStockValueDataSource() {
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
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    var id = row.getCells()[0].value;
                    int index = paginatedOrders
                        .indexWhere((element) => element.id == id);
                    var item = paginatedOrders[index];
                    await Get.toNamed(AddOpeningClosingStockValue.routeName,
                        arguments: {"item": item});
                    dataSource.notifyListeners();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    var id = '${row.getCells()[0].value.toString()}';
                    OpeningClosingStockValueController controller = Get.find();
                    await controller.deleteOpeningClosingStock(id);
                    //dataSource.handlePageChange(0, 0);
                    dataSource.notifyListeners();
                  },
                ),
              ],
            );
          } else {
            return Text(e.value.toString());
          }
        }),
        //child: Text(e.value.toString()),
      );
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (newPageIndex < totalPage) {
      OpeningClosingStockValueController controller = Get.find();
      var result = await controller.OpeningClosingStock(
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
            columnName: 'Date', value: dataGridRow.createdAt),
        DataGridCell(columnName: 'a/c Session', value: dataGridRow.acSession),
        DataGridCell(columnName: 'Firm', value: dataGridRow.firmName),
      ]);
    }).toList(growable: false);
  }
}
