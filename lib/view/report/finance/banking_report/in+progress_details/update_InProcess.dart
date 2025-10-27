import 'package:abtxt/widgets/MySFDataGridItemTable.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../model/banking_report_model/BankingReportModel.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../../widgets/MyDataGridHeader.dart';
import '../../../../../widgets/flutter_shortcut_widget.dart';
import '../baking_report_controller.dart';

class InProcessItemDetails extends StatefulWidget {
  const InProcessItemDetails({super.key});

  static const String routeName = '/inPprogress_item_details';

  @override
  State<InProcessItemDetails> createState() => _InProcessItemDetailsState();
}

class _InProcessItemDetailsState extends State<InProcessItemDetails> {
  BankingReportController controller = Get.find();

  TextEditingController transactionNo = TextEditingController();

  RxString firmName = RxString("");
  RxString status = RxString("");
  RxString bankName = RxString("");
  RxString branchName = RxString("");
  RxString paymentDate = RxString("");
  RxString chequeNo = RxString("");
  RxString totalAmount = RxString("");
  RxString paymentType = RxString("");
  RxString paymentMode = RxString("");
  RxString inVoiceNo = RxString("");

  RxBool isChequeNoVisible = RxBool(true);
  RxBool isVisible = RxBool(true);
  RxBool isInvoiceNoVisible = RxBool(true);

  int? id;
  List<dynamic> paymentId = <dynamic>[];

  List<BankingReportModel> list = <BankingReportModel>[];
  late MyDataSource dataSource;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    _initValue();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankingReportController>(
      builder: (controller) {
        return ShortCutWidget(
          appBar: AppBar(
            title: const Text("InProgress - Banking Report"),
            actions: const [],
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
                    MyTextField(
                      autofocus: true,
                      focusNode: _focus,
                      controller: transactionNo,
                      hintText: "Transaction id",
                      validate: "string",
                    ),
                    Card(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xff0B5CB8)),
                          color: const Color(0xffF1F8FF),
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        firmName.value,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      headingText("Status : "),
                                      const Text(
                                        "Waiting For Transaction",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff0B5CB8)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: <Widget>[
                                      headingText("Payment Type : "),
                                      contentText(paymentType.value),
                                      const SizedBox(width: 12),
                                      headingText("Payment Mode : "),
                                      contentText(paymentMode.value),
                                      const SizedBox(width: 12),
                                      headingText("Bank Name : ",
                                          isVisible: isVisible),
                                      contentText(bankName.value,
                                          isVisible: isVisible),
                                      const SizedBox(width: 12),
                                      headingText("Branch Name : ",
                                          isVisible: isVisible),
                                      contentText(branchName.value,
                                          isVisible: isVisible),
                                      const SizedBox(width: 12),
                                      headingText("Payment Date : "),
                                      contentText(paymentDate.value),
                                      const SizedBox(width: 12),
                                      headingText("Cheque no : ",
                                          isVisible: isChequeNoVisible),
                                      contentText(chequeNo.value,
                                          isVisible: isChequeNoVisible),
                                      const SizedBox(width: 12),
                                      headingText("Invoice no : ",
                                          isVisible: isInvoiceNoVisible),
                                      contentText(inVoiceNo.value,
                                          isVisible: isInvoiceNoVisible),
                                      const SizedBox(width: 12),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    totalAmount.value
                                        .myNumberFormat(totalAmount.value),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  headingText("Total Amount"),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Flexible(child: itemTable()),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        button(
                          "SUBMIT",
                          Colors.white,
                          Colors.blue,
                          () {
                            if (transactionNo.text.isEmpty) {
                              return AppUtils.infoAlert(
                                  message: "Enter the Transaction Number");
                            }
                            submitAlert();
                          },
                        ),
                      ],
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
        headerColor: const Color(0xffF0F0F0),
        source: dataSource,
        color: Colors.white,
        shrinkWrapRows: false,
        scrollPhysics: const ScrollPhysics(),
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
          GridColumn(
            width: 80,
            visible: isInvoiceNoVisible.value,
            columnName: 'button',
            label: const MyDataGridHeader(color: Colors.black, title: 'PDF'),
          ),
          GridColumn(
            visible: false,
            width: 80,
            columnName: 'id',
            label: const MyDataGridHeader(title: 'Id'),
          ),
        ],
      ),
    );
  }

  Widget headingText(String text, {RxBool? isVisible}) {
    return Visibility(
      visible: isVisible?.value ?? true,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget contentText(String text, {RxBool? isVisible}) {
    return Visibility(
      visible: isVisible?.value ?? true,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
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
                  'assets/images/transacation_icon.png',
                  color: const Color(0xFF2196F3),
                  width: 300,
                  height: 120,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Transaction Confirmation",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Text("Are you sure you want to proceed with this"),
                const Text("transaction?"),
              ],
            ),
          ),
          actions: [
            button("YES", Colors.white, const Color(0xff5700BC), () async {
              var request = {};

              request["id"] = id;
              request["trans_no"] = transactionNo.text;
              for(var e in list){
                paymentId.add(e.id);
              }

              request["payment_id"] = paymentId;

              var result = await controller.transactionIdToComplete(request);

              Get.back();
              if (result == "success") {
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

  declineAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        TextEditingController controller = TextEditingController();

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: SizedBox(
            height: 260,
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
                  "Decline Request",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Text("Are you sure you want to decline this"),
                const Text("request?"),
                MyTextField(
                  width: double.infinity,
                  controller: controller,
                  hintText: "Remarks",
                ),
              ],
            ),
          ),
          actions: [
            button("YES", Colors.white, const Color(0xff5700BC), () {}),
            button("NO", Colors.black, const Color(0xffE3E3E3), () {
              Get.back();
            }),
          ],
        );
      },
    );
  }

  _initValue() {
    if (Get.arguments != null) {
      var item = Get.arguments["item"];

      id = item["id"];

      firmName.value = "${item["firm_name"] ?? ""}";
      paymentDate.value = "${item["cheque_date"] ?? ""}";
      chequeNo.value = "${item["cheque_no"] ?? ""}";
      bankName.value = "${item["bank_name"] ?? ""}";
      branchName.value = "${item["branch_name"] ?? ""}";
      inVoiceNo.value = item["invoice_no"] ?? "";
      status.value = "Waiting For Approval";
      totalAmount.value = "${item["total_amount"] ?? ""}";
      if (item["type"] == "po") {
        paymentType.value = "PO";
        isInvoiceNoVisible.value = true;
        controller.isPaymentTo.value = true;
      } else {
        paymentType.value = "Direct";
        isInvoiceNoVisible.value = false;
        controller.isPaymentTo.value = false;
      }

      if (item["payment_mode"] == "cheque") {
        paymentMode.value = "Cheque";
        isChequeNoVisible.value = true;
        isVisible.value = true;
      } else if (item["payment_mode"] == "online") {
        paymentMode.value = "Online";
        isVisible.value = true;
        isChequeNoVisible.value = false;
      } else {
        paymentMode.value = "Cash";
        isChequeNoVisible.value = false;
        isVisible.value = false;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _apiCall(id!);
      });
    }
  }

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
        const DataGridCell<dynamic>(columnName: 'button', value: ""),
        DataGridCell<dynamic>(columnName: 'id', value: e.id),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      BankingReportController controller = Get.find();

      if (dataGridCell.columnName == 'button') {
        return Padding(
          padding: const EdgeInsets.all(3),
          child: TextButton.icon(
              onPressed: () async {
                int id = row.getCells()[11].value;
                String? response = await controller.poPdfGeneration(id);
                if (response != null) {
                  final Uri url = Uri.parse(response);
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $response');
                  }
                }
              },
              icon: Image.asset(
                'assets/images/pdf_icon.png',
              ),
              label: const Text("")),
        );
      }

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
}
