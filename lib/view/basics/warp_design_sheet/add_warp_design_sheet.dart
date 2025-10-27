import 'package:abtxt/model/WarpDesignSheetModel.dart';
import 'package:abtxt/utils/constant.dart';
import 'package:abtxt/view/basics/warp_design_sheet/warp_design_bottomSheet.dart';
import 'package:abtxt/view/basics/warp_design_sheet/warp_design_sheet_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../adjustments/alternative_warp_design/alternative_warp_design_list.dart';

class AddWarpDesignSheet extends StatefulWidget {
  const AddWarpDesignSheet({Key? key}) : super(key: key);
  static const String routeName = '/add_warp_design_sheet';

  @override
  State<AddWarpDesignSheet> createState() => _State();
}

class _State extends State<AddWarpDesignSheet> {
  TextEditingController idController = TextEditingController();
  TextEditingController designSheetController = TextEditingController();
  TextEditingController activeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late WarpDesignSheetController controller;
  // var warpDesignList = <dynamic>[].obs;

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
    return GetBuilder<WarpDesignSheetController>(builder: (controller) {
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
                "${idController.text == '' ? 'Add' : 'Update'} Warp Design Sheet"),
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
                                MyTextField(
                                  controller: designSheetController,
                                  hintText: "Design Sheet",
                                  validate: "string",
                                ),
                                MyDropdownButtonFormField(
                                  controller: activeController,
                                  hintText: "Is Active",
                                  items: Constants.ISACTIVE,
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
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 180,
                                  child: MyElevatedButton(
                                    color: Color(0xFF00BDC9),
                                    onPressed: () {

                                    },
                                    child: Text('Create Group'),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 180,
                                  child: MyElevatedButton(
                                    color:Color(0xFF8F8F8F),
                                    onPressed: () {
                                     // submit();
                                    },
                                    child: Text('Cancel Group'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 180,
                                  child: MyElevatedButton(
                                    color: Color(0xFFDF30B8),
                                    onPressed: () {

                                    },
                                    child: Text('Repeat Item'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: Get.arguments != null,
                                  child: MyElevatedButton(
                                    color: Colors.red,
                                    onPressed: () async {
                                      var id = idController.text;
                                      WarpDesignSheetController controller =
                                      Get.find();
                                      await controller.deleteWarpDesignSheet(id);
                                    },
                                    child: const Text('DELETE'),
                                  ),
                                ),
                                MyCloseButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Close'),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                MyElevatedButton(
                                  onPressed: () => submit(),
                                  child: Text(
                                      Get.arguments == null ? 'Save' : 'Update'),
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
      Map<String, dynamic> request = {
        "design_name": designSheetController.text,
        "active_status": activeController.text,
      };

      print(request);
      var id = idController.text;
      if (id.isEmpty) {
       // controller.addWarpDesignSheet(request);
      } else {
        request['id'] = '$id';
      //  controller.updateWarpDesignSheet(request, id);
      }

      print(request);
    }
  }

  void _initValue() {
    activeController.text = Constants.ISACTIVE[0];

    if (Get.arguments != null) {
      WarpDesignSheetModel val = Get.arguments['item'];
      idController.text = '${val.id}';
      designSheetController.text = '${val.designName}';
      activeController.text = '${val.activeStatus}';
    }
  }
  Widget ItemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'yarn_name',
          label: const MyDataGridHeader(title: 'Yarn Name'),
        ),
        GridColumn(
          columnName: 'color_name',
          label: const MyDataGridHeader(title: 'Color'),
        ),
        GridColumn(
          columnName: 'ends',
          label: const MyDataGridHeader(title: 'Ends'),
        ),
        // GridColumn(
        //   columnName: 'no_of_ends',
        //   label: const MyDataGridHeader(title: ' '),
        // ),
        // GridColumn(
        //   columnName: 'no_of_ends',
        //   label: const MyDataGridHeader(title: ' '),
        // ),
        GridColumn(
          columnName: 'hint',
          label: const MyDataGridHeader(title: 'Hints'),
        ),

      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'ends',
              columnName: 'ends',
              summaryType: GridSummaryType.sum,
            ),

          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSource,
      onRowSelected: (index) async {
        var item = itemList[index];
        var result = await Get.to(const WarpDesignBottomSheet(),
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
    var result = await Get.to(WarpDesignBottomSheet());
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
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e['yarn_name']),
        DataGridCell<dynamic>(columnName: 'color_name', value: e['color_name']),
        DataGridCell<dynamic>(columnName: 'ends', value: e['ends']),
        DataGridCell<dynamic>(columnName: 'hint', value: e['hint']),

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

