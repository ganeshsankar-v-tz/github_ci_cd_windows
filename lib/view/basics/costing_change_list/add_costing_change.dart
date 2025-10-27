import 'package:abtxt/model/CostingChangeHeaderValuesModel.dart';
import 'package:abtxt/view/basics/costing_change_list/costing_change_list_controller.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';

class AddCostingChange extends StatefulWidget {
  const AddCostingChange({Key? key}) : super(key: key);
  static const String routeName = '/AddCostingChange';

  @override
  State<AddCostingChange> createState() => _State();
}

class _State extends State<AddCostingChange> {
  TextEditingController idController = TextEditingController();
  TextEditingController newValueController = TextEditingController();
  TextEditingController headersController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late CostingChangeListController controller;

  var itemList = <CostingChangeHeaderValuesModel>[];
  late ItemDataSource dataSource;

  @override
  void initState() {
    _initValue();
    super.initState();
    dataSource = ItemDataSource(
      list: itemList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CostingChangeListController>(builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close',
            () => Get.back(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Costing Change"),
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
                                MyDialogList(
                                  labelText: 'Header',
                                  controller: headersController,
                                  list: controller.headers,
                                  showCreateNew: false,
                                  onItemSelected:
                                      (CostingChangeHeadersModel item) {
                                    headersController.text = '${item.header}';
                                  },
                                  onCreateNew: (value) async {},
                                ),
                                MyTextField(
                                  controller: newValueController,
                                  hintText: "New Value (Rs)",
                                  validate: "double",
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                    width: 140,
                                    height: 40,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0))),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    const Color(0xFFF643CF))),
                                        onPressed: () async {
                                          newRate();
                                        },
                                        child: const Text(
                                          "Change",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                )
                              ],
                            ),
                            // SizedBox(height: 12),
                            // Align(
                            //   alignment: Alignment.centerRight,
                            //   child: IconButton(
                            //     iconSize: 42,
                            //     icon: const Icon(Icons.add),
                            //     onPressed: () async {
                            //       var result = await CostingEntryItemDialog();
                            //       print("result: ${result.toString()}");
                            //       if (result != null) {
                            //         CostingchangeList.add(result);
                            //       }
                            //     },
                            //   ),
                            // ),
                            const SizedBox(
                              height: 20,
                            ),

                            ItemsTable(),
                            const SizedBox(height: 48),
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
                                    onPressed: () {
                                      submit();
                                    },
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

  void _initValue() {
    newValueController.text = "0";
  }

  Future<void> newRate() async {
    var header = headersController.text;
    var newValue = newValueController.text;
    var list = await controller.changeCostingValue(header, newValue);
    itemList.clear();
    itemList.addAll(list);
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
  }

  Widget ItemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          width: 50,
          columnName: 's_no',
          label: const MyDataGridHeader(title: 'S.No'),
        ),
        GridColumn(
          columnName: 'cost_date',
          label: const MyDataGridHeader(title: 'Cost Date'),
        ),
        GridColumn(
          columnName: 'product_name',
          label: const MyDataGridHeader(title: 'Product Name'),
        ),
        GridColumn(
          columnName: 'design_no',
          label: const MyDataGridHeader(title: 'Design No'),
        ),
        GridColumn(
          columnName: 'quantity',
          label: const MyDataGridHeader(title: 'Quantity'),
        ),
        GridColumn(
          columnName: 'rate_wages',
          label: const MyDataGridHeader(title: 'Rate/Wages (Rs)'),
        ),
        GridColumn(
          columnName: 'old_rate',
          label: const MyDataGridHeader(title: 'Old Rate'),
        ),
        GridColumn(
          columnName: 'new_rate',
          label: const MyDataGridHeader(title: 'New Rate'),
        ),
        GridColumn(
          columnName: 'difference',
          label: const MyDataGridHeader(title: 'Difference'),
        ),
      ],
      source: dataSource,
    );
  }

  void submit() {
    var header = headersController.text;
    var newValue = newValueController.text;
    controller.add(header, newValue);
  }
}

class ItemDataSource extends DataGridSource {
  ItemDataSource({
    required List<CostingChangeHeaderValuesModel> list,
  }) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<CostingChangeHeaderValuesModel> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 's_no', value: ""),
        DataGridCell<dynamic>(columnName: 'cost_date', value: e.costingDate),
        DataGridCell<dynamic>(columnName: 'product_name', value: e.productName),
        DataGridCell<dynamic>(columnName: 'design_no', value: e.designNo),
        DataGridCell<dynamic>(columnName: 'quantity', value: e.quantity),
        DataGridCell<dynamic>(columnName: 'rate_wages', value: e.rateWages),
        DataGridCell<dynamic>(columnName: 'old_rate', value: e.sglUnitCost),
        DataGridCell<dynamic>(columnName: 'new_rate', value: e.newRate),
        DataGridCell<dynamic>(columnName: 'difference', value: e.diffrent),
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
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
