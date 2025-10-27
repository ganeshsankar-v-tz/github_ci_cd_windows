import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/trasaction/payment_v2/add_payment_v2.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_dyer/add_warp_Inward_from_dyer.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_dyer/warp_Inward_from_dyer_controller.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_dyer/warp_Inward_from_dyer_payment_details.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_dyer/warp_inwaard_fromdyer_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/WarpInwardFromdyerModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';

class WarpInwardFromDyer extends StatefulWidget {
  const WarpInwardFromDyer({super.key});

  static const String routeName = '/WarpInwardFromDyer';

  @override
  State<WarpInwardFromDyer> createState() => _State();
}

class _State extends State<WarpInwardFromDyer> {
  WarpInwardFromDyerController controller =
      Get.put(WarpInwardFromDyerController());
  List<WarpInwardFromDyerModel> list = <WarpInwardFromDyerModel>[];
  late MyDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    _api();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpInwardFromDyerController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Transaction / Warp Inward From Dyer'),
          actions: [
            MyRefreshIconButton(
                onPressed: () => _api(request: controller.filterData ?? {})),
            const SizedBox(width: 12),
            Tooltip(
              message: 'Payment Details (Shift+P)',
              child: ElevatedButton(
                onPressed: () {
                  _payDetails();
                },
                child: const Text("Payment Details"),
              ),
            ),
            const SizedBox(width: 12),
            Tooltip(
              message: 'Payment (Ctrl+P)',
              child: ElevatedButton(
                onPressed: () {
                  _paymentScreen();
                },
                child: const Text("Payment"),
              ),
            ),
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
          const SingleActivator(LogicalKeyboardKey.keyP, shift: true): () =>
              _payDetails(),
          const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
              _api(request: controller.filterData ?? {}),
          const SingleActivator(LogicalKeyboardKey.keyP, control: true): () =>
              _paymentScreen(),
        },
        child: MySFDataGridRawTable(
          selectionMode: SelectionMode.single,
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            _add(args: {'item': item});
          },
          columns: [
            /*GridColumn(
              columnName: 'action',
              allowFiltering: false,
              allowSorting: false,
              width: 40,
              label: const Center(child: Text('')),
            ),*/
            GridColumn(
              columnName: 'id',
              width: 80,
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 105,
              columnName: 'e_date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              width: 280,
              columnName: 'firm_name',
              label: const MyDataGridHeader(title: 'Firm Name'),
            ),
            GridColumn(
              width: 120,
              columnName: 'reference_no',
              label: const MyDataGridHeader(title: 'Ref No'),
            ),
            GridColumn(
              width: 280,
              columnName: 'dyer_name',
              label: const MyDataGridHeader(title: 'Dyer Name'),
            ),
            GridColumn(
              width: 120,
              columnName: 'inward_warps',
              label: const MyDataGridHeader(title: 'Warps'),
            ),
            GridColumn(
              width: 120,
              columnName: 'total_wages',
              label: const MyDataGridHeader(title: 'Wages(Rs)'),
            ),
            GridColumn(
              columnName: 'details',
              label: const MyDataGridHeader(title: 'Details'),
            ),
            GridColumn(
              columnName: 'wages_status',
              label: const MyDataGridHeader(title: 'Status'),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.warpInwardDyer(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddWarpInwardFromDyer.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _payDetails() async {
    showDialog(
      context: context,
      builder: (_) => const WarpInwardFromDyerPayDetails(),
    );
  }

  void _paymentScreen() async {
    var arg = {
      "firm_name": "A B TEX PRIVATE LIMITED",
      "payment_type": "Dyer Amount",
    };

    Get.toNamed(AddPaymentV2.routeName, arguments: arg);
  }

  /*void _multiselect() async {
    Map<String, dynamic> request = {};
    List<WarpInwardFromDyerModel?> selected = [];
    HashSet<int> idSet = HashSet();
    for (WarpInwardFromDyerModel model in list) {
      if (model.select!) {
        selected.add(model);
        idSet.add(model.dyerId!);
        double netTotal = 0;
        var date = AppUtils.parseDateTime("${DateTime.now()}");
        for (var i = 0; i < selected.length; i++) {
          netTotal += double.tryParse("${selected[i]?.totalWages}") ?? 0.0;
          var item = {
            "e_date": date,
            "debit_amount": netTotal,
            "firm_id": selected[i]?.firmId,
            "firm_name": selected[i]?.firmName,
            "ledger_id": selected[i]?.dyerId,
            "ledger_name": selected[i]?.dyerName,
          };
          request["item"] = item;
        }
      }
    }
    if (selected.isNotEmpty) {
      if (idSet.length == 1) {
        var result = await Get.toNamed(
          AddPayment.routeName,
          arguments: request,
        );
        if (result == 'success') {
          _api();
        }
      } else {
        AppUtils.showErrorToast(message: "Multiple Dyer Name Selected");
      }
    } else {
      AppUtils.showErrorToast(message: "Selected The Dyer Name");
    }
  }*/

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const WarpInwardFromDyerFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<WarpInwardFromDyerModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<WarpInwardFromDyerModel> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        // const DataGridCell(columnName: 'action', value: null),
        DataGridCell<int>(columnName: 'id', value: e.id),
        DataGridCell<dynamic>(columnName: 'e_date', value: e.eDate),
        DataGridCell<dynamic>(columnName: 'firm_name', value: e.firmName),
        DataGridCell<dynamic>(columnName: 'reference_no', value: e.referenceNo),
        DataGridCell<dynamic>(columnName: 'dyer_name', value: e.dyerName),
        DataGridCell<int>(columnName: 'inward_warps', value: e.inwardWarps),
        DataGridCell<dynamic>(columnName: 'total_wages', value: e.totalWages),
        DataGridCell<dynamic>(columnName: 'details', value: e.details),
        DataGridCell<dynamic>(columnName: 'wages_status', value: e.wagesStatus),
      ]);
    }).toList();
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
  DataGridRowAdapter buildRow(DataGridRow row) {
    final index = _employeeData.indexOf(row);
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        double value = double.tryParse('${e.value}') ?? 0;
        final columnName = e.columnName;
        switch (columnName) {
          case 'total_wages':
            return buildFormattedCell(value, decimalPlaces: 2);
          default:
            return Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (e.columnName == 'action') {
                      return Checkbox(
                        value: _list[index].select,
                        onChanged: (bool? value) {
                          if (_list[index].wagesStatus == "Pending") {
                            _list[index].select = value;
                          } else {
                            AppUtils.showErrorToast(message: "Already Paid");
                          }
                          notifyDataSourceListeners(
                              rowColumnIndex: RowColumnIndex(index, 0));
                        },
                      );
                    } else {
                      return Text(
                        e.value != null ? '${e.value}' : '',
                        style: AppUtils.cellTextStyle(),
                      );
                    }
                  },
                ));
        }
      }).toList(),
    );
  }
}
