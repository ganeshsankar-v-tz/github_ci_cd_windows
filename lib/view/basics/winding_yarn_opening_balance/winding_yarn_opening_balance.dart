import 'package:abtxt/model/winding_yarn_opening_balance_model.dart';
import 'package:abtxt/view/basics/winding_yarn_opening_balance/add_winding_yarn_opening_balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';
import 'winding_yarn_opening_balance_controller.dart';

List<WindingYarnOpeningBalanceModel> paginatedOrders = [];
WindingYarnOpeningBalanceDataSource dataSource =
    WindingYarnOpeningBalanceDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class WindingYarnOpeningBalance extends StatefulWidget {
  const WindingYarnOpeningBalance({Key? key}) : super(key: key);
  static const String routeName = '/winding_yarn';

  @override
  State<WindingYarnOpeningBalance> createState() => _State();
}

class _State extends State<WindingYarnOpeningBalance> {
  late WindingYarnOpeningBalanceController controller;
  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = WindingYarnOpeningBalanceDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WindingYarnOpeningBalanceController>(
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
            'Add', () =>  Get.toNamed(AddWindingYarnOpeningBalance.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text('Basic Info / Winding Yarn Opening Balance'),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item =
                      await Get.toNamed(AddWindingYarnOpeningBalance.routeName);
                  dataSource.notifyListeners();
                },
                icon: Icon(Icons.add),
                label: const Text('ADD'), // <-- Text
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
                columnName: 'winder_name',
                label: const MyDataGridHeader(title: 'Winder Name'),
              ),
              GridColumn(
                columnName: 'record_no',
                label: const MyDataGridHeader(title: 'Record No'),
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
              await Get.toNamed(AddWindingYarnOpeningBalance.routeName,
                  arguments: {"item": item});
              dataSource.notifyListeners();
            },
          ),
        ),
      );
    });
  }
}

class WindingYarnOpeningBalanceDataSource extends DataGridSource {
  WindingYarnOpeningBalanceDataSource() {
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
                await Get.toNamed(AddWindingYarnOpeningBalance.routeName,
                    arguments: {"item": item});
                dataSource.notifyListeners();
              },
              onDeletePressed: () async {
                var id = row.getCells()[0].value.toString();
                WindingYarnOpeningBalanceController controller = Get.find();
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
      WindingYarnOpeningBalanceController controller = Get.find();
      var result = await controller.windingYarn(
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
        DataGridCell(columnName: 'winder_name', value: dataGridRow.winderName),
        DataGridCell(columnName: 'record_no', value: dataGridRow.recordNo),
        DataGridCell(columnName: 'details', value: dataGridRow.details),
      ]);
    }).toList(growable: false);
  }
}
