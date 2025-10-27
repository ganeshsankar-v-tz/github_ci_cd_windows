import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/production/weaving_weft_balance/private_weft_requirement/private_weft_requirement_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../flutter_core_widget.dart';
import '../../../../model/weaving_models/weft_balance/PrivateWeftRequirementListModel.dart';
import '../../../../widgets/MyDataGridHeader.dart';
import '../../../../widgets/MySFDataGridRawTable.dart';

class PrivateWeftRequirements extends StatefulWidget {
  const PrivateWeftRequirements({super.key});

  static const String routeName = '/private_weft_requirements_list';

  @override
  State<PrivateWeftRequirements> createState() =>
      _PrivateWeftRequirementsState();
}

class _PrivateWeftRequirementsState extends State<PrivateWeftRequirements> {
  PrivateWeftRequirementController controller =
      Get.put(PrivateWeftRequirementController());
  List<PrivateWeftRequirementListModel> itemList =
      <PrivateWeftRequirementListModel>[];
  late MyDataSource dataSource;

  @override
  void initState() {
    _initValue();
    super.initState();
    dataSource = MyDataSource(list: itemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrivateWeftRequirementController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Private Weft Requirements'),
        ),
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
        },
        loadingStatus: controller.status.isLoading,
        child: MySFDataGridRawTable(
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            PrivateWeftRequirementListModel item = itemList[index];
            Get.back(result: item);
            /*var request = {
              "id": item.weavingAcId,
              "product_id": item.productId,
              "loom": item.loom,
              "weaver_name": item.weaverName,
            };*/
          },
          columns: [
            GridColumn(
              columnName: 'product_name',
              label: const MyDataGridHeader(title: 'Product Name'),
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

  void _initValue() {
    if (Get.arguments != null) {
      var item = Get.arguments["id"];
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        List<PrivateWeftRequirementListModel> data =
            await controller.listScreen(item);
        itemList.addAll(data);
        dataSource.updateDataGridRows();
        dataSource.notifyListeners();
      });
    }
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<PrivateWeftRequirementListModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<PrivateWeftRequirementListModel> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'product_name', value: e.productName),
        DataGridCell<dynamic>(columnName: 'requirements', value: e.reqFor),
        DataGridCell<dynamic>(columnName: 'weft_for_saree', value: e.noOfUnit),
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
