import 'package:abtxt/view/production/wages_bill/wages_bill_controller.dart';
import 'package:abtxt/view/production/wages_bill/wages_bill_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../flutter_core_widget.dart';
import '../../../model/weaving_models/WagesBillListModel.dart';
import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'add_wages_bill.dart';

class WagesBillList extends StatefulWidget {
  const WagesBillList({Key? key}) : super(key: key);
  static const String routeName = '/wages_bill_list';

  @override
  State<WagesBillList> createState() => _State();
}

class _State extends State<WagesBillList> {
  WagesbillController controller = Get.put(WagesbillController());
  List<WagesBillListModel> list = <WagesBillListModel>[];
  late MyDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    _api();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WagesbillController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Production / Wages Bill'),
          actions: [
            MyFilterIconButton(onPressed: () => _filter()),
            const SizedBox(width: 12),
            MyAddItemButton(onPressed: () => _add()),
            const SizedBox(width: 12),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
              _add(),
          const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
              _filter()
        },
        child: MySFDataGridRawTable(
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            var request = {'challan_no': item.challanNo, 'account_no': item.id};
            _add(args: {'item': request});
          },
          columns: <GridColumn>[
            GridColumn(
              width: 120,
              columnName: 'date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              columnName: 'weaver_name',
              label: const MyDataGridHeader(title: 'Weaver Name'),
            ),
            GridColumn(
              columnName: 'challan_no',
              label: const MyDataGridHeader(title: 'Challan No'),
            ),
            GridColumn(
              columnName: 'total_amount',
              label: const MyDataGridHeader(title: 'Amount (Rs)'),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.wagesBill(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddWagesBill.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api();
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const WagesBillFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';;
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<WagesBillListModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<WagesBillListModel> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'e_date', value: e.eDate),
        DataGridCell<dynamic>(columnName: 'weaver_name', value: e.weaverName),
        DataGridCell<dynamic>(columnName: 'challan_no', value: e.challanNo),
        DataGridCell<dynamic>(columnName: 'total_amount', value: e.amount),
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
        child: Text(e.value.toString()),
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
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
