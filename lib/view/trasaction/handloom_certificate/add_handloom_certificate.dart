import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/TransportCopyProductSaleModel.dart';
import 'package:abtxt/view/basics/ledger/addledger.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/handloom_certificate_model.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/CountTextField.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import 'handloom_certificate_bottom_sheet.dart';
import 'handloom_certificate_controller.dart';

class AddHandloomCertificate extends StatefulWidget {
  const AddHandloomCertificate({Key? key}) : super(key: key);
  static const String routeName = '/add_handloom_certificate';

  @override
  State<AddHandloomCertificate> createState() => _State();
}

class _State extends State<AddHandloomCertificate> {
  TextEditingController idController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  TextEditingController firmNameController = TextEditingController();
  Rxn<LedgerModel> customerName = Rxn<LedgerModel>();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController lRrRController = TextEditingController();
  TextEditingController dCdateContoller = TextEditingController();
  TextEditingController totalQuantityController = TextEditingController();
  TextEditingController totalNetAmountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late HandLoomController controller;
  // var handloomList = <dynamic>[].obs;



  var itemList = <dynamic>[];
  late ItemDataSource dataSource;

  @override
  void initState() {
    _initValue();
    dataSource = ItemDataSource(list: itemList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandLoomController>(builder: (controller) {
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
            'Add', () => additem(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} HandLoom Certificate"),
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
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    MyDialogList(
                                      labelText: 'Firm',
                                      controller: firmNameController,
                                      showCreateNew: false,
                                      list: controller.firmDropdown,
                                      onItemSelected: (FirmModel item) {
                                        firmNameController.text = '${item.firmName}';
                                        firmName.value = item;
                                      },
                                      onCreateNew: (value) async {

                                      },
                                    ),
                                  ],
                                ),
                                MyDialogList(
                                  labelText: 'Customer Name',
                                  controller: customerNameController,
                                  list: controller.ledgerDropdown,
                                  showCreateNew: true,
                                  onItemSelected: (LedgerModel item) {
                                    customerNameController.text =
                                    '${item.ledgerName}';
                                    customerName.value = item;
                                  },
                                  onCreateNew: (value) async {

                                  },
                                ),
                                MyTextField(
                                  controller: placeController,
                                  hintText: "Place",
                                  validate: "string",
                                ),
                                const SizedBox(
                                  width: 11,
                                ),
                                MyCreateNew(
                                  onPressed: () async {
                                    customerName.value = null;
                                    var item =
                                        await Get.toNamed(AddLedger.routeName);
                                    controller.onInit();
                                  },
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                MyTextField(
                                  controller: lRrRController,
                                  hintText: "LR / RR No.",
                                  validate: "string",
                                ),
                                MyDateField(
                                  controller: dCdateContoller,
                                  hintText: "D.C Date",
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
                                  additem();
                                },
                                child: const Text('Add Item'),
                              ),
                            ),
                            const SizedBox(height: 20),
                            itemsTable(),
                            const SizedBox(height: 40),
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
      var request = {
        "firm_id": firmName.value?.id,
        "customer_id": customerName.value?.id,
        "place": placeController.text,
        "lr_rr_no": lRrRController.text,
        "d_c_date": dCdateContoller.text,
      };
      var handloomListItem = [];
      dynamic quantityTotal = 0;
      double amountTotal = 0.0;

      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "date": itemList[i]['date'],
          "invoice_no": itemList[i]['invoice_no'],
          "bundles": itemList[i]['bundles'],
          "quantity": itemList[i]['quantity'],
          "net_amount": itemList[i]['net_amount'],
        };
        // quantityTotal += int.tryParse(itemList[i]['quantity']) ?? 0;
        // amountTotal += double.tryParse(itemList[i]['net_amount']) ?? 0.0;

        handloomListItem.add(item);
      }

      request['total_qty'] = quantityTotal;
      request['total_net_amount'] = amountTotal;
      request['handloom_item'] = handloomListItem;

      print(request);
      var id = idController.text;
      if (id.isEmpty) {
        controller.addHandloom(request);
      } else {
        request['id'] = '$id';
        controller.updateHandloom(request, id);
      }
      print(request);
    }
  }

  void _initValue() {
    HandLoomController controller = Get.find();

    if (Get.arguments != null) {
      HandLoomController controller = Get.find();
      HandloomCertificateModel items = Get.arguments['item'];
      idController.text = '${items.id}';
      placeController.text = '${items.place}';
      lRrRController.text = '${items.lrRrNo}';
      dCdateContoller.text = '${items.dCDate}';

      var firmList = controller.firmDropdown
          .where((element) => '${element.id}' == '${items.firmId}')
          .toList();
      if (firmList.isNotEmpty) {
        firmName.value = firmList.first;
        firmNameController.text='${firmList.first.firmName}';
      }
      var customerList = controller.ledgerDropdown
          .where((element) => '${element.id}' == '${items.customerId}')
          .toList();
      if (customerList.isNotEmpty) {
        customerName.value = customerList.first;
        customerNameController.text='${customerList.first.ledgerName}';

      }

      items.itemDetails?.forEach((element) {

        var request = element.toJson();
        itemList.add(request);
      });
    }
    // initTotal();
  }

  // void initTotal() {
  //   double amountTotal = 0.0;
  //   var quantityTotal = 0;
  //
  //   for (var i = 0; i < itemList.length; i++) {
  //     print("${itemList[i]["quantity"].runtimeType}");
  //     // Parsing the string values to numeric types before addition
  //     quantityTotal += int.tryParse(itemList[i]['quantity']) ?? 0;
  //     amountTotal += double.tryParse(itemList[i]['net_amount']) ?? 0.0;
  //   }
  //
  //   totalQuantityController.text = '$quantityTotal';
  //   totalNetAmountController.text = '$amountTotal';
  // }
  Widget itemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'date',
          label: const MyDataGridHeader(title: 'Date'),
        ),
        GridColumn(
          columnName: 'invoice_no',
          label: const MyDataGridHeader(title: 'Invoice No'),
        ),
        GridColumn(
          columnName: 'bundles',
          label: const MyDataGridHeader(title: 'Bundles'),
        ),
        GridColumn(
          columnName: 'quantity',
          label: const MyDataGridHeader(title: 'Quantity'),
        ),
        GridColumn(
          columnName: 'net_amount',
          label: const MyDataGridHeader(title: 'Net. Amount'),
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
            const GridSummaryColumn(
              name: 'net_amount',
              columnName: 'net_amount',
              summaryType: GridSummaryType.sum,
            ),

          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSource,
      onRowSelected: (index) async {
        var item = itemList[index];
        var result = await Get.to(const HandLoomBottomSheet(),
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

  dynamic additem() async {
    var result = await showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        constraints: const BoxConstraints(
          maxWidth: 800,
        ),
        builder: (context) {
          return const HandLoomBottomSheet();
        });

    return result;
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
            columnName: 'date', value: e['date']),
        DataGridCell<dynamic>(columnName: 'invoice_no', value: e['invoice_no']),
        DataGridCell<dynamic>(columnName: 'bundles', value: e['bundles']),
        DataGridCell<dynamic>(
            columnName: 'quantity', value: e['quantity']),
        DataGridCell<dynamic>(columnName: 'net_amount', value: e['net_amount']),

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
