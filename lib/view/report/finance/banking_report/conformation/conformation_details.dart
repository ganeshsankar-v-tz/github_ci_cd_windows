import 'dart:convert';

import 'package:abtxt/model/banking_report_model/BankingReportModel.dart';
import 'package:abtxt/view/report/finance/banking_report/up_coming_details/upComing_list.dart';
import 'package:abtxt/widgets/MySFDataGridItemTable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../model/FirmModel.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../../widgets/AddItemsElevatedButton.dart';
import '../../../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../../../widgets/MyDataGridHeader.dart';
import '../../../../../widgets/MyDateFilter.dart';
import '../../../../../widgets/MyDropdownButtonFormField.dart';
import '../../../../../widgets/MyTextField.dart';
import '../../../../../widgets/flutter_shortcut_widget.dart';
import '../../../../../widgets/my_search_field/my_search_field.dart';
import '../baking_report_controller.dart';

class ConformationItemDetails extends StatefulWidget {
  const ConformationItemDetails({super.key});

  static const String routeName = '/conformation_item_details';

  @override
  State<ConformationItemDetails> createState() =>
      _ConformationItemDetailsState();
}

class _ConformationItemDetailsState extends State<ConformationItemDetails> {
  BankingReportController controller = Get.find();

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

  int? id;
  List<dynamic> paymentId = <dynamic>[];

  List<BankingReportModel> list = <BankingReportModel>[];
  late MyDataSource dataSource;
  final DataGridController _dataGridController = DataGridController();

  RxBool isChequeNoVisible = RxBool(true);
  RxBool isVisible = RxBool(true);

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    _initValue();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankingReportController>(
      builder: (controller) {
        return ShortCutWidget(
          appBar: AppBar(
            title: const Text("Conformation - Banking Report"),
          ),
          loadingStatus: controller.status.isLoading,
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.keyQ, control: true):
                GetBackIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              GetBackIntent: SetCounterAction(perform: () => Get.back()),
            },
            child: FocusScope(
              autofocus: true,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey,
                          child: Wrap(
                            children: [
                              MySearchField(
                                label: "Firm",
                                items: controller.firmDropdown,
                                textController: firmTextController,
                                focusNode: _firmFocusNode,
                                requestFocus: _paymentTypeFocusNode,
                                onChanged: (FirmModel item) {
                                  firmNameController.value = item;
                                },
                              ),
                              MyDropdownButtonFormField(
                                width: 160,
                                controller: paymentType,
                                enabled: false,
                                hintText: "Payment Type",
                                items: const ["Direct", "PO"],
                              ),
                              MyDropdownButtonFormField(
                                width: 160,
                                controller: paymentMode,
                                focusNode: _paymentTypeFocusNode,
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
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MyAddItemsRemoveButton(
                                onPressed: () => removeSelectedItems()),
                            const SizedBox(width: 12),
                            AddItemsElevatedButton(
                              onPressed: () => _addItem(),
                              child: const Text('Add Item'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Flexible(child: itemTable()),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: button(
                        text: "CONFORMATION",
                        textColor: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => submitAlert(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget itemTable() {
    return ExcludeFocusTraversal(
      child: MySFDataGridItemTable(
        selectionMode: SelectionMode.multiple,
        showCheckboxColumn: true,
        headerColor: const Color(0xffF0F0F0),
        source: dataSource,
        color: Colors.white,
        shrinkWrapRows: false,
        scrollPhysics: const ScrollPhysics(),
        controller: _dataGridController,
        columns: [
          GridColumn(
            width: 80,
            columnName: 's_no',
            label: const MyDataGridHeader(color: Colors.black, title: 'S.No'),
          ),
          GridColumn(
            width: 100,
            columnName: 'slip_no',
            label:
                const MyDataGridHeader(color: Colors.black, title: 'Slip No'),
          ),
          GridColumn(
            width: 110,
            columnName: 'e_date',
            label: const MyDataGridHeader(color: Colors.black, title: 'Date'),
          ),
          GridColumn(
            columnName: 'payment_type',
            label: const MyDataGridHeader(
                color: Colors.black, title: 'Payment Type'),
          ),
          GridColumn(
            columnName: 'ledger_name',
            label: const MyDataGridHeader(
                color: Colors.black, title: 'Ledger Name'),
          ),
          GridColumn(
            width: 150,
            columnName: 'total_amount',
            label: const MyDataGridHeader(
                color: Colors.black,
                alignment: Alignment.center,
                title: 'Payment'),
          ),
          GridColumn(
            width: 150,
            visible: controller.isPaymentTo.value == true,
            columnName: 'c_gst',
            label: const MyDataGridHeader(
                color: Colors.black,
                alignment: Alignment.center,
                title: 'C GST'),
          ),
          GridColumn(
            width: 150,
            columnName: 's_gst',
            visible: controller.isPaymentTo.value == true,
            label: const MyDataGridHeader(
                color: Colors.black,
                alignment: Alignment.center,
                title: 'S GST'),
          ),
          GridColumn(
            width: 150,
            columnName: 'tds',
            label: const MyDataGridHeader(
                color: Colors.black, alignment: Alignment.center, title: 'TDS'),
          ),
          GridColumn(
            width: 180,
            columnName: 'gross_amount',
            label: const MyDataGridHeader(
                color: Colors.black,
                alignment: Alignment.center,
                title: 'Payable Amount'),
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
    );
  }

  Widget headingText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget contentText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget button({
    required String text,
    required Color textColor,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(180, 46)),
        foregroundColor: WidgetStateProperty.all(textColor),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.focused)
              ? Colors.grey
              : backgroundColor;
        }),
      ),
      child: Text(text),
    );
  }

  submitAlert() {
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
                  "Conformation Request",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Text("Do you want to conform this request?"),
              ],
            ),
          ),
          actions: [
            button(
                text: "YES",
                textColor: Colors.white,
                backgroundColor: const Color(0xff5700BC),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (controller.isPaymentTo.value == true &&
                        paymentType.text == "Direct") {
                      AppUtils.infoAlert(
                          message: "Please select payment type to PO");

                      return;
                    } else if (controller.isPaymentTo.value == false &&
                        paymentType.text == "PO") {
                      AppUtils.infoAlert(
                          message: "Please select payment type to Direct");

                      return;
                    }

                    Map<String, dynamic> request = {
                      "firm_id": firmNameController.value?.id,
                      "type": paymentType.text.toLowerCase(),
                      "payment_mode": paymentMode.text.toLowerCase(),
                      "cheque_date": paymentDateController.text,
                    };

                    if (paymentMode.text == "Cheque") {
                      request["bank_name"] = bankNameController.text;
                      request["branch_name"] = branchNameController.text;

                      request["cheque_no"] = chequeNoController.text;
                    } else if (paymentMode.text == "Online") {
                      request["bank_name"] = bankNameController.text;
                    }

                    double totalAmount = 0.0;
                    for (var e in list) {
                      totalAmount += e.grossAmount ?? 0;
                      paymentId.add(e.id);
                    }

                    request["total_amount"] = totalAmount;
                    request["id"] = id;
                    request["payment_id"] = paymentId;

                    var result =
                        await controller.userConformationRequest(request);

                    Get.back();
                    if (result == "success") {
                      Get.back(result: "success");
                    }
                  }
                }),
            button(
                text: "NO",
                textColor: Colors.black,
                backgroundColor: const Color(0xffE3E3E3),
                onPressed: () {
                  Get.back();
                }),
          ],
        );
      },
    );
  }

  _initValue() {
    paymentDateController.text = AppUtils.parseDateTime("${DateTime.now()}");

    if (Get.arguments != null) {
      var item = Get.arguments["item"];

      id = item["id"];

      firmTextController.text = "${item["firm_name"] ?? ""}";
      firmNameController.value = FirmModel(
          id: item["firm_id"], firmName: "${item["firm_name"] ?? ""}");
      bankNameController.text = "${item["bank_name"] ?? "TMB"}";
      paymentDateController.text = "${item["cheque_date"] ?? ""}";
      chequeNoController.text = "${item["cheque_no"] ?? ""}";
      if (item["type"] == "po") {
        paymentType.text = "PO";
        controller.isPaymentTo.value = true;
      } else {
        paymentType.text = "Direct";
        controller.isPaymentTo.value = false;
      }

      if (item["payment_mode"] == "cheque") {
        paymentMode.text = "Cheque";
        isChequeNoVisible.value = true;
        isVisible.value = true;
      } else if (item["payment_mode"] == "online") {
        paymentMode.text = "Online";
        isVisible.value = true;
        isChequeNoVisible.value = false;
      } else {
        paymentMode.text = "Cash";
        isChequeNoVisible.value = false;
        isVisible.value = false;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _apiCall(id!);
      });
    }
  }

  removeSelectedItems() async {
    List<DataGridRow> selectedRows = _dataGridController.selectedRows;

    if (selectedRows.isNotEmpty) {
      List<int> selectedIndices = selectedRows
          .map((row) => dataSource.rows.indexOf(row))
          .where((index) => index >= 0)
          .toList();
      selectedIndices.sort((a, b) => b.compareTo(a));

      /// selected row ID details LIST
      List<int> selectedId = [];

      for (int index in selectedIndices) {
        selectedId.add(list[index].id!);
      }

      var request = {"id": id, "payment_id": selectedId};

      /// row remove API
      var result = await controller.selectedRowRemove(request);
      if (result == "success") {
        _apiCall(id!);
        controller.apiCall.value = true;
      }
    } else {
      AppUtils.infoAlert(message: "Select the values to remove");
    }
  }

  _addItem() async {
    var result = await Get.toNamed(UpcomingList.routeName,
        arguments: {"is_edit": true, "id": id});
    if (result == "success") {
      _apiCall(id!);
      controller.apiCall.value = true;
    }
  }

  /// item table details API call
  _apiCall(int id) async {
    list.clear();
    dataSource.updateDataGridRows();
    dataSource.notifyListeners();
    var result = await controller.selectedRowItemDetails(id);

    result?.payment?.forEach((element) {
      BankingReportModel result = BankingReportModel.fromJson(element.toJson());

      list.add(result);
      dataSource.updateDataGridRows();
      dataSource.notifyListeners();
    });
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
      int sNo = _list.indexOf(e);

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 's_no', value: "${sNo + 1}"),
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
