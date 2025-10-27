import 'package:abtxt/model/yarndeliverytodyerdata.dart';
import 'package:abtxt/view/basics/new_color/add_new_color.dart';
import 'package:abtxt/view/trasaction/yarn_delivery_to_dyer/yarn_delivery_to_dyer_bottomsheet.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/LedgerModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/YarnModel.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/constant.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/CountTextField.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyDropdownSearch.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../basics/ledger/addledger.dart';
import '../../basics/yarn/add_yarn.dart';
import 'yarn_delivery_to_dyer_controller.dart';

class AddDyer extends StatefulWidget {
  const AddDyer({Key? key}) : super(key: key);
  static const String routeName = '/add_dyer';

  @override
  State<AddDyer> createState() => _State();
}

class _State extends State<AddDyer> {
  TextEditingController idController = TextEditingController();
  TextEditingController dyerNameController = TextEditingController();
  TextEditingController yarnNameController = TextEditingController();
  TextEditingController colorNameController = TextEditingController();
  Rxn<LedgerModel> dyerName = Rxn<LedgerModel>();
  TextEditingController dCNoController = TextEditingController();
  TextEditingController entryDateController = TextEditingController();
  TextEditingController detailsContoller = TextEditingController();
  TextEditingController entryTypeContoller = TextEditingController();
  Rxn<YarnModel> yarnName = Rxn<YarnModel>();
  Rxn<NewColorModel> colorName = Rxn<NewColorModel>();
  TextEditingController deliveryformController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController packController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController lessController = TextEditingController();
  TextEditingController netQuantityController = TextEditingController();
  TextEditingController boxnoController = TextEditingController();
  TextEditingController totalPackController = TextEditingController();
  TextEditingController totalNetQytController = TextEditingController();
  TextEditingController calculateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late YarnDeliveryToDyerController controller;
  // var yarnList = <dynamic>[].obs;
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
    return GetBuilder<YarnDeliveryToDyerController>(builder: (controller) {
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
                "${idController.text == '' ? 'Add' : 'Update'} Yarn Delivery To Dyer"),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
               // color: Colors.white,
                border: Border.all(color: Color(0xFFF9F3FF),width: 16),
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
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyAutoComplete(
                                      label: 'Dyer Name',
                                      items: controller.ledger_dropdown,
                                      selectedItem: dyerName.value,
                                      onChanged: (LedgerModel item) {
                                        dyerName.value = item;
                                        //  _firmNameFocusNode.requestFocus();
                                      },
                                    ),
                                    /*MyDialogList(
                                      labelText: 'Dyer Name',
                                      controller: dyerNameController,
                                      list: controller.ledger_dropdown,
                                      showCreateNew: true,
                                      onItemSelected: (LedgerModel item) {
                                        dyerNameController.text =
                                        '${item.ledgerName}';
                                        dyerName.value = item;
                                        controller.request['ledger_name'] = item.id;
                                      },
                                      onCreateNew: (value) async {
                                        //supplier.value = null;
                                        var item =
                                        await Get.toNamed(AddLedger.routeName);
                                        controller.onInit();
                                      },
                                    ),*/
                                  ],
                                ),

                                MyTextField(
                                  controller: dCNoController,
                                  hintText: "D.C No",
                                  validate: "string",
                                  onChanged: (value) {
                                    _sumQuantityRate();
                                  },
                                ),

                                MyDateField(
                                  controller: entryDateController,
                                  hintText: "Entry Date",
                                  validate: "String",
                                  readonly: true,

                                ),
                                MyTextField(
                                  controller: detailsContoller,
                                  hintText: "Details",
                                  validate: "String",
                                  onChanged: (value) {
                                    _sumQuantityRate();
                                  },
                                ),
                                MyDropdownButtonFormField(
                                  controller: entryTypeContoller,
                                  hintText: "Entry Type ",
                                  items: Constants.ENTRYTYPE,
                                  onChanged: (value) {
                                    _sumQuantityRate();
                                  },
                                ),
                                MyAutoComplete(
                                  label: 'Yarn Name',
                                  items: controller.yarn_dropdown,
                                  selectedItem: yarnName.value,
                                  onChanged: (YarnModel item) {
                                    yarnName.value = item;
                                    //  _firmNameFocusNode.requestFocus();
                                  },
                                ),
                                /*MyDialogList(
                                  labelText: 'Yarn Name',
                                  controller: yarnNameController,
                                  list: controller.yarn_dropdown,
                                  showCreateNew: true,
                                  onItemSelected: (YarnModel item) {
                                    yarnNameController.text =
                                    '${item.name}';
                                    yarnName.value = item;
                                    controller.request['name'] = item.id;
                                  },
                                  onCreateNew: (value) async {
                                    //supplier.value = null;
                                    var item =
                                    await Get.toNamed(AddYarn.routeName);
                                    controller.onInit();
                                  },
                                ),*/
                                MyAutoComplete(
                                  label: 'Color Name',
                                  items: controller.colors_dropdown,
                                  selectedItem: colorName.value,
                                  onChanged: (NewColorModel item) {
                                    colorName.value = item;
                                    //  _firmNameFocusNode.requestFocus();
                                  },
                                ),
                                /*MyDialogList(
                                  labelText: 'Color Name',
                                  controller: colorNameController,
                                  list: controller.colors_dropdown,
                                  showCreateNew: true,
                                  onItemSelected: (NewColorModel item) {
                                    colorNameController.text =
                                    '${item.name}';
                                    colorName.value = item;
                                    controller.request['name'] = item.id;
                                  },
                                  onCreateNew: (value) async {
                                    //supplier.value = null;
                                    var item =
                                    await Get.toNamed(AddNewColor.routeName);
                                    controller.onInit();
                                  },
                                ),*/

                                MyDropdownButtonFormField(
                                  controller: deliveryformController,
                                  hintText: "Delivery From ",
                                  items: Constants.DELIVERY_FROM,
                                  onChanged: (value) {
                                    _sumQuantityRate();
                                  },
                                ),
                                MyTextField(
                                  controller: boxnoController,
                                  hintText: "Box No",
                                  validate: "String",
                                  inputType: TextInputType.phone,
                                  onChanged: (value) {
                                    _sumQuantityRate();
                                  },
                                ),
                                MyTextField(
                                  controller: stockController,
                                  hintText: "Stock",
                                  validate: "number",
                                  inputType: TextInputType.phone,
                                  onChanged: (value) {
                                    _sumQuantityRate();
                                  },
                                ),
                                MyTextField(
                                  controller: packController,
                                  hintText: "Pack",
                                  validate: "number",
                                  inputType: TextInputType.phone,
                                  onChanged: (value) {
                                    _sumQuantityRate();
                                  },
                                ),
                                MyTextField(
                                  controller: quantityController,
                                  hintText: "Quantity",
                                  validate: "double",
                                  inputType: TextInputType.phone,
                                  onChanged: (value) {
                                    _sumQuantityRate();
                                  },
                                ),
                                MyTextField(
                                  controller: lessController,
                                  hintText: "Less",
                                  validate: "double",
                                  inputType: TextInputType.phone,
                                  onChanged: (value) {
                                    _sumQuantityRate();
                                  },
                                ),
                                MyTextField(
                                  controller: netQuantityController,
                                  hintText: "Net Quantity",
                                  validate: "double",
                                  inputType: TextInputType.phone,
                                  onChanged: (value) {
                                    _sumQuantityRate();
                                  },
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
                              height: 12,
                            ),
                            ItemsTable(),
                            const SizedBox(height: 12),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(child: Container()),
                                // Padding(padding: EdgeInsets.only(left: 450)),
                                // SizedBox(
                                //   width: 170,
                                //   child: CountTextField(
                                //     controller: totalPackController,
                                //     hintText: "Total Pack",
                                //     readonly: true,
                                //   ),
                                // ),
                                // // Padding(padding: EdgeInsets.only(left:240)),
                                // SizedBox(
                                //   width: 170,
                                //   child: CountTextField(
                                //     controller: totalNetQytController,
                                //     hintText: "Total Net Qty",
                                //     suffix: const Text('Pondhu',
                                //         style:
                                //             TextStyle(color: Color(0xFF5700BC))),
                                //     readonly: true,
                                //   ),
                                // ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: [
                                  Visibility(
                                    visible: false,
                                    child: MyElevatedButton(
                                      color: Colors.red,
                                      onPressed: () async {
                                        var id = idController.text;
                                        YarnDeliveryToDyerController controller =
                                        Get.find();
                                        await controller.delete(id);
                                      },
                                      child: const Text('DELETE'),
                                    ),
                                  ),
                                  Spacer(),
                                  MyCloseButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Close'),
                                  ),
                                  const SizedBox(width: 12),
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
        "dc_no": dCNoController.text,
        "entry_date": entryDateController.text,
        "details": detailsContoller.text,
        "entry_type": entryTypeContoller.text,
        "yarn_id": yarnName.value?.id,
        "color_id": colorName.value?.id,
        "delivery_from": deliveryformController.text,
        "stock": stockController.text,
        "pack": packController.text,
        "quantity": quantityController.text,
        "less": lessController.text,
        "net_quantity": netQuantityController.text,
        "box_no": boxnoController.text,


      };

      var dyeryarnList = [];
      dynamic QuantityTotal = 0;
      dynamic packTotal = 0;
      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "color_name": itemList[i]['color_name'],
          "pack": itemList[i]['pack'],
          "qty": itemList[i]['qty'],
        };
        // packTotal += itemList[i]['pack'];
        // QuantityTotal += itemList[i]['qty'];

        dyeryarnList.add(item);
      }

      request['total_quantity'] = QuantityTotal;
      request['total_pack_quantity'] = packTotal;
      request['dyer_item'] = dyeryarnList;

      print(request);
      var id = idController.text;
      if (id.isEmpty) {
        controller.add(request);
      } else {
        request['id'] = '$id';
        controller.edit(request, id);
      }

      print(request);
    }
  }

  void _initValue() {
    entryDateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    YarnDeliveryToDyerController controller = Get.find();
    controller.request = <String, dynamic>{};
    entryTypeContoller.text = Constants.ENTRYTYPE[0];
    deliveryformController.text = Constants.DELIVERY_FROM[0];

    if (Get.arguments != null) {
      YarnDeliveryToDyerController controller = Get.find();
      YarnDeliverytoDyerModel value = Get.arguments['item'];


      idController.text = '${value.id}';
      // dyer Name
      var dyerList = controller.ledger_dropdown
          .where((element) => '${element.id}' == '${value.dyerId}')
          .toList();
      if (dyerList.isNotEmpty) {
        dyerName.value = dyerList.first;
        dyerNameController.text = '${dyerList.first.ledgerName}';
      }
      // Yarn Name
      var YarnList = controller.yarn_dropdown
          .where((element) => '${element.id}' == '${value.yarnId}')
          .toList();
      if (YarnList.isNotEmpty) {
        yarnName.value = YarnList.first;
        yarnNameController.text = '${YarnList.first.name}';

      }

      //colorName
      var colorList = controller.colors_dropdown
          .where((element) => '${element.id}' == '${value.colorId}')
          .toList();
      if (colorList.isNotEmpty) {
        colorName.value = colorList.first;
        colorNameController.text = '${colorList.first.name}';

      }

      entryTypeContoller.text = '${value.entryType}';
      dCNoController.text = '${value.dcNo}';
      entryDateController.text = '${value.entryDate}';
      detailsContoller.text = '${value.details}';
      deliveryformController.text = '${value.deliveryFrom}';
      stockController.text = '${value.stock}';
      packController.text = '${value.pack}';
      quantityController.text = '${value.quantity}';
      boxnoController.text = '${value.boxNo}';
      lessController.text = '${value.less}';
      netQuantityController.text = '${value.netQuantity}';
      entryTypeContoller.text = Constants.ENTRYTYPE[0];
      deliveryformController.text = Constants.DELIVERY_FROM[0];

      value.itemDetails?.forEach((element) {

        var request = element.toJson();
        itemList.add(request);
      });
    }
    // initTotal();
  }
  void _sumQuantityRate() {
    double quantity = double.tryParse(quantityController.text) ?? 0;
    double less = double.tryParse(lessController.text) ?? 0;
    // double rate = double.tryParse(rateController.text) ?? 0;
    int pack = int.tryParse(packController.text) ?? 0;
    var netQuantity = quantity - less;
    netQuantityController.text = '$netQuantity';


  }

  // void initTotal() {
  //   var netQtyTotal = 0;
  //   var packTotal = 0;
  //   for (var i = 0; i < itemList.length; i++) {
  //     packTotal += int.tryParse(itemList[i]['pack']) ?? 0;
  //     netQtyTotal += int.tryParse(itemList[i]['qty']) ?? 0;
  //
  //   }
  //   totalNetQytController.text = '$netQtyTotal';
  //   totalPackController.text = '$packTotal';
  // }


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
          columnName: 'qty',
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
              name: 'qty',
              columnName: 'qty',
              summaryType: GridSummaryType.sum,
            ),
            // const GridSummaryColumn(
            //   name: 'amount',
            //   columnName: 'amount',
            //   summaryType: GridSummaryType.sum,
            // ),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSource,
      onRowSelected: (index) async {
        var item = itemList[index];
        var result = await Get.to(const YarnDeliveryToDyerBottomSheet(),
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
    var result = await Get.to(YarnDeliveryToDyerBottomSheet());
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
        DataGridCell<dynamic>(
            columnName: 'qty', value: e['qty']),
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