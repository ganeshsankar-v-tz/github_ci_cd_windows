import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/vehicle_details/VehicleDetailsModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/vehicle_details/add_vehicle_details.dart';
import 'package:abtxt/view/basics/vehicle_details/vehicle_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';

class VehicleDetails extends StatefulWidget {
  const VehicleDetails({super.key});

  static const String routeName = '/vehicle_details';

  @override
  State<VehicleDetails> createState() => _State();
}

class _State extends State<VehicleDetails> {
  VehicleDetailsController controller = Get.put(VehicleDetailsController());
  List<VehicleDetailsModel> list = <VehicleDetailsModel>[];
  late MyDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    _api();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VehicleDetailsController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Basic Info / Vehicle Details'),
          actions: [
            MyRefreshIconButton(onPressed: () => _api()),
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
          const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
              _api(),
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
              columnName: 'transport_name',
              label: const MyDataGridHeader(title: 'Vehicle Name'),
            ),
            GridColumn(
              columnName: 'vehicle_no',
              label: const MyDataGridHeader(title: 'Vehicle No'),
            ),
            GridColumn(
              columnName: 'vehicle_gst',
              label: const MyDataGridHeader(title: 'GST No'),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.vehicleDetails(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result =
        await Get.toNamed(AddVehicleDetails.routeName, arguments: args);
    if (result == 'success') {
      _api();
    }
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<VehicleDetailsModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<VehicleDetailsModel> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e.id),
        DataGridCell<dynamic>(
            columnName: 'transport_name', value: e.transportName),
        DataGridCell<dynamic>(columnName: 'vehicle_no', value: e.vehicleNo),
        DataGridCell<dynamic>(columnName: 'vehicle_gst', value: e.vehicleGst),
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
