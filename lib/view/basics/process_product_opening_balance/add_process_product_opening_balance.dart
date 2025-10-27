import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/process_product_opening_balance_model.dart';
import 'package:abtxt/view/basics/ledger/addledger.dart';
import 'package:abtxt/view/basics/process_product_opening_balance/process_product_opening_balance_item_bottomsheet.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../widgets/CountTextField.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import 'process_product_opening_balance_controller.dart';

class AddProcessProductOpeningBalance extends StatefulWidget {
  const AddProcessProductOpeningBalance({Key? key}) : super(key: key);
  static const String routeName = '/add_process_product';

  @override
  State<AddProcessProductOpeningBalance> createState() => _State();
}

class _State extends State<AddProcessProductOpeningBalance> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> processorName = Rxn<LedgerModel>();
  TextEditingController processorNameController = TextEditingController();
  TextEditingController recordNoController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController totalQtyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late ProcessProductOpeningBalanceController controller;
  // var processProductList = <dynamic>[].obs;



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
    return GetBuilder<ProcessProductOpeningBalanceController>(
        builder: (controller) {
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
          KeyAction(
            LogicalKeyboardKey.keyA,
            'Add',
                () =>  Get.toNamed(AddLedger.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Process Product Opening Balance"),
            centerTitle: false,
            actions: [
              Visibility(
                visible: false,
                child: ElevatedButton(
                  onPressed: () async {
                    var item = await Get.toNamed(AddLedger.routeName);
                    dataSource.notifyListeners();
                  }, child: Text('Add'),
                  // <-- Text
                ),
              ),
            ],
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
                                  labelText: 'Processor',
                                  controller: processorNameController,
                                  list: controller.ledgerDropdown,
                                  showCreateNew: true,
                                  onItemSelected: (LedgerModel item) {
                                    processorNameController.text =
                                    '${item.ledgerName}';
                                    processorName.value = item;
                                    // controller.request['group_name'] = item.id;
                                  },
                                  onCreateNew: (value) async {
                                    //supplier.value = null;
                                    var item =
                                    await Get.toNamed(AddLedger.routeName);
                                    controller.onInit();
                                  },
                                ),

                                MyTextField(
                                  controller: recordNoController,
                                  hintText: "Record No",
                                  validate: "String",
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
                                    onPressed: () => submit(),
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
        "processor_id": processorName.value?.id,
        "record_no": recordNoController.text,
        "details": detailController.text,
      };
      dynamic totalQuantity = 0;
      for (var i = 0; i < itemList.length; i++) {
        request['product_id[$i]'] = itemList[i]['product_id'];
        request['product_name[$i]'] = itemList[i]['product_name'];
        request['design_no[$i]'] = itemList[i]['design_no'];
        request['work_type[$i]'] = itemList[i]['work_type'];
        request['pcs[$i]'] = itemList[i]['pcs'];
        request['quantity[$i]'] = itemList[i]['quantity'];
        // totalQuantity += itemList[i]['quantity'];
      }
      request['total_qty'] = totalQuantity;
      print(request);
      var id = idController.text;
      if (id.isEmpty) {
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.add(requestPayload);
      } else {
        // request['id'] = '$id';
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.edit(requestPayload, id);
      }

      print(request);
    }
  }

  void _initValue() {
    ProcessProductOpeningBalanceController controller = Get.find();

    if (Get.arguments != null) {
      ProcessProductOpeningBalanceModel ledger = Get.arguments['item'];
      idController.text = '${ledger.id}';

      var processId = controller.ledgerDropdown
          .where((element) => '${element.id}' == '${ledger.processorId}')
          .toList();
      if (processId.isNotEmpty) {
        processorName.value = processId.first;
        processorNameController.text= '${processId.first.ledgerName}';
      }

      recordNoController.text = '${ledger.recordNo}';
      detailController.text = '${ledger.details}';

      ledger.itemDetails?.forEach((element) {
        // var request = {
        //   "product_id": "${element.productId}",
        //   "product_name": "${element.productName}",
        //   "design_no": "${element.designNo}",
        //   "work_type": "${element.workType}",
        //   "pcs": "${element.pcs}",
        //   "quantity": "${element.quantity}",
        // };
        var request = element.toJson();
        itemList.add(request);
      });
    }
   // initTotalQty();
  }

  // void initTotalQty() {
  //   var totalQty = 0;
  //   for (var i = 0; i < itemList.length; i++) {
  //     totalQty += int.tryParse(itemList[i]['quantity']) ?? 0;
  //   }
  //   totalQtyController.text = '$totalQty';
  // }

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
          columnName: 'work_type',
          label: const MyDataGridHeader(title: 'Work Type'),
        ),
        GridColumn(
          columnName: 'pcs',
          label: const MyDataGridHeader(title: 'Pieces'),
        ),
        GridColumn(
          columnName: 'quantity',
          label: const MyDataGridHeader(title: 'Quantity (saree)'),
        ),

      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
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
        var result = await Get.to(const ProcessProductOpeningBalanceItemBottomSheet(),
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
    var result = await Get.to(ProcessProductOpeningBalanceItemBottomSheet());
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
        DataGridCell<dynamic>(columnName: 'product_name', value: e['product_name']),
        DataGridCell<dynamic>(columnName: 'design_no', value: e['design_no']),
        DataGridCell<dynamic>(columnName: 'work_type', value: e['work_type']),
        DataGridCell<dynamic>(columnName: 'pcs', value: e['pcs']),
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
