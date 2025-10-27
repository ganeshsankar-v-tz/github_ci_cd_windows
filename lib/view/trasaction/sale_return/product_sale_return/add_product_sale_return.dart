import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/TaxFixingModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/sale_return/product_sale_return/product_sale_return_bottomsheeet.dart';
import 'package:abtxt/view/trasaction/sale_return/product_sale_return/product_sale_return_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../model/credit_note/ProductSaleReturnSlipNoModel.dart';
import '../../../../model/product_sale/ProductOrderDetailsModel.dart';
import '../../../../model/vehicle_details/VehicleDetailsModel.dart';
import '../../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../../widgets/MyAutoComplete.dart';
import '../../../../widgets/MyDataGridHeader.dart';
import '../../../../widgets/MyDialogList.dart';
import '../../../../widgets/MySFDataGridItemTable.dart';
import '../../../../widgets/MySmallTextField.dart';
import '../../../../widgets/MyTextField.dart';
import '../../../../widgets/flutter_shortcut_widget.dart';

class AddProductSalesReturn extends StatefulWidget {
  final Map? value;

  const AddProductSalesReturn({
    super.key,
    this.value,
  });

  static const String routeName = '/add_product_sales_return';

  @override
  State<AddProductSalesReturn> createState() => _State();
}

class _State extends State<AddProductSalesReturn> {
  TextEditingController idController = TextEditingController();
  Rxn<FirmModel> firmNameController = Rxn<FirmModel>();
  TextEditingController firmNameTextController = TextEditingController();
  Rxn<LedgerModel> customerName = Rxn<LedgerModel>();
  TextEditingController customerNameTextController = TextEditingController();
  TextEditingController returnDateController = TextEditingController();
  TextEditingController lrNoController = TextEditingController();
  TextEditingController lrDateController = TextEditingController();
  Rxn<ProductSaleReturnSlipNoModel> slipNoValue =
      Rxn<ProductSaleReturnSlipNoModel>();
  TextEditingController slipNoController = TextEditingController();

  TextEditingController transportTextController = TextEditingController();
  Rxn<VehicleDetailsModel> transportController = Rxn<VehicleDetailsModel>();
  TextEditingController freightController =
      TextEditingController(text: "ToPay");
  TextEditingController noOfBagsController = TextEditingController(text: "0");
  TextEditingController detailsController = TextEditingController();

  // if order is yes use Rxn value
  Rxn<ProductOrderDetailsModel> orderNoController =
      Rxn<ProductOrderDetailsModel>();
  TextEditingController orderNoText = TextEditingController();
  var orderController = TextEditingController(text: "No").obs;

  /// Gst controllers
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

  final FocusNode _firmFocusNode = FocusNode();
  final FocusNode _orderFocusNode = FocusNode();
  final FocusNode _customerFocusNode = FocusNode();
  final FocusNode _slipNoFocusNode = FocusNode();
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _transportFocusNode = FocusNode();
  final FocusNode _freightFocusNode = FocusNode();

  final DataGridController _dataGridController = DataGridController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var itemList = <dynamic>[];

  /// this details used for update purpose only
  int? challanNo;
  int? referId;

  int? al1ano;
  int? al2ano;
  int? al3ano;
  int? al4ano;

  final _formKey = GlobalKey<FormState>();

  late ProductSalesItemDataSource dataSource;
  ProductSalesReturnController controller =
      Get.put(ProductSalesReturnController());
  RxBool isUpdate = RxBool(false);

  /// if order is Yes disable the addItem details
  RxBool isVisible = RxBool(false);

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
    dataSource = ProductSalesItemDataSource(list: itemList);
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_dateFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductSalesReturnController>(builder: (controller) {
      return ShortCutWidget(
        scaffoldKey: _scaffoldKey,
        loadingStatus: controller.status.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyP, control: true):
              PrintIntent(),
          SingleActivator(LogicalKeyboardKey.keyR, control: true):
              RemoveIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            SaveIntent: SetCounterAction(perform: () => submit()),
            RemoveIntent:
                SetCounterAction(perform: () => removeSelectedItems()),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        children: [
                          MySearchField(
                            label: 'Firm',
                            items: controller.firmName,
                            textController: firmNameTextController,
                            focusNode: _firmFocusNode,
                            enabled: !isUpdate.value,
                            requestFocus: _customerFocusNode,
                            onChanged: (FirmModel item) {
                              firmNameController.value = item;
                            },
                          ),
                          MySearchField(
                            width: 300,
                            label: 'Customer Name',
                            items: controller.customerDropdown,
                            textController: customerNameTextController,
                            focusNode: _customerFocusNode,
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
                            requestFocus: _dateFocusNode,
                            onChanged: (ProductSaleReturnSlipNoModel item) {
                              slipNoValue.value = item;

                              _selectedSlipNoDisplay(item);
                            },
                          ),
                          Obx(
                            () => MyDropdownButtonFormField(
                              focusNode: _orderFocusNode,
                              width: 160,
                              controller: orderController.value,
                              enabled: false,
                              hintText: "Order",
                              items: const ["No", "Yes"],
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: isVisible.value,
                              child: MyAutoComplete(
                                width: 160,
                                label: 'Order No',
                                items: controller.orderDetails,
                                selectedItem: orderNoController.value,
                                enabled: false,
                                isValidate: false,
                                onChanged:
                                    (ProductOrderDetailsModel item) async {},
                              ),
                            ),
                          ),
                          MyDateFilter(
                            focusNode: _dateFocusNode,
                            width: 160,
                            controller: returnDateController,
                            labelText: 'Return Date',
                          ),
                          MyDateFilter(
                            width: 160,
                            controller: lrDateController,
                            labelText: 'LR Date',
                            required: false,
                          ),
                          MyTextField(
                            controller: lrNoController,
                            hintText: "LR No",
                          ),
                          MySearchField(
                            width: 300,
                            label: 'Transport',
                            items: controller.vehicleDetailsList,
                            textController: transportTextController,
                            focusNode: _transportFocusNode,
                            requestFocus: _freightFocusNode,
                            isValidate: false,
                            onChanged: (VehicleDetailsModel item) async {
                              transportController.value = item;
                            },
                          ),
                          MyDropdownButtonFormField(
                              width: 160,
                              focusNode: _freightFocusNode,
                              controller: freightController,
                              hintText: "Freight",
                              items: const ["ToPay", "Paid"]),
                          MyTextField(
                            controller: noOfBagsController,
                            hintText: "No Of Package",
                            validate: "number",
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
                      itemsTable(),
                      gstCalculation(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          crateAndUpdatedBy(),
                          MySubmitButton(
                            onPressed:
                                controller.status.isLoading ? null : submit,
                          ),
                        ],
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

  controllerClear() {
    itemList.clear();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "credit_note_type": "Product sale return",
        "firm_id": firmNameController.value?.id,
        "customer_id": customerName.value?.id,
        "order_no": orderNoController.value?.orderNo,
        "order": orderController.value.text,
        "slip_no": slipNoValue.value?.id,
        "e_date": returnDateController.text,
        "lr_date": lrDateController.text,
        "lr_no": lrNoController.text,
        "freight": freightController.text,
        "transport": transportTextController.text,
        "no_of_bags": int.tryParse(noOfBagsController.text) ?? 0,
        "details": detailsController.text,
      };

      request['item_details'] = itemList;
      double totalNetQty = 0.00;

      for (var e in itemList) {
        totalNetQty += double.tryParse(e['qty'].toString()) ?? 0.00;
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
        controller.edit(request, id);
      }
    }
  }

  void _initValue() async {
    returnDateController.text = AppUtils.parseDateTime("${DateTime.now()}");

    if (widget.value != null && widget.value!.isNotEmpty) {
      isUpdate.value = true;

      var id = widget.value!["id"];
      referId = widget.value!['refer_id'];
      challanNo = widget.value!['challan_no'];
      var item = await controller.selectedDebitNoteDetails(id);
      idController.text = "${item["id"]}";
      returnDateController.text = '${item["e_date"]}';
      transportTextController.text = tryCast(item["transport"] ?? "");
      detailsController.text = tryCast(item["details"]);
      freightController.text = "${item["freight"]}";
      lrNoController.text = item["lr_no"] ?? "";
      noOfBagsController.text = "${item["no_of_bag"] ?? "0"}";

      customerName.value = LedgerModel(
          id: item["customer_id"], ledgerName: item["customer_name"]);
      customerNameTextController.text = "${item["customer_name"]}";

      firmNameController.value =
          FirmModel(id: item["firm_id"], firmName: item["firm_name"]);
      firmNameTextController.text = "${item["firm_name"]}";

      slipNoController.text = "${item["slip_no"]}";
      slipNoValue.value = ProductSaleReturnSlipNoModel(
          id: item["slip_no"], billNo: item["slip_no"]);

      /// get created by and updated by details
      DateTime createDate = DateTime.parse(item["created_at"] ?? "0000-00-00");
      DateTime updateDate = DateTime.parse(item["updated_at"] ?? "0000-00-00");
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
      },
    );
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

    calculateAmount();
  }

  Widget itemsTable() {
    return MySFDataGridItemTable(
      source: dataSource,
      controller: _dataGridController,
      selectionMode: SelectionMode.single,
      columns: [
        GridColumn(
          columnName: 'product_name',
          label: const MyDataGridHeader(title: 'Product Name'),
        ),
        GridColumn(
          width: 120,
          columnName: 'qty',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Quantity'),
        ),
        GridColumn(
          width: 150,
          columnName: 'rate',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Rate(Rs)'),
        ),
        GridColumn(
          width: 150,
          columnName: 'amount',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Amount(Rs)'),
        ),
        GridColumn(
          columnName: 'details',
          label: const MyDataGridHeader(title: 'Details'),
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
      onRowSelected: (index) async {
        var item = itemList[index];

        var result = await Get.to(() => const ProductSalesReturnBottomSheet(),
            arguments: {"item": item});
        if (result != null) {
          itemList[index] = result;
          amountCalculation();
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        }
      },
    );
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
                    calculateAmount();
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
                  calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al1AmountController,
                onChanged: (value) {
                  al1PercController.text = '0';
                  calculateAmount();
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
                    calculateAmount();
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
                  calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al2AmountController,
                onChanged: (value) {
                  al2PercController.text = '0';
                  calculateAmount();
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
                    calculateAmount();
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
                  calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al3AmountController,
                onChanged: (value) {
                  al3PercController.text = '0';
                  calculateAmount();
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
                    calculateAmount();
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
                  calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al4AmountController,
                onChanged: (value) {
                  al4PercController.text = '0';
                  calculateAmount();
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

  amountCalculation() {
    double total = 0;
    for (var element in itemList) {
      total += element['amount'];
    }

    amount.value = total;
    calculateAmount();
  }

  void calculateAmount() {
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
    netAmountController.text = netAmount.roundToDouble().toStringAsFixed(2);
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

  void _apiCalls() async {
    itemList.clear();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
    slipNoValue.value = null;
    slipNoController.text = "";

    var list = await controller.taxFixing('Product Sales');
    _taxDialog(list);

    controller.slipNoDetails("Product sale return",
        firmNameController.value?.id, customerName.value?.id);
  }

  void _selectedSlipNoDisplay(ProductSaleReturnSlipNoModel item) {
    itemList.clear();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();

    orderNoController.value = ProductOrderDetailsModel(orderNo: item.orderNo);
    orderNoText.text = item.orderNo ?? "";
    orderController.value.text = "${item.order}";
    if (item.order == "Yes") {
      isVisible.value = true;
    } else {
      isVisible.value = false;
    }

    noOfBagsController.text = "${item.noOfBags}";
    item.productSaleDetails?.forEach((element) {
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

class ProductSalesItemDataSource extends DataGridSource {
  ProductSalesItemDataSource({required List<dynamic> list}) {
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
        DataGridCell<dynamic>(columnName: 'qty', value: e['qty']),
        DataGridCell<dynamic>(columnName: 'rate', value: e['rate']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['amount']),
        DataGridCell<dynamic>(columnName: 'details', value: e['details']),
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
        case 'pieces':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'qty':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'amount':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'rate':
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
      case 'pieces':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'qty':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'amount':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      case 'rate':
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
