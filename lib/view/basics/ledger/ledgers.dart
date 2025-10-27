import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/http/http_urls.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/ledger/addledger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../utils/constant.dart';
import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'ledger_controller.dart';
import 'ledger_filter_screen.dart';

class Ledgers extends StatefulWidget {
  const Ledgers({super.key});

  static const String routeName = '/ledger';

  @override
  State<Ledgers> createState() => _State();
}

class _State extends State<Ledgers> {
  LedgerController controller = Get.put(LedgerController());
  List<dynamic> list = <dynamic>[];
  late MyDataSource dataSource;
  RxSet<String> selected = {''}.obs;
  int? selectIndex;

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    _api();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LedgerController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: segmentWidget(),
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
          columns: [
            GridColumn(
              width: 80,
              columnName: 'id',
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 80,
              allowSorting: false,
              allowFiltering: false,
              columnName: 'image',
              label: const MyDataGridHeader(title: 'Photo'),
            ),
            GridColumn(
              width: 280,
              columnName: 'ledger_name',
              label: const MyDataGridHeader(title: 'Ledger Name'),
            ),
            GridColumn(
              width: 230,
              columnName: 'account_type',
              label: const MyDataGridHeader(title: 'Account Type'),
            ),
            GridColumn(
              width: 140,
              columnName: 'ledger_role_name',
              label: const MyDataGridHeader(title: 'Role'),
            ),
            GridColumn(
              width: 150,
              columnName: 'mobile_no',
              label: const MyDataGridHeader(title: 'Mobile No'),
            ),
            GridColumn(
              // width: 230,
              columnName: 'area_name',
              label: const MyDataGridHeader(title: 'Area'),
            ),
            GridColumn(
              width: 150,
              columnName: 'city_name',
              label: const MyDataGridHeader(title: 'City'),
            ),
            // GridColumn(
            //   columnName: 'transport',
            //   label: const MyDataGridHeader(title: 'Transport'),
            // ),
            GridColumn(
              width: 120,
              columnName: 'is_active',
              label: const MyDataGridHeader(title: 'Is Active'),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _api({var request = const {}}) async {
    var response = await controller.ledgers(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    if (controller.loading == true) {
      return;
    }
    var result = await Get.toNamed(AddLedger.routeName, arguments: args);
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const LedgerFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
  }

  segmentWidget() {
    return MaterialSegmentedControl(
      children: rolls,
      selectionIndex: selectIndex,
      selectedColor: Colors.grey.shade200,
      unselectedColor: Colors.white,
      selectedTextStyle: const TextStyle(
          color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold),
      unselectedTextStyle: const TextStyle(
          color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
      borderWidth: 0.5,
      borderRadius: 15,
      onSegmentTapped: (index) {
        setState(() {
          selectIndex = index;
        });
        selectedValue(index);
      },
    );
  }

  final Map<int, Widget> rolls = {
    0: const SizedBox(
      width: 100,
      child: Center(
          child: Text(
        "ROLLER",
      )),
    ),
    1: const SizedBox(
      width: 100,
      child: Center(
          child: Text(
        "WINDER",
      )),
    ),
    2: const SizedBox(
      width: 100,
      child: Center(
          child: Text(
        "WARPER",
      )),
    ),
    3: const SizedBox(
      width: 100,
      child: Center(
          child: Text(
        "DYER",
      )),
    ),
    4: const SizedBox(
      width: 100,
      child: Center(
          child: Text(
        "WEAVER",
      )),
    ),
    5: const SizedBox(
      width: 100,
      child: Center(
          child: Text(
        "SUPPLIER",
      )),
    ),
    6: const SizedBox(
      width: 100,
      child: Center(
          child: Text(
        "CUSTOMERS",
      )),
    ),
  };

  Future<void> selectedValue(int index) async {
    controller.filterData = {};

    String? rollName;
    if (index == 0) {
      rollName = "roller";
    } else if (index == 1) {
      rollName = "winder";
    } else if (index == 2) {
      rollName = "warper";
    } else if (index == 3) {
      rollName = "dyer";
    } else if (index == 4) {
      rollName = "weaver";
    } else if (index == 5) {
      rollName = "supplier";
    } else if (index == 6) {
      rollName = "customer";
    }
    controller.filterData = {'ledger_role': rollName};
    await _api(request: controller.filterData);
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

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(builder: (context, constraints) {
          if (e.columnName == 'image') {
            return CachedNetworkImage(
              height: 40,
              width: 40,
              fit: BoxFit.cover,
              imageUrl: "${HttpUrl.baseUrl}${e.value.toString()}",
              errorWidget: (context, url, error) => Image.asset(
                Constants.placeHolderPath,
                fit: BoxFit.cover,
              ),
            );
          } else {
            return Text(
              e.value != null ? '${e.value}' : '',
              style: AppUtils.cellTextStyle(),
            );
          }
        }),
      );
    }).toList());
  }

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e['id']),
        DataGridCell<dynamic>(columnName: 'image', value: '${e['image']}'),
        DataGridCell<dynamic>(
            columnName: 'ledger_name', value: e['ledger_name']),
        DataGridCell<dynamic>(
            columnName: 'accout_type', value: e['accout_type']),
        DataGridCell<dynamic>(columnName: 'ledger_role', value: role(e)),
        DataGridCell<dynamic>(columnName: 'mobile_no', value: e['mobile_no']),
        DataGridCell<dynamic>(columnName: 'area', value: e['area']),
        DataGridCell<dynamic>(columnName: 'city', value: e['city']),
        DataGridCell<dynamic>(columnName: 'is_active', value: e['is_active']),
        // DataGridCell<dynamic>(columnName: 'transport', value: e['transport']),
      ]);
    }).toList();
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

  role(dynamic item) {
    var role = [];
    if (item['supplier'] == 'Yes') {
      role.add('Supplier');
    }
    if (item['customer'] == 'Yes') {
      role.add('Customer');
    }
    if (item['warper'] == 'Yes') {
      role.add('Warper');
    }
    if (item['weaver'] == 'Yes') {
      role.add('Weaver');
    }
    if (item['dyer'] == 'Yes') {
      role.add('Dyer');
    }
    if (item['roller'] == 'Yes') {
      role.add('Roller');
    }
    if (item['employee'] == 'Yes') {
      role.add('Employee');
    }
    if (item['processor'] == 'Yes') {
      role.add('Processor');
    }
    if (item['job_worker'] == 'Yes') {
      role.add('Job_Worker');
    }
    if (item['winder'] == 'Yes') {
      role.add('Winder');
    }
    if (item['operator'] == 'Yes') {
      role.add('Operator');
    }

    return role.join(', ');
  }
}
