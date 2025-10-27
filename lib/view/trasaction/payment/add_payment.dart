import 'dart:convert';

import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/PaymentModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/payment/payment_bottom_sheet.dart';
import 'package:abtxt/view/trasaction/payment/payment_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/DropModel.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({Key? key}) : super(key: key);
  static const String routeName = '/AddPayment';

  @override
  State<AddPayment> createState() => _State();
}

class _State extends State<AddPayment> {
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  Rxn<LedgerModel> ledger = Rxn<LedgerModel>();
  TextEditingController idController = TextEditingController();
  TextEditingController slipNoController = TextEditingController();
  TextEditingController dateContoller = TextEditingController();
  TextEditingController refNoController = TextEditingController();
  TextEditingController againstController =
      TextEditingController(text: "on Account");
  TextEditingController detailsController = TextEditingController();
  TextEditingController transNoController = TextEditingController();
  TextEditingController byDebitController = TextEditingController();
  TextEditingController toDebitController = TextEditingController();
  TextEditingController toCreditController = TextEditingController();
  TextEditingController byCreditController = TextEditingController();
  TextEditingController toFirmController = TextEditingController();
  TextEditingController byFirmController = TextEditingController();
  TextEditingController currBalController = TextEditingController();
  TextEditingController placeController = TextEditingController();

  TextEditingController totalDebitController = TextEditingController();
  TextEditingController totalCreditController = TextEditingController();

  var itemList = <dynamic>[];
  late ItemDataSource dataSource;

  final _formKey = GlobalKey<FormState>();
  late PaymentController controller;
  RxBool isUpdate = RxBool(false);

  @override
  void initState() {
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: itemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: Text("${idController.text == '' ? 'Add' : 'Update'} Payment"),
          actions: [
            Visibility(
                visible: false,
                child: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.print))),
            const SizedBox(width: 12),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
              _addItem(),
          const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
              submit(),
        },
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFF9F3FF),
                width: 16,
              ),
            ),
            //height: Get.height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  Visibility(
                                    visible: false,
                                    child: MyTextField(
                                      controller: idController,
                                      hintText: "ID",
                                      validate: "",
                                      enabled: false,
                                    ),
                                  ),
                                  MyAutoComplete(
                                      label: 'Firm',
                                      items: controller.firmDropdown,
                                      selectedItem: firmName.value,
                                      enabled: !isUpdate.value,
                                      onChanged: (FirmModel item) {
                                        firmName.value = item;
                                      },
                                      ),
                                  MyDateFilter(
                                    controller: dateContoller,
                                    labelText: "Date",
                                  ),
                                  Visibility(
                                    visible: slipNoController.text.isNotEmpty,
                                    child: MyTextField(
                                      controller: slipNoController,
                                      hintText: "Slip No",
                                      // readonly: true,
                                    ),
                                  ),
                                  MyTextField(
                                    controller: refNoController,
                                    hintText: "Ref.No",
                                    // validate: "string",
                                  ),
                                  MyDropdownButtonFormField(
                                      controller: againstController,
                                      hintText: "Against",
                                      items: const [
                                        "on Account",
                                        "Bill/Ref Nos"
                                      ]),
                                  MyTextField(
                                    controller: detailsController,
                                    hintText: "Details",
                                  ),
                                  MyTextField(
                                    controller: transNoController,
                                    hintText: "Transaction No",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "By:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  MyAutoComplete(
                                    label: 'Ledger',
                                    items: controller.ledgerDropdown,
                                    selectedItem: ledger.value,
                                    onChanged: (LedgerModel item)  {
                                      ledger.value = item;
                                    },
                                  ),
                                  MyTextField(
                                    controller: byDebitController,
                                    hintText: "Debit",
                                    validate: "double",
                                    onChanged: (value) {
                                      Calculation();
                                    },
                                  ),
                                ],
                              ),
                              // Obx(() => Text(ledger.value?.city ?? '')),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: AddItemsElevatedButton(
                                  width: 135,
                                  onPressed: () async {
                                    _addItem();
                                  },
                                  child: const Text('Add Item'),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ItemsTable(),
                              const SizedBox(height: 12),
                              MyTextField(
                                controller: totalDebitController,
                                hintText: "Total Debit",
                                readonly: true,
                                onChanged: (value) {
                                  Calculation();
                                },
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MySubmitButton(
                                    onPressed: () => submit(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _validationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Text('Validation!'),
          content: const Text('Given "Debit Amount" not Accepted!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Calculation() {
    double byDebit = double.tryParse(byDebitController.text) ?? 0.0;
    double toCredit = double.tryParse(toCreditController.text) ?? 0.0;

    var totalDebit = byDebit;
    totalDebitController.text = '$totalDebit';

    var totalCredit = toCredit;
    totalCreditController.text = '$totalCredit';
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "firm_id": firmName.value?.id,
        "ref_no": int.tryParse(refNoController.text) ?? 0,
        "e_date": dateContoller.text,
        "debit_amount": double.tryParse(byDebitController.text) ?? 0.0,
        "details": detailsController.text ?? '',
        "ledger_id": ledger.value?.id,
        "against": againstController.text,
        "trans_no": int.tryParse(transNoController.text) ?? 0,
      };

      var item = [];
      itemList.forEach((element) {
        item.add({
          "to_ledger_no": element['to_ledger_no'],
          "credit_amount": element['credit_amount'],
          "is_com_chq": element['is_com_chq'],
          "ch_no": element['ch_no'],
          "ch_dt": element['ch_dt'],
        });
      });
      request["customer_item"] = item;

      print(jsonEncode(request));
      var id = idController.text;
      if (id.isEmpty) {
        // controller.add(request);
      } else {
        request['id'] = id;
        request['slip_no'] = int.tryParse(slipNoController.text);
        // controller.edit(request, id);
      }
    }
  }

  void _initValue() {
    dateContoller.text = AppUtils.parseDateTime("${DateTime.now()}");
    PaymentController controller = Get.find();
    firmName.value = AppUtils.setDefaultFirmName(controller.firmDropdown);
    controller.request = <String, dynamic>{};
    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = PaymentModel.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      dateContoller.text = item.eDate ?? '';
      slipNoController.text = tryCast(item.slipNo);
      refNoController.text = tryCast(item.refNo);
      againstController.text = item.against ?? 'on Account';
      detailsController.text = item.details ?? '';
      byDebitController.text = '${item.debitAmount}';
      totalDebitController.text = '${item.debitAmount}';
      // ledger.value = DropModel(id: item.ledgerId, name: '${item.ledgerName}');
      // firmName.value = DropModel(id: item.firmId, name: '${item.firmName}');

      var firmNameList = controller.firmDropdown
          .where((element) => '${element.id}' == '${item.firmId}')
          .toList();
      if (firmNameList.isNotEmpty) {
        firmName.value = firmNameList.first;
      }

      // Ledger Name
      var LedgerName = controller.ledgerDropdown
          .where((element) => '${element.id}' == '${item.ledgerId}')
          .toList();
      if (LedgerName.isNotEmpty) {
        ledger.value = LedgerName.first;
      }
      item.itemDetails?.forEach((element) {
        var request = element.toJson();
        itemList.add(request);
      });
    }
  }

  Widget ItemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'ledger_name',
          label: const MyDataGridHeader(title: 'To Ledger'),
        ),
        GridColumn(
          columnName: 'credit_amount',
          label: const MyDataGridHeader(title: 'Credit'),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
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
      onRowSelected: (index) async {
        var item = itemList[index];
        var result =
            await Get.to(const PaymentBottomSheet(), arguments: {'item': item});
        if (result['item'] == 'delete') {
          itemList.removeAt(index);
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        } else if (result != null) {
          itemList[index] = result;
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        }
      },
    );
  }

  void _addItem() async {
    double debit = double.tryParse(byDebitController.text) ?? 0.0;

    if (debit != 0.00) {
      var result = await Get.to(const PaymentBottomSheet());
      if (result != null) {
        itemList.add(result);
        dataSource.updateDataGridRows();
        dataSource.updateDataGridSource();
      }
    } else {
      _validationDialog(context);
    }
  }
}

class ItemDataSource extends DataGridSource {
  ItemDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(
            columnName: 'ledger_name', value: e['ledger_name']),
        DataGridCell<dynamic>(
            columnName: 'credit_amount', value: e['credit_amount']),
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
        // child: Text(dataGridCell.value.toString()),
        child: Text(dataGridCell.value != null ? '${dataGridCell.value}' : ''),
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
