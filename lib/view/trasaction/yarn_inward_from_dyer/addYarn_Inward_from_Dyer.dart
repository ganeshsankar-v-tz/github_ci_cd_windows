import 'package:abtxt/model/YarnInwardFromDyer.dart';
import 'package:abtxt/view/trasaction/yarn_inward_from_dyer/yarn_inward_from_dyer_bottom_sheet.dart';
import 'package:abtxt/view/trasaction/yarn_inward_from_dyer/yarn_inward_from_dyer_controller.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/AccountTypeModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/CountTextField.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyDropdownSearch.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';

class addYarn_Inward_from_Dyer extends StatefulWidget {
  const addYarn_Inward_from_Dyer({Key? key}) : super(key: key);
  static const String routeName = '/addYarn_Inward_from_Dyer';

  @override
  State<addYarn_Inward_from_Dyer> createState() => _State();
}

class _State extends State<addYarn_Inward_from_Dyer> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> nameController = Rxn<LedgerModel>();
  TextEditingController dyerNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController referenceNoController = TextEditingController();
  Rxn<AccountTypeModel> wagesAccountController = Rxn<AccountTypeModel>();
  TextEditingController wagesController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController totalPackController = TextEditingController();
  TextEditingController totalNetQytController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late YarnInwardFromDyerController controller;
  // var yarnInwardFromDyerList = <dynamic>[].obs;



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
    return GetBuilder<YarnInwardFromDyerController>(builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
          KeyAction(
            LogicalKeyboardKey.keyA,
            'Add', () => _addItem(),
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
                "${idController.text == '' ? 'Add' : 'Update'} Yarn Inward from Dyer"),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(

                border: Border.all(color:  Color(0xFFF9F3FF)),
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
                                    validate: "",
                                    enabled: false,
                                  ),
                                ),

                                MyAutoComplete(
                                  label: 'Dyer Name',
                                  items: controller.DyerName,
                                  selectedItem: nameController.value,
                                  onChanged: (LedgerModel item) {
                                    nameController.value = item;
                                    //  _firmNameFocusNode.requestFocus();
                                  },
                                ),
                                /*MyDialogList(
                                  labelText: 'Dyer Name',
                                  controller: dyerNameController,
                                  list: controller.DyerName,
                                  showCreateNew: false,
                                  onItemSelected: (LedgerModel item) {
                                    dyerNameController.text =
                                    '${item.ledgerName}';
                                    nameController.value = item;
                                    // controller.request['group_name'] = item.id;
                                  },
                                  onCreateNew: (value) async {

                                  },
                                ),*/
                                MyTextField(
                                  controller: referenceNoController,
                                  hintText: "Reference No",
                                  validate: "string",
                                ),
                                MyDateField(
                                  controller: dateController,
                                  hintText: "Entry Date",
                                  validate: "string",
                                  readonly: true,
                                ),
                                MyAutoComplete(
                                  label: 'Wages Account',
                                  items: controller.Account,
                                  selectedItem: wagesAccountController.value,
                                  onChanged: (AccountTypeModel item) {
                                    wagesAccountController.value = item;
                                    //  _firmNameFocusNode.requestFocus();
                                  },
                                ),
                                /*MyDialogList(
                                  labelText: 'Wages Account',
                                  controller: wagesController,
                                  list: controller.Account,
                                  showCreateNew: false,
                                  onItemSelected: (AccountTypeModel item) {
                                    wagesController.text =
                                    '${item.name}';
                                    wagesAccountController.value = item;
                                    // controller.request['group_name'] = item.id;
                                  },
                                  onCreateNew: (value) async {
                                  },
                                ),*/
                                MyTextField(
                                  controller: detailsController,
                                  hintText: "Details ",
                                  validate: "String",
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
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
                            const SizedBox(
                              height: 20,
                            ),
                            ItemsTable(),
                            const SizedBox(height: 40),
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
        "dyer_id": nameController.value?.id,
        "reference_no": referenceNoController.text,
        "entry_date": dateController.text,
        "account_type_id": wagesAccountController.value?.id,
        "details": detailsController.text ?? '',
      };

      var yarnInwardFromList = [];
      dynamic quantityTotal = 0;
      dynamic packTotal = 0;
      double totalAmountTotal = 0;

      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "yarn_id": itemList[i]['yarn_id'],
          "yarn_balance": itemList[i]['yarn_balance'],
          "color_id": itemList[i]['color_id'],
          "yarn_order_balance": itemList[i]['yarn_order_balance'],
          "stock_no": itemList[i]['stock_no'],
          "bag_box_no": itemList[i]['bag_box_no'],
          "pack": itemList[i]['pack'],
          "quantity": itemList[i]['quantity'],
          "less": itemList[i]['less'],
          "net_qty": itemList[i]['net_qty'],
          "calculate_type": itemList[i]['calculate_type'],
          "wages": itemList[i]['wages'],
          "amount": itemList[i]['amount'],
        };

        // quantityTotal +=
        //     itemList[i]['quantity'];
        // totalAmountTotal +=
        //     itemList[i]['amount'];
        // packTotal +=itemList[i]['pack'];

        yarnInwardFromList.add(item);
      }
      request['total_amount'] = totalAmountTotal;
      request['total_quantity'] = quantityTotal;
      request['total_pack'] = packTotal;
      request['winder_item'] = yarnInwardFromList;

      print(request);
      var id = idController.text;
      if (id.isEmpty) {
        controller.addYarnInwardfromDyer(request);
      } else {
        request['id'] = id;
        controller.updateYarninward(request, id);
      }

      print(request);
    }
  }

  void _initValue() {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    YarnInwardFromDyerController controller = Get.find();

    if (Get.arguments != null) {
      YarnInwardFromDyerController controller = Get.find();
      YarnInwardFromDyerModel YarnInward = Get.arguments['item'];
      idController.text = '${YarnInward.id}';
      dateController.text = '${YarnInward.entryDate}';
      referenceNoController.text = '${YarnInward.referenceNo}';
      detailsController.text = '${YarnInward.details}';
      // DyerName
      var dyerNameList = controller.DyerName.where(
          (element) => '${element.id}' == '${YarnInward.dyerId}').toList();
      if (dyerNameList.isNotEmpty) {
        nameController.value = dyerNameList.first;
        dyerNameController.text='${dyerNameList.first.ledgerName}';
        //   WagesAccount

        var wageslist = controller.Account.where(
                (element) => '${element.id}' == '${YarnInward.accountTypeId}')
            .toList();
        if (wageslist.isNotEmpty) {
          wagesAccountController.value = wageslist.first;
          wagesController.text='${wageslist.first.name}';

        }
        YarnInward.itemDetails?.forEach((element) {
          // var request = {
          //   "yarn_name": "${element.yarnName}",
          //   "yarn_id": "${element.yarnId}",
          //   "color_name": "${element.colorName}",
          //   "color_id": "${element.colorId}",
          //   "stock_no": "${element.stockNo}",
          //   "bag_box_no": "${element.bagBoxNo}",
          //   "pack": "${element.pack}",
          //   "quantity": "${element.quantity}",
          //   "calculate_type": "${element.calculateType}",
          //   "wages": "${element.wages}",
          //   "amount": "${element.amount}",
          //   "yarn_balance": "${element.yarnBalance}",
          //   "yarn_order_balance": "${element.yarnOrderBalance}",
          //   "less": "${element.less}",
          //   "net_qty": "${element.netQty}",
          // };
          var request = element.toJson();
          itemList.add(request);
        });
      }
    }
  }

  Widget ItemsTable() {
    return MySFDataGridItemTable(
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
          columnName: 'stock_no',
          label: const MyDataGridHeader(title: 'Stock to'),
        ),
        GridColumn(
          columnName: 'bag_box_no',
          label: const MyDataGridHeader(title: 'Bag / Box No'),
        ),
        GridColumn(
          columnName: 'pack',
          label: const MyDataGridHeader(title: 'Pack'),
        ),
        GridColumn(
          columnName: 'quantity',
          label: const MyDataGridHeader(title: 'Quantity'),
        ),
        GridColumn(
          columnName: 'calculate_type',
          label: const MyDataGridHeader(title: 'Calculate Type'),
        ),
        GridColumn(
          columnName: 'wages',
          label: const MyDataGridHeader(title: 'Wages (Rs)'),
        ),
        GridColumn(
          columnName: 'amount',
          label: const MyDataGridHeader(title: 'Total Amount (Rs)'),
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
            const GridSummaryColumn(
              name: 'pack',
              columnName: 'pack',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'quantity',
              columnName: 'quantity',
              summaryType: GridSummaryType.sum,
            ),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSource,
      onRowSelected: (index) async {
        var item = itemList[index];
        var result = await Get.to(const YarnInwardFromDyerBottomSheet(),
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
    var result = await Get.to(YarnInwardFromDyerBottomSheet());
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
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e['yarn_name']),
        DataGridCell<dynamic>(columnName: 'color_name', value: e['color_name']),
        DataGridCell<dynamic>(columnName: 'stock_no', value: e['stock_no']),
        DataGridCell<dynamic>(columnName: 'bag_box_no', value: e['bag_box_no']),
        DataGridCell<dynamic>(columnName: 'pack', value: e['pack']),
        DataGridCell<dynamic>(columnName: 'quantity', value: e['quantity']),
        DataGridCell<dynamic>(columnName: 'calculate_type', value: e['calculate_type']),
        DataGridCell<dynamic>(columnName: 'wages', value: e['wages']),
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
