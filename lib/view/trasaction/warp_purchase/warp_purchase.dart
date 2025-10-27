import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/warp_purchase/warp_purchase_controller.dart';
import 'package:abtxt/view/trasaction/warp_purchase/warp_purchase_filter.dart';
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
import 'add_warp_purchase.dart';

class WarpPurchase extends StatefulWidget {
  const WarpPurchase({Key? key}) : super(key: key);
  static const String routeName = '/warp_purchase_product_sale';

  @override
  State<WarpPurchase> createState() => _State();
}

class _State extends State<WarpPurchase> {
  WarpPurchaseController controller = Get.put(WarpPurchaseController());
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
    return GetBuilder<WarpPurchaseController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Transaction / Warp Purchase '),
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
            // await Get.toNamed(AddWarpPurhase.routeName,
            //     arguments: {"item": item});
            // dataSource.notifyListeners();
            _add(args: {'item': item});
          },
          columns: <GridColumn>[
            GridColumn(
              width: 80,
              columnName: 'Id',
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 120,
              columnName: 'act_bill_date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              width: 280,
              columnName: 'firm_name',
              label: const MyDataGridHeader(title: 'Firm'),
            ),
            GridColumn(
              width: 280,
              columnName: 'suplier_name',
              label: const MyDataGridHeader(title: 'Supplier Name'),
            ),
            GridColumn(
              width: 280,
              columnName: 'purchase_account_name',
              label: const MyDataGridHeader(title: 'Account Type'),
            ),
            GridColumn(
              width: 150,
              columnName: 'net_totel',
              label: const MyDataGridHeader(title: 'Amount (Rs)'),
            ),
            GridColumn(
              width: 100,
              columnName: 'slip_no',
              label: const MyDataGridHeader(title: 'Slip No.'),
            ),
            GridColumn(
              width: 100,
              columnName: 'weight',
              label: const MyDataGridHeader(title: 'Weight'),
            ),
            GridColumn(
              width: 120,
              columnName: 'details',
              label: const MyDataGridHeader(title: 'Details'),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.warpPurchase(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddWarpPurhase.routeName,
      arguments: args,
    );
    if (result == 'success' || controller.isChanged == true) {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const WarpPurchaseFilter(),
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
        DataGridCell<dynamic>(
            columnName: 'act_bill_date', value: '${e['act_bill_date']}'),
        DataGridCell<dynamic>(columnName: 'firm_name', value: e['firm_name']),
        DataGridCell<dynamic>(
            columnName: 'suplier_name', value: e['suplier_name']),
        DataGridCell<dynamic>(
            columnName: 'purchase_account_name',
            value: e['purchase_account_name']),
        DataGridCell<dynamic>(columnName: 'net_totel', value: e['net_totel']),
        DataGridCell<int>(columnName: 'slip_no', value: e['slip_no']),
        DataGridCell<dynamic>(columnName: 'weight', value: e['weight']),
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
        case 'net_totel':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'weight':
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
}
