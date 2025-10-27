import 'dart:convert';

import 'package:abtxt/model/tds_report/BankSubmittedTdsDetailsModel.dart';
import 'package:abtxt/model/tds_report/TdsAmountDetailsModel.dart';
import 'package:abtxt/view/report/finance/tds_report/tds_amount_filter.dart';
import 'package:abtxt/view/report/finance/tds_report/tds_amount_report_controller.dart';
import 'package:abtxt/widgets/MySFDataGridItemTable.dart';
import 'package:abtxt/widgets/flutter_shortcut_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../utils/app_utils.dart';
import '../../../../../widgets/MyDataGridHeader.dart';
import '../../../../../widgets/MySubmitButton.dart';
import '../../../../model/FirmModel.dart';
import '../../../../widgets/MyDateFilter.dart';
import '../../../../widgets/MyDropdownButtonFormField.dart';
import '../../../../widgets/MyFilterIconButton.dart';
import '../../../../widgets/MyTextField.dart';
import '../../../../widgets/my_search_field/my_search_field.dart';

class AddTdsAmountDetails extends StatefulWidget {
  const AddTdsAmountDetails({super.key});

  static const String routeName = '/add_tds_amount_details';

  @override
  State<AddTdsAmountDetails> createState() => _State();
}

class _State extends State<AddTdsAmountDetails> {
  TdsAmountReportController controller = Get.put(TdsAmountReportController());

  final DataGridController _dataGridController = DataGridController();
  List<TdsAmountDetailsModel> itemDetails = <TdsAmountDetailsModel>[];
  late MyDataSource dataSource;

  Rxn<FirmModel> firmNameController = Rxn<FirmModel>();
  TextEditingController firmTextController = TextEditingController();
  TextEditingController paymentDateController = TextEditingController();
  TextEditingController chequeDateController = TextEditingController();
  TextEditingController chequeNoController = TextEditingController();
  TextEditingController bankNameController = TextEditingController(text: 'TMB');
  TextEditingController branchNameController =
      TextEditingController(text: "Elampillai");
  final _formKey = GlobalKey<FormState>();
  final FocusNode _firmFocusNode = FocusNode();
  final FocusNode _dateFocusNode = FocusNode();

  final RxBool isUpdate = RxBool(false);

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: itemDetails);
    _initValue();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TdsAmountReportController>(
      builder: (controller) {
        return ShortCutWidget(
          appBar: AppBar(
            title: const Text("Add TDS Banking amount"),
            actions: [
              Visibility(
                visible: Get.arguments == null,
                child: MyFilterIconButton(
                  onPressed: () => _filter(),
                  filterIcon: controller.paymentDetailsFilterData != null
                      ? true
                      : false,
                  tooltipText: "${controller.paymentDetailsFilterData}",
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          loadingStatus: controller.status.isLoading,
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.keyQ, control: true):
                GetBackIntent(),
            SingleActivator(LogicalKeyboardKey.keyF, control: true):
                FilterIntent(),
            SingleActivator(LogicalKeyboardKey.keyS, control: true):
                SaveIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              GetBackIntent: SetCounterAction(perform: () => Get.back()),
              FilterIntent: SetCounterAction(perform: () => _filter()),
              SaveIntent: SetCounterAction(perform: () => submit()),
            },
            child: FocusScope(
              autofocus: true,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Wrap(
                            children: [
                              MySearchField(
                                label: "Firm",
                                enabled: !isUpdate.value,
                                items: controller.firmDropdown,
                                textController: firmTextController,
                                focusNode: _firmFocusNode,
                                requestFocus: _dateFocusNode,
                                onChanged: (FirmModel item) {
                                  firmNameController.value = item;
                                },
                              ),
                              MyDateFilter(
                                enabled: !isUpdate.value,
                                focusNode: _dateFocusNode,
                                controller: paymentDateController,
                                labelText: "Create Date",
                              ),
                              MyDropdownButtonFormField(
                                enabled: !isUpdate.value,
                                controller: bankNameController,
                                hintText: "Bank Name",
                                items: const [
                                  "TMB",
                                  "ICICI",
                                  "CANARA",
                                  "AXIS",
                                ],
                              ),
                              MyTextField(
                                controller: branchNameController,
                                hintText: "Branch Name",
                                enabled: false,
                              ),
                              MyDateFilter(
                                enabled: !isUpdate.value,
                                controller: chequeDateController,
                                labelText: "Cheque Date",
                              ),
                              MyTextField(
                                enabled: !isUpdate.value,
                                controller: chequeNoController,
                                hintText: "Cheque No",
                                validate: "string",
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: ExcludeFocusTraversal(
                        child: MySFDataGridItemTable(
                          shrinkWrapRows: false,
                          showCheckboxColumn: !isUpdate.value,
                          controller: _dataGridController,
                          selectionMode: SelectionMode.multiple,
                          scrollPhysics: const ScrollPhysics(),
                          source: dataSource,
                          columns: [
                            GridColumn(
                              visible: false,
                              columnName: 'id',
                              label: const MyDataGridHeader(title: 'Id'),
                            ),
                            GridColumn(
                              width: 150,
                              columnName: 'e_date',
                              label: const MyDataGridHeader(title: 'Date'),
                            ),
                            GridColumn(
                              width: 100,
                              columnName: 'challan_no',
                              label: const MyDataGridHeader(title: 'Slip No'),
                            ),
                            GridColumn(
                              columnName: 'ledger_name',
                              label:
                                  const MyDataGridHeader(title: 'Ledger Name'),
                            ),
                            GridColumn(
                              columnName: 'account_no',
                              label:
                                  const MyDataGridHeader(title: 'Account No'),
                            ),
                            GridColumn(
                              columnName: 'account_holder',
                              label: const MyDataGridHeader(
                                  title: 'Account Holder'),
                            ),
                            GridColumn(
                              columnName: 'pan_no',
                              label: const MyDataGridHeader(title: 'Pan No'),
                            ),
                            GridColumn(
                              columnName: 'pan_name',
                              label: const MyDataGridHeader(title: 'Pan Name'),
                            ),
                            GridColumn(
                              width: 150,
                              columnName: 'tds_amount',
                              label: const MyDataGridHeader(
                                  alignment: Alignment.center,
                                  title: 'TDS Amount'),
                            ),
                          ],
                          tableSummaryRows: [
                            GridTableSummaryRow(
                              showSummaryInRow: false,
                              title: "",
                              titleColumnSpan: 1,
                              columns: [
                                const GridSummaryColumn(
                                  name: 'tds_amount',
                                  columnName: 'tds_amount',
                                  summaryType: GridSummaryType.sum,
                                ),
                              ],
                              position: GridTableSummaryRowPosition.bottom,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Visibility(
                      visible: Get.arguments == null,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: MySubmitButton(
                              onPressed:
                                  controller.status.isLoading ? null : submit),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  submit() async {
    if (isUpdate.value == true) {
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (_dataGridController.selectedRows.isEmpty) {
        return AppUtils.infoAlert(message: "Select the TDS Amount Details");
      }

      submitAlert();
    }
  }

  void _initValue() async {
    controller.paymentDetailsFilterData = null;
    paymentDateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    chequeDateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    if (Get.arguments != null) {
      BankSubmittedTdsDetailsModel item = Get.arguments["item"];
      isUpdate.value = true;

      firmNameController.value =
          FirmModel(id: item.firmId, firmName: item.firmName);
      firmTextController.text = "${item.firmName}";
      paymentDateController.text = "${item.paymentDate}";
      bankNameController.text = item.bankName ?? "TMB";
      chequeDateController.text = "${item.chequeDate}";
      chequeNoController.text = "${item.chequeNo}";

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        var result = await controller.tdsAmountPdf(request: {
          "id": item.id,
        });

        var response = (result["payment_details"] as List)
            .map((e) => TdsAmountDetailsModel.fromJson(e));

        itemDetails.addAll(response);
        dataSource.updateDataGridRows();
      });
    }
  }

  submitAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: SizedBox(
            height: 160,
            width: 400,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/approveicon.png',
                  color: const Color(0xFF2196F3),
                  width: 300,
                  height: 120,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Are you sure you want to submit?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            button("YES", Colors.white, const Color(0xff5700BC), () async {
              var paymentIds = [];

              Map<String, dynamic> request = {
                "firm_id": firmNameController.value?.id,
                "payment_date": paymentDateController.text,
                "cheque_no": chequeNoController.text,
                "bank_name": bankNameController.text,
                "branchNameController": branchNameController.text,
                "cheque_date": chequeDateController.text,
                "branch_name": branchNameController.text,
              };

              double totalAmount = 0.0;

              var selectedRows = _dataGridController.selectedRows;

              for (var e in selectedRows) {
                var selectedRow = e.getCells();
                paymentIds.add(selectedRow[0].value);
                totalAmount +=
                    double.tryParse("${selectedRow[8].value}") ?? 0.0;
              }

              request["total_amount"] = totalAmount;
              request["payment_id"] = paymentIds;

              var result = await controller.selectedAmountSubmit(request);

              if (result == "success") {
                Get.back();
                Get.back(result: "success");
              }
            }),
            button("NO", Colors.black, const Color(0xffE3E3E3), () {
              Get.back();
            }),
          ],
        );
      },
    );
  }

  Widget button(String text, Color textColor, backGround, Function function) {
    return OutlinedButton(
      autofocus: true,
      onPressed: () {
        function();
      },
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(180, 46)),
        foregroundColor: WidgetStateProperty.resolveWith((states) => textColor),
        shape: WidgetStateProperty.resolveWith((s) =>
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return Colors.grey;
          }
          return backGround;
        }),
      ),
      child: Text(text),
    );
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const TdsAmountFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
  }

  void _api({var request = const {}}) async {
    var response = await controller.tdsAmountDetails(request: request);
    itemDetails.clear();
    itemDetails.addAll(response);
    dataSource.updateDataGridRows();
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<TdsAmountDetailsModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<TdsAmountDetailsModel> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'id', value: e.paymentId),
        DataGridCell<dynamic>(columnName: 'e_date', value: e.eDate),
        DataGridCell<dynamic>(columnName: 'challan_no', value: e.challanNo),
        DataGridCell<dynamic>(columnName: 'ledger_name', value: e.ledgerName),
        DataGridCell<dynamic>(columnName: 'account_no', value: e.accountNo),
        DataGridCell<dynamic>(
            columnName: 'account_holder', value: e.accountHolder),
        DataGridCell<dynamic>(columnName: 'pan_no', value: e.panNo),
        DataGridCell<dynamic>(columnName: 'pan_name', value: e.panName),
        DataGridCell<dynamic>(columnName: 'tds_amount', value: e.tdsAmount),
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
        case 'tds_amount':
          return buildFormattedCell(value, decimalPlaces: 2);
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
      case 'tds_amount':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      default:
        return null;
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
