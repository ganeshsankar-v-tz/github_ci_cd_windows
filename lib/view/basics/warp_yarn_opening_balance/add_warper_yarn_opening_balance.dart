import 'package:abtxt/model/warper_yarn_opening_balance_model.dart';
import 'package:abtxt/view/basics/ledger/addledger.dart';
import 'package:abtxt/view/basics/warp_yarn_opening_balance/warp_yarn_bottom_sheet.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/CountTextField.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../adjustments/yarn_stock_adjustment/add_yarn_stock_.dart';
import 'warp_yarn_opening_balance_controller.dart';

class AddWarperYarnOpeningBalance extends StatefulWidget {
  const AddWarperYarnOpeningBalance({Key? key}) : super(key: key);
  static const String routeName = '/add_warp_yarn_opening';

  @override
  State<AddWarperYarnOpeningBalance> createState() => _State();
}

class _State extends State<AddWarperYarnOpeningBalance> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> warperNameDropdown = Rxn<LedgerModel>();
  TextEditingController warperNameController = TextEditingController();
  TextEditingController recordNoController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController totalPackController = TextEditingController();
  TextEditingController totalQtyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late WarpYarnOpeningBalanceController controller;

  // var warpList = <dynamic>[].obs;

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
    return GetBuilder<WarpYarnOpeningBalanceController>(builder: (controller) {
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
                "${idController.text == '' ? 'Add' : 'Update'} Warp yarn Opening Balance"),
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
                                  labelText: 'Warper Name',
                                  controller: warperNameController,
                                  list: controller.ledger_dropdown,
                                  showCreateNew: true,
                                  onItemSelected: (LedgerModel item) {
                                    warperNameController.text =
                                        '${item.ledgerName}';
                                    warperNameDropdown.value = item;
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
                                  validate: "number",
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
                                const SizedBox(width: 16),
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
        "warper_id": warperNameDropdown.value?.id,
        "record_no": recordNoController.text,
        "details": detailController.text,
      };
      dynamic totalPack = 0;
      dynamic totalQuantity = 0;

      for (var i = 0; i < itemList.length; i++) {
        request['yarn_id[$i]'] = itemList[i]['yarn_id'];
        request['colour_id[$i]'] = itemList[i]['colour_id'];
        request['pack[$i]'] = itemList[i]['pack'];
        request['quantity[$i]'] = itemList[i]['quantity'];

        // totalPack += itemList[i]['pack'];
        // totalQuantity += itemList[i]['quantity'];
      }
      request['total_pack'] = totalPack;
      request['total_qty'] = totalQuantity;

      print(request);
      var id = idController.text;
      if (id.isEmpty) {
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.addwarp(requestPayload);
      } else {
        request['id'] = id;
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.updatewarp(requestPayload, id);
      }

      print(request);
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      WarpYarnOpeningBalanceController controller = Get.find();
      WarpYarnOpeningBalanceModel dyerWarp = Get.arguments['item'];
      idController.text = '${dyerWarp.id}';

      recordNoController.text = '${dyerWarp.recordNo}';
      detailController.text = '${dyerWarp.details}';

      var warperName = controller.ledger_dropdown
          .where((element) => '${element.id}' == '${dyerWarp.warperId}')
          .toList();
      if (warperName.isNotEmpty) {
        warperNameDropdown.value = warperName.first;
        warperNameController.text = '${warperName.first.ledgerName}';
      }

      dyerWarp.itemDetails?.forEach((element) {
        // var request = {
        //   "yarn_id": "${element.yarnId}",
        //   "yarn_name": "${element.yarnName}",
        //   "colour_id": "${element.colourId}",
        //   "color_name": "${element.colorName}",
        //   "pack": "${element.pack}",
        //   "quantity": "${element.quantity}",
        // };
        var request = element.toJson();
        itemList.add(request);
      });
    }
    // initTotal();
  }

  // void initTotal() {
  //   double packTotal = 0.0;
  //   double qtyTotal = 0.0;
  //
  //   for (var i = 0; i < itemList.length; i++) {
  //     packTotal += double.tryParse(itemList[i]['pack']) ?? 0.0;
  //     qtyTotal += double.tryParse(itemList[i]['quantity']) ?? 0.0;
  //
  //   }
  //
  //   totalQtyController.text = '$qtyTotal';
  //   totalPackController.text = '$packTotal';
  // }

  Widget ItemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'yarn_name',
          label: const MyDataGridHeader(title: 'Yarn Name'),
        ),
        GridColumn(
          columnName: 'color_name',
          label: const MyDataGridHeader(title: 'Color'),
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
        var result = await Get.to(const WarpYarnBottomSheet(),
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
    var result = await Get.to(WarpYarnBottomSheet());
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
