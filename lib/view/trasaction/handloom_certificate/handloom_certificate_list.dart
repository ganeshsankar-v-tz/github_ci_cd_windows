import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/handloom_certificate_model.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';
import 'add_handloom_certificate.dart';
import 'handloom_certificate_controller.dart';

List<HandloomCertificateModel> paginatedOrders = [];
HandloomDataSource dataSource = HandloomDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class HandLoomList extends StatefulWidget {
  const HandLoomList({Key? key}) : super(key: key);
  static const String routeName = '/handloom_certificate_list';

  @override
  State<HandLoomList> createState() => _State();
}

class _State extends State<HandLoomList> {
  late HandLoomController controller;

  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = HandloomDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandLoomController>(builder: (controller) {
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
            'Add', () => Get.toNamed(AddHandloomCertificate.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Transaction / HandLoom Certificate '),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item = await Get.toNamed(AddHandloomCertificate.routeName);
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
                  columnName: 'date',
                  label: const MyDataGridHeader(title: 'Date'),
                ),
                GridColumn(
                  columnName: 'customer',
                  label: const MyDataGridHeader(title: 'Customer'),
                ),
                GridColumn(
                  columnName: 'LLRRNo',
                  label: const MyDataGridHeader(title: 'LR / RR No'),
                ),
                GridColumn(
                  columnName: 'netAmount',
                  label: const MyDataGridHeader(title: 'Net. Amount (Rs)'),
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
                await Get.toNamed(AddHandloomCertificate.routeName,
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

class HandloomDataSource extends DataGridSource {
  HandloomDataSource() {
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
          return Text(e.value.toString(), overflow: TextOverflow.ellipsis);
        }),
        //child: Text(e.value.toString()),
      );
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (newPageIndex < totalPage) {
      HandLoomController controller = Get.find();
      var result = await controller.handloom(
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
        DataGridCell(columnName: 'date', value: dataGridRow.dCDate),
        DataGridCell(columnName: 'customer', value: dataGridRow.customerName),
        DataGridCell(columnName: 'LLRRNo', value: dataGridRow.lrRrNo),
        DataGridCell(
            columnName: 'netAmount', value: dataGridRow.totalNetAmount),
      ]);
    }).toList(growable: false);
  }
}
