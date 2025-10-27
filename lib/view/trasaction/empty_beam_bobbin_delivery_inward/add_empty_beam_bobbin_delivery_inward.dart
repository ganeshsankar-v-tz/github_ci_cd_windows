import 'package:abtxt/model/EmptyBeamBobbinDeliveryInwardModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/utils/constant.dart';
import 'package:abtxt/view/trasaction/empty_beam_bobbin_delivery_inward/empty_beam_bobbin_delivery_inward_bottomsheeet.dart';
import 'package:abtxt/view/trasaction/empty_beam_bobbin_delivery_inward/empty_beam_bobbin_delivery_inward_controller.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
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
import '../../basics/ledger/addledger.dart';
import 'empty_beam_bobbin_delivery_inward_additem.dart';

class AddEmptyBeamBobbinDeliveryInward extends StatefulWidget {
  const AddEmptyBeamBobbinDeliveryInward({Key? key}) : super(key: key);
  static const String routeName = '/add_empty_beam_bobbin_delivery_inward';

  @override
  State<AddEmptyBeamBobbinDeliveryInward> createState() => _State();
}

class _State extends State<AddEmptyBeamBobbinDeliveryInward> {
  TextEditingController idController = TextEditingController();
  TextEditingController recordNoController = TextEditingController();
  TextEditingController entryTypeController = TextEditingController();
  TextEditingController transactionTypeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  Rxn<LedgerModel> from = Rxn<LedgerModel>();
  TextEditingController fromController = TextEditingController();
  TextEditingController beamController = TextEditingController();
  TextEditingController bobbinController = TextEditingController();
  TextEditingController sheetController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController totalCopsReelQtyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late EmptyBeamBobbinDeliveryInwardController controller;
//  var emptyBeamBobbinList = <dynamic>[].obs;

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
    return GetBuilder<EmptyBeamBobbinDeliveryInwardController>(
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
            'Add', () => additem(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Empty (Beam, Bobbin) Delivery / Inward"),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
              ),
              //height: Get.height,
              margin: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        //color: Colors.green,
                        padding: const EdgeInsets.all(16),
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
                                  controller: recordNoController,
                                  hintText: "Record No",
                                  validate: "number",
                                ),
                                MyDropdownButtonFormField(
                                    controller: entryTypeController,
                                    hintText: "Entry Type",
                                    items: Constants.entry),
                                MyDropdownButtonFormField(
                                    controller: transactionTypeController,
                                    hintText: "Transaction Type",
                                    items: Constants.transport),
                                MyDateField(
                                  controller: dateController,
                                  hintText: "Date",
                                  validate: "string",
                                  readonly: true,
                                ),
                              ],
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                MyDialogList(
                                  labelText: 'From',
                                  controller: fromController,
                                  list: controller.ledgerDropdown,
                                  showCreateNew: true,
                                  onItemSelected: (LedgerModel item) {
                                    fromController.text = '${item.ledgerName}';
                                    from.value = item;
                                    controller.request['from'] = item.id;
                                  },
                                  onCreateNew: (value) async {
                                    var item =
                                        await Get.toNamed(AddLedger.routeName);
                                    controller.onInit();
                                  },
                                ),
                                MyTextField(
                                  controller: beamController,
                                  hintText: "Beam",
                                  validate: "number",
                                ),
                                MyTextField(
                                  controller: bobbinController,
                                  hintText: "Bobbin",
                                  validate: "number",
                                ),
                                MyTextField(
                                  controller: sheetController,
                                  hintText: "Sheet",
                                  validate: "number",
                                ),
                                MyTextField(
                                  controller: detailController,
                                  hintText: "Details",
                                  validate: "string",
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Align(
                            //   alignment: Alignment.bottomRight,
                            //   child: AddItemsElevatedButton(
                            //     width: 135,
                            //     onPressed: () async {
                            //       var result = await emptyBeamBobbinDialog();
                            //       print("result: ${result.toString()}");
                            //       if (result != null) {
                            //         itemList.add(result);
                            //         initTotal();
                            //       }
                            //     },
                            //     child: const Text('Add Item'),
                            //   ),
                            // ),
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
                            const SizedBox(height: 12),
                            // emptyBeamBobbinItem(),
                            ItemsTable(),
                            const SizedBox(height: 12),
                            // Row(
                            //   children: [
                            //     Expanded(child: Container()),
                            //     SizedBox(
                            //       width: 170,
                            //       child: CountTextField(
                            //         controller: totalCopsReelQtyController,
                            //         hintText: "Total Cops Reel Qty",
                            //         readonly: true,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(height: 60),
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

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "record_no": recordNoController.text,
        "entry_type": entryTypeController.text,
        "transaction_type": transactionTypeController.text,
        "date": dateController.text,
        "from": from.value?.id,
        "beam": beamController.text,
        "bobbin": bobbinController.text,
        "sheet": sheetController.text,
        "details": detailController.text,
      };
      var emptyItemList = [];
      double total = 0.0;
      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "type": itemList[i]['type'],
          "cops_reel": itemList[i]['cops_reel'],
          "quantity": itemList[i]['quantity'],
        };
        // total += double.tryParse(itemList[i]['quantity']) ?? 0.0;
        emptyItemList.add(item);
      }
      request['quantity'] = total.toString();
      request['empty_item'] = emptyItemList;
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
    entryTypeController.text = Constants.entry[0];
    transactionTypeController.text = Constants.transport[0];

    if (Get.arguments != null) {
      EmptyBeamBobbinDeliveryInwardController controller = Get.find();
      EmptyBeamBobbinDeliveryInwardModel item = Get.arguments['item'];
      idController.text = '${item.id}';
      recordNoController.text = '${item.recordNo}';
      entryTypeController.text = '${item.entryType}';
      transactionTypeController.text = '${item.transactionType}';
      dateController.text = '${item.date}';
      beamController.text = '${item.beam}';
      bobbinController.text = '${item.bobbin}';
      sheetController.text = '${item.sheet}';
      detailController.text = '${item.details}';

      var myList = controller.ledgerDropdown
          .where((element) => '${element.id}' == '${item.from}')
          .toList();
      if (myList.isNotEmpty) {
        from.value = myList.first;
        controller.request['from'] = myList.first.id;
        fromController.text = '${myList.first.ledgerName}';
      }

      item.itemDetails?.forEach((element) {
        //
        var request = element.toJson();
        itemList.add(request);
      });
    }
    // initTotal();
  }

  // void initTotal() {
  //   var total = 0;
  //   for (var i = 0; i < itemList.length; i++) {
  //     total += int.tryParse(itemList[i]['quantity']) ?? 0;
  //   }
  //   totalCopsReelQtyController.text = '$total';
  // }

  Widget emptyBeamBobbinItem() {
    final ScrollController scrollView = ScrollController();

    return Obx(() => Container(
          width: Get.width,
          color: const Color(0xFFF4F2FF),
          child: Scrollbar(
            thumbVisibility: true,
            controller: scrollView,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: scrollView,
              child: DataTable(
                columnSpacing: 350,
                columns: const <DataColumn>[
                  DataColumn(
                      label: Text("Type", overflow: TextOverflow.ellipsis)),
                  DataColumn(
                      label: Text("Cops / Reel Name",
                          overflow: TextOverflow.ellipsis)),
                  DataColumn(
                      label: Text("Cops / Reel Qty",
                          overflow: TextOverflow.ellipsis)),
                  DataColumn(
                      label: Text("Action", overflow: TextOverflow.ellipsis)),
                ],
                rows: itemList.map((user) {
                  return DataRow(
                    cells: [
                      DataCell(Text('${user['type']}',
                          overflow: TextOverflow.ellipsis)),
                      DataCell(Text('${user['cops_reel']}',
                          overflow: TextOverflow.ellipsis)),
                      DataCell(Text('${user['quantity']}',
                          overflow: TextOverflow.ellipsis)),
                      DataCell(
                        IconButton(
                          iconSize: 24,
                          icon: Image.asset('assets/images/ic_delete1.png',
                              width: 18),
                          onPressed: () {
                            itemList.remove(user);
                            // initTotal();
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ));
  }

  Widget ItemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'type',
          label: const MyDataGridHeader(title: 'Type'),
        ),
        GridColumn(
          columnName: 'cops_reel',
          label: const MyDataGridHeader(title: 'Cops / Reel Name'),
        ),
        GridColumn(
          columnName: 'quantity',
          label: const MyDataGridHeader(title: 'Cops / Reel Qty'),
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
        var result = await Get.to(const empty_beam_bobbin_delivery_inward_additem(),
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
  void additem() async {
    var result = await Get.to(empty_beam_bobbin_delivery_inward_additem());
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
        DataGridCell<dynamic>(columnName: 'type', value: e['type']),
        DataGridCell<dynamic>(columnName: 'cops_reel', value: e['cops_reel']),
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
