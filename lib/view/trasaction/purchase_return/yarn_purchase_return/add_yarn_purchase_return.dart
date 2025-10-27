import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/TaxFixingModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/purchase_return/yarn_purchase_return/yarn_purchase_return_bottom_sheet.dart';
import 'package:abtxt/view/trasaction/purchase_return/yarn_purchase_return/yarn_purchase_return_controller.dart';
import 'package:abtxt/widgets/MyAddItemsRemoveButton.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MySmallTextField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../model/debit_note/DebitNoteSlipNoDropdown.dart';
import '../../../../widgets/MyDataGridHeader.dart';
import '../../../../widgets/MyDialogList.dart';
import '../../../../widgets/MySFDataGridItemTable.dart';
import '../../../../widgets/MyTextField.dart';

class AddYarnPurchaseReturn extends StatefulWidget {
  final Map? value;

  const AddYarnPurchaseReturn({
    super.key,
    this.value,
  });

  static const String routeName = '/AddYarnPurchaseReturn';

  @override
  State<AddYarnPurchaseReturn> createState() => _State();
}

class _State extends State<AddYarnPurchaseReturn> {
  TextEditingController idController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  TextEditingController firmNameTextController = TextEditingController();
  Rxn<LedgerModel> supplier = Rxn<LedgerModel>();
  TextEditingController supplierTextController = TextEditingController();
  Rxn<DebitNoteSlipNoDropdown> slipNoValue = Rxn<DebitNoteSlipNoDropdown>();
  TextEditingController slipNoController = TextEditingController();
  TextEditingController returnDateController = TextEditingController();
  TextEditingController invoiceController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  TextEditingController al1TypController = TextEditingController(text: "None");
  TextEditingController al2TypController = TextEditingController(text: "None");
  TextEditingController al3TypController = TextEditingController(text: "None");
  TextEditingController al4TypController = TextEditingController(text: "None");
  TextEditingController al1AccountNoController = TextEditingController();
  Rxn<TaxFixingModel> al1Tax = Rxn<TaxFixingModel>();
  TextEditingController al2AccountNoController = TextEditingController();
  Rxn<TaxFixingModel> al2Tax = Rxn<TaxFixingModel>();
  TextEditingController al3AccountNoController = TextEditingController();
  Rxn<TaxFixingModel> al3Tax = Rxn<TaxFixingModel>();
  TextEditingController al4AccountNoController = TextEditingController();
  Rxn<TaxFixingModel> al4Tax = Rxn<TaxFixingModel>();
  TextEditingController al1PercController = TextEditingController(text: "0");
  TextEditingController al2PercController = TextEditingController(text: "0");
  TextEditingController al3PercController = TextEditingController(text: "0");
  TextEditingController al4PercController = TextEditingController(text: "0");
  TextEditingController al1AmountController = TextEditingController(text: "0");
  TextEditingController al2AmountController = TextEditingController(text: "0");
  TextEditingController al3AmountController = TextEditingController(text: "0");
  TextEditingController al4AmountController = TextEditingController(text: "0");
  TextEditingController roundOffController = TextEditingController(text: "0");
  TextEditingController netAmountController = TextEditingController(text: "0");

  /// this details used for update purpose only
  int? challanNo;
  int? referId;

  var itemList = <dynamic>[];
  late ItemDataSource dataSource;

  final _formKey = GlobalKey<FormState>();
  final YarnPurchaseReturnController controller =
      Get.put(YarnPurchaseReturnController());

  RxDouble amount = RxDouble(0);

  int? al1ano;
  int? al2ano;
  int? al3ano;
  int? al4ano;

  RxBool isUpdate = RxBool(false);
  final FocusNode _firmNameFocusNode = FocusNode();
  final FocusNode _supplierNameFocusNode = FocusNode();
  final FocusNode _returnDateFocusNode = FocusNode();
  final FocusNode _slipNoFocusNode = FocusNode();
  var shortCut = RxString("");

  final DataGridController _dataGridController = DataGridController();

  /// created by and updated by details controllers
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? displayName;
  String? displayDate;

  @override
  void initState() {
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: itemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnPurchaseReturnController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyR, control: true): () =>
              removeSelectedItems(),
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
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
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
                        MySearchField(
                          label: "Firm",
                          enabled: !isUpdate.value,
                          focusNode: _firmNameFocusNode,
                          items: controller.firmDropdown,
                          textController: firmNameTextController,
                          requestFocus: _supplierNameFocusNode,
                          onChanged: (FirmModel item) {
                            firmName.value = item;
                          },
                        ),
                        MySearchField(
                          label: 'Supplier',
                          enabled: !isUpdate.value,
                          items: controller.ledgerDropdown,
                          textController: supplierTextController,
                          focusNode: _supplierNameFocusNode,
                          requestFocus: _slipNoFocusNode,
                          onChanged: (LedgerModel item) async {
                            supplier.value = item;

                            _apiCalls();
                          },
                        ),
                        MySearchField(
                          label: "Slip No",
                          enabled: !isUpdate.value,
                          isValidate: !isUpdate.value,
                          items: controller.slipNoDropdown,
                          textController: slipNoController,
                          focusNode: _slipNoFocusNode,
                          requestFocus: _returnDateFocusNode,
                          onChanged: (DebitNoteSlipNoDropdown value) {
                            slipNoValue.value = value;

                            _selectedSlipNoDisplay(value);
                          },
                        ),
                        MyDateFilter(
                          focusNode: _returnDateFocusNode,
                          controller: returnDateController,
                          labelText: "Return Date",
                        ),
                        MyTextField(
                          enabled: false,
                          controller: invoiceController,
                          hintText: "DC Invoice No",
                        ),
                        MyTextField(
                          controller: detailsController,
                          hintText: "Details",
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyAddItemsRemoveButton(
                            onPressed: () => removeSelectedItems()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    itemsTable(),
                    gstWidget(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        crateAndUpdatedBy(),
                        const Spacer(),
                        Obx(
                          () => Text(shortCut.value,
                              style: AppUtils.shortCutTextStyle()),
                        ),
                        const SizedBox(width: 12),
                        MySubmitButton(
                          onPressed:
                              controller.status.isLoading ? null : submit,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      if (supplier.value == null) {
        return AppUtils.infoAlert(message: "Select the Supplier name");
      }

      Map<String, dynamic> request = {
        "debit_note_type": "Yarn purchase return",
        "firm_id": firmName.value?.id,
        "supplier_id": supplier.value?.id,
        "e_date": returnDateController.text,
        "invoice_no": invoiceController.text,
        "details": detailsController.text,
        "slip_no": "${slipNoValue.value?.id}",
      };

      double totalNetQty = 0;
      for (var e in itemList) {
        totalNetQty += double.tryParse("${e['net_quantity']}") ?? 0.0;
      }

      request["total_net_qty"] = totalNetQty;
      request['item_details'] = itemList;

      // al1
      request["al1_typ"] = al1TypController.text;
      request["al1_perc"] = double.tryParse(al1PercController.text) ?? 0.00;
      request["al1_amount"] = double.tryParse(al1AmountController.text) ?? 0.00;
      if (al1TypController.text != "None") {
        request["al1_ano"] = al1ano;
      }

      // al2
      request["al2_typ"] = al2TypController.text;
      request["al2_perc"] = double.tryParse(al2PercController.text) ?? 0.00;
      request["al2_amount"] = double.tryParse(al2AmountController.text) ?? 0.00;
      if (al2TypController.text != "None") {
        request["al2_ano"] = al2ano;
      }

      //al3
      request["al3_typ"] = al3TypController.text;
      request["al3_perc"] = double.tryParse(al3PercController.text) ?? 0.00;
      request["al3_amount"] = double.tryParse(al3AmountController.text) ?? 0.00;
      if (al3TypController.text != "None") {
        request["al3_ano"] = al3ano;
      }

      //al4
      request["al4_typ"] = al4TypController.text;
      request["al4_perc"] = double.tryParse(al4PercController.text) ?? 0.00;
      request["al4_amount"] = double.tryParse(al4AmountController.text) ?? 0.00;
      if (al4TypController.text != "None") {
        request["al4_ano"] = al4ano;
      }

      request["net_total"] = double.tryParse(netAmountController.text) ?? 0.00;
      request["round_off"] = double.tryParse(roundOffController.text) ?? 0.00;

      var id = idController.text;
      if (id.isEmpty) {
        controller.add(request);
      } else {
        request["refer_id"] = referId;
        request["challan_no"] = challanNo;
        controller.edit(request, int.tryParse(id));
      }
    }
  }

  void _initValue() async {
    returnDateController.text = AppUtils.parseDateTime("${DateTime.now()}");

    if (widget.value != null && widget.value!.isNotEmpty) {
      isUpdate.value = true;

      var id = widget.value!['id'];
      referId = widget.value!['refer_id'];
      challanNo = widget.value!['challan_no'];
      var item = await controller.selectedDebitNoteDetails(id);

      if (item != null) {
        idController.text = '${item["id"]}';
        firmName.value =
            FirmModel(id: item['firm_id'], firmName: item['firm_name']);
        firmNameTextController.text = item['firm_name'];

        supplier.value = LedgerModel(
            id: item["supplier_id"], ledgerName: item['supplier_name']);
        supplierTextController.text = item['supplier_name'];

        slipNoValue.value = DebitNoteSlipNoDropdown(
            id: int.tryParse(item['slip_no']),
            slipNo: int.tryParse(item['slip_no']));
        slipNoController.text = "${item['slip_no']}";
        returnDateController.text = item['e_date'];
        invoiceController.text = item['invoice_no'] ?? "";
        detailsController.text = item['details'] ?? "";

        /// get created by and updated by details
        DateTime createDate =
            DateTime.parse(item["created_at"] ?? "0000-00-00");
        DateTime updateDate =
            DateTime.parse(item["updated_at"] ?? "0000-00-00");
        createdAt = AppUtils.dateFormatter.format(createDate);
        updatedAt = AppUtils.dateFormatter.format(updateDate);
        createdBy = item["created_name"];
        updatedBy = item["updated_name"];
        if (updatedBy != null) {
          displayName = "Edit : $updatedBy";
          displayDate = updatedAt;
        } else {
          displayName = "New : $createdBy";
          displayDate = createdAt;
        }

        item['item_details'].forEach((element) {
          amount.value += element['amount'];
          var request = element;
          itemList.add(request);

          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        });

        al1ano = item['al1_ano'];
        al2ano = item['al2_ano'];
        al3ano = item['al3_ano'];
        al4ano = item['al4_ano'];

        //al1
        al1TypController.text = item['al1_typ'] ?? "None";
        al1PercController.text = tryCast(item['al1_perc']);
        al1AccountNoController.text = tryCast(item['al1_ano_name']);
        al1AmountController.text = '${item['al1_amount']}';

        //al2
        al2TypController.text = item['al2_typ'] ?? "None";
        al2PercController.text = tryCast(item['al2_perc']);
        al2AccountNoController.text = tryCast(item['al2_ano_name']);
        al2AmountController.text = '${item['al2_amount']}';

        //al3
        al3TypController.text = item['al3_typ'] ?? "None";
        al3PercController.text = tryCast(item['al3_perc']);
        al3AccountNoController.text = tryCast(item['al3_ano_name']);
        al3AmountController.text = '${item['al3_amount']}';

        //al4
        al4TypController.text = item['al4_typ'] ?? "None";
        al4PercController.text = tryCast(item['al4_perc']);
        al4AccountNoController.text = tryCast(item['al4_ano_name']);
        al4AmountController.text = '${item['al4_amount']}';

        netAmountController.text = "${item['net_total']}";
        roundOffController.text = "${item['round_off']}";
      }

      // selectedDebitNoteDetails
    }
  }

  Widget gstWidget() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: 400,
        color: Colors.white,
        padding: const EdgeInsets.all(12.0),
        child: Table(
          children: [
            /// Al1
            TableRow(children: [
              SizedBox(
                height: 50,
                child: MyDialogList(
                  labelText: '',
                  isValidate: false,
                  controller: al1TypController,
                  list: const ["None", "Add", "Less"],
                  onItemSelected: (String item) {
                    al1TypController.text = item;
                    al1PercController.text = '0';
                    al1AmountController.text = '0';
                    _calculateAmount();
                  },
                  onCreateNew: (value) async {},
                ),
              ),
              SizedBox(
                height: 50,
                child: MyDialogList(
                  labelText: '',
                  controller: al1AccountNoController,
                  list: controller.ledgerByTax,
                  isValidate: false,
                  onItemSelected: (LedgerModel item) {
                    al1AccountNoController.text = "${item.ledgerName}";
                    al1ano = int.tryParse("${item.id}");
                  },
                  onCreateNew: (value) async {},
                ),
              ),
              MySmallTextField(
                controller: al1PercController,
                validate: "double",
                onChanged: (value) {
                  al1AmountController.text = '0';
                  _calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al1AmountController,
                validate: "double",
                onChanged: (value) {
                  al1PercController.text = '0';
                  _calculateAmount();
                },
              ),
            ]),

            /// Al2
            TableRow(children: [
              SizedBox(
                height: 50,
                child: MyDialogList(
                  labelText: '',
                  controller: al2TypController,
                  isValidate: false,
                  list: const ["None", "Add", "Less"],
                  onItemSelected: (String item) {
                    al2TypController.text = item;
                    al2PercController.text = '0';
                    al2AmountController.text = '0';
                    _calculateAmount();
                  },
                  onCreateNew: (value) async {},
                ),
              ),
              SizedBox(
                height: 50,
                child: MyDialogList(
                  labelText: '',
                  controller: al2AccountNoController,
                  isValidate: false,
                  list: controller.ledgerByTax,
                  onItemSelected: (LedgerModel item) {
                    al2AccountNoController.text = "${item.ledgerName}";
                    al2ano = int.tryParse("${item.id}");
                  },
                  onCreateNew: (value) async {},
                ),
              ),
              MySmallTextField(
                controller: al2PercController,
                validate: "double",
                onChanged: (value) {
                  al2AmountController.text = '0';
                  _calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al2AmountController,
                validate: "double",
                onChanged: (value) {
                  al2PercController.text = '0';
                  _calculateAmount();
                },
              ),
            ]),

            /// Al3
            TableRow(children: [
              SizedBox(
                height: 50,
                child: MyDialogList(
                  labelText: '',
                  controller: al3TypController,
                  isValidate: false,
                  list: const ["None", "Add", "Less"],
                  onItemSelected: (String item) {
                    al3TypController.text = item;
                    al3PercController.text = '0';
                    al3AmountController.text = '0';
                    _calculateAmount();
                  },
                  onCreateNew: (value) async {},
                ),
              ),
              SizedBox(
                height: 50,
                child: MyDialogList(
                  labelText: '',
                  controller: al3AccountNoController,
                  isValidate: false,
                  list: controller.ledgerByTax,
                  onItemSelected: (LedgerModel item) {
                    al3AccountNoController.text = "${item.ledgerName}";
                    al3ano = int.tryParse("${item.id}");
                  },
                  onCreateNew: (value) async {},
                ),
              ),
              MySmallTextField(
                controller: al3PercController,
                validate: "double",
                onChanged: (value) {
                  al3AmountController.text = '0';
                  _calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al3AmountController,
                validate: "double",
                onChanged: (value) {
                  al3PercController.text = '0';
                  _calculateAmount();
                },
              ),
            ]),

            /// Al4
            TableRow(children: [
              SizedBox(
                height: 50,
                child: MyDialogList(
                  labelText: '',
                  controller: al4TypController,
                  isValidate: false,
                  list: const ["None", "Add", "Less"],
                  onItemSelected: (String item) {
                    al4TypController.text = item;
                    al4PercController.text = '0';
                    al4AmountController.text = '0';
                    _calculateAmount();
                  },
                  onCreateNew: (value) async {},
                ),
              ),
              SizedBox(
                height: 50,
                child: MyDialogList(
                  labelText: '',
                  controller: al4AccountNoController,
                  list: controller.ledgerByTax,
                  isValidate: false,
                  onItemSelected: (LedgerModel item) {
                    al4AccountNoController.text = "${item.ledgerName}";
                    al4ano = int.tryParse("${item.id}");
                  },
                  onCreateNew: (value) async {},
                ),
              ),
              MySmallTextField(
                controller: al4PercController,
                // validate:"double",
                onChanged: (value) {
                  al4AmountController.text = '0';
                  _calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al4AmountController,
                validate: "double",
                onChanged: (value) {
                  al4PercController.text = '0';
                  _calculateAmount();
                },
              ),
            ]),

            /// Round Of
            TableRow(children: [
              const Text(''),
              const Text(''),
              const SizedBox(
                  width: 50,
                  height: 35,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text('Round Off'))),
              MySmallTextField(
                controller: roundOffController,
                readonly: true,
              ),
            ]),

            /// Net Total
            TableRow(children: [
              const Text(''),
              const Text(''),
              const SizedBox(
                  width: 50,
                  height: 35,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text('Net Total'))),
              MySmallTextField(
                controller: netAmountController,
                readonly: true,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  void _calculateAmount() {
    /// Al Percentage Field Controllers Data Type Change
    double al1Percent = double.tryParse(al1PercController.text) ?? 0;
    double al2Percent = double.tryParse(al2PercController.text) ?? 0;
    double al3Percent = double.tryParse(al3PercController.text) ?? 0;
    double al4Percent = double.tryParse(al4PercController.text) ?? 0;

    double total = amount.value;
    double netAmount = total;

    /// Al1 Percentage And Amount Calculation

    if (al1TypController.text == 'None') {
      al1AmountController.text = "0";
      al1PercController.text = "0";
    } else {
      if (al1Percent != 0) {
        al1AmountController.text =
            ((total * al1Percent) / 100).toStringAsFixed(3);
        // al1AmountController.text = "${(total * al1Percent) / 100}";
      }
      if (al1TypController.text == 'Add') {
        netAmount += double.tryParse(al1AmountController.text) ?? 0.0;
      } else {
        netAmount -= double.tryParse(al1AmountController.text) ?? 0.0;
      }
    }

    /// Al2 Percentage And Amount Calculation

    if (al2TypController.text == 'None') {
      al2AmountController.text = "0";
      al2PercController.text = "0";
    } else {
      if (al2Percent != 0) {
        al2AmountController.text =
            ((total * al2Percent) / 100).toStringAsFixed(3);
        // al2AmountController.text = "${(total * al2Percent) / 100}";
      }
      if (al2TypController.text == 'Add') {
        netAmount += double.tryParse(al2AmountController.text) ?? 0.0;
      } else {
        netAmount -= double.tryParse(al2AmountController.text) ?? 0.0;
      }
    }

    /// Al3 Percentage And Amount Calculation

    if (al3TypController.text == 'None') {
      al3AmountController.text = "0";
      al3PercController.text = "0";
    } else {
      if (al3Percent != 0) {
        al3AmountController.text =
            ((total * al3Percent) / 100).toStringAsFixed(3);
        // al3AmountController.text = "${(total * al3Percent) / 100}";
      }
      if (al3TypController.text == 'Add') {
        netAmount += double.tryParse(al3AmountController.text) ?? 0.0;
      } else {
        netAmount -= double.tryParse(al3AmountController.text) ?? 0.0;
      }
    }

    /// Al4 Percentage And Amount Calculation

    if (al4TypController.text == 'None') {
      al4AmountController.text = "0";
      al4PercController.text = "0";
    } else {
      if (al4Percent != 0) {
        al4AmountController.text =
            ((total * al4Percent) / 100).toStringAsFixed(3);
      }
      if (al4TypController.text == 'Add') {
        netAmount += double.tryParse(al4AmountController.text) ?? 0.0;
      } else {
        netAmount -= double.tryParse(al4AmountController.text) ?? 0.0;
      }
    }

    double roundOfRemainder = netAmount.roundToDouble() - netAmount;
    roundOffController.text = roundOfRemainder.toStringAsFixed(2);
    netAmountController.text = netAmount.roundToDouble().toStringAsFixed(2);
  }

  Widget itemsTable() {
    return MySFDataGridItemTable(
      controller: _dataGridController,
      selectionMode: SelectionMode.single,
      columns: [
        GridColumn(
          columnName: 'yarn_name',
          label: const MyDataGridHeader(title: 'Yarn Name'),
        ),
        GridColumn(
          columnName: 'color_name',
          label: const MyDataGridHeader(title: 'Color Name'),
        ),
        GridColumn(
          columnName: 'stock_to',
          label: const MyDataGridHeader(title: 'Stock Place'),
        ),
        GridColumn(
          columnName: 'box_no',
          label: const MyDataGridHeader(title: 'Bag/Box No.'),
        ),
        GridColumn(
          columnName: 'pack',
          label: const MyDataGridHeader(title: 'Pack'),
        ),
        GridColumn(
          width: 120,
          columnName: 'net_quantity',
          label: const MyDataGridHeader(title: 'Net Qty'),
        ),
        GridColumn(
          columnName: 'calculate_type',
          label: const MyDataGridHeader(title: 'Cal Type'),
        ),
        GridColumn(
          width: 120,
          columnName: 'rate',
          label: const MyDataGridHeader(title: 'Rate (Rs)'),
        ),
        GridColumn(
          width: 120,
          columnName: 'amount',
          label: const MyDataGridHeader(title: 'Amount(Rs)'),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'pack',
              columnName: 'pack',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'net_quantity',
              columnName: 'net_quantity',
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
      onRowSelected: (index) async {
        var item = itemList[index];
        var result = await Get.to(() => const YarnPurchaseReturnBottomSheet(),
            arguments: {'item': item});
        if (result != null) {
          itemList[index] = result;
          amountCalculation();
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        }
      },
    );
  }

  amountCalculation() {
    double total = 0;
    for (var element in itemList) {
      total += element['amount'];
    }
    amount.value = total;
    _calculateAmount();
  }

  void removeSelectedItems() {
    int? index = _dataGridController.selectedIndex;
    if (index >= 0) {
      itemList.removeAt(index);
      amountCalculation();
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
      _dataGridController.selectedIndex = -1;
    } else {
      AppUtils.infoAlert(message: "Select The Value");
    }
  }

  void removeItem(index) {
    Get.defaultDialog(
      barrierDismissible: false,
      title: 'ALERT!',
      titleStyle: const TextStyle(color: Colors.red, fontSize: 18),
      radius: 10,
      content: const Text("Are you sure you want to remove?"),
      actions: <Widget>[
        TextButton(
          child: const Text("CLOSE"),
          onPressed: () => Get.back(),
        ),
        TextButton(
          autofocus: true,
          onPressed: () {
            Get.back();
            itemList.removeAt(index);
            amountCalculation();
            dataSource.updateDataGridRows();
            dataSource.updateDataGridSource();
          },
          child: const Text("REMOVE"),
        ),
      ],
    );
  }

  void _taxDialog(List<TaxFixingModel> list) {
    if (list.isEmpty) {
      return;
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: SizedBox(
              width: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = list[index];
                  return ListTile(
                    autofocus: true,
                    title: Text('$item'),
                    onTap: () {
                      _initTaxWidget(item);
                      Get.back();
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  void _initTaxWidget(TaxFixingModel item) {
    al1ano = item.al1Ano;
    al2ano = item.al2Ano;
    al3ano = item.al3Ano;
    al4ano = item.al4Ano;

    //al1
    al1TypController.text = item.al1Typ ?? "None";
    al1PercController.text = '${item.al1Perc}';
    al1AccountNoController.text = item.al1AnoName ?? "";
    //al2
    al2TypController.text = item.al2Typ ?? "None";
    al2PercController.text = '${item.al2Perc}';
    al2AccountNoController.text = item.al2AnoName ?? "";
    //al3
    al3TypController.text = item.al3Typ ?? "None";
    al3PercController.text = '${item.al3Perc}';
    al3AccountNoController.text = item.al3AnoName ?? "";
    //al4
    al4TypController.text = item.al4Typ ?? "None";
    al4PercController.text = '${item.al4Perc}';
    al4AccountNoController.text = item.al4AnoName ?? '';

    _calculateAmount();
  }

  Widget crateAndUpdatedBy() {
    String id = idController.text;
    String formattedDate = AppUtils.dateFormatter.format(DateTime.now());

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${id.isEmpty ? "New : ${AppUtils().loginName}" : displayName}",
          style: AppUtils.updateAndCreateTextStyle(),
        ),
        const SizedBox(width: 12),
        Text(
          "${id.isEmpty ? formattedDate : displayDate}",
          style: AppUtils.updateAndCreateTextStyle(),
        )
      ],
    );
  }

  void _apiCalls() async {
    itemList.clear();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
    slipNoValue.value = null;
    slipNoController.text = "";

    var list = await controller.taxFixing('Yarn Purchase');
    _taxDialog(list);

    controller.slipNoDetails(
        "Yarn purchase return", firmName.value?.id, supplier.value?.id);
  }

  void _selectedSlipNoDisplay(DebitNoteSlipNoDropdown item) {
    invoiceController.text = tryCast(item.invoiceNo);

    itemList.clear();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
    item.itemDetails?.forEach((element) {
      amount.value += element.amount ?? 0;
      var request = element.toJson();

      itemList.add(request);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    });

    al1ano = item.al1Ano;
    al2ano = item.al2Ano;
    al3ano = item.al3Ano;
    al4ano = item.al4Ano;

    //al1
    al1TypController.text = item.al1Typ ?? "None";
    al1PercController.text = tryCast(item.al1Perc);
    al1AccountNoController.text = tryCast(item.al1AnoName);
    al1AmountController.text = '${item.al1Amount}';

    //al2
    al2TypController.text = item.al2Typ ?? "None";
    al2PercController.text = tryCast(item.al2Perc);
    al2AccountNoController.text = tryCast(item.al1AnoName);
    al2AmountController.text = '${item.al2Amount}';

    //al3
    al3TypController.text = item.al3Typ ?? "None";
    al3PercController.text = tryCast(item.al3Perc);
    al3AccountNoController.text = tryCast(item.al3AnoName);
    al3AmountController.text = '${item.al3Amount}';

    //al4
    al4TypController.text = item.al4Typ ?? "None";
    al4PercController.text = tryCast(item.al4Perc);
    al4AccountNoController.text = tryCast(item.al4AnoName);
    al4AmountController.text = '${item.al4Amount}';

    netAmountController.text = "${item.netTotal}";
    roundOffController.text = "${item.roundOff}";
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
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e['yarn_name']),
        DataGridCell<dynamic>(columnName: 'color_name', value: e['color_name']),
        DataGridCell<dynamic>(columnName: 'stock_to', value: e['stock_to']),
        DataGridCell<dynamic>(columnName: 'box_no', value: e['box_no']),
        DataGridCell<dynamic>(columnName: 'pack', value: e['pack']),
        DataGridCell<dynamic>(
            columnName: 'net_quantity', value: e['net_quantity']),
        DataGridCell<dynamic>(
            columnName: 'calculate_type', value: e['calculate_type']),
        DataGridCell<dynamic>(columnName: 'rate', value: e['rate']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['amount']),
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
        case 'amount':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'rate':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'net_quantity':
          return buildFormattedCell(value, decimalPlaces: 3);
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
      case 'amount':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      case 'net_quantity':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 3, alignment: alignment);
      case 'pack':
        alignment = TextAlign.left;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      default:
        /*alignment = TextAlign.left;
        return const Text('Total: ',  style: TextStyle(fontWeight: FontWeight.w700),);*/
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

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
