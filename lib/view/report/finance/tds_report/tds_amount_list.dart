import 'package:abtxt/model/tds_report/BankSubmittedTdsDetailsModel.dart';
import 'package:abtxt/view/report/finance/tds_report/add_tds_details.dart';
import 'package:abtxt/view/report/finance/tds_report/tds_amount_report_controller.dart';
import 'package:abtxt/view/report/finance/tds_report/tds_banking_details_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../utils/app_utils.dart';
import '../../../../../widgets/MyDataGridHeader.dart';
import '../../../../../widgets/MyRefreshButton.dart';
import '../../../../../widgets/MySFDataGridRawTable.dart';
import '../../../../../widgets/flutter_shortcut_widget.dart';
import '../../../../widgets/MyAddItemButton.dart';
import '../../../../widgets/MyFilterIconButton.dart';

class TdsAmountList extends StatefulWidget {
  const TdsAmountList({super.key});

  static const String routeName = '/tds_amount_list';

  @override
  State<TdsAmountList> createState() => _TdsAmountListState();
}

class _TdsAmountListState extends State<TdsAmountList> {
  TdsAmountReportController controller = Get.put(TdsAmountReportController());

  List<BankSubmittedTdsDetailsModel> list = <BankSubmittedTdsDetailsModel>[];
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
    return GetBuilder<TdsAmountReportController>(
      builder: (controller) {
        return ShortCutWidget(
          appBar: AppBar(
            title: const Text("TDS Amount"),
            actions: [
              MyRefreshIconButton(onPressed: () => _api()),
              const SizedBox(width: 12),
              MyFilterIconButton(
                onPressed: () => _filter(),
                filterIcon: controller.filterData != null ? true : false,
                tooltipText: "${controller.filterData}",
              ),
              const SizedBox(width: 12),
              MyAddItemButton(onPressed: () => _add()),
              const SizedBox(width: 12),
            ],
          ),
          loadingStatus: controller.status.isLoading,
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.keyQ, control: true):
                GetBackIntent(),
            SingleActivator(LogicalKeyboardKey.keyR, shift: true):
                RecordIntent(),
            SingleActivator(LogicalKeyboardKey.keyF, control: true):
                FilterIntent(),
            SingleActivator(LogicalKeyboardKey.keyN, control: true):
                AddNewIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              GetBackIntent: SetCounterAction(perform: () => Get.back()),
              RecordIntent: SetCounterAction(perform: () => _api()),
              FilterIntent: SetCounterAction(perform: () => _filter()),
              AddNewIntent: SetCounterAction(perform: () => _add()),
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
                      visible: false,
                      columnName: 'id',
                      label: const MyDataGridHeader(title: 'Id'),
                    ),
                    GridColumn(
                      width: 80,
                      columnName: 's_no',
                      label: const MyDataGridHeader(title: 'S.No'),
                    ),
                    GridColumn(
                      columnName: 'payment_date',
                      label: const MyDataGridHeader(title: 'Create Date'),
                    ),
                    GridColumn(
                      columnName: 'firm_name',
                      label: const MyDataGridHeader(title: 'Firm Name'),
                    ),
                    GridColumn(
                      columnName: 'bank_name',
                      label: const MyDataGridHeader(title: 'Bank Name'),
                    ),
                    GridColumn(
                      columnName: 'branch_name',
                      label: const MyDataGridHeader(title: 'Branch Name'),
                    ),
                    GridColumn(
                      columnName: 'check_no',
                      label: const MyDataGridHeader(title: 'Check No'),
                    ),
                    GridColumn(
                      columnName: 'check_date',
                      label: const MyDataGridHeader(title: 'Check Date'),
                    ),
                    GridColumn(
                      width: 150,
                      columnName: 'total_amount',
                      label: const MyDataGridHeader(
                          alignment: Alignment.center, title: 'Total Amount'),
                    ),
                    GridColumn(
                      width: 80,
                      columnName: 'excel',
                      label: const MyDataGridHeader(title: 'Excel'),
                    ),
                    GridColumn(
                      width: 80,
                      columnName: 'pdf',
                      label: const MyDataGridHeader(title: 'Pdf'),
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
    var response = await controller.bankSubmittedDetails(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result =
        await Get.toNamed(AddTdsAmountDetails.routeName, arguments: args);
    if (result == 'success') {
      _api();
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const TdsBankingDetailsFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<BankSubmittedTdsDetailsModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<BankSubmittedTdsDetailsModel> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      int sNo = _list.indexOf(e);

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'id', value: e.id),
        DataGridCell<dynamic>(columnName: 's_no', value: "${sNo + 1}"),
        DataGridCell<dynamic>(columnName: 'payment_date', value: e.paymentDate),
        DataGridCell<dynamic>(columnName: 'firm_name', value: e.firmName),
        DataGridCell<dynamic>(columnName: 'bank_name', value: e.bankName),
        DataGridCell<dynamic>(columnName: 'branch_name', value: e.branchName),
        DataGridCell<dynamic>(columnName: 'check_no', value: e.chequeNo),
        DataGridCell<dynamic>(columnName: 'check_date', value: e.chequeDate),
        DataGridCell<dynamic>(columnName: 'total_amount', value: e.totalAmount),
        const DataGridCell<dynamic>(columnName: 'excel', value: ""),
        const DataGridCell<dynamic>(columnName: 'pdf', value: ""),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    TdsAmountReportController controller = Get.find();

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      if (e.columnName == "pdf") {
        return Padding(
          padding: const EdgeInsets.all(3),
          child: Center(
            child: TextButton.icon(
                onPressed: () async {
                  int id = row.getCells()[0].value;
                  String? response = await controller
                      .tdsAmountPdf(request: {"id": id, "report_type": "PDF"});
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

      if (e.columnName == "excel") {
        return Padding(
          padding: const EdgeInsets.all(3),
          child: Center(
            child: TextButton.icon(
                onPressed: () async {
                  int id = row.getCells()[0].value;
                  String? response = await controller.tdsAmountPdf(
                      request: {"id": id, "report_type": "Excel"});
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
    if (summaryColumn!.columnName == "tds_amount") {
      return Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          AppUtils().rupeeFormat.format(summaryValue),
          style: AppUtils.cellTextStyle(),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        summaryValue,
        style: AppUtils.footerTextStyle(),
      ),
    );
  }
}
