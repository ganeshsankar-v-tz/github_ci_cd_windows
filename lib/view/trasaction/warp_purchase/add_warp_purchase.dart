import 'package:abtxt/model/warp_purchase_model.dart';
import 'package:abtxt/view/trasaction/warp_purchase/warp_purchase_bottom_sheet.dart';
import 'package:abtxt/view/trasaction/warp_purchase/warp_purchase_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/TaxFixingModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MySmallTextField.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../basics/ledger/addledger.dart';

class AddWarpPurhase extends StatefulWidget {
  const AddWarpPurhase({super.key});

  static const String routeName = '/add_warp_purchase';

  @override
  State<AddWarpPurhase> createState() => _State();
}

class _State extends State<AddWarpPurhase> {
  TextEditingController idController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  TextEditingController firmController = TextEditingController();
  Rxn<LedgerModel> supplier = Rxn<LedgerModel>();
  TextEditingController supplierController = TextEditingController();
  Rxn<LedgerModel> accountType = Rxn<LedgerModel>();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController actualBillDateController = TextEditingController();
  TextEditingController slipNoController = TextEditingController();
  TextEditingController dueDaysController = TextEditingController(text: "0");
  TextEditingController detailsController = TextEditingController();
  TextEditingController al1TypController = TextEditingController(text: "None");
  TextEditingController al2TypController = TextEditingController(text: "None");
  TextEditingController al3TypController = TextEditingController(text: "None");
  TextEditingController al4TypController = TextEditingController(text: "None");
  TextEditingController al1AccountNoController = TextEditingController();
  TextEditingController al2AccountNoController = TextEditingController();
  TextEditingController al3AccountNoController = TextEditingController();
  TextEditingController al4AccountNoController = TextEditingController();
  TextEditingController al1PercController = TextEditingController(text: "0");
  TextEditingController al2PercController = TextEditingController(text: "0");
  TextEditingController al3PercController = TextEditingController(text: "0");
  TextEditingController al4PercController = TextEditingController(text: "0");
  TextEditingController beamController = TextEditingController();
  TextEditingController bobbinController = TextEditingController();
  TextEditingController sheetController = TextEditingController();
  TextEditingController emptyPurchaseController =
      TextEditingController(text: "No");
  TextEditingController al1AmountController = TextEditingController(text: "0");
  TextEditingController al2AmountController = TextEditingController(text: "0");
  TextEditingController al3AmountController = TextEditingController(text: "0");
  TextEditingController al4AmountController = TextEditingController(text: "0");
  TextEditingController roundOffController = TextEditingController(text: "0");
  TextEditingController netAmountController = TextEditingController(text: "0");
  RxDouble amount = RxDouble(0);
  final FocusNode _accountTypeFocusNode = FocusNode();
  final FocusNode _supplierNameFocusNode = FocusNode();
  var shortCut = RxString("");

  int? al1ano;
  int? al2ano;
  int? al3ano;
  int? al4ano;

  final _formKey = GlobalKey<FormState>();
  WarpPurchaseController controller = Get.find();

  late ItemDataSource dataSource;
  RxBool isUpdate = RxBool(false);
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
    _accountTypeFocusNode.addListener(() => shortCutKeys());
    _supplierNameFocusNode.addListener(() => shortCutKeys());
    controller.itemList.clear();
    controller.lastWarp = null;
    controller.isChanged = false;
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: controller.itemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpPurchaseController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Warp Purchase"),
          actions: [
            Visibility(
              visible: idController.text.isNotEmpty,
              child: MyDeleteIconButton(
                onPressed: (password) {
                  controller.delete(idController.text, password);
                },
              ),
            ),
            const SizedBox(width: 8),
            Visibility(
              visible: slipNoController.text.isNotEmpty,
              child: MyPrintButton(
                onPressed: () => _print(),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyP, control: true):
              PrintIntent(),
          SingleActivator(LogicalKeyboardKey.keyN, control: true):
              AddNewIntent(),
          SingleActivator(LogicalKeyboardKey.keyR, control: true):
              RemoveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            PrintIntent: SetCounterAction(perform: () {
              _print();
            }),
            AddNewIntent: SetCounterAction(perform: () {
              additem();
            }),
            RemoveIntent: SetCounterAction(perform: () {
              removeSelectedItems();
            }),
            NavigateIntent: SetCounterAction(perform: () {
              navigateAnotherPage();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                //height: Get.height,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Form(
                        key: _formKey,
                        child: Container(
                          //color: Colors.green,
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
                                  MyAutoComplete(
                                    label: 'Firm',
                                    items: controller.Firm,
                                    selectedItem: firmName.value,
                                    enabled: !isUpdate.value,
                                    onChanged: (FirmModel item) {
                                      firmName.value = item;
                                    },
                                    autofocus: false,
                                  ),
                                  Focus(
                                    focusNode: _accountTypeFocusNode,
                                    skipTraversal: true,
                                    child: MyAutoComplete(
                                      label: 'Account Type',
                                      items: controller.accountDropDown,
                                      selectedItem: accountType.value,
                                      onChanged: (LedgerModel item) {
                                        accountType.value = item;
                                        //  _firmNameFocusNode.requestFocus();
                                      },
                                      autofocus: false,
                                    ),
                                  ),
                                  MyTextField(
                                    controller: slipNoController,
                                    hintText: "Slip No",
                                    readonly: true,
                                    enabled: false,
                                  ),
                                  Focus(
                                    focusNode: _supplierNameFocusNode,
                                    skipTraversal: true,
                                    child: MyAutoComplete(
                                      label: 'Supplier',
                                      items: controller.supplierName,
                                      selectedItem: supplier.value,
                                      onChanged: (LedgerModel item) async {
                                        supplier.value = item;
                                        var list = await controller
                                            .taxFixing('Yarn Purchase');
                                        _taxDialog(list);
                                        //  _firmNameFocusNode.requestFocus();
                                      },
                                    ),
                                  ),
                                  MyDateFilter(
                                    controller: dateController,
                                    labelText: 'Date',
                                  ),
                                  MyDateFilter(
                                    controller: actualBillDateController,
                                    labelText: 'Actual Bill Date',
                                  ),
                                  MyTextField(
                                    controller: detailsController,
                                    hintText: "Details",
                                  ),
                                  MyTextField(
                                    controller: dueDaysController,
                                    hintText: "Due Days",
                                    validate: "number",
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
                                    onPressed: () async {
                                      additem();
                                    },
                                    child: const Text('Add Item'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              itemsTable(),
                              gstCalculation(),
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
                                    onPressed: controller.status.isLoading
                                        ? null
                                        : submit,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }

    var request = {'id': idController.text};
    String? response = await controller.warpPurchasePdf(request: request);

    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }

  shortCutKeys() {
    if (_accountTypeFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Account',Press Alt+C ";
    } else if (_supplierNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Supplier',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_accountTypeFocusNode.hasFocus) {
      var result = await Get.toNamed(AddLedger.routeName);

      if (result == "success") {
        controller.accountInfo();
      }
    } else if (_supplierNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddLedger.routeName);

      if (result == "success") {
        controller.ledgerInfo();
      }
    }
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "firm_id": firmName.value?.id,
        "e_date": dateController.text,
        "details": detailsController.text,
        "supplier_id": supplier.value?.id,
        "act_bill_date": actualBillDateController.text,
        "pa_ano": accountType.value?.id,
        "due_days": int.tryParse(dueDaysController.text) ?? 0,
      };
      var warpPurchaseList = [];

      var itemList = controller.itemList;
      for (var i = 0; i < itemList.length; i++) {
        if (itemList[i]["sync"] == 0) {
          var item = {
            "order_rec_no": itemList[i]['order_rec_no'],
            "warp_design_id": itemList[i]['warp_design_id'],
            "wrap_condition": itemList[i]['wrap_condition'],
            "qty": itemList[i]['qty'],
            "metre": itemList[i]['metre'],
            "empty_type": itemList[i]['empty_type'],
            "empty_qty": itemList[i]['empty_qty'],
            "sheet": itemList[i]['sheet'],
            "calculate_type": itemList[i]['calculate_type'],
            "weight": itemList[i]['weight'],
            "rate": itemList[i]['rate'],
            "amount": itemList[i]['amount'],
            "warp_color": itemList[i]['warp_color'],
            "warp_id": itemList[i]['warp_id'],
            "weaver_id": itemList[i]['weaver_id'],
            "sub_weaver_no": itemList[i]['sub_weaver_no'],
            "warp_for": itemList[i]['warp_for'],
          };
          warpPurchaseList.add(item);
        }
      }
      request['purchase_item'] = warpPurchaseList;

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
        controller.filterData = null;
        controller.add(request);
      } else {
        request['id'] = id;
        request['slip_no'] = int.tryParse(slipNoController.text);
        controller.edit(request);
      }
    }
  }

  void _initValue() {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    actualBillDateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    WarpPurchaseController controller = Get.find();
    controller.request = <String, dynamic>{};
    accountType.value = AppUtils.findLedgerAccountByName(
        controller.accountDropDown, 'Warp Purchase Account');
    firmName.value = AppUtils.setDefaultFirmName(controller.Firm);
    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = WarpPurchaseModel.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      dateController.text = "${item.eDate}";
      actualBillDateController.text = '${item.actBillDate}';
      slipNoController.text = '${item.slipNo}';
      dueDaysController.text = "${item.dueDays}";
      detailsController.text = item.details ?? '';

      // firm
      var firmlist = controller.Firm.where(
          (element) => '${element.id}' == '${item.firmId}').toList();
      if (firmlist.isNotEmpty) {
        firmName.value = firmlist.first;
        firmController.text = '${firmlist.first.firmName}';
      }
      // Supplier Name
      var supplierList = controller.supplierName
          .where((element) => '${element.id}' == '${item.supplierId}')
          .toList();
      if (supplierList.isNotEmpty) {
        supplier.value = supplierList.first;
        supplierController.text = '${supplierList.first.ledgerName}';
      }
      var accountList = controller.accountDropDown
          .where((element) => '${element.id}' == '${item.paAno}')
          .toList();
      if (accountList.isNotEmpty) {
        accountType.value = accountList.first;
        accountTypeController.text = '${accountList.first.ledgerName}';
      }

      /// get created by and updated by details
      DateTime createDate = DateTime.parse(item.createdAt ?? "0000-00-00");
      DateTime updateDate = DateTime.parse(item.updatedAt ?? "0000-00-00");
      createdAt = AppUtils.dateFormatter.format(createDate);
      updatedAt = AppUtils.dateFormatter.format(updateDate);
      createdBy = item.creatorName;
      updatedBy = item.updatedName;
      if (updatedBy != null) {
        displayName = "Edit : $updatedBy";
        displayDate = updatedAt;
      } else {
        displayName = "New : $createdBy";
        displayDate = createdAt;
      }

      item.itemDetails?.forEach((element) {
        amount.value += double.tryParse("${element.amount}") ?? 0.0;
        var request = element.toJson();
        controller.itemList.add(request);
      });

      al1ano = item.al1Ano;
      al2ano = item.al2Ano;
      al3ano = item.al3Ano;
      al4ano = item.al4Ano;

      //al1
      al1TypController.text = item.al1Typ ?? "None";
      al1AccountNoController.text = item.al1AnoName ?? "";
      al1PercController.text = item.al1Perc == null ? '' : '${item.al1Perc}';
      al1AmountController.text = '${item.al1Amount}';

      //al2
      al2TypController.text = item.al2Typ ?? "None";
      al2AccountNoController.text = item.al2AnoName ?? "";
      al2PercController.text = item.al2Perc == null ? '' : '${item.al2Perc}';
      al2AmountController.text = '${item.al2Amount}';

      //al3
      al3TypController.text = item.al3Typ ?? "None";
      al3AccountNoController.text = item.al3AnoName ?? "";
      al3PercController.text = item.al3Perc == null ? '' : '${item.al3Perc}';
      al3AmountController.text = '${item.al3Amount}';

      //al4
      al4TypController.text = item.al4Typ ?? "None";
      al4AccountNoController.text = item.al4AnoName ?? "";
      al4PercController.text = item.al4Perc == null ? '' : '${item.al4Perc}';
      al4AmountController.text = '${item.al4Amount}';

      netAmountController.text = "${item.netTotal}";
      roundOffController.text = "${item.roundOff}";
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

    /// Al Amount Field Controllers Data Type Change
    /*double al1Amount = double.tryParse(al1AmountController.text) ?? 0;
    double al2Amount = double.tryParse(al2AmountController.text) ?? 0;
    double al3Amount = double.tryParse(al3AmountController.text) ?? 0;
    double al4Amount = double.tryParse(al4AmountController.text) ?? 0;*/

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
    netAmountController.text = netAmount.roundToDouble().toStringAsFixed(2);
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

  Widget itemsTable() {
    return MySFDataGridItemTable(
      selectionMode: SelectionMode.single,
      controller: _dataGridController,
      columns: [
        GridColumn(
          width: 60,
          columnName: 'order',
          label: const MyDataGridHeader(title: 'Order'),
        ),
        GridColumn(
          width: 120,
          columnName: 'warp_id',
          label: const MyDataGridHeader(title: 'Warp Id'),
        ),
        GridColumn(
          minimumWidth: 200,
          columnName: 'warp_design_name',
          label: const MyDataGridHeader(title: 'Warp Design'),
        ),
        GridColumn(
          width: 50,
          columnName: 'product_qty',
          label:
              const MyDataGridHeader(alignment: Alignment.center, title: 'Qty'),
        ),
        GridColumn(
          width: 60,
          columnName: 'metre',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Meter'),
        ),
        GridColumn(
          width: 50,
          columnName: 'beam',
          label:
              const MyDataGridHeader(alignment: Alignment.center, title: 'Bm'),
        ),
        GridColumn(
          width: 50,
          columnName: 'bobbin',
          label:
              const MyDataGridHeader(alignment: Alignment.center, title: 'Bbn'),
        ),
        GridColumn(
          width: 50,
          columnName: 'sheet',
          label:
              const MyDataGridHeader(alignment: Alignment.center, title: 'Sht'),
        ),
        GridColumn(
          width: 90,
          columnName: 'wrap_condition',
          label: const MyDataGridHeader(title: 'Condition'),
        ),
        GridColumn(
          width: 80,
          columnName: 'weight',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Weight'),
        ),
        GridColumn(
          width: 70,
          columnName: 'rate',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Rate'),
        ),
        GridColumn(
          width: 90,
          columnName: 'amount',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Amount'),
        ),
        GridColumn(
          width: 140,
          columnName: 'calculate_type',
          label: const MyDataGridHeader(title: 'Calculation Type'),
        ),
        GridColumn(
          minimumWidth: 200,
          columnName: 'warp_color',
          label: const MyDataGridHeader(title: 'Warp Color'),
        ),
        GridColumn(
          width: 180,
          columnName: 'weaver_name',
          label: const MyDataGridHeader(title: 'Weaver Name'),
        ),
        GridColumn(
          width: 60,
          columnName: 'loom_no',
          label: const MyDataGridHeader(title: 'Loom'),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          titleColumnSpan: 0,
          columns: [
            const GridSummaryColumn(
              name: 'product_qty',
              columnName: 'product_qty',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'metre',
              columnName: 'metre',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'sheet',
              columnName: 'sheet',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'amount',
              columnName: 'amount',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'bobbin',
              columnName: 'bobbin',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'beam',
              columnName: 'beam',
              summaryType: GridSummaryType.sum,
            ),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSource,
      onRowSelected: (index) async {
        var item = controller.itemList[index];
        var result = await Get.to(const AddWarpPurchaseBottomSheet(),
            arguments: {'item': item});
        if (result != null) {
          controller.itemList[index] = result;
          amountCalculation();
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        }
      },
    );
  }

  amountCalculation() {
    double total = 0;
    for (var element in controller.itemList) {
      total += element['amount'];
    }
    amount.value = total;
    _calculateAmount();
  }

  void removeSelectedItems() async {
    int? index = _dataGridController.selectedIndex;
    if (index >= 0) {
      var item = controller.itemList[index];

      if (item["sync"] != 0) {
        int warpPurchaseId = item["wrap_purchase_id"];
        int rowId = item["id"];
        var result = await controller.rowRemove(rowId, warpPurchaseId);

        if (result["status"] == "success") {
          controller.itemList.removeAt(index);
          amountCalculation();
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
          _dataGridController.selectedIndex = -1;
          controller.isChanged = true;
        }
      } else {
        controller.itemList.removeAt(index);
        amountCalculation();
        dataSource.updateDataGridRows();
        dataSource.updateDataGridSource();
        _dataGridController.selectedIndex = -1;
      }
    } else {
      AppUtils.infoAlert(message: "Select The Value");
    }
  }

  void additem() async {
    if (controller.itemList.isNotEmpty) {
      controller.lastWarp = controller.itemList.last;
    }

    var supplierId = supplier.value?.id;
    var eDate = dateController.text;

    if (supplierId == null || eDate.isEmpty) {
      return;
    }

    controller.warpID = '';
    if (controller.itemList.isEmpty && eDate.isNotEmpty) {
      var result = await controller.warpIdInfo(supplierId, eDate);

      var item = result?.warpId;
      final split = item?.split('-');
      if (split!.isNotEmpty) {
        var number = int.parse(split.last);
        controller.warpID = '${split.first}-${number + 1}';
      }
    } else {
      var item = controller.itemList.last['warp_id'];

      final split = item.split('-');
      if (split.isNotEmpty) {
        var number = int.parse(split.last);
        controller.warpID = '${split.first}-${number + 1}';
      }
    }

    if (controller.warpID?.isEmpty == true) {
      return;
    }

    var result = await Get.to(const AddWarpPurchaseBottomSheet());
    if (result != null) {
      controller.itemList.add(result);
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
      int beam = 0;
      int bobbin = 0;
      if (e["empty_type"] == "Beam") {
        beam = e["empty_qty"];
      } else {
        bobbin = e["empty_qty"];
      }

      return DataGridRow(cells: [
        DataGridCell<dynamic>(
            columnName: 'order', value: e["order_rec_no"] == 0 ? 'No' : 'Yes'),
        DataGridCell<dynamic>(columnName: 'warp_id', value: e['warp_id']),
        DataGridCell<dynamic>(
            columnName: 'warp_design_name', value: e['warp_design_name']),
        DataGridCell<dynamic>(columnName: 'product_qty', value: e['qty']),
        DataGridCell<dynamic>(columnName: 'metre', value: e['metre']),
        DataGridCell<dynamic>(columnName: 'beam', value: beam),
        DataGridCell<dynamic>(columnName: 'bobbin', value: bobbin),
        DataGridCell<dynamic>(columnName: 'sheet', value: e['sheet']),
        DataGridCell<dynamic>(
            columnName: 'wrap_condition', value: e['wrap_condition']),
        DataGridCell<dynamic>(columnName: 'weight', value: e['weight']),
        DataGridCell<dynamic>(columnName: 'rate', value: e['rate']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['amount']),
        DataGridCell<dynamic>(
            columnName: 'calculate_type', value: e['calculate_type']),
        DataGridCell<dynamic>(columnName: 'warp_color', value: e['warp_color']),
        DataGridCell<dynamic>(
            columnName: 'weaver_name', value: e['weaver_name']),
        DataGridCell<dynamic>(columnName: 'loom_no', value: e['loom_no']),
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
        case 'product_qty':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'metre':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'beam':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'bobbin':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'sheet':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'weight':
          return buildFormattedCell(value, decimalPlaces: 3);
        case 'rate':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'amount':
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
      case 'product_qty':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'metre':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'beam':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'bobbin':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'sheet':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'amount':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      default:
        /* alignment = TextAlign.right;
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
