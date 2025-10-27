import 'dart:convert';

import 'package:abtxt/view/adjustments/alternative_warp_design/alternative_warp_design_list.dart';
import 'package:abtxt/view/trasaction/yarn_stock_report/yarn_stock_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/YarnStockReportHistoryModel.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridItemTable.dart';

class YarnStockReport2 extends StatefulWidget {
  const YarnStockReport2({Key? key}) : super(key: key);
  static const String routeName = '/YarnStockReport2';

  @override
  State<YarnStockReport2> createState() => _State();
}

class _State extends State<YarnStockReport2> {
  YarnStockReportController controller = Get.put(YarnStockReportController());
  List<Map<String, dynamic>> itemList = [];
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
        backgroundColor: Color(0xFFF4F2FF),
          appBar: AppBar(title: const Text('Transaction / Yarn Stock Report')),
          body: MySFDataGridItemTable(
            columns: [
              GridColumn(
                columnName: 'id',
                width: 100,
                label: const MyDataGridHeader(title: 'S.NO'),
              ),
              GridColumn(
                columnName: 'date',
                label: const MyDataGridHeader(title: 'Date'),
              ),
              GridColumn(
                columnName: 'yarn',
                label: const MyDataGridHeader(title: 'Yarn'),
              ),
              GridColumn(
                columnName: 'stock_to',
                label: const MyDataGridHeader(title: 'Stock Place'),
              ),
              GridColumn(
                columnName: 'supplier',
                label: const MyDataGridHeader(title: 'Supplier/Customer'),
              ),
              GridColumn(
                columnName: 'type',
                label: const MyDataGridHeader(title: 'Type'),
              ),
              GridColumn(
                columnName: 'opening',
                label: const MyDataGridHeader(title: 'Opening Stock'),
              ),
              GridColumn(
                columnName: 'current',
                label: const MyDataGridHeader(title: 'Current Stock'),
              ),
              GridColumn(
                columnName: 'closing',
                label: const MyDataGridHeader(title: 'Closing Stock'),
              ),
            ],
            source: dataSource,
            footer: Container(
              color: Colors.white,
              alignment: Alignment.center,
              padding: EdgeInsets.all(12),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('PURCHASE: 5450', style: TextStyle(color: Colors.green),),
                  SizedBox(width: 12),
                  Text('PROCESS: 1500', style: TextStyle(color: Colors.blue),),
                  SizedBox(width: 12),
                  Text('SALES: 2750', style: TextStyle(color: Colors.red),),
                  SizedBox(width: 12),
                  Text('STOCK: 1200', style: TextStyle(color: Colors.orange),),
                ],
              ),
            ),
          ));
    });
  }

  void apiCall() async {
    /*var result = await controller.yarnStockHistory(page: '1', limit: '100');
    itemList.addAll(result['list']);*/
    //itemList = <dynamic>[];
    var item = [
      {
        'id': 1,
        'date': '01-12-2023',
        'yarn': '110 Karishma - RED',
        'stock_to': 'Godown',
        'supplier': 'Tamilzorous',
        'type': 'PURCHASE',
        'opening': 0,
        'current': 1000,
        'closing': 1000
      },
      {
        'id': 2,
        'date': '03-12-2023',
        'yarn': '110 Karishma - RED',
        'stock_to': 'Office',
        'supplier': 'Tamilzorous',
        'type': 'PURCHASE',
        'opening': 1000,
        'current': 500,
        'closing': 1500
      },
      {
        'id': 3,
        'date': '04-12-2023',
        'yarn': '110 Karishma - RED',
        'stock_to': 'Godown',
        'supplier': 'Pothys',
        'type': 'PURCHASE',
        'opening': 1500,
        'current': 2000,
        'closing': 3500
      },
      {
        'id': 4,
        'date': '07-12-2023',
        'yarn': '110 Karishma - RED',
        'stock_to': 'Godown',
        'supplier': 'Pothys',
        'type': 'PURCHASE-Return',
        'opening': 3500,
        'current': '500.0',
        'closing': 3000
      },
      {
        'id': 5,
        'date': '16-12-2023',
        'yarn': '110 Karishma - RED',
        'stock_to': 'Godown',
        'supplier': 'Ganesh',
        'type': 'Dying Process',
        'opening': 3000,
        'current': '1000.00',
        'closing': 2000
      },
      {
        'id': 6,
        'date': '20-12-2023',
        'yarn': '110 Karishma - RED',
        'stock_to': 'Godown',
        'supplier': 'Santhosh',
        'type': 'Rolling Process',
        'opening': 2000,
        'current': '500.00',
        'closing': 1500
      },
      {
        'id': 7,
        'date': '24-12-2023',
        'yarn': '110 Karishma - RED',
        'stock_to': 'Godown',
        'supplier': 'Ganesh',
        'type': 'Dying Yarn Return',
        'opening': 1500,
        'current': 1950,
        'closing': 3450
      },
      {
        'id': 8,
        'date': '28-12-2023',
        'yarn': '110 Karishma - RED',
        'stock_to': 'Godown',
        'supplier': 'Venki',
        'type': 'Weaving',
        'opening': 3450,
        'current': 1200,
        'closing': 2250
      },
      {
        'id': 9,
        'date': '29-12-2023',
        'yarn': '110 Karishma - RED',
        'stock_to': 'Godown',
        'supplier': 'Rajesh',
        'type': 'Sales',
        'opening': 2250,
        'current': 1050,
        'closing': 1200
      },
    ];
    itemList.addAll(item);
    print('itemList: ${itemList.length}');
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
  }
}

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
        DataGridCell<dynamic>(columnName: 'id', value: e['id']),
        DataGridCell<dynamic>(columnName: 'date', value: e['date']),
        DataGridCell<dynamic>(columnName: 'yarn', value: e['yarn']),
        DataGridCell<dynamic>(columnName: 'stock_to', value: e['stock_to']),
        DataGridCell<dynamic>(columnName: 'supplier', value: e['supplier']),
        DataGridCell<dynamic>(columnName: 'type', value: e['type']),
        DataGridCell<dynamic>(columnName: 'opening', value: e['opening']),
        DataGridCell<dynamic>(columnName: 'current', value: e['current']),
        DataGridCell<dynamic>(columnName: 'closing', value: e['closing']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: row.getCells().map<Widget>((dataGridCell) {

      TextStyle? getTextStyle() {
        if (dataGridCell.columnName == 'current') {
          final int index = effectiveRows.indexOf(row);
          if (dataGridCell.value == 1200 || '${dataGridCell.value}' == '500.0' || dataGridCell.value == 1050) {
            return TextStyle(color: Colors.red);
          }else if(dataGridCell.value == 1000 || dataGridCell.value == 500 || dataGridCell.value == 2000 || dataGridCell.value == 1950){
            return TextStyle(color: Colors.green);
          }else if('${dataGridCell.value}' == '1000.00' || '${dataGridCell.value}' == '500.00'){
            return TextStyle(color: Colors.blue);
          }
        }
        return null;
      }

      return Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(dataGridCell.value.toString(), style: getTextStyle(),),
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
