import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../utils/app_utils.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridItemTable.dart';

class ProductStockTable extends StatefulWidget {
  final ProductStockDataSource dataSource;

  const ProductStockTable({
    super.key,
    required this.dataSource,
  });

  @override
  State<ProductStockTable> createState() => _ProductStockTableState();
}

class _ProductStockTableState extends State<ProductStockTable> {
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
            columnName: 'product_name',
            label:
                const MyDataGridHeader(color: Colors.black, title: 'Product'),
          ),
          GridColumn(
            width: 130,
            columnName: 'status',
            label: const MyDataGridHeader(color: Colors.black, title: 'Status'),
          ),
          GridColumn(
            width: 130,
            columnName: 'stock_to',
            label: const MyDataGridHeader(
                color: Colors.black, title: 'Stock ( Saree )'),
          ),
        ],
        source: widget.dataSource,
      ),
    );
  }
}

class ProductStockDataSource extends DataGridSource {
  ProductStockDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var status = "";
      int balanceQty = e["balance_qty"];
      if (balanceQty <= 0) {
        status = "Out Of Stock";
      } else if (balanceQty > 0 && balanceQty <= 1000) {
        status = "Low Stock";
      } else if (balanceQty > 1000 && balanceQty <= 5000) {
        status = "Medium";
      } else {
        status = "In Stock";
      }

      return DataGridRow(cells: [
        DataGridCell<dynamic>(
            columnName: 'product_name', value: e['product_name']),
        DataGridCell<dynamic>(columnName: 'status', value: status),
        DataGridCell<dynamic>(
            columnName: 'balance_qty', value: e['balance_qty']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      TextStyle? textStyle() {
        if (e.columnName == "status") {
          if (e.value == "In Stock") {
            return const TextStyle(
              overflow: TextOverflow.visible,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xff1EB62D),
            );
          } else if (e.value == "Low Stock") {
            return const TextStyle(
              overflow: TextOverflow.visible,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xffF88634),
            );
          } else if (e.value == "Medium") {
            return const TextStyle(
              overflow: TextOverflow.visible,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xff0038FF),
            );
          } else {
            return const TextStyle(
              overflow: TextOverflow.visible,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xffFF0000),
            );
          }
        } else {
          return AppUtils.cellTextStyle();
        }
      }

      return Container(
        alignment: e.columnName == "balance_qty"
            ? Alignment.center
            : Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          e.value != null ? '${e.value}' : '',
          style: textStyle(),
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
