import 'package:abtxt/view/trasaction/yarn_stock_report/yarn_stock_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/YarnStockReportHistoryModel.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridItemTable.dart';

class YarnStockReportHistory extends StatefulWidget {
  const YarnStockReportHistory({Key? key}) : super(key: key);
  static const String routeName = '/YarnStockReportHistoryList';

  @override
  State<YarnStockReportHistory> createState() => _State();
}

class _State extends State<YarnStockReportHistory> {
  YarnStockReportController controller = Get.find();
  var itemList = <YarnStockReportHistoryModel>[];
  late ItemDataSource dataSource;

  @override
  void initState() {
    dataSource = ItemDataSource(list: itemList);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      apiCall();
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnStockReportController>(builder: (controller) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Transaction / Yarn Stock History'),
            centerTitle: false,
            elevation: 0,
          ),
          body: MySFDataGridItemTable(
            columns: [
              GridColumn(
                columnName: 'firm_name',
                label: const MyDataGridHeader(title: 'Firm Name'),
              ),
            ],
            source: dataSource,
          ));
    });
  }

  void apiCall() async {
    var result = await controller.yarnStockHistory(page: '1', limit: '100');
    itemList.addAll(result['list']);
    print('itemList: ${itemList.length}');
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
  }
}

/*class MyDataSource extends DataGridSource {
  MyDataSource() {
    buildPaginatedDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(builder: (context, constraints) {
          return Text(e.value.toString(), overflow: TextOverflow.ellipsis);
        }),
      );
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (newPageIndex < totalPage) {
      YarnStockReportController controller = Get.find();
      var result = await controller.yarnStockHistory(page: '${newPageIndex + 1}', limit: _rowsPerPage);
      paginatedOrders = result['list'];
      totalPage = result['totalPage'];
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      paginatedOrders = [];
    }

    return true;
  }

  void buildPaginatedDataGridRows() {
    dataGridRows = paginatedOrders.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'yarn_name', value: dataGridRow.supplierName),
        DataGridCell(columnName: 'color_name', value: dataGridRow.purchaseNo),
        DataGridCell(columnName: 'godown', value: dataGridRow.invoiceNo),
        DataGridCell(columnName: 'office', value: dataGridRow.accountTypeName),
        DataGridCell(columnName: 'total', value: dataGridRow.totalNetQty),
      ]);
    }).toList(growable: false);
  }
}*/

class ItemDataSource extends DataGridSource {
  ItemDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e.firmName),
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
