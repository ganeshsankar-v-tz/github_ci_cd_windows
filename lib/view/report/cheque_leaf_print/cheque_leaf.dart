import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/report/cheque_leaf_print/add_cheque_leaf.dart';
import 'package:abtxt/view/report/cheque_leaf_print/cheque_leaf_filter.dart';
import 'package:abtxt/widgets/MyAddItemButton.dart';
import 'package:abtxt/widgets/MyFilterIconButton.dart';
import 'package:abtxt/widgets/MyRefreshButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'cheque_leaf_controller.dart';

class ChequeLeaf extends StatefulWidget {
  const ChequeLeaf({super.key});

  static const String routeName = '/cheque_leaf_list';

  @override
  State<ChequeLeaf> createState() => _State();
}

class _State extends State<ChequeLeaf> {
  ChequeLeafController controller = Get.find();
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
    return GetBuilder<ChequeLeafController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Cheque Leaf'),
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
            _add(args: {'item': item});
          },
          columns: [
            GridColumn(
              columnName: 'id',
              width: 60,
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 105,
              columnName: 'e_date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              columnName: 'favouring',
              label: const MyDataGridHeader(title: 'Favouring'),
            ),
            GridColumn(
              width: 200,
              columnName: 'amount',
              label: const MyDataGridHeader(title: 'Amount'),
            ),
            GridColumn(
              width: 250,
              columnName: 'cheque_no',
              label: const MyDataGridHeader(title: 'Cheque No'),
            ),
            GridColumn(
              width: 115,
              columnName: 'template',
              label: const MyDataGridHeader(title: 'Template'),
            ),
            GridColumn(
              width: 100,
              columnName: 'ac_payee',
              label: const MyDataGridHeader(title: 'A/C Payee'),
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
    var response = await controller.chequeListApiCall(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(AddChequeLeaf.routeName, arguments: args);
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const ChequeLeafFilter(),
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
        DataGridCell<dynamic>(columnName: 'favouring', value: e['name']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['amount']),
        DataGridCell<dynamic>(columnName: 'cheque_no', value: e['cheque_no']),
        DataGridCell<dynamic>(columnName: 'template', value: e['template']),
        DataGridCell<dynamic>(columnName: 'ac_payee', value: e['is_open']),
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
}
