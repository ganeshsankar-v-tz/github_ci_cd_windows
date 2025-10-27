import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/YarnModel.dart';
import 'package:abtxt/model/dyer_order_opening_balance_model.dart';
import 'package:abtxt/view/basics/dyer_order_opening_balance/dyer_order_opening_balance_bottomsheeet.dart';
import 'package:abtxt/view/basics/ledger/addledger.dart';
import 'package:abtxt/view/basics/yarn/add_yarn.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import 'dyer_order_opening_balance_controller.dart';

class AddDyerOrderOpeningBalance extends StatefulWidget {
  const AddDyerOrderOpeningBalance({Key? key}) : super(key: key);
  static const String routeName = '/add_dyer_order';

  @override
  State<AddDyerOrderOpeningBalance> createState() => _State();
}

class _State extends State<AddDyerOrderOpeningBalance> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> dyerName = Rxn<LedgerModel>();
  TextEditingController dyerNameController = TextEditingController();
  Rxn<YarnModel> yarnName = Rxn<YarnModel>();
  TextEditingController yarnNameController = TextEditingController();
  TextEditingController recordNoController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController totalPackController = TextEditingController();
  TextEditingController totalQtyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late DyerOrderOpeningBalanceController controller;
  // var dyerOrderList = <dynamic>[].obs;

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
    return GetBuilder<DyerOrderOpeningBalanceController>(builder: (controller) {
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
          backgroundColor: const Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Dyer Order Opening Balance"),
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
                                  labelText: 'Dyer Name',
                                  controller: dyerNameController,
                                  list: controller.ledger_dropdown,
                                  showCreateNew: true,
                                  onItemSelected: (LedgerModel item) {
                                    dyerNameController.text =
                                        '${item.ledgerName}';
                                    dyerName.value = item;
                                    // controller.request['group_name'] = item.id;
                                  },
                                  onCreateNew: (value) async {
                                    //supplier.value = null;
                                    var item =
                                        await Get.toNamed(AddLedger.routeName);
                                    controller.onInit();
                                  },
                                ),
                                MyDialogList(
                                  labelText: 'Yarn Name',
                                  controller: yarnNameController,
                                  list: controller.yarn_dropdown,
                                  showCreateNew: true,
                                  onItemSelected: (YarnModel item) {
                                    yarnNameController.text = '${item.name}';
                                    yarnName.value = item;
                                    // controller.request['group_name'] = item.id;
                                  },
                                  onCreateNew: (value) async {
                                    //supplier.value = null;
                                    var item =
                                        await Get.toNamed(AddYarn.routeName);
                                    controller.onInit();
                                  },
                                ),
                                MyTextField(
                                  controller: recordNoController,
                                  hintText: "Record No",
                                  validate: "string",
                                ),
                                MyTextField(
                                  controller: detailController,
                                  hintText: "Details",
                                  validate: "string",
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
                                    width: 200,
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
        "dyer_id": dyerName.value?.id,
        "yarn_id": yarnName.value?.id,
        "record_no": recordNoController.text,
        "details": detailController.text,
      };
      var openStockList = [];
      dynamic total = 0;
      dynamic totalPack = 0;
      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "colour_id": itemList[i]['colour_id'],
          "pack": itemList[i]['pack'],
          "quantity": itemList[i]['quantity'],
        };
        // total +=itemList[i]['quantity'];
        // totalPack += itemList[i]['pack'];
        openStockList.add(item);
      }
      request['pack_total'] = totalPack;
      request['qty_total'] = total;
      request['open_stock'] = openStockList;
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
    if (Get.arguments != null) {
      DyerOrderOpeningBalanceController controller = Get.find();
      DyerOrderOpeningBalanceModel dyerOrder = Get.arguments['item'];
      idController.text = '${dyerOrder.id}';
      recordNoController.text = '${dyerOrder.recordNo}';
      detailController.text = '${dyerOrder.details}';
      var dyerList = controller.ledger_dropdown
          .where((element) => '${element.id}' == '${dyerOrder.dyerId}')
          .toList();
      if (dyerList.isNotEmpty) {
        dyerName.value = dyerList.first;
        dyerNameController.text = '${dyerList.first.ledgerName}';
      }
      var yarnList = controller.yarn_dropdown
          .where((element) => '${element.id}' == '${dyerOrder.yarnId}')
          .toList();
      if (yarnList.isNotEmpty) {
        yarnName.value = yarnList.first;
        yarnNameController.text = '${yarnList.first.name}';
      }
      dyerOrder.itemDetails?.forEach((element) {
        var request = {
          "color_name": "${element.colorName}",
          "colour_id": "${element.colourId}",
          "pack": "${element.pack}",
          "quantity": "${element.quantity}",
        };
        itemList.add(request);
      });
    }
    initTotal();
  }

  void initTotal() {
    double packTotal = 0.0;
    double qtyTotal = 0.0;

    for (var i = 0; i < itemList.length; i++) {
      packTotal += double.tryParse(itemList[i]['pack']) ?? 0.0;
      qtyTotal += double.tryParse(itemList[i]['quantity']) ?? 0.0;
    }

    totalQtyController.text = '$qtyTotal';
    totalPackController.text = '$packTotal';
  }

  Widget ItemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'color_name',
          label: const MyDataGridHeader(title: 'Color Name'),
        ),
        GridColumn(
          columnName: 'pack',
          label: const MyDataGridHeader(title: 'Pack'),
        ),
        GridColumn(
          columnName: 'quantity',
          label: const MyDataGridHeader(title: 'Quantity'),
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
        var result = await Get.to(const DyerOrderOpeningBalanceBottomSheet(),
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
    var result = await Get.to(DyerOrderOpeningBalanceBottomSheet());
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
        DataGridCell<dynamic>(columnName: 'color_name', value: e['color_name']),
        DataGridCell<dynamic>(columnName: 'pack', value: e['pack']),
        DataGridCell<dynamic>(columnName: 'quantity', value: e['quantity']),
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
