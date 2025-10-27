import 'package:abtxt/view/basics/ledger_role/add_ledger_role.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/LedgerRole.dart';
import 'ledger_role_controller.dart';

List<LedgerRole> paginatedOrders = [];
LedgerRoleDataSource dataSource = LedgerRoleDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class LedgerRoles extends StatefulWidget {
  const LedgerRoles({Key? key}) : super(key: key);
  static const String routeName = '/ledger_role';

  @override
  State<LedgerRoles> createState() => _State();
}

class _State extends State<LedgerRoles> {
  late LedgerRoleController controller;
  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = LedgerRoleDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LedgerRoleController>(builder: (controller) {
      this.controller = controller;
      return Scaffold(
        appBar: AppBar(
          title: Text('Basic Info / Ledger Role'),
          centerTitle: false,
          elevation: 0,
          actions: [
            ElevatedButton.icon(
              onPressed: () async {
                var item = await Get.toNamed(AddLedgerRole.routeName);
                dataSource.notifyListeners();
              },
              icon: Icon(Icons.add),
              label: Text('Add'), // <-- Text
            ),
            SizedBox(width: 15)
          ],
        ),
        body: LayoutBuilder(builder: (context, constraint) {
          return Column(
            children: [
              SizedBox(
                height: constraint.maxHeight - 60.0,
                width: constraint.maxWidth,
                child: _buildDataGrid(constraint),
              ),
              Container(
                height: 60.0,
                child: Obx(
                  () => SfDataPager(
                    delegate: dataSource,
                    pageCount: totalPage.ceil().toDouble(),
                    direction: Axis.horizontal,
                  ),
                ),
              ),
            ],
          );
        }),
      );
    });
  }

  Widget _buildDataGrid(BoxConstraints constraint) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: const Color(0xFFF4EAFF),
        gridLineStrokeWidth: 0.1,
        gridLineColor: Color(0xFF5700BC),
      ),
      child: SfDataGrid(
        allowFiltering: true,
        gridLinesVisibility: GridLinesVisibility.vertical,
        source: dataSource,
        columnWidthMode: ColumnWidthMode.fill,
        columns: <GridColumn>[
          GridColumn(
            width: 100,
            columnName: 'id',
            label: Center(child: Text('ID')),
          ),
          GridColumn(
            columnName: 'name',
            label: Center(child: Text('Name')),
          ),
          GridColumn(
            columnName: 'button',
            label: Center(child: Text('Action')),
          ),
        ],
      ),
    );
  }
}

class LedgerRoleDataSource extends DataGridSource {
  LedgerRoleDataSource() {
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
        alignment: Alignment.center,
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
                    await Get.toNamed(AddLedgerRole.routeName,
                        arguments: {"item": item});
                    dataSource.notifyListeners();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    var id = '${row.getCells()[0].value.toString()}';
                    LedgerRoleController controller = Get.find();
                    await controller.delete(id);
                    dataSource.notifyListeners();
                  },
                ),
              ],
            );
          } else {
            return Text(e.value.toString());
          }
        }),
      );
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (newPageIndex < totalPage) {
      LedgerRoleController controller = Get.find();
      var result = await controller.ledgerRoles(
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
        DataGridCell(columnName: 'name', value: dataGridRow.name),
        DataGridCell(columnName: 'button', value: null),
      ]);
    }).toList(growable: false);
  }
}
