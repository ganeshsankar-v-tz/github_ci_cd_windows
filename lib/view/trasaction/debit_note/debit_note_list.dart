import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/widgets/MyFilterIconButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../utils/app_utils.dart';
import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'add_debit_note.dart';
import 'debit_note_controller.dart';
import 'debit_note_filter.dart';

class DebitNoteList extends StatefulWidget {
  const DebitNoteList({super.key});

  static const String routeName = '/debit_note_list';

  @override
  State<DebitNoteList> createState() => _DebitNoteListState();
}

class _DebitNoteListState extends State<DebitNoteList> {
  DebitNoteController controller = Get.find<DebitNoteController>();
  List<dynamic> list = <dynamic>[];
  late MyDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dataSource = MyDataSource(list: list);
      _api();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DebitNoteController>(
      builder: (controller) {
        return CoreWidget(
          loadingStatus: controller.status.isLoading,
          bindings: {
            const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
                Get.back(),
            const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
                _filter(),
            const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
                _api(request: controller.filterData),
            const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
                _add(),
          },
          appBar: AppBar(
            title: const Text('Debit Note'),
            actions: [
              MyRefreshIconButton(
                  onPressed: () => _api(request: controller.filterData)),
              const SizedBox(width: 12),
              MyFilterIconButton(
                  onPressed: () => _filter(),
                  filterIcon: controller.filterData.isNotEmpty ? true : false,
                  tooltipText: "${controller.filterData}"),
              const SizedBox(width: 12),
              MyAddItemButton(onPressed: () => _add()),
              const SizedBox(width: 12),
            ],
          ),
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
                visible: false,
                label: const MyDataGridHeader(title: 'ID'),
              ),
              GridColumn(
                width: 105,
                columnName: 'e_date',
                label: const MyDataGridHeader(title: 'Date'),
              ),
              GridColumn(
                columnName: 'debit_note_type',
                label: const MyDataGridHeader(title: 'Debit Note Type'),
              ),
              GridColumn(
                width: 110,
                columnName: 'invoice_no',
                label: const MyDataGridHeader(title: 'Invoice No'),
              ),
              GridColumn(
                width: 215,
                columnName: 'ledger_name',
                label: const MyDataGridHeader(title: 'Ledger Name'),
              ),
              GridColumn(
                width: 210,
                columnName: 'firm_name',
                label: const MyDataGridHeader(title: 'Firm Name'),
              ),
              GridColumn(
                columnName: 'details',
                label: const MyDataGridHeader(title: 'Details'),
              ),
            ],
            tableSummaryColumns: const [
              GridSummaryColumn(
                name: 'net_total',
                columnName: 'net_total',
                summaryType: GridSummaryType.sum,
              ),
              GridSummaryColumn(
                name: 'net_qty',
                columnName: 'net_qty',
                summaryType: GridSummaryType.sum,
              ),
            ],
          ),
        );
      },
    );
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(AddDebitNote.routeName, arguments: args);
    if (result == true) {
      _api(request: controller.filterData);
    }
  }

  Future<void> _api({var request = const {}}) async {
    var response = await controller.debitNoteList(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const DebitNoteFilter(),
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
        DataGridCell<int>(columnName: 'id', value: e["id"]),
        DataGridCell<dynamic>(columnName: 'e_date', value: '${e["e_date"]}'),
        DataGridCell<dynamic>(
            columnName: 'debit_note_type', value: '${e["debit_note_type"]}'),
        DataGridCell<dynamic>(columnName: 'invoice_no', value: e["invoice_no"]),
        DataGridCell<dynamic>(
            columnName: 'supplier_name', value: e["supplier_name"]),
        DataGridCell<dynamic>(columnName: 'firm_name', value: e["firm_name"]),
        DataGridCell<dynamic>(columnName: 'details', value: e["details"]),
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
        case 'net_total':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'net_qty':
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

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    final columnName = summaryColumn?.columnName;
    double parsedValue = double.tryParse(summaryValue) ?? 0;
    TextAlign alignment;

    switch (columnName) {
      case 'net_total':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      case 'net_qty':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 3, alignment: alignment);
      default:
        alignment = TextAlign.left;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
    }
  }

  Widget _buildFormattedCell(double value,
      {int decimalPlaces = 0, required TextAlign alignment}) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      decimalDigits: decimalPlaces,
      name: '',
    );
    return Container(
      padding: const EdgeInsets.all(8.0),
      // alignment: Alignment.center,
      child: Text(
        formatter.format(value),
        style: AppUtils.footerTextStyle(),
        textAlign: alignment,
      ),
    );
  }
}
