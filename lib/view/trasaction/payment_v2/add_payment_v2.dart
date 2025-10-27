import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/DropModel.dart';
import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/payment_models/AccountDetailsModel.dart';
import 'package:abtxt/model/payment_models/PaymentV2Model.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/payment_v2/payment_v2_controller.dart';
import 'package:abtxt/view/trasaction/payment_v2/payment_v2_pay_details_bottomsheet.dart';
import 'package:abtxt/view/trasaction/payment_v2/payment_v2_slip_details_bottomsheet.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';

class AddPaymentV2 extends StatefulWidget {
  const AddPaymentV2({super.key});

  static const String routeName = '/AddPaymentV2';

  @override
  State<AddPaymentV2> createState() => _State();
}

class _State extends State<AddPaymentV2> {
  TextEditingController idController = TextEditingController();
  TextEditingController firmTextController = TextEditingController();
  Rxn<FirmModel> firmNameController = Rxn<FirmModel>();
  TextEditingController ledgerTextController = TextEditingController();
  Rxn<DropModel> ledgerNameController = Rxn<DropModel>();
  TextEditingController paymentTypeTextController = TextEditingController();
  Rxn<String> paymentTypeController = Rxn<String>();
  TextEditingController challanNoController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController accountTextController = TextEditingController();
  Rxn<AccountDetailsModel> accountController = Rxn<AccountDetailsModel>();
  TextEditingController paymentToController =
      TextEditingController(text: "Bank");
  TextEditingController detailsController = TextEditingController();
  TextEditingController tdsPercentageController =
      TextEditingController(text: "1.00");

  /// paid amount details controller's
  RxString totalWages = RxString('0.00');
  RxString tdsAmount = RxString('0.00');
  RxString inHandAmount = RxString('0.00');
  RxString inAccountAmount = RxString('0.00');
  RxString midAmount = RxString('0.00');
  RxString advAmount = RxString('0.00');
  RxString balanceAmount = RxString('0.00');
  RxString greaseAmount = RxString('0.00');

  late SlipDataSource slipDataSource;
  var paymentList = <dynamic>[];
  late PaymentDataSource paymentDataSource;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  RxBool isUpdate = RxBool(false);

  // account number dropdown enable
  RxBool isEnable = RxBool(false);

  // if challon is update remove the check box in slip detail table
  // and selection mode is change
  RxBool isCheckBox = RxBool(true);
  SelectionMode selectionMode = SelectionMode.multiple;

  // if challon is update show the slip addItem and remove button
  RxBool isVisible = RxBool(false);

  // selected row total amount and qty
  var selectedAmount = "0.00".obs;
  var selectedQty = 0.0.obs;

  final _formKey = GlobalKey<FormState>();
  final PaymentV2Controller controller = Get.find();
  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _firmFocusNode = FocusNode();
  final FocusNode _paymentTypeFocusNode = FocusNode();
  final FocusNode _ledgerNameFocusNode = FocusNode();
  final FocusNode _paymentAddItemFocusNode = FocusNode();
  final FocusNode _accountFocusNode = FocusNode();
  final FocusNode _focusNode = FocusNode();

  final DataGridController _slipDataGridController = DataGridController();
  final DataGridController _paymentDataGridController = DataGridController();

  /// created by and updated by details controllers
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? displayName;
  String? displayDate;

  /// Selected Slip Details
  List selectedSlipDetails = [];

  @override
  void initState() {
    controller.accountNumberList.clear();
    controller.itemTableSlipList.clear();
    selectedSlipDetails.clear();
    controller.ledgerDropdown.clear();
    _initValue();
    super.initState();
    slipDataSource = SlipDataSource(
      list: controller.itemTableSlipList,
      selectedQty: selectedQty,
      selectedAmount: selectedAmount,
    );
    paymentDataSource = PaymentDataSource(list: paymentList);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null &&
          (Get.arguments["item"] != null ||
              Get.arguments["ledger_id"] != null)) {
        FocusScope.of(context).requestFocus(_firstInputFocusNode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentV2Controller>(builder: (controller) {
      return KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            final ctrl = HardwareKeyboard.instance.isControlPressed;
            if (event.logicalKey == LogicalKeyboardKey.keyQ && ctrl) {
              Get.back();
            } else if (event.logicalKey == LogicalKeyboardKey.keyS && ctrl) {
              submit();
            } else if (event.logicalKey == LogicalKeyboardKey.keyP && ctrl) {
              _print();
            } else if (event.logicalKey == LogicalKeyboardKey.keyN) {
              _addItemPayment();
            }
          }
        },
        child: CoreWidget(
          autofocus: false,
          scaffoldKey: _scaffoldKey,
          endDrawer: Container(
            color: Colors.white10.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Drawer(
                  width: 520,
                  child: PaymentV2PayDetailsBottomSheet(
                    paymentList: paymentList,
                    paymentDataSource: paymentDataSource,
                    paidAmountCalculation: paidAmountCalculation,
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title:
                Text("${idController.text == '' ? 'Add' : 'Update'} Payment"),
            actions: [
              Visibility(
                  visible: idController.text.isNotEmpty,
                  child: MyDeleteIconButton(
                    onPressed: (password) {
                      controller.delete(idController.text, password);
                    },
                  )),
              const SizedBox(width: 12),
              Visibility(
                visible: challanNoController.text.isNotEmpty,
                child: MyPrintButton(
                  onPressed: () => _print(),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          loadingStatus: controller.status.isLoading,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Visibility(
                          visible: false,
                          child: MyTextField(
                            controller: idController,
                            hintText: "ID",
                            validate: "",
                            enabled: false,
                          ),
                        ),
                        MySearchField(
                          label: 'Firm',
                          items: controller.firmDropdown,
                          textController: firmTextController,
                          focusNode: _firmFocusNode,
                          requestFocus: _paymentTypeFocusNode,
                          onChanged: (FirmModel item) {
                            firmNameController.value = item;
                          },
                          autofocus: false,
                        ),
                        MySearchField(
                          enabled: !isUpdate.value,
                          label: 'Payment Type',
                          items: const [
                            "Dyer Amount",
                            "Roller Amount",
                            "Weaver Amount",
                            "JobWorker Amount",
                            "Processor Amount",
                            "Advance Amount",
                            "Mid Amount",
                          ],
                          textController: paymentTypeTextController,
                          focusNode: _paymentTypeFocusNode,
                          requestFocus: _ledgerNameFocusNode,
                          onChanged: (String item) async {
                            controller.accountNumberList.clear();
                            accountController.value = null;
                            accountTextController.text = "";
                            payTypeOnChange(item);
                            paidAmountCalculation();
                            selectedAmountCalculation();
                          },
                        ),
                        MyDateFilter(
                          width: 160,
                          focusNode: _firstInputFocusNode,
                          controller: dateController,
                          labelText: "Date",
                        ),
                        MySearchField(
                          setInitialValue: false,
                          enabled: !isUpdate.value,
                          label: 'Ledger Name',
                          items: controller.ledgerDropdown,
                          textController: ledgerTextController,
                          focusNode: _ledgerNameFocusNode,
                          requestFocus: _accountFocusNode,
                          isArrayValidate: false,
                          onChanged: (LedgerModel item) async {
                            ledgerNameController.value =
                                DropModel(id: item.id, name: item.ledgerName);
                            var paymentType = paymentTypeController.value;
                            slipDetailsApiCall(item.id, paymentType);
                            controller.accountNumberList.clear();
                            accountController.value = null;
                            accountTextController.text = "";

                            // account details API call
                            accountDetailsApiCall(item.id!);

                            /// Advance Amount Details Api Call
                            advanceAmountApiCall(item.id);
                          },
                        ),
                        Obx(
                          () => MySearchField(
                            setInitialValue: false,
                            enabled: !isEnable.value,
                            label: 'Account Number',
                            items: controller.accountNumberList,
                            textController: accountTextController,
                            focusNode: _accountFocusNode,
                            isValidate: controller.accountNumberList.isNotEmpty,
                            requestFocus: _paymentAddItemFocusNode,
                            onChanged: (AccountDetailsModel item) async {
                              accountController.value = item;
                            },
                          ),
                        ),
                        Visibility(
                          visible: challanNoController.text.isNotEmpty,
                          child: MyTextField(
                            width: 140,
                            controller: challanNoController,
                            hintText: "Challan No",
                            enabled: false,
                            readonly: true,
                          ),
                        ),
                        ExcludeFocusTraversal(
                          child: MyTextField(
                            controller: detailsController,
                            hintText: "Details",
                          ),
                        ),
                        ExcludeFocusTraversal(
                          child: MyDropdownButtonFormField(
                            width: 120,
                            controller: paymentToController,
                            hintText: "Payment To",
                            items: const ["Bank", "GST"],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Slip Details"),
                                    const Spacer(),
                                    Obx(
                                      () => Visibility(
                                        visible: isVisible.value,
                                        child: MyAddItemsRemoveButton(
                                            message: "",
                                            onPressed: () =>
                                                removeSelectedSlipItems()),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const SizedBox(height: 30),
                                    Obx(
                                      () => Visibility(
                                        visible: isVisible.value,
                                        child: AddItemsElevatedButton(
                                          toolTip: '',
                                          onPressed: () => _addItemSlip(),
                                          child: const Text('Add Item'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                slipTable(),
                                ExcludeFocusTraversal(child: amountDetails()),
                              ],
                            )),
                        const SizedBox(width: 10),
                        Flexible(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Payment Details"),
                                  const Spacer(),
                                  MyAddItemsRemoveButton(
                                      message: "",
                                      onPressed: () =>
                                          removeSelectedPaymentItems()),
                                  const SizedBox(width: 12),
                                  AddItemsElevatedButton(
                                    focusNode: _paymentAddItemFocusNode,
                                    onPressed: () => _addItemPayment(),
                                    child: const Text('Add Item'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              paymentTable(),
                              const SizedBox(height: 12),
                              Obx(
                                () => Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Total Wages  :   ${totalWages.value}",
                                    textAlign: TextAlign.right,
                                    style: AppUtils.paymentTextStyle(
                                        color: Colors.green),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ExcludeFocusTraversal(
                                    child: MyTextField(
                                      width: 140,
                                      controller: tdsPercentageController,
                                      hintText: "Tds %",
                                      validate: "double",
                                      onChanged: (value) =>
                                          selectedAmountCalculation(),
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                  Obx(
                                    () => Text(
                                      "Tds Amount  :   ${tdsAmount.value}",
                                      textAlign: TextAlign.right,
                                      style: AppUtils.paymentTextStyle(),
                                    ),
                                  ),
                                ],
                              ),
                              Obx(
                                () => Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Gross Amount  :   ${greaseAmount.value}",
                                    textAlign: TextAlign.right,
                                    style: AppUtils.paymentTextStyle(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        crateAndUpdatedBy(),
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
        ),
      );
    });
  }

  Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }

    var request = {'id': idController.text};
    String? response = await controller.paymentPdf(request: request);
    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      double grossAmount = 0.0;
      double netTotal =
          double.tryParse(totalWages.value.replaceAll(",", "")) ?? 0.0;
      double tdsPer = double.tryParse(tdsPercentageController.text) ?? 0.0;
      double tdsAm =
          double.tryParse(tdsAmount.value.replaceAll(",", "")) ?? 0.0;
      grossAmount = netTotal - tdsAm;

      Map<String, dynamic> request = {
        "firm_id": firmNameController.value?.id,
        "e_date": dateController.text,
        "details": detailsController.text,
        "payment_type": paymentTypeController.value,
        "ledger_id": ledgerNameController.value?.id,
        "total_amount": netTotal,
        "gross_amount": grossAmount,
        "tds_per": tdsPer,
        "tds_amount": tdsAm,
        "account_no": accountController.value?.accountNo?.replaceAll(" ", ""),
        "banking_type": paymentToController.text,
      };

      var debitItemList = [];
      var paymentItemList = [];
      for (var e in paymentList) {
        if (e["e_type"] == "Debit") {
          debitItemList.add(e);
        } else {
          paymentItemList.add(e);
        }
      }

      // if tds amount is 1 or above send the details in debit_list
      var tdsDetails = [];

      if (tdsPer > 0) {
        var item = {
          "e_type": "Debit",
          "to": 3570,
          "to_name": 'TDS',
          "debit_amount": tdsAm,
          "details": "TDS Amount Deduction",
        };

        tdsDetails.add(item);
        debitItemList.addAll(tdsDetails);
      }

      request["job_details"] = selectedSlipDetails;
      request["debit_list"] =
          selectedSlipDetails.isNotEmpty ? debitItemList : [];
      request["payment_list"] = paymentItemList;

      var id = idController.text;
      var payType = paymentTypeController.value;

      if (selectedSlipDetails.isEmpty &&
          (payType == "Dyer Amount" ||
              payType == 'Roller Amount' ||
              payType == 'Weaver Amount' ||
              payType == 'JobWorker Amount' ||
              payType == 'Processor Amount')) {
        return AppUtils.infoAlert(message: "Please select the slip details");
      }

      if (id.isEmpty) {
        // selected payment type is Advance Amount and Mid Amount
        // not check the total wages and total paid
        // other wish check the amount
        if (payType == "Advance Amount" || payType == "Mid Amount") {
          controller.add(request);
          controller.filterData = null;
        } else {
          if (controller.totalAmount != controller.paidTotal) {
            return AppUtils.infoAlert(
                message: "Paid Total Not Match Total Wages");
          }

          controller.add(request);
          controller.filterData = null;
        }
      } else {
        request['id'] = id;
        request['challan_no'] = challanNoController.text;
        if (payType == "Advance Amount" || payType == "Mid Amount") {
          controller.edit(request);
        } else {
          if (controller.totalAmount == controller.paidTotal) {
            controller.edit(request);
          } else {
            AppUtils.infoAlert(message: "Paid Total Not Match Total Wages");
          }
        }
      }
    }
  }

  void _initValue() async {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");

    var firm = AppUtils.setDefaultFirmName(controller.firmDropdown);
    if (firm != null) {
      firmNameController.value = firm;
      firmTextController.text = firm.firmName ?? "";
    }

    if (Get.arguments != null) {
      if (Get.arguments["item"] != null) {
        // update screen table ui change
        selectionMode = SelectionMode.single;
        isCheckBox.value = false;
        isVisible.value = true;

        PaymentV2Model item = Get.arguments["item"];
        isUpdate.value = true;
        isEnable.value = true;
        idController.text = "${item.id}";
        dateController.text = "${item.eDate}";
        paymentTypeController.value = "${item.paymentType}";
        paymentTypeTextController.text = "${item.paymentType}";
        detailsController.text = item.details ?? '';
        challanNoController.text = "${item.challanNo}";
        tdsPercentageController.text = "${item.tdsPer ?? 0.0}";
        accountTextController.text = item.accountNo ?? "";
        accountController.value =
            AccountDetailsModel(accountNo: item.accountNo ?? '');

        paymentToController.text = item.bankingType ?? "Bank";

        // Firm Name
        var firmNameList = controller.firmDropdown
            .where((element) => '${element.id}' == '${item.firmId}')
            .toList();
        if (firmNameList.isNotEmpty) {
          firmNameController.value = firmNameList.first;
          firmTextController.text = firmNameList.first.firmName ?? '';
        }

        ledgerNameController.value =
            DropModel(id: item.ledgerId, name: item.ledgerName);
        ledgerTextController.text = "${item.ledgerName}";

        /// get created by and updated by details
        DateTime createDate = DateTime.parse(item.createdAt ?? "0000-00-00");
        DateTime updateDate = DateTime.parse(item.updatedAt ?? "0000-00-00");
        createdAt = AppUtils.dateFormatter.format(createDate);
        updatedAt = AppUtils.dateFormatter.format(updateDate);
        createdBy = item.creatorName;
        updatedBy = item.updatedName;
        if (updatedBy != null) {
          displayName = "Edit : $updatedBy";
          displayDate = updatedAt;
        } else {
          displayName = "New : $createdBy";
          displayDate = createdAt;
        }

        item.jobDetails?.forEach((element) {
          var request = element.toJson();
          controller.itemTableSlipList.add(request);
          selectedSlipDetails.add(request);
          selectedAmountCalculation();
        });
        item.amountDetails?.removeWhere((element) => element.to == 3570);

        item.amountDetails?.forEach((element) {
          if (element.to != 3570) {
            var request = element.toJson();
            paymentList.add(request);
            paidAmountCalculation();
          }
        });

        /// Advance And Mid Amount Details Api Call
        advanceAmountApiCall(item.ledgerId);
      } else {
        /// goods inward short cut to initiate the details

        int? ledgerId;
        var firmName = Get.arguments["firm_name"];
        var paymentType = Get.arguments["payment_type"];
        if (Get.arguments["ledger_id"] != null) {
          isUpdate.value = true;
          isCheckBox.value = true;
          ledgerId = Get.arguments["ledger_id"];

          // slip details api call
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            slipDetailsApiCall(ledgerId, paymentType);
          });
        }
        var result = await controller.firmInfo();
        var firmNameList = result
            .where((element) => '${element.firmName}' == '$firmName')
            .toList();
        if (firmNameList.isNotEmpty) {
          firmNameController.value = firmNameList.first;
          firmTextController.text = firmNameList.first.firmName ?? '';
        }
        paymentTypeController.value = paymentType;
        paymentTypeTextController.text = "$paymentType";
        advanceAmountApiCall(ledgerId);

        // account details API call
        accountDetailsApiCall(ledgerId!);

        payTypeOnChange(paymentType, ledgerId: ledgerId);
      }
    }
  }

  void advanceAmountApiCall(var ledgerId) {
    if (ledgerId != null) {
      controller.advanceAmountDetails(ledgerId);
    }
  }

  Widget slipTable() {
    return Obx(
      () => ExcludeFocusTraversal(
        child: MySFDataGridItemTable(
          showCheckboxColumn: isCheckBox.value,
          controller: _slipDataGridController,
          selectionMode: selectionMode,
          scrollPhysics: const AlwaysScrollableScrollPhysics(),
          shrinkWrapRows: false,
          columns: [
            GridColumn(
              width: 100,
              columnName: 'slip_date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              columnName: 'slip',
              label: const MyDataGridHeader(title: 'Slip'),
            ),
            GridColumn(
              width: 120,
              columnName: 'qty',
              label: const MyDataGridHeader(title: 'Qty'),
            ),
            GridColumn(
              width: 120,
              columnName: 'wages',
              label: const MyDataGridHeader(title: 'Wages(Rs)'),
            ),
          ],
          tableSummaryRows: [
            GridTableSummaryRow(
              showSummaryInRow: false,
              title: 'Total: ',
              titleColumnSpan: 1,
              columns: [
                const GridSummaryColumn(
                  name: 'qty',
                  columnName: 'qty',
                  summaryType: GridSummaryType.sum,
                ),
                const GridSummaryColumn(
                  name: 'wages',
                  columnName: 'wages',
                  summaryType: GridSummaryType.sum,
                ),
              ],
              position: GridTableSummaryRowPosition.bottom,
            ),
          ],
          onSelectionChanged: (addedRows, removedRows) {
            if (idController.text.isNotEmpty) {
              return;
            }
            var selectedList = [];

            var items = _slipDataGridController.selectedRows;
            for (var row in items) {
              var slipNo = row.getCells()[1].value;
              var eDate = row.getCells()[0].value;
              var qty = row.getCells()[2].value;
              var creditAmount = row.getCells()[3].value;
              var item = {
                "slip_rec_no": slipNo,
                "slip_date": eDate,
                "qty": qty,
                "credit_amount": creditAmount,
              };

              selectedList.add(item);
            }

            controller.itemTableSlipList.clear();
            selectedSlipDetails.clear();
            // insert the selected row details
            controller.itemTableSlipList.addAll(selectedList);
            selectedSlipDetails.addAll(selectedList);

            // after add call the calculation methode
            selectedAmountCalculation();
          },
          source: slipDataSource,
        ),
      ),
    );
  }

  Widget paymentTable() {
    return ExcludeFocusTraversal(
      child: MySFDataGridItemTable(
        controller: _paymentDataGridController,
        selectionMode: SelectionMode.single,
        scrollPhysics: const AlwaysScrollableScrollPhysics(),
        shrinkWrapRows: false,
        columns: [
          GridColumn(
            columnName: 'particulars',
            label: const MyDataGridHeader(title: 'Particulars'),
          ),
          GridColumn(
            width: 120,
            columnName: 'debit_amount',
            label: const MyDataGridHeader(title: 'Amount(Rs)'),
          ),
          GridColumn(
            columnName: 'details',
            label: const MyDataGridHeader(title: 'Details'),
          ),
        ],
        tableSummaryRows: [
          GridTableSummaryRow(
            showSummaryInRow: false,
            title: 'Total: ',
            titleColumnSpan: 1,
            columns: [
              const GridSummaryColumn(
                name: 'debit_amount',
                columnName: 'debit_amount',
                summaryType: GridSummaryType.sum,
              ),
            ],
            position: GridTableSummaryRowPosition.bottom,
          ),
        ],
        source: paymentDataSource,
      ),
    );
  }

  Widget amountDetails() {
    return Obx(
      () => Table(
        children: [
          const TableRow(children: [
            Text(""),
            Text(""),
            Text(""),
            Text(""),
            Text(""),
          ]),
          TableRow(children: [
            Text(
              "Mid Amount :",
              style: AppUtils.paymentTextStyle(),
            ),
            Text(
              midAmount.value,
              textAlign: TextAlign.right,
              style: AppUtils.paymentTextStyle(),
            ),
            const Text(""),
            Text(
              "In Hand :",
              style: AppUtils.paymentTextStyle(),
            ),
            Text(
              inHandAmount.value,
              textAlign: TextAlign.right,
              style: AppUtils.paymentTextStyle(),
            ),
          ]),
          const TableRow(children: [
            Text(""),
            Text(""),
            Text(""),
            Text(""),
            Text(""),
          ]),
          TableRow(children: [
            Text(
              "Adv Amount :",
              style: AppUtils.paymentTextStyle(),
            ),
            Text(
              advAmount.value,
              textAlign: TextAlign.right,
              style: AppUtils.paymentTextStyle(),
            ),
            const Text(""),
            Text(
              "In Account :",
              style: AppUtils.paymentTextStyle(),
            ),
            Text(
              inAccountAmount.value,
              textAlign: TextAlign.right,
              style: AppUtils.paymentTextStyle(),
            ),
          ]),
          const TableRow(children: [
            Text(""),
            Text(""),
            Text(""),
            Text(""),
            Text(""),
          ]),
          TableRow(children: [
            Text(
              "Balance :",
              style: AppUtils.paymentTextStyle(),
            ),
            Text(
              balanceAmount.value,
              textAlign: TextAlign.right,
              style: AppUtils.paymentTextStyle(),
            ),
            const Text(""),
            const Text(""),
            const Text(""),
          ]),
        ],
      ),
    );
  }

  void _addItemSlip() async {
    controller.request.clear();
    var payType = paymentTypeController.value;
    if (ledgerNameController.value == null ||
        paymentTypeController.value == null ||
        payType == "Advance Amount" ||
        payType == "Mid Amount") {
      return;
    }

    controller.request["ledger_id"] = ledgerNameController.value?.id;
    controller.request["payment_type"] = paymentTypeController.value;

    var result = await Get.to(() => const PaymentV2SlipDetailsBottomSheet());

    if (result != null) {
      for (var element in result) {
        controller.itemTableSlipList.add(element);
        selectedSlipDetails.add(element);
        slipDataSource.updateDataGridRows();
        slipDataSource.updateDataGridSource();
        selectedAmountCalculation();
      }
    }
  }

  void _addItemPayment() async {
    if (ledgerNameController.value == null) {
      return;
    }

    paidAmountCalculation();

    _scaffoldKey.currentState!.openEndDrawer();
  }

  void selectedAmountCalculation() {
    double totalAmount = 0.0;
    double totalQty = 0;
    double tdsAm = 0.0;
    double tdsPercentage = double.tryParse(tdsPercentageController.text) ?? 0.0;

    /// Selected Amount Total Calculation
    for (var e in controller.itemTableSlipList) {
      totalAmount += e["credit_amount"];
      totalQty += e["qty"];
    }

    selectedAmount.value = AppUtils().rupeeFormat.format(totalAmount);
    selectedQty.value = totalQty;

    /// tds amount calculation ( totalAmount * tdsPercentage ) / 100
    tdsAm = (totalAmount * tdsPercentage) / 100;
    tdsAmount.value = AppUtils().rupeeFormat.format(tdsAm.roundToDouble());
    greaseAmount.value = AppUtils()
        .rupeeFormat
        .format(totalAmount.roundToDouble() - tdsAm.roundToDouble());

    controller.totalAmount =
        totalAmount.roundToDouble() - tdsAm.roundToDouble();
    controller.paymentAmount =
        totalAmount.roundToDouble() - tdsAm.roundToDouble();

    totalWages.value = AppUtils().rupeeFormat.format(totalAmount);
  }

  void paidAmountCalculation() {
    ///  Paid Amount Calculation
    double totalAmount = controller.totalAmount;
    double addedAmount = 0.0;
    double inHand = 0.0;
    double inAmount = 0.0;
    double midAmo = 0.0;
    double advAmo = 0.0;

    for (var e in paymentList) {
      var amount = e["debit_amount"];

      addedAmount += amount;
      var to = e["to"];
      if (to == 3568) {
        inHand += amount;
      } else if (to == 3569) {
        inAmount += amount;
      } else if (to == 1) {
        advAmo += amount;
      } else if (to == 2) {
        midAmo += amount;
      }
    }

    double balance = totalAmount.roundToDouble() - addedAmount.roundToDouble();
    controller.paidTotal = addedAmount;
    if (controller.totalAmount != 0.0) {
      controller.paymentAmount = balance.roundToDouble();
    }

    inHandAmount.value = AppUtils().rupeeFormat.format(inHand);
    inAccountAmount.value = AppUtils().rupeeFormat.format(inAmount);
    midAmount.value = AppUtils().rupeeFormat.format(midAmo);
    advAmount.value = AppUtils().rupeeFormat.format(advAmo);

    if (paymentTypeController.value != "Advance Amount" &&
        paymentTypeController.value != "Mid Amount") {
      balanceAmount.value = AppUtils().rupeeFormat.format(balance);
    }
  }

  void payTypeOnChange(String item, {int? ledgerId}) async {
    ledgerNameController.value = null;
    ledgerTextController.text = "";
    controller.payType = item;
    controller.ledgerDropdown.clear();
    controller.advanceAmountList.clear();

    var roll = "";
    paymentTypeController.value = item;
    paymentTypeTextController.text = item;
    if (item == "Advance Amount" || item == "Mid Amount") {
      roll = "all";
    } else if (item == "JobWorker Amount") {
      roll = "job_worker";
    } else {
      roll = item.split(" ").first.toLowerCase();
    }

    controller.itemTableSlipList.clear();
    selectedSlipDetails.clear();
    slipDataSource.updateDataGridRows();
    slipDataSource.updateDataGridSource();

    paymentList.clear();
    paymentDataSource.updateDataGridRows();
    paymentDataSource.updateDataGridSource();

    controller.paymentAmount = 0.0;
    controller.totalAmount = 0.0;
    var result = await controller.ledgerInfo(roll);
    if (ledgerId == null) {
      return;
    }
    isUpdate.value = true;
    var ledgerList =
        result.where((element) => '${element.id}' == '$ledgerId').toList();
    if (ledgerList.isNotEmpty) {
      ledgerNameController.value =
          DropModel(id: ledgerList.first.id, name: ledgerList.first.ledgerName);
      ledgerTextController.text = "${ledgerList.first.ledgerName}";
    }
  }

  void removeSelectedSlipItems() {
    int? slipIndex = _slipDataGridController.selectedIndex;
    if (slipIndex >= 0) {
      controller.itemTableSlipList.removeAt(slipIndex);
      selectedSlipDetails.removeAt(slipIndex);
      slipDataSource.updateDataGridRows();
      slipDataSource.updateDataGridSource();
      _slipDataGridController.selectedIndex = -1;
      selectedAmountCalculation();
    } else {
      AppUtils.infoAlert(message: "Select The Value");
    }
  }

  void removeSelectedPaymentItems() {
    int? paymentIndex = _paymentDataGridController.selectedIndex;
    if (paymentIndex >= 0) {
      paymentList.removeAt(paymentIndex);
      paymentDataSource.updateDataGridRows();
      paymentDataSource.updateDataGridSource();
      _paymentDataGridController.selectedIndex = -1;
      paidAmountCalculation();
    } else {
      AppUtils.infoAlert(message: "Select The Value");
    }
  }

  /// selected ledger id by get the slip details
  slipDetailsApiCall(var ledgerId, var paymentType) async {
    // if adv and mid amount not call the slip details API
    if (paymentTypeController.value == "Advance Amount" ||
        paymentTypeController.value == "Mid Amount") {
      return;
    }

    if (ledgerId == null && paymentType == null) {
      return;
    }
    _slipDataGridController.selectedIndex = -1;
    controller.itemTableSlipList.clear();
    selectedSlipDetails.clear();
    slipDataSource.updateDataGridRows();
    slipDataSource.updateDataGridSource();
    paymentList.clear();
    paymentDataSource.updateDataGridRows();
    paymentDataSource.updateDataGridSource();

    var item = await controller.ledgerBySlipDetails(ledgerId, paymentType);
    var list = [];

    for (var e in item) {
      var item = {
        "slip_rec_no": e.id,
        "slip_date": e.eDate,
        "qty": e.qty,
        "credit_amount": e.creditAmount,
      };
      list.add(item);
    }
    controller.itemTableSlipList.addAll(list);
    slipDataSource.updateDataGridRows();
    slipDataSource.updateDataGridSource();
    if (item.length == 1) {
      _slipDataGridController.selectedIndex = 0;

      selectedSlipDetails = list;

      selectedAmountCalculation();
    } else {
      totalWages.value = "0.00";
      tdsAmount.value = "0.00";
      selectedAmount.value = "0.00";
      selectedQty.value = 0;
      controller.paidTotal = 0.0;
      controller.totalAmount = 0.0;
    }
  }

  Widget crateAndUpdatedBy() {
    String id = idController.text;
    String formattedDate = AppUtils.dateFormatter.format(DateTime.now());

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${id.isEmpty ? "New : ${AppUtils().loginName}" : displayName}",
          style: AppUtils.updateAndCreateTextStyle(),
        ),
        const SizedBox(width: 12),
        Text(
          "${id.isEmpty ? formattedDate : displayDate}",
          style: AppUtils.updateAndCreateTextStyle(),
        )
      ],
    );
  }

  void accountDetailsApiCall(int id) {
    controller.accountDetails(id);
  }
}

class SlipDataSource extends DataGridSource {
  SlipDataSource({
    required List<dynamic> list,
    selectedQty,
    selectedAmount,
  }) {
    _list = list;
    updateDataGridRows();
    _selectedQty = selectedQty;
    _selectedAmount = selectedAmount;
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;
  late RxDouble _selectedQty;
  late RxString _selectedAmount;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'slip_date', value: e["slip_date"]),
        DataGridCell<dynamic>(columnName: 'slip', value: e["slip_rec_no"]),
        DataGridCell<dynamic>(columnName: 'qty', value: e['qty']),
        DataGridCell<dynamic>(columnName: 'wages', value: e['credit_amount']),
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
        case 'qty':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'wages':
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
    if (summaryColumn?.columnName == "qty") {
      return Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8),
        child: Obx(
          () => Text(
            _selectedQty.value.toStringAsFixed(0),
            style: AppUtils.footerTextStyle(),
          ),
        ),
      );
    } else if (summaryColumn?.columnName == "wages") {
      return Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8),
        child: Obx(
          () => Text(
            _selectedAmount.value,
            style: AppUtils.footerTextStyle(),
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "",
          style: AppUtils.footerTextStyle(),
        ),
      );
    }
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}

class PaymentDataSource extends DataGridSource {
  PaymentDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var particulars = "";

      particulars = "${e["e_type"] ?? ''}  To : ${e['to_name'] ?? ''}";

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'particulars', value: particulars),
        DataGridCell<dynamic>(
            columnName: 'debit_amount', value: e['debit_amount']),
        DataGridCell<dynamic>(columnName: 'details', value: e['details'] ?? ''),
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
        case 'debit_amount':
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
      case 'debit_amount':
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

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
