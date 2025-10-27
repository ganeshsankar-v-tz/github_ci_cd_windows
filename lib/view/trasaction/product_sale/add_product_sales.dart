import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/TaxFixingModel.dart';
import 'package:abtxt/model/product_sale/ProductOrderDetailsModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/product_sale/product_sale_controller.dart';
import 'package:abtxt/view/trasaction/product_sale/product_sale_filter.dart';
import 'package:abtxt/view/trasaction/product_sale/product_sales_bottom_sheet.dart';
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
import 'package:url_launcher/url_launcher.dart';

import '../../../model/ProductSaleModel.dart';
import '../../../model/vehicle_details/VehicleDetailsModel.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MySmallTextField.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../basics/ledger/addledger.dart';

class AddProductSales extends StatefulWidget {
  const AddProductSales({super.key});

  static const String routeName = '/add_product_sales';

  @override
  State<AddProductSales> createState() => _State();
}

class _State extends State<AddProductSales> {
  TextEditingController idController = TextEditingController();
  var orderController = TextEditingController(text: "No").obs;
  Rxn<FirmModel> firmNameController = Rxn<FirmModel>();
  TextEditingController firmNameTextController = TextEditingController();
  Rxn<LedgerModel> customerName = Rxn<LedgerModel>();
  TextEditingController customerNameTextController = TextEditingController();
  TextEditingController billNoController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  Rxn<LedgerModel> accountType = Rxn<LedgerModel>();

  TextEditingController accountTypeTextController = TextEditingController();
  TextEditingController lrNoController = TextEditingController();
  TextEditingController lrDateController = TextEditingController();

  // if order is yes use Rxn value
  Rxn<ProductOrderDetailsModel> orderNoController =
      Rxn<ProductOrderDetailsModel>();
  TextEditingController orderNoText = TextEditingController();

  TextEditingController transportTextController = TextEditingController();
  Rxn<VehicleDetailsModel> transportController = Rxn<VehicleDetailsModel>();
  TextEditingController freightController =
      TextEditingController(text: "ToPay");
  TextEditingController noOfBagsController = TextEditingController(text: "0");
  TextEditingController detailsController = TextEditingController();

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

  final FocusNode _accountTypeFocusNode = FocusNode();
  final FocusNode _firmFocusNode = FocusNode();
  final FocusNode _orderFocusNode = FocusNode();
  final FocusNode _customerFocusNode = FocusNode();
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _transportFocusNode = FocusNode();
  final FocusNode _freightFocusNode = FocusNode();

  final DataGridController _dataGridController = DataGridController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var shortCut = RxString("");

  int? al1ano;
  int? al2ano;
  int? al3ano;
  int? al4ano;

  final _formKey = GlobalKey<FormState>();

  late ProductSalesItemDataSource dataSource;
  ProductSaleController controller = Get.find();
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
    controller.getBackBoolean.value = false;
    controller.itemList.clear();
    _initValue();
    super.initState();
    dataSource = ProductSalesItemDataSource(list: controller.itemList);
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_dateFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductSaleController>(builder: (controller) {
      return ShortCutWidget(
        scaffoldKey: _scaffoldKey,
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Product Sale"),
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
              visible: idController.text.isNotEmpty,
              child: MyPrintButton(
                onPressed: () => controller.printDialog(idController.text, getBack: false),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        endDrawer: Container(
          color: Colors.white10.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Drawer(
                width: 520,
                child: ProductSalesBottomSheet(
                  dataSource: dataSource,
                  amount: amount,
                  taxCalculation: calculateAmount,
                ),
              ),
            ],
          ),
        ),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyP, control: true):
              PrintIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
          SingleActivator(LogicalKeyboardKey.keyR, control: true):
              RemoveIntent(),
          SingleActivator(LogicalKeyboardKey.keyN, control: true):
              AddNewIntent(),
        },
        child: WillPopScope(
          onWillPop: () async {
            getBackAlert();
            return false;
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              GetBackIntent: SetCounterAction(perform: () =>  getBackAlert()),
              SaveIntent: SetCounterAction(perform: () => submit()),
              PrintIntent: SetCounterAction(
                  perform: () => controller.printDialog(idController.text, getBack: false)),
              NavigateIntent:
                  SetCounterAction(perform: () => navigateAnotherPage()),
              RemoveIntent:
                  SetCounterAction(perform: () => removeSelectedItems()),
              AddNewIntent: SetCounterAction(perform: () => _addItem()),
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
                              autofocus: false,
                              label: 'Account',
                              items: controller.accountDropdown,
                              textController: accountTypeTextController,
                              focusNode: _accountTypeFocusNode,
                              requestFocus: _firmFocusNode,
                              onChanged: (LedgerModel item) {
                                accountType.value = item;
                              },
                            ),
                            MySearchField(
                              autofocus: false,
                              label: 'Firm',
                              items: controller.firmName,
                              textController: firmNameTextController,
                              focusNode: _firmFocusNode,
                              requestFocus: _customerFocusNode,
                              onChanged: (FirmModel item) {
                                firmNameController.value = item;
                              },
                            ),
                            Obx(
                              () => MySearchField(
                                width: 300,
                                label: 'Customer Name',
                                items: controller.customerDropdown,
                                textController: customerNameTextController,
                                focusNode: _customerFocusNode,
                                requestFocus: _orderFocusNode,
                                enabled: !isUpdate.value,
                                onChanged: (LedgerModel item) async {
                                  customerName.value = item;
                                  orderController.value.text = "No";
                                  controller.customerId = item.id;
                                  isVisible.value = false;
                                  controllerClear();
                                  var list =
                                      await controller.taxFixing('Product Sales');
                                  _taxDialog(list);
                                },
                              ),
                            ),
                            Obx(
                              () => MyDropdownButtonFormField(
                                focusNode: _orderFocusNode,
                                width: 160,
                                controller: orderController.value,
                                enabled: !isUpdate.value,
                                hintText: "Order",
                                items: const ["No", "Yes"],
                                onChanged: (value) {
                                  controllerClear();
                                  if (value == "Yes") {
                                    isVisible.value = true;
                                    int id = customerName.value!.id!;
                                    controller.orderNoDetailsInfo(id);
                                  } else {
                                    isVisible.value = false;
                                    controller.orderDetails.clear();
                                  }
                                },
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
                                  enabled: !isUpdate.value,
                                  autofocus: false,
                                  onChanged:
                                      (ProductOrderDetailsModel item) async {
                                    orderNoController.value = item;
                                    String? orderNo = item.orderNo;
                                    controller.itemList.clear();
                                    dataSource.updateDataGridRows();
                                    dataSource.updateDataGridSource();

                                    var result = await controller
                                        .oderNiByDetails(orderNo!);

                                    for (var e in result) {
                                      controller.itemList.add({
                                        "product_name": e["product_name"],
                                        "product_id": e["product_id"],
                                        "qty": e["order_quantity"],
                                        "rate": e["rate"],
                                        "amount": e["amount"],
                                        "discount": e["discount"],
                                        "discount_per": e["discount_per"],
                                        "details": e["details"],
                                      });
                                    }
                                    amountCalculation();
                                    dataSource.updateDataGridRows();
                                    dataSource.updateDataGridSource();
                                  },
                                ),
                              ),
                            ),
                            Visibility(
                              visible: billNoController.text.isNotEmpty,
                              child: MyTextField(
                                controller: billNoController,
                                hintText: "Bill No",
                                enabled: false,
                              ),
                            ),
                            MyDateFilter(
                              focusNode: _dateFocusNode,
                              width: 160,
                              controller: dateController,
                              labelText: 'Date',
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
                        Obx(
                          () => Visibility(
                            visible: !isVisible.value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MyAddItemsRemoveButton(
                                    onPressed: () => removeSelectedItems()),
                                const SizedBox(width: 12),
                                AddItemsElevatedButton(
                                  onPressed: () => _addItem(),
                                  child: const Text('Add Item'),
                                ),
                              ],
                            ),
                          ),
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
                            Obx(() => Text(shortCut.value,
                                style: AppUtils.shortCutTextStyle())),
                            const SizedBox(width: 12),
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
        ),
      );
    });
  }

  shortCutKeys() {
    if (_accountTypeFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Account',Press Alt+C ";
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
    }
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "sa_ano": accountType.value?.id,
        "firm_id": firmNameController.value?.id,
        "customer_id": customerName.value?.id,
        "e_date": dateController.text,
        "order": orderController.value.text,
        "transport": transportTextController.text,
        "freight": freightController.text,
        "details": detailsController.text,
        "lr_no": lrNoController.text,
        "lr_date": lrDateController.text,
        "no_of_bags": int.tryParse(noOfBagsController.text) ?? 0,
      };

      request["order_no"] = orderNoController.value?.orderNo;

      request['product_sale_details'] = controller.itemList;

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
        request['bill_no'] = int.tryParse(billNoController.text);
        controller.edit(request, id);
      }
    }
  }

  void _initValue() {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");

    var firm = AppUtils.setDefaultFirmName(controller.firmName);
    if (firm != null) {
      firmNameController.value = firm;
      firmNameTextController.text = firm.firmName ?? "";
    }
    var account = AppUtils.findLedgerAccountByName(
        controller.accountDropdown, 'Product Sales Account');
    if (account != null) {
      accountType.value = account;
      accountTypeTextController.text = account.ledgerName ?? "";
    }

    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = ProductSaleModel.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      dateController.text = '${item.eDate}';
      billNoController.text = "${item.billNo}";
      transportTextController.text = tryCast(item.transport);
      detailsController.text = tryCast(item.details);
      freightController.text = "${item.freight}";
      lrNoController.text = item.lrNo ?? "";
      lrDateController.text = item.lrDate ?? "";
      noOfBagsController.text = "${item.noOfBags ?? "0"}";

      orderController.value.text = "${item.order}";
      if (item.order == "Yes") {
        isVisible.value = true;
        orderNoController.value =
            ProductOrderDetailsModel(orderNo: item.orderNo!);
      } else {
        isVisible.value = false;
      }

      var firmList = controller.firmName
          .where((element) => '${element.id}' == '${item.firmId}')
          .toList();
      if (firmList.isNotEmpty) {
        firmNameController.value = firmList.first;
        firmNameTextController.text = "${firmList.first.firmName}";
      }
      var customerNameList = controller.customerDropdown
          .where((element) => '${element.id}' == '${item.customerId}')
          .toList();
      if (customerNameList.isNotEmpty) {
        customerName.value = customerNameList.first;
        customerNameTextController.text =
            "${customerNameList.first.ledgerName}";
      }
      var accountList = controller.accountDropdown
          .where((element) => '${element.id}' == '${item.saAno}')
          .toList();
      if (accountList.isNotEmpty) {
        accountType.value = accountList.first;
        accountTypeTextController.text = "${accountList.first.ledgerName}";
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

      item.productSaleDetails?.forEach((element) {
        amount.value += double.tryParse("${element.amount}") ?? 0.0;
        var result = element.toJson();
        controller.itemList.add(result);
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
      al2AccountNoController.text = tryCast(item.al2AnoName);
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
          columnName: 'discount_per',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Discount ( % )'),
        ),
        GridColumn(
          width: 150,
          columnName: 'discount',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Discount ( RS. )'),
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
      source: dataSource,
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
    for (var element in controller.itemList) {
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
    if (isVisible.value == true) {
      return;
    }

    int? index = _dataGridController.selectedIndex;
    if (index >= 0) {
      controller.itemList.removeAt(index);
      amountCalculation();
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
      _dataGridController.selectedIndex = -1;
    } else {
      AppUtils.infoAlert(message: "Select The Value");
    }
  }

  _addItem() {
    if (isVisible.value == true) {
      return;
    }
    _scaffoldKey.currentState!.openEndDrawer();
  }

  controllerClear() {
    controller.itemList.clear();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
  }

  getBackAlert() async {
    if (controller.getBackBoolean.value == true) {
      await AppUtils.showExitDialog(context) == true ? submit() : '';
    } else {
      Get.back();
    }
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
        DataGridCell<dynamic>(columnName: 'discount_per', value: e['discount_per']),
        DataGridCell<dynamic>(columnName: 'discount', value: e['discount']),
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
        case 'discount':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'discount_per':
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
      case 'discount':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      case 'discount_per':
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
