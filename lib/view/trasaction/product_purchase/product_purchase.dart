import 'dart:math';

import 'package:abtxt/view/trasaction/product_purchase/add_product_purchase.dart';
import 'package:abtxt/view/trasaction/product_purchase/product_purchase_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridRawTable.dart';



class ProductPurchase extends StatefulWidget {
  const ProductPurchase({Key? key}) : super(key: key);
  static const String routeName = '/ProductPurchase';

  @override
  State<ProductPurchase> createState() => _State();
}

class _State extends State<ProductPurchase> {
  ProductPurchaseController controller = Get.put(ProductPurchaseController());
  final _formKey = GlobalKey<FormState>();
  List<dynamic> list = <dynamic>[];
  late MyDataSource dataSource;



  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    _api();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductPurchaseController>(builder: (controller) {
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close',
            () => Get.back(),
            isControlPressed: true,
          ),
          KeyAction(
            LogicalKeyboardKey.keyN,
            'Add',
                () async {
              _add();
            },
            isControlPressed: true,
          ),
          KeyAction(
            LogicalKeyboardKey.keyF,
            'Filter',
                () async {},
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Transaction / Product Purchase'),
            centerTitle: false,
            elevation: 0,
            actions: [
              // MyFilterIconButton(onPressed: () async {
              //   final result = await showDialog(
              //     context: context,
              //     builder: (_) => const JariTwistingYarnInwardFilter(),
              //   );
              //   result != null ? _api(request: result ?? {}) : '';;
              // }),
              SizedBox(width: 12),
              MyAddItemButton(
                onPressed: () async {
                  _add();
                },
              ),
              SizedBox(width: 12),
            ],
          ),
          body:MySFDataGridRawTable(
            source: dataSource,
            isLoading: controller.status.isLoading,
            onRowSelected: (index) async {
              var item = list[index];
              await Get.toNamed(AddProductPurchase.routeName,
                  arguments: {"item": item});
              dataSource.notifyListeners();
            },
            columns: <GridColumn>[
              GridColumn(
                width: 80,
                columnName: 'id',
                label: const MyDataGridHeader(title: 'ID'),
              ),
              GridColumn(
                width: 120,
                columnName: 'e_date',
                label: const MyDataGridHeader(title: 'Date'),
              ),
              GridColumn(
                columnName: 'suplier_name',
                label: const MyDataGridHeader(title: 'Supplier Name'),
              ),
              GridColumn(
                columnName: 'pa_ano',
                label: const MyDataGridHeader(title: 'Return No'),
              ),
              GridColumn(
                columnName: 'slip_no',
                label: const MyDataGridHeader(title: 'D.C / Invoice No'),
              ),
              GridColumn(
                columnName: 'account_name',
                label: const MyDataGridHeader(title: 'Account Type'),
              ),
              GridColumn(
                columnName: 'details',
                label: const MyDataGridHeader(title: 'Details'),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.productpurchase(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }
  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddProductPurchase.routeName,
      arguments: args,
    );
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
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e['id']),
        DataGridCell<dynamic>(
            columnName: 'e_date',
            value: '${e['e_date']}'),
        DataGridCell<dynamic>(
            columnName: 'suplier_name', value: e['suplier_name']),
        DataGridCell<int>(columnName: 'pa_ano', value: e['pa_ano']),
        DataGridCell<int>(columnName: 'slip_no', value: e['slip_no']),
        DataGridCell<dynamic>(columnName: 'account_name', value: e['account_name']),
        DataGridCell<dynamic>(columnName: 'details', value: e['details']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(8.0),
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
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
