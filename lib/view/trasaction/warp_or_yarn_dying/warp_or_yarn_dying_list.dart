import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/warp_or_yarn_dying_model.dart';
import 'add_warp_or_yarn_dying.dart';
import 'warp_or_yarn_dying_controller.dart';

List<WarpOrYarnDyingModel> paginatedOrders = [];
final WarporYarnDataSource dataSource = WarporYarnDataSource();
RxInt totalPage = RxInt(1);

class WarpOrYarnDying extends StatefulWidget {
  const WarpOrYarnDying({Key? key}) : super(key: key);
  static const String routeName = '/WarpOrYarnDyingList';

  @override
  State<WarpOrYarnDying> createState() => _State();
}

class _State extends State<WarpOrYarnDying> {
  late WarpOrYarnDyingController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpOrYarnDyingController>(builder: (controller) {
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
            'Add', () => Get.toNamed(AddWarpOrYarnDying.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text('Transaction / Warp Or Yarn Dying'),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item = await Get.toNamed(AddWarpOrYarnDying.routeName);
                  dataSource.notifyListeners();
                },
                icon: Icon(Icons.add),
                label: Text('ADD'), // <-- Text
              ),
              SizedBox(
                width: 15,
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: LayoutBuilder(builder: (context, constraint) {
              return Column(
                children: [
                  SizedBox(
                    height: constraint.maxHeight - 60.0,
                    width: constraint.maxWidth,
                    child: _buildDataGrid(constraint),
                  ),
                  Container(
                    height: 60.0,
                    child: SfDataPager(
                      delegate: dataSource,
                      pageCount: totalPage.value.ceil().toDouble(),
                      direction: Axis.horizontal,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
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
        allowSorting: true,
        allowMultiColumnSorting: true,
        gridLinesVisibility: GridLinesVisibility.vertical,
        source: dataSource,
        columnWidthMode: ColumnWidthMode.fill,
        columns: <GridColumn>[
          GridColumn(
            allowFiltering: false,
            width: 100,
            columnName: 'Id',
            label: Center(child: Text('ID')),
          ),
          GridColumn(
            width: 120,
            columnName: 'Date',
            label: Center(child: Text('Date')),
          ),
          GridColumn(
            columnName: 'Dyer Name',
            label: Center(child: Text('Dyer Name')),
          ),
          GridColumn(
            columnName: 'Record No.',
            label: Center(child: Text('Record No.')),
          ),
          GridColumn(
            columnName: 'Lot',
            label: Center(child: Text('Lot')),
          ),
          GridColumn(
            columnName: 'Wages Account',
            label: Center(child: Text('Wages Account')),
          ),
          GridColumn(
            columnName: 'Transactin Type',
            label: Center(child: Text('Transaction Type')),
          ),
          GridColumn(
            allowFiltering: false,
            allowSorting: false,
            width: 100,
            columnName: 'button',
            label: Center(
                child: const Text('Actions', overflow: TextOverflow.ellipsis)),
          ),
        ],
      ),
    );
  }
}

class WarporYarnDataSource extends DataGridSource {
  WarporYarnDataSource() {
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
                    await Get.toNamed(AddWarpOrYarnDying.routeName,
                        arguments: {"item": item});
                    dataSource.notifyListeners();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: const Text(
                          'Do you want to delete?',
                          style: TextStyle(color: Colors.black),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text(
                              'CANCEL',
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          ),
                          TextButton(
                              child: Text(
                                'DELETE',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () async {
                                Get.back();
                                var id = row.getCells()[0].value.toString();
                                WarpOrYarnDyingController controller =
                                    Get.find();
                                await controller.deleteWarpYarn(id);
                                dataSource.notifyListeners();
                              }),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          } else {
            return Text(e.value.toString(), overflow: TextOverflow.ellipsis);
          }
        }),
        //child: Text(e.value.toString()),
      );
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (newPageIndex < totalPage.value) {
      WarpOrYarnDyingController controller = Get.find();
      var result = await controller.warpYarndying(page: '${newPageIndex + 1}');
      paginatedOrders = result['list'];
      totalPage.value = result['totalPage'];
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
        DataGridCell(columnName: 'S.No', value: dataGridRow.id),
        DataGridCell(
            columnName: 'Date',
            value: dataGridRow.itemDetails
                ?.map((e) => e.createdAt)
                .join(',')
                ),
        DataGridCell(columnName: 'Dyer Name', value: dataGridRow.dyerName),
        DataGridCell(columnName: 'Record No', value: dataGridRow.recoredNo),
        DataGridCell(columnName: 'Lot', value: dataGridRow.lot),
        DataGridCell(
            columnName: 'Wages Account', value: dataGridRow.accountTypeName),
        DataGridCell(
            columnName: 'Transactin Type',
            value: dataGridRow.transactionTypeId),
        DataGridCell(columnName: 'button', value: null),
      ]);
    }).toList(growable: false);
  }
}
