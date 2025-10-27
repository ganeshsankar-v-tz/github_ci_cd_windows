import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/weaving_models/WarpOrYarnDeliveryListModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/production/warp_or_yarn_delivery/warp_or_yarn_delivery_controller.dart';
import 'package:abtxt/view/production/warp_or_yarn_delivery/warp_or_yarn_delivery_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'add_warp_or_yarn_screen.dart';

class WarpOrYarnDeliveryProduction extends StatefulWidget {
  const WarpOrYarnDeliveryProduction({super.key});

  static const String routeName = '/warporyarndeliveryproduction';

  @override
  State<WarpOrYarnDeliveryProduction> createState() =>
      _WarpOrYarnDeliveryProductionState();
}

class _WarpOrYarnDeliveryProductionState
    extends State<WarpOrYarnDeliveryProduction> {
  WarpOrYarnDeliveryController controller =
      Get.put(WarpOrYarnDeliveryController());
  List<WarpOrYarnDeliveryListModel> list = <WarpOrYarnDeliveryListModel>[];
  late MyDataSource dataSource;
  late CustomSelectionManager _customSelectionManager;


  @override
  void initState() {
    super.initState();
    _customSelectionManager = CustomSelectionManager(
      refresh: () => _api(request: controller.filterData ?? {}),
      filter: _filter,
      addItem: _add,
    );
    dataSource = MyDataSource(list: list);
    _api();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpOrYarnDeliveryController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Production - Warp / Yarn Delivery'),
          actions: [
            MyRefreshIconButton(onPressed: () => _api(request: controller.filterData ?? {})),
            const SizedBox(width: 12),
            MyFilterIconButton(
                onPressed: () => _filter(),
                filterIcon: controller.filterData != null ? true : false,
                tooltipText: "${controller.filterData}"),
            const SizedBox(width: 12),
            MyAddItemButton(onPressed: () => _add()),
            const SizedBox(width: 12),
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
          areFocusable: true,
          selectionManager: _customSelectionManager,
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            var request = {
              'challan_no': item.challanNo,
              'rec_no': item.id,
              "creator_name": item.creatorName,
              "updated_name": item.updatedName,
              "updated_at": item.updatedAt,
              "created_at": item.createdAt,
            };
            _add(args: {'item': request});
          },
          columns: <GridColumn>[
            GridColumn(
              columnName: 'id',
              width: 80,
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 120,
              columnName: 'e_date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              width: 120,
              columnName: 'challan_no',
              label: const MyDataGridHeader(title: 'Challan No'),
            ),
            GridColumn(
              columnName: 'weaver_name',
              label: const MyDataGridHeader(title: 'Weaver Name'),
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
    var response = await controller.WarporYarnDelivery(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(AddWarporYarnDeliveryProduction.routeName,
        arguments: args);
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const WarpOrYarnDeliveryFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<WarpOrYarnDeliveryListModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<WarpOrYarnDeliveryListModel> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      var details = e.entryType?.split(",").toSet().toString();

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e.id),
        DataGridCell<dynamic>(columnName: 'e_date', value: e.eDate),
        DataGridCell<int>(columnName: 'challan_no', value: e.challanNo),
        DataGridCell<dynamic>(columnName: 'weaver_name', value: e.weaverName),
        DataGridCell<dynamic>(
            columnName: 'details',
            value: details?.replaceAll("{", "").replaceAll("}", "")),
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
class CustomSelectionManager extends RowSelectionManager {
  CustomSelectionManager({
    required this.refresh,
    required this.addItem,
    required this.filter,
  });

  Function() refresh, addItem, filter;

  @override
  Future<void> handleKeyEvent(KeyEvent keyEvent) async {
    final ctrl = HardwareKeyboard.instance.isControlPressed;
    final shift = HardwareKeyboard.instance.isShiftPressed;

    if (ctrl && keyEvent.logicalKey == LogicalKeyboardKey.keyQ) {
      Get.back();
    } else if (ctrl && keyEvent.logicalKey == LogicalKeyboardKey.keyN) {
      addItem();
    } else if (shift && keyEvent.logicalKey == LogicalKeyboardKey.keyR) {
      refresh();
    }  else if (ctrl && keyEvent.logicalKey == LogicalKeyboardKey.keyF) {
      filter();
    } else if (keyEvent.logicalKey == LogicalKeyboardKey.enter) {
      addItem();
      return;
    }
    super.handleKeyEvent(keyEvent);
  }
}

