import 'package:abtxt/model/AccountTypeModel.dart';
import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/RetailSaleModel.dart';
import 'package:abtxt/utils/constant.dart';
import 'package:abtxt/view/basics/ledger/addledger.dart';
import 'package:abtxt/view/trasaction/retail_sale/retail_sale_bottomsheeet.dart';
import 'package:abtxt/view/trasaction/retail_sale/retail_sale_controller.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/CountTextField.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../basics/account/add_account.dart';
import '../../basics/firm/add_firm.dart';

class AddRetailSale extends StatefulWidget {
  const AddRetailSale({Key? key}) : super(key: key);
  static const String routeName = '/add_retail_sale';

  @override
  State<AddRetailSale> createState() => _State();
}

class _State extends State<AddRetailSale> {
  TextEditingController idController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  TextEditingController firmController = TextEditingController();
  Rxn<LedgerModel> customer = Rxn<LedgerModel>();
  TextEditingController customerController = TextEditingController();
  TextEditingController salesNoController = TextEditingController();
  TextEditingController salesDate = TextEditingController();
  Rxn<AccountTypeModel> salesAc = Rxn<AccountTypeModel>();
  TextEditingController salesAcController = TextEditingController();
  TextEditingController cashBankAc = TextEditingController();
  TextEditingController cellNo = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController totalQuantityController = TextEditingController();
  TextEditingController totalRateController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late RetailSaleController controller;
//  var dyerOrderList = <dynamic>[].obs;

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
    return GetBuilder<RetailSaleController>(builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
          KeyAction(
            LogicalKeyboardKey.keyN,
            'Add', () => _addItem(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title:
                Text("${idController.text == '' ? 'Add' : 'Update'} Retail Sale"),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
              ),
              //height: Get.height,
              margin: const EdgeInsets.all(16),
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
                                MyDialogList(
                                  labelText: 'Firm',
                                  controller: firmController,
                                  list: controller.firmDropdown,
                                  showCreateNew: true,
                                  onItemSelected: (FirmModel item) {
                                    firmController.text = '${item.firmName}';
                                    firmName.value = item;
                                  },
                                  onCreateNew: (value) async {
                                    var item =
                                        await Get.toNamed(AddFirm.routeName);
                                    controller.onInit();
                                  },
                                ),
                                MyDialogList(
                                  labelText: 'Customer',
                                  controller: customerController,
                                  list: controller.ledgerDropdown,
                                  showCreateNew: true,
                                  onItemSelected: (LedgerModel item) {
                                    customerController.text =
                                        '${item.ledgerName}';
                                    customer.value = item;
                                  },
                                  onCreateNew: (value) async {
                                    var item =
                                        await Get.toNamed(AddLedger.routeName);
                                    controller.onInit();
                                  },
                                ),
                                MyTextField(
                                  controller: salesNoController,
                                  hintText: "Sales No",
                                  validate: "string",
                                ),
                                MyDateField(
                                  controller: salesDate,
                                  hintText: "Sales Date",
                                  validate: "string",
                                  readonly: true,
                                ),
                                MyDialogList(
                                  labelText: 'Account Type',
                                  controller: salesAcController,
                                  list: controller.accountDropdown,
                                  showCreateNew: true,
                                  onItemSelected: (AccountTypeModel item) {
                                    salesAcController.text = '${item.name}';
                                    salesAc.value = item;
                                  },
                                  onCreateNew: (value) async {
                                    var item =
                                        await Get.toNamed(AddAccount.routeName);
                                    controller.onInit();
                                  },
                                ),
                                MyDropdownButtonFormField(
                                    controller: cashBankAc,
                                    hintText: "Cash / Bank A/c",
                                    items: Constants.cashBank),
                                MyTextField(
                                  controller: cellNo,
                                  hintText: "Cell No",
                                  validate: "string",
                                ),
                                MyTextField(
                                  controller: email,
                                  hintText: "Email",
                                  validate: "string",
                                ),
                                MyTextField(
                                  controller: address,
                                  hintText: "Address",
                                  validate: "string",
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Align(
                            //   alignment: Alignment.bottomRight,
                            //   child: AddItemsElevatedButton(
                            //     width: 135,
                            //     onPressed: () async {
                            //       var result = await dyerOrderItemDialog();
                            //       print("result: ${result.toString()}");
                            //       if (result != null) {
                            //         dyerOrderList.add(result);
                            //         initTotal();
                            //       }
                            //     },
                            //     child: const Text('Add Item'),
                            //   ),
                            // ),
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
                            const SizedBox(height: 20),
                            // dyerOrderItems(),
                            itemsTable(),
                            const SizedBox(height: 12),
                            // Row(
                            //   // mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     Expanded(child: Container()),
                            //     // Padding(padding: EdgeInsets.only(left: 670)),
                            //     SizedBox(
                            //       width: 170,
                            //       child: CountTextField(
                            //         controller: totalQuantityController,
                            //         hintText: "Total Quantity",
                            //         readonly: true,
                            //         suffix: const Text('Saree',
                            //             style:
                            //                 TextStyle(color: Color(0xFF5700BC))),
                            //       ),
                            //     ),
                            //     // Padding(padding: EdgeInsets.only(left: 50)),
                            //     SizedBox(
                            //       width: 170,
                            //       child: CountTextField(
                            //         controller: totalRateController,
                            //         hintText: "Total Rate",
                            //         readonly: true,
                            //       ),
                            //     ),
                            //     // Padding(padding: EdgeInsets.only(left: 60)),
                            //     SizedBox(
                            //       width: 170,
                            //       child: CountTextField(
                            //         controller: totalAmountController,
                            //         hintText: "Total Amount",
                            //         readonly: true,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Wrap(
                                spacing: 16,
                                children: [
                                  MyCloseButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Close'),
                                  ),
                                  MyElevatedButton(
                                    onPressed: () => submit(),
                                    child: Text(
                                      Get.arguments == null ? 'Save' : 'Update',
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
      );
    });
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "firm_id": firmName.value?.id,
        "customer_id": customer.value?.id,
        "sales_no": salesNoController.text,
        "sales_date": salesDate.text,
        "account_type_id": salesAc.value?.id,
        "cash": cashBankAc.text,
        "cell_no": cellNo.text,
        "email_id": email.text,
        "address": address.text,
        "net_total_amount": 234,
        "discount": "Rs",
        "discount_rate": 23,
        "discount_amount": 32,
        "transport": "Rs",
        "transport_rate": 32,
        "transport_amount": 32,
      };
      var productItemLIst = [];
      dynamic qtyTotal = 0;
      double rateTotal = 0;
      double amountTotal = 0;

      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "product_id": itemList[i]['product_id'],
          "design_no": itemList[i]['design_no'],
          "work_details": itemList[i]['work_details'],
          "work": itemList[i]['work'],
          "qty": itemList[i]['qty'],
          "rate": itemList[i]['rate'],
          "amount": itemList[i]['amount'],
        };
        // qtyTotal += itemList[i]['qty'];
        // rateTotal += itemList[i]['rate'];
        // amountTotal += itemList[i]['amount'];
        productItemLIst.add(item);
      }
      request['total_qty'] = qtyTotal;
      request['total_rate'] = rateTotal;
      request['total_amount'] = amountTotal;
      request['product_item'] = productItemLIst;
      var id = idController.text;
      if (id.isEmpty) {
        controller.add(request);
      } else {
        request['id'] = id;
        controller.edit(request, id);
      }
    }
  }

  void _initValue() {
    cashBankAc.text = Constants.cashBank[0];

    if (Get.arguments != null) {
      RetailSaleController controller = Get.find();
      RetailSaleModel dyerOrder = Get.arguments['item'];
      idController.text = '${dyerOrder.id}';
      salesNoController.text = '${dyerOrder.salesNo}';
      salesDate.text = '${dyerOrder.salesDate}';
      cashBankAc.text = '${dyerOrder.cash}';
      cellNo.text = '${dyerOrder.cellNo}';
      email.text = '${dyerOrder.emailId}';
      address.text = '${dyerOrder.address}';

      var firmList = controller.firmDropdown
          .where((element) => '${element.id}' == '${dyerOrder.firmId}')
          .toList();
      if (firmList.isNotEmpty) {
        firmName.value = firmList.first;
        firmController.text = '${firmList.first.firmName}';
      }
      var customerList = controller.ledgerDropdown
          .where((element) => '${element.id}' == '${dyerOrder.customerId}')
          .toList();
      if (customerList.isNotEmpty) {
        customer.value = customerList.first;
        customerController.text = '${customerList.first.ledgerName}';
      }
      var salesAcList = controller.accountDropdown
          .where((element) => '${element.id}' == '${dyerOrder.accountTypeId}')
          .toList();
      if (salesAcList.isNotEmpty) {
        salesAc.value = salesAcList.first;
        salesAcController.text = '${salesAcList.first.name}';
      }
      dyerOrder.itemDetails?.forEach((element) {
        // var request = {
        //   "product_id": "${element.productId}",
        //   "product_name": "${element.productName}",
        //   "design_no": "${element.designNo}",
        //   "work_details": "${element.workDetails}",
        //   "work": "${element.work}",
        //   "qty": "${element.qty}",
        //   "rate": "${element.rate}",
        //   "amount": "${element.amount}",
        // };
        var request = element.toJson();
        itemList.add(request);
      });
    }
    // initTotal();
  }

  // void initTotal() {
  //   double amountTotal = 0.0;
  //   double rateTotal = 0.0;
  //   dynamic qtyTotal = 0;
  //   for (var i = 0; i < itemList.length; i++) {
  //     amountTotal += double.tryParse(itemList[i]['amount']) ?? 0.0;
  //     rateTotal += int.tryParse(itemList[i]['rate']) ?? 0;
  //     qtyTotal += int.tryParse(itemList[i]['qty']) ?? 0;
  //   }
  //   totalAmountController.text = '$amountTotal';
  //   totalQuantityController.text = '$qtyTotal';
  //   totalRateController.text = '$rateTotal';
  // }


  Widget itemsTable() {
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
          columnName: 'work',
          label: const MyDataGridHeader(title: 'Work'),
        ),
        GridColumn(
          columnName: 'qty',
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
              name: 'qty',
              columnName: 'qty',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'rate',
              columnName: 'rate',
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
        var result = await Get.to(const RetailSaleBottomSheet(),
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

  void _addItem() async {
    var result = await Get.to(RetailSaleBottomSheet());
    if (result != null) {
      itemList.add(result);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
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
            columnName: 'product_name', value: e['product_name']),
        DataGridCell<dynamic>(columnName: 'design_no', value: e['design_no']),
        DataGridCell<dynamic>(columnName: 'work', value: e['work']),
        DataGridCell<dynamic>(columnName: 'qty', value: e['qty']),
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
