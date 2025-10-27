import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/sale_return/yarn_sales_return/yarn_sale_return_bottom_sheet.dart';
import 'package:abtxt/view/trasaction/sale_return/yarn_sales_return/yarn_sale_return_controller.dart';
import 'package:abtxt/widgets/MyDialogList.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../model/FirmModel.dart';
import '../../../../model/LedgerModel.dart';
import '../../../../model/TaxFixingModel.dart';
import '../../../../model/credit_note/YarnSaleReturnSlipNoModel.dart';
import '../../../../utils/constant.dart';
import '../../../../widgets/AddItemsElevatedButton.dart';
import '../../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../../widgets/MyDataGridHeader.dart';
import '../../../../widgets/MyDateFilter.dart';
import '../../../../widgets/MyDropdownButtonFormField.dart';
import '../../../../widgets/MySFDataGridItemTable.dart';
import '../../../../widgets/MySmallTextField.dart';
import '../../../../widgets/MySubmitButton.dart';
import '../../../../widgets/MyTextField.dart';
import '../../../../widgets/flutter_shortcut_widget.dart';

class AddYarnSalesReturn extends StatefulWidget {
  final Map? value;

  const AddYarnSalesReturn({
    super.key,
    this.value,
  });

  static const String routeName = '/add_yarn_sales_return';

  @override
  State<AddYarnSalesReturn> createState() => _State();
}

class _State extends State<AddYarnSalesReturn> {
  TextEditingController idController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  TextEditingController firmNameController = TextEditingController();
  Rxn<LedgerModel> customerName = Rxn<LedgerModel>();
  TextEditingController customerNameController = TextEditingController();
  Rxn<YarnSaleReturnSlipNoModel> slipNoValue = Rxn<YarnSaleReturnSlipNoModel>();
  TextEditingController slipNoController = TextEditingController();
  TextEditingController returnDateController = TextEditingController();
  TextEditingController destinationNameController = TextEditingController();
  TextEditingController freightController = TextEditingController();
  TextEditingController transportNameController = TextEditingController();
  TextEditingController lrNoController = TextEditingController();
  TextEditingController lrController = TextEditingController();
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
  TextEditingController netAmountController = TextEditingController(text: "0");
  TextEditingController roundOffController = TextEditingController(text: "0");
  RxDouble amount = RxDouble(0);

  int? al1ano;
  int? al2ano;
  int? al3ano;
  int? al4ano;

  late ItemDataSource dataSource;
  RxBool isUpdate = RxBool(false);

  /// this details used for update purpose only
  int? challanNo;
  int? referId;

  final DataGridController _dataGridController = DataGridController();

  final _formKey = GlobalKey<FormState>();
  YarnSaleReturnController controller = Get.put(YarnSaleReturnController());

  final FocusNode _firmNameFocusNode = FocusNode();
  final FocusNode _customerNameFocusNode = FocusNode();
  final FocusNode _slipNoFocusNode = FocusNode();
  final FocusNode _returnDateFocusNode = FocusNode();

  var itemList = <dynamic>[];

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
    return GetBuilder<YarnSaleReturnController>(builder: (controller) {
      return ShortCutWidget(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyN, control: true):
              AddNewIntent(),
          SingleActivator(LogicalKeyboardKey.keyR, control: true):
              RemoveIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            AddNewIntent: SetCounterAction(perform: () {
              _addItem();
            }),
            RemoveIntent: SetCounterAction(perform: () {
              removeSelectedItems();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Form(
                  key: _formKey,
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
                            label: 'Firm',
                            items: controller.firmNameDropdown,
                            textController: firmNameController,
                            focusNode: _firmNameFocusNode,
                            requestFocus: _customerNameFocusNode,
                            enabled: !isUpdate.value,
                            onChanged: (FirmModel item) {
                              firmName.value = item;
                            },
                          ),
                          MySearchField(
                            label: 'Customer Name',
                            items: controller.customerNameDropdown,
                            textController: customerNameController,
                            focusNode: _customerNameFocusNode,
                            requestFocus: _slipNoFocusNode,
                            enabled: !isUpdate.value,
                            onChanged: (LedgerModel item) async {
                              customerName.value = item;
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
                            onChanged: (YarnSaleReturnSlipNoModel value) {
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
                            controller: destinationNameController,
                            hintText: "Destination To",
                          ),
                          MyDropdownButtonFormField(
                            controller: freightController,
                            hintText: "Freight",
                            items: Constants.freight,
                          ),
                          MyTextField(
                            controller: transportNameController,
                            hintText: "Transport",
                          ),
                          MyTextField(
                            controller: lrNoController,
                            hintText: "L.R.No",
                          ),
                          MyDateFilter(
                            controller: lrController,
                            labelText: "L.R.Date",
                            required: false,
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
                          const SizedBox(width: 12),
                          AddItemsElevatedButton(
                            width: 135,
                            onPressed: () => _addItem(),
                            child: const Text('Add Item'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      yarnSaleTable(),
                      gstCalculation(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          crateAndUpdatedBy(),
                          const Spacer(),
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
        ),
      );
    });
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "credit_note_type": "Yarn sale return",
        "firm_id": firmName.value?.id,
        "customer_id": customerName.value?.id,
        "e_date": returnDateController.text,
        "slip_no": slipNoValue.value?.id,
        "destination_to": destinationNameController.text,
        "freight": freightController.text,
        "lr_no": lrNoController.text,
        "lr_date": lrController.text,
        "details": detailsController.text,
        "transport_type": transportNameController.text,
      };

      var yarnSaleList = [];
      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "yarn_id": itemList[i]['yarn_id'],
          "yarn_name": itemList[i]['yarn_name'],
          "color_id": itemList[i]['color_id'],
          "color_name": itemList[i]['color_name'],
          "stock_to": itemList[i]['stock_to'],
          "box_no": itemList[i]['box_no'],
          "stock": itemList[i]['stock'],
          "pack": itemList[i]['pack'],
          "quantity": itemList[i]['quantity'],
          "less_quantity": itemList[i]['less_quantity'],
          "net_quantity": itemList[i]['net_quantity'],
          "calculate_type": itemList[i]['calculate_type'],
          "rate": itemList[i]['rate'],
          "amount": itemList[i]['amount'],
        };

        yarnSaleList.add(item);
      }

      request["item_details"] = yarnSaleList;
      double totalNetQty = 0;

      for (var e in itemList) {
        totalNetQty = double.tryParse('${e['amount']}') ?? 0.00;
      }

      request["total_net_qty"] = totalNetQty;

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
      request["al4_amount"] = double.tryParse(al4AmountController.text) ?? 0.00;
      request["al4_perc"] = double.tryParse(al4PercController.text) ?? 0.00;
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
        controller.edit(request,id);
      }
    }
  }

  void _initValue() async {
    returnDateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    freightController.text = Constants.freight[0];

    if (widget.value != null && widget.value!.isNotEmpty) {
      isUpdate.value = true;

      var id = widget.value!["id"];
      referId = widget.value!['refer_id'];
      challanNo = widget.value!['challan_no'];
      var item = await controller.selectedDebitNoteDetails(id);
      if (item != null) {
        idController.text = "${item["id"]}";
        firmNameController.text = "${item["firm_name"]}";
        firmName.value =
            FirmModel(id: item["firm_id"], firmName: item["firm_name"]);

        customerNameController.text = item["customer_name"];
        customerName.value = LedgerModel(
            id: item["customer_id"], ledgerName: item["customer_name"]);

        slipNoController.text = "${item["slip_no"]}";
        slipNoValue.value = YarnSaleReturnSlipNoModel(
            id: int.tryParse(item["slip_no"]),
            billNo: int.tryParse(item["slip_no"]));

        returnDateController.text = "${item["e_date"]}";
        destinationNameController.text = "${item["destination_to"] ?? ""}";
        freightController.text = "${item["freight"] ?? "ToPay"}";
        transportNameController.text = "${item["transport_type"] ?? ""}";
        lrNoController.text = "${item["lr_no"] ?? ""}";
        lrController.text = "${item["lr_date"] ?? ""}";
        detailsController.text = "${item["details"] ?? ""}";

        /// get created by and updated by details
        DateTime createDate =
            DateTime.parse(item["created_at"] ?? "0000-00-00");
        DateTime updateDate =
            DateTime.parse(item["updated_at"] ?? "0000-00-00");
        createdAt = AppUtils.dateFormatter.format(createDate);
        updatedAt = AppUtils.dateFormatter.format(updateDate);
        createdBy = item["creator_name"];
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
    }
  }

  Widget gstCalculation() {
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
                onChanged: (value) {
                  al1AmountController.text = '0';
                  _calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al1AmountController,
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
                onChanged: (value) {
                  al2AmountController.text = '0';
                  _calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al2AmountController,
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
                onChanged: (value) {
                  al3AmountController.text = '0';
                  _calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al3AmountController,
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
                onChanged: (value) {
                  al4AmountController.text = '0';
                  _calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al4AmountController,
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
    netAmountController.text = netAmount.toStringAsFixed(2);
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
            content: SizedBox(
              height: 300,
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

  Widget yarnSaleTable() {
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
          label: const MyDataGridHeader(title: 'Delivered From'),
        ),
        GridColumn(
          columnName: 'box_no',
          label: const MyDataGridHeader(title: 'Bag/Box No.'),
        ),
        GridColumn(
          width: 120,
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
        var result = await Get.to(() => const YarnSaleReturnBottomSheet(),
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

  void _addItem() async {
    var result = await Get.to(const YarnSaleReturnBottomSheet());
    if (result != null) {
      itemList.add(result);
      amountCalculation();
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    }
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

  void _selectedSlipNoDisplay(YarnSaleReturnSlipNoModel item) {
    itemList.clear();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();

    var slipList = item.itemDetails ?? [];

    var yarnSaleList = [];
    for (var i = 0; i < slipList.length; i++) {
      amount.value += slipList[i].amount ?? 0;

      var item = {
        "yarn_id": slipList[i].yarnId,
        "yarn_name": slipList[i].yarnName,
        "color_id": slipList[i].colorId,
        "color_name": slipList[i].colorName,
        "stock_to": slipList[i].stockIn,
        "box_no": slipList[i].boxNo,
        "pack": slipList[i].pack,
        "quantity": slipList[i].quantity,
        "less_quantity": slipList[i].lessQuantity,
        "net_quantity": slipList[i].grossQuantity,
        "calculate_type": slipList[i].calculateType,
        "rate": slipList[i].rate,
        "amount": slipList[i].amount,
      };

      yarnSaleList.add(item);
    }

    itemList.addAll(yarnSaleList);
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();

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

  void _apiCalls() async {
    itemList.clear();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
    slipNoValue.value = null;
    slipNoController.text = "";

    var list = await controller.taxFixing('Yarn Purchase');
    _taxDialog(list);

    controller.slipNoDetails(
        "Yarn sale return", firmName.value?.id, customerName.value?.id);
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
        /* alignment = TextAlign.left;
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
