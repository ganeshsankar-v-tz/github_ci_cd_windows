import 'package:abtxt/model/dyer_warp_opening_balance_model.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/view/basics/dyer_warp_opening_balance/dyer_warp_bottom_sheeet.dart';
import 'package:abtxt/view/basics/ledger/addledger.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
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
import '../../adjustments/yarn_stock_adjustment/add_yarn_stock_.dart';
import 'dyer_warp_opening_balance_controller.dart';

class AddDyerWarpOpeningBalance extends StatefulWidget {
  const AddDyerWarpOpeningBalance({Key? key}) : super(key: key);
  static const String routeName = '/add_dyer_warp_opening';

  @override
  State<AddDyerWarpOpeningBalance> createState() => _State();
}

class _State extends State<AddDyerWarpOpeningBalance> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> dyerWarpName = Rxn<LedgerModel>();
  TextEditingController dyerNameController = TextEditingController();
  TextEditingController recordNoController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController productqtyController = TextEditingController();
  TextEditingController meterTotalController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late DyerWarpOpeningBalanceController controller;

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
    return GetBuilder<DyerWarpOpeningBalanceController>(builder: (controller) {
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
                "${idController.text == '' ? 'Add' : 'Update'} Dyer Warp Opening Balance"),
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
                                //drop down
                                MyDialogList(
                                  labelText: 'Dyer Name',
                                  controller: dyerNameController,
                                  list: controller.ledger_dropdown,
                                  showCreateNew: true,
                                  onItemSelected: (LedgerModel item) {
                                    dyerNameController.text = '${item.ledgerName}';
                                    dyerWarpName.value = item;
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
                                    child: Text(
                                        "${Get.arguments == null ? 'Save' : 'Update'}"),
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
         "dyer_id": dyerWarpName.value?.id,
        //"dyer_name": dyerWarpName.value?.name,
        "record_no": recordNoController.text,
        "details": detailController.text,
      };
      dynamic totalMeter = 0;
      dynamic totalProductQty = 0;

      for (var i = 0; i < itemList.length; i++) {
        request['warp_design_id[$i]'] = itemList[i]['warp_design_id'];
        request['warp_type[$i]'] = itemList[i]['warp_type'];
        request['product_qty[$i]'] = itemList[i]['product_qty'];
        request['colour_to_dye[$i]'] = itemList[i]['colour_to_dye'];
        request['meter[$i]'] = itemList[i]['meter'];

        // totalProductQty += itemList[i]['product_qty'];
        // totalMeter += itemList[i]['meter'];
      }
      request['total_product_qty'] = totalProductQty;
      request['total_meter'] = totalMeter;

      var id = idController.text;
      if (id.isEmpty) {
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.add(requestPayload);
      } else {
        request['id'] = '$id';
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.edit(requestPayload, id);
      }
    }
  }

  void _initValue() {
    DyerWarpOpeningBalanceController controller = Get.find();

    if (Get.arguments != null) {
      DyerWarpOpeningBalanceController controller = Get.find();
      DyerWarpOpeningBalanceModel item = Get.arguments['item'];
      idController.text = '${item.id}';
      recordNoController.text = '${item.recordNo}';
      detailController.text = '${item.details}';

      var dyerList = controller.ledger_dropdown
          .where((element) => '${element.id}' == '${item.dyerId}')
          .toList();
      if (dyerList.isNotEmpty) {
        dyerWarpName.value = dyerList.first;
        dyerNameController.text = '${dyerList.first.ledgerName}';
      }
      item.itemDetails?.forEach((element) {
        /*var request = {
          "designName": "${element.warpDesignName}",
          "warp_design_id": "${element.warpDesignId}",
          "warp_type": "${element.warpType}",
          "product_qty": "${element.productQty}",
          "colour_to_dye": "${element.colourToDye}",
          "meter": "${element.meter}",
        };*/
        var request = element.toJson();
        itemList.add(request);
      });
    }
   // initTotal();
  }

  /*void initTotal() {
    double meterTotal = 0.0;
    double productqtyTotal = 0.0;

    for (var i = 0; i < itemList.length; i++) {
      meterTotal += double.tryParse(itemList[i]['meter']) ?? 0.0;
      productqtyTotal += double.tryParse(itemList[i]['product_qty']) ?? 0.0;
    }

    productqtyController.text = '$productqtyTotal';
    meterTotalController.text = '$meterTotal';
  }*/

  Widget ItemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'designName',
          label: const MyDataGridHeader(title: 'Warp Design'),
        ),
        GridColumn(
          columnName: 'warp_type',
          label: const MyDataGridHeader(title: 'Warp Type'),
        ),
        GridColumn(
          columnName: 'product_qty',
          label: const MyDataGridHeader(title: 'Product Qty'),
        ),
        GridColumn(
          columnName: 'meter',
          label: const MyDataGridHeader(title: 'Color to Dye'),
        ),
        GridColumn(
          columnName: 'colour_to_dye',
          label: const MyDataGridHeader(title: 'Meter'),
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
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSource,
      onRowSelected: (index) async {
        var item = itemList[index];
        var result = await Get.to(const DyerWarpBottomSheet(),
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
    var result = await Get.to(DyerWarpBottomSheet());
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
        DataGridCell<dynamic>(columnName: 'designName', value: e['designName']),
        DataGridCell<dynamic>(columnName: 'warp_type', value: e['warp_type']),
        DataGridCell<dynamic>(
            columnName: 'product_qty', value: e['product_qty']),
        DataGridCell<dynamic>(columnName: 'meter', value: e['meter']),
        DataGridCell<dynamic>(
            columnName: 'colour_to_dye', value: e['colour_to_dye']),
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
