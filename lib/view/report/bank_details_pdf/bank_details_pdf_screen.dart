import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/widgets/MyMultiSelectDropdown.dart';
import 'package:abtxt/widgets/MyPrintButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../widgets/MyDataGridHeader.dart';
import '../../../../widgets/MyFilterIconButton.dart';
import '../../../../widgets/MySFDataGridRawTable.dart';
import 'bank_details_controller.dart';
import 'bank_details_filter_screen.dart';

class BankDetailsPDFList extends StatefulWidget {
  const BankDetailsPDFList({super.key});

  static const String routeName = '/bank_details';

  @override
  State<BankDetailsPDFList> createState() => _State();
}

class _State extends State<BankDetailsPDFList> {
  BankDetailsController controller = Get.put(BankDetailsController());
  List<dynamic> list = <dynamic>[];
  late MyDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    // _api();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankDetailsController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Bank Details'),
          actions: [
            TextButton(
              onPressed: () => _overAllReportPrint(),
              child: const Text("Download"),
            ),
            MyFilterIconButton(onPressed: () => _filter()),
            const SizedBox(width: 12),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
              _filter(),
          const SingleActivator(LogicalKeyboardKey.keyP, control: true): () =>
              _overAllReportPrint(),
        },
        child: MySFDataGridRawTable(
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {},
          columns: <GridColumn>[
            GridColumn(
              columnName: 'ledger_name',
              label: const MyDataGridHeader(title: 'Ledger Name'),
            ),
            GridColumn(
              columnName: 'ac_holder',
              label: const MyDataGridHeader(title: 'Ac Holder'),
            ),
            GridColumn(
              columnName: 'account_no',
              label: const MyDataGridHeader(title: 'Account No'),
            ),
            GridColumn(
              columnName: 'bank_name',
              label: const MyDataGridHeader(title: 'Bank Name'),
            ),
            GridColumn(
              columnName: 'branch',
              label: const MyDataGridHeader(title: 'Branch'),
            ),
            GridColumn(
              columnName: 'ifsc_no',
              label: const MyDataGridHeader(title: 'IFSC No'),
            ),
            GridColumn(
              columnName: 'pan_no',
              label: const MyDataGridHeader(title: 'Pan No'),
            ),
            GridColumn(
              columnName: 'pan_name',
              label: const MyDataGridHeader(title: 'Pan Name'),
            ),
            GridColumn(
              columnName: 'aathar_no',
              label: const MyDataGridHeader(title: 'Aadhar No'),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.bankDetails(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const BankDetailsPDFFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
  }

  void _overAllReportPrint() async {
    final Uri url = controller.overAllReportPdfUrl;
    if (!await launchUrl(url)) {
      throw Exception('Could not launch');
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
      return DataGridRow(cells: [
        DataGridCell<dynamic>(
            columnName: 'ledger_name', value: e['ledger_name']),
        DataGridCell<dynamic>(columnName: 'ac_holder', value: e['ac_holder']),
        DataGridCell<dynamic>(columnName: 'account_no', value: e['accont_no']),
        DataGridCell<dynamic>(columnName: 'bank_name', value: e['bank_name']),
        DataGridCell<dynamic>(columnName: 'branch', value: e['branch']),
        DataGridCell<dynamic>(columnName: 'ifsc_no', value: e['ifsc_no']),
        DataGridCell<dynamic>(columnName: 'pan_no', value: e['pan_no']),
        DataGridCell<dynamic>(columnName: 'pan_name', value: e['pan_name']),
        DataGridCell<dynamic>(columnName: 'aathar_no', value: e['aathar_no']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
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
