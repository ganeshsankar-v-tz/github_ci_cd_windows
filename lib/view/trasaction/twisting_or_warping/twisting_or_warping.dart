import 'package:abtxt/model/TwisterWarpingModel.dart';
import 'package:abtxt/view/trasaction/twisting_or_warping/add_twisting_warping.dart';
import 'package:abtxt/view/trasaction/twisting_or_warping/twisting_or_warping_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';

List<TwisterWarpingModel> paginatedOrders = [];
TwisterWarpingDataSource dataSource = TwisterWarpingDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class TwistingOrWarpingSheet extends StatefulWidget {
  const TwistingOrWarpingSheet({super.key});
  static const String routeName = '/twisting_or_warping';
  @override
  State<TwistingOrWarpingSheet> createState() => _TwistingOrWarpingSheetState();
}
//

class _TwistingOrWarpingSheetState extends State<TwistingOrWarpingSheet> {
  late TwistingOrWarpingController controller;
  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = TwisterWarpingDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwistingOrWarpingController>(builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyN,
            'Add', () =>Get.toNamed(add_twisting_warping.routeName),
            isControlPressed: true,
          ),
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Transaction / Twisting or Warping',
            ),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item = await Get.toNamed(add_twisting_warping.routeName);
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
                columnName: 'Date',
                label: const MyDataGridHeader(title: 'Date'),
              ),
              GridColumn(
                columnName: 'warper_name',
                label: const MyDataGridHeader(title: 'Warper Name'),
              ),
              GridColumn(
                columnName: 'record_no',
                label: const MyDataGridHeader(title: 'Record No.'),
              ),
              GridColumn(
                columnName: 'lot',
                label: const MyDataGridHeader(title: 'Lot'),
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
              await Get.toNamed(add_twisting_warping.routeName,
                  arguments: {"item": item});
              dataSource.notifyListeners();
            },
          ),
        ),
      );
    });
  }
}

class TwisterWarpingDataSource extends DataGridSource {
  TwisterWarpingDataSource() {
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
      TwistingOrWarpingController controller = Get.find();
      var result = await controller.twister(
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
            columnName: 'date', value: dataGridRow.createdAt),
        DataGridCell(columnName: 'warper_name', value: dataGridRow.warperName),
        DataGridCell(columnName: 'record_no', value: dataGridRow.recoredNo),
        DataGridCell(columnName: 'lot', value: dataGridRow.lot),
      ]);
    }).toList(growable: false);
  }
}
