import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/payment_models/PaymentV2Model.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/payment_v2/payment_v2_controller.dart';
import 'package:abtxt/view/trasaction/payment_v2/payment_v2_filter.dart';
import 'package:abtxt/widgets/MyAddItemButton.dart';
import 'package:abtxt/widgets/MyFilterIconButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'add_payment_v2.dart';

class PaymentV2 extends StatefulWidget {
  const PaymentV2({super.key});

  static const String routeName = '/PaymentV2List';

  @override
  State<PaymentV2> createState() => _State();
}

class _State extends State<PaymentV2> {
  PaymentV2Controller controller = Get.put(PaymentV2Controller());
  List<PaymentV2Model> list = <PaymentV2Model>[];
  late MyDataSource dataSource;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    _api();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentV2Controller>(builder: (controller) {
      return KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            final ctrl = HardwareKeyboard.instance.isControlPressed;
            final shift = HardwareKeyboard.instance.isShiftPressed;
            if (event.logicalKey == LogicalKeyboardKey.keyQ && ctrl) {
              Get.back();
            } else if (event.logicalKey == LogicalKeyboardKey.keyF && ctrl) {
              _filter();
            } else if (event.logicalKey == LogicalKeyboardKey.keyN && ctrl) {
              _add();
            } else if (event.logicalKey == LogicalKeyboardKey.keyR && shift) {
              _api(request: controller.filterData ?? {});
            }
          }
        },
        child: CoreWidget(
          appBar: AppBar(
            title: const Text('Transaction / Payment V2'),
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
              const SizedBox(width: 12)
            ],
          ),
          loadingStatus: controller.status.isLoading,
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
                visible: false,
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
                width: 100,
                columnName: 'challan_no',
                label: const MyDataGridHeader(title: 'Challan No'),
              ),
              GridColumn(
                width: 250,
                columnName: 'ledger_name',
                label: const MyDataGridHeader(title: 'Ledger Name'),
              ),
              GridColumn(
                width: 200,
                columnName: 'firm_name',
                label: const MyDataGridHeader(title: 'Firm'),
              ),
              GridColumn(
                width: 150,
                columnName: 'payment_type',
                label: const MyDataGridHeader(title: 'Payment Type'),
              ),
              GridColumn(
                width: 110,
                columnName: 'tds_amount',
                label: const MyDataGridHeader(
                    alignment: Alignment.centerRight, title: 'TDS Amount'),
              ),
              GridColumn(
                width: 110,
                columnName: 'in_hand_amount',
                label: const MyDataGridHeader(
                    alignment: Alignment.centerRight, title: 'In Hand'),
              ),
              GridColumn(
                width: 100,
                columnName: 'credit_amount',
                label: const MyDataGridHeader(
                    alignment: Alignment.centerRight, title: 'Credit'),
              ),
              GridColumn(
                width: 100,
                columnName: 'debit_amount',
                label: const MyDataGridHeader(
                    alignment: Alignment.centerRight, title: 'Debit'),
              ),
              GridColumn(
                width: 120,
                columnName: 'net_amount',
                label: const MyDataGridHeader(
                    alignment: Alignment.centerRight, title: 'Net Amount'),
              ),
              GridColumn(
                minimumWidth: 210,
                columnName: 'details',
                label: const MyDataGridHeader(title: 'Details'),
              ),
            ],
            tableSummaryColumns: const [
              GridSummaryColumn(
                name: 'id',
                columnName: 'id',
                summaryType: GridSummaryType.count,
              ),
              GridSummaryColumn(
                name: 'net_amount',
                columnName: 'net_amount',
                summaryType: GridSummaryType.sum,
              ),
            ],
          ),
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.paymentList(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddPaymentV2.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    controller.ledgerInfo("all");
    final result = await showDialog(
      context: context,
      builder: (_) => const PaymentV2Filter(),
    );
    result != null ? _api(request: result ?? {}) : '';
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<PaymentV2Model> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<PaymentV2Model> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      double creditAmount = 0.0;
      double debitAmount = 0.0;
      double inHandeAmount = 0.0;

      e.amountDetails?.forEach((element) {
        if (element.eType == "Payment") {
          creditAmount += element.debitAmount ?? 0.0;
        } else {
          if (element.to != 3570) {
            debitAmount += element.debitAmount ?? 0.0;
          }
        }

        if (element.to == 3568) {
          inHandeAmount += element.debitAmount ?? 0.0;
        }
      });

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e.id),
        DataGridCell<dynamic>(columnName: 'e_date', value: e.eDate),
        DataGridCell<dynamic>(columnName: 'challan_no', value: e.challanNo),
        DataGridCell<dynamic>(columnName: 'ledger_name', value: e.ledgerName),
        DataGridCell<dynamic>(columnName: 'firm_name', value: e.firmName),
        DataGridCell<dynamic>(columnName: 'payment_type', value: e.paymentType),
        DataGridCell<dynamic>(
            columnName: 'tds_amount',
            value: e.tdsAmount != 0
                ? AppUtils().rupeeFormat.format(e.tdsAmount ?? 0)
                : ''),
        DataGridCell<dynamic>(
            columnName: 'in_hand_amount',
            value: inHandeAmount != 0
                ? AppUtils().rupeeFormat.format(inHandeAmount)
                : ''),
        DataGridCell<dynamic>(
            columnName: 'credit_amount',
            value: creditAmount != 0
                ? AppUtils().rupeeFormat.format(creditAmount)
                : ""),
        DataGridCell<dynamic>(
            columnName: 'debit_amount',
            value: debitAmount != 0
                ? AppUtils().rupeeFormat.format(debitAmount)
                : ""),
        DataGridCell<dynamic>(columnName: 'net_amount', value: e.totalAmount),
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
        case 'net_amount':
          return buildFormattedCell(value, decimalPlaces: 2);
        default:
          return Container(
            alignment: e.columnName == "tds_amount" ||
                    e.columnName == "credit_amount" ||
                    e.columnName == "in_hand_amount" ||
                    e.columnName == "debit_amount"
                ? Alignment.centerRight
                : Alignment.centerLeft,
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
      case 'net_amount':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
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
