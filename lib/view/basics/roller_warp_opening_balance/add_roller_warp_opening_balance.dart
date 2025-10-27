import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/roller_warp_opening_balance_model.dart';
import 'package:abtxt/view/basics/ledger/addledger.dart';
import 'package:abtxt/view/basics/roller_warp_opening_balance/roller_warp_opening_balance_item_bottomsheet.dart';
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
import '../../adjustments/alternative_warp_design/alternative_warp_design_list.dart';
import 'roller_warp_opening_balance_controller.dart';

class AddRollerWarpOpeningBalance extends StatefulWidget {
  const AddRollerWarpOpeningBalance({Key? key}) : super(key: key);
  static const String routeName = '/add_roller_warp';

  @override
  State<AddRollerWarpOpeningBalance> createState() => _State();
}

class _State extends State<AddRollerWarpOpeningBalance> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> rollernameDropdown = Rxn<LedgerModel>();
  TextEditingController rollerNameController = TextEditingController();
  TextEditingController recordNoController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController productQtyController = TextEditingController();
  TextEditingController totalmeterController = TextEditingController();
  TextEditingController totalbeamController = TextEditingController();
  TextEditingController totalbobbinController = TextEditingController();
  TextEditingController totalsheetController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // var rollerList = <dynamic>[].obs;

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
    return GetBuilder<RollerWarpOpeningBalanceController>(
        builder: (controller) {
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
                "${idController.text == '' ? 'Add' : 'Update'} Roller Warp Opening Balance"),
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
                                //
                                // Dropdown API
                                MyDialogList(
                                  labelText: 'Roller Name',
                                  controller: rollerNameController,
                                  list: controller.ledger_dropdown,
                                  showCreateNew: true,
                                  onItemSelected: (LedgerModel item) {
                                    rollerNameController.text =
                                        '${item.ledgerName}';
                                    rollernameDropdown.value = item;
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
                                    onPressed: () {
                                      submit();
                                    },
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
      RollerWarpOpeningBalanceController controller = Get.find();
      Map<String, dynamic> request = {
        "roller_id": rollernameDropdown.value?.id,
        "record_no": recordNoController.text,
        "details": detailController.text,
      };
      for (var i = 0; i < itemList.length; i++) {
        request['warp_design_id[$i]'] = itemList[i]['warp_design_id'];
        request['warp_design_name[$i]'] = itemList[i]['warp_design_name'];
        request['warp_id_no[$i]'] = itemList[i]['warp_id_no'];
        request['product_qty[$i]'] = itemList[i]['product_qty'];
        request['meter[$i]'] = itemList[i]['meter'];
        request['delivered_empty[$i]'] = itemList[i]['delivered_empty'];
        request['empty_qty[$i]'] = itemList[i]['empty_qty'];
        request['sheet[$i]'] = itemList[i]['sheet'];
        request['warp_colour[$i]'] = itemList[i]['warp_colour'];
      }
      var id = idController.text;
      if (id.isEmpty) {
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.add(requestPayload);
      } else {
        request['id'] = id;
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.edit(requestPayload, id);
      }
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      RollerWarpOpeningBalanceController controller = Get.find();
      RollerWarpOpeningBalanceModel ledger = Get.arguments['item'];
      idController.text = '${ledger.id}';

      var rollerId = controller.ledger_dropdown
          .where((element) => '${element.id}' == '${ledger.rollerId}')
          .toList();
      if (rollerId.isNotEmpty) {
        rollernameDropdown.value = rollerId.first;
        rollerNameController.text = '${rollerId.first.ledgerName}';
      }

      detailController.text = '${ledger.details}';
      recordNoController.text = '${ledger.recordNo}';
      ledger.itemDetails?.forEach((element) {
        // var request = {
        //   "warp_design_id": "${element.warpDesignId}",
        //   "warp_design_name": "${element.warpDesignName}",
        //   "warp_id_no": "${element.warpIdNo}",
        //   "product_qty": "${element.productQty}",
        //   "meter": "${element.meter}",
        //   "delivered_empty": "${element.deliveredEmpty}",
        //   "empty_qty": "${element.emptyQty}",
        //   "sheet": "${element.sheet}",
        //   "warp_colour": "${element.warpColour}",
        // };
        var request = element.toJson();
        itemList.add(request);
      });
    }
   // initTotal();
  }

  // void initTotal() {
  //   double meterTotal = 0.0;
  //   double productqtyTotal = 0.0;
  //   double sheetTotal = 0.0;
  //   double beamTotal = 0.0;
  //   double bobbinTotal = 0.0;
  //
  //   for (var i = 0; i < itemList.length; i++) {
  //     meterTotal += double.tryParse(itemList[i]['meter']) ?? 0.0;
  //     productqtyTotal += double.tryParse(itemList[i]['product_qty']) ?? 0.0;
  //
  //     sheetTotal += double.tryParse(itemList[i]['sheet']) ?? 0.0;
  //     if (itemList[i]["delivered_empty"] == "Beam") {
  //       beamTotal += double.tryParse(itemList[i]['empty_qty']) ?? 0.0;
  //     }
  //     if (itemList[i]["delivered_empty"] == "Bobbin") {
  //       bobbinTotal += double.tryParse(itemList[i]['empty_qty']) ?? 0.0;
  //     }
  //   }
  //
  //   totalmeterController.text = '$meterTotal';
  //   productQtyController.text = '$productqtyTotal';
  //   totalsheetController.text = '$sheetTotal';
  //   totalbeamController.text = '$beamTotal';
  //   totalbobbinController.text = '$bobbinTotal';
  // }

  Widget ItemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'warp_design_name',
          label: const MyDataGridHeader(title: 'Warp Design'),
        ),
        GridColumn(
          columnName: 'warp_id_no',
          label: const MyDataGridHeader(title: 'Warp ID No'),
        ),
        GridColumn(
          columnName: 'product_qty',
          label: const MyDataGridHeader(title: 'Product Qty'),
        ),
        GridColumn(
          columnName: 'meter',
          label: const MyDataGridHeader(title: 'Meter'),
        ),
        GridColumn(
          columnName: 'delivered_empty',
          label: const MyDataGridHeader(title: 'Beam'),
        ),
        GridColumn(
          columnName: 'empty_qty',
          label: const MyDataGridHeader(title: 'Bobbin'),
        ),
        GridColumn(
          columnName: 'sheet',
          label: const MyDataGridHeader(title: 'Sheet'),
        ),
        GridColumn(
          columnName: 'warp_colour',
          label: const MyDataGridHeader(title: 'Warp Color'),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'product_qty',
              columnName: 'product_qty',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'meter',
              columnName: 'meter',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'delivered_empty',
              columnName: 'delivered_empty',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'empty_qty',
              columnName: 'empty_qty',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'sheet',
              columnName: 'sheet',
              summaryType: GridSummaryType.sum,
            ),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSource,
      onRowSelected: (index) async {
        var item = itemList[index];
        var result = await Get.to(
            const RollerWarpOpeningBalanceItemBottomSheet(),
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
    var result = await Get.to(RollerWarpOpeningBalanceItemBottomSheet());
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
            columnName: 'warp_design_name', value: e['warp_design_name']),
        DataGridCell<dynamic>(columnName: 'warp_id_no', value: e['warp_id_no']),
        DataGridCell<dynamic>(
            columnName: 'product_qty', value: e['product_qty']),
        DataGridCell<dynamic>(columnName: 'meter', value: e['meter']),
        DataGridCell<dynamic>(
            columnName: 'delivered_empty', value: e['delivered_empty']),
        DataGridCell<dynamic>(columnName: 'empty_qty', value: e['empty_qty']),
        DataGridCell<dynamic>(columnName: 'sheet', value: e['sheet']),
        DataGridCell<dynamic>(
            columnName: 'warp_colour', value: e['warp_colour']),
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
