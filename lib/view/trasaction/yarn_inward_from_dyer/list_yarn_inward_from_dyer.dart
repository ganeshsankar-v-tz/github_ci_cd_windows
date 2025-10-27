import 'package:abtxt/view/trasaction/yarn_inward_from_dyer/addYarn_Inward_from_Dyer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../model/YarnInwardFromDyer.dart';
import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridTable.dart';
import 'yarn_inward_from_dyer_controller.dart';

List<YarnInwardFromDyerModel> paginatedOrders = [];
YarnInwardFromDyerDataSource dataSource = YarnInwardFromDyerDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class ListYarnInwardFromDyer extends StatefulWidget {
  const ListYarnInwardFromDyer({Key? key}) : super(key: key);
  static const String routeName = '/yarn_inward_from_dyer';

  @override
  State<ListYarnInwardFromDyer> createState() => _State();
}

class _State extends State<ListYarnInwardFromDyer> {
  late YarnInwardFromDyerController controller;
  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = YarnInwardFromDyerDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnInwardFromDyerController>(builder: (controller) {
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
            'Add', () => Get.toNamed(addYarn_Inward_from_Dyer.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text('Transaction / Yarn Inward From Dyer'),
            centerTitle: false,
            elevation: 0,
            actions: [
              MyAddItemButton(
                onPressed: () async {
                  var item =
                      await Get.toNamed(addYarn_Inward_from_Dyer.routeName);
                  dataSource.notifyListeners();
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
                columnName: 'Date',
                label: const MyDataGridHeader(title: 'Date'),
              ),
              GridColumn(
                columnName: 'dyerName',
                label: const MyDataGridHeader(title: 'Dyer Name'),
              ),
              GridColumn(
                columnName: 'referenceNo',
                label: const MyDataGridHeader(title: 'Reference No'),
              ),
              GridColumn(
                columnName: 'wagesAccount',
                label: const MyDataGridHeader(title: 'Wages Account'),
              ),
              GridColumn(
                columnName: 'quantity',
                label: const MyDataGridHeader(title: 'Quantity'),
              ),
              GridColumn(
                columnName: 'totalAmount',
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
              await Get.toNamed(addYarn_Inward_from_Dyer.routeName,
                  arguments: {"item": item});
              dataSource.notifyListeners();
            },
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
            width: 100,
            columnName: 'id',
            label: const Center(
                child: Text('ID', overflow: TextOverflow.ellipsis)),
          ),
          GridColumn(
            width: 120,
            columnName: 'date',
            label: const Center(
                child: Text('Date', overflow: TextOverflow.ellipsis)),
          ),
          GridColumn(
            columnName: 'dyerName',
            label: const Center(
                child: Text('Dyer Name', overflow: TextOverflow.ellipsis)),
          ),
          GridColumn(
            columnName: 'referenceNo',
            label: const Center(
                child: Text('Reference No', overflow: TextOverflow.ellipsis)),
          ),
          GridColumn(
            columnName: 'wagesAccount',
            label: const Center(
                child: Text('Wages Account', overflow: TextOverflow.ellipsis)),
          ),
          GridColumn(
            columnName: 'quantity',
            label: const Center(
                child: Text('Quantity', overflow: TextOverflow.ellipsis)),
          ),
          GridColumn(
            columnName: 'totalAmount',
            label: const Center(
                child:
                    Text('Total Amount (Rs)', overflow: TextOverflow.ellipsis)),
          ),
        ],
      ),
    );
  }
}

class YarnInwardFromDyerDataSource extends DataGridSource {
  YarnInwardFromDyerDataSource() {
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
        //child: Text(e.value.toString()),
      );
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (newPageIndex < totalPage) {
      YarnInwardFromDyerController controller = Get.find();
      var result = await controller.yarninward(
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
        DataGridCell(columnName: 'date', value: dataGridRow.entryDate),
        DataGridCell(columnName: 'dyerName', value: dataGridRow.dyerName),
        DataGridCell(columnName: 'referenceNo', value: dataGridRow.referenceNo),
        DataGridCell(
            columnName: 'wagesAccount', value: dataGridRow.wagesAccount),
        DataGridCell(columnName: 'quantity', value: dataGridRow.totalQuantity),
        DataGridCell(columnName: 'totalAmount', value: dataGridRow.totalAmount),
      ]);
    }).toList(growable: false);
  }
}
