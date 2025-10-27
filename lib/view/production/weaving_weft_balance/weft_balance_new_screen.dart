import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/weaving_models/weft_balance/WeaverByWeftBalanceModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/production/weaving_weft_balance/private_weft_requirement/add_private_weft_requirements.dart';
import 'package:abtxt/view/production/weaving_weft_balance/weaving_weft_balance_controller.dart';
import 'package:abtxt/view/production/weaving_weft_balance/weft_delivery_balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/WeavingAccount.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyLabelTile.dart';
import '../../../widgets/MySFDataGridItemTable.dart';

class WeftBalanceNewScreen extends StatefulWidget {
  const WeftBalanceNewScreen({super.key});

  static const String routeName = '/weft_balance_new_screen';

  @override
  State<WeftBalanceNewScreen> createState() => _State();
}

class _State extends State<WeftBalanceNewScreen> {
  RxInt deliveredQty = RxInt(0);
  RxInt receivedQty = RxInt(0);
  RxInt balance = RxInt(0);
  String privateWeft = "No";

  WeavingWeftBalanceController controller =
      Get.put(WeavingWeftBalanceController());
  Rxn<WeavingAccount> weavingAccount = Rxn<WeavingAccount>();
  late ReqYarnDataSource reqYarnDataSource;
  late DeliveredYarnDataSource deliveredYarnDataSource;
  late DeliveredYarBalanceDataSource deliveredYarBalanceDataSource;
  late UsedYarnDataSource usedYarnDataSource;
  late WeaverYarnDataSource weaverYarnDataSource;

  var reqYarnItemList = <dynamic>[];
  var deliveredYarnItemList = <dynamic>[];
  var deliveredYarnBalanceItemList = <dynamic>[];
  var usedYarnItemList = <dynamic>[];
  var weaverYarnItemList = <dynamic>[];

  @override
  void initState() {
    reqYarnDataSource = ReqYarnDataSource(list: reqYarnItemList);
    deliveredYarnDataSource =
        DeliveredYarnDataSource(list: deliveredYarnItemList);
    deliveredYarBalanceDataSource =
        DeliveredYarBalanceDataSource(list: deliveredYarnBalanceItemList);
    usedYarnDataSource = UsedYarnDataSource(list: usedYarnItemList);
    weaverYarnDataSource = WeaverYarnDataSource(list: weaverYarnItemList);
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeavingWeftBalanceController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text("Weaving - WeftBalance"),
          actions: [
            Tooltip(
              message: 'Weft Refresh ( Ctrl+R )',
              child: ElevatedButton(
                onPressed: () {
                  weftDetailsRefresh();
                },
                child: const Text("Weft Refresh"),
              ),
            ),
            const SizedBox(width: 12),
            Tooltip(
              message: 'Over All Weft ( Ctrl+Alt+W )',
              child: ElevatedButton(
                onPressed: () {
                  _overAllWeft();
                },
                child: const Text("All Weft"),
              ),
            ),
            const SizedBox(width: 12),
            Visibility(
              visible: privateWeft != "No",
              child: Tooltip(
                message: 'Private Weft Requirement ( Alt + W )',
                child: ElevatedButton(
                  onPressed: () {
                    _privateWet();
                  },
                  child: const Text("Private Weft"),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyR, control: true): () =>
              weftDetailsRefresh(),
          const SingleActivator(LogicalKeyboardKey.keyW,
              control: true, alt: true): () => _overAllWeft(),
          const SingleActivator(LogicalKeyboardKey.keyW, alt: true): () =>
              _privateWet(),
        },
        loadingStatus: controller.status.isLoading,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Obx(
                        () => Visibility(
                          visible: weavingAccount.value != null,
                          child: Table(
                            border: TableBorder.all(
                              color: Colors.black12,
                            ),
                            children: [
                              TableRow(children: [
                                MyLabelTile(
                                  title:
                                      ('${weavingAccount.value?.weaverName}'),
                                  subtitle: ('Weaver Name'),
                                ),
                                MyLabelTile(
                                  title: '${weavingAccount.value?.loomNo}',
                                  subtitle: ('Loom No'),
                                ),
                                MyLabelTile(
                                  title: '${weavingAccount.value?.id}',
                                  subtitle: ('Weav No'),
                                ),
                                MyLabelTile(
                                  title:
                                      '${weavingAccount.value?.currentStatus}',
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
                    const SizedBox(width: 12),
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Delivered : ${deliveredQty.value}',
                              style: AppUtils.footerTextStyle()),
                          const SizedBox(height: 5),
                          Text('Received : ${receivedQty.value}',
                              style: AppUtils.footerTextStyle()),
                          const SizedBox(height: 5),
                          Text('Balance   :  ${balance.value}',
                              style: AppUtils.footerTextStyle())
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(child: reqYarnItemsTable()),
                    Flexible(child: deliveredYarnItemsTable()),
                    Flexible(child: deliveryBalanceItemsTable()),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(child: usedYarnItemsTable()),
                    Flexible(child: weaverYarnStockItemsTable()),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  void _initValue() async {
    WeavingAccount item = Get.arguments["weaving_account"];
    debugPrint("${Get.arguments}");
    privateWeft = item.privateWeft!;
    weavingAccount.value = item;

    _particularLoomWeftApiCall();

    /// Product Qty Details
    deliveredQty.value = Get.arguments["delivery_qty"];
    receivedQty.value = Get.arguments["receive_qty"];
    balance.value = Get.arguments["balance_qty"];
  }

  Widget reqYarnItemsTable() {
    return Container(
      padding: const EdgeInsets.all(4),
      color: const Color(0xFFBED7DC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Req. Yarn',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          MySFDataGridItemTable(
            scrollPhysics: const ScrollPhysics(),
            shrinkWrapRows: false,
            columns: [
              GridColumn(
                columnName: 'yarn_name',
                label: const MyDataGridHeader(title: 'Yarn Name'),
              ),
              GridColumn(
                width: 100,
                columnName: 'qty',
                label: const MyDataGridHeader(title: 'Qty'),
              ),
              GridColumn(
                width: 70,
                columnName: 'unit',
                label: const MyDataGridHeader(title: 'Unit'),
              ),
            ],
            source: reqYarnDataSource,
          ),
        ],
      ),
    );
  }

  Widget deliveredYarnItemsTable() {
    return Container(
      padding: const EdgeInsets.all(4),
      color: const Color(0xFFED9455),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivered Yarn',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          MySFDataGridItemTable(
            scrollPhysics: const ScrollPhysics(),
            shrinkWrapRows: false,
            columns: [
              GridColumn(
                columnName: 'yarn_name',
                label: const MyDataGridHeader(title: 'Yarn Name'),
              ),
              GridColumn(
                width: 80,
                columnName: 'qty',
                label: const MyDataGridHeader(title: 'Qty'),
              ),
              GridColumn(
                width: 70,
                columnName: 'unit',
                label: const MyDataGridHeader(title: 'Unit'),
              ),
              GridColumn(
                visible: false,
                width: 50,
                columnName: 'pack',
                label: const MyDataGridHeader(title: 'Pack'),
              ),
            ],
            source: deliveredYarnDataSource,
          ),
        ],
      ),
    );
  }

  Widget deliveryBalanceItemsTable() {
    return Container(
      padding: const EdgeInsets.all(4),
      color: const Color(0xFFE8DFCA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Balance',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          MySFDataGridItemTable(
            scrollPhysics: const ScrollPhysics(),
            shrinkWrapRows: false,
            columns: [
              GridColumn(
                columnName: 'yarn_name',
                label: const MyDataGridHeader(title: 'Yarn Name'),
              ),
              GridColumn(
                width: 100,
                columnName: 'qty',
                label: const MyDataGridHeader(title: 'Qty'),
              ),
              GridColumn(
                width: 70,
                columnName: 'unt',
                label: const MyDataGridHeader(title: 'Unit'),
              ),
            ],
            source: deliveredYarBalanceDataSource,
          ),
        ],
      ),
    );
  }

  Widget usedYarnItemsTable() {
    return Container(
      padding: const EdgeInsets.all(4),
      color: const Color(0xFFFFEC9E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Used Yarn',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          MySFDataGridItemTable(
            scrollPhysics: const ScrollPhysics(),
            shrinkWrapRows: false,
            columns: [
              GridColumn(
                columnName: 'yarn_name',
                label: const MyDataGridHeader(title: 'Yarn Name'),
              ),
              GridColumn(
                width: 80,
                columnName: 'qty',
                label: const MyDataGridHeader(title: 'Qty'),
              ),
              GridColumn(
                width: 70,
                columnName: 'unit',
                label: const MyDataGridHeader(title: 'Unit'),
              ),
            ],
            source: usedYarnDataSource,
          ),
        ],
      ),
    );
  }

  Widget weaverYarnStockItemsTable() {
    return Container(
      padding: const EdgeInsets.all(4),
      color: const Color(0xFF6AD4DD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weaver-Yarn Stock',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          MySFDataGridItemTable(
            scrollPhysics: const ScrollPhysics(),
            shrinkWrapRows: false,
            columns: [
              GridColumn(
                columnName: 'yarn_name',
                label: const MyDataGridHeader(title: 'Yarn Name'),
              ),
              GridColumn(
                width: 100,
                columnName: 'qty',
                label: const MyDataGridHeader(title: 'Qty'),
              ),
              GridColumn(
                width: 70,
                columnName: 'unt',
                label: const MyDataGridHeader(title: 'Unit'),
              ),
            ],
            source: weaverYarnDataSource,
          ),
        ],
      ),
    );
  }

  void _overAllWeft() {
    var weaverId = weavingAccount.value?.weaverId;
    var weaverName = weavingAccount.value?.weaverName;
    var request = {
      "weaver_id": weaverId,
      "weaver_name": weaverName,
    };

    if (weaverId == null) {
      return;
    }

    Get.toNamed(WeftDeliveryBalance.routeName, arguments: request);
  }

  void _privateWet() async {
    if (weavingAccount.value == null) {
      return;
    }

    var request = {
      "id": weavingAccount.value?.id,
      "product_id": weavingAccount.value?.productId,
      "loom": weavingAccount.value?.loomNo,
      "weaver_name": weavingAccount.value?.weaverName,
    };

    var result = await Get.toNamed(AddPrivateWeftRequirement.routeName,
        arguments: request);
    if (result == "success") {
      _particularLoomWeftApiCall();
    }
  }

  void _particularLoomWeftApiCall() async {
    reqYarnItemList.clear();
    reqYarnDataSource.updateDataGridRows();
    reqYarnDataSource.updateDataGridSource();

    deliveredYarnItemList.clear();
    deliveredYarnDataSource.updateDataGridRows();
    deliveredYarnDataSource.updateDataGridSource();

    deliveredYarnBalanceItemList.clear();
    deliveredYarBalanceDataSource.updateDataGridRows();
    deliveredYarBalanceDataSource.updateDataGridSource();

    usedYarnItemList.clear();
    usedYarnDataSource.updateDataGridRows();
    usedYarnDataSource.updateDataGridSource();

    weaverYarnItemList.clear();
    weaverYarnDataSource.updateDataGridRows();
    weaverYarnDataSource.updateDataGridSource();

    var weavingId = weavingAccount.value?.id;

    WeaverByWeftBalanceModel? result =
        await controller.weavingWftBalanceNew(weavingId);

    /// Required Yarn Details Add
    result?.requiredYarn?.forEach((e) {
      var request = e.toJson();
      reqYarnItemList.add(request);
      reqYarnDataSource.updateDataGridRows();
      reqYarnDataSource.updateDataGridSource();
    });

    /// Delivery Yarn Details Add
    result?.deliveryYarn?.forEach((e) {
      var request = e.toJson();
      deliveredYarnItemList.add(request);
      deliveredYarnDataSource.updateDataGridRows();
      deliveredYarnDataSource.updateDataGridSource();
    });

    /// Delivery Balance Details Add
    result?.deliveryBalance?.forEach((e) {
      var request = e.toJson();
      deliveredYarnBalanceItemList.add(request);
      deliveredYarBalanceDataSource.updateDataGridRows();
      deliveredYarBalanceDataSource.updateDataGridSource();
    });

    /// Used Yarn Details Add
    result?.usedYarn?.forEach((e) {
      var request = e.toJson();
      usedYarnItemList.add(request);
      usedYarnDataSource.updateDataGridRows();
      usedYarnDataSource.updateDataGridSource();
    });

    /// Weaver Yarn Stock Details Add
    result?.weaverYarnStock?.forEach((e) {
      var request = e.toJson();
      weaverYarnItemList.add(request);
      weaverYarnDataSource.updateDataGridRows();
      weaverYarnDataSource.updateDataGridSource();
    });
  }

  void weftDetailsRefresh() async {
    var weavingId = weavingAccount.value?.id;

    String? result = await controller.weavingWftBalanceRefresh(weavingId);
    if (result == "sucess") {
      _particularLoomWeftApiCall();
    }
  }
}

/// Required Yarn Details
class ReqYarnDataSource extends DataGridSource {
  ReqYarnDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var reqYarn = e["req_yarn"];

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e["yarn_name"]),
        DataGridCell<dynamic>(
            columnName: 'qty', value: reqYarn.toStringAsFixed(3)),
        DataGridCell<dynamic>(columnName: 'unit', value: e["unit"]),
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
        child: Text(
          dataGridCell.value != null ? '${dataGridCell.value}' : ' ',
          style: AppUtils.cellTextStyle(),
        ),
      );
    }).toList());
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}

/// Delivered Yarn Details
class DeliveredYarnDataSource extends DataGridSource {
  DeliveredYarnDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var qty = e["yarn_qty"];

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e["yarn_name"]),
        DataGridCell<dynamic>(columnName: 'qty', value: qty.toStringAsFixed(3)),
        DataGridCell<dynamic>(columnName: 'unit', value: e["unit"]),
        DataGridCell<dynamic>(columnName: 'pack', value: e["pck"]),
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
        child: Text(
          dataGridCell.value != null ? '${dataGridCell.value}' : ' ',
          style: AppUtils.cellTextStyle(),
        ),
      );
    }).toList());
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}

/// Delivered Yarn Balance Details
class DeliveredYarBalanceDataSource extends DataGridSource {
  DeliveredYarBalanceDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var balQty = e["balance_yarn"];

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e["yarn_name"]),
        DataGridCell<dynamic>(
            columnName: 'qty', value: balQty.toStringAsFixed(3)),
        DataGridCell<dynamic>(columnName: 'unit', value: e["unit"]),
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
        child: Text(
          dataGridCell.value != null ? '${dataGridCell.value}' : ' ',
          style: AppUtils.cellTextStyle(),
        ),
      );
    }).toList());
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}

/// Used Yarn Details
class UsedYarnDataSource extends DataGridSource {
  UsedYarnDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var qty = e["used_yarn"];

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e["yarn_name"]),
        DataGridCell<dynamic>(columnName: 'qty', value: qty.toStringAsFixed(3)),
        DataGridCell<dynamic>(columnName: 'unit', value: e["unit"]),
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
        child: Text(
          dataGridCell.value != null ? '${dataGridCell.value}' : ' ',
          style: AppUtils.cellTextStyle(),
        ),
      );
    }).toList());
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}

/// Weaver Yarn Stock Details
class WeaverYarnDataSource extends DataGridSource {
  WeaverYarnDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var qty = e["bal_stock_yarn"];

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e["yarn_name"]),
        DataGridCell<dynamic>(columnName: 'qty', value: qty.toStringAsFixed(3)),
        DataGridCell<dynamic>(columnName: 'unit', value: e["unit"]),
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
        child: Text(
          dataGridCell.value != null ? '${dataGridCell.value}' : ' ',
          style: AppUtils.cellTextStyle(),
        ),
      );
    }).toList());
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
