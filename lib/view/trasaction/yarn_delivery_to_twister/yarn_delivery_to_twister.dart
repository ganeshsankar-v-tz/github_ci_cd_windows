import 'package:abtxt/view/trasaction/yarn_delivery_to_twister/yarn_delivery_to_twister_controller.dart';
import 'package:abtxt/view/trasaction/yarn_delivery_to_twister/yarndeliveryt_totwister_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../flutter_core_widget.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'addyarn_delivery_to_twister.dart';

class YarnDeliveryToTwister extends StatefulWidget {
  const YarnDeliveryToTwister({super.key});

  static const String routeName = '/yarndelivery_totwister';

  @override
  State<YarnDeliveryToTwister> createState() => _YarnDeliveryToTwisterState();
}

class _YarnDeliveryToTwisterState extends State<YarnDeliveryToTwister> {
  YarnDeliveryToTwisterController controller =
      Get.put(YarnDeliveryToTwisterController());
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
    return GetBuilder<YarnDeliveryToTwisterController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Yarn Delivery to Twister'),
          actions: [
            MyRefreshIconButton(
              onPressed: () => _api(request: controller.filterData ?? {}),
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
          const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
              _api(request: controller.filterData ?? {}),
          const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
              _filter(),
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
              width: 100,
              columnName: 'date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              columnName: 'twisting',
              label: const MyDataGridHeader(title: 'Twisting Yarn Name'),
            ),
            GridColumn(
              columnName: 'machine',
              label: const MyDataGridHeader(title: 'Machine Name'),
            ),
            GridColumn(
              columnName: 'particulars',
              label: const MyDataGridHeader(title: 'Particulars'),
            ),
            GridColumn(
              columnName: 'pack',
              label: const MyDataGridHeader(title: 'Pack'),
            ),
            GridColumn(
              width: 100,
              columnName: 'quantity',
              label: const MyDataGridHeader(title: 'Quantity'),
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
    var response = await controller.yarnDeliveryToTwister(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddyarnDeliveryToTwister.routeName,
      arguments: args,
    );
    if (result == "success") {
      _api();
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const YarndeliverytTotwisterFilter(),
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
      var machineDetails = "";
      var machineType = e['machine_type'];

      if (machineType == "Winder") {
        machineDetails = "$machineType, ${e["winding_type"]}";
      } else if (machineType == "TFO") {
        machineDetails = "$machineType, ${e["deck_type"]}, ${e["spendile"]}";
      } else {
        machineDetails = "$machineType, ${e["deck_type"]}, ${e["spendile"]}";
      }

      int pack = 0;
      for (var h in e["twisting_delivery_details"]) {
        pack += int.tryParse("${h["pack"]}") ?? 0;
      }

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e['id']),
        DataGridCell<dynamic>(columnName: 'date', value: e['e_date']),
        DataGridCell<dynamic>(columnName: 'twisting', value: e['yarn_name']),
        DataGridCell<dynamic>(columnName: 'machine', value: e['machine_name']),
        DataGridCell<dynamic>(columnName: 'particulars', value: machineDetails),
        DataGridCell<dynamic>(columnName: 'pack', value: pack),
        DataGridCell<dynamic>(
            columnName: 'quantity', value: e['gross_quantity']),
        DataGridCell<dynamic>(columnName: 'details', value: e['details']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      double value = double.tryParse('${dataGridCell.value}') ?? 0;
      final columnName = dataGridCell.columnName;
      switch (columnName) {
        case 'quantity':
          return buildFormattedCell(value, decimalPlaces: 3);
        default:
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              dataGridCell.value != null ? '${dataGridCell.value}' : '',
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
