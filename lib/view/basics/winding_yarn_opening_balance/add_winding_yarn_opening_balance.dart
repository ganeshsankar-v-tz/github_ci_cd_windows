import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/winding_yarn_opening_balance_model.dart';
import 'package:abtxt/view/basics/ledger/addledger.dart';
import 'package:abtxt/view/basics/winding_yarn_opening_balance/winding_yarn_opening_balance_delivered_bottomsheet.dart';
import 'package:abtxt/view/basics/winding_yarn_opening_balance/winding_yarn_opening_balance_expected_bottomsheet.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../widgets/CountTextField.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../adjustments/alternative_warp_design/alternative_warp_design_list.dart';
import '../../adjustments/yarn_stock_adjustment/add_yarn_stock_.dart';
import 'winding_yarn_opening_balance_controller.dart';

class AddWindingYarnOpeningBalance extends StatefulWidget {
  const AddWindingYarnOpeningBalance({Key? key}) : super(key: key);
  static const String routeName = '/add_winding_yarn';

  @override
  State<AddWindingYarnOpeningBalance> createState() => _State();
}

class _State extends State<AddWindingYarnOpeningBalance> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> winderName = Rxn<LedgerModel>();
  TextEditingController winderNameController = TextEditingController();
  TextEditingController recordNoController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController totalPackController = TextEditingController();
  TextEditingController totalQtyController = TextEditingController();
  TextEditingController totalexQtyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late WindingYarnOpeningBalanceController controller;
  // var deliveredYarnList = <dynamic>[].obs;
  // var expectedYarnList = <dynamic>[].obs;


  var deliveredYarnList = <dynamic>[];
  var expectedYarnList = <dynamic>[];

  late ItemDataSource dataSource;
  late ExItemDataSource ExdataSource;



  @override
  void initState() {
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: deliveredYarnList);
    ExdataSource = ExItemDataSource(Exlist: expectedYarnList);

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WindingYarnOpeningBalanceController>(
        builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Winding Yarn Opening Balance"),
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
              child: Column(
                children: [
                  Row(
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
                                      labelText: 'Winder Name',
                                      controller: winderNameController,
                                      list: controller.ledger_dropdown,
                                      showCreateNew: true,
                                      onItemSelected: (LedgerModel item) {
                                        winderNameController.text =
                                        '${item.ledgerName}';
                                        winderName.value = item;
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
                                      controller: recordNoController,
                                      hintText: "Record No",
                                      validate: "String",
                                    ),
                                    MyTextField(
                                      controller: detailController,
                                      hintText: "Details",
                                      validate: "String",
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 35),
                                /*Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * .5,
                                      child: Row(children: [
                                        const Text(
                                          'Delivered Yarn',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.black),
                                        ),
                                        Spacer(),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: AddItemsElevatedButton(
                                            width: 135,
                                            onPressed: () async {
                                              var result =
                                                  await deliveredYarnItemDialog();
                                              print("result: ${result.toString()}");
                                              if (result != null) {
                                                deliveredYarnList.add(result);
                                                initTotal();
                                              }
                                            },
                                            child: const Text('Add Item'),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ]),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      width: MediaQuery.of(context).size.width * .4,
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Expected Yarn',
                                            style: TextStyle(
                                                fontSize: 16, color: Colors.black),
                                          ),
                                          Spacer(),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: AddItemsElevatedButton(
                                              width: 135,
                                              onPressed: () async {
                                                var result =
                                                    await expectedYarnItemDialog();
                                                print("result: ${result.toString()}");
                                                if (result != null) {
                                                  expectedYarnList.add(result);
                                                  initTotal();
                                                }
                                              },
                                              child: const Text('Add Item'),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    )
                                  ],
                                ),*/
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(child: deliveredYarnItems()),
                                    SizedBox(width: 12),
                                    Flexible(child: expectedYarnItems()),
                                  ],
                                ),
                                const SizedBox(height: 60),
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
                                        onPressed: () {
                                          submit();
                                        },
                                        child: Text(Get.arguments == null
                                            ? 'Save'
                                            : 'Update'),
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
        "winder_id": winderName.value?.id,
        "record_no": recordNoController.text,
        "details": detailController.text,
      };
      dynamic deliTotalPack = 0;
      dynamic deliTotalQty = 0;
      for (var i = 0; i < deliveredYarnList.length; i++) {
        request['de_yarn_id[$i]'] = deliveredYarnList[i]['de_yarn_id'];
        request['de_yarn_name[$i]'] = deliveredYarnList[i]['de_yarn_name'];
        request['de_colour_id[$i]'] = deliveredYarnList[i]['de_colour_id'];
        request['de_color_name[$i]'] = deliveredYarnList[i]['de_color_name'];
        request['de_pack[$i]'] = deliveredYarnList[i]['de_pack'];
        request['de_qty[$i]'] = deliveredYarnList[i]['de_qty'];
        // deliTotalPack += deliveredYarnList[i]['de_pack'];
        // deliTotalQty += deliveredYarnList[i]['de_qty'];
      }
      request['de_total_pack'] = deliTotalPack;
      request['de_total_qty'] = deliTotalQty;

      dynamic exepTotalQty = 0;

      for (var i = 0; i < expectedYarnList.length; i++) {
        request['ex_yarn_id[$i]'] = expectedYarnList[i]['ex_yarn_id'];
        request['ex_yarn_name[$i]'] = expectedYarnList[i]['ex_yarn_name'];
        request['ex_qty[$i]'] = expectedYarnList[i]['ex_qty'];
        // exepTotalQty += expectedYarnList[i]['ex_qty'];
      }
      request['ex_total_qty'] = exepTotalQty;

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
    WindingYarnOpeningBalanceController controller = Get.find();
    if (Get.arguments != null) {
      WindingYarnOpeningBalanceModel winding = Get.arguments['item'];
      idController.text = '${winding.id}';
      var myList = controller.ledger_dropdown
          .where((element) => '${element.id}' == '${winding.winderId}')
          .toList();
      if (myList.isNotEmpty) {
        winderName.value = myList.first;
        winderNameController.text = '${myList.first.ledgerName}';
      }
      recordNoController.text = '${winding.recordNo}';
      detailController.text = '${winding.details}';

      winding.deliveredDetails?.forEach((element) {
        // var request = {
        //   "de_yarn_id": "${element.deYarnId}",
        //   "de_yarn_name": "${element.deYarnName}",
        //   "de_colour_id": "${element.deColourId}",
        //   "de_color_name": "${element.deColorName}",
        //   "de_pack": "${element.dePack}",
        //   "de_qty": "${element.deQty}",
        // };
        var request = element.toJson();
        deliveredYarnList.add(request);
      });
      winding.expectedDetails?.forEach((element) {
        // var request = {
        //   "ex_yarn_id": "${element.exYarnId}",
        //   "ex_yarn_name": "${element.exYarnName}",
        //   "ex_qty": "${element.exQty}",
        // };
        var request = element.toJson();
        expectedYarnList.add(request);
      });
    }

  }


  Widget deliveredYarnItems() {

    return  Container(
      color: const Color(0xFFF4F2FF),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      Container(
      padding: const EdgeInsets.all(12),
      child: Row(children: [
        const Text(
          'Delivered Yarn',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: AddItemsElevatedButton(
            width: 135,
            onPressed: () async {
              _addDeliveredItem();
            },
            child: const Text('Add Item'),
          ),
        ),
        const SizedBox(height: 20),
      ]),
    ),


      MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'de_yarn_name',
          label: const MyDataGridHeader(title: 'Yarn Name'),
        ),
        GridColumn(
          columnName: 'de_color_name',
          label: const MyDataGridHeader(title: 'Color Name'),
        ),
        GridColumn(
          columnName: 'de_pack',
          label: const MyDataGridHeader(title: 'Pack'),
        ),
        GridColumn(
          columnName: 'de_qty',
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
              name: 'de_pack',
              columnName: 'de_pack',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'de_qty',
              columnName: 'de_qty',
              summaryType: GridSummaryType.sum,
            ),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSource,
      onRowSelected: (index) async {
        var item = deliveredYarnList[index];
        var result = await Get.to(const WindingYarnOpeningBalanceDeliveredBottomSheet(),
            arguments: {'item': item});
        if (result['item'] == 'delete') {
          deliveredYarnList.removeAt(index);
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        } else if (result != null) {
          deliveredYarnList[index] = result;
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        }
      },
    ),
   ] ),
    );
  }


  void _addDeliveredItem() async {
    var result = await Get.to(WindingYarnOpeningBalanceDeliveredBottomSheet());
    if (result != null) {
      deliveredYarnList.add(result);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    }
  }

  Widget expectedYarnItems() {
    return Container(
      color: const Color(0xFFF4F2FF),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      Container(
      padding: const EdgeInsets.all(12),
      child: Row(children: [
        const Text(
          'Expected Yarn',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: AddItemsElevatedButton(
            width: 135,
            onPressed: () async {
              _addExpectedItem();
            },
            child: const Text('Add Item'),
          ),
        ),
        const SizedBox(height: 20),
      ]),
    ),


      MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'ex_yarn_name',
          label: const MyDataGridHeader(title: 'Yarn Name'),
        ),
        GridColumn(
          columnName: 'ex_qty',
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
              name: 'ex_qty',
              columnName: 'ex_qty',
              summaryType: GridSummaryType.sum,
            ),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: ExdataSource,
      onRowSelected: (index) async {
        var item = expectedYarnList[index];
        var result = await Get.to(const WindingYarnOpeningBalanceExpectedBottomSheet(),
            arguments: {'item': item});
        if (result['item'] == 'delete') {
          expectedYarnList.removeAt(index);
          ExdataSource.updateDataGridRows();
          ExdataSource.updateDataGridSource();
        } else if (result != null) {
          expectedYarnList[index] = result;
          ExdataSource.updateDataGridRows();
          ExdataSource.updateDataGridSource();
        }
      },
    ),]
      ),);
  }

  void _addExpectedItem() async {
    var result = await Get.to(WindingYarnOpeningBalanceExpectedBottomSheet());
    if (result != null) {
      expectedYarnList.add(result);
      ExdataSource.updateDataGridRows();
      ExdataSource.updateDataGridSource();
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
        DataGridCell<dynamic>(columnName: 'de_yarn_name', value: e['de_yarn_name']),
        DataGridCell<dynamic>(columnName: 'de_color_name', value: e['de_color_name']),
        DataGridCell<dynamic>(columnName: 'de_pack', value: e['de_pack']),
        DataGridCell<dynamic>(columnName: 'de_qty', value: e['de_qty']),

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
class ExItemDataSource extends DataGridSource {
  ExItemDataSource({required List<dynamic> Exlist}) {
    _exlist = Exlist;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _exlist;

  void updateDataGridRows() {
    dataGridRow = _exlist.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'ex_yarn_name', value: e['ex_yarn_name']),
        DataGridCell<dynamic>(columnName: 'ex_qty', value: e['ex_qty']),


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


