import 'package:abtxt/view/report/finance/banking_report/admin_conformation/admin_conformation_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../utils/app_utils.dart';
import '../../../../../widgets/MyDataGridHeader.dart';
import '../../../../../widgets/MySFDataGridRawTable.dart';
import '../../../../../widgets/flutter_shortcut_widget.dart';
import '../baking_report_controller.dart';

class AdminConformationList extends StatefulWidget {
  const AdminConformationList({super.key});

  static const String routeName = '/admin_conformation_list';

  @override
  State<AdminConformationList> createState() => _AdminConformationListState();
}

class _AdminConformationListState extends State<AdminConformationList> {
  BankingReportController controller = Get.find();

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
            title: const Text("Admin Conformation - Banking Report"),
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
                      columnName: 'status',
                      label: const MyDataGridHeader(title: 'Status'),
                    ),
                    GridColumn(
                      visible: false,
                      width: 140,
                      columnName: 'button',
                      label: const MyDataGridHeader(title: ''),
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

  void _api() async {
    var response = await controller.approvalDetails();
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(AdminConformationItemDetails.routeName,
        arguments: args);
    if (result == 'success') {
      _api();
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
      int sNo = _list.indexOf(e);

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
        const DataGridCell<dynamic>(
            columnName: 'status', value: "Waiting For Approval"),
        const DataGridCell<dynamic>(columnName: 'button', value: ""),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      if (e.columnName == "button") {
        return Padding(
          padding: const EdgeInsets.all(3),
          child: OutlinedButton(
            onPressed: () {},
            style: ButtonStyle(
              minimumSize: WidgetStateProperty.all(const Size(60, 36)),
              foregroundColor:
                  WidgetStateProperty.resolveWith((states) => Colors.white),
              shape: WidgetStateProperty.resolveWith((s) =>
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0))),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                return Colors.blue;
              }),
            ),
            child: const Text('APPROVE'),
          ),
        );
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

      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          e.value != null ? '${e.value}' : '',
          style: e.columnName == "status"
              ? const TextStyle(
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xffF09111))
              : AppUtils.cellTextStyle(),
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
