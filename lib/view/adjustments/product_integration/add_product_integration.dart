import 'package:abtxt/view/adjustments/product_integration/product_integration_bottom_sheet.dart';
import 'package:abtxt/view/adjustments/product_integration/product_integration_controller.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../model/product_integration_model.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../basics/productinfo/add_product_info.dart';

class AddProductIntegration extends StatefulWidget {
  const AddProductIntegration({Key? key}) : super(key: key);
  static const String routeName = '/addproductintegration';

  @override
  State<AddProductIntegration> createState() => _State();
}

class _State extends State<AddProductIntegration> {
  TextEditingController idController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController recordController = TextEditingController();
  TextEditingController integratedController = TextEditingController();
  Rxn<ProductInfoModel> productController = Rxn<ProductInfoModel>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController designNoController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late ProductIntegrationController controller;

  // var addproductIntegrationList = <dynamic>[].obs;


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
    return GetBuilder<ProductIntegrationController>(builder: (controller) {
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
        ],
        child: Scaffold(
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Product Integration - Adjustments"),
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
                                  controller: integratedController,
                                  hintText: "Integrated by",
                                  validate: "string",
                                ),

                                MyDialogList(
                                  labelText: 'Product Name',
                                  controller: productNameController,
                                  list: controller.products,
                                  showCreateNew: true,
                                  onItemSelected: (ProductInfoModel item) {
                                    productNameController.text = '${item.productName}';
                                    productController.value = item;
                                  },
                                  onCreateNew: (value) async {
                                    var item =
                                    await Get.toNamed(AddProductInfo.routeName);
                                    controller.onInit();
                                  },
                                ),

                                MyTextField(
                                  controller: designNoController,
                                  hintText: "Design No",
                                  validate: "string",
                                  readonly: true,
                                ),
                                MyTextField(
                                  controller: quantityController,
                                  hintText: "Quantity",
                                  validate: "number",
                                  suffix: const Text('Set',
                                      style: TextStyle(color: Color(0xFF5700BC))),
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
                              height: 20,
                            ),
                            ItemTable(),
                            SizedBox(height: 60),
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
        "recored_no": recordController.text,
        "integrate_by": integratedController.text,
        "product_id": productController.value?.id,
        "product_name": productController.value?.productName,
        "design_no": designNoController.text,
        "quantity": quantityController.text,
      };
      var productIntegrationList = [];

      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "product_id": itemList[i]['product_id'],
          "design_no": itemList[i]['design_no'],
          "work_name": itemList[i]['work_name'],
          "wastage": itemList[i]['wastage'],
          "quantity": itemList[i]['quantity'],
          "totel_consumption": itemList[i]
              ['totel_consumption'],
        };

        productIntegrationList.add(item);
      }

      request['product_item'] = productIntegrationList;

      print(request);
      var id = idController.text;
      if (id.isEmpty) {
        controller.addProductintegration(request);
      } else {
        request['id'] = '$id';
        controller.editProductintegration(request);
      }

      print(request);
    }
  }

  void _initValue() {
    ProductIntegrationController controller = Get.find();
    // dateController.text = "2023-10-23";
    // recordController.text = "";
    // integratedController.text = "Menaga";

    if (Get.arguments != null) {
      ProductIntegrationController controller = Get.find();
      ProductIntegrationModel data = Get.arguments['item'];
      idController.text = '${data.id}';
      dateController.text = '${data.date}';
      recordController.text = '${data.recoredNo}';
      integratedController.text = '${data.integrateBy}';
      quantityController.text = '${data.quantity}';

      // Product
      var productlist = controller.products
          .where((element) => '${element.id}' == '${data.productId}')
          .toList();
      if (productlist.isNotEmpty) {
        productController.value = productlist.first;
      }
      designNoController.text = '${data.designNo}';
    }
  }
  Widget ItemTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'product_id',
          label: const MyDataGridHeader(title: 'Product Name'),
        ),
        GridColumn(
          columnName: 'design_no',
          label: const MyDataGridHeader(title: 'Design No'),
        ),
        GridColumn(
          columnName: 'work_name',
          label: const MyDataGridHeader(title: 'Work Name'),
        ),
        GridColumn(
          columnName: 'quantity',
          label: const MyDataGridHeader(title: 'Quantity'),
        ),
        GridColumn(
          columnName: 'wastage',
          label: const MyDataGridHeader(title: 'Wastage'),
        ),
        GridColumn(
          columnName: 'totel_consumption',
          label: const MyDataGridHeader(title: 'Total Consumption'),
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
        /*var item = paginatedOrders[index];
        dataSource.notifyListeners();*/
      },
    );
  }
  void _addItem() async {
    var result = await Get.to(ProductIntegrationBottomSheet());
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
        DataGridCell<dynamic>(columnName: 'product_id', value: e['product_id']),
        DataGridCell<dynamic>(columnName: 'design_no', value: e['design_no']),
        DataGridCell<dynamic>(
            columnName: 'work_name', value: e['work_name']),
        DataGridCell<dynamic>(columnName: 'quantity', value: e['quantity']),
        DataGridCell<dynamic>(columnName: 'wastage', value: e['wastage']),
        DataGridCell<dynamic>(columnName: 'totel_consumption', value: e['totel_consumption']),
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
