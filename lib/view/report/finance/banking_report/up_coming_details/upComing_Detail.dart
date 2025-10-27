import 'dart:convert';

import 'package:abtxt/model/banking_report_model/BankingReportModel.dart';
import 'package:abtxt/widgets/MySFDataGridItemTable.dart';
import 'package:abtxt/widgets/flutter_shortcut_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../model/FirmModel.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../../widgets/MyDataGridHeader.dart';
import '../../../../../widgets/MyDateFilter.dart';
import '../../../../../widgets/MyDropdownButtonFormField.dart';
import '../../../../../widgets/MySubmitButton.dart';
import '../../../../../widgets/MyTextField.dart';
import '../../../../../widgets/my_search_field/my_search_field.dart';
import '../baking_report_controller.dart';

class UpcomingDetail extends StatefulWidget {
  const UpcomingDetail({super.key});

  static const String routeName = '/upcoming_details';

  @override
  State<UpcomingDetail> createState() => _State();
}

class _State extends State<UpcomingDetail> {
  BankingReportController controller = Get.put(BankingReportController());

  Rxn<FirmModel> firmNameController = Rxn<FirmModel>();
  TextEditingController firmTextController = TextEditingController();
  TextEditingController paymentDateController = TextEditingController();
  TextEditingController chequeNoController = TextEditingController();
  TextEditingController bankNameController = TextEditingController(text: 'TMB');
  TextEditingController branchNameController =
      TextEditingController(text: "Elampillai");

  var paymentType = TextEditingController(text: "Direct");
  var paymentMode = TextEditingController(text: "Cheque");

  final _formKey = GlobalKey<FormState>();
  final FocusNode _firmFocusNode = FocusNode();
  final FocusNode _paymentTypeFocusNode = FocusNode();
  RxBool isChequeNoVisible = RxBool(true);
  RxBool isVisible = RxBool(true);

  List<BankingReportModel> itemDetails = <BankingReportModel>[];
  late MyDataSource dataSource;

  final DataGridController _upcomingDataGridController = DataGridController();

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: itemDetails);
    _initValue();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankingReportController>(
      builder: (controller) {
        return ShortCutWidget(
          appBar: AppBar(
            title: const Text("Upcoming - Select Report"),
            actions: const [],
          ),
          loadingStatus: controller.status.isLoading,
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.keyQ, control: true):
                GetBackIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              GetBackIntent: SetCounterAction(perform: () {
                Get.back();
              }),
            },
            child: FocusScope(
              autofocus: true,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Wrap(
                        children: [
                          /*MySearchField(
                            label: "Firm",
                            items: controller.firmDropdown,
                            textController: firmTextController,
                            focusNode: _firmFocusNode,
                            requestFocus: _paymentTypeFocusNode,
                            onChanged: (FirmModel item) {
                              firmNameController.value = item;
                            },
                          ),*/
                          MyDropdownButtonFormField(
                            width: 160,
                            focusNode: _paymentTypeFocusNode,
                            controller: paymentType,
                            hintText: "Payment Type",
                            items: const ["Direct", "PO"],
                          ),
                          /*MyDropdownButtonFormField(
                            width: 160,
                            controller: paymentMode,
                            hintText: "Payment Mode",
                            items: const ["Cheque", "Online", "Cash"],
                            onChanged: (value) {
                              isChequeNoVisible.value = value == "Cheque";
                              isVisible.value = value != "Cash";
                            },
                          ),
                          Obx(() {
                            return Visibility(
                              visible: isVisible.value,
                              child: MyDropdownButtonFormField(
                                width: 160,
                                controller: bankNameController,
                                hintText: "Bank Name",
                                items: const [
                                  "TMB",
                                  "ICICI",
                                  "CANARA",
                                  "AXIS",
                                ],
                              ),
                            );
                          }),
                          Obx(() {
                            return Visibility(
                              visible: isVisible.value,
                              child: MyTextField(
                                controller: branchNameController,
                                hintText: "Branch Name",
                                enabled: false,
                              ),
                            );
                          }),
                          MyDateFilter(
                            controller: paymentDateController,
                            labelText: "Payment Date",
                          ),
                          Obx(
                            () => Visibility(
                              visible: isChequeNoVisible.value,
                              child: MyTextField(
                                controller: chequeNoController,
                                hintText: "Cheque No",
                                validate: "string",
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: ExcludeFocusTraversal(
                        child: MySFDataGridItemTable(
                          shrinkWrapRows: false,
                          scrollPhysics: const ScrollPhysics(),
                          source: dataSource,
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
                                  const FilterPopupMenuOptions(
                                      canShowSortingOptions: false),
                            ),
                            GridColumn(
                              columnName: 'payment_type',
                              label:
                                  const MyDataGridHeader(title: 'Payment Type'),
                              filterPopupMenuOptions:
                                  const FilterPopupMenuOptions(
                                      canShowSortingOptions: false),
                            ),
                            GridColumn(
                              columnName: 'ledger_name',
                              label:
                                  const MyDataGridHeader(title: 'Ledger Name'),
                              filterPopupMenuOptions:
                                  const FilterPopupMenuOptions(
                                      canShowSortingOptions: false),
                            ),
                            GridColumn(
                              width: 150,
                              columnName: 'total_amount',
                              label: const MyDataGridHeader(
                                  alignment: Alignment.center,
                                  title: 'Payment'),
                              filterPopupMenuOptions:
                                  const FilterPopupMenuOptions(
                                canShowSortingOptions: false,
                              ),
                            ),
                            GridColumn(
                              width: 150,
                              visible: controller.isPaymentTo.value == true,
                              columnName: 'c_gst',
                              label: const MyDataGridHeader(
                                  alignment: Alignment.center, title: 'C GST'),
                              filterPopupMenuOptions:
                                  const FilterPopupMenuOptions(
                                canShowSortingOptions: false,
                              ),
                            ),
                            GridColumn(
                              width: 150,
                              columnName: 's_gst',
                              visible: controller.isPaymentTo.value == true,
                              label: const MyDataGridHeader(
                                  alignment: Alignment.center, title: 'S GST'),
                              filterPopupMenuOptions:
                                  const FilterPopupMenuOptions(
                                canShowSortingOptions: false,
                              ),
                            ),
                            GridColumn(
                              width: 150,
                              columnName: 'tds',
                              label: const MyDataGridHeader(
                                  alignment: Alignment.center, title: 'TDS'),
                              filterPopupMenuOptions:
                                  const FilterPopupMenuOptions(
                                canShowSortingOptions: false,
                              ),
                            ),
                            GridColumn(
                              width: 180,
                              columnName: 'gross_amount',
                              label: const MyDataGridHeader(
                                  alignment: Alignment.center,
                                  title: 'Payable Amount'),
                              filterPopupMenuOptions:
                                  const FilterPopupMenuOptions(
                                canShowSortingOptions: false,
                              ),
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
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
    if (_formKey.currentState!.validate()) {
      if (controller.isPaymentTo.value == true &&
          paymentType.text == "Direct") {
        AppUtils.infoAlert(message: "Please select payment type to PO");

        return;
      } else if (controller.isPaymentTo.value == false &&
          paymentType.text == "PO") {
        AppUtils.infoAlert(message: "Please select payment type to Direct");

        return;
      }

      Map<String, dynamic> request = {
        // "firm_id": firmNameController.value?.id,
        "type": paymentType.text.toLowerCase(),
        // "payment_mode": paymentMode.text.toLowerCase(),
        // "cheque_date": paymentDateController.text,
      };

      /*if (paymentMode.text == "Cheque") {
        request["bank_name"] = bankNameController.text;
        request["branch_name"] = branchNameController.text;

        request["cheque_no"] = chequeNoController.text;
      } else if (paymentMode.text == "Online") {
        request["bank_name"] = bankNameController.text;
      }*/

      var selectedId = [];
      num totalAmount = 0.0;

      for (var e in itemDetails) {
        totalAmount += e.grossAmount ?? 0;

        selectedId.add(e.id);
      }
      request["total_amount"] = totalAmount;
      request["payment_id"] = selectedId;

      submitAlert(request);
    }
  }

  void _initValue() async {
    paymentDateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    if (Get.arguments != null) {
      final List<dynamic> item = Get.arguments;

      List<BankingReportModel> reportList =
          item.map((e) => BankingReportModel.fromJson(e)).toList();

      itemDetails.addAll(reportList);
      dataSource.updateDataGridRows();
    }
  }

  submitAlert(var request) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: SizedBox(
            height: 200,
            width: 400,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/approveicon.png',
                  color: const Color(0xFF2196F3),
                  width: 300,
                  height: 120,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Approval Submission",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Text("Are you sure you want to submit?"),
              ],
            ),
          ),
          actions: [
            button("YES", Colors.white, const Color(0xff5700BC), () async {
              var result = await controller.upComingPost(request);

              Get.back();
              if (result == "success") {
                itemDetails.clear();
                _upcomingDataGridController.selectedIndex = -1;
                dataSource.updateDataGridRows();
                Get.back(result: "success");
              }
            }),
            button("NO", Colors.black, const Color(0xffE3E3E3), () {
              Get.back();
            }),
          ],
        );
      },
    );
  }

  Widget button(String text, Color textColor, backGround, Function function) {
    return OutlinedButton(
      autofocus: true,
      onPressed: () {
        function();
      },
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(180, 46)),
        foregroundColor: WidgetStateProperty.resolveWith((states) => textColor),
        shape: WidgetStateProperty.resolveWith((s) =>
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return Colors.grey;
          }
          return backGround;
        }),
      ),
      child: Text(text),
    );
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
