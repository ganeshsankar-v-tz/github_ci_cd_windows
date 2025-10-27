import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/jari_twinsting_yarn_inward_V2/JariTwistingInwardV2Model.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/jari_twisting_yarn_inward_v2/add_jari_twisting_yarn_inward_V2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'jari_twisting_yarn_inward_V2_filter.dart';
import 'jari_twisting_yarn_inward_controller_v2.dart';

class JariTwistingYarnInwardV2 extends StatefulWidget {
  const JariTwistingYarnInwardV2({super.key});

  static const String routeName = '/Jari_twisting_yarn_inwardV2_list';

  @override
  State<JariTwistingYarnInwardV2> createState() =>
      _JariTwistingYarnInwardV2State();
}

class _JariTwistingYarnInwardV2State extends State<JariTwistingYarnInwardV2> {
  JariTwistingYarnInwardControllerV2 controller =
      Get.put(JariTwistingYarnInwardControllerV2());
  List<JariTwistingInwardV2Model> list = <JariTwistingInwardV2Model>[];
  late ItemDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = ItemDataSource(list: list);
    _api();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JariTwistingYarnInwardControllerV2>(
        builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Transaction / Jari Twisting - Yarn Inward V2'),
          centerTitle: false,
          elevation: 0,
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
            _add(args: {"item": item});
          },
          columns: <GridColumn>[
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
              minimumWidth: 210,
              columnName: 'twisting_yarn_name',
              label: const MyDataGridHeader(title: 'Twisting Yarn Name'),
            ),
            GridColumn(
              minimumWidth: 210,
              columnName: 'machine_name',
              label: const MyDataGridHeader(title: 'Machine Name'),
            ),
            GridColumn(
              minimumWidth: 210,
              columnName: 'particulars',
              label: const MyDataGridHeader(title: 'Particulars'),
            ),
            GridColumn(
              width: 100,
              columnName: 'quantity',
              label: const MyDataGridHeader(
                  alignment: Alignment.center, title: 'Quantity'),
            ),
            GridColumn(
              width: 120,
              columnName: 'total_amount',
              label: const MyDataGridHeader(
                  alignment: Alignment.center, title: 'Total Amount'),
            ),
            GridColumn(
              columnName: 'details',
              label: const MyDataGridHeader(title: 'Details'),
            )
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.jariTwistingYarnInward(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(AddJariTwistingYarnInwardV2.routeName,
        arguments: args);
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const JariTwistingYarnInwardV2Filter(),
    );
    result != null ? _api(request: result ?? {}) : '';
  }
}

class ItemDataSource extends DataGridSource {
  ItemDataSource({required List<JariTwistingInwardV2Model> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<JariTwistingInwardV2Model> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      var particulars = "";

      if (e.machineType == "TFO") {
        particulars =
            "${e.machineType}, Deck Type:${e.deckType}, SPENDILE: ${e.spendile}";
      } else if (e.machineType == "Jari") {
        particulars =
            "${e.machineType}, Deck Type:${e.deckType}, SPENDILE: ${e.spendile}";
      } else if (e.machineType == "Winder") {
        particulars = "${e.machineType}, Winding Type: ${e.windingType}";
      }

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'id', value: e.id),
        DataGridCell<dynamic>(columnName: 'e_date', value: '${e.eDate}'),
        DataGridCell<dynamic>(
            columnName: 'twisting_yarn_name', value: e.yarnName),
        DataGridCell<dynamic>(columnName: 'machine_name', value: e.machineName),
        DataGridCell<dynamic>(columnName: 'particulars', value: particulars),
        DataGridCell<dynamic>(columnName: 'quantity', value: e.grossQuantity),
        DataGridCell<dynamic>(columnName: 'total_amount', value: e.grossAmount),
        DataGridCell<dynamic>(columnName: 'details', value: e.details),
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
        case 'quantity':
          return buildFormattedCell(value, decimalPlaces: 3);
        case 'total_amount':
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

  void updateDataGridSource() {
    notifyListeners();
  }
}
