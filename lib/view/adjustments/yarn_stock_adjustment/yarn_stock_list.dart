import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/adjustments/yarn_stock_adjustment/yarn_stock_adjustment_filter.dart';
import 'package:abtxt/view/adjustments/yarn_stock_adjustment/yarn_stock_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'add_yarn_stock_.dart';

class YarnStock extends StatefulWidget {
  const YarnStock({Key? key}) : super(key: key);
  static const String routeName = '/yarn_stock_list';

  @override
  State<YarnStock> createState() => _State();
}

class _State extends State<YarnStock> {
  YarnStockController controller = Get.put(YarnStockController());
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
    return GetBuilder<YarnStockController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Adjustment / Yarn Stock - Adjustment'),
          actions: [
            MyRefreshIconButton(onPressed: () => _api(request: controller.filterData ?? {})),
            SizedBox(width: 12),
            MyFilterIconButton(
                onPressed: () => _filter(),
                filterIcon: controller.filterData != null ? true : false,
                tooltipText: "${controller.filterData}"),
            const SizedBox(width: 12),
            MyAddItemButton(onPressed: () => _add()),
            const SizedBox(width: 12),
          ],
        ),
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
        loadingStatus: controller.status.isLoading,
        child: MySFDataGridRawTable(
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            _add(args: {'item': item});
            // await Get.toNamed(AddYarnStock.routeName,
            //     arguments: {"item": item});
            // dataSource.notifyListeners();
          },
          columns: <GridColumn>[
            GridColumn(
              width: 80,
              columnName: 'id',
              label: const MyDataGridHeader(title: 'Rec No'),
            ),
            GridColumn(
              width: 100,
              columnName: 'e_date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              columnName: 'firm_name',
              label: const MyDataGridHeader(title: 'Firm'),
            ),
            GridColumn(
              width: 120,
              columnName: 'reason',
              label: const MyDataGridHeader(title: 'Reason'),
            ),
            GridColumn(
              columnName: 'yarn_name',
              label: const MyDataGridHeader(title: 'Yarn'),
            ),
            GridColumn(
              columnName: 'details',
              label: const MyDataGridHeader(title: 'Details'),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.YarnStockAdjustment(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddYarnStock.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const YarnStockAdjustmentFilter(),
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
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e['rec_no']),
        DataGridCell<dynamic>(columnName: 'e_date', value: '${e['e_date']}'),
        DataGridCell<dynamic>(columnName: 'firm_name', value: e['firm_name']),
        DataGridCell<dynamic>(columnName: 'reason', value: e['reason']),
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e['yarn_name']),
        DataGridCell<dynamic>(columnName: 'details', value: e['details']),
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
