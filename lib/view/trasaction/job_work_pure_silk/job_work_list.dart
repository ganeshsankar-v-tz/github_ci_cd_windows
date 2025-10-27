import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../adjustments/alternative_warp_design/alternative_warp_design_list.dart';
import '../../basics/ledger/ledgers.dart';
import 'add_job_work.dart';
import 'job_work_controller.dart';

// List<DeliveryYarn> paginatedOrders = [];
// final DeliveryYarnDataSource dataSource = DeliveryYarnDataSource();
// RxInt totalPage = RxInt(1);

class JobWorkList extends StatefulWidget {
  const JobWorkList({Key? key}) : super(key: key);
  static const String routeName = '/JobWorkList';

  @override
  State<JobWorkList> createState() => _State();
}

class _State extends State<JobWorkList> {
  late JobWorkController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobWorkController>(builder: (controller) {
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
            'Add', () => Get.toNamed(AddJobWork.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text('Transaction / JobWork'),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item = await Get.toNamed(AddJobWork.routeName);
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
          body: LayoutBuilder(builder: (context, constraint) {
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
                    pageCount: totalPage.ceil().toDouble(),
                    direction: Axis.horizontal,
                  ),
                ),
              ],
            );
          }),
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
            label: Center(child: Text('ID')),
          ),
          GridColumn(
            width: 100,
            columnName: 'Date',
            label: Center(child: Text('Date')),
          ),
          GridColumn(
            columnName: 'History',
            label: Center(child: Text('History')),
          ),
          GridColumn(
            columnName: 'JobWorker Name',
            label: Center(child: Text('JobWorker Name')),
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
            width: 100,
            columnName: 'button',
            label: Center(child: const Text('Action')),
          ),
        ],
      ),
    );
  }
}

// class DeliveryYarnDataSource extends DataGridSource {
//   DeliveryYarnDataSource() {
//     buildPaginatedDataGridRows();
//   }
//
//   List<DataGridRow> dataGridRows = [];
//
//   @override
//   List<DataGridRow> get rows => dataGridRows;
//
//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((e) {
//       return Container(
//         alignment: Alignment.center,
//         padding: EdgeInsets.all(8.0),
//         child: LayoutBuilder(builder: (context, constraints) {
//           if (e.columnName == 'button') {
//             return Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.edit),
//                   onPressed: () async {
//                     var id = row.getCells()[0].value;
//                     int index = paginatedOrders
//                         .indexWhere((element) => element.id == id);
//                     var item = paginatedOrders[index];
//                     await Get.toNamed(AddDyer.routeName,
//                         arguments: {"item": item});
//                     dataSource.notifyListeners();
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () async {
//                     var id = '${row.getCells()[0].value.toString()}';
//                     YarnDeliveryToDyerController controller = Get.find();
//                     await controller.deleteLedger(id);
//                     //dataSource.handlePageChange(0, 0);
//                     dataSource.notifyListeners();
//                   },
//                 ),
//               ],
//             );
//           } else if (e.columnName == 'image') {
//             return Image.network(
//               'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
//               width: 100,
//             );
//           } else {
//             return Text(e.value.toString());
//           }
//         }),
//         //child: Text(e.value.toString()),
//       );
//     }).toList());
//   }
//
//   @override
//   Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
//     if (newPageIndex < totalPage.value) {
//       YarnDeliveryToDyerController controller = Get.find();
//       var result = await controller.ledgers(page: '${newPageIndex + 1}');
//       paginatedOrders = result['list'];
//       totalPage.value = result['totalPage'];
//       buildPaginatedDataGridRows();
//       notifyListeners();
//     } else {
//       paginatedOrders = [];
//     }
//
//     return true;
//   }
//
//   void buildPaginatedDataGridRows() {
//     dataGridRows = paginatedOrders.map<DataGridRow>((dataGridRow) {
//       return DataGridRow(cells: [
//         DataGridCell(columnName: 'S.No', value: dataGridRow.id),
//         DataGridCell(columnName: 'Date', value: dataGridRow.entryDate),
//         // DataGridCell(columnName: 'History', value: dataGridRow.dyerId),
//         DataGridCell(columnName: 'Dyer Name', value: dataGridRow.dyarName),
//         DataGridCell(columnName: 'D.C No', value: dataGridRow.dcNo),
//         DataGridCell(columnName: 'Entry Type', value: dataGridRow.entryType),
//         DataGridCell(columnName: 'Yarn Name', value: dataGridRow.yarnName),
//         //  DataGridCell(columnName: 'Color Name', value: dataGridRow.yarnId),
//         DataGridCell(columnName: 'Quantity', value: dataGridRow.quantity),
//         DataGridCell(columnName: 'button', value: null),
//       ]);
//     }).toList(growable: false);
//   }
// }
