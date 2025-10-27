import 'package:abtxt/model/WarpDesignSheetModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastify/components/enums.dart';
import 'package:flutter_toastify/flutter_toastify.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridTable.dart';
import 'add_warp_design_sheet.dart';
import 'warp_design_sheet_controller.dart';

List<WarpDesignSheetModel> paginatedOrders = [];
LedgerDataSource dataSource = LedgerDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class WarpDesignSheet extends StatefulWidget {
  const WarpDesignSheet({Key? key}) : super(key: key);
  static const String routeName = '/warp_design_sheet_screen';

  @override
  State<WarpDesignSheet> createState() => _State();
}

class _State extends State<WarpDesignSheet> {
  late WarpDesignSheetController controller;
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
    return GetBuilder<WarpDesignSheetController>(builder: (controller) {
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
            'Add',
                () async {
              var item = await Get.toNamed(AddWarpDesignSheet.routeName);
              dataSource.notifyListeners();
            },
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text('Basic Info / Warp Design Sheet'),
            centerTitle: false,
            elevation: 0,
            actions: [
              MyAddItemButton(
                onPressed: () async {
                  var item = await Get.toNamed(AddWarpDesignSheet.routeName);
                  dataSource.notifyListeners();
                },
              ),
              SizedBox(
                width: 12,
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
                columnName: 'design_name',
                label: const MyDataGridHeader(title: 'Design Sheet'),
              ),
              GridColumn(
                columnName: 'active_status',
                label: const MyDataGridHeader(title: 'Is Active'),
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
              await Get.toNamed(AddWarpDesignSheet.routeName,
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
                      await Get.toNamed(AddWarpDesignSheet.routeName,
                          arguments: {"item": item});
                      dataSource.notifyListeners();
                      dataSource.notifyDataSourceListeners();
                    }),
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
                                WarpDesignSheetController controller =
                                    Get.find();
                                await controller.deleteWarpDesignSheet(id);
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
    if (newPageIndex < totalPage) {
      WarpDesignSheetController controller = Get.find();
      var result = await controller.warpDesignSheet(
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
        DataGridCell(columnName: 'design_name', value: dataGridRow.designName),
        DataGridCell(
            columnName: 'active_status', value: dataGridRow.activeStatus),
      ]);
    }).toList(growable: false);
  }
}
