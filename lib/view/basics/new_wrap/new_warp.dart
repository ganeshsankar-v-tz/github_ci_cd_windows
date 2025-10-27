import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/new_wrap/add_new_warp_list.dart';
import 'package:abtxt/view/basics/new_wrap/new_warp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'new_warp_info_filtter.dart';

class NewWarp extends StatefulWidget {
  const NewWarp({Key? key}) : super(key: key);
  static const String routeName = '/new_wrap_list';

  @override
  State<NewWarp> createState() => _State();
}

class _State extends State<NewWarp> {
  NewWarpController controller = Get.put(NewWarpController());
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
    return GetBuilder<NewWarpController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: Text('Basic Info / New Warp'),
          actions: [
            MyRefreshIconButton(onPressed: () => _api(request: controller.filterData ?? {})),
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
              _api(request: controller.filterData ?? {}),
        },
        child: MySFDataGridRawTable(
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            // await Get.toNamed(AddNewWarp.routeName, arguments: {"item": item});
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
              columnName: 'warp_name',
              label: const MyDataGridHeader(title: 'Warp Name'),
            ),
            GridColumn(
              columnName: 'warp_type',
              label: const MyDataGridHeader(title: 'Warp Type'),
            ),
            GridColumn(
              columnName: 'group_name',
              label: const MyDataGridHeader(title: 'Group'),
            ),
            GridColumn(
              columnName: 'patterns',
              label: const MyDataGridHeader(title: 'Pattern'),
            ),
            GridColumn(
              columnName: 'total_ends',
              label: const MyDataGridHeader(title: 'Total Ends'),
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
    var response = await controller.newWrapList(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddNewWarp.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const WarpInfoFilter(),
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
        DataGridCell<dynamic>(columnName: 'warp_name', value: e['warp_name']),
        DataGridCell<dynamic>(columnName: 'warp_type', value: e['warp_type']),
        DataGridCell<dynamic>(columnName: 'group_name', value: e['group_name']),
        DataGridCell<dynamic>(columnName: 'patterns', value: e['patterns']),
        DataGridCell<int>(columnName: 'total_ends', value: e['total_ends']),
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
        padding: EdgeInsets.all(8.0),
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
