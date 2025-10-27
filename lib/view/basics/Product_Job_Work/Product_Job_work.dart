import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/Product_Job_Work/ProductJobWork_controller.dart';
import 'package:abtxt/view/basics/Product_Job_Work/addProduct_Job_Work.dart';
import 'package:abtxt/view/basics/Product_Job_Work/product_job_work_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';

class ProductJobWorkBasics extends StatefulWidget {
  const ProductJobWorkBasics({Key? key}) : super(key: key);
  static const String routeName = '/ProductJobWork';

  @override
  State<ProductJobWorkBasics> createState() => _State();
}

class _State extends State<ProductJobWorkBasics> {
  ProductJobWorkController controller = Get.put(ProductJobWorkController());
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
    return GetBuilder<ProductJobWorkController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Basic Info / Product Job Work'),
          actions: [
            MyRefreshIconButton(onPressed: () => _api(request: controller.filterData ?? {})),
            SizedBox(width: 12),
            MyFilterIconButton(
                onPressed: () => _filter(),
                filterIcon: controller.filterData != null ? true : false,
                tooltipText: "${controller.filterData}"),
            SizedBox(width: 12),
            MyAddItemButton(onPressed: () => _add()),
            SizedBox(width: 12),
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
            // await Get.toNamed(AddProductJobWork.routeName,
            //     arguments: {"item": item});
            _add(args: {'item': item});
            _api();
          },
          columns: [
            GridColumn(
              width: 80,
              columnName: 'id',
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              columnName: 'work_name',
              label: const MyDataGridHeader(title: 'Work Name'),
            ),
            GridColumn(
              width: 170,
              columnName: 'labour_wages',
              label: const MyDataGridHeader(title: 'Labour Wages (Rs)'),
            ),
            GridColumn(
              columnName: 'work_typ',
              label: const MyDataGridHeader(title: 'Work Type'),
            ),
            GridColumn(
              columnName: 'is_active',
              label: const MyDataGridHeader(title: 'Is Active'),
            ),
            GridColumn(
              columnName: 'llname',
              label: const MyDataGridHeader(title: 'L.L.Name'),
            ),
          ],
          // tableSummaryColumns: const [
          //   GridSummaryColumn(
          //     name: 'labour_wages',
          //     columnName: 'labour_wages',
          //     summaryType: GridSummaryType.sum,
          //   ),
          // ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.ProductJobWorkList(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddProductJobWork.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const ProductJobworkFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
    ;
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
        DataGridCell<dynamic>(columnName: 'work_name', value: e['work_name']),
        DataGridCell<int>(columnName: 'labour_wages', value: e['labour_wages']),
        DataGridCell<dynamic>(columnName: 'work_typ', value: e['work_typ']),
        DataGridCell<dynamic>(columnName: 'is_active', value: e['is_active']),
        DataGridCell<dynamic>(columnName: 'll_name', value: e['ll_name']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      double value = double.tryParse('${e.value}') ?? 0;
      final columnName = e.columnName;
      switch (columnName) {
        case 'labour_wages':
          return buildFormattedCell(value, decimalPlaces: 2);
        default:
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              e.value != null ? '${e.value}' : '',
              style: AppUtils.cellTextStyle(),
            ),
          );
      }
    }).toList());
  }

  Widget buildFormattedCell(dynamic value, {int decimalPlaces = 2}) {
    if (value is num) {
      final formatter = NumberFormat.currency(
        locale: 'en_IN',
        decimalDigits: decimalPlaces,
        name: '',
      );
      return Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          formatter.format(value),
          style: AppUtils.cellTextStyle(),
        ),
      );
    }
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        value != null ? '$value' : '',
        style: AppUtils.cellTextStyle(),
      ),
    );
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
