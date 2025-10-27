import 'dart:convert';
import 'package:abtxt/model/ProductInfoModel.dart';
import 'package:abtxt/model/color_matching_list_data.dart';
import 'package:abtxt/view/basics/color_matching_list/color_matching_list_controller.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import 'color_matching_item_bottomsheet.dart';

class AddColorMatching extends StatefulWidget {
  const AddColorMatching({Key? key}) : super(key: key);
  static const String routeName = '/AddColorMatching';

  @override
  State<AddColorMatching> createState() => _State();
}

class _State extends State<AddColorMatching> {
  TextEditingController idController = TextEditingController();
  TextEditingController designNoController = TextEditingController();

  Rxn<ProductInfoModel> productInfoModel = Rxn<ProductInfoModel>();
  TextEditingController productInfoController = TextEditingController();


  final _formKey = GlobalKey<FormState>();



  var itemList = <dynamic>[];
  late ItemDataSource dataSource;

  @override
  void initState() {
    super.initState();
    _initValue();
    dataSource = ItemDataSource(list: itemList);

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ColorMatchingListController>(builder: (controller) {
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
        ],
        child: Scaffold(
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Color Matching"),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
              ),
              margin: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: Form(
                      key: _formKey,
                      child: Container(
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
                                MyDialogList(
                                  labelText: 'Product',
                                  controller: productInfoController,
                                  list: controller.products,
                                  showCreateNew: false,
                                  onItemSelected: (ProductInfoModel item) {
                                    productInfoController.text =
                                    '${item.productName}';
                                    productInfoModel.value = item;
                                    controller.request['product_name'] = item.id;
                                  },
                                  onCreateNew: (value) async {
                                  },
                                ),

                                MyTextField(
                                  controller: designNoController,
                                  hintText: "Design No",
                                  validate: "string",
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
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
                            const SizedBox(height: 32),
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
                                    child: Text(
                                      Get.arguments == null ? 'Save' : 'Update',
                                    ),
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
      ColorMatchingListController controller = Get.find();
      Map<String, dynamic> request = {
        "product_id": productInfoModel.value?.id,
        "design_no": designNoController.text,
      };
      for (var i = 0; i < itemList.length; i++) {
        request['warp_color[$i]'] = itemList[i]['warp_color'];
        request['weft_color[$i]'] = itemList[i]['weft_color'];
        request['is_active[$i]'] = itemList[i]['is_active'];
      }
      var id = idController.text;
      if (id.isEmpty) {
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.addColorMatching(requestPayload);
      } else {
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.updateColorMatching(requestPayload, id);
      }
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      ColorMatchingListController controller = Get.find();
      ColorMatchingListData colorMatch = Get.arguments['item'];
      print('HELLO ${jsonEncode(colorMatch)}');
      idController.text = '${colorMatch.id}';
      designNoController.text = '${colorMatch.designNo}';

      var productList = controller.products
          .where((element) => '${element.id}' == '${colorMatch.productId}')
          .toList();
      if (productList.isNotEmpty) {
        productInfoModel.value = productList.first;
        productInfoController.text ='${productList.first.productName}';
      }

      colorMatch.productDetails?.forEach((element) {
        var request = {
          "warp_color": "${element.warpColor}",
          "weft_color": "${element.weftColor}",
          "is_active": "${element.isActive}",
        };
        itemList.add(request);
      });
    }
  }
  Widget ItemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'warp_color',
          label: const MyDataGridHeader(title: 'Warp Color'),
        ),
        GridColumn(
          columnName: 'weft_color',
          label: const MyDataGridHeader(title: 'Weft Color'),
        ),
        GridColumn(
          columnName: 'is_active',
          label: const MyDataGridHeader(title: 'Is Active'),
        ),


      ],
      source: dataSource,
      onRowSelected: (index) async {
        var item = itemList[index];
        var result = await Get.to(const ColorMatchingItemBottomSheet(),
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
    var result = await Get.to(ColorMatchingItemBottomSheet());
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
        DataGridCell<dynamic>(columnName: 'warp_color', value: e['warp_color']),
        DataGridCell<dynamic>(columnName: 'weft_color', value: e['weft_color']),
        DataGridCell<dynamic>(columnName: 'is_active', value: e['is_active']),

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
