import 'package:abtxt/model/CostingEntryModel.dart';
import 'package:abtxt/view/basics/costing_entry_list/add_costing_entry.dart';
import 'package:abtxt/view/basics/costing_entry_list/costing_entry_controller.dart';
import 'package:abtxt/widgets/MyAddItemButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';

List<CostingEntryModel> paginatedOrders = [];
CostingEntryDataSource dataSource = CostingEntryDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class CostingEntryList extends StatefulWidget {
  const CostingEntryList({Key? key}) : super(key: key);
  static const String routeName = '/CostingEntryList';

  @override
  State<CostingEntryList> createState() => _State();
}

class _State extends State<CostingEntryList> {
  late CostingEntryController controller;

  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = CostingEntryDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CostingEntryController>(builder: (controller) {
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
            'Add', () =>  Get.toNamed(AddCostingEntry.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Basic Info / Costing Entry'),
            centerTitle: false,
            elevation: 0,
            actions: [
              MyAddItemButton(
                onPressed: () async {
                  var item = await Get.toNamed(AddCostingEntry.routeName);
                },
              ),
              const SizedBox(
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
                columnName: 'date',
                label: const MyDataGridHeader(title: 'Date'),
              ),
              GridColumn(
                columnName: 'product_name',
                label: const MyDataGridHeader(title: 'Product Name'),
              ),
              GridColumn(
                columnName: 'design_no',
                label: const MyDataGridHeader(title: 'Design No'),
              ),
              GridColumn(
                columnName: 'noofunits',
                label: const MyDataGridHeader(title: 'No of Units'),
              ),
              GridColumn(
                columnName: 'group_name',
                label: const MyDataGridHeader(title: 'Group'),
              ),
              GridColumn(
                columnName: 'sgl_unit_cost',
                label: const MyDataGridHeader(title: 'Single Unit Cost (Rs)'),
              ),
              GridColumn(
                columnName: 'Record No',
                label: const MyDataGridHeader(title: 'Record No'),
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
              await Get.toNamed(AddCostingEntry.routeName,
                  arguments: {"item": item});
              dataSource.notifyListeners();
            },
          ),
        ),
      );
    });
  }
}

class CostingEntryDataSource extends DataGridSource {
  CostingEntryDataSource() {
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
                await Get.toNamed(AddCostingEntry.routeName,
                    arguments: {"item": item});
                dataSource.notifyListeners();
              },
              onDeletePressed: () async {
                var id = row.getCells()[0].value.toString();
                CostingEntryController controller = Get.find();
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
      CostingEntryController controller = Get.find();
      var result = await controller.costingEntry(
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
        DataGridCell(
            columnName: 'product_name', value: dataGridRow.productName),
        DataGridCell(columnName: 'design_no', value: dataGridRow.designNo),
        DataGridCell(columnName: 'noofunits', value: dataGridRow.noofunits),
        DataGridCell(columnName: 'group_name', value: dataGridRow.groupName),
        DataGridCell(
            columnName: 'sgl_unit_cost', value: dataGridRow.sglUnitCost),
        DataGridCell(columnName: 'Record No', value: dataGridRow.recordNo),
      ]);
    }).toList(growable: false);
  }
}
