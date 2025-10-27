import 'package:abtxt/model/EmptyBeamModel.dart';
import 'package:abtxt/view/basics/empty_beam/add_empty.dart';
import 'package:abtxt/view/trasaction/empty_beam_bobbin_delivery_inward/add_empty_beam_bobbin_delivery_inward.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';
import 'empty_beam_controller.dart';

List<EmptyBeamModel> paginatedOrders = [];
LedgerDataSource dataSource = LedgerDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class empty_beam extends StatefulWidget {
  const empty_beam({Key? key}) : super(key: key);
  static const String routeName = '/empty';

  @override
  State<empty_beam> createState() => _State();
}

class _State extends State<empty_beam> {
  late EmptyBeamController controller;

  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = LedgerDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmptyBeamController>(builder: (controller) {
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
            'Add', () =>  Get.toNamed(add_empty.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
                'Basic Info / Empty Beam,Bobbin,Sheet Balance from Warper,Customer Supplier'),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item = await Get.toNamed(add_empty.routeName);
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
                columnName: 'record_no',
                label: const MyDataGridHeader(title: 'Record No'),
              ),
              GridColumn(
                columnName: 'ledger_name',
                label: const MyDataGridHeader(title: 'Name'),
              ),
              GridColumn(
                columnName: 'beam',
                label: const MyDataGridHeader(title: 'Beam'),
              ),
              GridColumn(
                columnName: 'bobbin',
                label: const MyDataGridHeader(title: 'Bobbin'),
              ),
              GridColumn(
                columnName: 'sheet',
                label: const MyDataGridHeader(title: 'Sheet'),
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
              await Get.toNamed(add_empty.routeName,
                  arguments: {"item": item});
              dataSource.notifyListeners();
            },
          ),
        ),
      );
    });
  }
}

class LedgerDataSource extends DataGridSource {
  LedgerDataSource() {
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
                await Get.toNamed(add_empty.routeName,
                    arguments: {"item": item});
                dataSource.notifyListeners();
              },
              onDeletePressed: () async {
                var id = row.getCells()[0].value.toString();
                EmptyBeamController controller = Get.find();
                await controller.deleteEmpty(id);
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
      EmptyBeamController controller = Get.find();
      var result = await controller.empty(
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
        DataGridCell(columnName: 'record_no', value: dataGridRow.recordNo),
        DataGridCell(columnName: 'ledger_name', value: dataGridRow.ledgerName),
        DataGridCell(columnName: 'beam', value: dataGridRow.beam),
        DataGridCell(columnName: 'bobbin', value: dataGridRow.bobbin),
        DataGridCell(columnName: 'sheet', value: dataGridRow.sheet),
        DataGridCell(columnName: 'details', value: dataGridRow.details),]);
    }).toList(growable: false);
  }
}
