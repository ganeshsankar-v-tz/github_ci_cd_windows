import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/saree_checker/SareeCheckerModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/warp_checker/warp_checker_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'add_warp_checker.dart';

class WarpChecker extends StatefulWidget {
  const WarpChecker({super.key});

  static const String routeName = '/warp_checker';

  @override
  State<WarpChecker> createState() => _State();
}

class _State extends State<WarpChecker> {
  WarpCheckerController controller = Get.find();
  List<SareeCheckerModel> list = <SareeCheckerModel>[];
  late MyDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    _api();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpCheckerController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Basic Info / Warp Checker'),
          actions: [
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
              columnName: 'name',
              label: const MyDataGridHeader(title: 'Checker Name'),
            ),
            // GridColumn(
            //   columnName: 'cell_no',
            //   label: const MyDataGridHeader(title: 'Cell No'),
            // ),
            // GridColumn(
            //   columnName: 'area',
            //   label: const MyDataGridHeader(title: 'Area'),
            // ),
            GridColumn(
              columnName: 'active',
              label: const MyDataGridHeader(title: 'Is Active'),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.checkerDetails(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(AddWarpChecker.routeName, arguments: args);
    if (result == 'success') {
      _api();
    }
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<SareeCheckerModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<SareeCheckerModel> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e.id),
        DataGridCell<dynamic>(columnName: 'name', value: e.checkerName),
        // DataGridCell<dynamic>(columnName: 'cell_no', value: e.cellNo),
        // DataGridCell<dynamic>(columnName: 'area', value: e.area),
        DataGridCell<dynamic>(columnName: 'active', value: e.isActive),
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
