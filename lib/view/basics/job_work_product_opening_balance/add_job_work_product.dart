import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/job_worker_product_model.dart';
import 'package:abtxt/view/basics/job_work_product_opening_balance/job_work_product_opening_balance_bottomsheet.dart';
import 'package:abtxt/view/basics/ledger/addledger.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:abtxt/widgets/CountTextField.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import 'job_work_product_opening_balance.dart';
import 'job_work_product_opening_balance_controller.dart';

class AddJobWorkerProduct extends StatefulWidget {
  const AddJobWorkerProduct({Key? key}) : super(key: key);
  static const String routeName = '/add_job_work_Product';

  @override
  State<AddJobWorkerProduct> createState() => _State();
}

class _State extends State<AddJobWorkerProduct> {

  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> jobWorkerName = Rxn<LedgerModel>();
  TextEditingController jobWorkerNameController = TextEditingController();
  TextEditingController recordnoController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController totalQtyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late JobWorkProductOpeningBalanceController controller;

  // var jobWorkProductList = <dynamic>[].obs;

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
    return GetBuilder<JobWorkProductOpeningBalanceController>(
        builder: (controller) {
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
          KeyAction(
            LogicalKeyboardKey.keyA,
            'Add',
                () =>  Get.toNamed(AddLedger.routeName),
            isControlPressed: true,
          ),

          KeyAction(
            LogicalKeyboardKey.enter,
            'Save',
                () => submit(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Job Work Product Opening Balance"),
            centerTitle: false,
            actions: [

              Visibility(
                visible: false,
                child: ElevatedButton(
                  onPressed: () async {
                    var item = await Get.toNamed(AddLedger.routeName);
                    dataSource.notifyListeners();
                  }, child: Text('Add'),
                  // <-- Text
                ),
              ),
              SizedBox(width: 10,),
            ],
          ),

          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
              ),
              //height: Get.height,
              margin: const EdgeInsets.all(16),
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
                            labelText: 'Job Worker Name',
                            controller: jobWorkerNameController,
                            list: controller.ledgerDropdown,
                            showCreateNew: true,
                            onItemSelected: (LedgerModel item) {
                              jobWorkerNameController.text =
                                  '${item.ledgerName}';
                              jobWorkerName.value = item;
                              // controller.request['group_name'] = item.id;
                            },
                            onCreateNew: (value) async {
                              //supplier.value = null;
                              var item = await Get.toNamed(AddLedger.routeName);
                              controller.onInit();
                            },
                          ),
                          MyTextField(
                            controller: recordnoController,
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
          ),
        ),
      );
    });
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "jobworker_id": jobWorkerName.value?.id,
        "record_no": recordnoController.text,
        "details": detailsController.text ?? '',
      };
      dynamic totalQty = 0;
      for (var i = 0; i < itemList.length; i++) {
        request['product_name[$i]'] = itemList[i]['product_name'];
        request['product_id[$i]'] = itemList[i]['product_id'];
        request['design_no[$i]'] = itemList[i]['design_no'];
        request['ordered_work[$i]'] = itemList[i]['ordered_work'];
        request['pcs[$i]'] = itemList[i]['pcs'];
        request['quantity[$i]'] = itemList[i]['quantity'];
        // totalQty += itemList[i]['quantity'];
      }
      request['total_qty'] = totalQty;
      print(request);
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

  Future<void> _initValue() async {
    JobWorkProductOpeningBalanceController controller = Get.find();

    //Api value
    if (Get.arguments != null) {
      JobWorkerProductModel item = Get.arguments['item'];

      var myList = controller.ledgerDropdown
          .where((element) => '${element.id}' == '${item.jobworkerId}')
          .toList();
      if (myList.isNotEmpty) {
        jobWorkerName.value = myList.first;
        jobWorkerNameController.text = '${myList.first.ledgerName}';
      }
      idController.text = '${item.id}';
      recordnoController.text = '${item.recordNo}';
      detailsController.text = '${item.details}';
      item.itemDetails?.forEach((element) {
        // var request = {
        //   "product_id": "${element.productId}",
        //   "product_name": "${element.productName}",
        //   "design_no": "${element.designNo}",
        //   "ordered_work": "${element.orderedWork}",
        //   "pcs": "${element.pcs}",
        //   "quantity": "${element.quantity}",
        // };
        var request = element.toJson();
        itemList.add(request);
      });
    }
   // initTotalQty();
  }

  // void initTotalQty() {
  //   var totalQty = 0;
  //   for (var i = 0; i < itemList.length; i++) {
  //     totalQty += int.tryParse(itemList[i]['quantity']) ?? 0;
  //   }
  //   totalQtyController.text = '$totalQty';
  // }

  Widget ItemsTable() {
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
          columnName: 'ordered_work',
          label: const MyDataGridHeader(title: 'Ordered Work'),
        ),
        GridColumn(
          columnName: 'pcs',
          label: const MyDataGridHeader(title: 'Pieces'),
        ),
        GridColumn(
          columnName: 'quantity',
          label: const MyDataGridHeader(title: 'Quantity (saree)'),
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
        var result = await Get.to(
            const JobWorkProductOpeningBalanceBottomSheet(),
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
    var result = await Get.to(JobWorkProductOpeningBalanceBottomSheet());
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
            columnName: 'product_name', value: e['product_name']),
        DataGridCell<dynamic>(columnName: 'design_no', value: e['design_no']),
        DataGridCell<dynamic>(
            columnName: 'ordered_work', value: e['ordered_work']),
        DataGridCell<dynamic>(columnName: 'pcs', value: e['pcs']),
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
