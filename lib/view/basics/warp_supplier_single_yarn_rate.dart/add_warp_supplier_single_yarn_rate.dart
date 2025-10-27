import 'dart:convert';

import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/basics/warp_supplier_single_yarn_rate.dart/warp_supplier_single_yarn_rate_controller.dart';
import 'package:abtxt/view/basics/warp_supplier_single_yarn_rate.dart/warp_supplier_single_yarn_rate_item_bottomsheet.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:abtxt/widgets/flutter_shortcut_widget.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/WarpSupplierSingleYarnRateModel.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';

class AddWarpSupplierSingleYarnRate extends StatefulWidget {
  const AddWarpSupplierSingleYarnRate({Key? key}) : super(key: key);
  static const String routeName = '/add_warping_single_yarn_rate';

  @override
  State<AddWarpSupplierSingleYarnRate> createState() => _State();
}

class _State extends State<AddWarpSupplierSingleYarnRate> {
  TextEditingController idController = TextEditingController();
  TextEditingController totalSingleYarnRateController = TextEditingController();

  Rxn<LedgerModel> supplier_name = Rxn<LedgerModel>();
  TextEditingController supplierNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  // late WarpSupplierSingleYarnRateController controller;

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
    return GetBuilder<WarpSupplierSingleYarnRateController>(
        builder: (controller) {
      // this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Warp Supplier Single Yarn Rate"),
        ),
        // bindings: {
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () => Get.back(),
        //   const SingleActivator(LogicalKeyboardKey.keyN, control: true): () => _addItem(),
        //   const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
        //       submit(),
        // },
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ,control: true): GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS,control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyN,control: true): AddNewIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            AddNewIntent: SetCounterAction(perform: () {
              _addItem();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
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
                                      enabled: false,
                                    ),
                                  ),

                                  MyAutoComplete(
                                    label: 'Supplier Name',
                                    items: controller.ledger_dropdown,
                                    selectedItem: supplier_name.value,
                                    onChanged: (LedgerModel item) {
                                      supplier_name.value = item;
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: AddItemsElevatedButton(
                                  onPressed: () async => _addItem(),
                                  child: const Text('Add Item'),
                                ),
                              ),
                              SizedBox(height: 12),
                              ItemsTable(),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MySubmitButton(
                                    onPressed: () => submit(),
                                    //child: Text("${Get.arguments == null ? 'Save' : 'Update'}"),
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
        ),
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      WarpSupplierSingleYarnRateController controller = Get.find();
      Map<String, dynamic> request = {
        "supplier_id": supplier_name.value?.id,
      };

      dynamic totalRate = 0;
      for (var i = 0; i < itemList.length; i++) {
        request['yarn_id[$i]'] = itemList[i]['yarn_id'];
        request['length_type[$i]'] = itemList[i]['length_type'];
        request['yarn_length[$i]'] = itemList[i]['yarn_length'];
        request['rate[$i]'] = itemList[i]['rate'];
        totalRate += itemList[i]['rate'];
      }
      request['yarn_rate_total'] = totalRate;
      print(jsonEncode(request));
      var id = idController.text;
      if (id.isEmpty) {
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.addNewSingleWarp(requestPayload);
      } else {
        request['_method'] = 'PUT';
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.updateNewSingleWarp(requestPayload, id);
      }
    }
  }

  void _initValue() {
    WarpSupplierSingleYarnRateController controller = Get.find();
    controller.request = <String, dynamic>{};

    if (Get.arguments != null) {
      var warp =
          WarpSupplierSingleYarnRateModel.fromJson(Get.arguments['item']);

      idController.text = '${warp.id}';

      var supplierId = controller.ledger_dropdown
          .where((element) => '${element.id}' == '${warp.supplierId}')
          .toList();
      if (supplierId.isNotEmpty) {
        supplier_name.value = supplierId.first;
        supplierNameController.text = '${supplierId.first.ledgerName}';
      }

      warp.itemDetails?.forEach((element) {
        var request = element.toJson();
        itemList.add(request);
        // print(request);
      });
    }
    initTotal();
  }

  void initTotal() {
    double amountTotal = 0.0;

    for (var i = 0; i < itemList.length; i++) {
      amountTotal += itemList[i]['rate'] ?? 0.0;
    }
    totalSingleYarnRateController.text = '$amountTotal';
  }

  Widget ItemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'yarn_name',
          label: const MyDataGridHeader(title: 'Yarn Name'),
        ),
        GridColumn(
          columnName: 'yarn_length',
          label: const MyDataGridHeader(title: 'Length'),
        ),
        GridColumn(
          columnName: 'rate',
          label: const MyDataGridHeader(title: 'Single Yarn Rate (Rs)'),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'rate',
              columnName: 'rate',
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
            const WarpSupplierSingleYarnRateItemBottomsheet(),
            arguments: {'item': item});
        // if (result['item'] == 'delete') {
        //   itemList.removeAt(index);
        //   dataSource.updateDataGridRows();
        //   dataSource.updateDataGridSource();
        // } else if (result != null) {
        //   itemList[index] = result;
        //   dataSource.updateDataGridRows();
        //   dataSource.updateDataGridSource();
        // }
      },
    );
  }

  void _addItem() async {
    var result = await Get.to(WarpSupplierSingleYarnRateItemBottomsheet());
    if (result != null) {
      itemList.add(result);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    }
  }

//testCalculation function
  dynamic testCalculation() async {
    TextEditingController lengthController = TextEditingController();
    TextEditingController warpDesignController = TextEditingController();

    final formKey = GlobalKey<FormState>();
    //test calculation
    submit() {}

    var result = await showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        constraints: const BoxConstraints(
          maxWidth: 800,
        ),
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.90,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add Item',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Form(
                    key: formKey,
                    child: Wrap(
                      children: [
                        MyTextField(
                          controller: warpDesignController,
                          hintText: "Warp Design",
                          validate: "Number",
                        ),
                        MyTextField(
                          controller: lengthController,
                          hintText: "Length",
                          validate: "Number",
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      MyCloseButton(
                        onPressed: () => Get.back(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
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
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e['yarn_name']),
        DataGridCell<dynamic>(
            columnName: 'yarn_length', value: e['yarn_length']),
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
