import 'dart:convert';

import 'package:abtxt/model/WarpDesignSheetModel.dart';
import 'package:abtxt/model/WarpOpeningStockModel.dart';
import 'package:abtxt/view/basics/new_wrap/add_new_warp_list.dart';
import 'package:abtxt/view/basics/new_wrap/new_warp.dart';
import 'package:abtxt/view/basics/warp_design_sheet/add_warp_design_sheet.dart';
import 'package:abtxt/view/basics/warp_opening_stock/warp_opening_stock_bottomsheet.dart';
import 'package:abtxt/view/basics/warp_opening_stock/warp_opening_stock_controller.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../model/NewWarpModel.dart';
import '../../../utils/constant.dart';
import '../../../widgets/CountTextField.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDateField.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';

class AddWarpOpeningStock extends StatefulWidget {
  const AddWarpOpeningStock({Key? key}) : super(key: key);
  static const String routeName = '/add_warp_opening_stock';

  @override
  State<AddWarpOpeningStock> createState() => _State();
}

class _State extends State<AddWarpOpeningStock> {
  TextEditingController idController = TextEditingController();
  Rxn<NewWarpModel> warpDesign = Rxn<NewWarpModel>();
  TextEditingController warpdesignController = TextEditingController();
  TextEditingController designNo = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController totalProductQtyController = TextEditingController();
  TextEditingController totalmeterController = TextEditingController();




  final _formKey = GlobalKey<FormState>();
  late WarpOpeningStockController controller;
  // var warpOpeningStockLIst = <dynamic>[].obs;


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
    return GetBuilder<WarpOpeningStockController>(builder: (controller) {
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
            'New', () => Get.toNamed(AddNewWarp.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Warp Opening Stock"),
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
              child: Form(
                key: _formKey,
                child: Container(
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
                            labelText: 'Warp Design',
                            controller: warpdesignController,
                            list: controller.warpDesignDropdown,
                            showCreateNew: true,
                            onItemSelected: (NewWarpModel item) {
                              warpdesignController.text =
                              '${item.warpName}';
                              warpDesign.value = item;
                              designNo.text='${item.warpType}';
                              // controller.request['group_name'] = item.id;
                            },
                            onCreateNew: (value) async {
                              //supplier.value = null;
                              var item =
                              await Get.toNamed(AddNewWarp.routeName);
                              controller.onInit();
                            },
                          ),
                  MyTextField(
                            controller: designNo,
                            hintText: "Warp Type",
                            validate: "string",
                    readonly: true,
                          ),
                          MyDateField(
                            controller: dateController,
                            hintText: "Date",
                            validate: "string",
                            readonly: true,
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
                      Visibility(
                        visible: false,
                        child: ElevatedButton(onPressed: () async{
                          var item = Get.toNamed(AddNewWarp.routeName);
                          dataSource.notifyListeners();}, child:Text('New')),
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
                          Container(
                            width: 200,
                            child: MyElevatedButton(
                              onPressed: () {
                                submit();
                              },
                              child:
                                  Text(Get.arguments == null ? 'Save' : 'Update'),
                            ),
                          ),
                        ],
                      ),

                      // Align(
                      //     alignment: Alignment.center
                      //     ,child: Text('To create Warp Design , Press "Ctrl+A"',
                      //   style: TextStyle(
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.w100),)),
                    ],
                  ),
                ),
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
        "warp_design_id": warpDesign.value?.id,
        "date": dateController.text,
        "warp_type": designNo.text,
      };
      dynamic totalProductQty = 0;
      dynamic totalMeter = 0;
      for (var i = 0; i < itemList.length; i++) {
        request['warp_id_no[$i]'] = itemList[i]['warp_id_no'];
        request['product_quantity[$i]'] =
        itemList[i]['product_quantity'];
        request['meter[$i]'] = itemList[i]['meter'];
        request['warp_condition[$i]'] =
        itemList[i]['warp_condition'];
        request['empty_type[$i]'] = itemList[i]['empty_type'];
        request['empty_quantity[$i]'] =
        itemList[i]['empty_quantity'];
        request['sheet[$i]'] = itemList[i]['sheet'];
        request['warp_colour[$i]'] = itemList[i]['warp_colour'];

      }
      request['total_product_qty'] = totalProductQty;
      request['total_meter'] = totalMeter;

      var id = idController.text;
      if (id.isEmpty) {
        var requestdata = DioFormData.FormData.fromMap(request);
        controller.add(requestdata);
      } else {
        request['id'] = id;
        var requestdata = DioFormData.FormData.fromMap(request);
        controller.edit(requestdata, id);
      }
    }
  }

  void _initValue() {
    WarpOpeningStockController controller = Get.find();

    if (Get.arguments != null) {
      WarpOpeningStockModel item = Get.arguments['item'];
      idController.text = '${item.id}';
      designNo.text = '${item.warpType}';
      dateController.text = '${item.date}';

      var warpDesignId = controller.warpDesignDropdown
          .where((element) => '${element.id}' == '${item.warpDesignId}')
          .toList();
      if (warpDesignId.isNotEmpty) {
        warpDesign.value = warpDesignId.first;
        warpdesignController.text = '${warpDesignId.first.warpName}';
      }


      item.itemDetails?.forEach((element) {
        // var request = {
        //   "warp_id_no": "${element.warpIdNo}",
        //   "product_quantity": "${element.productQuantity}",
        //   "meter": "${element.meter}",
        //   "warp_condition": "${element.warpCondition}",
        //   "empty_type": "${element.emptyType}",
        //   "empty_quantity": "${element.emptyQuantity}",
        //   "sheet": "${element.sheet}",
        //   "warp_colour": "${element.warpColour}",
        // };
        var request = element.toJson();
        itemList.add(request);

      });
    }
  }



  Widget ItemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'warp_id_no',
          label: const MyDataGridHeader(title: 'Warp ID No'),
        ),
        GridColumn(
          columnName: 'product_quantity',
          label: const MyDataGridHeader(title: 'Product Qty'),
        ),
        GridColumn(
          columnName: 'meter',
          label: const MyDataGridHeader(title: 'Meter'),
        ),
        GridColumn(
          columnName: 'warp_condition',
          label: const MyDataGridHeader(title: 'Warp Condition'),
        ),
        GridColumn(
          columnName: 'empty_type',
          label: const MyDataGridHeader(title: 'Empty Type'),
        ),
        GridColumn(
          columnName: 'empty_quantity',
          label: const MyDataGridHeader(title: 'Empty Qty'),
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
              name: 'product_quantity',
              columnName: 'product_quantity',
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
        var result = await Get.to(const WarpOpeningStockBottomSheet(),
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
    var result = await Get.to(WarpOpeningStockBottomSheet());
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
        DataGridCell<dynamic>(columnName: 'warp_id_no', value: e['warp_id_no']),
        DataGridCell<dynamic>(columnName: 'product_quantity', value: e['product_quantity']),
        DataGridCell<dynamic>(columnName: 'meter', value: e['meter']),
        DataGridCell<dynamic>(columnName: 'warp_condition', value: e['warp_condition']),
        DataGridCell<dynamic>(columnName: 'empty_type', value: e['empty_type']),
        DataGridCell<dynamic>(columnName: 'empty_quantity', value: e['empty_quantity']),
        DataGridCell<dynamic>(columnName: 'sheet', value: e['sheet']),
        DataGridCell<dynamic>(columnName: 'warp_colour', value: e['warp_colour']),

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
