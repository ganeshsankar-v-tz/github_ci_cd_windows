//product_weft_requirements

import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/product_weft_requirements/add_product_weft_requirements.dart';
import 'package:abtxt/view/basics/product_weft_requirements/product_weft_requirements_controller.dart';
import 'package:abtxt/view/basics/product_weft_requirements/product_weft_requirements_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../flutter_core_widget.dart';
import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';

class ProductWeftRequirements extends StatefulWidget {
  const ProductWeftRequirements({super.key});

  static const String routeName = '/product_weft_requirements';

  @override
  State<ProductWeftRequirements> createState() =>
      _ProductWeftRequirementsState();
}

class _ProductWeftRequirementsState extends State<ProductWeftRequirements> {
  ProductWeftRecuirementsController controller =
      Get.put(ProductWeftRecuirementsController());
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
    return GetBuilder<ProductWeftRecuirementsController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Basic Info / Product Weft Requirements'),
          actions: [
            MyRefreshIconButton(onPressed: () => _api(request: controller.filterData ?? {})),
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
        loadingStatus: controller.status.isLoading,
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
              columnName: 'id',
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 400,
              columnName: 'product_name',
              label: const MyDataGridHeader(title: 'Product Name'),
            ),
            GridColumn(
              columnName: 'design_no',
              label: const MyDataGridHeader(title: 'Design No'),
            ),
            GridColumn(
              columnName: 'requirements',
              label: const MyDataGridHeader(title: 'Requirement for'),
            ),
            GridColumn(
              columnName: 'weft_for_saree',
              label: const MyDataGridHeader(title: 'Weft for'),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response =
        await controller.ProductWeftRecuirementsList(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddProductWeftRecuirements.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const ProductWeftRequirementsFilter(),
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
        // DataGridCell<dynamic>(columnName: 'created_at', value: e['created_at']),
        DataGridCell<dynamic>(
            columnName: 'product_name', value: e['product_name']),
        DataGridCell<dynamic>(columnName: 'design_no', value: e['design_no']),
        DataGridCell<dynamic>(
            columnName: 'requirements', value: e['requirements']),
        DataGridCell<dynamic>(
            columnName: 'weft_for_saree', value: e['weft_for_saree']),
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
