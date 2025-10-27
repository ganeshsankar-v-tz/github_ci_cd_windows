import 'package:abtxt/model/AccountModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/payment_v2/add_payment_v2.dart';
import 'package:abtxt/view/trasaction/payment_v2/payment_v2_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../utils/constant.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class PaymentV2PayDetailsBottomSheet extends StatefulWidget {
  final List<dynamic> paymentList;
  final PaymentDataSource paymentDataSource;
  final Function paidAmountCalculation;

  const PaymentV2PayDetailsBottomSheet({
    super.key,
    required this.paymentList,
    required this.paymentDataSource,
    required this.paidAmountCalculation,
  });

  @override
  State<PaymentV2PayDetailsBottomSheet> createState() => _State();
}

class _State extends State<PaymentV2PayDetailsBottomSheet> {
  TextEditingController entryTypeController = TextEditingController();
  final _selectedEntryType = Constants.Wagesbill_Entrytype[0].obs;
  final FocusNode _entryTypeFocusNode = FocusNode();
  var itemList = <dynamic>[];
  late DataSource dataSource;

  /// Payment Controllers
  Rxn<AccountModel> paymentTo = Rxn<AccountModel>();
  TextEditingController paymentAmountController = TextEditingController();
  TextEditingController paymentDetailsController = TextEditingController();

  /// Debit Controllers
  Rxn<AccountModel> debitTo = Rxn<AccountModel>();
  TextEditingController debitAmountController = TextEditingController();
  TextEditingController debitDetailsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  PaymentV2Controller controller = Get.find();

  @override
  void initState() {
    _initValue();
    super.initState();
    dataSource = DataSource(list: itemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentV2Controller>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(title: const Text('Add Item Payment')),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () => Get.back()),
            SaveIntent: SetCounterAction(perform: () => submit()),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              MyDropdownButtonFormField(
                                autofocus: true,
                                controller: entryTypeController,
                                hintText: "Entry Type",
                                items: Constants.Wagesbill_Entrytype,
                                onChanged: (value) {
                                  _selectedEntryType.value = value;
                                },
                                focusNode: _entryTypeFocusNode,
                              ),
                            ],
                          ),
                          Obx(() => updateWidget(_selectedEntryType.value)),
                          const SizedBox(height: 12),
                          itemTable(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: MyElevatedButton(
                          onPressed: () => submit(),
                          child: const Text('ADD'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget updateWidget(String option) {
    return GetBuilder<PaymentV2Controller>(builder: (controller) {
      if (option == 'Payment') {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Obx(
                  () => MyAutoComplete(
                    forceNextFocus: true,
                    label: 'To',
                    items: controller.paymentAccounts,
                    selectedItem: paymentTo.value,
                    onChanged: (AccountModel item) async {
                      paymentTo.value = item;
                    },
                  ),
                ),
                Focus(
                    skipTraversal: true,
                    child: MyTextField(
                      controller: paymentAmountController,
                      hintText: 'Amount (Rs)',
                      validate: 'double',
                    ),
                    onFocusChange: (hasFocus) {
                      AppUtils.fractionDigitsText(paymentAmountController,
                          fractionDigits: 2);
                    }),
              ],
            ),
            Row(
              children: [
                MyTextField(
                  controller: paymentDetailsController,
                  hintText: 'Details',
                ),
              ],
            ),
          ],
        );
      } else if (option == "Debit") {
        return Wrap(
          children: [
            Row(
              children: [
                Obx(
                  () => MyAutoComplete(
                    forceNextFocus: true,
                    label: 'To',
                    items: controller.debitAccounts,
                    selectedItem: debitTo.value,
                    onChanged: (AccountModel item) async {
                      debitTo.value = item;
                    },
                  ),
                ),
                Focus(
                    skipTraversal: true,
                    child: MyTextField(
                      controller: debitAmountController,
                      hintText: 'Amount (Rs)',
                      validate: 'double',
                    ),
                    onFocusChange: (hasFocus) {
                      AppUtils.fractionDigitsText(debitAmountController,
                          fractionDigits: 2);
                    }),
              ],
            ),
            Row(
              children: [
                MyTextField(
                  controller: debitDetailsController,
                  hintText: 'Details',
                ),
              ],
            ),
          ],
        );
      } else {
        return Container();
      }
    });
  }

  Widget itemTable() {
    return ExcludeFocusTraversal(
      child: MySFDataGridItemTable(
        scrollPhysics: const AlwaysScrollableScrollPhysics(),
        shrinkWrapRows: false,
        columns: [
          GridColumn(
            columnName: 'particulars',
            label: const MyDataGridHeader(title: 'Particulars'),
          ),
          GridColumn(
            columnName: 'amount',
            label: const MyDataGridHeader(title: 'Amount'),
          ),
        ],
        tableSummaryRows: [
          GridTableSummaryRow(
            showSummaryInRow: false,
            title: 'Total: ',
            titleColumnSpan: 1,
            columns: [
              const GridSummaryColumn(
                name: 'qty',
                columnName: 'qty',
                summaryType: GridSummaryType.sum,
              ),
              const GridSummaryColumn(
                name: 'amount',
                columnName: 'amount',
                summaryType: GridSummaryType.sum,
              ),
            ],
            position: GridTableSummaryRowPosition.bottom,
          ),
        ],
        source: dataSource,
      ),
    );
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      if (entryTypeController.text == "Payment") {
        for (var e in widget.paymentList) {
          if ((e["to_name"] == "In-Hand" &&
                  paymentTo.value?.name == "In-Hand") ||
              (e["to_name"] == "In-Account" &&
                  paymentTo.value?.name == "In-Account")) {
            return AppUtils.infoAlert(
                message: "Already ${e["to_name"]} Amount added");
          }
        }
      } else {
        for (var e in widget.paymentList) {
          if ((e["to_name"] == "Advance Amount" &&
                  debitTo.value?.name == "Advance Amount") ||
              (e["to_name"] == "Mid Amount" &&
                  debitTo.value?.name == "Mid Amount")) {
            return AppUtils.infoAlert(message: "Already ${e["to_name"]} added");
          }
        }
      }

      controller.paymentAmount = 0.00;
      var entryType = _selectedEntryType.value.toString();
      var payType = controller.payType;
      Map<String, dynamic> request = {
        "e_type": entryType,
      };
      if (entryType == "Payment") {
        var payment = double.tryParse(paymentAmountController.text) ?? 0.0;
        if (payType == "Advance Amount" || payType == "Mid Amount") {
          request["to"] = paymentTo.value?.id;
          request["to_name"] = paymentTo.value?.name;
          request["debit_amount"] = payment;
          request["details"] = paymentDetailsController.text;
          dataSourcesUpdate(request);
        } else {
          request["to"] = paymentTo.value?.id;
          request["to_name"] = paymentTo.value?.name;
          request["debit_amount"] = payment;
          request["details"] = paymentDetailsController.text;
          dataSourcesUpdate(request);
        }
      } else {
        var debit = double.tryParse(debitAmountController.text) ?? 0;
        if (payType == "Advance Amount" || payType == "Mid Amount") {
          AppUtils.infoAlert(
              message:
                  "Advance, Mid And Other Amounts Only Payment Option Available");
        } else {
          if (debit <= controller.totalAmount && debit != 0.0) {
            request["to"] = debitTo.value?.id;
            request["to_name"] = debitTo.value?.name;
            request["debit_amount"] = debit;
            request["details"] = debitDetailsController.text;
            dataSourcesUpdate(request);
          } else {
            AppUtils.infoAlert(
                message: "Payment Is Less Then Or Grater Than To Total Wages");
          }
        }
      }
    }
  }

  dataSourcesUpdate(Map<String, dynamic> request) {
    widget.paymentList.add(request);
    widget.paidAmountCalculation();
    widget.paymentDataSource.updateDataGridRows();
    widget.paymentDataSource.updateDataGridSource();
    controllerClear();
  }

  controllerClear() {
    var amount = controller.paymentAmount;
    paymentTo.value = null;
    paymentAmountController.text = "$amount";
    paymentDetailsController.text = "";

    debitTo.value = null;
    debitAmountController.text = "$amount";
    debitDetailsController.text = "";

    FocusScope.of(context).requestFocus(_entryTypeFocusNode);
  }

  Future<void> _initValue() async {
    entryTypeController.text = Constants.Wagesbill_Entrytype[0];

    /// Advance Amount Details
    var item = controller.advanceAmountList;
    for (var e in item) {
      var request = e.toJson();
      itemList.add(request);
    }

    /// init state Payment Amount set in controller
    var amount = controller.paymentAmount;
    paymentAmountController.text = "$amount";
    debitAmountController.text = "$amount";
  }
}

class DataSource extends DataGridSource {
  DataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(
            columnName: 'particulars', value: e['perticulars']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['balance']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(dataGridCell.value.toString()),
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
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
