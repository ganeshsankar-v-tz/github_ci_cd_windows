import 'package:abtxt/model/EmptyBeamBobbinDeliveryInwardModel.dart';
import 'package:abtxt/view/trasaction/empty_beam_bobbin_delivery_inward/add_empty_beam_bobbin_delivery_inward.dart';
import 'package:abtxt/view/trasaction/empty_beam_bobbin_delivery_inward/empty_beam_bobbin_delivery_inward_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';

List<EmptyBeamBobbinDeliveryInwardModel> paginatedOrders = [];
EmptyBeamBobbinDeliveryInwardDataSource dataSource =
    EmptyBeamBobbinDeliveryInwardDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class EmptyBeamBobbinDeliveryInward extends StatefulWidget {
  const EmptyBeamBobbinDeliveryInward({Key? key}) : super(key: key);
  static const String routeName = '/empty_beam_bobbin_delivery_inward';

  @override
  State<EmptyBeamBobbinDeliveryInward> createState() => _State();
}

class _State extends State<EmptyBeamBobbinDeliveryInward> {
  late EmptyBeamBobbinDeliveryInwardController controller;
  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = EmptyBeamBobbinDeliveryInwardDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmptyBeamBobbinDeliveryInwardController>(
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
            'Add', () => Get.toNamed(
              AddEmptyBeamBobbinDeliveryInward.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
                'Transaction / Empty (Beam, Bobbin) Delivery / Inward '),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item = await Get.toNamed(
                      AddEmptyBeamBobbinDeliveryInward.routeName);
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
                columnName: 'recordNo',
                label: const MyDataGridHeader(title: 'Record No'),
              ),
              GridColumn(
                columnName: 'entry',
                label: const MyDataGridHeader(title: 'Entry'),
              ),
              GridColumn(
                columnName: 'transactionType',
                label: const MyDataGridHeader(title: 'Transaction Type'),
              ),
              GridColumn(
                columnName: 'from',
                label: const MyDataGridHeader(title: 'From'),
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
              await Get.toNamed(AddEmptyBeamBobbinDeliveryInward.routeName,
                  arguments: {"item": item});
              dataSource.notifyListeners();
            },
          ),
        ),
      );
    });
  }
}

class EmptyBeamBobbinDeliveryInwardDataSource extends DataGridSource {
  EmptyBeamBobbinDeliveryInwardDataSource() {
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
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (newPageIndex < totalPage) {
      EmptyBeamBobbinDeliveryInwardController controller = Get.find();
      var result = await controller.emptyBeamBobbin(
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
        DataGridCell(columnName: 'date', value: dataGridRow.date),
        DataGridCell(columnName: 'recordNo', value: dataGridRow.recordNo),
        DataGridCell(columnName: 'entry', value: dataGridRow.entryType),
        DataGridCell(
            columnName: 'transactionType', value: dataGridRow.transactionType),
        DataGridCell(columnName: 'from', value: dataGridRow.from),
        DataGridCell(columnName: 'beam', value: dataGridRow.beam),
        DataGridCell(columnName: 'bobbin', value: dataGridRow.bobbin),
        DataGridCell(columnName: 'sheet', value: dataGridRow.sheet),
      ]);
    }).toList(growable: false);
  }
}
