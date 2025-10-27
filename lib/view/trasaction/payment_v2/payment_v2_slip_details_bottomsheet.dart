import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/trasaction/payment_v2/payment_v2_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/payment_models/LedgerBySlipDetails.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyElevatedButton.dart';

class PaymentV2SlipDetailsBottomSheet extends StatefulWidget {
  const PaymentV2SlipDetailsBottomSheet({super.key});

  @override
  State<PaymentV2SlipDetailsBottomSheet> createState() => _State();
}

class _State extends State<PaymentV2SlipDetailsBottomSheet> {
  PaymentV2Controller controller = Get.find();
  List<LedgerBySlipDetails> list = <LedgerBySlipDetails>[];
  late MyDataSource dataSource;
  final DataGridController _dataGridController = DataGridController();
  late CustomSelectionManager _customSelectionManager;
  final FocusNode _focusNode = FocusNode();
  var totalAmount = 0.0.obs;
  var rowCount = 0.obs;
  var totalQty = 0.0.obs;

  @override
  void initState() {
    _initState();
    super.initState();
    dataSource = MyDataSource(
        list: list,
        totalAmount: totalAmount,
        rowCount: rowCount,
        totalQty: totalQty);
    _customSelectionManager =
        CustomSelectionManager(_dataGridController, dataSource, submit);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentV2Controller>(builder: (controller) {
      return KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            final ctrl = HardwareKeyboard.instance.isControlPressed;
            if (event.logicalKey == LogicalKeyboardKey.keyQ && ctrl) {
              Get.back();
            } else if (event.logicalKey == LogicalKeyboardKey.keyS && ctrl) {
              submit();
            }
          }
        },
        child: CoreWidget(
          appBar: AppBar(title: const Text('Add Item Slip Details')),
          loadingStatus: controller.status.isLoading,
          child: LayoutBuilder(
            builder: (BuildContext ctx, BoxConstraints constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    color: Colors.white,
                    height: constraints.maxHeight - 46,
                    child: SfDataGridTheme(
                      data: const SfDataGridThemeData(
                        selectionColor: Color(0xffA3D8FF),
                        headerColor: Color(0xFFF4F2FF),
                        gridLineStrokeWidth: 0.3,
                        gridLineColor: Color(0xEFAAAAAA),
                      ),
                      child: SfDataGrid(
                        navigationMode: GridNavigationMode.row,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        showCheckboxColumn: true,
                        shrinkWrapRows: false,
                        verticalScrollPhysics: const ScrollPhysics(),
                        selectionMode: SelectionMode.multiple,
                        columnWidthMode: ColumnWidthMode.fill,
                        controller: _dataGridController,
                        selectionManager: _customSelectionManager,
                        onSelectionChanged: (List<DataGridRow> addedRows,
                            List<DataGridRow> removedRows) {
                          var items = _dataGridController.selectedRows;
                          double total = 0;
                          double qty = 0;
                          for (var row in items) {
                            var creditAmount = row.getCells()[3].value;
                            var qtyCount = row.getCells()[2].value;
                            total = total + creditAmount;
                            qty = qty + qtyCount;
                          }
                          rowCount.value = items.length;
                          totalAmount.value = total;
                          totalQty.value = qty;
                        },
                        onQueryRowHeight: (details) {
                          return details
                                  .getIntrinsicRowHeight(details.rowIndex) *
                              0.7;
                        },
                        columns: [
                          GridColumn(
                            columnName: 'id',
                            width: 100,
                            label: const MyDataGridHeader(title: 'Slip'),
                          ),
                          GridColumn(
                            width: 120,
                            columnName: 'e_date',
                            label: const MyDataGridHeader(title: 'Date'),
                          ),
                          GridColumn(
                            columnName: 'qty',
                            label: const MyDataGridHeader(title: 'Qty'),
                          ),
                          GridColumn(
                            columnName: 'credit_amount',
                            label:
                                const MyDataGridHeader(title: 'Credit Amount'),
                          ),
                        ],
                        tableSummaryRows: [
                          GridTableSummaryRow(
                            showSummaryInRow: false,
                            title: 'Total: ',
                            titleColumnSpan: 2,
                            columns: [
                              const GridSummaryColumn(
                                name: 'e_date',
                                columnName: 'e_date',
                                summaryType: GridSummaryType.count,
                              ),
                              const GridSummaryColumn(
                                name: 'qty',
                                columnName: 'qty',
                                summaryType: GridSummaryType.count,
                              ),
                              const GridSummaryColumn(
                                name: 'credit_amount',
                                columnName: 'credit_amount',
                                summaryType: GridSummaryType.sum,
                              ),
                            ],
                            position: GridTableSummaryRowPosition.bottom,
                          ),
                        ],
                        source: dataSource,
                      ),
                    ),
                  ),
                  MyElevatedButton(
                    onPressed: () => submit(),
                    child: const Text('ADD'),
                  ),
                ],
              );
            },
          ),
        ),
      );
    });
  }

  submit() async {
    var selectedList = [];
    var items = _dataGridController.selectedRows;
    for (var row in items) {
      var slipNo = row.getCells()[0].value;
      var eDate = row.getCells()[1].value;
      var qty = row.getCells()[2].value;
      var creditAmount = row.getCells()[3].value;
      var item = {
        "slip_rec_no": slipNo,
        "slip_date": eDate,
        "qty": qty,
        "credit_amount": creditAmount,
      };
      selectedList.add(item);
    }

    if (selectedList.isNotEmpty) {
      Get.back(result: selectedList);
    } else {
      AppUtils.showErrorToast(message: "Selected The Slip");
    }
  }

  _initState() {
    var id = controller.request["ledger_id"];
    var payType = controller.request["payment_type"];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var item = await controller.ledgerBySlipDetails(id, payType);
      for (var element in item) {
        list.add(element);
        dataSource.updateDataGridRows();
        dataSource.notifyListeners();
      }

      //FOCUS THE CHECK BOX
      FocusScope.of(context).nextFocus();
      if (list.isNotEmpty) {
        FocusScope.of(context).nextFocus();
        FocusScope.of(context).nextFocus();
      }
    });
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({
    required List<LedgerBySlipDetails> list,
    required RxDouble totalAmount,
    required RxInt rowCount,
    required RxDouble totalQty,
  }) {
    _list = list;
    _totalAmount = totalAmount;
    _rowCount = rowCount;
    _totalQty = totalQty;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<LedgerBySlipDetails> _list;
  late RxDouble _totalAmount;
  late RxInt _rowCount;
  late RxDouble _totalQty;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e.id),
        DataGridCell<dynamic>(columnName: 'e_date', value: e.eDate),
        DataGridCell<dynamic>(columnName: 'qty', value: e.qty),
        DataGridCell<dynamic>(
            columnName: 'credit_amount', value: e.creditAmount),
      ]);
    }).toList();
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    if (summaryColumn?.columnName == "credit_amount") {
      return Container(
        padding: const EdgeInsets.all(8),
        child: Obx(
          () => Text(
            "${_rowCount.value == 0 ? 0 : '${_totalAmount.value} (${_rowCount.value})'}",
            style: AppUtils.footerTextStyle(),
          ),
        ),
      );
    } else if (summaryColumn?.columnName == "qty") {
      return Container(
        padding: const EdgeInsets.all(8),
        child: Obx(
          () => Text(
            "${_rowCount.value == 0 ? 0 : '${_totalQty.value} (${_rowCount.value})'}",
            style: AppUtils.footerTextStyle(),
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(8),
        child: Text(
          summaryValue,
          style: AppUtils.footerTextStyle(),
        ),
      );
    }
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    // final index = _employeeData.indexOf(row);
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                /*if (e.columnName == 'action') {
                  return Checkbox(
                    value: _list[index].select,
                    onChanged: (bool? value) {
                      _list[index].select = value;
                      notifyDataSourceListeners(rowColumnIndex: RowColumnIndex(index, 0));
                    },
                  );
                } else {
                  return Text(e.value.toString());
                }*/
                return Text(
                  e.value != null ? '${e.value}' : '',
                  style: AppUtils.cellTextStyle(),
                );
              },
            ));
      }).toList(),
    );
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}

class CustomSelectionManager extends RowSelectionManager {
  CustomSelectionManager(
      this.dataGridController, this.dataSource, this.callback);

  DataGridController dataGridController;
  MyDataSource dataSource;
  Function callback;

  @override
  Future<void> handleKeyEvent(KeyEvent keyEvent) async {
    List<DataGridRow> selectedRows = dataGridController.selectedRows;
    final ctrl = HardwareKeyboard.instance.isControlPressed;
    if (keyEvent.logicalKey == LogicalKeyboardKey.enter) {
      if (dataGridController.currentCell.rowIndex >= 0) {
        var index = dataGridController.currentCell.rowIndex;
        DataGridRow row = dataSource.effectiveRows[index];
        if (dataGridController.selectedRows.isNotEmpty &&
            dataGridController.selectedRows.contains(row)) {
          // Remove the row when the Enter key is pressed.
          selectedRows.remove(row);

          // When the selectionMode property is in multiple,
          // clear the selection from grid rows by setting the DataGridController.selectedRows to empty.
          dataGridController.selectedRows = [];

          // Update the selected rows.
          dataGridController.selectedRows = selectedRows;
          return;
        } else {
          dataGridController.selectedIndex =
              dataGridController.currentCell.rowIndex;
        }
      }
      return;
    } else if (ctrl && keyEvent.logicalKey == LogicalKeyboardKey.keyQ) {
      Get.back();
    } else if (ctrl && keyEvent.logicalKey == LogicalKeyboardKey.keyS) {
      callback();
    }
    super.handleKeyEvent(keyEvent);
  }
}
