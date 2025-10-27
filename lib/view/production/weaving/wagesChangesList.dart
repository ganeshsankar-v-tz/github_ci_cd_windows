import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/production/weaving/weaving_controller.dart';
import 'package:abtxt/view/trasaction/yarn_purchase/yarn_purchase_filter.dart';
import 'package:abtxt/widgets/MyAddItemButton.dart';
import 'package:abtxt/widgets/MyFilterIconButton.dart';
import 'package:abtxt/widgets/MyRefreshButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridRawTable.dart';

class WagesChangesList extends StatefulWidget {
  const WagesChangesList({super.key});

  static const String routeName = '/WagesChangesListList';

  @override
  State<WagesChangesList> createState() => _State();
}

class _State extends State<WagesChangesList> {
  WeavingController controller = Get.put(WeavingController());
  List<dynamic> list = <dynamic>[];
  late MyDataSource dataSource;

  int? id;

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    id = controller.request["weaving_ac_id"];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _api();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeavingController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Wages Changes List'),
        ),
        loadingStatus: controller.status.isLoading,
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
              _api(),
        },
        child: MySFDataGridRawTable(
          source: dataSource,
          isLoading: controller.status.isLoading,
          columns: [
            GridColumn(
              width: 105,
              columnName: 'e_date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              columnName: 'product_name',
              label: const MyDataGridHeader(title: 'Product Name'),
            ),
            GridColumn(
              columnName: 'wages',
              label: const MyDataGridHeader(title: 'Wages'),
            ),
            GridColumn(
              columnName: 'update_by',
              label: const MyDataGridHeader(title: 'Update By'),
            ),
            GridColumn(
              columnName: 'entry_status',
              label: const MyDataGridHeader(title: 'Status'),
            ),
          ],
        ),
      );
    });
  }

  void _api() async {
    var response = await controller.wagesChangeListDetails(id);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
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
        DataGridCell<dynamic>(columnName: 'e_date', value: '${e['e_date']}'),
        DataGridCell<dynamic>(
            columnName: 'product_name', value: '${e['product_name']}'),
        DataGridCell<dynamic>(columnName: 'wages', value: '${e['wages']}'),
        DataGridCell<dynamic>(
            columnName: 'updated_name', value: '${e['updated_name'] ?? ""}'),
        DataGridCell<dynamic>(
            columnName: 'entry_status', value: '${e['entry_status']}'),
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
}
