import 'package:abtxt/view/basics/warping_design_charges_config/warping_design_charges_config_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:abtxt/view/basics/warping_design_charges_config/add_warping_design_charges_config.dart';
import '../../../model/warping_design_charges_config_model.dart';
import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';

List<WarpDesignChargesConfigModel> paginatedOrders = [];

WarpingDesignChargesConfigListDataSource dataSource =
    WarpingDesignChargesConfigListDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class WarpingDesignChargesConfig extends StatefulWidget {
  const WarpingDesignChargesConfig({Key? key}) : super(key: key);
  static const String routeName = '/wrap_design_charges';

  @override
  State<WarpingDesignChargesConfig> createState() => _State();
}

class _State extends State<WarpingDesignChargesConfig> {
  late WarpingDesignChargesConfigController controller;
  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = WarpingDesignChargesConfigListDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpingDesignChargesConfigController>(
        builder: (controller) {
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
            'Add', ()async =>  Get.toNamed(AddWarpingDesignChargesConfig.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text('Basic Info / Warping Design Charges Config'),
            centerTitle: false,
            elevation: 0,
            actions: [
              MyAddItemButton(
                onPressed: () async {
                  var item = await Get.toNamed(AddWarpingDesignChargesConfig.routeName);
                  dataSource.notifyListeners();
                },
              ),
              SizedBox(width: 12),
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
                columnName: 'wrap_design_name',
                label: const MyDataGridHeader(title: 'Warp Design'),
              ),
              GridColumn(
                columnName: 'wrap_type',
                label: const MyDataGridHeader(title: 'Warp Type'),
              ),
              GridColumn(
                columnName: 'length_type',
                label: const MyDataGridHeader(title: 'Length Type'),
              ),
              GridColumn(
                columnName: 'asthiri',
                label: const MyDataGridHeader(title: 'Asthiri'),
              ),
              GridColumn(
                columnName: 'design_changes',
                label: const MyDataGridHeader(title: 'Design Charges (Rs)'),
              ),
              GridColumn(
                columnName: 'yarns',
                label: const MyDataGridHeader(title: 'Yarns'),
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
              await Get.toNamed(AddWarpingDesignChargesConfig.routeName,
                  arguments: {"item": item});
              dataSource.notifyListeners();
            },
          ),
        ),
      );
    });
  }
}

class WarpingDesignChargesConfigListDataSource extends DataGridSource {
  WarpingDesignChargesConfigListDataSource() {
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
                await Get.toNamed(AddWarpingDesignChargesConfig.routeName,
                    arguments: {"item": item});
                dataSource.notifyListeners();
              },
              onDeletePressed: () async {
                var id = row.getCells()[0].value.toString();
                WarpingDesignChargesConfigController controller = Get.find();
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
      WarpingDesignChargesConfigController controller = Get.find();
      var result = await controller.warpDesignCharges(
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
        DataGridCell(
            columnName: 'wrap_design_name', value: dataGridRow.wrapDesignName),
        DataGridCell(columnName: 'wrap_type', value: dataGridRow.wrapType),
        DataGridCell(columnName: 'length_type', value: dataGridRow.lengthType),
        DataGridCell(columnName: 'asthiri', value: dataGridRow.asthiri),
        DataGridCell(
            columnName: 'design_changes', value: dataGridRow.designChanges),
        DataGridCell(columnName: 'yarns', value: dataGridRow.yarns),
      ]);
    }).toList(growable: false);
  }
}
