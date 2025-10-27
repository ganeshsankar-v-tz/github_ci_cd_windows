import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/warp_dropout_allocation/WarpDropoutAllocationModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/production/dropout_warp_allocation/add_warp_dropout_allocation.dart';
import 'package:abtxt/view/production/dropout_warp_allocation/warp_dropout_allocation_controller.dart';
import 'package:abtxt/view/production/dropout_warp_allocation/warp_dropout_allocationj_filter.dart';
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

class WarpDropoutAllocationList extends StatefulWidget {
  const WarpDropoutAllocationList({super.key});

  static const String routeName = '/warp_dropout_allocation_list';

  @override
  State<WarpDropoutAllocationList> createState() => _State();
}

class _State extends State<WarpDropoutAllocationList> {
  WarpDropOutAllocationController controller =
      Get.put(WarpDropOutAllocationController());
  List<WarpDropoutAllocationModel> list = <WarpDropoutAllocationModel>[];
  late MyDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    _api();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpDropOutAllocationController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Production / Warp Dropout Allocation'),
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
              width: 80,
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 105,
              columnName: 'e_date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              minimumWidth: 200,
              columnName: 'weaver_name',
              label: const MyDataGridHeader(title: 'Weaver Name'),
            ),
            GridColumn(
              width: 70,
              columnName: 'loom_no',
              label: const MyDataGridHeader(title: 'Loom'),
            ),
            GridColumn(
              width: 170,
              columnName: 'warp_id',
              label: const MyDataGridHeader(title: 'Warp Id'),
            ),
            GridColumn(
              minimumWidth: 200,
              columnName: 'warp_design_name',
              label: const MyDataGridHeader(title: 'Warp Design Name'),
            ),
            GridColumn(
              width: 80,
              columnName: 'qty',
              label: const MyDataGridHeader(title: 'Qty'),
            ),
            GridColumn(
              width: 80,
              columnName: 'meter',
              label: const MyDataGridHeader(title: 'Meter'),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.warpDropoutList(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result =
        await Get.toNamed(AddWarpDropoutAllocation.routeName, arguments: args);
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const WarpDropoutAllocationFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<WarpDropoutAllocationModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<WarpDropoutAllocationModel> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e.id),
        DataGridCell<dynamic>(
            columnName: 'e_date', value: '${e.warpAllocateDate}'),
        DataGridCell<dynamic>(columnName: 'weaver_name', value: e.weaverName),
        DataGridCell<dynamic>(columnName: 'loom_no', value: e.loomNo),
        DataGridCell<dynamic>(columnName: 'warp_id', value: e.warpId),
        DataGridCell<dynamic>(
            columnName: 'warp_design_name', value: e.warpName),
        DataGridCell<dynamic>(columnName: 'qty', value: e.warpQty),
        DataGridCell<dynamic>(columnName: 'meter', value: e.meter),
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
        case 'meter':
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
