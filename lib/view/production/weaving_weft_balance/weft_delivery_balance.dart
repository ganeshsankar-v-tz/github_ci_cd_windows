import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/production/weaving_weft_balance/weaving_weft_balance_controller.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/weaving_models/weft_balance/OverAllWeftBalanceModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridItemTable.dart';

class WeftDeliveryBalance extends StatefulWidget {
  const WeftDeliveryBalance({super.key});

  static const String routeName = '/weft_delivery_balance';

  @override
  State<WeftDeliveryBalance> createState() => _State();
}

class _State extends State<WeftDeliveryBalance> {
  Rxn<LoomNoModel> loomDetails = Rxn<LoomNoModel>();
  TextEditingController weaverNameController = TextEditingController();
  TextEditingController deliveredQtyController =
      TextEditingController(text: "0");
  TextEditingController receivedQtyController =
      TextEditingController(text: "0");
  TextEditingController balanceQtyController = TextEditingController(text: "0");
  TextEditingController deliveredLengthController =
      TextEditingController(text: "0.00");
  TextEditingController receivedLengthController =
      TextEditingController(text: "0.00");
  TextEditingController balanceLengthController =
      TextEditingController(text: "0.00");

  WeavingWeftBalanceController controller =
      Get.put(WeavingWeftBalanceController());

  late YarnDataSource yarnDataSource;
  late OtherWarpDataSource otherWarpDataSource;

  int? weaverId;

  var yarnItemList = <dynamic>[];
  var otherWarpItemList = <dynamic>[];

  @override
  void initState() {
    _initValue();
    super.initState();
    yarnDataSource = YarnDataSource(list: yarnItemList);
    otherWarpDataSource = OtherWarpDataSource(list: otherWarpItemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeavingWeftBalanceController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text("Weft Delivery Balance"),
          actions: const [],
        ),
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
        },
        loadingStatus: controller.status.isLoading,
        child: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  child: yarnDetails(),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "( Other ) - Warp Balance",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      warpBalanceItemsTable()
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      );
    });
  }

  void _apiCall() async {
    var loomNo = loomDetails.value?.subWeaverNo;
    yarnItemList.clear();
    yarnDataSource.updateDataGridRows();
    yarnDataSource.updateDataGridSource();
    otherWarpItemList.clear();
    otherWarpDataSource.updateDataGridRows();
    otherWarpDataSource.updateDataGridSource();
    deliveredQtyController.text = "0";
    receivedQtyController.text = "0";
    balanceQtyController.text = "0";

    if (weaverId == null || loomNo == null) {
      return;
    }

    /// Weft Balance Api Call
    Future<OverAllWeftBalanceModel?> item =
        controller.overAllWeftBalance(weaverId, loomNo);
    item.then((e) {
      e?.weftBalance?.forEach((e) {
        var request = e.toJson();
        yarnItemList.add(request);
        yarnDataSource.updateDataGridRows();
        yarnDataSource.updateDataGridSource();
      });
      deliveredQtyController.text = "${e?.productDetails?.deliveryQty}";
      receivedQtyController.text = "${e?.productDetails?.receviedQty}";
      balanceQtyController.text = "${e?.productDetails?.balanceQty}";
    });

    /// Other Warp Balance Api Call

    var data = controller.otherWarpBalance(weaverId, loomNo);
    data.then((e) {
      for (var i in e) {
        var request = i.toJson();
        otherWarpItemList.add(request);
        otherWarpDataSource.updateDataGridRows();
        otherWarpDataSource.updateDataGridSource();
      }
    });
  }

  void _initValue() async {
    if (Get.arguments != null) {
      weaverNameController.text = Get.arguments["weaver_name"];
      weaverId = Get.arguments["weaver_id"];

      /// Loom Api Call
      var result = await controller.loonNoDetails(weaverId);

      var loomList =
          result.where((element) => '${element.subWeaverNo}' == 'ALL').toList();
      if (loomList.isNotEmpty) {
        loomDetails.value = loomList.first;
      }

      /// Weft Balance Api Call
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _apiCall();
      });
    }
  }

  Widget yarnDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MyTextField(
              controller: weaverNameController,
              hintText: "Weaver",
              readonly: true,
            ),
            MyAutoComplete(
              label: 'Loom',
              items: controller.loomDropDown,
              selectedItem: loomDetails.value,
              onChanged: (LoomNoModel item) async {
                loomDetails.value = item;
                _apiCall();
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 3,
              child: yarnItemsTable(),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('Qty')),
                  DataColumn(label: Text('Length')),
                ],
                rows: [
                  DataRow(cells: [
                    const DataCell(Text("Delivered")),
                    DataCell(Text(deliveredQtyController.text)),
                    DataCell(Text(deliveredLengthController.text)),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text("Recieved")),
                    DataCell(Text(receivedQtyController.text)),
                    DataCell(Text(receivedLengthController.text)),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text("Balance")),
                    DataCell(Text(balanceQtyController.text)),
                    DataCell(Text(balanceLengthController.text)),
                  ]),
                ],
              ),
              /*child: Table(
                border: TableBorder.all(color: Colors.black12 ),
                children: [
                  const TableRow(
                    children: [
                      Text(''),
                      Text('Qty'),
                      Text('Length'),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Text('Delivered'),
                      Text('${deliveredQtyController.text}'),
                      Text('${deliveredLengthController.text}'),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Text('Recieved'),
                      Text('${receivedQtyController.text}'),
                      Text('${receivedLengthController.text}'),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Text('Balance'),
                      Text('${balanceQtyController.text}'),
                      Text('${balanceLengthController.text}'),
                    ],
                  )
                ],
              ),*/
              /*child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(""),
                      SizedBox(width: 85),
                      Text(
                        "Qty",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 85),
                      Text(
                        "Length",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Delivered",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 40),
                      MySmallTextField(
                        controller: deliveredQtyController,
                        readonly: true,
                      ),
                      const SizedBox(width: 20),
                      MySmallTextField(
                        controller: deliveredLengthController,
                        readonly: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Received",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 40),
                      MySmallTextField(
                        controller: receivedQtyController,
                        readonly: true,
                      ),
                      const SizedBox(width: 20),
                      MySmallTextField(
                        controller: receivedLengthController,
                        readonly: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        " Balance",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 40),
                      MySmallTextField(
                        controller: balanceQtyController,
                        readonly: true,
                      ),
                      const SizedBox(width: 20),
                      MySmallTextField(
                        controller: balanceLengthController,
                        readonly: true,
                      ),
                    ],
                  ),
                ],
              ),*/
            ),
          ],
        )
      ],
    );
  }

  Widget yarnItemsTable() {
    return MySFDataGridItemTable(
      scrollPhysics: const ScrollPhysics(),
      shrinkWrapRows: false,
      columns: [
        GridColumn(
          width: 250,
          columnName: 'yarn_name',
          label: const MyDataGridHeader(title: 'Yarn Name'),
        ),
        GridColumn(
          columnName: 'required',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Required'),
        ),
        GridColumn(
          columnName: 'delivered',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Delivered'),
        ),
        GridColumn(
          columnName: 'balance',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Balance'),
        ),
        GridColumn(
          columnName: 'used',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Used'),
        ),
        GridColumn(
          columnName: 'weaver_stock',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Weaver Stock'),
        ),
        GridColumn(
          columnName: 'unit',
          label: const MyDataGridHeader(title: ''),
        ),
      ],
      source: yarnDataSource,
    );
  }

  Widget warpBalanceItemsTable() {
    return MySFDataGridItemTable(
      scrollPhysics: const ScrollPhysics(),
      shrinkWrapRows: false,
      columns: [
        GridColumn(
          columnName: 'warp_design_name',
          label: const MyDataGridHeader(title: 'Warp Design'),
        ),
        GridColumn(
          columnName: 'delivered',
          label: const MyDataGridHeader(title: 'Delivered'),
        ),
        GridColumn(
          columnName: 'used',
          label: const MyDataGridHeader(title: 'Used'),
        ),
        GridColumn(
          columnName: 'weaver_stock',
          label: const MyDataGridHeader(title: 'Weaver Stock'),
        ),
        GridColumn(
          columnName: 'unit',
          label: const MyDataGridHeader(title: ''),
        ),
      ],
      source: otherWarpDataSource,
    );
  }
}

class YarnDataSource extends DataGridSource {
  YarnDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var reqYarn = "";
      var wevYarn = "";
      var balYarn = '';
      var useYarn = "";
      var delYarn = '';
      if (e["req_weft"] != 0) {
        reqYarn = e["req_weft"].toStringAsFixed(3);
      }
      if (e["deli_weft"] != 0) {
        delYarn = e["deli_weft"].toStringAsFixed(3);
      }
      if (e["bal_weft"] != 0) {
        balYarn = e["bal_weft"].toStringAsFixed(3);
      }
      if (e["use_weft"] != 0) {
        useYarn = e["use_weft"].toStringAsFixed(3);
      }
      if (e["wev_stock"] != 0) {
        wevYarn = e["wev_stock"].toStringAsFixed(3);
      }

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e["yarn_name"]),
        DataGridCell<dynamic>(columnName: 'required', value: reqYarn),
        DataGridCell<dynamic>(columnName: 'delivered', value: delYarn),
        DataGridCell<dynamic>(columnName: 'balance', value: balYarn),
        DataGridCell<dynamic>(columnName: 'used', value: useYarn),
        DataGridCell<dynamic>(columnName: 'weaver_stock', value: wevYarn),
        DataGridCell<dynamic>(columnName: 'unit', value: e["unit"]),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color? weaverStockText;
    Color? balanceText;

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      TextStyle? getTextStyle() {
        if (e.columnName == "weaver_stock") {
          return TextStyle(
            color: weaverStockText ?? Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.visible,
          );
        } else if (e.columnName == "balance") {
          return TextStyle(
            color: balanceText ?? Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.visible,
          );
        } else {
          return const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.visible,
          );
        }
      }

      Color getColor() {
        if (e.columnName == "balance") {
          double data = double.tryParse("${e.value}") ?? 0.0;

          if (data < 0) {
            balanceText = Colors.red;
          }
          return Colors.green.shade100;
        }

        if (e.columnName == "weaver_stock") {
          double data = double.tryParse("${e.value}") ?? 0.0;

          if (data < 0) {
            weaverStockText = Colors.red;
          }
          return Colors.yellow.shade100;
        }

        return Colors.transparent;
      }

      return Container(
        color: getColor(),
        padding: const EdgeInsets.all(8),
        alignment: (e.columnName == "yarn_name" || e.columnName == "unit")
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Text(
          e.value != null ? '${e.value}' : '',
          style: getTextStyle(),
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

class OtherWarpDataSource extends DataGridSource {
  OtherWarpDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var delivered = e["deliverd"];
      var used = e["used_qty"];
      var stock = e["weaver_stock"];

      return DataGridRow(cells: [
        DataGridCell<dynamic>(
            columnName: 'warp_design_name', value: e["warp_design_name"]),
        DataGridCell<dynamic>(
            columnName: 'delivered', value: delivered.toStringAsFixed(3)),
        DataGridCell<dynamic>(
            columnName: 'used', value: used.toStringAsFixed(3)),
        DataGridCell<dynamic>(
            columnName: 'weaver_stock', value: stock.toStringAsFixed(3)),
        DataGridCell<dynamic>(columnName: 'unit', value: e["length_type"]),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color? weaverStockText;

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      TextStyle? getTextStyle() {
        if (e.columnName == "weaver_stock") {
          return TextStyle(
            color: weaverStockText ?? Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.visible,
          );
        } else {
          return const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.visible,
          );
        }
      }

      Color getColor() {
        if (e.columnName == "weaver_stock") {
          double data = double.tryParse("${e.value}") ?? 0.0;

          if (data < 0) {
            weaverStockText = Colors.red;
          }

          return Colors.yellow.shade100;
        }

        return Colors.transparent;
      }

      return Container(
        color: getColor(),
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          e.value != null ? '${e.value}' : '',
          style: getTextStyle(),
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
