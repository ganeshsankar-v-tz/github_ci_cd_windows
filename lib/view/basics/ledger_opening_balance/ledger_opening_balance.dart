import 'package:abtxt/model/ledger_opening_balance_model.dart';
import 'package:abtxt/view/basics/ledger_opening_balance/add_ledger_opening_balance.dart';
import 'package:abtxt/view/basics/ledger_opening_balance/ledger_opening_balance_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';

List<LedgerOpeningBalanceModel> paginatedOrders = [];
LedgerOpeningBalanceDataSource dataSource = LedgerOpeningBalanceDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class LedgerOpeningBalance extends StatefulWidget {
  const LedgerOpeningBalance({Key? key}) : super(key: key);
  static const String routeName = '/LedgerOpeningBalance';

  @override
  State<LedgerOpeningBalance> createState() => _State();
}

class _State extends State<LedgerOpeningBalance> {
  late LedgerOpeningBalanceController controller;
  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = LedgerOpeningBalanceDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LedgerOpeningBalanceController>(builder: (controller) {
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
            'Add', () => Get.toNamed(AddLedgerOpeningBalance.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Basic Info / Ledger Opening Balance'),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item = await Get.toNamed(AddLedgerOpeningBalance.routeName);
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
                columnName: 'created_at',
                label: const MyDataGridHeader(title: 'Date'),
              ),
              GridColumn(
                columnName: 'firm_name',
                label: const MyDataGridHeader(title: 'Firm'),
              ),
              GridColumn(
                columnName: 'ledger_role_name',
                label: const MyDataGridHeader(title: 'Role'),
              ),
              GridColumn(
                columnName: 'ledger_name',
                label: const MyDataGridHeader(title: 'Ledger Name'),
              ),
              GridColumn(
                columnName: 'account_type',
                label: const MyDataGridHeader(title: 'Account Type'),
              ),
              GridColumn(
                columnName: 'total_amount',
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
              await Get.toNamed(AddLedgerOpeningBalance.routeName,
                  arguments: {"item": item});
              dataSource.notifyListeners();
            },
          ),
        ),
      );
    });
  }
}

class LedgerOpeningBalanceDataSource extends DataGridSource {
  LedgerOpeningBalanceDataSource() {
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
                await Get.toNamed(AddLedgerOpeningBalance.routeName,
                    arguments: {"item": item});
                dataSource.notifyListeners();
              },
              onDeletePressed: () async {
                var id = row.getCells()[0].value.toString();
                LedgerOpeningBalanceController controller = Get.find();
                await controller.deleteLedgerOpening(id);
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
      LedgerOpeningBalanceController controller = Get.find();
      var result = await controller.ledgerOpeningBalance(
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
        DataGridCell(columnName: 'created_at', value: dataGridRow.date),
        DataGridCell(columnName: 'firm_name', value: dataGridRow.firmName),
        DataGridCell(
            columnName: 'ledger_role_name', value: dataGridRow.ledgerRoleName),
        DataGridCell(columnName: 'ledger_name', value: dataGridRow.ledgerName),
        DataGridCell(
            columnName: 'account_type', value: dataGridRow.accountTypeName),
        DataGridCell(
            columnName: 'total_amount', value: dataGridRow.totalAmount),
      ]);
    }).toList(growable: false);
  }
}
