import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/warp_group/warp_group_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'add_warp_group.dart';

class WarpGroup extends StatefulWidget {
  const WarpGroup({Key? key}) : super(key: key);
  static const String routeName = '/WarpDesignSheet';

  @override
  State<WarpGroup> createState() => _State();
}

class _State extends State<WarpGroup> {
  WarpGroupController controller = Get.put(WarpGroupController());
  final _formKey = GlobalKey<FormState>();
  List<dynamic> list = <dynamic>[];
  late MyDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    _api();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpGroupController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Basic Info / Warp Group'),
          actions: [
            MyRefreshIconButton(onPressed: () => _api()),
            SizedBox(width: 12),
            MyAddItemButton(onPressed: () => _add()),
            const SizedBox(width: 12),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
              _add(),
          const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
              _api(),
        },
        child: MySFDataGridRawTable(
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            _add(args: {'item': item});
            // dataSource.notifyListeners();
            // await Get.toNamed(AddWarpGroup.routeName,
            //     arguments: {"item": item});
          },
          columns: <GridColumn>[
            GridColumn(
              width: 80,
              columnName: 'id',
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              columnName: 'group_name',
              label: const MyDataGridHeader(title: 'Group Name'),
            ),
            GridColumn(
              columnName: 'is_active',
              label: const MyDataGridHeader(title: 'Is Active'),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.warp(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddWarpGroup.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api();
    }
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<dynamic> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e['id']),
        DataGridCell<dynamic>(columnName: 'group_name', value: e['group_name']),
        DataGridCell<dynamic>(columnName: 'is_active', value: e['is_active']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          e.value != null ? '${e.value}' : '',
          style: AppUtils.cellTextStyle(),
        ),
      );
    }).toList());
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        summaryValue,
        style: AppUtils.footerTextStyle(),
      ),
    );
  }
}
