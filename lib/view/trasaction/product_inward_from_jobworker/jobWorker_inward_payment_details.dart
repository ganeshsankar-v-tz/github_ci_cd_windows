import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/payment_models/PayDetailsHistoryModel.dart';
import 'package:abtxt/view/trasaction/product_inward_from_jobworker/product_inward_from_jobworker_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/LedgerModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import '../../../widgets/MySubmitButton.dart';

class JobWorkerInwardPaymentDetails extends StatefulWidget {
  const JobWorkerInwardPaymentDetails({Key? key}) : super(key: key);

  @override
  State<JobWorkerInwardPaymentDetails> createState() => _State();
}

class _State extends State<JobWorkerInwardPaymentDetails> {
  Rxn<LedgerModel> jobWorker = Rxn<LedgerModel>();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ProductInwardFromJobWorkerController controller = Get.find();
  var itemList = <PayDetailsHistoryModel>[];
  late ItemDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = ItemDataSource(list: itemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductInwardFromJobWorkerController>(
        builder: (controller) {
      return CoreWidget(
        appBar: AppBar(title: const Text('JobWorker Payment Details')),
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
        },
        loadingStatus: controller.status.isLoading,
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
                          label: 'JobWorker Name',
                          items: controller.jobWorkerName,
                          selectedItem: jobWorker.value,
                          onChanged: (LedgerModel item) async {
                            jobWorker.value = item;
                            itemList.clear();
                            dataSource.updateDataGridSource();
                            dataSource.updateDataGridRows();
                            fromDateController.text = "";
                            toDateController.text = "";
                            var request = {
                              "job_worker_id": jobWorker.value?.id,
                            };
                            var result =
                                await controller.payDetails(request: request);
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
                SizedBox(
                  height: constraint.maxHeight - 100,
                  child: itemsTable(),
                )
              ],
            ),
          );
        }),
      );
    });
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      itemList.clear();
      dataSource.updateDataGridSource();
      dataSource.updateDataGridRows();
      var request = {
        "job_worker_id": jobWorker.value?.id,
        "from_date": fromDateController.text,
        "to_date": toDateController.text,
      };
      var result = await controller.payDetails(request: request);
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
