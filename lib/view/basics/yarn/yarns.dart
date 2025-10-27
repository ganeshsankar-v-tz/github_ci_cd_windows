import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/yarn/add_yarn.dart';
import 'package:abtxt/view/basics/yarn/yarn_controller.dart';
import 'package:abtxt/view/basics/yarn/yarn_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';

class Yarns extends StatefulWidget {
  const Yarns({super.key});

  static const String routeName = '/yarns';

  @override
  State<Yarns> createState() => _YarnsState();
}

class _YarnsState extends State<Yarns> {
  YarnController controller = Get.put(YarnController());
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
    return GetBuilder<YarnController>(
      builder: (controller) {
        this.controller = controller;
        return CoreWidget(
          appBar: AppBar(
            title: const Text('Basic Info / New Yarn'),
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
              // await Get.toNamed(AddYarn.routeName, arguments: {"item": item});
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
                columnName: 'name',
                label: const MyDataGridHeader(title: 'Yarn Name'),
              ),
              GridColumn(
                width: 120,
                columnName: 'unit',
                label: const MyDataGridHeader(title: 'Unit'),
              ),
              GridColumn(
                width: 180,
                columnName: 'holder',
                label: const MyDataGridHeader(title: 'Holder'),
              ),
              GridColumn(
                width: 160,
                columnName: 'net_weight_unit',
                label: const MyDataGridHeader(title: 'Net. Weight - Unit'),
              ),
              GridColumn(
                width: 120,
                columnName: 'holder_unit',
                label: const MyDataGridHeader(title: 'Holder - Unit'),
              ),
              GridColumn(
                width: 120,
                columnName: 'll_name',
                label: const MyDataGridHeader(title: 'LL Name'),
              ),
              GridColumn(
                width: 120,
                columnName: 'is_active',
                label: const MyDataGridHeader(title: 'Is Active'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _api({var request = const {}}) async {
    var response = await controller.yarn(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddYarn.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const YarnFilter(),
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
        DataGridCell<int>(columnName: 'id', value: e['id']),
        DataGridCell<dynamic>(columnName: 'name', value: e['name']),
        DataGridCell<dynamic>(columnName: 'unit_name', value: e['unit_name']),
        DataGridCell<dynamic>(columnName: 'holder', value: e['holder']),
        DataGridCell<int>(columnName: 'net_weight', value: e['net_weight']),
        DataGridCell<dynamic>(
            columnName: 'holder_unit', value: e['holder_unit']),
        DataGridCell<dynamic>(columnName: 'll_name', value: e['ll_name']),
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
