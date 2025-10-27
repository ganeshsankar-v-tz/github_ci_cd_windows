import 'package:abtxt/model/YarnOpeningStockResponse.dart';
import 'package:abtxt/view/basics/new_color/add_new_color.dart';
import 'package:abtxt/view/basics/yarn/add_yarn.dart';
import 'package:abtxt/view/basics/yarn_opening_stock/yarn_opening_stock-bottom_sheet.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/YarnModel.dart';
import '../../../widgets/CountTextField.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDateField.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../new_color/new_color.dart';
import '../yarn/yarns.dart';
import 'yarn_opening_stock_controller.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';

class AddYarnOpeningStock extends StatefulWidget {
  const AddYarnOpeningStock({Key? key}) : super(key: key);
  static const String routeName = '/add_yarn_stock';

  @override
  State<AddYarnOpeningStock> createState() => _State();
}

class _State extends State<AddYarnOpeningStock> {
  TextEditingController idController = TextEditingController();
  Rxn<YarnModel> yarnNameController = Rxn<YarnModel>();
  TextEditingController yarnController = TextEditingController();
  Rxn<NewColorModel> colorController = Rxn<NewColorModel>();
  TextEditingController colorNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController totalQtyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late YarnOpeningStockController controller;

  // var addItemyarnopeningstock = <dynamic>[].obs;



  var itemList = <dynamic>[];
  late ItemDataSource dataSource;
  // File? image;

  @override
  void initState() {
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: itemList);

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnOpeningStockController>(builder: (controller) {
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
            'Add', () =>_addItem(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Yarn Opening Stock"),
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
                                  labelText: 'Yarn Name',
                                  controller: yarnController,
                                  list: controller.YarnName,
                                  showCreateNew: true,
                                  onItemSelected: (YarnModel item) {
                                    yarnController.text =
                                    '${item.name}';
                                    yarnNameController.value = item;
                                    // controller.request['group_name'] = item.id;
                                  },
                                  onCreateNew: (value) async {
                                    //supplier.value = null;
                                    var item =
                                    await Get.toNamed(AddYarn.routeName);
                                    controller.onInit();
                                  },
                                ),

                                MyDialogList(
                                  labelText: 'Color Name',
                                  controller: colorNameController,
                                  list: controller.ColorName,
                                  showCreateNew: true,
                                  onItemSelected: (NewColorModel item) {
                                    colorNameController.text =
                                    '${item.name}';
                                    colorController.value = item;
                                    // controller.request['group_name'] = item.id;
                                  },
                                  onCreateNew: (value) async {
                                    //supplier.value = null;
                                    var item =
                                    await Get.toNamed(AddNewColor.routeName);
                                    controller.onInit();
                                  },
                                ),

                                MyDateField(
                                  controller: dateController,
                                  hintText: "Date",
                                  validate: "string",
                                  readonly: true,
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
                            const SizedBox(height: 20),
                            ItemsTable(),
                            SizedBox(height: 40),

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
                                    onPressed: () => submit(),
                                    child: Text(
                                        "${Get.arguments == null ? 'Save' : 'Update'}"),
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
        "yarn_id": yarnNameController.value?.id,
        "colour_id": colorController.value?.id,
        "date": dateController.text,
      };
      dynamic totalQty = 0;
      for (var i = 0; i < itemList.length; i++) {
        request['stock_in[$i]'] = itemList[i]['stock_in'];
        request['box_number[$i]'] = itemList[i]['box_number'];
        request['quantity[$i]'] = itemList[i]['quantity'];

        totalQty += itemList[i]['quantity'];

      }
      request['total_qty'] = totalQty;
      print(request);
      var id = idController.text;
      if (id.isEmpty) {
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.add(requestPayload);
      } else {
        request['id'] = '$id';
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.edit(requestPayload, id);
      }

      print(request);
    }
  }

  void _initValue() {
    YarnOpeningStockController controller = Get.find();
    if (Get.arguments != null) {
      YarnOpeningStockController controller = Get.find();
      YarnOpeningStockModel ledger = Get.arguments['item'];
      idController.text = '${ledger.id}';
      dateController.text = '${ledger.date}';

      var yarnName = controller.YarnName
          .where((element) => '${element.id}' == '${ledger.yarnId}')
          .toList();
      if (yarnName.isNotEmpty) {
        yarnNameController.value = yarnName.first;
        yarnController.text = '${yarnName.first.name}';
      }
      var colorName = controller.ColorName
          .where((element) => '${element.id}' == '${ledger.colourId}')
          .toList();
      if (colorName.isNotEmpty) {
        colorController.value = colorName.first;
        colorNameController.text = '${colorName.first.name}';

      }

      ledger.itemDetails?.forEach((element) {
        // var request = {
        //   "stock_in": "${element.stockIn}",
        //   "box_number": "${element.boxNumber}",
        //   "quantity": "${element.quantity}",
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
          columnName: 'stock_in',
          label: const MyDataGridHeader(title: 'Stock in'),
        ),
        GridColumn(
          columnName: 'box_number',
          label: const MyDataGridHeader(title: 'Bag / Box No.'),
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
        var result = await Get.to(const YarnOpeningStockBottomSheet(),
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
    var result = await Get.to(YarnOpeningStockBottomSheet());
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
        DataGridCell<dynamic>(columnName: 'stock_in', value: e['stock_in']),
        DataGridCell<dynamic>(columnName: 'box_number', value: e['box_number']),
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
