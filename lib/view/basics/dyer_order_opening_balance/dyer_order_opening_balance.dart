import 'package:abtxt/model/dyer_order_opening_balance_model.dart';
import 'package:abtxt/view/basics/dyer_order_opening_balance/add_dyer_order_opening_balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';
import 'dyer_order_opening_balance_controller.dart';

List<DyerOrderOpeningBalanceModel> paginatedOrders = [];
DyerOrderOpeningBalanceDataSource dataSource =
    DyerOrderOpeningBalanceDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class DyerOrderOpeningBalance extends StatefulWidget {
  const DyerOrderOpeningBalance({Key? key}) : super(key: key);
  static const String routeName = '/dyer_order';

  @override
  State<DyerOrderOpeningBalance> createState() => _State();
}

class _State extends State<DyerOrderOpeningBalance> {
  late DyerOrderOpeningBalanceController controller;
  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = DyerOrderOpeningBalanceDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DyerOrderOpeningBalanceController>(builder: (controller) {
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
            'Add', () => Get.toNamed(AddDyerOrderOpeningBalance.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Basic Info / Dyer Order Opening Balance'),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item =
                      await Get.toNamed(AddDyerOrderOpeningBalance.routeName);
                  dataSource.notifyListeners();
                },
                icon: const Icon(Icons.add),
                label: const Text('ADD'), // <-- Text
              ),
              const SizedBox(width: 15)
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: MySFDataGridTable(
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
                  columnName: 'dyer_name',
                  label: const MyDataGridHeader(title: 'Dyer Name'),
                ),
                GridColumn(
                  columnName: 'yarn_name',
                  label: const MyDataGridHeader(title: 'Yarn Name'),
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
                await Get.toNamed(AddDyerOrderOpeningBalance.routeName,
                    arguments: {"item": item});
                dataSource.notifyListeners();
              },
            ),
          ),
        ),
      );
    });
  }
}

class DyerOrderOpeningBalanceDataSource extends DataGridSource {
  DyerOrderOpeningBalanceDataSource() {
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
                await Get.toNamed(AddDyerOrderOpeningBalance.routeName,
                    arguments: {"item": item});
                dataSource.notifyListeners();
              },
              onDeletePressed: () async {
                var id = row.getCells()[0].value.toString();
                DyerOrderOpeningBalanceController controller = Get.find();
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
      DyerOrderOpeningBalanceController controller = Get.find();
      var result = await controller.GetDyerOrderOpen(
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
          value: dataGridRow.createdAt,
        ),
        DataGridCell(columnName: 'dyer_name', value: dataGridRow.dyerName),
        DataGridCell(columnName: 'yarn_name', value: dataGridRow.yarnName),
        DataGridCell(columnName: 'record_no', value: dataGridRow.recordNo),
        DataGridCell(columnName: 'details', value: dataGridRow.details),
      ]);
    }).toList(growable: false);
  }
}
