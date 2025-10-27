import 'package:abtxt/model/ProductReturnFromCustomerModel.dart';
import 'package:abtxt/view/trasaction/product_return_from_customer/product_return_from_customer_controller.dart';
import 'package:abtxt/view/trasaction/product_return_from_customer/product_return_from_customers_bottom_sheet.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/CountTextField.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../basics/ledger/addledger.dart';

class AddProductReturnFromCustomer extends StatefulWidget {
  const AddProductReturnFromCustomer({Key? key}) : super(key: key);
  static const String routeName = '/add_product_return_from_customer';

  @override
  State<AddProductReturnFromCustomer> createState() => _State();
}

class _State extends State<AddProductReturnFromCustomer> {
  Rxn<FirmModel> firmNameController = Rxn<FirmModel>();
  TextEditingController firmController = TextEditingController();
  Rxn<LedgerModel> customerController = Rxn<LedgerModel>();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController dCNoContoller = TextEditingController();
  TextEditingController dCDateController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController totalPiecesController = TextEditingController();
  TextEditingController totalQuantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late ProductReturnFromCustomerController controller;


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
    return GetBuilder<ProductReturnFromCustomerController>(
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
        ],
        child: Scaffold(
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Product Return From Customer"),
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
                                MyDialogList(
                                  labelText: 'Firm',
                                  controller: firmController,
                                  list: controller.firmName,
                                  showCreateNew: false,
                                  onItemSelected: (FirmModel item) {
                                    firmController.text =
                                    '${item.firmName}';
                                    firmNameController.value = item;
                                    // controller.request['group_name'] = item.id;
                                  },
                                  onCreateNew: (value) async {
                                    //supplier.value = null;
                                    // var item =
                                    // await Get.toNamed(AddWarpGroup.routeName);
                                    // controller.onInit();
                                  },
                                ),
                                MyDialogList(
                                  labelText: 'Customer Name',
                                  controller: customerNameController,
                                  list: controller.Customer,
                                  showCreateNew: false,
                                  onItemSelected: (LedgerModel item) {
                                    customerNameController.text =
                                    '${item.ledgerName}';
                                    customerController.value = item;
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
                                  controller: placeController,
                                  hintText: "Place",
                                  validate: "String",
                                ),
                                const SizedBox(
                                  width: 11,
                                ),
                                MyCreateNew(
                                  onPressed: () async {
                                    var item =
                                        await Get.toNamed(AddLedger.routeName);
                                    controller.onInit();
                                  },
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                MyTextField(
                                  controller: dCNoContoller,
                                  hintText: "D.C No",
                                  validate: "String",
                                ),
                                MyDateField(
                                  controller: dCDateController,
                                  hintText: "Date",
                                  validate: "String",
                                  readonly: true,
                                ),
                                MyTextField(
                                  controller: detailsController,
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
                            const SizedBox(height: 20),

                            Align(
                              alignment: Alignment.centerRight,
                              child: Wrap(
                                spacing: 16,
                                children: [
                                  MyCloseButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Close'),
                                  ),
                                  MyElevatedButton(
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

  submit() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "firm_id": firmNameController.value?.id,
        "customer_id": customerController.value?.id,
        "place": placeController.text,
        "dc_no": dCNoContoller.text,
        "dc_date": dCDateController.text,
        "details": detailsController.text ?? '',
      };
      var returnItemList = [];
      dynamic piecesTotal = 0;
      dynamic qytTotal = 0;
      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "product_id": itemList[i]['product_id'],
          "desgin_no": itemList[i]['desgin_no'],
          "work": itemList[i]['work'],
          "work_details": itemList[i]['work_details'],
          "pieces": itemList[i]['pieces'],
          "quantity": itemList[i]['quantity'],
          "rate": itemList[i]['rate'],
          "delivered": itemList[i]['delivered'],
        };
        // piecesTotal += itemList[i]['pieces'];
        // qytTotal += itemList[i]['quantity'];
        returnItemList.add(item);
      }
      request['totel_pieces'] = piecesTotal;
      request['totel_quantity'] = qytTotal;
      request['return_item'] = returnItemList;
      var id = idController.text;
      if (id.isEmpty) {
        controller.add(request);
      } else {
        request['id'] = id;
        controller.edit(request, id);
      }
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      ProductReturnFromCustomerController controller = Get.find();
      ProductReturnFromCustomerModel items = Get.arguments['item'];
      idController.text = '${items.id}';
      placeController.text = '${items.place}';
      dCNoContoller.text = '${items.dcNo}';
      dCDateController.text = '${items.dcDate}';
      detailsController.text = '${items.details}';

      var firmList = controller.firmName
          .where((element) => '${element.id}' == '${items.firmId}')
          .toList();
      if (firmList.isNotEmpty) {
        firmNameController.value = firmList.first;
        firmController.text = '${firmList.first.firmName}';
      }
      var customerList = controller.Customer.where(
          (element) => '${element.id}' == '${items.customerId}').toList();
      if (customerList.isNotEmpty) {
        customerController.value = customerList.first;
        customerNameController.text = '${customerList.first.ledgerName}';

      }
      items.itemDetails?.forEach((element) {
        // var request = {
        //   "product_name": "${element.productName}",
        //   "product_id": "${element.productId}",
        //   "desgin_no": "${element.desginNo}",
        //   "work": "${element.work}",
        //   "pieces": "${element.pieces}",
        //   "quantity": "${element.quantity}",
        //   "rate": "${element.rate}",
        //   "delivered": "${element.delivered}",
        //   "work_details": "${element.workDetails}",
        // };
        var request = element.toJson();
        itemList.add(request);
      });
    }
    // initTotal();
  }

  // void initTotal() {
  //   var piecesTotal = 0;
  //   var quantityTotal = 0;
  //   for (var i = 0; i < itemList.length; i++) {
  //     piecesTotal += int.tryParse(itemList[i]['pieces']) ?? 0;
  //     quantityTotal += int.tryParse(itemList[i]['quantity']) ?? 0;
  //   }
  //   totalQuantityController.text = '$quantityTotal';
  //   totalPiecesController.text = '$piecesTotal';
  // }

  Widget ItemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'product_name',
          label: const MyDataGridHeader(title: 'Product Name'),
        ),
        GridColumn(
          columnName: 'desgin_no',
          label: const MyDataGridHeader(title: 'Design No'),
        ),
        GridColumn(
          columnName: 'work',
          label: const MyDataGridHeader(title: 'Work'),
        ),
        GridColumn(
          columnName: 'pieces',
          label: const MyDataGridHeader(title: 'Pieces'),
        ),
        GridColumn(
          columnName: 'quantity',
          label: const MyDataGridHeader(title: 'Quantity'),
        ),
        GridColumn(
          columnName: 'rate',
          label: const MyDataGridHeader(title: 'Rate(Rs)'),
        ),

      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'pieces',
              columnName: 'pieces',
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
        var result = await Get.to(const ProductReturnFromCustomerBottomSheet(),
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
    var result = await Get.to(ProductReturnFromCustomerBottomSheet());
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
        DataGridCell<dynamic>(columnName: 'desgin_no', value: e['desgin_no']),
        DataGridCell<dynamic>(columnName: 'work', value: e['work']),
        DataGridCell<dynamic>(columnName: 'pieces', value: e['pieces']),
        DataGridCell<dynamic>(columnName: 'quantity', value: e['quantity']),
        DataGridCell<dynamic>(columnName: 'rate', value: e['rate']),

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
