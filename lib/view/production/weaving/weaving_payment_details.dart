import 'package:abtxt/model/payment_models/PayDetailsHistoryModel.dart';
import 'package:abtxt/model/weaving_models/WeaverLoomDetailsModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/production/weaving/weaving_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import '../../../widgets/MySubmitButton.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class WeavingPaymentDetails extends StatefulWidget {
  const WeavingPaymentDetails({Key? key}) : super(key: key);

  @override
  State<WeavingPaymentDetails> createState() => _State();
}

class _State extends State<WeavingPaymentDetails> {
  Rxn<WeaverLoomDetailsModel> weaverName = Rxn<WeaverLoomDetailsModel>();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late ItemDataSource dataSource;
  var itemList = <PayDetailsHistoryModel>[];

  WeavingController controller = Get.find();

  @override
  void initState() {
    super.initState();
    dataSource = ItemDataSource(list: itemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeavingController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(title: const Text('Weaver Payment Details')),
        // bindings: {
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
        //       Get.back(),
        // },
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      padding: const EdgeInsets.all(12),
                      child: Form(
                        key: _formKey,
                        child: Wrap(
                          children: [
                            MyAutoComplete(
                              label: 'Weaver',
                              items: controller.weaverList,
                              selectedItem: weaverName.value,
                              onChanged: (WeaverLoomDetailsModel item) async {
                                weaverName.value = item;
                                itemList.clear();
                                dataSource.updateDataGridSource();
                                dataSource.updateDataGridRows();
                                fromDateController.text = "";
                                toDateController.text = "";
                                var request = {"weaver_id": item.id};
                                var result = await controller.paymentHistory(
                                    request: request);
                                for (var e in result) {
                                  itemList.add(e);
                                  dataSource.updateDataGridSource();
                                  dataSource.updateDataGridRows();
                                }
                              },
                            ),
                            MyDateFilter(
                              controller: fromDateController,
                              labelText: "From Date",
                            ),
                            MyDateFilter(
                              controller: toDateController,
                              labelText: "To Date",
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  right: 8, bottom: 8, top: 15),
                              child: MySubmitButton(
                                onPressed: () {
                                  submit();
                                },
                                // child: Text(Get.arguments == null ? 'Save' : 'Update'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: constraint.maxHeight,
                      padding: const EdgeInsets.all(12),
                      child: itemsTable(),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      );
    });
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      itemList.clear();
      dataSource.updateDataGridSource();
      dataSource.updateDataGridRows();
      var request = {
        "weaver_id": controller.request["weaver_id"],
        "from_date": fromDateController.text,
        "to_date": toDateController.text,
      };
      var result = await controller.paymentHistory(request: request);
      for (var e in result) {
        itemList.add(e);
        dataSource.updateDataGridSource();
        dataSource.updateDataGridRows();
      }
    }
  }

  Widget itemsTable() {
    return MySFDataGridRawTable(
      source: dataSource,
      isLoading: controller.status.isLoading,
      columns: [
        GridColumn(
          columnName: 's_no',
          width: 80,
          label: const MyDataGridHeader(title: 'S.No'),
        ),
        GridColumn(
          width: 120,
          columnName: 'e_date',
          label: const MyDataGridHeader(title: 'Date'),
        ),
        GridColumn(
          width: 120,
          columnName: 'challan_no',
          label: const MyDataGridHeader(title: 'Challan No'),
        ),
        GridColumn(
          columnName: 'firm_name',
          label: const MyDataGridHeader(title: 'Firm'),
        ),
        GridColumn(
          columnName: 'paymentType',
          label: const MyDataGridHeader(title: 'To'),
        ),
        GridColumn(
          columnName: 'through',
          label: const MyDataGridHeader(title: 'Through'),
        ),
        GridColumn(
          width: 120,
          columnName: 'credit',
          label: const MyDataGridHeader(title: 'Credit'),
        ),
        GridColumn(
          width: 120,
          columnName: 'debit',
          label: const MyDataGridHeader(title: 'Debit'),
        ),
        GridColumn(
          columnName: 'details',
          label: const MyDataGridHeader(title: 'Details'),
        ),
      ],
      tableSummaryColumns: const [
        GridSummaryColumn(
          name: 'credit',
          columnName: 'credit',
          summaryType: GridSummaryType.sum,
        ),
        GridSummaryColumn(
          name: 'debit',
          columnName: 'debit',
          summaryType: GridSummaryType.sum,
        ),
      ],
    );
  }
}

class ItemDataSource extends DataGridSource {
  ItemDataSource({
    required List<PayDetailsHistoryModel> list,
  }) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<PayDetailsHistoryModel> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var index = _list.indexOf(e);

      num? debitAmount;
      num? creditAmount;
      if (e.paymentType == "Roller Amount") {
        if (e.debitAmount != 0) {
          debitAmount = e.debitAmount;
        }
      } else {
        creditAmount = e.debitAmount;
      }

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 's_no', value: "${index + 1}"),
        DataGridCell<dynamic>(columnName: 'e_date', value: e.eDate),
        DataGridCell<dynamic>(columnName: 'challan_no', value: e.challanNo),
        DataGridCell<dynamic>(columnName: 'firm_name', value: e.firmName),
        DataGridCell<dynamic>(columnName: 'paymentType', value: e.paymentType),
        DataGridCell<dynamic>(columnName: 'through', value: e.to),
        DataGridCell<dynamic>(columnName: 'credit', value: creditAmount),
        DataGridCell<dynamic>(columnName: 'debit', value: debitAmount),
        DataGridCell<dynamic>(columnName: 'details', value: e.details),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      TextStyle? getTextStyle() {
        if (dataGridCell.columnName == 'debit') {
          return const TextStyle(
            color: Colors.redAccent,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          );
        } else {
          AppUtils.cellTextStyle();
        }
        return null;
      }

      return Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          dataGridCell.value != null ? "${dataGridCell.value}" : '',
          style: getTextStyle(),
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

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
