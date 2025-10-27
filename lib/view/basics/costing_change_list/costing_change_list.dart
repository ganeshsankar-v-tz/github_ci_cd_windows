import 'package:abtxt/view/basics/costing_change_list/add_costing_change.dart';
import 'package:abtxt/view/basics/costing_change_list/costing_change_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridTable.dart';

CostingChangeListDataSource dataSource = CostingChangeListDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class CostingChangeList extends StatefulWidget {
  const CostingChangeList({Key? key}) : super(key: key);
  static const String routeName = '/CostingChangeList';

  @override
  State<CostingChangeList> createState() => _State();
}

class _State extends State<CostingChangeList> {
  late CostingChangeListController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CostingChangeListController>(builder: (controller) {
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
            'Add', () => Get.toNamed(AddCostingChange.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text('Basic Info / Costing Change'),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item = await Get.toNamed(AddCostingChange.routeName);
                  dataSource.notifyListeners();
                },
                icon: Icon(Icons.add),
                label: Text('Add'), // <-- Text
              ),
              SizedBox(
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
                columnName: 'Date',
                label: const MyDataGridHeader(title: 'Date'),
              ),
              GridColumn(
                columnName: 'firm_name',
                label: const MyDataGridHeader(title: 'Header'),
              ),
              GridColumn(
                columnName: 'short_code',
                label: const MyDataGridHeader(title: 'New Rate (Rs)'),
              ),
              GridColumn(
                width: 100,
                columnName: 'action',
                label: const MyDataGridHeader(title: 'Actions'),
                allowFiltering: false,
                allowSorting: false,
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
          ),
        ),
      );
    });
  }
}

class CostingChangeListDataSource extends DataGridSource {
  CostingChangeListDataSource() {
    // buildPaginatedDataGridRows();
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
                  onPressed: () {},
                  // async {
                  //   var id = row.getCells()[0].value;
                  //   int index = paginatedOrders.indexWhere((element) => element.id == id);
                  //   var item = paginatedOrders[index];
                  //   await Get.toNamed(AddLedger.routeName, arguments: {"item": item});
                  //   dataSource.notifyListeners();
                  // },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    var id = '${row.getCells()[0].value.toString()}';
                    CostingChangeListController controller = Get.find();
                    // await controller.deleteLedger(id);
                    //dataSource.handlePageChange(0, 0);
                    dataSource.notifyListeners();
                  },
                ),
              ],
            );
          } else {
            return Text(e.value.toString());
          }
        }),
      );
    }).toList());
  }
}
