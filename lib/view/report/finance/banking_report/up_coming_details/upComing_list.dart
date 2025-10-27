import 'package:abtxt/view/report/finance/banking_report/up_coming_details/upComing_Detail.dart';
import 'package:abtxt/view/report/finance/banking_report/up_coming_details/upComing_FilterData.dart';
import 'package:abtxt/widgets/flutter_shortcut_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../model/banking_report_model/BankingReportModel.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../../widgets/MyDataGridHeader.dart';
import '../../../../../widgets/MyFilterIconButton.dart';
import '../../../../../widgets/MySFDataGridItemTable.dart';
import '../../../../../widgets/MySubmitButton.dart';
import '../baking_report_controller.dart';

class UpcomingList extends StatefulWidget {
  const UpcomingList({super.key});

  static const String routeName = '/up_coming_list';

  @override
  State<UpcomingList> createState() => _UpcomingListState();
}

class _UpcomingListState extends State<UpcomingList> {
  BankingReportController controller = Get.put(BankingReportController());

  List<BankingReportModel> list = <BankingReportModel>[];
  late MyDataSource dataSource;
  TextEditingController totalAmountController =
      TextEditingController(text: "0.00");
  TextEditingController idController = TextEditingController();
  var totalAmount = "0.00".obs;
  var totalSelect = "0".obs;

  /// this is used for submitted details update purpose
  bool isEditable = false;
  int? id;

  final DataGridController _upcomingDataGridController = DataGridController();
  SelectionMode selectionMode = SelectionMode.multiple;

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    _initValue();
    controller.isPaymentTo.value = false;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _filter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankingReportController>(
      builder: (controller) {
        return ShortCutWidget(
          appBar: AppBar(
            title: const Text("Upcoming - Banking Report"),
            actions: const [],
          ),
          loadingStatus: controller.status.isLoading,
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.keyQ, control: true):
                GetBackIntent(),
            SingleActivator(LogicalKeyboardKey.keyS, control: true):
                SaveIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              GetBackIntent: SetCounterAction(perform: () {
                Get.back();
              }),
              SaveIntent: SetCounterAction(perform: () {
                submit();
              }),
            },
            child: FocusScope(
              autofocus: true,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),
                        Obx(
                          () => Text(
                            "Total Selection : ${totalSelect.value}",
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Obx(
                          () => RichText(
                            text: TextSpan(
                              text: "Total Amount : ",
                              style: const TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  text: totalAmount.value
                                      .myNumberFormat(totalAmount.value),
                                )
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        MyFilterIconButton(
                          onPressed: () => _filter(),
                          filterIcon:
                              controller.filterData != null ? true : false,
                          tooltipText: "${controller.filterData}",
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Flexible(child: upComingTable()),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Spacer(),
                        MySubmitButton(
                          onPressed:
                              controller.status.isLoading ? null : submit,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  submit() async {
    var items = _upcomingDataGridController.selectedRows;
    var selectedDetails = [];

    int? firstLedgerId;

    var paymentId = [];
    for (var row in items) {
      var id = row.getCells()[0].value;
      var challanNo = row.getCells()[1].value;
      var eDate = row.getCells()[2].value;
      var paymentType = row.getCells()[3].value;
      var ledgerName = row.getCells()[4].value;
      var payment = row.getCells()[5].value;
      var cgst = row.getCells()[6].value;
      var sgst = row.getCells()[7].value;
      var tds = row.getCells()[8].value;
      var payableAmount = row.getCells()[9].value;
      var ledgerId = row.getCells()[10].value;

      if (controller.isPaymentTo.value) {
        if (firstLedgerId == null) {
          firstLedgerId = ledgerId;
        } else if (ledgerId != firstLedgerId) {
          return AppUtils.infoAlert(
              message: "You selected the different ledger's.");
        }
      }
      paymentId.add(id);

      selectedDetails.add({
        "id": id,
        "challan_no": challanNo,
        "e_date": eDate,
        "payment_type": paymentType,
        "ledger_name": ledgerName,
        "total_amount": payment,
        "cgst": cgst,
        "sgst": sgst,
        "tds_amount": tds,
        "gross_amount": payableAmount,
      });
    }

    if (selectedDetails.isEmpty) {
      return AppUtils.infoAlert(
          message: "Please select the slip before proceeding.");
    }

    if (isEditable == true) {
      /// this is used for submitted details update purpose

      var request = {"payment_id": paymentId};

      var result = await controller.newDetailsAdd(id!, request);
      if (result == "success") {
        Get.back(result: "success");
      }
    } else {
      var result = await Get.toNamed(UpcomingDetail.routeName,
          arguments: selectedDetails);

      if (result == "success") {
        controller.isPaymentTo.value = false;
        totalAmount.value = "0.00";
        totalSelect.value = "0";
        _upcomingDataGridController.selectedIndex = -1;
        list.clear();
        dataSource.updateDataGridRows();
        _filter();
      }
    }
  }

  void _api({var request = const {}}) async {
    var response = await controller.paymentReport(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const UpcomingFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
    if (result != null) {
      totalAmount.value = "0.00";
      totalSelect.value = "0";
      _upcomingDataGridController.selectedIndex = -1;
      dataSource.updateDataGridRows();
      dataSource.notifyListeners();
    }
  }

  Widget button(Function onPress, String text) {
    return OutlinedButton(
      onPressed: onPress(),
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(100, 46)),
        shape: WidgetStateProperty.resolveWith(
          (s) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      child: Text(text),
    );
  }

  Widget upComingTable() {
    return ExcludeFocusTraversal(
      child: MySFDataGridItemTable(
        filtering: true,
        showCheckboxColumn: true,
        controller: _upcomingDataGridController,
        selectionMode: selectionMode,
        scrollPhysics: const ScrollPhysics(),
        shrinkWrapRows: false,
        columns: [
          GridColumn(
            visible: false,
            columnName: 'id',
            label: const MyDataGridHeader(title: 'Id'),
          ),
          GridColumn(
            allowFiltering: false,
            width: 100,
            columnName: 'slip',
            label: const MyDataGridHeader(title: 'Slip No'),
          ),
          GridColumn(
            columnName: 'e_date',
            label: const MyDataGridHeader(title: 'Date'),
            filterPopupMenuOptions:
                const FilterPopupMenuOptions(canShowSortingOptions: false),
          ),
          GridColumn(
            columnName: 'payment_type',
            label: const MyDataGridHeader(title: 'Payment Type'),
            filterPopupMenuOptions:
                const FilterPopupMenuOptions(canShowSortingOptions: false),
          ),
          GridColumn(
            columnName: 'ledger_name',
            label: const MyDataGridHeader(title: 'Ledger Name'),
            filterPopupMenuOptions:
                const FilterPopupMenuOptions(canShowSortingOptions: false),
          ),
          GridColumn(
            width: 150,
            columnName: 'total_amount',
            label: const MyDataGridHeader(
                alignment: Alignment.center, title: 'Payment'),
            filterPopupMenuOptions: const FilterPopupMenuOptions(
              canShowSortingOptions: false,
            ),
          ),
          GridColumn(
            width: 150,
            visible: controller.isPaymentTo.value == true,
            columnName: 'c_gst',
            label: const MyDataGridHeader(
                alignment: Alignment.center, title: 'C GST'),
            filterPopupMenuOptions: const FilterPopupMenuOptions(
              canShowSortingOptions: false,
            ),
          ),
          GridColumn(
            width: 150,
            columnName: 's_gst',
            visible: controller.isPaymentTo.value == true,
            label: const MyDataGridHeader(
                alignment: Alignment.center, title: 'S GST'),
            filterPopupMenuOptions: const FilterPopupMenuOptions(
              canShowSortingOptions: false,
            ),
          ),
          GridColumn(
            width: 150,
            columnName: 'tds',
            label: const MyDataGridHeader(
                alignment: Alignment.center, title: 'TDS'),
            filterPopupMenuOptions: const FilterPopupMenuOptions(
              canShowSortingOptions: false,
            ),
          ),
          GridColumn(
            width: 180,
            columnName: 'gross_amount',
            label: const MyDataGridHeader(
                alignment: Alignment.center, title: 'Payable Amount'),
            filterPopupMenuOptions: const FilterPopupMenuOptions(
              canShowSortingOptions: false,
            ),
          ),
          GridColumn(
            visible: false,
            columnName: 'ledger_id',
            label: const MyDataGridHeader(title: 'ledger_id'),
          ),
        ],
        tableSummaryRows: [
          GridTableSummaryRow(
            showSummaryInRow: false,
            title: "",
            titleColumnSpan: 1,
            columns: [
              const GridSummaryColumn(
                name: 'gross_amount',
                columnName: 'gross_amount',
                summaryType: GridSummaryType.sum,
              ),
            ],
            position: GridTableSummaryRowPosition.bottom,
          ),
        ],
        onSelectionChanged: (addedRows, removedRows) {
          double totalWages = 0.0;
          var items = _upcomingDataGridController.selectedRows;

          totalSelect.value = "${items.length}";
          for (var row in items) {
            var wages = double.tryParse("${row.getCells()[5].value}") ?? 0.0;

            totalWages += wages;
          }
          totalAmountController.text = "$totalWages";
          totalAmount.value = "$totalWages";
        },
        source: dataSource,
      ),
    );
  }

  void _initValue() {
    if (Get.arguments != null) {
      /// this is used for submitted details update purpose
      var item = Get.arguments;

      isEditable = item["is_edit"];
      id = item["id"];
    }
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<BankingReportModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<BankingReportModel> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e.id),
        DataGridCell<int>(columnName: 'challan_no', value: e.challanNo),
        DataGridCell<dynamic>(columnName: 'e_date', value: e.eDate),
        DataGridCell<dynamic>(columnName: 'payment_type', value: e.paymentType),
        DataGridCell<dynamic>(columnName: 'ledger_name', value: e.ledgerName),
        DataGridCell<dynamic>(columnName: 'total_amount', value: e.totalAmount),
        DataGridCell<dynamic>(columnName: 'c_gst', value: e.cgst),
        DataGridCell<dynamic>(columnName: 's_gst', value: e.sgst),
        DataGridCell<dynamic>(columnName: 'tds', value: e.tdsAmount),
        DataGridCell<dynamic>(columnName: 'gross_amount', value: e.grossAmount),
        DataGridCell<dynamic>(columnName: 'ledger_id', value: e.ledgerId),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      double value = double.tryParse('${dataGridCell.value}') ?? 0;
      final columnName = dataGridCell.columnName;
      switch (columnName) {
        case 'total_amount':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'c_gst':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 's_gst':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'tds':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'gross_amount':
          return buildFormattedCell(value, decimalPlaces: 2);
        default:
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              dataGridCell.value != null ? '${dataGridCell.value}' : '',
              style: AppUtils.cellTextStyle(),
            ),
          );
      }
    }).toList());
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
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    final columnName = summaryColumn?.columnName;
    double parsedValue = double.tryParse(summaryValue) ?? 0;
    TextAlign alignment;

    switch (columnName) {
      case 'gross_amount':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      default:
        return null;
    }
  }

  Widget _buildFormattedCell(double value,
      {int decimalPlaces = 0, required TextAlign alignment}) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      decimalDigits: decimalPlaces,
      name: '',
    );
    return Container(
      padding: const EdgeInsets.all(8.0),
      // alignment: Alignment.center,
      child: Text(
        formatter.format(value),
        style: AppUtils.footerTextStyle(),
        textAlign: alignment,
      ),
    );
  }
}
