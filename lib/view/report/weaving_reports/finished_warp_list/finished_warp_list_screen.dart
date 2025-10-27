import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../widgets/MyDataGridHeader.dart';
import '../../../../widgets/MyFilterIconButton.dart';
import '../../../../widgets/MySFDataGridRawTable.dart';
import 'finished_warp_list_controller.dart';
import 'finished_warps_filter.dart';

class FinishedWarpList extends StatefulWidget {
  const FinishedWarpList({super.key});

  static const String routeName = '/FinishedWarpList';

  @override
  State<FinishedWarpList> createState() => _State();
}

class _State extends State<FinishedWarpList> {
  FinishedWarpListReportController controller =
      Get.put(FinishedWarpListReportController());
  List<dynamic> list = <dynamic>[];
  late MyDataSource dataSource;
  final DataGridController _dataGridController = DataGridController();

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    _api();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FinishedWarpListReportController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Finished Warps List'),
          actions: [
            ExcludeFocusTraversal(
              child: TextButton.icon(
                onPressed: () {
                  var index = _dataGridController.selectedIndex;
                  if (index >= 0) {
                    unFinishAlert(index);
                  } else {
                    AppUtils.infoAlert(message: "Select the weaver");
                  }
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.red,
                ),
                label: const Text(
                  'UnFinish',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(width: 12),
            /*ExcludeFocusTraversal(
              child: TextButton.icon(
                onPressed: () => _overAllReportPrint(),
                icon: const Icon(
                  Icons.print,
                  color: Colors.blue,
                ),
                label: const Text(
                  'List Print',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(width: 12),*/
            MyFilterIconButton(
                onPressed: () => _filter(),
                filterIcon: controller.filterData != null ? true : false,
                tooltipText: "${controller.filterData}"),
            const SizedBox(width: 12),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
              _filter(),
        },
        child: MySFDataGridRawTable(
          controller: _dataGridController,
          selectionMode: SelectionMode.single,
          source: dataSource,
          isLoading: controller.status.isLoading,
          columns: [
            GridColumn(
              width: 80,
              columnName: 'id',
              visible: false,
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              columnName: 'weaver_name',
              label: const MyDataGridHeader(title: 'Weaver Name'),
            ),
            GridColumn(
              width: 65,
              columnName: 'sub_weaver_no',
              label: const MyDataGridHeader(title: 'Loom'),
            ),
            GridColumn(
              width: 140,
              columnName: 'warp_id',
              label: const MyDataGridHeader(
                  alignment: Alignment.center, title: 'Warp Id'),
            ),
            GridColumn(
              width: 90,
              columnName: 'total_warp_qty',
              label: const MyDataGridHeader(
                  alignment: Alignment.center, title: 'Qty'),
            ),
            GridColumn(
              width: 100,
              columnName: 'total_deli_meter',
              label: const MyDataGridHeader(title: 'Mtr/Yards'),
            ),
            GridColumn(
              width: 80,
              columnName: 'rec_qty',
              label: const MyDataGridHeader(title: 'Rece.Qty'),
            ),
            GridColumn(
              width: 80,
              columnName: 'rec_meter',
              label: const MyDataGridHeader(title: 'Rece.Mtr'),
            ),
            GridColumn(
              columnName: 'product_name',
              label: const MyDataGridHeader(title: 'Product Name'),
            ),
            GridColumn(
              width: 90,
              columnName: 'weav_no',
              label: const MyDataGridHeader(title: 'Weav No.'),
            ),
            GridColumn(
              width: 110,
              columnName: 'finished_date',
              label: const MyDataGridHeader(title: 'Finished Date'),
            ),
          ],
          tableSummaryColumns: const [
            GridSummaryColumn(
              name: 'weaver_name',
              columnName: 'weaver_name',
              summaryType: GridSummaryType.count,
            ),
            GridSummaryColumn(
              name: 'total_warp_qty',
              columnName: 'total_warp_qty',
              summaryType: GridSummaryType.sum,
            ),
            GridSummaryColumn(
              name: 'total_deli_meter',
              columnName: 'total_deli_meter',
              summaryType: GridSummaryType.sum,
            ),
          ],
          onRowSelected: (index) async {
            alertDialogue(index);
          },
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.finishedWarp(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const FinishedWarpReport(),
    );
    result != null ? _api(request: result ?? {}) : '';
  }

  detailedReportPdfApiCall(var index) async {
    var item = list[index];
    int? weavingAcId = item["weaving_ac_id"];

    if (weavingAcId == null) {
      return;
    }

    String? response = await controller.detailedReport(weavingAcId);
    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $response');
      }
    }
  }

  void alertDialogue(var index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 2,
          shadowColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: Colors.red,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Alert',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            'Do you want print?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red), // Border color
              ),
              child: const Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Get.back();
                detailedReportPdfApiCall(index);
              },
              autofocus: true,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue), // Border color
              ),
              child: const Text(
                'Ok',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  unFinishAlert(int index) {
    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          RxBool textVisible = RxBool(true);
          TextEditingController passwordText = TextEditingController();

          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            contentPadding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            title: RichText(
              textAlign: TextAlign.start,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'ALERT!\n',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Do you want to unFinish?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
            content: Form(
              key: formKey,
              child: Container(
                width: 270,
                height: 70,
                margin: const EdgeInsets.only(left: 8, right: 8),
                child: Obx(
                  () => TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    obscureText: textVisible.value,
                    controller: passwordText,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        focusNode: FocusNode(skipTraversal: true),
                        icon: Icon(
                          textVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => textVisible.value = !textVisible.value,
                      ),
                      labelText: 'Password',
                      hintText: 'Enter the Password',
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 12),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF939393), width: 0.4),
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      if (formKey.currentState!.validate()) {
                        Get.back();
                        unFinishApiCall(index, passwordText.text);
                      }
                    },
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Get.back();
                    unFinishApiCall(index, passwordText.text);
                  }
                },
                child: const Text('YES'),
              ),
            ],
          );
        });
  }

  unFinishApiCall(int index, var passwordText) async {
    var item = list[index];
    var weavingAcId = item["weaving_ac_id"];
    var weaverId = item["weaver_id"];
    var loomNo = item["sub_weaver_no"];
    var password = passwordText;

    if (weavingAcId != null &&
        weaverId != null &&
        loomNo != null &&
        password != null) {
      var result = await controller.unFinishApiCall(
          weavingAcId, weaverId, loomNo, password);

      if (result == "success") {
        _api(request: controller.filterData ?? {});
      }
    }
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<dynamic> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      int deliveryWarpQty = 0;
      deliveryWarpQty =
          (e["delivered_qty"] + e["warp_excess_qty"] + e["o_bal_qty"]) -
              (e["shortage_qty"] + e["drop_out_qty"]);
      num deliveryWarpMeter = 0.0;
      deliveryWarpMeter =
          (e["delivered_meter"] + e["warp_excess_meter"] + e["o_bal_meter"]) -
              (e["shortage_meter"] + e["drop_out_meter"]);

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e['id']),
        DataGridCell<dynamic>(
            columnName: 'weaver_name', value: '${e['weaver_name']}'),
        DataGridCell<dynamic>(
            columnName: 'sub_weaver_no', value: e['sub_weaver_no']),
        DataGridCell<dynamic>(columnName: 'warp_id', value: e['warp_id']),
        DataGridCell<dynamic>(
            columnName: 'total_warp_qty', value: deliveryWarpQty),
        DataGridCell<dynamic>(
            columnName: 'total_deli_meter', value: deliveryWarpMeter),
        DataGridCell<dynamic>(columnName: 'rec_qty', value: e['rec_qty']),
        DataGridCell<dynamic>(columnName: 'rec_meter', value: e['rec_meter']),
        DataGridCell<dynamic>(
            columnName: 'product_name', value: e['product_name']),
        DataGridCell<dynamic>(columnName: 'weav_no', value: e['weaving_ac_id']),
        DataGridCell<dynamic>(
            columnName: 'finished_date', value: e['finished_date']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      double value = double.tryParse('${e.value}') ?? 0;
      final columnName = e.columnName;
      switch (columnName) {
        case 'total_deli_meter':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'rec_meter':
          return buildFormattedCell(value, decimalPlaces: 3);
        case 'total_warp_qty':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'rec_qty':
          return buildFormattedCell(value, decimalPlaces: 0);
        default:
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              e.value != null ? '${e.value}' : '',
              style: AppUtils.cellTextStyle(),
            ),
          );
      }
    }).toList());
  }

  Widget buildFormattedCell(dynamic value, {int decimalPlaces = 2}) {
    if (value is num) {
      final formatter = NumberFormat.currency(
        locale: 'en_IN',
        decimalDigits: decimalPlaces,
        name: '',
      );
      return Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          formatter.format(value),
          style: AppUtils.cellTextStyle(),
        ),
      );
    }
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        value != null ? '$value' : '',
        style: AppUtils.cellTextStyle(),
      ),
    );
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    final columnName = summaryColumn?.columnName;
    double parsedValue = double.tryParse(summaryValue) ?? 0;
    TextAlign alignment;

    switch (columnName) {
      case 'total_deli_meter':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'total_warp_qty':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'weaver_name':
        alignment = TextAlign.left;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      default:
        return null;
    }
  }

  Widget _buildFormattedCell(double value,
      {int decimalPlaces = 0, required TextAlign alignment}) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      decimalDigits: decimalPlaces,
      name: '',
    );
    return Container(
      padding: const EdgeInsets.all(8.0),
      // alignment: Alignment.center,
      child: Text(
        formatter.format(value),
        style: AppUtils.footerTextStyle(),
        textAlign: alignment,
      ),
    );
  }
}
