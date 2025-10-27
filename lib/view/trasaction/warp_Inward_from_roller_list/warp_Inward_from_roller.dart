import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_roller_list/add_warp_Inward_from_rolle.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_roller_list/warp_Inward_from_roller_controller.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_roller_list/warp_Inward_from_roller_payment_details.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_roller_list/warp_inward_from_roller_filter.dart';
import 'package:abtxt/widgets/MyAddItemButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import '../payment_v2/add_payment_v2.dart';

class WarpInwardFromRoller extends StatefulWidget {
  const WarpInwardFromRoller({super.key});
  static const String routeName = '/WarpInwardFromRoller';

  @override
  State<WarpInwardFromRoller> createState() => _State();
}

class _State extends State<WarpInwardFromRoller> {
  WarpInwardFromRollerController controller =
      Get.put(WarpInwardFromRollerController());
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
    return GetBuilder<WarpInwardFromRollerController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Transaction / Warp Inward From Roller'),
          actions: [
            MyRefreshIconButton(
                onPressed: () => _api(request: controller.filterData ?? {})),
            const SizedBox(width: 12),
            Tooltip(
              message: 'Payment Details (Shift+P)',
              child: ElevatedButton(
                onPressed: () {
                  _payDetails();
                },
                child: const Text("Payment Details"),
              ),
            ),
            const SizedBox(width: 12),
            Tooltip(
              message: 'Payment (Ctrl+P)',
              child: ElevatedButton(
                onPressed: () {
                  _paymentScreen();
                },
                child: const Text("Payment"),
              ),
            ),
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
          const SingleActivator(LogicalKeyboardKey.keyP, shift: true): () =>
              _payDetails(),
          const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
              _api(request: controller.filterData ?? {}),
          const SingleActivator(LogicalKeyboardKey.keyP, control: true): () =>
              _paymentScreen(),
        },
        child: MySFDataGridRawTable(
          selectionMode: SelectionMode.single,
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            _add(args: {'item': item});
          },
          columns: [
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
              width: 280,
              columnName: 'firm_name',
              label: const MyDataGridHeader(title: 'Firm'),
            ),
            GridColumn(
              width: 120,
              columnName: 'reference_no',
              label: const MyDataGridHeader(title: 'Ref No'),
            ),
            GridColumn(
              width: 280,
              columnName: 'roller_name',
              label: const MyDataGridHeader(title: 'Roller Name'),
            ),
            GridColumn(
              width: 80,
              columnName: 'inward_warps',
              label: const MyDataGridHeader(title: 'Warps'),
            ),
            GridColumn(
              width: 120,
              columnName: 'total_wages',
              label: const MyDataGridHeader(title: 'Wages(Rs)'),
            ),
            GridColumn(
              width: 90,
              columnName: 'wages_status',
              label: const MyDataGridHeader(title: 'Status'),
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
    var response = await controller.warpInward(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddWarpInwardFromRoller.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const WarpInwardFromRollerFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
    ;
  }

  void _payDetails() async {
    showDialog(
      context: context,
      builder: (_) => const WarpInwardFromRollerPayDetails(),
    );
  }

  void _paymentScreen() async {
    var arg = {
      "firm_name": "A B TEX PRIVATE LIMITED",
      "payment_type": "Roller Amount",
    };

    Get.toNamed(AddPaymentV2.routeName, arguments: arg);
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
        DataGridCell<dynamic>(columnName: 'firm_name', value: e['firm_name']),
        DataGridCell<dynamic>(
            columnName: 'reference_no', value: e['reference_no']),
        DataGridCell<dynamic>(
            columnName: 'roller_name', value: e['roller_name']),
        DataGridCell<int>(columnName: 'inward_warps', value: e['inward_warps']),
        DataGridCell<dynamic>(
            columnName: 'total_wages', value: e['total_wages']),
        DataGridCell<dynamic>(
            columnName: 'wages_status', value: e['wages_status']),
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
        case 'total_wages':
          return buildFormattedCell(value, decimalPlaces: 2);
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
}
