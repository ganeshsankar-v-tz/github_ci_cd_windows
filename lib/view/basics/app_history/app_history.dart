import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/http/http_urls.dart';
import 'package:abtxt/model/app_history/AppHistoryModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/app_history/app_history_filter.dart';
import 'package:abtxt/widgets/MyFilterIconButton.dart';
import 'package:abtxt/widgets/MyRefreshButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'app_history_controller.dart';
import 'app_history_full_details.dart';

class AppHistory extends StatefulWidget {
  const AppHistory({super.key});

  static const String routeName = '/app_history';

  @override
  State<AppHistory> createState() => _State();
}

class _State extends State<AppHistory> {
  AppHistoryController controller = Get.put(AppHistoryController());
  List<AppHistoryModel> list = <AppHistoryModel>[];
  late MyDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);

    _api(request: {"user_id": GetStorage().read("id")});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppHistoryController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('App History'),
          actions: [
            MyRefreshIconButton(
                onPressed: () => _api(request: controller.filterData ?? {})),
            const SizedBox(width: 12),
            MyFilterIconButton(
                onPressed: () => _filter(),
                filterIcon: controller.filterData != null ? true : false,
                tooltipText: "${controller.filterData}"),
            const SizedBox(width: 12),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
              _filter(),
          const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
              _api(request: controller.filterData ?? {}),
        },
        child: MySFDataGridRawTable(
          source: dataSource,
          isLoading: controller.status.isLoading,
          columns: [
            GridColumn(
              columnName: 'transaction_no',
              width: 130,
              label: const MyDataGridHeader(title: 'Transaction no'),
            ),
            GridColumn(
              width: 105,
              columnName: 'e_date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              width: 130,
              columnName: 'time',
              label: const MyDataGridHeader(title: 'Time'),
            ),
            GridColumn(
              minimumWidth: 250,
              columnName: 'name',
              label: const MyDataGridHeader(title: 'Name'),
            ),
            GridColumn(
              width: 150,
              columnName: 'role',
              label: const MyDataGridHeader(title: 'Role'),
            ),
            GridColumn(
              minimumWidth: 200,
              columnName: 'module',
              label: const MyDataGridHeader(title: 'Module'),
            ),
            GridColumn(
              columnName: 'changes',
              label: const MyDataGridHeader(title: 'Changes'),
            ),
          ],
          onRowSelected: (index) async {
            if(HttpUrl.baseUrl == "http://apiabtex.tamilzorous.com/"){
              return;
            }

            var item = list[index];
            Get.toNamed(
              AppHistoryFullDetails.routeName,
              arguments: { "item": item},
            );
          },
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.appHistoryDetails(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const AppHistoryFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<AppHistoryModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<AppHistoryModel> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      String role = '';

      if (e.role == "A") {
        role = "Admin";
      } else if (e.role == "U") {
        role = "User";
      }

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'transaction_no', value: e.id),
        DataGridCell<dynamic>(columnName: 'e_date', value: '${e.createdBy}'),
        DataGridCell<dynamic>(columnName: 'time', value: e.createdAt),
        DataGridCell<dynamic>(columnName: 'name', value: e.createdBy),
        DataGridCell<dynamic>(columnName: 'role', value: role),
        DataGridCell<dynamic>(columnName: 'module', value: e.module),
        DataGridCell<dynamic>(columnName: 'changes', value: e.action),
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
