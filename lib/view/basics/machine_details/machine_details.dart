import 'package:abtxt/flutter_core_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../utils/app_utils.dart';
import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'add_machine_details.dart';
import 'machine_details_controller.dart';

class MachineDetails extends StatefulWidget {
  const MachineDetails({super.key});

  static const String routeName = '/machine_details';

  @override
  State<MachineDetails> createState() => _MachineDetailsState();
}

class _MachineDetailsState extends State<MachineDetails> {
  MachineDetailsController controller = Get.put(MachineDetailsController());
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
    return GetBuilder<MachineDetailsController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Basic Info / Machine Details'),
          actions: [
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
              columnName: 'sno',
              label: const MyDataGridHeader(title: 'S.No'),
            ),
            GridColumn(
              columnName: 'm_name',
              label: const MyDataGridHeader(title: 'Machine Name'),
            ),
            GridColumn(
              columnName: 'm_type',
              label: const MyDataGridHeader(title: 'Machine Type'),
            ),
            GridColumn(
              columnName: 'particulars',
              label: const MyDataGridHeader(title: 'Particular'),
            ),
            GridColumn(
              columnName: 'wages',
              label: const MyDataGridHeader(title: 'Wages (Rs)'),
            ),
          ],
        ),
      );
    });
  }

  void _api() async {
    var response = await controller.machineDetails();
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result =
        await Get.toNamed(AddMachineDetails.routeName, arguments: args);
    if (result == "success") {
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
      var machineDetails = "";
      var particulars = "";
      var machineType = e['machine_type'];
      var wagesTyw = e['wages_type'];

      if (machineType == "Winder") {
        machineDetails = "$machineType, ${e["winding_type"]}";
      } else if (machineType == "TFO") {
        machineDetails = "$machineType, ${e["deck_type"]}, ${e["spendile"]}";
      } else {
        machineDetails = "$machineType, ${e["deck_type"]}, ${e["spendile"]}";
      }

      if (wagesTyw == "Kg") {
        particulars = "$wagesTyw - ${e["weight"]}";
      } else if (wagesTyw == "Lot") {
        particulars = "$wagesTyw - ${e["lots"]}";
      } else if (wagesTyw == "Meter") {
        particulars = "$wagesTyw - ${e["meter"]}";
      } else {
        particulars = "$wagesTyw - ${e["hours"]} Hour";
      }

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'sno', value: e['id']),
        DataGridCell<dynamic>(columnName: 'm_name', value: e['machine_name']),
        DataGridCell<dynamic>(columnName: 'm_type', value: machineDetails),
        DataGridCell<dynamic>(columnName: 'particulars', value: particulars),
        DataGridCell<dynamic>(columnName: 'wages', value: e['wages']),
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
