import 'package:abtxt/model/JariTwistingModel.dart';
import 'package:abtxt/model/MachineDetailsModel.dart';
import 'package:abtxt/model/jari_twinsting_yarn_inward_V2/JariTwistingInwardV2Model.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import 'jari_twisting_yarn_inward_bhottom_sheet_v2.dart';
import 'jari_twisting_yarn_inward_controller_v2.dart';

class AddJariTwistingYarnInwardV2 extends StatefulWidget {
  const AddJariTwistingYarnInwardV2({super.key});

  static const String routeName = '/add_jari_twisting_yarn_inward_v2';

  @override
  State<AddJariTwistingYarnInwardV2> createState() =>
      _AddJariTwistingYarnInwardV2State();
}

class _AddJariTwistingYarnInwardV2State
    extends State<AddJariTwistingYarnInwardV2> {
  TextEditingController idController = TextEditingController();
  TextEditingController firmNameTextController = TextEditingController();
  Rxn<FirmModel> firmNameController = Rxn<FirmModel>();
  TextEditingController dateController = TextEditingController();
  TextEditingController accountTypeTextController = TextEditingController();
  Rxn<LedgerModel> accountTypeController = Rxn<LedgerModel>();
  Rxn<JariTwistingModel> yarnNameController = Rxn<JariTwistingModel>();
  TextEditingController yarnNameTextController = TextEditingController();
  Rxn<NewColorModel> colorNameController = Rxn<NewColorModel>();
  TextEditingController colorNameTextController = TextEditingController();
  TextEditingController stockController = TextEditingController(text: "Office");
  Rxn<MachineDetailsModel> machineNameController = Rxn<MachineDetailsModel>();
  TextEditingController machineNameTextController = TextEditingController();
  TextEditingController machineTypeController = TextEditingController();
  TextEditingController deckTypeController = TextEditingController();
  TextEditingController spendileController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController boxNoController = TextEditingController();
  TextEditingController packController = TextEditingController(text: '0');
  TextEditingController netQuantityController =
      TextEditingController(text: '0.000');
  TextEditingController wagesRsController = TextEditingController(text: '0.00');
  TextEditingController totalAmountController =
      TextEditingController(text: '0.00');
  TextEditingController detailsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final JariTwistingYarnInwardControllerV2 controller = Get.find();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var yarnItemList = <dynamic>[];
  var operatorItemList = <dynamic>[];

  late YarnItemDataSource yarnDataSource;
  late OperatorsItemDataSource operatorsItemDataSource;
  final DataGridController _operatorDataGridController = DataGridController();

  RxBool isUpdate = RxBool(false);
  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _firmNameFocusNode = FocusNode();
  final FocusNode _accountTypeFocusNode = FocusNode();
  final FocusNode _yarnNameFocusNode = FocusNode();
  final FocusNode _colorNameFocusNode = FocusNode();
  final FocusNode _machineFocusNode = FocusNode();
  final FocusNode _netQtyFocusNode = FocusNode();
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
    _initValue();
    super.initState();
    yarnDataSource = YarnItemDataSource(list: yarnItemList);
    operatorsItemDataSource = OperatorsItemDataSource(list: operatorItemList);
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_firstInputFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JariTwistingYarnInwardControllerV2>(
      builder: (controller) {
        return ShortCutWidget(
          scaffoldKey: _scaffoldKey,
          appBar: AppBar(
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'}  Jari Twisting - Yarn Inward"),
            actions: [
              Visibility(
                visible: idController.text.isNotEmpty,
                child: MyDeleteIconButton(
                  onPressed: (password) {
                    controller.delete(idController.text, password);
                  },
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          endDrawer: Container(
            color: Colors.white10.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Drawer(
                  width: 520,
                  child: JariTwistingYarnInwardBottomSheetV2(
                    dataGridSource: operatorsItemDataSource,
                    amountCalculation: amountCalculation,
                    itemDetails: operatorItemList,
                  ),
                ),
              ],
            ),
          ),
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.keyQ, control: true):
                GetBackIntent(),
            SingleActivator(LogicalKeyboardKey.keyS, control: true):
                SaveIntent(),
            SingleActivator(LogicalKeyboardKey.keyP, control: true):
                PrintIntent(),
            SingleActivator(LogicalKeyboardKey.keyC, alt: true):
                NavigateAnotherPageIntent(),
          },
          loadingStatus: controller.status.isLoading,
          child: Actions(
            actions: <Type, Action<Intent>>{
              GetBackIntent: SetCounterAction(perform: () => Get.back()),
              SaveIntent: SetCounterAction(perform: () => submit()),
              NavigateAnotherPageIntent: SetCounterAction(perform: () {
                // navigateAnotherPage();
              }),
            },
            child: FocusScope(
              autofocus: true,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: const Color(0xFFF9F3FF), width: 16),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
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
                              autofocus: false,
                              label: "Firm Name",
                              items: controller.firmDetails,
                              textController: firmNameTextController,
                              focusNode: _firmNameFocusNode,
                              requestFocus: _accountTypeFocusNode,
                              onChanged: (FirmModel item) {
                                firmNameController.value = item;
                              },
                            ),
                            MySearchField(
                              autofocus: false,
                              label: "Account Type",
                              items: controller.wagesAccountList,
                              textController: accountTypeTextController,
                              focusNode: _accountTypeFocusNode,
                              requestFocus: _firstInputFocusNode,
                              onChanged: (LedgerModel item) {
                                accountTypeController.value = item;
                              },
                            ),
                            MyDateFilter(
                              width: 160,
                              controller: dateController,
                              labelText: "Date",
                              focusNode: _firstInputFocusNode,
                              // readonly: true,
                            ),
                            MySearchField(
                              label: "Twisting Yarn Name",
                              enabled: !isUpdate.value,
                              items: controller.yarnDetails,
                              textController: yarnNameTextController,
                              focusNode: _yarnNameFocusNode,
                              requestFocus: _machineFocusNode,
                              onChanged: (JariTwistingModel item) async {
                                yarnNameController.value = item;
                                netQuantityController.text = '0.000';
                                yarnItemList.clear();
                                var result = await controller
                                    .yarnIdByConsumedYarn(item.yarnId);

                                for (var element in result) {
                                  var request = element.toJson();
                                  yarnItemList.add(request);
                                }
                                yarnDataSource.updateDataGridRows();
                                yarnDataSource.updateDataGridSource();
                              },
                            ),
                            MySearchField(
                              label: 'Color Name',
                              items: controller.colorDetails,
                              textController: colorNameTextController,
                              focusNode: _colorNameFocusNode,
                              requestFocus: _machineFocusNode,
                              enabled: !isUpdate.value,
                              onChanged: (NewColorModel item) {
                                colorNameController.value = item;
                                for (var i = 0; i < yarnItemList.length; i++) {
                                  yarnItemList[i]["color_id"] = item.id;
                                  yarnItemList[i]["color_name"] = item.name;
                                }
                                yarnDataSource.updateDataGridRows();
                                yarnDataSource.updateDataGridSource();
                              },
                            ),
                            MyDropdownButtonFormField(
                              controller: stockController,
                              hintText: "Stock in",
                              items: const ["Office", "Godown"],
                              enabled: !isUpdate.value,
                            ),
                            MySearchField(
                              label: "Machine Name",
                              enabled: !isUpdate.value,
                              items: controller.machineDetails,
                              textController: machineNameTextController,
                              focusNode: _machineFocusNode,
                              requestFocus: _netQtyFocusNode,
                              onChanged: (MachineDetailsModel item) {
                                machineNameController.value = item;
                                controller.wages.value =
                                    double.tryParse("${item.wages}") ?? 0.0;
                                controller.wagesType.value =
                                    "${item.wagesType}";
                                wagesRsController.text =
                                    item.wages!.toStringAsFixed(2);
                              },
                            ),
                            ExcludeFocusTraversal(
                              child: MyTextField(
                                width: 150,
                                controller: wagesRsController,
                                hintText: "Wages (Rs)",
                                validate: "double",
                                enabled: false,
                              ),
                            ),
                            MyTextField(
                              controller: boxNoController,
                              hintText: "Box No.",
                              enabled: !isUpdate.value,
                            ),
                            MyTextField(
                              width: 150,
                              controller: packController,
                              hintText: "Pack",
                            ),
                            Focus(
                                skipTraversal: true,
                                child: MyTextField(
                                  width: 150,
                                  enabled: !isUpdate.value,
                                  focusNode: _netQtyFocusNode,
                                  controller: netQuantityController,
                                  hintText: "Net Quantity",
                                  validate: "double",
                                  onChanged: (value) => _calculate(),
                                  suffix: const Text(
                                    "Kg",
                                    style: TextStyle(color: Color(0XFF5700BC)),
                                  ),
                                ),
                                onFocusChange: (hasFocus) {
                                  AppUtils.fractionDigitsText(
                                    netQuantityController,
                                    fractionDigits: 2,
                                  );
                                }),
                            MyTextField(
                              width: 150,
                              controller: totalAmountController,
                              hintText: "Total Amount",
                              enabled: false,
                            ),
                            ExcludeFocusTraversal(
                              child: MyTextField(
                                controller: detailsController,
                                hintText: "Details",
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Text(
                                        'Consumed Yarns',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  yarnItemsTable(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Operators',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    ),
                                    const Spacer(),
                                    MyAddItemsRemoveButton(
                                        onPressed: () => removeSelectedItems()),
                                    AddItemsElevatedButton(
                                      onPressed: () => _addItem(),
                                      child: const Text("Add Item"),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 12),
                                operatorsItemsTable(),
                              ],
                            ))
                          ],
                        ),
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
      },
    );
  }

  _calculate() {
    double netQuantity = double.tryParse(netQuantityController.text) ?? 0.0;

    for (var i = 0; i < yarnItemList.length; i++) {
      var consumedQuantity = netQuantity * yarnItemList[i]["usage"];
      yarnItemList[i]['quantity'] = consumedQuantity;
    }

    yarnDataSource.updateDataGridRows();
    yarnDataSource.updateDataGridSource();
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      if (yarnItemList.isEmpty) {
        return AppUtils.infoAlert(message: "Enter the item Details");
      }

      if (operatorItemList.isEmpty) {
        return AppUtils.infoAlert(message: "Select the operator name");
      }

      Map<String, dynamic> request = {
        "machine_id": machineNameController.value?.id,
        "machine_type": machineNameController.value?.machineType,
        "wages_type": machineNameController.value?.wagesType,
        "firm_id": firmNameController.value?.id,
        "e_date": dateController.text,
        "wages_ano": accountTypeController.value?.id,
        "details": detailsController.text,
        "yarn_id": yarnNameController.value?.yarnId,
        "color_id": colorNameController.value?.id,
        "stock_in": stockController.text,
        "box_no": boxNoController.text,
        "pck": int.tryParse(packController.text) ?? 0,
        "gross_quantity": double.tryParse(netQuantityController.text) ?? 0.0,
        "wages": double.tryParse(wagesRsController.text) ?? 0.0,
        "gross_amount": double.tryParse(totalAmountController.text) ?? 0.0,
      };

      var wagesType = machineNameController.value?.wagesType;
      var machineType = machineNameController.value?.machineType;

      if (machineType == "Winder") {
        request["winding_type"] = machineNameController.value?.windingType;
      } else if (machineType == "TFO") {
        request["deck_type"] = machineNameController.value?.deckType;
        request["spendile"] = machineNameController.value?.windingType;
      } else {
        request["deck_type"] = machineNameController.value?.deckType;
        request["spendile"] = machineNameController.value?.windingType;
      }

      if (wagesType == "Time") {
        request["hours"] = machineNameController.value?.hours;
      } else if (wagesType == "Kg") {
        request["weight"] = machineNameController.value?.weight;
      } else if (wagesType == "Lot") {
        request["lots"] = machineNameController.value?.lots;
      } else {
        request["meter"] = machineNameController.value?.meter;
      }

      request["twisting_inward_details"] = yarnItemList;
      request["operators_details"] = operatorItemList;

      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        controller.add(request);
      } else {
        request['id'] = id;
        controller.edit(request, id);
      }
    }
  }

  void _initValue() {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    var account = AppUtils.findLedgerAccountByName(
        controller.wagesAccountList, 'Twisting Wages');
    if (account != null) {
      accountTypeController.value = account;
      accountTypeTextController.text = account.ledgerName;
    }

    var firm = AppUtils.setDefaultFirmName(controller.firmDetails);
    if (firm != null) {
      firmNameController.value = firm;
      firmNameTextController.text = firm.firmName ?? "";
    }

    // AUTO SELECT THE FIRST ITEM OF COLOUR.
    if (controller.colorDetails.isNotEmpty) {
      colorNameController.value = controller.colorDetails.first;
      colorNameTextController.text = "${controller.colorDetails.first.name}";
    }

    if (controller.yarnDetails.isNotEmpty) {
      yarnNameTextController.text = controller.yarnName;
    }

    if (Get.arguments != null) {
      isUpdate.value = true;

      JariTwistingInwardV2Model item = Get.arguments["item"];
      idController.text = tryCast(item.id);
      dateController.text = item.eDate ?? '';
      detailsController.text = item.details ?? '';
      boxNoController.text = tryCast(item.boxNo);
      packController.text = tryCast(item.pck);
      netQuantityController.text = '${item.grossQuantity}';
      wagesRsController.text = tryCast(item.wages);
      totalAmountController.text = tryCast(item.grossAmount);

      // Firm Name
      var firmNameList = controller.firmDetails
          .where((element) => '${element.id}' == '${item.firmId}')
          .toList();
      if (firmNameList.isNotEmpty) {
        firmNameController.value = firmNameList.first;
        firmNameTextController.text = "${firmNameList.first.firmName}";
      }
      // // Yarn Name
      var yarnNameList = controller.yarnDetails
          .where((element) => '${element.yarnId}' == '${item.yarnId}')
          .toList();
      if (yarnNameList.isNotEmpty) {
        yarnNameController.value = yarnNameList.first;
        yarnNameTextController.text = '${yarnNameList.first.yarnName}';
      }

      var machineNameList = controller.machineDetails
          .where((element) => '${element.id}' == '${item.machineId}')
          .toList();
      if (machineNameList.isNotEmpty) {
        machineNameController.value = machineNameList.first;
        machineNameTextController.text = '${machineNameList.first.machineName}';
      }

      var wagesNameList = controller.wagesAccountList
          .where((element) => '${element.id}' == '${item.wagesAno}')
          .toList();
      if (wagesNameList.isNotEmpty) {
        accountTypeController.value = wagesNameList.first;
        accountTypeTextController.text = "${wagesNameList.first.ledgerName}";
      }

      var colorNameList = controller.colorDetails
          .where((element) => '${element.id}' == '${item.colorId}')
          .toList();
      if (colorNameList.isNotEmpty) {
        colorNameController.value = colorNameList.first;
        colorNameTextController.text = "${colorNameList.first.name}";
      }

      /// get created by and updated by details
      DateTime createDate = DateTime.parse(item.createdAt ?? "0000-00-00");
      DateTime updateDate = DateTime.parse(item.updatedAt ?? "0000-00-00");
      createdAt = AppUtils.dateFormatter.format(createDate);
      updatedAt = AppUtils.dateFormatter.format(updateDate);
      createdBy = item.createrName;
      updatedBy = item.updaterName;
      if (updatedBy != null) {
        displayName = "Edit : $updatedBy";
        displayDate = updatedAt;
      } else {
        displayName = "New : $createdBy";
        displayDate = createdAt;
      }

      item.twistingInwardDetails?.forEach((element) {
        var request = element.toJson();
        yarnItemList.add(request);
      });
      item.operatorsDetails?.forEach((element) {
        var request = element.toJson();
        operatorItemList.add(request);
      });
    }
  }

  _addItem() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  amountCalculation() {
    double totalAmount = 0.0;
    for (var e in operatorItemList) {
      totalAmount += e["wages"];
    }
    totalAmountController.text = totalAmount.toStringAsFixed(2);
  }

  void removeSelectedItems() {
    int? index = _operatorDataGridController.selectedIndex;
    if (index >= 0) {
      operatorItemList.removeAt(index);
      amountCalculation();
      operatorsItemDataSource.updateDataGridRows();
      operatorsItemDataSource.updateDataGridSource();
      _operatorDataGridController.selectedIndex = -1;
    } else {
      AppUtils.infoAlert(message: "Select The Value");
    }
  }

  Widget yarnItemsTable() {
    return MySFDataGridItemTable(
      scrollPhysics: const ScrollPhysics(),
      shrinkWrapRows: false,
      source: yarnDataSource,
      columns: [
        GridColumn(
          columnName: 'yarn_name',
          label: const MyDataGridHeader(title: 'Yarn Name'),
        ),
        GridColumn(
          columnName: 'color_name',
          label: const MyDataGridHeader(title: 'Color Name'),
        ),
        GridColumn(
          width: 120,
          columnName: 'quantity',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Quantity'),
        ),
        GridColumn(
          visible: false,
          columnName: 'usage',
          label: const MyDataGridHeader(title: 'Usage'),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'quantity',
              columnName: 'quantity',
              summaryType: GridSummaryType.sum,
            ),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
    );
  }

  Widget operatorsItemsTable() {
    return MySFDataGridItemTable(
      selectionMode: SelectionMode.single,
      scrollPhysics: const ScrollPhysics(),
      shrinkWrapRows: false,
      source: operatorsItemDataSource,
      controller: _operatorDataGridController,
      columns: [
        GridColumn(
          columnName: 'operator_name',
          label: const MyDataGridHeader(title: 'Operator Name'),
        ),
        GridColumn(
          columnName: 'particulars',
          label: const MyDataGridHeader(title: 'Particulars'),
        ),
        GridColumn(
          width: 100,
          columnName: 'wages',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Wages (Rs)'),
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
              name: 'wages',
              columnName: 'wages',
              summaryType: GridSummaryType.sum,
            ),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
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
}

class YarnItemDataSource extends DataGridSource {
  YarnItemDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e['yarn_name']),
        DataGridCell<dynamic>(columnName: 'color_name', value: e['color_name']),
        DataGridCell<dynamic>(columnName: 'quantity', value: e['quantity']),
        DataGridCell<dynamic>(columnName: 'usage', value: e['usage']),
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
        case 'quantity':
          return buildFormattedCell(value, decimalPlaces: 3);
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
      case 'quantity':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 3, alignment: alignment);
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

class OperatorsItemDataSource extends DataGridSource {
  OperatorsItemDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var particulars = "";

      if (e["hours"] != 0.0 && e["hours"] != null) {
        particulars = "Time: ${e["hours"]} Hours";
      } else if (e["weight"] != 0.0 && e["weight"] != null) {
        particulars = "${e["weight"]} Kg";
      } else if (e["lots"] != 0 && e["lots"] != null) {
        particulars = "${e["lots"]} Lots";
      } else {
        particulars = "${e["meter"]} Meter";
      }

      return DataGridRow(cells: [
        DataGridCell<dynamic>(
            columnName: 'operator_name', value: e['operator_name']),
        DataGridCell<dynamic>(columnName: 'particulars', value: particulars),
        DataGridCell<dynamic>(columnName: 'wages', value: e['wages']),
        DataGridCell<dynamic>(columnName: 'details', value: e['details']),
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
    final columnName = summaryColumn?.columnName;
    double parsedValue = double.tryParse(summaryValue) ?? 0;
    TextAlign alignment;

    switch (columnName) {
      case 'wages':
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
