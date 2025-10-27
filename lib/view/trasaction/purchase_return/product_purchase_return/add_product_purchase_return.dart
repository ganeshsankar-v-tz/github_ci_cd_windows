import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/product_purchase/product_purchase_bottom_sheet.dart';
import 'package:abtxt/view/trasaction/purchase_return/product_purchase_return/product_purchase_return_controller.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../model/FirmModel.dart';
import '../../../../model/LedgerModel.dart';
import '../../../../model/TaxFixingModel.dart';
import '../../../../model/product_purchase_model.dart';
import '../../../../widgets/MyAutoComplete.dart';
import '../../../../widgets/MyCloseButton.dart';
import '../../../../widgets/MyDataGridHeader.dart';
import '../../../../widgets/MyDialogList.dart';
import '../../../../widgets/MySFDataGridItemTable.dart';
import '../../../../widgets/MySmallTextField.dart';
import '../../../../widgets/MyTextField.dart';

class AddProductPurchaseReturn extends StatefulWidget {
  const AddProductPurchaseReturn({super.key});

  static const String routeName = '/AddProductPurchaseReturn';

  @override
  State<AddProductPurchaseReturn> createState() => _State();
}

class _State extends State<AddProductPurchaseReturn> {
  TextEditingController idController = TextEditingController();
  Rxn<FirmModel> firmController = Rxn<FirmModel>();
  TextEditingController firmNameController = TextEditingController();
  Rxn<LedgerModel> supplierNameController = Rxn<LedgerModel>();
  TextEditingController supplierController = TextEditingController();
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
  TextEditingController al1AmountController = TextEditingController(text: "0");
  TextEditingController al2AmountController = TextEditingController(text: "0");
  TextEditingController al3AmountController = TextEditingController(text: "0");
  TextEditingController al4AmountController = TextEditingController(text: "0");
  TextEditingController roundOffController = TextEditingController(text: "0");
  TextEditingController netAmountController = TextEditingController(text: "0");

  RxDouble amount = RxDouble(0);
  RxDouble netAmount = RxDouble(0);

  // RxDouble roundOff = RxDouble(0);
  RxDouble al1Amount = RxDouble(0);
  RxDouble al2Amount = RxDouble(0);
  RxDouble al3Amount = RxDouble(0);
  RxDouble al4Amount = RxDouble(0);

  int? al1ano;
  int? al2ano;
  int? al3ano;
  int? al4ano;

  final _formKey = GlobalKey<FormState>();

  ProductPurchaseReturnController controller =
      Get.put(ProductPurchaseReturnController());

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
    return GetBuilder<ProductPurchaseReturnController>(builder: (controller) {
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyS,
            'Save',
            () async => submit(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.all(16),
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
                          items: controller.firmNameDropdown,
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
                          items: controller.supplierNameDropdown,
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
                        MyTextField(
                          controller: detailsController,
                          hintText: "Details",
                          // validate: "string",
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ItemsTable(),
                    gstWidget(),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyCloseButton(
                          onPressed: () => Get.back(),
                          child: const Text('Close'),
                        ),
                        const SizedBox(width: 16),
                        MyElevatedButton(
                          onPressed: () {
                            submit();
                          },
                          child:
                              Text(Get.arguments == null ? 'Save' : 'Update'),
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
        "details": detailsController.text,
      };

      request['item_details'] = itemList;

      // al1
      request["al1_typ"] = al1TypController.text;

      request["al1_perc"] = double.tryParse(al1PercController.text) ?? 0.00;
      if (al1TypController.text != "None") {
        request["al1_ano"] = al1ano;
      }

      // al2
      request["al2_typ"] = al2TypController.text;
      request["al2_perc"] = double.tryParse(al2PercController.text) ?? 0.00;
      if (al2TypController.text != "None") {
        request["al2_ano"] = al2ano;
      }

      //al3
      request["al3_typ"] = al3TypController.text;

      request["al3_perc"] = double.tryParse(al3PercController.text) ?? 0.00;
      if (al3TypController.text != "None") {
        request["al3_ano"] = al3ano;
      }

      //al4
      request["al4_typ"] = al4TypController.text;
      request["al4_perc"] = double.tryParse(al4PercController.text) ?? 0.00;
      if (al4TypController.text != "None") {
        request["al4_ano"] = al4ano;
      }

      var id = idController.text;
      if (id.isEmpty) {
        // controller.AddProductPurchaseReturn(request);
      } else {
        request['id'] = id;
        controller.updateproductpurchase(request);
      }
    }
  }

  void _initValue() {
    purchaseDateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    ProductPurchaseReturnController controller = Get.find();
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

      firmController.value =
          FirmModel(id: item.firmId, firmName: item.firmName);
      firmNameController.text = '${item.firmName}';
      supplierNameController.value =
          LedgerModel(id: item.suplierId!, ledgerName: item.suplierName);

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
