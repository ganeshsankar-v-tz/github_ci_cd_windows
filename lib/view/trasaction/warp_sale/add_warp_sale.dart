import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/WarpSaleModel.dart';
import 'package:abtxt/view/trasaction/warp_sale/warp_sale_bottomsheet.dart';
import 'package:abtxt/view/trasaction/warp_sale/warp_sale_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/TaxFixingModel.dart';
import '../../../model/vehicle_details/VehicleDetailsModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MySmallTextField.dart';
import '../../../widgets/MySubmitButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/my_search_field/my_search_field.dart';
import '../../basics/ledger/addledger.dart';

class AddWarpSale extends StatefulWidget {
  const AddWarpSale({super.key});

  static const String routeName = '/add_warp_sale';

  @override
  State<AddWarpSale> createState() => _State();
}

class _State extends State<AddWarpSale> {
  TextEditingController idController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  TextEditingController firmController = TextEditingController();
  Rxn<LedgerModel> customerName = Rxn<LedgerModel>();
  TextEditingController customerController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  Rxn<LedgerModel> accountType = Rxn<LedgerModel>();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController lrNoController = TextEditingController();
  TextEditingController lrDateController = TextEditingController();
  TextEditingController transportTextController = TextEditingController();
  Rxn<VehicleDetailsModel> transportController = Rxn<VehicleDetailsModel>();

  final _formKey = GlobalKey<FormState>();
  final WarpSaleController controller = Get.find();
  final DataGridController _dataGridController = DataGridController();

  RxBool isUpdate = RxBool(false);
  final FocusNode _firmFocusNode = FocusNode();
  final FocusNode _accountTypeFocusNode = FocusNode();
  final FocusNode _customerNameFocusNode = FocusNode();
  final FocusNode _transportFocusNode = FocusNode();
  final FocusNode _detailsFocusNode = FocusNode();
  final FocusNode _dateFocusNode = FocusNode();
  var shortCut = RxString("");

  TextEditingController al1TypController = TextEditingController(text: "None");
  TextEditingController al2TypController = TextEditingController(text: "None");
  TextEditingController al3TypController = TextEditingController(text: "None");
  TextEditingController al4TypController = TextEditingController(text: "None");
  TextEditingController al1AccountNoController = TextEditingController();
  Rxn<TaxFixingModel> al1Tax = Rxn<TaxFixingModel>();
  TextEditingController al2AccountNoController = TextEditingController();
  Rxn<TaxFixingModel> al2Tax = Rxn<TaxFixingModel>();
  TextEditingController al3AccountNoController = TextEditingController();
  Rxn<TaxFixingModel> al3Tax = Rxn<TaxFixingModel>();
  TextEditingController al4AccountNoController = TextEditingController();
  Rxn<TaxFixingModel> al4Tax = Rxn<TaxFixingModel>();
  TextEditingController al1PercController = TextEditingController(text: "0");
  TextEditingController al2PercController = TextEditingController(text: "0");
  TextEditingController al3PercController = TextEditingController(text: "0");
  TextEditingController al4PercController = TextEditingController(text: "0");
  TextEditingController al1AmountController = TextEditingController(text: "0");
  TextEditingController al2AmountController = TextEditingController(text: "0");
  TextEditingController al3AmountController = TextEditingController(text: "0");
  TextEditingController al4AmountController = TextEditingController(text: "0");
  TextEditingController roundOffController = TextEditingController(text: "0");
  TextEditingController netAmountController = TextEditingController(text: "0");
  RxDouble amount = RxDouble(0);

  int? al1ano;
  int? al2ano;
  int? al3ano;
  int? al4ano;

  late ItemDataSource dataSource;

  /// created by and updated by details controllers
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? displayName;
  String? displayDate;

  @override
  void initState() {
    controller.itemList.clear();
    _accountTypeFocusNode.addListener(() => shortCutKeys());
    _customerNameFocusNode.addListener(() => shortCutKeys());
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: controller.itemList);
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_dateFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpSaleController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title:
              Text("${idController.text == '' ? 'Add' : 'Update'} Warp Sale"),
          actions: [
            Visibility(
                visible: idController.text.isNotEmpty,
                child: MyDeleteIconButton(
                  onPressed: (password) {
                    controller.delete(idController.text, password);
                  },
                )),
            Visibility(
              visible: idController.text.isNotEmpty,
              child: MyPrintButton(
                onPressed: () => _print(),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyN, control: true):
              AddNewIntent(),
          SingleActivator(LogicalKeyboardKey.keyR, control: true):
              RemoveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            AddNewIntent: SetCounterAction(perform: () {
              _addItem();
            }),
            RemoveIntent: SetCounterAction(perform: () {
              removeSelectedItems();
            }),
            NavigateIntent: SetCounterAction(perform: () {
              navigateAnotherPage();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
              ),
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
                            autofocus: false,
                            enabled: !isUpdate.value,
                            items: controller.firmDropdown,
                            textController: firmController,
                            focusNode: _firmFocusNode,
                            requestFocus: _accountTypeFocusNode,
                            onChanged: (FirmModel item) {
                              firmName.value = item;
                            },
                          ),
                          MySearchField(
                            label: 'Account Type',
                            autofocus: false,
                            items: controller.accountDropdown,
                            enabled: !isUpdate.value,
                            textController: accountTypeController,
                            focusNode: _accountTypeFocusNode,
                            requestFocus: _customerNameFocusNode,
                            onChanged: (LedgerModel item) {
                              accountType.value = item;
                            },
                          ),
                          MySearchField(
                            width: 350,
                            label: 'Supplier',
                            autofocus: true,
                            items: controller.ledgerDropdown,
                            textController: customerController,
                            focusNode: _customerNameFocusNode,
                            requestFocus: _dateFocusNode,
                            enabled: !isUpdate.value,
                            onChanged: (LedgerModel item) async {
                              customerName.value = item;
                              var list =
                                  await controller.taxFixing('Warp Sales');
                              _taxDialog(list);
                            },
                          ),
                          MyDateFilter(
                            width: 160,
                            focusNode: _dateFocusNode,
                            controller: dateController,
                            labelText: "Date",
                          ),
                          MyDateFilter(
                            width: 160,
                            controller: lrDateController,
                            labelText: 'LR Date',
                            required: false,
                          ),
                          MyTextField(
                            controller: lrNoController,
                            hintText: "LR No",
                          ),
                          MySearchField(
                            width: 300,
                            label: 'Transport',
                            items: controller.vehicleDetailsList,
                            textController: transportTextController,
                            focusNode: _transportFocusNode,
                            requestFocus: _detailsFocusNode,
                            isValidate: false,
                            onChanged: (VehicleDetailsModel item) async {
                              transportController.value = item;
                            },
                          ),
                          MyTextField(
                            focusNode: _detailsFocusNode,
                            controller: detailsController,
                            hintText: "Details",
                          ),
                        ],
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
                      const SizedBox(height: 12),
                      Flexible(child: itemsTable()),
                      gstCalculation(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          crateAndUpdatedBy(),
                          const Spacer(),
                          Obx(
                            () => Text(shortCut.value,
                                style: AppUtils.shortCutTextStyle()),
                          ),
                          const SizedBox(width: 12),
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
        ),
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      double netTotal = 0;

      for (var e in controller.itemList) {
        netTotal += e["amount"];
      }

      var request = {
        "firm_id": firmName.value?.id,
        "customer_id": customerName.value?.id,
        "sale_ano": accountType.value?.id,
        "e_date": dateController.text,
        "details": detailsController.text,
        "lr_no": lrNoController.text,
        "lr_date": lrDateController.text,
        "transport": transportTextController.text,
        "gross_amount": netTotal
      };
      // al1
      request["al1_typ"] = al1TypController.text;
      request["al1_perc"] = double.tryParse(al1PercController.text) ?? 0.00;
      request["al1_amount"] = double.tryParse(al1AmountController.text) ?? 0.00;
      if (al1TypController.text != "None") {
        request["al1_ano"] = al1ano;
      }

      // al2
      request["al2_typ"] = al2TypController.text;
      request["al2_perc"] = double.tryParse(al2PercController.text) ?? 0.00;
      request["al2_amount"] = double.tryParse(al2AmountController.text) ?? 0.00;
      if (al2TypController.text != "None") {
        request["al2_ano"] = al2ano;
      }

      //al3
      request["al3_typ"] = al3TypController.text;
      request["al3_perc"] = double.tryParse(al3PercController.text) ?? 0.00;
      request["al3_amount"] = double.tryParse(al3AmountController.text) ?? 0.00;
      if (al3TypController.text != "None") {
        request["al3_ano"] = al3ano;
      }

      //al4
      request["al4_typ"] = al4TypController.text;
      request["al4_perc"] = double.tryParse(al4PercController.text) ?? 0.00;
      request["al4_amount"] = double.tryParse(al4AmountController.text) ?? 0.00;
      if (al4TypController.text != "None") {
        request["al4_ano"] = al4ano;
      }
      request["net_total"] = double.tryParse(netAmountController.text) ?? 0.00;
      request["round_off"] = double.tryParse(roundOffController.text) ?? 0.00;

      request['item_details'] = controller.itemList;

      var id = idController.text;
      if (id.isEmpty) {
        controller.add(request);
      } else {
        request['id'] = id;
        controller.edit(request, id);
      }
    }
  }

  void _initValue() {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");

    var acType = AppUtils.findLedgerAccountByName(
        controller.accountDropdown, 'Warp Sales Account');

    if (acType != null) {
      accountType.value = acType;
      accountTypeController.text = acType.ledgerName;
    }
    var firm = AppUtils.setDefaultFirmName(controller.firmDropdown);
    if (firm != null) {
      firmName.value = firm;
      firmController.text = firm.firmName ?? "";
    }

    if (Get.arguments != null) {
      WarpSaleModel items = Get.arguments['item'];
      isUpdate.value = true;
      idController.text = '${items.id}';
      dateController.text = '${items.eDate}';
      detailsController.text = items.details ?? "";
      lrNoController.text = items.lrNo ?? "";
      lrDateController.text = items.lrDate ?? "";

      var firmList = controller.firmDropdown
          .where((element) => '${element.id}' == '${items.firmId}')
          .toList();
      if (firmList.isNotEmpty) {
        firmName.value = firmList.first;
        firmController.text = '${firmList.first.firmName}';
      }
      var customerList = controller.ledgerDropdown
          .where((element) => '${element.id}' == '${items.customerId}')
          .toList();
      if (customerList.isNotEmpty) {
        customerName.value = customerList.first;
        customerController.text = '${customerList.first.ledgerName}';
      }
      var accountList = controller.accountDropdown
          .where((element) => '${element.id}' == '${items.saleAno}')
          .toList();
      if (accountList.isNotEmpty) {
        accountType.value = accountList.first;
        accountTypeController.text = '${accountList.first.ledgerName}';
      }

      /// get created by and updated by details
      DateTime createDate = DateTime.parse(items.createdAt ?? "0000-00-00");
      DateTime updateDate = DateTime.parse(items.updatedAt ?? "0000-00-00");
      createdAt = AppUtils.dateFormatter.format(createDate);
      updatedAt = AppUtils.dateFormatter.format(updateDate);
      createdBy = items.creatorName;
      updatedBy = items.updatedName;
      if (updatedBy != null) {
        displayName = "Edit : $updatedBy";
        displayDate = updatedAt;
      } else {
        displayName = "New : $createdBy";
        displayDate = createdAt;
      }

      items.itemDetails?.forEach((element) {
        var request = element.toJson();
        controller.itemList.add(request);
      });
      al1ano = items.al1Ano;
      al2ano = items.al2Ano;
      al3ano = items.al3Ano;
      al4ano = items.al4Ano;

      //al1
      al1TypController.text = items.al1Typ ?? "None";
      al1PercController.text = tryCast(items.al1Perc);
      al1AccountNoController.text = tryCast(items.ledgerNameA1);
      al1AmountController.text = '${items.al1Amount}';

      //al2
      al2TypController.text = items.al2Typ ?? "None";
      al2PercController.text = tryCast(items.al2Perc);
      al2AccountNoController.text = tryCast(items.ledgerNameA2);
      al2AmountController.text = '${items.al2Amount}';

      //al3
      al3TypController.text = items.al3Typ ?? "None";
      al3PercController.text = tryCast(items.al3Perc);
      al3AccountNoController.text = tryCast(items.ledgerNameA3);
      al3AmountController.text = '${items.al3Amount}';

      //al4
      al4TypController.text = items.al4Typ ?? "None";
      al4PercController.text = tryCast(items.al4Perc);
      al4AccountNoController.text = tryCast(items.ledgerNameA4);
      al4AmountController.text = '${items.al4Amount}';

      netAmountController.text = "${items.netTotal}";
      roundOffController.text = "${items.roundOff}";
    }
  }

  Widget itemsTable() {
    return MySFDataGridItemTable(
      controller: _dataGridController,
      selectionMode: SelectionMode.single,
      scrollPhysics: const ScrollPhysics(),
      shrinkWrapRows: false,
      columns: [
        GridColumn(
          columnName: 'warp_design_name',
          label: const MyDataGridHeader(title: 'Warp Design'),
        ),
        GridColumn(
          width: 110,
          columnName: 'warp_type',
          label: const MyDataGridHeader(title: 'Warp Type'),
        ),
        GridColumn(
          width: 160,
          columnName: 'warp_id',
          label: const MyDataGridHeader(title: 'Warp ID'),
        ),
        GridColumn(
          width: 60,
          columnName: 'product_qty',
          label: const MyDataGridHeader(
            title: 'Qyt',
            alignment: Alignment.center,
          ),
        ),
        GridColumn(
          width: 80,
          columnName: 'meter',
          label: const MyDataGridHeader(
            title: 'Meter',
            alignment: Alignment.center,
          ),
        ),
        GridColumn(
          width: 80,
          columnName: 'sheet',
          label: const MyDataGridHeader(
            title: 'Sheet',
            alignment: Alignment.center,
          ),
        ),
        GridColumn(
          columnName: 'warp_color',
          label: const MyDataGridHeader(title: 'Warp Color'),
        ),
        GridColumn(
          columnName: 'details',
          label: const MyDataGridHeader(title: 'Details'),
        ),
        GridColumn(
          width: 120,
          columnName: 'warp_weight',
          label: const MyDataGridHeader(
            title: 'Weight',
            alignment: Alignment.center,
          ),
        ),
        GridColumn(
          width: 120,
          columnName: 'rate',
          label: const MyDataGridHeader(
            title: 'Rate',
            alignment: Alignment.center,
          ),
        ),
        GridColumn(
          width: 120,
          columnName: 'amount',
          label: const MyDataGridHeader(
            title: 'Amount(Rs)',
            alignment: Alignment.center,
          ),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'product_qty',
              columnName: 'product_qty',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'meter',
              columnName: 'meter',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'sheet',
              columnName: 'sheet',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'amount',
              columnName: 'amount',
              summaryType: GridSummaryType.sum,
            ),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSource,
    );
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

  _addItem() async {
    if (customerName.value == null) {
      return AppUtils.infoAlert(message: "Select the Customer name");
    }

    if (controller.itemList.isNotEmpty) {
      controller.warpName = controller.itemList.last["warp_design_name"];
    } else {
      controller.warpName = "";
    }

    var result = await Get.to(() => const WarpSaleBottomSheet());
    if (result != null) {
      controller.itemList.add(result);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
      amountCalculation();
    }
  }

  void removeSelectedItems() {
    int? index = _dataGridController.selectedIndex;
    if (index >= 0) {
      controller.itemList.removeAt(index);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
      _dataGridController.selectedIndex = -1;
      amountCalculation();
    } else {
      AppUtils.infoAlert(message: "Select The Value");
    }
  }

  shortCutKeys() {
    if (_accountTypeFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Account',Press Alt+C ";
    } else if (_customerNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Customer',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_accountTypeFocusNode.hasFocus) {
      var result = await Get.toNamed(AddLedger.routeName);

      if (result == "success") {
        controller.accountInfo();
      }
    } else if (_customerNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddLedger.routeName);

      if (result == "success") {
        controller.ledgerInfo();
      }
    }
  }

  Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }

    String? response = await controller.warpSalePdf(idController.text);
    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }

  Widget gstCalculation() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: 400,
        color: Colors.white,
        padding: const EdgeInsets.all(12.0),
        child: Table(
          children: [
            /// Al1
            TableRow(children: [
              SizedBox(
                height: 50,
                child: MyDialogList(
                  labelText: '',
                  isValidate: false,
                  controller: al1TypController,
                  list: const ["None", "Add", "Less"],
                  onItemSelected: (String item) {
                    al1TypController.text = item;
                    al1PercController.text = '0';
                    al1AmountController.text = '0';
                    calculateAmount();
                  },
                  onCreateNew: (value) async {},
                ),
              ),
              SizedBox(
                height: 50,
                child: MyDialogList(
                  labelText: '',
                  controller: al1AccountNoController,
                  list: controller.ledgerByTax,
                  isValidate: false,
                  onItemSelected: (LedgerModel item) {
                    al1AccountNoController.text = "${item.ledgerName}";
                    al1ano = int.tryParse("${item.id}");
                  },
                  onCreateNew: (value) async {},
                ),
              ),
              MySmallTextField(
                controller: al1PercController,
                onChanged: (value) {
                  al1AmountController.text = '0';
                  calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al1AmountController,
                onChanged: (value) {
                  al1PercController.text = '0';
                  calculateAmount();
                },
              ),
            ]),

            /// Al2
            TableRow(children: [
              SizedBox(
                height: 50,
                child: MyDialogList(
                  labelText: '',
                  controller: al2TypController,
                  isValidate: false,
                  list: const ["None", "Add", "Less"],
                  onItemSelected: (String item) {
                    al2TypController.text = item;
                    al2PercController.text = '0';
                    al2AmountController.text = '0';
                    calculateAmount();
                  },
                  onCreateNew: (value) async {},
                ),
              ),
              SizedBox(
                height: 50,
                child: MyDialogList(
                  labelText: '',
                  controller: al2AccountNoController,
                  isValidate: false,
                  list: controller.ledgerByTax,
                  onItemSelected: (LedgerModel item) {
                    al2AccountNoController.text = "${item.ledgerName}";
                    al2ano = int.tryParse("${item.id}");
                  },
                  onCreateNew: (value) async {},
                ),
              ),
              MySmallTextField(
                controller: al2PercController,
                onChanged: (value) {
                  al2AmountController.text = '0';
                  calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al2AmountController,
                onChanged: (value) {
                  al2PercController.text = '0';
                  calculateAmount();
                },
              ),
            ]),

            /// Al3
            TableRow(children: [
              SizedBox(
                height: 50,
                child: MyDialogList(
                  labelText: '',
                  controller: al3TypController,
                  isValidate: false,
                  list: const ["None", "Add", "Less"],
                  onItemSelected: (String item) {
                    al3TypController.text = item;
                    al3PercController.text = '0';
                    al3AmountController.text = '0';
                    calculateAmount();
                  },
                  onCreateNew: (value) async {},
                ),
              ),
              SizedBox(
                height: 50,
                child: MyDialogList(
                  labelText: '',
                  controller: al3AccountNoController,
                  isValidate: false,
                  list: controller.ledgerByTax,
                  onItemSelected: (LedgerModel item) {
                    al3AccountNoController.text = "${item.ledgerName}";
                    al3ano = int.tryParse("${item.id}");
                  },
                  onCreateNew: (value) async {},
                ),
              ),
              MySmallTextField(
                controller: al3PercController,
                onChanged: (value) {
                  al3AmountController.text = '0';
                  calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al3AmountController,
                onChanged: (value) {
                  al3PercController.text = '0';
                  calculateAmount();
                },
              ),
            ]),

            /// Al4
            TableRow(children: [
              SizedBox(
                height: 50,
                child: MyDialogList(
                  labelText: '',
                  controller: al4TypController,
                  isValidate: false,
                  list: const ["None", "Add", "Less"],
                  onItemSelected: (String item) {
                    al4TypController.text = item;
                    al4PercController.text = '0';
                    al4AmountController.text = '0';
                    calculateAmount();
                  },
                  onCreateNew: (value) async {},
                ),
              ),
              SizedBox(
                height: 50,
                child: MyDialogList(
                  labelText: '',
                  controller: al4AccountNoController,
                  list: controller.ledgerByTax,
                  isValidate: false,
                  onItemSelected: (LedgerModel item) {
                    al4AccountNoController.text = "${item.ledgerName}";
                    al4ano = int.tryParse("${item.id}");
                  },
                  onCreateNew: (value) async {},
                ),
              ),
              MySmallTextField(
                controller: al4PercController,
                onChanged: (value) {
                  al4AmountController.text = '0';
                  calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al4AmountController,
                onChanged: (value) {
                  al4PercController.text = '0';
                  calculateAmount();
                },
              ),
            ]),

            /// Round Of
            TableRow(children: [
              const Text(''),
              const Text(''),
              const SizedBox(
                  width: 50,
                  height: 35,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text('Round Off'))),
              MySmallTextField(
                controller: roundOffController,
                readonly: true,
              ),
            ]),

            /// Net Total
            TableRow(children: [
              const Text(''),
              const Text(''),
              const SizedBox(
                  width: 50,
                  height: 35,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text('Net Total'))),
              MySmallTextField(
                controller: netAmountController,
                readonly: true,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  void _taxDialog(List<TaxFixingModel> list) {
    if (list.isEmpty) {
      return;
    }
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                var item = list[index];
                return ListTile(
                  autofocus: true,
                  title: Text('$item'),
                  onTap: () {
                    _initTaxWidget(item);
                    Get.back();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _initTaxWidget(TaxFixingModel item) {
    al1ano = item.al1Ano;
    al2ano = item.al2Ano;
    al3ano = item.al3Ano;
    al4ano = item.al4Ano;

    //al1
    al1TypController.text = item.al1Typ ?? "None";
    al1PercController.text = '${item.al1Perc}';
    al1AccountNoController.text = item.al1AnoName ?? "";
    //al2
    al2TypController.text = item.al2Typ ?? "None";
    al2PercController.text = '${item.al2Perc}';
    al2AccountNoController.text = item.al2AnoName ?? "";
    //al3
    al3TypController.text = item.al3Typ ?? "None";
    al3PercController.text = '${item.al3Perc}';
    al3AccountNoController.text = item.al3AnoName ?? "";
    //al4
    al4TypController.text = item.al4Typ ?? "None";
    al4PercController.text = '${item.al4Perc}';
    al4AccountNoController.text = item.al4AnoName ?? '';

    calculateAmount();
  }

  amountCalculation() {
    double total = 0;
    for (var element in controller.itemList) {
      total += element['amount'];
    }

    amount.value = total;
    calculateAmount();
  }

  void calculateAmount() {
    /// Al Percentage Field Controllers Data Type Change
    double al1Percent = double.tryParse(al1PercController.text) ?? 0;
    double al2Percent = double.tryParse(al2PercController.text) ?? 0;
    double al3Percent = double.tryParse(al3PercController.text) ?? 0;
    double al4Percent = double.tryParse(al4PercController.text) ?? 0;

    double total = amount.value;
    double netAmount = total;

    /// Al1 Percentage And Amount Calculation

    if (al1TypController.text == 'None') {
      al1AmountController.text = "0";
      al1PercController.text = "0";
    } else {
      if (al1Percent != 0) {
        al1AmountController.text =
            ((total * al1Percent) / 100).toStringAsFixed(3);
      }
      if (al1TypController.text == 'Add') {
        netAmount += double.tryParse(al1AmountController.text) ?? 0.0;
      } else {
        netAmount -= double.tryParse(al1AmountController.text) ?? 0.0;
      }
    }

    /// Al2 Percentage And Amount Calculation

    if (al2TypController.text == 'None') {
      al2AmountController.text = "0";
      al2PercController.text = "0";
    } else {
      if (al2Percent != 0) {
        al2AmountController.text =
            ((total * al2Percent) / 100).toStringAsFixed(3);
      }
      if (al2TypController.text == 'Add') {
        netAmount += double.tryParse(al2AmountController.text) ?? 0.0;
      } else {
        netAmount -= double.tryParse(al2AmountController.text) ?? 0.0;
      }
    }

    /// Al3 Percentage And Amount Calculation

    if (al3TypController.text == 'None') {
      al3AmountController.text = "0";
      al3PercController.text = "0";
    } else {
      if (al3Percent != 0) {
        al3AmountController.text =
            ((total * al3Percent) / 100).toStringAsFixed(3);
      }
      if (al3TypController.text == 'Add') {
        netAmount += double.tryParse(al3AmountController.text) ?? 0.0;
      } else {
        netAmount -= double.tryParse(al3AmountController.text) ?? 0.0;
      }
    }

    /// Al4 Percentage And Amount Calculation

    if (al4TypController.text == 'None') {
      al4AmountController.text = "0";
      al4PercController.text = "0";
    } else {
      if (al4Percent != 0) {
        al4AmountController.text =
            ((total * al4Percent) / 100).toStringAsFixed(3);
      }
      if (al4TypController.text == 'Add') {
        netAmount += double.tryParse(al4AmountController.text) ?? 0.0;
      } else {
        netAmount -= double.tryParse(al4AmountController.text) ?? 0.0;
      }
    }

    double roundOfRemainder = netAmount.roundToDouble() - netAmount;
    roundOffController.text = roundOfRemainder.toStringAsFixed(2);
    netAmountController.text = netAmount.roundToDouble().toStringAsFixed(2);
  }
}

class ItemDataSource extends DataGridSource {
  ItemDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(
            columnName: 'warp_design_name', value: e['warp_design_name']),
        DataGridCell<dynamic>(columnName: 'warp_type', value: e['warp_type']),
        DataGridCell<dynamic>(columnName: 'warp_id', value: e['warp_id']),
        DataGridCell<dynamic>(
            columnName: 'product_qty', value: e['product_qty']),
        DataGridCell<dynamic>(columnName: 'meter', value: e['meter']),
        DataGridCell<dynamic>(columnName: 'sheet', value: e['sheet']),
        DataGridCell<dynamic>(
            columnName: 'warp_color', value: e['warp_color'] ?? ''),
        DataGridCell<dynamic>(columnName: 'details', value: e['details'] ?? ''),
        DataGridCell<dynamic>(
            columnName: 'warp_weight', value: e['warp_weight']),
        DataGridCell<dynamic>(columnName: 'rate', value: e['rate']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['amount']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      var amount = "";
      if (e.columnName == "amount" || e.columnName == "rate") {
        amount = formater("${e.value}");
      }

      return Container(
        padding: const EdgeInsets.all(8),
        alignment: (e.columnName == "meter" ||
                e.columnName == "sheet" ||
                e.columnName == "product_qty" ||
                e.columnName == "product_qty" ||
                e.columnName == "amount" ||
                e.columnName == "rate" ||
                e.columnName == "warp_weight")
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Text(
          (e.columnName == "amount" || e.columnName == "rate")
              ? amount
              : e.value != null
                  ? '${e.value}'
                  : '',
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
    var e = summaryColumn?.columnName;

    var amount = "";
    if (e == "amount") {
      amount = formater(summaryValue);
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: (e == "meter" ||
              e == "sheet" ||
              e == "product_qty" ||
              e == "amount" ||
              e == "warp_weight")
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Text(
        e == "amount" ? amount : summaryValue,
        style: AppUtils.footerTextStyle(),
      ),
    );
  }

  String formater(String value) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      decimalDigits: 2,
      name: '',
    );
    double amount = double.tryParse(value) ?? 0.0;

    return formatter.format(amount);
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
