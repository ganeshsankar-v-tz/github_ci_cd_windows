import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/product_delivery_to_jobworker/product_deliver_to_jobworker_bottomsheet.dart';
import 'package:abtxt/view/trasaction/product_delivery_to_jobworker/product_deliver_to_jobworker_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/ProductDeliveryToJobWorkerModel.dart';
import '../../../model/TaxFixingModel.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MySmallTextField.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../basics/ledger/addledger.dart';

class AddProductDeliverToJobWorker extends StatefulWidget {
  const AddProductDeliverToJobWorker({super.key});

  static const String routeName = '/Add_Product_Deliver_To_JobWorker';

  @override
  State<AddProductDeliverToJobWorker> createState() => _State();
}

class _State extends State<AddProductDeliverToJobWorker> {
  TextEditingController idController = TextEditingController();
  TextEditingController firmNameController = TextEditingController();
  Rxn<FirmModel> firmname = Rxn<FirmModel>();
  TextEditingController dcNoController = TextEditingController();
  TextEditingController dcTypeController =
      TextEditingController(text: "Group Tax");
  Rxn<LedgerModel> jobWorker = Rxn<LedgerModel>();
  TextEditingController jobWorkerController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController balesController = TextEditingController(text: "0");
  TextEditingController transportController = TextEditingController();
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
  TextEditingController netAmountController = TextEditingController(text: "0");
  RxDouble amount = RxDouble(0);

  int? al1ano;
  int? al2ano;
  int? al3ano;
  int? al4ano;

  final _formKey = GlobalKey<FormState>();
  final ProductDeliverToJobWorkerController controller = Get.find();

  final DataGridController _dataGridController = DataGridController();

  late ItemDataSource dataSource;
  RxBool isUpdate = RxBool(false);
  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _jobWorkerFocusNode = FocusNode();
  var shortCut = RxString("");

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
    _initValue();
    _jobWorkerFocusNode.addListener(() => shortCutKeys());
    super.initState();
    dataSource = ItemDataSource(list: controller.itemList);
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_firstInputFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDeliverToJobWorkerController>(
        builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Product Deliver To JobWorker"),
          actions: [
            Visibility(
              visible: idController.text.isNotEmpty,
              child: MyDeleteIconButton(
                onPressed: (password) {
                  controller.delete(idController.text, password);
                },
              ),
            ),
            const SizedBox(width: 8),
            Visibility(
              visible: dcNoController.text.isNotEmpty,
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
          SingleActivator(LogicalKeyboardKey.keyP, control: true):
              PrintIntent(),
          SingleActivator(LogicalKeyboardKey.keyR, control: true):
              RemoveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true):
              NavigateAnotherPageIntent(),
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
            PrintIntent: SetCounterAction(perform: () {
              _print();
            }),
            RemoveIntent: SetCounterAction(perform: () {
              removeSelectedItems();
            }),
            NavigateAnotherPageIntent: SetCounterAction(perform: () {
              navigateAnotherPage();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                width: Get.width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                child: Form(
                  key: _formKey,
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
                          MyAutoComplete(
                            label: 'Firm',
                            items: controller.firmName,
                            selectedItem: firmname.value,
                            enabled: !isUpdate.value,
                            onChanged: (FirmModel item) {
                              firmname.value = item;
                            },
                            autofocus: false,
                          ),
                          Visibility(
                            visible: dcNoController.text.isNotEmpty,
                            child: MyTextField(
                              controller: dcNoController,
                              hintText: "DC No",
                              enabled: false,
                              focusNode: _firstInputFocusNode,
                              // enabled: false,
                            ),
                          ),
                          MyDropdownButtonFormField(
                              controller: dcTypeController,
                              hintText: "Dc Type",
                              enabled: !isUpdate.value,
                              items: const ["Group Tax", "Individual"]),
                          Focus(
                            focusNode: _jobWorkerFocusNode,
                            skipTraversal: true,
                            child: MyAutoComplete(
                              label: 'JobWorker Name',
                              items: controller.jobWorkerName,
                              selectedItem: jobWorker.value,
                              enabled: !isUpdate.value,
                              onChanged: (LedgerModel item) async {
                                jobWorker.value = item;
                                controller.request['supplier_id'] = item.id;
                                var list = await controller
                                    .taxFixing('JobWork Delivery');
                                _taxDialog(list);
                              },
                              autofocus: true,
                            ),
                          ),
                          MyDateFilter(
                            controller: dateController,
                            labelText: "Date",
                          ),
                          MyTextField(
                            controller: detailsController,
                            hintText: "Details",
                          ),
                          MyTextField(
                            controller: balesController,
                            hintText: "Bales",
                            validate: "number",
                          ),
                          MyTextField(
                            controller: transportController,
                            hintText: "Transport",
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
                            width: 135,
                            onPressed: () async {
                              _addItem();
                            },
                            child: const Text('Add Item'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      itemsTable(),
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
                      ),
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

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "firm_id": firmname.value?.id,
        "dc_type": dcTypeController.text,
        "job_worker_id": jobWorker.value?.id,
        "e_date": dateController.text,
        "details": detailsController.text,
        "no_of_bales": int.tryParse(balesController.text) ?? 0,
        "transport": transportController.text,
      };
      var customerItemList = [];

      for (var i = 0; i < controller.itemList.length; i++) {
        var item = {
          "order_work_id": controller.itemList[i]['order_work_id'],
          "product_id": controller.itemList[i]['product_id'],
          "work_no": controller.itemList[i]['work_no'],
          "pieces": controller.itemList[i]['pieces'],
          "qty": controller.itemList[i]['qty'],
          "rate": controller.itemList[i]['rate'],
          "amount": controller.itemList[i]['amount'],
          "ch_details": controller.itemList[i]['ch_details'],
          "lot_no": controller.itemList[i]['lot_no'],
          "agent_name": controller.itemList[i]['agent_name'],
        };
        customerItemList.add(item);
      }
      request['item_details'] = customerItemList;

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

      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        controller.add(request);
      } else {
        request['id'] = id;
        request['dc_no'] = int.tryParse(dcNoController.text);
        controller.edit(request, id);
      }
    }
  }

  void _initValue() {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    ProductDeliverToJobWorkerController controller = Get.find();
    firmname.value = AppUtils.setDefaultFirmName(controller.firmName);
    controller.request = <String, dynamic>{};
    if (Get.arguments != null) {
      isUpdate.value = true;
      var item =
          ProductDeliveryToJobWorkerModel.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      dcTypeController.text = '${item.dcType}';
      dateController.text = '${item.eDate}';
      balesController.text = '${item.noOfBales}';
      detailsController.text = item.details ?? '';
      dcNoController.text = "${item.dcNo}";
      transportController.text = item.transport ?? '';

      var firmNameList = controller.firmName
          .where((element) => '${element.id}' == '${item.firmId}')
          .toList();
      if (firmNameList.isNotEmpty) {
        firmname.value = firmNameList.first;
        firmNameController.text = '${firmNameList.first.firmName}';
      }
      var jobWorkerList = controller.jobWorkerName
          .where((element) => '${element.id}' == '${item.jobWorkerId}')
          .toList();
      if (jobWorkerList.isNotEmpty) {
        jobWorker.value = jobWorkerList.first;
        jobWorkerController.text = '${jobWorkerList.first.ledgerName}';
      }

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

      item.itemDetails?.forEach((element) {
        amount.value += double.tryParse("${element.amount}") ?? 0.0;
        var request = element.toJson();
        controller.itemList.add(request);
      });

      al1ano = item.al1Ano;
      al2ano = item.al2Ano;
      al3ano = item.al3Ano;
      al4ano = item.al4Ano;

      //al1
      al1TypController.text = item.al1Typ ?? "None";
      al1PercController.text = tryCast(item.al1Perc);
      al1AccountNoController.text = tryCast(item.al1AnoName);
      al1AmountController.text = '${item.al1Amount}';

      //al2
      al2TypController.text = item.al2Typ ?? "None";
      al2PercController.text = tryCast(item.al2Perc);
      al2AccountNoController.text = tryCast(item.al2AnoName);
      al2AmountController.text = '${item.al2Amount}';

      //al3
      al3TypController.text = item.al3Typ ?? "None";
      al3PercController.text = tryCast(item.al3Perc);
      al3AccountNoController.text = tryCast(item.al3AnoName);
      al3AmountController.text = '${item.al3Amount}';

      //al4
      al4TypController.text = item.al4Typ ?? "None";
      al4PercController.text = tryCast(item.al3Perc);
      al4AccountNoController.text = tryCast(item.al4AnoName);
      al4AmountController.text = '${item.al4Amount}';

      netAmountController.text = "${item.netTotal}";
    }
    // initTotal();
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
                    _calculateAmount();
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
                  _calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al1AmountController,
                onChanged: (value) {
                  al1PercController.text = '0';
                  _calculateAmount();
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
                    _calculateAmount();
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
                  _calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al2AmountController,
                onChanged: (value) {
                  al2PercController.text = '0';
                  _calculateAmount();
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
                    _calculateAmount();
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
                  _calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al3AmountController,
                onChanged: (value) {
                  al3PercController.text = '0';
                  _calculateAmount();
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
                    _calculateAmount();
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
                  _calculateAmount();
                },
                suffix:
                    const Text("%", style: TextStyle(color: Color(0XFF5700BC))),
              ),
              MySmallTextField(
                controller: al4AmountController,
                onChanged: (value) {
                  al4PercController.text = '0';
                  _calculateAmount();
                },
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

  void _calculateAmount() {
    /// Al Percentage Field Controllers Data Type Change
    double al1Percent = double.tryParse(al1PercController.text) ?? 0;
    double al2Percent = double.tryParse(al2PercController.text) ?? 0;
    double al3Percent = double.tryParse(al3PercController.text) ?? 0;
    double al4Percent = double.tryParse(al4PercController.text) ?? 0;

    /// Al Amount Field Controllers Data Type Change
    /*double al1Amount = double.tryParse(al1AmountController.text) ?? 0;
    double al2Amount = double.tryParse(al2AmountController.text) ?? 0;
    double al3Amount = double.tryParse(al3AmountController.text) ?? 0;
    double al4Amount = double.tryParse(al4AmountController.text) ?? 0;*/

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
    netAmountController.text = netAmount.toStringAsFixed(2);
  }

  Widget itemsTable() {
    return MySFDataGridItemTable(
      selectionMode: SelectionMode.single,
      controller: _dataGridController,
      columns: [
        GridColumn(
          columnName: 'ordered_work',
          label: const MyDataGridHeader(title: 'Ordered Work'),
        ),
        GridColumn(
          columnName: 'product_name',
          label: const MyDataGridHeader(title: 'Product Name'),
        ),
        GridColumn(
          width: 100,
          columnName: 'design_no',
          label: const MyDataGridHeader(title: 'Design No'),
        ),
        GridColumn(
          width: 70,
          columnName: 'pieces',
          label: const MyDataGridHeader(title: 'Pieces'),
        ),
        GridColumn(
          width: 70,
          columnName: 'qty',
          label: const MyDataGridHeader(title: 'Quantity'),
        ),
        GridColumn(
          width: 80,
          columnName: 'rate',
          label: const MyDataGridHeader(title: 'Rate(Rs)'),
        ),
        GridColumn(
          width: 100,
          columnName: 'amount',
          label: const MyDataGridHeader(title: 'Amount(Rs)'),
        ),
        GridColumn(
          columnName: 'current_work',
          label: const MyDataGridHeader(title: 'Current Work'),
        ),
        GridColumn(
          columnName: 'details',
          label: const MyDataGridHeader(title: 'Details'),
        ),
        GridColumn(
          columnName: 'agent_name',
          label: const MyDataGridHeader(title: 'Agent Name'),
        ),
        GridColumn(
          width: 100,
          columnName: 'lot_no',
          label: const MyDataGridHeader(title: 'Lot No'),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'pieces',
              columnName: 'pieces',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'qty',
              columnName: 'qty',
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
      onRowSelected: (index) async {
        var item = controller.itemList[index];
        controller.slipId = int.tryParse(idController.text);
        var result = await Get.to(
            () => const ProductDeliverToJobWorkerBottomSheet(),
            arguments: {'item': item});
        if (result != null) {
          controller.itemList[index] = result;
          double total = 0;
          for (var element in controller.itemList) {
            total += element['amount'];
          }
          amount.value = total;
          _calculateAmount();
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        }
      },
    );
  }

  void removeSelectedItems() {
    int? index = _dataGridController.selectedIndex;
    if (index >= 0) {
      controller.itemList.removeAt(index);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
      _dataGridController.selectedIndex = -1;
    } else {
      AppUtils.infoAlert(message: "Select The Value");
    }
  }

  void _addItem() async {
    var result =
        await Get.to(() => const ProductDeliverToJobWorkerBottomSheet());
    if (result != null) {
      controller.itemList.add(result);
      double total = 0;
      for (var element in controller.itemList) {
        total += element['amount'];
      }
      amount.value = total;
      _calculateAmount();
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    }
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
        });
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

    _calculateAmount();
  }

  Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }

    var request = {'id': idController.text};

    String? response = await controller.jobWorkDeliveryReport(request: request);

    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }

  shortCutKeys() {
    if (_jobWorkerFocusNode.hasFocus && Get.arguments == null) {
      shortCut.value = "To Create 'JobWorker',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  navigateAnotherPage() async {
    if (_jobWorkerFocusNode.hasFocus && Get.arguments == null) {
      var result = await Get.toNamed(AddLedger.routeName);

      if (result == "success") {
        controller.ledgerInfo();
      }
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
            columnName: 'ordered_work', value: e['work_name']),
        DataGridCell<dynamic>(
            columnName: 'product_name', value: e['product_name']),
        DataGridCell<dynamic>(columnName: 'design_no', value: e['design_no']),
        DataGridCell<dynamic>(columnName: 'pieces', value: e['pieces']),
        DataGridCell<dynamic>(columnName: 'qty', value: e['qty']),
        DataGridCell<dynamic>(columnName: 'rate', value: e['rate']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['amount']),
        DataGridCell<dynamic>(
            columnName: 'current_work', value: e['current_work']),
        DataGridCell<dynamic>(columnName: 'details', value: e['ch_details']),
        DataGridCell<dynamic>(columnName: 'agent_name', value: e['agent_name']),
        DataGridCell<dynamic>(columnName: 'lot_no', value: e['lot_no']),
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
        case 'pieces':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'qty':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'rate':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'amount':
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
      case 'pieces':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'qty':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'amount':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      default:
        /* alignment = TextAlign.left;
        return const Text('Total: ',  style: TextStyle(fontWeight: FontWeight.w700),);*/
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
