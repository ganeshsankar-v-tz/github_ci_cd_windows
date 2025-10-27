import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/weaving_models/GoodsInwardListModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/production/goods_inward_slip/goods_inward_slip_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import '../../trasaction/payment_v2/add_payment_v2.dart';
import 'add_goods_inward_slip.dart';
import 'goods_inward_slip_controller.dart';

class GoodsInwardSlipScreen extends StatefulWidget {
  const GoodsInwardSlipScreen({super.key});

  static const String routeName = '/GoodsInwardSlipscreen';

  @override
  State<GoodsInwardSlipScreen> createState() => _State();
}

class _State extends State<GoodsInwardSlipScreen> {
  GoodsInwardSlipController controller = Get.put(GoodsInwardSlipController());
  List<GoodsInwardListModel> list = <GoodsInwardListModel>[];
  late MyDataSource dataSource;

  final DataGridController _dataGridController = DataGridController();
  late CustomSelectionManager _customSelectionManager;

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    _customSelectionManager = CustomSelectionManager(
      refresh: () => _api(request: controller.filterData ?? {}),
      filter: _filter,
      addItem: _add,
      paymentScreen: _paymentScreen,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _api();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoodsInwardSlipController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Production / Goods Inward Slip'),
          actions: [
            MyRefreshIconButton(
                onPressed: () => _api(request: controller.filterData ?? {})),
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
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
              _add(),
          const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
              _filter(),
          const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
              _api(request: controller.filterData ?? {}),
          const SingleActivator(LogicalKeyboardKey.keyP, control: true): () =>
              _paymentScreen(),
        },
        loadingStatus: controller.status.isLoading,
        child: MySFDataGridRawTable(
          areFocusable: true,
          selectionManager: _customSelectionManager,
          source: dataSource,
          controller: _dataGridController,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            var request = {
              'challan_no': item.challanNo,
              'rec_no': item.id,
              "wages": item.wagesStatus,
              "creator_name": item.creatorName,
              "updated_name": item.updatedName,
              "updated_at": item.updatedAt,
              "created_at": item.createdAt,
            };
            _add(args: {'item': request});
          },
          columns: <GridColumn>[
            GridColumn(
              width: 120,
              columnName: 'e_date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              columnName: 'challan_no',
              label: const MyDataGridHeader(title: 'Challan No'),
            ),
            GridColumn(
              columnName: 'weaver_name',
              label: const MyDataGridHeader(title: 'Weaver Name'),
            ),
            GridColumn(
              columnName: 'qty_pcs',
              label: const MyDataGridHeader(title: 'Qty / Pcs'),
            ),
            GridColumn(
              columnName: 'wages_status',
              label: const MyDataGridHeader(title: 'Status'),
            ),
          ],
          tableSummaryColumns: const [
            GridSummaryColumn(
              name: 'e_date',
              columnName: 'e_date',
              summaryType: GridSummaryType.count,
            ),
            GridSummaryColumn(
              name: 'qty_pcs',
              columnName: 'qty_pcs',
              summaryType: GridSummaryType.sum,
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.goodsInward(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
    if (controller.paymentSaveToApiCall.value == false) {
      _dataGridController.scrollToRow(
        position: DataGridScrollPosition.end,
        dataSource.rows.length - 1,
      );
    }
  }

  void _add({Map<String, dynamic>? args}) async {
    var result =
        await Get.toNamed(AddGoodsInwardSlip.routeName, arguments: args);
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    } else if (controller.paymentSaveToApiCall.value == true) {
      _api(request: controller.filterData ?? {});
    } else if (controller.shortCutToSave == true) {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const GoodsInwardSlipFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
  }

  void _paymentScreen() async {
    var arg = {
      "firm_name": "A B TEX PRIVATE LIMITED",
      "payment_type": "Weaver Amount",
    };

    Get.toNamed(AddPaymentV2.routeName, arguments: arg);
  }
}

class CustomSelectionManager extends RowSelectionManager {
  CustomSelectionManager({
    required this.refresh,
    required this.addItem,
    required this.paymentScreen,
    required this.filter,
  });

  Function() refresh, addItem, paymentScreen, filter;

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
    } else if (ctrl && keyEvent.logicalKey == LogicalKeyboardKey.keyP) {
      paymentScreen();
    } else if (ctrl && keyEvent.logicalKey == LogicalKeyboardKey.keyF) {
      filter();
    } else if (keyEvent.logicalKey == LogicalKeyboardKey.enter) {
      addItem();
      return;
    }
    super.handleKeyEvent(keyEvent);
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<GoodsInwardListModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<GoodsInwardListModel> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'e_date', value: e.eDate),
        DataGridCell<dynamic>(columnName: 'challan_no', value: e.challanNo),
        DataGridCell<dynamic>(columnName: 'weaver_name', value: e.weaverName),
        DataGridCell<dynamic>(columnName: 'qty_pcs', value: e.qty),
        DataGridCell<dynamic>(
            columnName: 'status',
            value: e.wagesStatus == 'Pending' ? '' : e.wagesStatus),
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
