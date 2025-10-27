import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'add_loom_declaration.dart';
import 'loom_declaration_controller.dart';
import 'loom_declaration_filter.dart';

class LoomDeclarationList extends StatefulWidget {
  const LoomDeclarationList({Key? key}) : super(key: key);
  static const String routeName = '/loom_declaration_list';

  @override
  State<LoomDeclarationList> createState() => _State();
}

class _State extends State<LoomDeclarationList> {
  LoomDeclarationController controller = Get.put(LoomDeclarationController());
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
    return GetBuilder<LoomDeclarationController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Production / Loom Declaration'),
          actions: [
            MyRefreshIconButton(
                onPressed: () => _api(request: controller.filterData ?? {})),
            SizedBox(width: 12),
            MyFilterIconButton(
                onPressed: () => _filter(),
                filterIcon: controller.filterData != null ? true : false,
                tooltipText: "${controller.filterData}"),
            SizedBox(width: 12),
            MyAddItemButton(onPressed: () => _add()),
            SizedBox(width: 12),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
              _add(),
          const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
              _filter(),
          const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
              _api(),
        },
        child: MySFDataGridRawTable(
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            _add(args: {'item': item});
          },
          columns: <GridColumn>[
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
              columnName: 'weaver_name',
              label: const MyDataGridHeader(title: 'Weaver Name'),
            ),
            GridColumn(
              width: 100,
              columnName: 'loom_no',
              label: const MyDataGridHeader(title: 'Loom No'),
            ),
            GridColumn(
              width: 120,
              columnName: 'intro_date',
              label: const MyDataGridHeader(title: 'Introduce Date'),
            ),
            GridColumn(
              width: 120,
              columnName: 'is_active',
              label: const MyDataGridHeader(title: 'Is Active'),
            ),
            /*GridColumn(
              columnName: 'weekly_inward_day',
              label: const MyDataGridHeader(title: 'Weekly Inward Day'),
            ),*/
            GridColumn(
              width: 120,
              columnName: 'details',
              label: const MyDataGridHeader(title: 'Details'),
            ),
            GridColumn(
              width: 160,
              columnName: 'ac_holder',
              label: const MyDataGridHeader(title: 'A/c Holder'),
            ),
            GridColumn(
              width: 180,
              columnName: 'account_no',
              label: const MyDataGridHeader(title: 'Account No'),
            ),
            GridColumn(
              width: 160,
              columnName: 'ifsc_no',
              label: const MyDataGridHeader(title: 'IFSC No'),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.loomDeclaration(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddLoomDeclaration.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const LoomDeclarationFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
    ;
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
      /*var inwardDay = "";
      if (e["sund"] == "Yes") {
        inwardDay = "Sunday";
      } else if (e["mond"] == "Yes") {
        inwardDay = "Monday";
      } else if (e["tued"] == "Yes") {
        inwardDay = "Tuesday";
      } else if (e["wed"] == "Yes") {
        inwardDay = "Wednesday";
      } else if (e["thud"] == "Yes") {
        inwardDay = "Thursday";
      } else if (e["frid"] == "Yes") {
        inwardDay = "Friday";
      } else if (e["satd"] == "Yes") {
        inwardDay = "Saturday";
      }*/
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e['id']),
        DataGridCell<dynamic>(
            columnName: 'intro_date', value: '${e['intro_date']}'),
        DataGridCell<dynamic>(
            columnName: 'weaver_name', value: e['weaver_name']),
        DataGridCell<dynamic>(
            columnName: 'sub_weaver_no', value: e['sub_weaver_no']),
        DataGridCell<dynamic>(columnName: 'intro_date', value: e['intro_date']),
        DataGridCell<dynamic>(columnName: 'is_active', value: e['is_active']),
        /*DataGridCell<dynamic>(
            columnName: 'weekly_inward_day', value: inwardDay),*/
        DataGridCell<dynamic>(columnName: 'details', value: e['details']),
        DataGridCell<dynamic>(columnName: 'ac_holder', value: e['ac_holder']),
        DataGridCell<dynamic>(columnName: 'account_no', value: e['account_no']),
        DataGridCell<dynamic>(columnName: 'ifsc_no', value: e['ifsc_no']),
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
