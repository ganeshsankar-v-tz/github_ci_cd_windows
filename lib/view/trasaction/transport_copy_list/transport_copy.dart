import 'package:abtxt/model/TransportCopyModel.dart';
import 'package:abtxt/view/trasaction/transport_copy_list/add_transport_copy_list.dart';
import 'package:abtxt/view/trasaction/transport_copy_list/transport_copy_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';

List<TransportCopyModel> paginatedOrders = [];
MyDataSource dataSource = MyDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class TransportCopy extends StatefulWidget {
  const TransportCopy({Key? key}) : super(key: key);
  static const String routeName = '/TransportCopy';

  @override
  State<TransportCopy> createState() => _State();
}

class _State extends State<TransportCopy> {
  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = MyDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransportCopyController>(builder: (controller) {
      return KeyboardWidget(
bindings: [
  KeyAction(
    LogicalKeyboardKey.keyQ,
    'Close', () => Get.back(),
    isControlPressed: true,
  ),
  KeyAction(
    LogicalKeyboardKey.keyN,
    'Add', () =>Get.toNamed(AddTransportCopy.routeName),
    isControlPressed: true,
  ),
],        child: Scaffold(
          appBar: AppBar(
            title: const Text('Transaction / Transport Copy'),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item = await Get.toNamed(AddTransportCopy.routeName);
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
                columnName: 'Date',
                label: const MyDataGridHeader(title: 'Date'),
              ),
              GridColumn(
                columnName: 'Role',
                label: const MyDataGridHeader(title: 'Role'),
              ),
              GridColumn(
                columnName: 'From',
                label: const MyDataGridHeader(title: 'From'),
              ),
              GridColumn(
                columnName: 'To',
                label: const MyDataGridHeader(title: 'To'),
              ),
              GridColumn(
                columnName: 'InvoiceNo',
                label: const MyDataGridHeader(title: 'Invoice No'),
              ),
              GridColumn(
                columnName: 'InvoiceDate',
                label: const MyDataGridHeader(title: 'Invoice Date'),
              ),
              GridColumn(
                columnName: 'NoOfQty',
                label: const MyDataGridHeader(title: 'No of Qty'),
              ),
              GridColumn(
                columnName: 'Bundles',
                label: const MyDataGridHeader(title: 'Bundles'),
              ),
              GridColumn(
                columnName: 'Amount',
                label: const MyDataGridHeader(title: 'Total Amount (Rs)'),
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
              await Get.toNamed(AddTransportCopy.routeName,
                  arguments: {"item": item});
              dataSource.notifyListeners();
            },
          ),
        ),
      );
    });
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource() {
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
          padding: const EdgeInsets.all(8),
          child: LayoutBuilder(builder: (context, constraints) {
            return Text(e.value.toString(), overflow: TextOverflow.ellipsis);
          }),
        );
      }).toList(),
    );
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (newPageIndex < totalPage) {
      TransportCopyController controller = Get.find();
      var result = await controller.transportCopy(
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
        DataGridCell(columnName: 'Date', value: dataGridRow.date),
        DataGridCell(columnName: 'Role', value: dataGridRow.ledgerRoleName),
        DataGridCell(columnName: 'From', value: dataGridRow.firmName),
        DataGridCell(columnName: 'To', value: dataGridRow.toLedgerName),
        DataGridCell(columnName: 'InvoiceNo', value: dataGridRow.invoiceNo),
        DataGridCell(columnName: 'InvoiceDate', value: dataGridRow.invoiceDate),
        DataGridCell(columnName: 'NoOfQty', value: dataGridRow.noOfQuantity),
        DataGridCell(columnName: 'Bundles', value: dataGridRow.bundle),
        DataGridCell(columnName: 'Amount', value: dataGridRow.totalAmount),
      ]);
    }).toList(growable: false);
  }
}
