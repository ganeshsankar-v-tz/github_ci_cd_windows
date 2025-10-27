import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../utils/app_utils.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridItemTable.dart';

class RecentSaleTable extends StatefulWidget {
  final RecentSaleDataSource dataSource;

  const RecentSaleTable({
    super.key,
    required this.dataSource,
  });

  @override
  State<RecentSaleTable> createState() => _RecentSaleTableState();
}

class _RecentSaleTableState extends State<RecentSaleTable> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: MySFDataGridItemTable(
        color: Colors.white,
        headerColor: Colors.white,
        cellLineVisibility: GridLinesVisibility.none,
        headerLineVisibility: GridLinesVisibility.horizontal,
        shrinkWrapRows: false,
        scrollPhysics: const ScrollPhysics(),
        columns: [
          GridColumn(
            width: 130,
            columnName: 'e_date',
            label: const MyDataGridHeader(color: Colors.black, title: 'Date'),
          ),
          GridColumn(
            columnName: 'customer_name',
            label:
                const MyDataGridHeader(color: Colors.black, title: 'Customer'),
          ),
          GridColumn(
            width: 130,
            columnName: 'total_qty',
            label:
                const MyDataGridHeader(color: Colors.black, title: 'Quantity'),
          ),
        ],
        source: widget.dataSource,
      ),
    );
  }
}

class RecentSaleDataSource extends DataGridSource {
  RecentSaleDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'e_date', value: e['e_date']),
        DataGridCell<dynamic>(
            columnName: 'customer_name', value: e['customer_name']),
        DataGridCell<dynamic>(columnName: 'total_qty', value: e['total_qty']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: e.columnName == "total_qty"
            ? Alignment.center
            : Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          e.value != null ? '${e.value}' : '',
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
