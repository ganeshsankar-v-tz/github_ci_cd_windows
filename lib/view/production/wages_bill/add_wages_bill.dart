import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/production/wages_bill/wages_bill_bottomsheet.dart';
import 'package:abtxt/view/production/wages_bill/wages_bill_controller.dart';
import 'package:abtxt/view/production/wages_bill/wages_bill_goods_details_bottomsheet.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/LedgerModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';

class AddWagesBill extends StatefulWidget {
  const AddWagesBill({Key? key}) : super(key: key);
  static const String routeName = '/add_wages_bill';

  @override
  State<AddWagesBill> createState() => _State();
}

class _State extends State<AddWagesBill> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> weaverName = Rxn<LedgerModel>();
  TextEditingController dateController = TextEditingController();
  TextEditingController challanNoController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController addLessAmountController = TextEditingController();
  TextEditingController totalWagesController = TextEditingController(text: '0');
  TextEditingController debitController = TextEditingController(text: '0');
  TextEditingController paidController = TextEditingController(text: '0');
  TextEditingController balanceController = TextEditingController(text: '0');

  final _formKey = GlobalKey<FormState>();
  final WagesbillController controller = Get.find();

  var goodsInwardItemList = <dynamic>[];
  var paymentItemList = <dynamic>[];
  late GoodsInwardDataSource dataSourceGoodsInward;
  late PaymentDataSource dataSourcePayment;

  @override
  void initState() {
    _initValue();
    super.initState();
    dataSourceGoodsInward = GoodsInwardDataSource(list: goodsInwardItemList);
    dataSourcePayment = PaymentDataSource(list: paymentItemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WagesbillController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: Text("${idController.text == '' ? 'Add' : 'Update'} Wages Bill"),
        ),
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
              submit(),
        },
        loadingStatus: controller.status.isLoading,
        child: SingleChildScrollView(
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
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Column(
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
                                        Obx(
                                          () => MyAutoComplete(
                                            label: 'Weaver Name',
                                            items: controller.weaverList,
                                            selectedItem: weaverName.value,
                                            onChanged:
                                                (LedgerModel item) async {
                                              weaverName.value = item;

                                              /// Advance Amount Api Call
                                              controller
                                                  .advAmountDetails(item.id);

                                              /// Good Inward Api Call
                                              controller
                                                  .goodsInwardDetails(item.id);
                                            },
                                          ),
                                        ),
                                        MyDateField(
                                          controller: dateController,
                                          hintText: "Date",
                                          validate: "string",
                                          readonly: true,
                                        ),
                                        Wrap(
                                          children: [
                                            MyTextField(
                                              controller: challanNoController,
                                              hintText: "No",
                                              readonly: true,
                                              enabled: false,
                                            ),
                                            MyTextField(
                                              controller: detailsController,
                                              hintText: "Details",
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 0.5),
                                      ),
                                      child: DataTable(
                                        columns: const [
                                          DataColumn(
                                              label: Text('Particulars')),
                                          DataColumn(label: Text('Balance')),
                                        ],
                                        rows: controller.advDetails.map(
                                          (e) {
                                            return DataRow(
                                              cells: [
                                                DataCell(
                                                    Text('${e.ledgerName}')),
                                                DataCell(
                                                    Text('${e.balanceAmount}')),
                                              ],
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        AddItemsElevatedButton(
                                          onPressed: () =>
                                              _addItemGoodsInward(),
                                          child: const Text('Add Item'),
                                        ),
                                        ItemListDiologue1(),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: AddItemsElevatedButton(
                                            onPressed: () async =>
                                                _addItemPayment(),
                                            child: const Text('Add Item'),
                                          ),
                                        ),
                                        ItemListDiologue2(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MyTextField(
                                controller: totalWagesController,
                                hintText: 'Total Wages',
                                readonly: true,
                              ),
                              MyTextField(
                                  controller: debitController,
                                  hintText: 'Debit',
                                  readonly: true),
                              MyTextField(
                                  controller: paidController,
                                  hintText: 'Paid',
                                  readonly: true),
                              MyTextField(
                                  controller: balanceController,
                                  hintText: 'Balance',
                                  readonly: true),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MyElevatedButton(
                                onPressed: () => submit(),
                                child: Text(
                                    Get.arguments == null ? 'Save' : 'Update'),
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
      );
    });
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "weaver_id": weaverName.value?.id,
        "e_date": dateController.text,
      };
      request["goods_inward_details"] = goodsInwardItemList;
      var debitList = [];
      var paymentList = [];

      for (var e in paymentItemList) {
        if (e["entry_type"] == "Debit") {
          debitList.add(e);
        } else {
          paymentList.add(e);
        }
      }
      request['debit_list'] = debitList;
      request['payment_list'] = paymentList;

      var id = idController.text;
      if (id.isEmpty) {
        controller.add(request);
      }
    }
  }

  void _initValue() async {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    controller.advDetails.clear();

    if (Get.arguments != null) {
      var obj = Get.arguments['item'];
      var challanNo = obj['challan_no'];
      var accountId = obj["account_no"];
      var item = await controller.challanNoByDetails(challanNo, accountId);

      dateController.text = "${item.eDate}";
      challanNoController.text = "${item.challanNo}";
      var weaverList = controller.weaverList
          .where((element) => '${element.id}' == '${item.weaverId}')
          .toList();
      if (weaverList.isNotEmpty) {
        weaverName.value = weaverList.first;
        controller.advAmountDetails(item.weaverId);
      }

      /// Amount Calculation
      double amount = 0;
      double debit = 0;
      double paid = 0;
      double balance = 0;

      /// Update The Goods Inward Details In Item Table
      item.goodInwardDetails?.forEach((element) {
        var result = element.toJson();

        goodsInwardItemList.add(result);
        dataSourceGoodsInward.updateDataGridRows();
        dataSourceGoodsInward.updateDataGridSource();
      });

      /// Update The Payment Details In Item Table
      item.wagesBillDetails?.forEach((element) {
        double wages = double.tryParse("${element.debit}") ?? 0;
        amount += wages;
        var entryType = element.entryType;

        if (entryType == "Debit") {
          debit += wages;
        } else {
          paid += wages;
        }

        balance = amount - (debit + paid);
        var result = element.toJson();
        paymentItemList.add(result);
        dataSourcePayment.updateDataGridRows();
        dataSourcePayment.updateDataGridSource();
      });
      totalWagesController.text = "$amount";
      debitController.text = "$debit";
      paidController.text = "$paid";
      balanceController.text = "$balance";
    }
  }

  Widget ItemListDiologue1() {
    return MySFDataGridItemTable(
      scrollPhysics: const AlwaysScrollableScrollPhysics(),
      shrinkWrapRows: false,
      columns: [
        GridColumn(
          width: 100,
          columnName: 'e_date',
          label: const MyDataGridHeader(title: 'Date'),
        ),
        GridColumn(
          columnName: 'challan_no',
          label: const MyDataGridHeader(title: 'Slip No'),
        ),
        GridColumn(
          columnName: 'inward_qty',
          label: const MyDataGridHeader(title: 'Qty'),
        ),
        GridColumn(
          columnName: 'inward_meter',
          label: const MyDataGridHeader(title: 'Mtr/Yrds'),
        ),
        GridColumn(
          width: 150,
          columnName: 'credit',
          label: const MyDataGridHeader(title: 'Wages(Rs.)'),
        ),
        GridColumn(
          width: 150,
          columnName: 'paid',
          label: const MyDataGridHeader(title: 'Paid(Rs.)'),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'inward_qty',
              columnName: 'inward_qty',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'inward_meter',
              columnName: 'inward_meter',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'credit',
              columnName: 'credit',
              summaryType: GridSummaryType.sum,
            ),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSourceGoodsInward,
    );
  }

  Widget ItemListDiologue2() {
    return MySFDataGridItemTable(
      scrollPhysics: const AlwaysScrollableScrollPhysics(),
      shrinkWrapRows: false,
      columns: [
        GridColumn(
          width: 150,
          columnName: 'entry_type',
          label: const MyDataGridHeader(title: 'Entry Type'),
        ),
        GridColumn(
          width: 100,
          columnName: 'e_date',
          label: const MyDataGridHeader(title: 'Date'),
        ),
        GridColumn(
          columnName: 'pr_ledger_name',
          label: const MyDataGridHeader(title: ' '),
        ),
        GridColumn(
          width: 150,
          columnName: 'amount',
          label: const MyDataGridHeader(title: ' '),
        ),
        GridColumn(
          width: 150,
          columnName: 'debit',
          label: const MyDataGridHeader(title: 'Paid(Rs.)'),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'debit',
              columnName: 'debit',
              summaryType: GridSummaryType.sum,
            ),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSourcePayment,
    );
  }

  void _addItemGoodsInward() async {
    if (weaverName.value == null) {
      return;
    }
    List<dynamic> result =
        await Get.to(const WagesBillGoodsDetailsBottomSheet());

    int? challanNo;
    for (var e in result) {
      challanNo = e["challan_no"];
    }

    var exists = _checkChallanNoAlreadyExits(challanNo);

    if (!exists && result.isNotEmpty) {
      goodsInwardItemList.addAll(result);

      /// Goods Inward Selected Amount Total Calculation
      double totalAmount = 0.0;
      double addLessAmount = 0.0;
      for (var e in goodsInwardItemList) {
        totalAmount += e["credit"];
      }

      double netTotal = totalAmount + addLessAmount;

      controller.balanceAmount = totalAmount;
      totalWagesController.text = "$netTotal";
      balanceController.text = "$totalAmount";
      addLessAmountController.text = "$addLessAmount";

      dataSourceGoodsInward.updateDataGridRows();
      dataSourceGoodsInward.updateDataGridSource();
    } else {
      AppUtils.showErrorToast(message: "The selected Slip No already exists!");
    }
  }

  _checkChallanNoAlreadyExits(challanNo) {
    var exists = goodsInwardItemList
        .any((element) => element['challan_no'] == challanNo);
    return exists;
  }

  void _addItemPayment() async {
    if (goodsInwardItemList.isEmpty) {
      return;
    }

    if (controller.balanceAmount <= 0) {
      return;
    }

    var result = await Get.to(const WagesBillBottomSheet());
    if (result != null) {
      paymentItemList.add(result);

      ///  Paid Amount Calculation
      double totalAmount = double.tryParse(totalWagesController.text) ?? 0.00;
      double debitAmount = 0;
      double paidAmount = 0;
      for (var e in paymentItemList) {
        var entryType = e["entry_type"];
        if (entryType == "Payment") {
          paidAmount += e["debit"];
        } else {
          debitAmount += e["debit"];
        }
      }

      dataSourcePayment.updateDataGridRows();
      dataSourcePayment.updateDataGridSource();

      double balance = totalAmount - (debitAmount + paidAmount);
      controller.balanceAmount = balance;
      balanceController.text = "$balance";
      debitController.text = "$debitAmount";
      paidController.text = "$paidAmount";
    }
  }
}

class GoodsInwardDataSource extends DataGridSource {
  GoodsInwardDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'e_date', value: e['e_date'] ?? ''),
        DataGridCell<dynamic>(columnName: 'challan_no', value: e['challan_no']),
        DataGridCell<dynamic>(columnName: 'inward_qty', value: e['inward_qty']),
        DataGridCell<dynamic>(
            columnName: 'inward_meter', value: e['inward_meter']),
        DataGridCell<dynamic>(columnName: 'credit', value: e['credit']),
        const DataGridCell<dynamic>(columnName: 'paid', value: ""),
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

class PaymentDataSource extends DataGridSource {
  PaymentDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var particulars = "";
      particulars = "${e["pr_ledger_name"]} ${e["product_details"] ?? ''}";

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'entry_type', value: e["entry_type"]),
        DataGridCell<dynamic>(columnName: 'e_date', value: e['e_date'] ?? ''),
        DataGridCell<dynamic>(columnName: 'pr_ledger_name', value: particulars),
        const DataGridCell<dynamic>(columnName: 'amount', value: ""),
        DataGridCell<dynamic>(columnName: 'debit', value: e['debit']),
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
