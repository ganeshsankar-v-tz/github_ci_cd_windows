import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/productopeningstockModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/product_opening_stock/productopeningstock_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'addProduct_Opening_Stock.dart';

class ProductOpeningBalance extends StatefulWidget {
  const ProductOpeningBalance({super.key});

  static const String routeName = '/product_opening_balance';

  @override
  State<ProductOpeningBalance> createState() => _ProductOpeningBalanceState();
}

class _ProductOpeningBalanceState extends State<ProductOpeningBalance> {
  ProductOpeningStockController controller =
      Get.put(ProductOpeningStockController());
  List<ProductOpeningStockModel> list = <ProductOpeningStockModel>[];
  late MyDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    _api();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductOpeningStockController>(
      builder: (controller) {
        this.controller = controller;
        return CoreWidget(
          appBar: AppBar(
            title: const Text('Basic Info / Product Opening Stock'),
            actions: [
              MyRefreshIconButton(
                  onPressed: () => _api(request: controller.filterData ?? {})),
              const SizedBox(width: 12),
              MyFilterIconButton(
                  onPressed: () => _filter(),
                  filterIcon: controller.filterData != null ? true : false,
                  tooltipText: "${controller.filterData}"),
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
                _filter(),
            const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
                _api(request: controller.filterData ?? {}),
          },
          child: MySFDataGridRawTable(
            source: dataSource,
            isLoading: controller.status.isLoading,
            onRowSelected: (index) async {
              var item = list[index];
              _add(args: {'item': item});
            },
            columns: <GridColumn>[
              GridColumn(
                width: 80,
                columnName: 'id',
                label: const MyDataGridHeader(title: 'ID'),
              ),
              GridColumn(
                columnName: 'product_name',
                label: const MyDataGridHeader(title: 'Product Name'),
              ),
              GridColumn(
                width: 120,
                columnName: 'e_date',
                label: const MyDataGridHeader(title: 'Date'),
              ),
              GridColumn(
                width: 120,
                columnName: 'quantity',
                label: const MyDataGridHeader(title: 'Quantity'),
              ),
              GridColumn(
                columnName: 'details',
                label: const MyDataGridHeader(title: 'Details'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _api({var request = const {}}) async {
    var response = await controller.openingStockDetails(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result =
        await Get.toNamed(AddProductOpeningStock.routeName, arguments: args);
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    // final result =
    //     await showDialog(context: context, builder: (_) => const YarnFilter());
    // result != null ? _api(request: result ?? {}) : '';
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<ProductOpeningStockModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<ProductOpeningStockModel> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e.id),
        DataGridCell<dynamic>(columnName: 'product_name', value: e.productName),
        DataGridCell<dynamic>(columnName: 'e_date', value: e.eDate),
        DataGridCell<dynamic>(columnName: 'quantity', value: e.quantity),
        DataGridCell<dynamic>(columnName: 'details', value: e.details),
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
