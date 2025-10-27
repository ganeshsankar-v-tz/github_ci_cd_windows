import 'dart:convert';

import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/product_purchase/product_purchase_bottom_sheet.dart';
import 'package:abtxt/view/trasaction/product_purchase/product_purchase_controller.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/TaxFixingModel.dart';
import '../../../model/product_purchase_model.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MySmallTextFieldNew.dart';
import '../../../widgets/MyTextField.dart';

class AddProductPurchase extends StatefulWidget {
  const AddProductPurchase({Key? key}) : super(key: key);
  static const String routeName = '/AddProductPurchase';

  @override
  State<AddProductPurchase> createState() => _State();
}

class _State extends State<AddProductPurchase> {
  TextEditingController idController = TextEditingController();
  Rxn<FirmModel> firmController = Rxn<FirmModel>();
  TextEditingController firmNameController = TextEditingController();
  Rxn<LedgerModel> supplierNameController = Rxn<LedgerModel>();
  TextEditingController supplierController = TextEditingController();
  Rxn<LedgerModel> accountTypeController = Rxn<LedgerModel>();
  TextEditingController accountController = TextEditingController();
  TextEditingController dcInvoiceNoController = TextEditingController();
  TextEditingController purchaseNoController = TextEditingController();
  TextEditingController purchaseDateController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController totalPiecesController = TextEditingController();
  TextEditingController totalQuantityController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();

  //GST Calculation
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

  RxDouble amount = RxDouble(0);
  RxDouble netAmount = RxDouble(0);

  // RxDouble roundOff = RxDouble(0);
  RxDouble al1Amount = RxDouble(0);
  RxDouble al2Amount = RxDouble(0);
  RxDouble al3Amount = RxDouble(0);
  RxDouble al4Amount = RxDouble(0);

  int? al1ano = null;
  int? al2ano = null;
  int? al3ano = null;
  int? al4ano = null;

  bool _isMyDialogListEnabled = true;
  bool _isDisable1 = true;
  bool _isDisable2 = true;
  bool _isDisable3 = true;
  bool _isDisable4 = true;

  final _formKey = GlobalKey<FormState>();

  late ProductPurchaseController controller;

  // var productList = <dynamic>[].obs;

  var itemList = <dynamic>[];
  late ItemDataSource dataSource;

  @override
  void initState() {
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: itemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductPurchaseController>(builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close',
            () => Get.back(),
            isControlPressed: true,
          ),
          KeyAction(
            LogicalKeyboardKey.keyA,
            'Add',
            () => additem(),
            isControlPressed: true,
          ),
          KeyAction(
            LogicalKeyboardKey.keyS,
            'Save',
            () async => submit(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Product Purchase"),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Container(
              width: Get.width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFF9F3FF), width: 12),
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
                        MyAutoComplete(
                          label: 'Firm',
                          items: controller.firmName,
                          selectedItem: firmController.value,
                          onChanged: (FirmModel item) {
                            firmController.value = item;
                            //  _firmNameFocusNode.requestFocus();
                          },
                        ),
                        /*MyDialogList(
                          labelText: 'Firm',
                          controller: firmNameController,
                          list: controller.firmName,
                          showCreateNew: false,
                          onItemSelected: (FirmModel item) {
                            firmNameController.text = '${item.firmName}';
                            firmController.value = item;
                            // controller.request['group_name'] = item.id;
                          },
                          onCreateNew: (value) async {
                            //supplier.value = null;
                            // var item =
                            // await Get.toNamed(AddWarpGroup.routeName);
                            // controller.onInit();
                          },
                        ),*/
                        MyAutoComplete(
                          label: 'Supplier Name',
                          items: controller.Supplier,
                          selectedItem: supplierNameController.value,
                          onChanged: (LedgerModel item) async {
                            supplierNameController.value = item;
                            controller.request['supplier_id'] = item.id;
                            var list =
                                await controller.taxFixing('Yarn Purchase');
                            _taxDialog(list);
                            //  _firmNameFocusNode.requestFocus();
                          },
                        ),
                        /*MyDialogList(
                          labelText: 'Supplier Name',
                          controller: supplierController,
                          list: controller.Supplier,
                          showCreateNew: true,
                          onItemSelected: (LedgerModel item) async {
                            supplierController.text = '${item.ledgerName}';
                            supplierNameController.value = item;
                            controller.request['supplier_id'] = item.id;
                            var list =
                                await controller.taxFixing('Yarn Purchase');
                            _taxDialog(list);
                          },
                          onCreateNew: (value) async {
                            //supplier.value = null;
                            var item = await Get.toNamed(AddLedger.routeName);
                            controller.onInit();
                          },
                        ),*/
                        MyTextField(
                          controller: purchaseNoController,
                          hintText: "Purchase No",
                          validate: "string",
                        ),
                        MyDateField(
                          controller: purchaseDateController,
                          hintText: "Purchase Date",
                          validate: "string",
                          readonly: true,
                        ),
                        MyTextField(
                          controller: dcInvoiceNoController,
                          hintText: "D.C / Invoice No",
                          //  validate: "string",
                        ),
                        MyAutoComplete(
                          label: 'Account Type',
                          items: controller.Account,
                          selectedItem: accountTypeController.value,
                          onChanged: (LedgerModel item) {
                            accountTypeController.value = item;
                            //  _firmNameFocusNode.requestFocus();
                          },
                        ),
                        /*MyDialogList(
                          labelText: 'Account Type',
                          controller: accountController,
                          list: controller.Account,
                          showCreateNew: false,
                          onItemSelected: (LedgerModel item) {
                            accountController.text = '${item.ledgerName}';
                            accountTypeController.value = item;
                            // controller.request['group_name'] = item.id;
                          },
                          onCreateNew: (value) async {
                            //supplier.value = null;
                          },
                        ),*/
                        MyTextField(
                          controller: detailsController,
                          hintText: "Details",
                          // validate: "string",
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: AddItemsElevatedButton(
                        width: 135,
                        onPressed: () async {
                          additem();
                        },
                        child: const Text('Add Item'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ItemsTable(),
                    GST_Calculation(),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyCloseButton(
                          onPressed: () => Get.back(),
                          child: const Text('Close'),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          child: MyElevatedButton(
                            onPressed: () {
                              submit();
                            },
                            child: Text(
                                "${Get.arguments == null ? 'Save' : 'Update'}"),
                          ),
                        ),
                      ],
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

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "firm_id": firmController.value?.id,
        "suplier_id": supplierNameController.value?.id,
        "purchase_type": purchaseNoController.text,
        "e_date": purchaseDateController.text,
        "reference_no": dcInvoiceNoController.text,
        "pa_ano": accountTypeController.value?.id,
        "details": detailsController.text ?? '',
      };
      /*
         var productPurchaseList = [];
      double amountTotal = 0.0;
      dynamic piecesTotal = 0;
      dynamic QuantityTotal = 0;
      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "product_id": itemList[i]['product_id'],
          "design_no": itemList[i]['design_no'],
          "work_status": itemList[i]['work_status'],
          "pieces": itemList[i]['pieces'],
          "product_qty": itemList[i]['product_qty'],
          "product_rate": itemList[i]['product_rate'],
          "product_net_amount": itemList[i]['product_net_amount'],
          "stock": itemList[i]['stock'],
          "work_details": itemList[i]['work_details'],
        };
        //
        // QuantityTotal +=itemList[i]['product_qty'];
        // piecesTotal += itemList[i]['pieces'];
        // amountTotal +=
        //     itemList[i]['product_net_amount'];

        productPurchaseList.add(item);
      }

      request['total_product_amount'] = amountTotal;
      request['total_pieces'] = piecesTotal;
      request['total_product_qty'] = QuantityTotal;
      request['product_item'] = productPurchaseList;

      print(request);
      */

      request['item_details'] = itemList;

      // al1
      request["al1_typ"] = al1TypController.text;

      request["al1_perc"] = double.tryParse(al1PercController.text) ?? 0.00;
      if ('${al1TypController.text}' != "None") {
        request["al1_ano"] = al1ano;
      }

      // al2
      request["al2_typ"] = al2TypController.text;
      request["al2_perc"] = double.tryParse(al2PercController.text) ?? 0.00;
      if ('${al2TypController.text}' != "None") {
        request["al2_ano"] = al2ano;
      }

      //al3
      request["al3_typ"] = al3TypController.text;

      request["al3_perc"] = double.tryParse(al3PercController.text) ?? 0.00;
      if ('${al3TypController.text}' != "None") {
        request["al3_ano"] = al3ano;
      }

      //al4
      request["al4_typ"] = al4TypController.text;
      request["al4_perc"] = double.tryParse(al4PercController.text) ?? 0.00;
      if ('${al4TypController.text}' != "None") {
        request["al4_ano"] = al4ano;
      }

      var id = idController.text;
      if (id.isEmpty) {
        controller.addproductpurchase(request);
      } else {
        request['id'] = '$id';
        controller.updateproductpurchase(request);
      }

      print(request);
    }
  }

  void _initValue() {
    purchaseDateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    ProductPurchaseController controller = Get.find();
    controller.request = <String, dynamic>{};

    if (Get.arguments != null) {
      var item = ProductPurchaseModel.fromJson(Get.arguments['item']);
      idController.text = tryCast(item.id);
      purchaseNoController.text = '${item.purchaseType}';
      purchaseDateController.text = '${item.eDate}';
      // detailsController.text = '${item.details}';
      detailsController.text = item.details ?? '';
      // dcInvoiceNoController.text = '${item.referenceNo}';
      dcInvoiceNoController.text = tryCast(item.referenceNo);

      // firm
      var firmlist = controller.firmName
          .where((element) => '${element.id}' == '${item.firmId}')
          .toList();
      if (firmlist.isNotEmpty) {
        firmController.value = firmlist.first;
        firmNameController.text = '${firmlist.first.firmName}';
      }
      //  Supplier Name
      var suppilerList = controller.Supplier.where(
          (element) => '${element.id}' == '${item.suplierId}').toList();
      if (suppilerList.isNotEmpty) {
        supplierNameController.value = suppilerList.first;
        controller.request['supplier_id'] = suppilerList.first.id;
        supplierController.text = '${suppilerList.first.ledgerName}';
      }

      var accountTypeList = controller.Account.where(
          (element) => '${item.paAno}' == '${element.id}').toList();
      if (accountTypeList.isNotEmpty) {
        accountTypeController.value = accountTypeList.first;
        accountController.text = '${accountTypeList.first.ledgerName}';
      }

      item.productItem?.forEach((element) {
        // amount.value += element.productNetAmount;
        amount.value += element.amount!;
        var request = element.toJson();
        itemList.add(request);
      });

      al1ano = item.al1Ano;
      al2ano = item.al2Ano;
      al3ano = item.al3Ano;
      al4ano = item.al4Ano;

      //al1
      al1TypController.text = item.al1Typ ?? "None";

      al1PercController.text = tryCast(item.al1Perc);
      al1Amount.value = double.tryParse('${item.al1Amount}') ?? 0.00;

      //al2
      al2TypController.text = item.al2Typ ?? "None";
      al2PercController.text = tryCast(item.al2Perc);
      al2Amount.value = double.tryParse('${item.al2Amount}') ?? 0.00;
      //al3
      al3TypController.text = item.al3Typ ?? "None";
      al3PercController.text = tryCast(item.al3Perc);
      al3Amount.value = double.tryParse('${item.al3Amount}') ?? 0.00;
      //al4
      al4TypController.text = item.al4Typ ?? "None";
      al4PercController.text = tryCast(item.al4Perc);
      al4Amount.value = double.tryParse('${item.al4Amount}') ?? 0.00;

      netAmount.value = double.tryParse("${item.netTotal}") ?? 0.00;
    }
    // initTotal();
  }

  Widget GST_Calculation() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: 400,
        color: Colors.white,
        padding: EdgeInsets.all(12.0),
        child: Table(
          // border: TableBorder.all(),
          children: [
            TableRow(children: [
              SizedBox(
                height: 50,
                child: MyDropdownButtonFormField(
                  controller: al1TypController,
                  hintText: "",
                  items: ["None", "Add", "Less"],
                  onChanged: (String value) {
                    setState(() {
                      if (value == 'None') {
                        al1AccountNoController.clear();
                        _isMyDialogListEnabled = false;
                        al1PercController.clear();
                        al1Amount.value = 0.0;
                        _isDisable1 = false;
                        _calculateAmount();
                      } else if (value == 'Add') {
                        _calculateAmount();
                        _isDisable1 = true;
                      } else if (value == 'Less') {
                        _calculateAmount();
                        _isDisable1 = true;
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                height: 50,
                child: MySmallTextFieldNew(
                  controller: al1AccountNoController,
                  enabled: _isDisable1,
                ),
              ),
              MySmallTextFieldNew(
                controller: al1PercController,
                onChanged: (value) => _calculateAmount(),
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
                enabled: _isDisable1,
              ),
              Obx(() => Container(
                    height: 50,
                    padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(al1Amount.toStringAsFixed(2))),
                  )),
            ]),
            TableRow(children: [
              SizedBox(
                height: 50,
                child: MyDropdownButtonFormField(
                  controller: al2TypController,
                  hintText: "",
                  items: ["None", "Add", "Less"],
                  onChanged: (String value) {
                    setState(() {
                      if (value == 'None') {
                        al2AccountNoController.clear();
                        _isMyDialogListEnabled = false;
                        al2PercController.clear();
                        al2Amount.value = 0.0;
                        _isDisable2 = false;
                        _calculateAmount();
                      } else if (value == 'Add') {
                        _calculateAmount();
                        _isDisable2 = true;
                      } else if (value == 'Less') {
                        _calculateAmount();
                        _isDisable2 = true;
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                height: 50,
                child: MySmallTextFieldNew(
                  controller: al2AccountNoController,
                  enabled: _isDisable2,
                ),
              ),
              MySmallTextFieldNew(
                controller: al2PercController,
                onChanged: (value) => _calculateAmount(),
                enabled: _isDisable2,
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              Obx(() => Container(
                    height: 50,
                    padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(al2Amount.toStringAsFixed(2))),
                  )),
            ]),
            TableRow(children: [
              SizedBox(
                height: 50,
                child: MyDropdownButtonFormField(
                  controller: al3TypController,
                  hintText: "",
                  items: ["None", "Add", "Less"],
                  onChanged: (String value) {
                    setState(() {
                      if (value == 'None') {
                        al3AccountNoController.clear();
                        _isMyDialogListEnabled = false;
                        al3PercController.clear();
                        al3Amount.value = 0.0;
                        _isDisable3 = false;
                        _calculateAmount();
                      } else if (value == 'Add') {
                        _calculateAmount();
                        _isDisable3 = true;
                      } else if (value == 'Less') {
                        _calculateAmount();
                        _isDisable3 = true;
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                height: 50,
                child: MySmallTextFieldNew(
                  controller: al3AccountNoController,
                  enabled: _isDisable3,
                ),
              ),
              MySmallTextFieldNew(
                controller: al3PercController,
                onChanged: (value) => _calculateAmount(),
                enabled: _isDisable3,
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              Obx(() => Container(
                    height: 50,
                    padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(al3Amount.toStringAsFixed(2))),
                  )),
            ]),
            TableRow(children: [
              SizedBox(
                height: 50,
                child: MyDropdownButtonFormField(
                  controller: al4TypController,
                  hintText: "",
                  items: ["None", "Add", "Less"],
                  onChanged: (String value) {
                    setState(() {
                      if (value == 'None') {
                        al4AccountNoController.clear();
                        _isMyDialogListEnabled = false;
                        al4PercController.clear();
                        al4Amount.value = 0.0;
                        _isDisable4 = false;
                        _calculateAmount();
                      } else if (value == 'Add') {
                        _calculateAmount();
                        _isDisable4 = true;
                      } else if (value == 'Less') {
                        _calculateAmount();
                        _isDisable4 = true;
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                height: 50,
                child: MySmallTextFieldNew(
                  controller: al4AccountNoController,
                  enabled: _isDisable4,
                ),
              ),
              MySmallTextFieldNew(
                controller: al4PercController,
                onChanged: (value) => _calculateAmount(),
                enabled: _isDisable4,
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              Obx(() => Container(
                  height: 50,
                  padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(al4Amount.toStringAsFixed(2))))),
            ]),
            TableRow(children: [
              const Text(''),
              const Text(''),
              const Text(
                'Net Total',
              ),
              Obx(() => Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$netAmount   ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ))),
            ]),
          ],
        ),
      ),
    );
  }

  void _calculateAmount2() {
    int al1Percent = int.tryParse(al1PercController.text) ?? 0;

    double total = amount.value;
    if (al1TypController.text == 'None') {
      al1Amount.value = 0;
    } else {
      al1Amount.value = (amount.value * al1Percent) / 100;
      if (al1TypController.text == 'Add') {
        total += al1Amount.value;
      } else {
        total -= al1Amount.value;
      }
    }

    double netTotal = total.roundToDouble();
    // double roundOfRemainder = total - netTotal;
    // roundOff.value = roundOfRemainder;
    netAmount.value = netTotal;
  }

  void _calculateAmount() {
    int al1Percent = int.tryParse(al1PercController.text) ?? 0;
    int al2Percent = int.tryParse(al2PercController.text) ?? 0;
    int al3Percent = int.tryParse(al3PercController.text) ?? 0;
    int al4Percent = int.tryParse(al4PercController.text) ?? 0;

    double total = amount.value;
    if (al1TypController.text == 'None') {
      al1Amount.value = 0;
    } else {
      al1Amount.value = (amount.value * al1Percent) / 100;
      if (al1TypController.text == 'Add') {
        total += al1Amount.value;
      } else {
        total -= al1Amount.value;
      }
    }
    if (al2TypController.text == 'None') {
      al2Amount.value = 0;
    } else {
      al2Amount.value = (amount.value * al2Percent) / 100;
      if (al2TypController.text == 'Add') {
        total += al2Amount.value;
      } else {
        total -= al2Amount.value;
      }
    }
    if (al3TypController.text == 'None') {
      al3Amount.value = 0;
    } else {
      al3Amount.value = (amount.value * al3Percent) / 100;
      if (al3TypController.text == 'Add') {
        total += al3Amount.value;
      } else {
        total -= al3Amount.value;
      }
    }
    if (al4TypController.text == 'None') {
      al4Amount.value = 0;
    } else {
      al4Amount.value = (amount.value * al4Percent) / 100;
      if (al4TypController.text == 'Add') {
        total += al4Amount.value;
      } else {
        total -= al4Amount.value;
      }
    }
    double netTotal = total.roundToDouble();
    // double roundOfRemainder = total - netTotal;
    // roundOff.value = roundOfRemainder;
    netAmount.value = netTotal;
    // print('Round Of : ${261893.55}'.split("."));
  }

  Widget ItemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'product_name',
          label: const MyDataGridHeader(title: 'Product Name'),
        ),
        GridColumn(
          columnName: 'design_no',
          label: const MyDataGridHeader(title: 'Design No'),
        ),
        GridColumn(
          columnName: 'work_no',
          label: const MyDataGridHeader(title: 'Work'),
        ),
        GridColumn(
          columnName: 'pieces',
          label: const MyDataGridHeader(title: 'Pieces'),
        ),
        GridColumn(
          columnName: 'quantity',
          label: const MyDataGridHeader(title: 'Quantity'),
        ),
        GridColumn(
          columnName: 'rate',
          label: const MyDataGridHeader(title: 'Rate (Rs)'),
        ),
        GridColumn(
          columnName: 'amount',
          label: const MyDataGridHeader(title: 'Amount (Rs)'),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'pieces',
              columnName: 'pieces',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'quantity',
              columnName: 'quantity',
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
        var result = await Get.to(const ProductPurchaseBottomSheet(),
            arguments: {'item': item});
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

  void additem() async {
    var result = await Get.to(ProductPurchaseBottomSheet());
    print(jsonEncode(result));
    if (result != null) {
      itemList.add(result);

      double _total = 0;
      itemList.forEach((element) {
        _total += element['amount'];
      });
      amount.value = _total;
      _calculateAmount();

      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    }
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
            content: Container(
              height: 300,
              width: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = list[index];
                  return ListTile(
                    autofocus: true,
                    title: Text('${item}'),
                    onTap: () {
                      _initTaxWidget(item);
                      _calculateAmount();
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
    al1AccountNoController.text = '${item.al1AnoName}';
    al1Tax.value = item;
    al1PercController.text = '${item.al1Perc}';
    //a2
    al2AccountNoController.text = '${item.al2AnoName}';
    al2Tax.value = item;
    al2PercController.text = '${item.al2Perc}';
    //a3
    al3AccountNoController.text = '${item.al3AnoName}';
    al3Tax.value = item;
    al3PercController.text = '${item.al3Perc}';
    //a4
    al4AccountNoController.text = '${item.al4AnoName}';
    al4Tax.value = item;
    al4PercController.text = '${item.al4Perc}';
    _calculateAmount();
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
            columnName: 'product_name', value: e['product_name']),
        DataGridCell<dynamic>(
            columnName: 'design_no', value: e['design_no'] ?? ''),
        DataGridCell<dynamic>(columnName: 'work_no', value: e['work_no']),
        DataGridCell<dynamic>(columnName: 'pieces', value: e['pieces']),
        DataGridCell<dynamic>(columnName: 'quantity', value: e['quantity']),
        DataGridCell<dynamic>(columnName: 'rate', value: e['rate']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['amount']),
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
        '${summaryValue}',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
