import 'dart:convert';

import 'package:abtxt/model/WeavingAccount.dart';
import 'package:abtxt/model/WeavingWeftBalanceModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyLabelTile.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import 'weaving_weft_balance_controller.dart';

class WeavingWeftBalance extends StatefulWidget {
  const WeavingWeftBalance({
    Key? key,
  }) : super(key: key);

  static const String routeName = '/weft_balance';

  @override
  State<WeavingWeftBalance> createState() => _WeftItemBottomSheetState();
}

class _WeftItemBottomSheetState extends State<WeavingWeftBalance> {
  TextEditingController weaverNameController = TextEditingController();
  TextEditingController loomNoController = TextEditingController();
  TextEditingController weavNoController = TextEditingController();
  TextEditingController warpStatusController = TextEditingController();
  TextEditingController productController = TextEditingController();
  TextEditingController wagesController = TextEditingController();
  TextEditingController deliveredController = TextEditingController();
  TextEditingController receivedController = TextEditingController();
  TextEditingController balanceController = TextEditingController();

  var itemList = <WeavingWeftBalanceModel>[];
  late ItemDataSource dataSource;
  Rxn<WeavingAccount> weavingAccount = Rxn<WeavingAccount>();
  WeavingWeftBalanceController controller =
      Get.put(WeavingWeftBalanceController());

  @override
  void initState() {
    dataSource = ItemDataSource(list: itemList);
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeavingWeftBalanceController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(title: const Text('Weft Balance')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              /*Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        MyTextField(
                          controller: weaverNameController,
                          hintText: "Weaver Name",
                          validate: "string",
                        ),
                        MyTextField(
                          controller: loomNoController,
                          hintText: "Loom No",
                          validate: "string",
                        ),
                        MyTextField(
                          controller: weavNoController,
                          hintText: "Weav NO",
                          validate: "number",
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        MyTextField(
                          controller: warpStatusController,
                          hintText: "Warp Status",
                          validate: "string",
                        ),
                        MyTextField(
                          controller: productController,
                          hintText: "Product",
                          validate: "string",
                        ),
                        MyTextField(
                          controller: wagesController,
                          hintText: "Wages(Rs)/saree",
                          validate: "double",
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        MyTextField(
                          controller: deliveredController,
                          hintText: "Delivered",
                          validate: "number",
                        ),
                        MyTextField(
                          controller: receivedController,
                          hintText: "Received",
                          validate: "number",
                        ),
                        MyTextField(
                          controller: balanceController,
                          hintText: "Balance",
                          validate: "number",
                        ),
                      ],
                    ),
                  ),
                ],
              ),*/
              Obx(
                () => Visibility(
                  visible: weavingAccount.value != null,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Table(
                      border: TableBorder.all(color: Colors.black12),
                      children: [
                        TableRow(children: [
                          MyLabelTile(
                            title: ('${weavingAccount.value?.weaverName}'),
                            subtitle: ('Weaver Name'),
                          ),
                          MyLabelTile(
                            title: '${weavingAccount.value?.subWeaverNo}',
                            subtitle: ('Loom No'),
                          ),
                          MyLabelTile(
                            title: '${weavingAccount.value?.id}',
                            subtitle: ('Weav No'),
                          ),
                          MyLabelTile(
                            title: '${weavingAccount.value?.currentStatus}',
                            subtitle: ('Warp Status'),
                          ),
                        ]),
                        TableRow(children: [
                          MyLabelTile(
                            title: '${weavingAccount.value?.firmName}',
                            subtitle: ('Firm'),
                          ),
                          MyLabelTile(
                            title: '${weavingAccount.value?.productName}',
                            subtitle: ('Product'),
                          ),
                          MyLabelTile(
                            title: '${weavingAccount.value?.wages}',
                            subtitle: ('Wages (Rs)'),
                          ),
                          MyLabelTile(
                            title: '${weavingAccount.value?.unitLength}',
                            subtitle: ('Unit Length'),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              MySFDataGridItemTable(
                columns: [
                  GridColumn(
                    columnName: 'yarn_name',
                    label: const MyDataGridHeader(title: 'Yarn Name'),
                  ),
                  GridColumn(
                    columnName: 'required_yarn',
                    label: const MyDataGridHeader(title: 'Required Yarn'),
                  ),
                  GridColumn(
                    columnName: 'delivered_yarn',
                    label: const MyDataGridHeader(title: 'Delivered Yarn'),
                  ),
                  GridColumn(
                    columnName: 'balance_yarn',
                    label: const MyDataGridHeader(title: 'Balance Yarn'),
                  ),
                  GridColumn(
                    columnName: 'used_yarn',
                    label: const MyDataGridHeader(title: 'Used Yarn'),
                  ),
                  GridColumn(
                    columnName: 'weaver_yarn_stock',
                    label: const MyDataGridHeader(title: 'Weaver Yarn Stock'),
                  ),
                ],
                source: dataSource,
              ),
            ],
          ),
        ),
      );
    });
  }

  void _initValue() async {
    if (Get.arguments == null) {
      return;
    }

    WeavingAccount item = Get.arguments;
    weavingAccount.value = item;
    print(jsonEncode(item.toJson()));

    var id = item.id;
    var result = await controller.weavingWftBalance(id);
    itemList.clear();
    itemList.addAll(result);
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
  }
}

class ItemDataSource extends DataGridSource {
  ItemDataSource({required List<WeavingWeftBalanceModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<WeavingWeftBalanceModel> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e.yarnName),
        DataGridCell<dynamic>(columnName: 'required_yarn', value: e.reqYarn),
        DataGridCell<dynamic>(
            columnName: 'delivered_yarn', value: e.deliverdYarn),
        DataGridCell<dynamic>(
            columnName: 'balance_yarn', value: e.deliveryBalance),
        DataGridCell<dynamic>(columnName: 'used_yarn', value: e.usedYarn),
        DataGridCell<dynamic>(
            columnName: 'weaver_yarn_stock', value: e.weaverYarnStock),
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
