import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/AlternativeWarpDesignModel.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';
import '../../basics/Cops_Reel/cops_reel.dart';
import 'add_alternative_warp_design.dart';
import 'alternative_warp_design_controller.dart';

List<AlternativeWarpDesignModel> paginatedOrders = [];
MyDataSource dataSource = MyDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class AltWarpDesign extends StatefulWidget {
  const AltWarpDesign({Key? key}) : super(key: key);
  static const String routeName = '/alternative_warp_design_list';

  @override
  State<AltWarpDesign> createState() => _State();
}

class _State extends State<AltWarpDesign> {
  late AltWarpDesignController controller;

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
    return GetBuilder<AltWarpDesignController>(builder: (controller) {
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
            'Add', () => Get.toNamed(AddAltWarpDesign.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text('Adjustment / Alternative Warp Design'),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item = await Get.toNamed(AddAltWarpDesign.routeName);
                  dataSource.notifyListeners();
                },
                icon: Icon(Icons.add),
                label: Text('ADD'),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: MySFDataGridTable(
              columns: <GridColumn>[
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
                  columnName: 'record_no',
                  label: const MyDataGridHeader(title: 'Record No'),
                ),
                GridColumn(
                  columnName: 'old_warp_design',
                  label: const MyDataGridHeader(title: 'Warp Design'),
                ),
                GridColumn(
                  columnName: 'warp_type',
                  label: const MyDataGridHeader(title: 'Warp Type'),
                ),
                GridColumn(
                  columnName: 'total_ends',
                  label: const MyDataGridHeader(title: 'Total Ends'),
                ),
                GridColumn(
                  columnName: 'warp_id_no',
                  label: const MyDataGridHeader(title: 'Warp ID No'),
                ),
                GridColumn(
                  columnName: 'alt_warp_design_id',
                  label: const MyDataGridHeader(title: 'Alter Warp Design'),
                ),
                GridColumn(
                  columnName: 'alt_total_ends',
                  label: const MyDataGridHeader(title: 'Total End'),
                ),
                GridColumn(
                  columnName: 'New alt_warp_id ID No',
                  label: const MyDataGridHeader(title: 'New Warp ID No'),
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
                await Get.toNamed(AddAltWarpDesign.routeName,
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
        padding: EdgeInsets.all(8.0),
        child: LayoutBuilder(builder: (context, constraints) {
          if (e.columnName == 'button') {
            return MyEditDelete(
              onEditPressed: () async {
                var id = row.getCells()[0].value;
                int index =
                    paginatedOrders.indexWhere((element) => element.id == id);
                var item = paginatedOrders[index];
                await Get.toNamed(AddAltWarpDesign.routeName,
                    arguments: {"item": item});
                dataSource.notifyListeners();
              },
              onDeletePressed: () async {
                var id = row.getCells()[0].value.toString();
                AltWarpDesignController controller = Get.find();
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
      AltWarpDesignController controller = Get.find();
      var result = await controller.paginatedList(
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
        DataGridCell(columnName: 'record_no', value: dataGridRow.recordNo),
        DataGridCell(
            columnName: 'old_warp_design', value: dataGridRow.oldWarpDesign),
        DataGridCell(columnName: 'warp_type', value: dataGridRow.warpType),
        DataGridCell(columnName: 'total_ends', value: dataGridRow.totalEnds),
        DataGridCell(columnName: 'warp_id_no', value: dataGridRow.warpIdNo),
        DataGridCell(
            columnName: 'alt_warp_design_id',
            value: dataGridRow.altWarpDesignId),
        DataGridCell(
            columnName: 'alt_total_ends', value: dataGridRow.altTotalEnds),
        DataGridCell(columnName: 'alt_warp_id', value: dataGridRow.altWarpId),
      ]);
    }).toList(growable: false);
  }
}
