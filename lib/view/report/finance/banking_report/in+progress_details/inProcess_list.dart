import 'package:abtxt/view/report/finance/banking_report/in+progress_details/update_InProcess.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../utils/app_utils.dart';
import '../../../../../widgets/MyDataGridHeader.dart';
import '../../../../../widgets/MySFDataGridRawTable.dart';
import '../../../../../widgets/flutter_shortcut_widget.dart';
import '../baking_report_controller.dart';

class InProcessList extends StatefulWidget {
  const InProcessList({super.key});

  static const String routeName = '/in_progress';

  @override
  State<InProcessList> createState() => _InProcessListState();
}

class _InProcessListState extends State<InProcessList> {
  BankingReportController controller = Get.put(BankingReportController());

  List<dynamic> list = <dynamic>[];
  late MyDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _api();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankingReportController>(
      builder: (controller) {
        return ShortCutWidget(
          appBar: AppBar(
            title: const Text("InProgress - Banking Report"),
            actions: const [],
          ),
          loadingStatus: controller.status.isLoading,
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.keyQ, control: true):
                GetBackIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              GetBackIntent: SetCounterAction(perform: () => Get.back()),
            },
            child: FocusScope(
              autofocus: true,
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: MySFDataGridRawTable(
                  source: dataSource,
                  isLoading: controller.status.isLoading,
                  onRowSelected: (index) async {
                    var item = list[index];
                    _add(args: {'item': item});
                  },
                  columns: [
                    GridColumn(
                      width: 80,
                      columnName: 's_no',
                      label: const MyDataGridHeader(title: 'S.No'),
                    ),
                    GridColumn(
                      minimumWidth: 200,
                      columnName: 'firm_name',
                      label: const MyDataGridHeader(title: 'Firm Name'),
                    ),
                    GridColumn(
                      width: 120,
                      columnName: 'cheque_date',
                      label: const MyDataGridHeader(title: 'Payment Date'),
                    ),
                    GridColumn(
                      columnName: 'payment_type',
                      label: const MyDataGridHeader(title: 'Payment Type'),
                    ),
                    GridColumn(
                      columnName: 'payment_mode',
                      label: const MyDataGridHeader(title: 'Payment Mode'),
                    ),
                    GridColumn(
                      columnName: 'created_by',
                      label: const MyDataGridHeader(title: 'Created By'),
                    ),
                    GridColumn(
                      width: 140,
                      columnName: 'total_amount',
                      label: const MyDataGridHeader(title: 'Total Amount'),
                    ),
                    GridColumn(
                      width: 180,
                      columnName: 'status',
                      label: const MyDataGridHeader(title: 'Status'),
                    ),
                    GridColumn(
                      width: 80,
                      columnName: 'button',
                      label: const MyDataGridHeader(title: 'Excel'),
                    ),
                    GridColumn(
                      width: 80,
                      columnName: 'button_2',
                      label: const MyDataGridHeader(title: 'Pdf'),
                    ),
                    GridColumn(
                      visible: false,
                      width: 80,
                      columnName: 'id',
                      label: const MyDataGridHeader(title: 'Id'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _api({var request = const {}}) async {
    var response = await controller.inProcessGetList(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result =
        await Get.toNamed(InProcessItemDetails.routeName, arguments: args);
    if (result == 'success') {
      _api();
    }else {
      if (controller.apiCall.value == true) {
        _api();
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

  RxBool isVisible = RxBool(false);

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      int sNo = _list.indexOf(e);
      var status = "";
      if (e["status"] == "Inprogress") {
        status = "Waiting For Transaction";
      }


      var type = "";
      var mode = "";
      if (e["payment_mode"] == "cheque") {
        mode = "Cheque";
      } else if (e["payment_mode"] == "online") {
        mode = "Online";
      } else {
        mode = "Cash";
      }


      if (e["type"] == "po") {
        type = "PO";
      } else {
        type = "Direct";
      }

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 's_no', value: "${sNo + 1}"),
        DataGridCell<dynamic>(columnName: 'firm_name', value: e["firm_name"]),
        DataGridCell<dynamic>(
            columnName: 'cheque_date',
            value: e["cheque_date"].toString().substring(0, 10)),
        DataGridCell<dynamic>(columnName: 'payment_type', value: type),
        DataGridCell<dynamic>(columnName: 'payment_mode', value: mode),
        DataGridCell<dynamic>(columnName: 'created_by', value: e["creator_name"]),
        DataGridCell<dynamic>(columnName: 'total_amount', value: e["total_amount"]),
        DataGridCell<dynamic>(columnName: 'status', value: status),
        const DataGridCell<dynamic>(columnName: 'button', value: ""),
        const DataGridCell<dynamic>(columnName: 'button_2', value: ""),
        DataGridCell<dynamic>(columnName: 'id', value: e["id"]),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    BankingReportController controller = Get.put(BankingReportController());

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      TextStyle? getTextStyle() {
        if (e.columnName == "status" && e.value == "Waiting For Transaction") {
          isVisible.value = true;
          return const TextStyle(
            color: Color(0xff0B5CB8),
            fontSize: 13,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.visible,
          );
        } else {
          return const TextStyle(
            color: Color(0xffF09111),
            fontSize: 13,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.visible,
          );
        }
      }

      if (e.columnName == "total_amount") {
        return Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            e.value != null ? AppUtils().rupeeFormat.format(e.value) : '',
            style: AppUtils.cellTextStyle(),
          ),
        );
      }

      if (e.columnName == "button") {
        return Padding(
          padding: const EdgeInsets.all(3),
          child: Visibility(
            visible: row.getCells()[7].value == "Waiting For Transaction",
            child: TextButton.icon(
                onPressed: () async {
                  int id = row.getCells()[10].value;
                  String? response =
                      await controller.reportApiCall(id, "excel");
                  if (response != null) {
                    final Uri url = Uri.parse(response);
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $response');
                    }
                  }
                },
                icon: Image.asset(
                  'assets/images/excel_icon.png',
                ),
                label: const Text("")),
          ),
        );
      }
      if (e.columnName == "button_2") {
        return Padding(
          padding: const EdgeInsets.all(3),
          child: Visibility(
            visible: row.getCells()[7].value == "Waiting For Transaction",
            child: TextButton.icon(
                onPressed: () async {
                  int id = row.getCells()[10].value;
                  String? response = await controller.reportApiCall(id, "pdf");
                  if (response != null) {
                    final Uri url = Uri.parse(response);
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $response');
                    }
                  }
                },
                icon: Image.asset(
                  'assets/images/pdf_icon.png',
                ),
                label: const Text("")),
          ),
        );
      }
      if (e.columnName == "status") {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            e.value != null ? '${e.value}' : '',
            style: getTextStyle(),
          ),
        );
      }

      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          e.value != null ? '${e.value}' : '',
          style: AppUtils.cellTextStyle(),
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
        style: AppUtils.footerTextStyle(),
      ),
    );
  }
}
