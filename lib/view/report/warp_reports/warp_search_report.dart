import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/report/warp_reports/warp_report_controller.dart';
import 'package:abtxt/widgets/MyFilterTextField.dart';
import 'package:abtxt/widgets/MySFDataGridItemTable.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/report_models/WarpSearchModel.dart';
import '../../../widgets/MyDataGridHeader.dart';

class WarpSearchReport extends StatefulWidget {
  const WarpSearchReport({super.key});

  static const String routeName = '/warp_search';

  @override
  State<WarpSearchReport> createState() => _State();
}

class _State extends State<WarpSearchReport> {
  TextEditingController warpNoController = TextEditingController();
  Rxn<WarpSearchModel?> warpResult = Rxn<WarpSearchModel>();

  WarpReportController controller = Get.put(WarpReportController());
  var itemList = <dynamic>[];
  late ItemDataSource dataSource;
  final FocusNode _firstInputFocusNode = FocusNode();

  @override
  void initState() {
    _initValue();
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_firstInputFocusNode);
    });
    dataSource = ItemDataSource(list: itemList);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      return GetBuilder<WarpReportController>(builder: (controller) {
        return CoreWidget(
          appBar: AppBar(title: const Text('Warp Search')),
          bindings: {
            const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
                Get.back(),
            const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
                warpDetailsDisplay(id: warpNoController.text),
          },
          loadingStatus: controller.status.isLoading,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      MyFilterTextField(
                        focusNode: _firstInputFocusNode,
                        autofocus: true,
                        controller: warpNoController,
                        hintText: "Warp No",
                        validate: "string",
                        suffixIcon: ExcludeFocusTraversal(
                          child: IconButton(
                            onPressed: () {
                              var warpId = warpNoController.text;
                              warpDetailsDisplay(id: warpId);
                            },
                            tooltip: "Search (Ctrl+S)",
                            icon: const Icon(Icons.search),
                          ),
                        ),
                        onFieldSubmitted: (value) {
                          warpDetailsDisplay(id: value);
                        },
                      ),
                      const SizedBox(width: 100),
                      Obx(
                        () => Text(
                          warpResult.value?.warpLable ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(
                          color: Colors.white,
                          child: Table(
                            border: TableBorder.all(color: Colors.black12),
                            children: [
                              TableRow(children: [
                                const Text('Warp From'),
                                Obx(
                                  () =>
                                      Text(warpResult.value?.ledgerName ?? ''),
                                ),
                              ]),
                              TableRow(children: [
                                const Text('Warp Design'),
                                Obx(
                                  () => Text(warpResult.value?.warpName ?? ''),
                                ),
                              ]),
                              TableRow(children: [
                                const Text('Details'),
                                Obx(
                                  () => Text(warpResult.value?.details ?? ''),
                                ),
                              ]),
                              TableRow(children: [
                                const Text('Empty Type'),
                                Obx(
                                  () => Text(warpResult.value?.emptyType ?? ''),
                                ),
                              ]),
                              TableRow(children: [
                                const Text('Sheet'),
                                Obx(
                                  () =>
                                      Text("${warpResult.value?.sheet ?? ''}"),
                                ),
                              ]),
                              TableRow(children: [
                                const Text('Ledger Name'),
                                Obx(
                                  () =>
                                      Text(warpResult.value?.ledgerName ?? ''),
                                ),
                              ]),
                              TableRow(children: [
                                const Text('Inward Date'),
                                Obx(
                                  () => Text(warpResult.value?.eDate ?? ''),
                                ),
                              ]),
                              TableRow(children: [
                                const Text('Weight'),
                                Obx(
                                  () =>
                                      Text("${warpResult.value?.weight ?? ''}"),
                                ),
                              ]),
                              TableRow(children: [
                                const Text('Product Qty'),
                                Obx(
                                  () => Text("${warpResult.value?.qty ?? ''}"),
                                ),
                              ]),
                              TableRow(children: [
                                const Text('Meter'),
                                Obx(
                                  () =>
                                      Text("${warpResult.value?.metre ?? ''}"),
                                ),
                              ]),
                              TableRow(children: [
                                const Text('Color'),
                                Obx(
                                  () => Text(warpResult.value?.warpColor ?? ''),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Column(
                          children: [
                            itemsTable(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }

  Widget itemsTable() {
    return MySFDataGridItemTable(
      source: dataSource,
      shrinkWrapRows: false,
      scrollPhysics: const ScrollPhysics(),
      columns: [
        GridColumn(
          columnName: 's_no',
          width: 80,
          label: const MyDataGridHeader(title: 'S.No'),
        ),
        GridColumn(
          width: 180,
          columnName: 'entry_type',
          label: const MyDataGridHeader(title: 'Entry'),
        ),
        GridColumn(
          width: 120,
          columnName: 'e_date',
          label: const MyDataGridHeader(title: 'Date'),
        ),
        GridColumn(
          width: 150,
          columnName: 'new_warp_id',
          label: const MyDataGridHeader(title: 'New Warp Id'),
        ),
        GridColumn(
          columnName: 'particulars',
          label: const MyDataGridHeader(title: 'Particulars'),
        ),
        GridColumn(
          width: 150,
          columnName: 'old_warp_id',
          label: const MyDataGridHeader(title: 'Old Warp Id'),
        ),
      ],
      onRowSelected: (index) async {
        var item = itemList[index];
        var warpId = item["new_warp_id"];

        if (item["new_warp_id"] != null) {
          warpNoController.text = warpId;
          warpDetailsDisplay(id: warpId);
        } else {
          AppUtils.showErrorToast(message: "Given 'Warp Id No' Is Invalid !");
        }
      },
    );
  }

  void warpDetailsDisplay({var id}) async {
    warpResult.value = null;
    itemList.clear();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();

    if (warpNoController.text.isNotEmpty) {
      /// Api Call
      WarpSearchModel? result = await controller.warpIdInfo(id);
      warpResult.value = result;
      //warpLableController.text =  "Warp Status : ${result?.warpLable ?? ''}";
      /// Set The Values to Controllers

      result?.warpTracking?.forEach((e) {
        var request = e.toJson();
        itemList.add(request);
        dataSource.updateDataGridRows();
        dataSource.updateDataGridSource();
      });
    } else {
      AppUtils.showErrorToast(message: "Enter The Warp No");
    }
  }

  _initValue() async {
    if (Get.arguments != null) {
      String warpId = Get.arguments;
      warpNoController.text = warpId;
      if (warpId.isNotEmpty) {
        itemList.clear();

        WarpSearchModel? result = await controller.warpIdInfo(warpId);
        warpResult.value = result;

        result?.warpTracking?.forEach((e) {
          var request = e.toJson();
          itemList.add(request);
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        });
      }
    }
  }
}

class ItemDataSource extends DataGridSource {
  ItemDataSource({
    required List<dynamic> list,
  }) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var index = _list.indexOf(e);

      var particulars = "";
      var loom = "";
      var currentStatus = "";
      var productName = "";
      var rollerName = "";
      var ledgerName = "${e["ledger_name"] ?? ''} ,";
      var warpName = "${e["warp_name"] ?? ''}";

      if (e["loom"] != null) {
        loom = "Loom ${e["loom"]} ,";
      }
      if (e["current_status"] != null) {
        currentStatus = "< ${e["current_status"]} >,";
      }
      if (e["product_name"] != null) {
        productName = "${e["product_name"]} ,";
      }
      if (e["roller_name"] != null) {
        rollerName = "${e["roller_name"]}";
      }

      if (e["entry_type"] == "Weaving Drop") {
        particulars = "$ledgerName$loom$warpName$productName";
      } else if (e["entry_type"] == "Weaving") {
        particulars = "$ledgerName$loom$currentStatus$productName$rollerName";
      } else {
        particulars = "$ledgerName  $warpName";
      }

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 's_no', value: "${index + 1}"),
        DataGridCell<dynamic>(columnName: 'entry_type', value: e["entry_type"]),
        DataGridCell<dynamic>(columnName: 'e_date', value: e["e_date"]),
        DataGridCell<dynamic>(
            columnName: 'new_warp_id', value: e["new_warp_id"]),
        DataGridCell<dynamic>(columnName: 'particulars', value: particulars),
        DataGridCell<dynamic>(
            columnName: 'old_warp_id', value: e["old_warp_id"]),
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
        child: SelectionArea(
          child: Text(
            dataGridCell.value != null ? "${dataGridCell.value}" : '',
          ),
        ),
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
        summaryValue,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
