import 'package:abtxt/model/AccountTypeModel.dart';
import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/LedgerRole.dart';
import 'package:abtxt/model/ledger_opening_balance_model.dart';
import 'package:abtxt/view/basics/ledger_opening_balance/ledger_opening_balance_bottomsheet.dart';
import 'package:abtxt/view/basics/ledger_opening_balance/ledger_opening_balance_controller.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDateField.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';

class AddLedgerOpeningBalance extends StatefulWidget {
  const AddLedgerOpeningBalance({Key? key}) : super(key: key);
  static const String routeName = '/AddLedgerOpeningBalance';

  @override
  State<AddLedgerOpeningBalance> createState() => _State();
}

class _State extends State<AddLedgerOpeningBalance> {
  TextEditingController idController = TextEditingController();
  Rxn<FirmModel> firmname = Rxn<FirmModel>();
  TextEditingController firmNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  Rxn<LedgerRole> rolename = Rxn<LedgerRole>();
  TextEditingController roleNameController = TextEditingController();
  Rxn<LedgerModel> ledgername = Rxn<LedgerModel>();
  TextEditingController ledgerNameController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController totalamountController = TextEditingController();
  Rxn<AccountTypeModel> accountname = Rxn<AccountTypeModel>();
  TextEditingController accountNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late LedgerOpeningBalanceController controller;
  // var LedgerOpeningBalanceList = <dynamic>[].obs;

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
    return GetBuilder<LedgerOpeningBalanceController>(builder: (controller) {
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
            LogicalKeyboardKey.keyN,
            'Add',
            () => _addItem(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Ledger Opening Balance"),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
              ),
              //height: Get.height,
              margin: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        //color: Colors.green,
                        padding: EdgeInsets.all(16),
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
                                    validate: "Select",
                                    enabled: false,
                                  ),
                                ),
                                //Dropdown Api Call

                                MyDialogList(
                                  labelText: 'Firm',
                                  controller: firmNameController,
                                  list: controller.firm_dropdown,
                                  showCreateNew: false,
                                  onItemSelected: (FirmModel item) {
                                    firmNameController.text =
                                        '${item.firmName}';
                                    firmname.value = item;
                                    // controller.request['group_name'] = item.id;
                                  },
                                  onCreateNew: (value) async {},
                                ),
                                MyDateField(
                                  controller: dateController,
                                  hintText: "Date",
                                  validate: "string",
                                  readonly: true,
                                ),
                                //Dropdown Api Call

                                MyDialogList(
                                  labelText: 'Role',
                                  controller: roleNameController,
                                  list: controller.role_dropdown,
                                  showCreateNew: false,
                                  onItemSelected: (LedgerRole item) {
                                    roleNameController.text = '${item.name}';
                                    rolename.value = item;
                                    // controller.request['group_name'] = item.id;
                                  },
                                  onCreateNew: (value) async {},
                                ),
                                MyDialogList(
                                  labelText: 'Ledger Name',
                                  controller: ledgerNameController,
                                  list: controller.ledger_dropdown,
                                  showCreateNew: false,
                                  onItemSelected: (LedgerModel item) {
                                    ledgerNameController.text =
                                        '${item.ledgerName}';
                                    ledgername.value = item;
                                    // controller.request['group_name'] = item.id;
                                  },
                                  onCreateNew: (value) async {},
                                ),
                                //Dropdown Api Call
                                MyTextField(
                                  controller: placeController,
                                  hintText: "Place",
                                  validate: "string",
                                ),
                                MyDialogList(
                                  labelText: 'Account Type',
                                  controller: accountNameController,
                                  list: controller.account_dropdown,
                                  showCreateNew: false,
                                  onItemSelected: (AccountTypeModel item) {
                                    accountNameController.text = '${item.name}';
                                    accountname.value = item;
                                    // controller.request['group_name'] = item.id;
                                  },
                                  onCreateNew: (value) async {},
                                ),
                              ],
                            ),
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
                            const SizedBox(height: 20),
                            ItemsTable(),
                            SizedBox(
                              height: 10,
                            ),
                            const SizedBox(height: 48),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MyCloseButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Close'),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 200,
                                  child: MyElevatedButton(
                                    onPressed: () {
                                      submit();
                                    },
                                    child: Text(Get.arguments == null
                                        ? 'Save'
                                        : 'Update'),
                                  ),
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
      );
    });
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "firm_id": firmname.value?.id,
        "date": dateController.text,
        "role_id": rolename.value?.id,
        "ledger_id": ledgername.value?.id,
        "place": placeController.text,
        "account_type": accountname.value?.id,
      };
      var ledgerOpeningList = [];
      double total = 0.0;
      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "amount": itemList[i]['amount'],
          "amount_type": itemList[i]['amount_type'],
          "type": itemList[i]['type'],
          "details": itemList[i]['details'],
        };
        // total += itemList[i]['amount'];
        // ledgerOpeningList.add(item);
      }
      request['total_amount'] = total;
      request['ledger_item'] = ledgerOpeningList;

      print(request);

      var id = idController.text;

      if (id.isEmpty) {
        controller.addledgerOpeningBalance(request);
      } else {
        request['id'] = id;
        controller.updateledgerOpening(request, id);
      }

      print(request);
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      LedgerOpeningBalanceController controller = Get.find();
      LedgerOpeningBalanceModel ledgerOpening = Get.arguments['item'];
      idController.text = '${ledgerOpening.id}';
      dateController.text = '${ledgerOpening.date}';
      placeController.text = '${ledgerOpening.place}';

      var firmName = controller.firm_dropdown
          .where((element) => '${element.id}' == '${ledgerOpening.firmId}')
          .toList();
      if (firmName.isNotEmpty) {
        firmname.value = firmName.first;
        firmNameController.text = '${firmName.first.firmName}';
      }

      var roleName = controller.role_dropdown
          .where((element) => '${element.id}' == '${ledgerOpening.roleId}')
          .toList();
      if (roleName.isNotEmpty) {
        rolename.value = roleName.first;
        roleNameController.text = '${roleName.first.name}';
      }

      var ledgerName = controller.ledger_dropdown
          .where((element) => '${element.id}' == '${ledgerOpening.ledgerId}')
          .toList();
      if (ledgerName.isNotEmpty) {
        ledgername.value = ledgerName.first;
        ledgerNameController.text = '${ledgerName.first.ledgerName}';
      }

      var accountName = controller.account_dropdown
          .where((element) => '${element.id}' == '${ledgerOpening.accountType}')
          .toList();
      if (accountName.isNotEmpty) {
        accountname.value = accountName.first;
        accountNameController.text = '${accountName.first.name}';
      }

      ledgerOpening.ledgerOpenDetails?.forEach((element) {
        var request = {
          "amount": "${element.amount}",
          "amount_type": "${element.amountType}",
          "type": "${element.type}",
          "details": "${element.details}",
        };
        itemList.add(request);
      });
    }
    initTotal();
  }

  void initTotal() {
    double Totalamount = 0.0;
    for (var i = 0; i < itemList.length; i++) {
      Totalamount += double.tryParse(itemList[i]['amount']) ?? 0.0;
    }
    totalamountController.text = '$Totalamount';
  }

  Widget ItemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'amount',
          label: const MyDataGridHeader(title: 'Amount (RS)'),
        ),
        GridColumn(
          columnName: 'amount_type',
          label: const MyDataGridHeader(title: 'Amount Type'),
        ),
        GridColumn(
          columnName: 'type',
          label: const MyDataGridHeader(title: 'Type'),
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
        var result = await Get.to(const LedgerOpeningBalanceModelBottomSheet(),
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
    var result = await Get.to(LedgerOpeningBalanceModelBottomSheet());
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
        DataGridCell<dynamic>(columnName: 'amount', value: e['amount']),
        DataGridCell<dynamic>(
            columnName: 'amount_type', value: e['amount_type']),
        DataGridCell<dynamic>(columnName: 'type', value: e['type']),
        DataGridCell<dynamic>(columnName: 'details', value: e['details']),
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
