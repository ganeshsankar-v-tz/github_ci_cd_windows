import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/new_unit/add_new_unit.dart';
import 'package:abtxt/view/basics/new_unit/new_unit_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';

class NewUnit extends StatefulWidget {
  const NewUnit({Key? key}) : super(key: key);
  static const String routeName = '/new_unit';

  @override
  State<NewUnit> createState() => _State();
}

class _State extends State<NewUnit> {
  NewUnitController controller = Get.put(NewUnitController());
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
    return GetBuilder<NewUnitController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Basic Info / New Unit'),
          actions: [
            MyRefreshIconButton(onPressed: () => _api()),
            SizedBox(width: 12),
            MyAddItemButton(onPressed: () => _add()),
            const SizedBox(width: 12),
          ],
        ),
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
              _add(),
          const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
              _api(),
        },
        loadingStatus: controller.status.isLoading,
        child: MySFDataGridRawTable(
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            // await Get.toNamed(AddNewUnit.routeName, arguments: {"item": item});
            // dataSource.notifyListeners();
            _add(args: {'item': item});
          },
          columns: <GridColumn>[
            GridColumn(
              width: 80,
              columnName: 'id',
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              columnName: 'unit_name',
              label: const MyDataGridHeader(title: 'Unit Name'),
            ),
            GridColumn(
              columnName: 'active_status',
              label: const MyDataGridHeader(title: 'Is Active'),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.NewUnitList(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddNewUnit.routeName,
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
        DataGridCell<dynamic>(columnName: 'unit_name', value: e['unit_name']),
        DataGridCell<dynamic>(
            columnName: 'active_status', value: e['active_status']),
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
