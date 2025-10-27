import 'package:abtxt/model/yarndeliverytodyerdata.dart';
import 'package:abtxt/view/trasaction/Yarn_Delivery_to_Dyer/add_dyer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';
import 'yarn_delivery_to_dyer_controller.dart';

List<YarnDeliverytoDyerModel> paginatedOrders = [];
DeliveryYarnDataSource dataSource = DeliveryYarnDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class YarnDeliveryToDyer extends StatefulWidget {
  const YarnDeliveryToDyer({Key? key}) : super(key: key);
  static const String routeName = '/yarn_delivery_to_dyer_screen';

  @override
  State<YarnDeliveryToDyer> createState() => _State();
}

class _State extends State<YarnDeliveryToDyer> {
  late YarnDeliveryToDyerController controller;
  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = DeliveryYarnDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnDeliveryToDyerController>(builder: (controller) {
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
              var item = await Get.toNamed(AddDyer.routeName);
              dataSource.notifyListeners();
            },
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Transaction / Yarn Delivery To Dyer'),
            centerTitle: false,
            elevation: 0,
            actions: [
              MyAddItemButton(
                onPressed: () async {
                  var item = await Get.toNamed(AddDyer.routeName);
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
                columnName: 'DyerName',
                label: const MyDataGridHeader(title: 'Dyer Name'),
              ),
              GridColumn(
                columnName: 'DCNo',
                label: const MyDataGridHeader(title: 'D.C No'),
              ),
              GridColumn(
                columnName: 'EntryType',
                label: const MyDataGridHeader(title: 'Entry Type'),
              ),
              GridColumn(
                columnName: 'YarnName',
                label: const MyDataGridHeader(title: 'Yarn Name'),
              ),
              GridColumn(
                columnName: 'ColorName',
                label: const MyDataGridHeader(title: 'Color Name'),
              ),
              GridColumn(
                columnName: 'Quantity',
                label: const MyDataGridHeader(title: 'Net Quantity'),
              ),
              // GridColumn(
              //   width: 100,
              //   columnName: 'button',
              //   label: const MyDataGridHeader(title: 'Actions'),
              //   allowFiltering: false,
              //   allowSorting: false,
              // ),
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
              await Get.toNamed(AddDyer.routeName,
                  arguments: {"item": item});
              dataSource.notifyListeners();
            },
          ),
        ),
      );
    });
  }
}

class DeliveryYarnDataSource extends DataGridSource {
  DeliveryYarnDataSource() {
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
          if (e.columnName == 'button') {
            return MyEditDelete(
              onEditPressed: () async {
                var id = row.getCells()[0].value;
                int index =
                    paginatedOrders.indexWhere((element) => element.id == id);
                var item = paginatedOrders[index];
                await Get.toNamed(AddDyer.routeName, arguments: {"item": item});
                dataSource.notifyListeners();
              },
              onDeletePressed: () async {
                var id = row.getCells()[0].value.toString();
                YarnDeliveryToDyerController controller = Get.find();
                await controller.delete(id);
                dataSource.notifyListeners();
              },
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
      YarnDeliveryToDyerController controller = Get.find();
      var result = await controller.yarnDeliverytoDyer(
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
        DataGridCell(columnName: 'Date', value: dataGridRow.entryDate),
        DataGridCell(columnName: 'DyerName', value: dataGridRow.dyarName),
        DataGridCell(columnName: 'DCNo', value: dataGridRow.dcNo),
        DataGridCell(columnName: 'EntryType', value: dataGridRow.entryType),
        DataGridCell(columnName: 'YarnName', value: dataGridRow.yarnName),
        DataGridCell(columnName: 'ColorName', value: dataGridRow.colorName),
        DataGridCell(columnName: 'Quantity', value: dataGridRow.netQuantity),
        // const DataGridCell(columnName: 'button', value: null),
      ]);
    }).toList(growable: false);
  }
}
