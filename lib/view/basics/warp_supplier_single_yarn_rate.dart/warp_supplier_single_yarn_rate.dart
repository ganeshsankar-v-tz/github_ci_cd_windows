import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/basics/warp_supplier_single_yarn_rate.dart/warp_supplier_single_yarn_rate_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../model/WarpSupplierSingleYarnRateModel.dart';
import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import '../../../widgets/MySFDataGridTable.dart';
import '../../adjustments/alternative_warp_design/alternative_warp_design_list.dart';
import 'add_warp_supplier_single_yarn_rate.dart';

class WarpSupplierSingleYarnRate extends StatefulWidget {
  const WarpSupplierSingleYarnRate({Key? key}) : super(key: key);
  static const String routeName = '/WarpingSupplierSingleYarnRate';

  @override
  State<WarpSupplierSingleYarnRate> createState() => _State();
}

class _State extends State<WarpSupplierSingleYarnRate> {
  WarpSupplierSingleYarnRateController controller =
      Get.put(WarpSupplierSingleYarnRateController());
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
    return GetBuilder<WarpSupplierSingleYarnRateController>(
        builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Basic Info / Warp Supplier Single Yarn Rate'),
          actions: [
            MyAddItemButton(onPressed: () => _add()),
            SizedBox(width: 12),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () => Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyN, control: true): () => _add(),
        },
        child: MySFDataGridRawTable(
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            // await Get.toNamed(AddWarpSupplierSingleYarnRate.routeName,
            //     arguments: {"item": item});
            _add(args: {'item': item});
          },
          columns: <GridColumn>[
            GridColumn(
              width: 80,
              columnName: 'id',
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              columnName: 'wrap_suppliers_id',
              label: const MyDataGridHeader(title: 'Supplier Name'),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.warping(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddWarpSupplierSingleYarnRate.routeName,
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
            columnName: 'supplier_name', value: e['supplier_name']),
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
