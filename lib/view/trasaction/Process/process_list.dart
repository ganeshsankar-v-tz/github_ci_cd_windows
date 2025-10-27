import 'package:abtxt/view/trasaction/Process/add_process.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/ProcessPureSilkModel.dart';
import '../../basics/ledger/ledgers.dart';
import 'process_controller.dart';

List<ProcessPureSilkModel> paginatedOrders = [];
final ProcessDataSource dataSource = ProcessDataSource();
RxInt totalPage = RxInt(1);

class ProcessList extends StatefulWidget {
  const ProcessList({Key? key}) : super(key: key);
  static const String routeName = '/ProcessList';

  @override
  State<ProcessList> createState() => _State();
}

class _State extends State<ProcessList> {
  late ProcessController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProcessController>(builder: (controller) {
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
            'Add', () =>  Get.toNamed(AddProcess.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text('Transaction / Process'),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item = await Get.toNamed(AddProcess.routeName);
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
        gridLinesVisibility: GridLinesVisibility.vertical,
        source: dataSource,
        columnWidthMode: ColumnWidthMode.fill,
        columns: <GridColumn>[
          GridColumn(
            allowFiltering: false,
            width: 100,
            columnName: 'Id',
            label: Center(
                child: Text(
              'ID',
              overflow: TextOverflow.ellipsis,
            )),
          ),
          GridColumn(
            width: 120,
            columnName: 'Date',
            label: Center(
                child: Text(
              'Date',
              overflow: TextOverflow.ellipsis,
            )),
          ),
          // GridColumn(
          //   columnName: 'History',
          //   label: Center(
          //       child: Text(
          //     'History',
          //     overflow: TextOverflow.ellipsis,
          //   )),
          // ),
          // GridColumn(
          //   columnName: 'Firm',
          //   label: Center(
          //       child: Text(
          //     'Firm',
          //     overflow: TextOverflow.ellipsis,
          //   )),
          // ),
          GridColumn(
            columnName: 'Processor Name',
            label: Center(
                child: Text(
              'Processor Name',
              overflow: TextOverflow.ellipsis,
            )),
          ),
          GridColumn(
            columnName: 'Record No',
            label: Center(
                child: Text(
              'Record No',
              overflow: TextOverflow.ellipsis,
            )),
          ),
          GridColumn(
            columnName: 'Lot',
            label: Center(
                child: Text(
              'Lot',
              overflow: TextOverflow.ellipsis,
            )),
          ),
          GridColumn(
            columnName: 'Wages Account',
            label: Center(
                child: Text(
              'Wages Account',
              overflow: TextOverflow.ellipsis,
            )),
          ),

          GridColumn(
            allowFiltering: false,
            width: 100,
            columnName: 'button',
            label: Center(
                child: const Text(
              'Actions',
              overflow: TextOverflow.ellipsis,
            )),
          ),
        ],
      ),
    );
  }
}

class ProcessDataSource extends DataGridSource {
  ProcessDataSource() {
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
                    await Get.toNamed(AddProcess.routeName,
                        arguments: {"item": item});
                    dataSource.notifyListeners();
                    dataSource.notifyDataSourceListeners();
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
                                ProcessController controller = Get.find();
                                await controller.deleteProcess(id);
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
            return Text(
              e.value.toString(),
              overflow: TextOverflow.ellipsis,
            );
          }
        }),
        //child: Text(e.value.toString()),
      );
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (newPageIndex < totalPage.value) {
      ProcessController controller = Get.find();
      var result = await controller.process_get(page: '${newPageIndex + 1}');
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
        DataGridCell(columnName: 'Date', value: dataGridRow.processorId),
        // DataGridCell(columnName: 'History', value: dataGridRow.processorId),
        // DataGridCell(columnName: 'Firm', value: dataGridRow.firmName),
        DataGridCell(
            columnName: 'Processor Name', value: dataGridRow.processerName),
        DataGridCell(columnName: 'Record No', value: dataGridRow.recoredNo),
        DataGridCell(columnName: 'Lot', value: dataGridRow.lot),
        DataGridCell(columnName: 'Wages Account', value: dataGridRow.wages),
        DataGridCell(columnName: 'button', value: null),
      ]);
    }).toList(growable: false);
  }
}
