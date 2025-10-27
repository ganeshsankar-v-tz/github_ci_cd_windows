import 'package:abtxt/view/adjustments/product_stock_adjustment/product_stock_adjustment_bottom_sheet.dart';
import 'package:abtxt/view/adjustments/product_stock_adjustment/product_stock_controller.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../model/product_stock_adjustment_model.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/CountTextField.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../basics/Cops_Reel/cops_reel.dart';

class AddProductStock extends StatefulWidget {
  const AddProductStock({Key? key}) : super(key: key);
  static const String routeName = '/addproductstock';

  @override
  State<AddProductStock> createState() => _State();
}

class _State extends State<AddProductStock> {
  TextEditingController idController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController recordController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController totalQtyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late ProductStockController controller;

  // var addproductStockList = <dynamic>[].obs;


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
    return GetBuilder<ProductStockController>(builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close',
                () =>Get.back(),
            isControlPressed: true,
          ),
          KeyAction(
            LogicalKeyboardKey.keyN,
            'Add',
                () =>_addItem(),
            isControlPressed: true,
          ),

        ],
        child: Scaffold(
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Product Stock - Adjustments"),
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
                                MyDateField(
                                  controller: dateController,
                                  hintText: "Date",
                                  validate: "string",
                                  readonly: true,
                                ),
                                MyTextField(
                                  controller: recordController,
                                  hintText: "Record No",
                                  validate: "string",
                                ),
                                MyTextField(
                                  controller: detailsController,
                                  hintText: "Details",
                                  validate: "string",
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
                            SizedBox(
                              height: 20,
                            ),
                            productStockTable(),
                            SizedBox(height: 40),
                            // Row(
                            //   children: [
                            //     Expanded(child: Container()),
                            //     // Padding(padding: EdgeInsets.only(left: 1000)),
                            //     SizedBox(
                            //       width: 170,
                            //       child: CountTextField(
                            //         controller: totalQtyController,
                            //         hintText: "Total Qty",
                            //         readonly: true,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MyCloseButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Close'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  child: MyElevatedButton(
                                    onPressed: controller.status.isLoading
                                        ? null
                                        : () => submit(),
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
        "date": dateController.text,
        "record_no": recordController.text,
        "details": detailsController.text ?? '',
      };

      var productStockList = [];
      int QuantityTotal = 0;

      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "product_id": itemList[i]['product_id'],
          "design_no": itemList[i]['design_no'],
          "work": itemList[i]['work'],
          "stock": itemList[i]['stock'],
          "quantity": itemList[i]['quantity'],
        };

        QuantityTotal += int.tryParse(itemList[i]['quantity']) ?? 0;

        productStockList.add(item);
      }

      request['total_quantity'] = QuantityTotal;
      request['product_item'] = productStockList;

      print(request);
      var id = idController.text;
      if (id.isEmpty) {
        controller.addProductStock(request);
      } else {
        request['id'] = '$id';
        controller.editProductStock(
          request,
        );
      }

      print(request);
    }
  }

  void _initValue() {
    ProductStockController controller = Get.find();
    // dateController.text = "2023-10-09";
    if (Get.arguments != null) {
      ProductStockController controller = Get.find();
      ProductStockAdjustmentsModel data = Get.arguments['item'];
      idController.text = '${data.id}';
      dateController.text = '${data.date}';
      recordController.text = '${data.recordNo}';
      detailsController.text = '${data.details}';

      data.itemDetails?.forEach((element) {
        var request = {
          "product_id": "${element.productId}",
          "product_name": "${element.productName}",
          "design_no": "${element.designNo}",
          "work_type": "${element.work}",
          "quantity": "${element.quantity}",
        };
        itemList.add(request);
      });
    }
    initTotal();
  }

  void initTotal() {

    var totalqytTotal = 0;


    for (var i = 0; i < itemList.length; i++) {
      totalqytTotal += int.tryParse(itemList[i]['quantity']) ?? 0;


    }
    totalQtyController.text = '$totalqytTotal';

  }
  Widget productStockTable() {
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
          label: const MyDataGridHeader(title: 'Work Name'),
        ),
        GridColumn(
          columnName: 'quantity',
          label: const MyDataGridHeader(title: 'Quantity.'),
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
        /*var item = paginatedOrders[index];
        dataSource.notifyListeners();*/
      },
    );
  }

  void _addItem() async {
    var result = await Get.to(ProductStockAdjustmentsBottomSheet());
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
        DataGridCell<dynamic>(
            columnName: 'work_type', value: e['work_type']),
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
