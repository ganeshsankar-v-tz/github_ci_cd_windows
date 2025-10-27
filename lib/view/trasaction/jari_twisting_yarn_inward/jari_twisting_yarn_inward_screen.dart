import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'add_jari_twisting_yarn_inward.dart';
import 'jari_twisting_yarn_inward_controller.dart';
import 'jari_twisting_yarn_inward_filter.dart';

class JariTwistingYarnInward extends StatefulWidget {
  const JariTwistingYarnInward({super.key});

  static const String routeName = '/JariTwistingYarnInwardList';

  @override
  State<JariTwistingYarnInward> createState() => _JariTwistingYarnInwardState();
}

class _JariTwistingYarnInwardState extends State<JariTwistingYarnInward> {
  JariTwistingYarnInwardController controller =
      Get.put(JariTwistingYarnInwardController());
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
    return GetBuilder<JariTwistingYarnInwardController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Transaction / Jari Twisting - Yarn Inward'),
          centerTitle: false,
          elevation: 0,
          actions: [
            MyRefreshIconButton(
                onPressed: () => _api(request: controller.filterData ?? {})),
            const SizedBox(width: 12),
            MyFilterIconButton(
                onPressed: () => _filter(),
                filterIcon: controller.filterData != null ? true : false,
                tooltipText: "${controller.filterData}"),
            const SizedBox(width: 12),
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
          const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
              _filter(),
          const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
              _api(request: controller.filterData ?? {}),
        },
        child: MySFDataGridRawTable(
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            _add(args: {"item": item});
            /*await Get.toNamed(AddJariTwistingYarnInward.routeName, arguments: {"item": item});
            dataSource.notifyListeners();*/
          },
          columns: <GridColumn>[
            GridColumn(
              columnName: 'id',
              width: 80,
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 105,
              columnName: 'e_date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              width: 100,
              columnName: 'slip_no',
              label: const MyDataGridHeader(title: 'No.'),
            ),
            GridColumn(
              width: 210,
              columnName: 'warper_name',
              label: const MyDataGridHeader(title: 'Warper Name'),
            ),
            GridColumn(
              width: 210,
              columnName: 'yarn_name',
              label: const MyDataGridHeader(title: 'Yarn Name'),
            ),
            GridColumn(
              width: 210,
              columnName: 'color_name',
              label: const MyDataGridHeader(title: 'Color'),
            ),
            GridColumn(
              width: 120,
              columnName: 'quantity',
              label: const MyDataGridHeader(title: 'Quantity'),
            ),
            // GridColumn(
            //   columnName: 'unit',
            //   label: const MyDataGridHeader(title: 'Unit'),
            // ),
            GridColumn(
              width: 120,
              columnName: 'cr_no',
              label: const MyDataGridHeader(title: 'CR/ Name'),
            ),
            // GridColumn(
            //   columnName: 'balancecr',
            //   label: const MyDataGridHeader(title: 'Balance CR'),
            // ),
            GridColumn(
              columnName: 'details',
              label: const MyDataGridHeader(title: 'Details'),
            )
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.jariTwistingYarnInward(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    if (list.isNotEmpty) {
      controller.yarnName = list.first["yarn_name"];
      controller.warperName = list.first["warper_name"];
    }

    var result = await Get.toNamed(
      AddJariTwistingYarnInward.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const JariTwistingYarnInwardFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
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
        DataGridCell<dynamic>(columnName: 'e_date', value: '${e['e_date']}'),
        DataGridCell<int>(columnName: 'slip_no', value: e['slip_no']),
        DataGridCell<dynamic>(
            columnName: 'warper_name', value: e['warper_name']),
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e['yarn_name']),
        DataGridCell<dynamic>(columnName: 'color_name', value: e['color_name']),
        DataGridCell<num>(columnName: 'quantity', value: e['quantity']),
        DataGridCell<dynamic>(columnName: 'cr_no', value: e['cr_no']),
        DataGridCell<dynamic>(columnName: 'details', value: e['details']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      double value = double.tryParse('${e.value}') ?? 0;
      final columnName = e.columnName;
      switch (columnName) {
        case 'quantity':
          return buildFormattedCell(value, decimalPlaces: 3);
        default:
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              e.value != null ? '${e.value}' : '',
              style: AppUtils.cellTextStyle(),
            ),
          );
      }
    }).toList());
  }

  Widget buildFormattedCell(dynamic value, {int decimalPlaces = 2}) {
    if (value is num) {
      final formatter = NumberFormat.currency(
        locale: 'en_IN',
        decimalDigits: decimalPlaces,
        name: '',
      );
      return Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          formatter.format(value),
          style: AppUtils.cellTextStyle(),
        ),
      );
    }
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        value != null ? '$value' : '',
        style: AppUtils.cellTextStyle(),
      ),
    );
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
