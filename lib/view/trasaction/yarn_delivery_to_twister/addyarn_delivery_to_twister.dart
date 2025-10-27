import 'package:abtxt/view/trasaction/yarn_delivery_to_twister/yarn_delivery_to_twister_controller.dart';
import 'package:abtxt/view/trasaction/yarn_delivery_to_twister/yarndelivery_to_twister_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/FirmModel.dart';
import '../../../model/JariTwistingModel.dart';
import '../../../model/MachineDetailsModel.dart';
import '../../../model/YarnDeliveryToTwisterModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MySubmitButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/my_search_field/my_search_field.dart';

class AddyarnDeliveryToTwister extends StatefulWidget {
  const AddyarnDeliveryToTwister({super.key});

  static const String routeName = '/addyarn_deliverytotwister';

  @override
  State<AddyarnDeliveryToTwister> createState() => _State();
}

class _State extends State<AddyarnDeliveryToTwister> {
  TextEditingController idController = TextEditingController();
  TextEditingController firmNameTextController = TextEditingController();
  Rxn<FirmModel> firmNameController = Rxn<FirmModel>();
  TextEditingController entryDateController = TextEditingController();
  Rxn<JariTwistingModel> yarnNameController = Rxn<JariTwistingModel>();
  TextEditingController yarnNameTextController = TextEditingController();
  Rxn<MachineDetailsModel> machineNameController = Rxn<MachineDetailsModel>();
  TextEditingController machineNameTextController = TextEditingController();
  TextEditingController wagesController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController emptyTypeController =
      TextEditingController(text: "Nothing");
  TextEditingController totalQuantityController = TextEditingController();
  TextEditingController machineTypeController = TextEditingController();

  // winder
  TextEditingController windingTypeController = TextEditingController();

  // tfo
  TextEditingController tfoDeckTypeController = TextEditingController();
  TextEditingController tfoSpendileController = TextEditingController();

  // Jari
  TextEditingController jariDeckType1Controller = TextEditingController();
  TextEditingController jariSpendile1Controller = TextEditingController();
  TextEditingController hourController = TextEditingController();
  TextEditingController kgController = TextEditingController();
  TextEditingController lotController = TextEditingController();
  TextEditingController meterController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  YarnDeliveryToTwisterController controller = Get.find();

  late MyDataSource dataSource;

  final FocusNode _firmNameFocusNode = FocusNode();
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _yarnNameFocusNode = FocusNode();
  final FocusNode _machineFocusNode = FocusNode();
  final FocusNode _detailsFocusNode = FocusNode();

  final RxString _selectedMachineType = RxString("");
  final RxString _selectedWagesType = RxString("");

  RxBool isUpdate = RxBool(false);
  final DataGridController _dataGridController = DataGridController();

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
    super.initState();
    dataSource = MyDataSource(list: controller.itemList);
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_dateFocusNode);
      });
    }

    _initValue();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnDeliveryToTwisterController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Yarn Delivery to Twister"),
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
          },
          child: FocusScope(
            autofocus: true,
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
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
                          items: controller.firmDropdown,
                          textController: firmNameTextController,
                          focusNode: _firmNameFocusNode,
                          requestFocus: _dateFocusNode,
                          onChanged: (FirmModel item) {
                            firmNameController.value = item;
                          },
                        ),
                        MyDateFilter(
                          focusNode: _dateFocusNode,
                          controller: entryDateController,
                          labelText: "Date",
                        ),
                        MySearchField(
                          label: "Twisting Yarn Name",
                          enabled: !isUpdate.value,
                          items: controller.inwardYarnDetails,
                          textController: yarnNameTextController,
                          focusNode: _yarnNameFocusNode,
                          requestFocus: _machineFocusNode,
                          onChanged: (JariTwistingModel item) async {
                            yarnNameController.value = item;
                          },
                        ),
                        MySearchField(
                          label: "Machine Name",
                          enabled: !isUpdate.value,
                          items: controller.machineDetails,
                          textController: machineNameTextController,
                          focusNode: _machineFocusNode,
                          requestFocus: _detailsFocusNode,
                          onChanged: (MachineDetailsModel item) {
                            machineNameController.value = item;

                            machineDetails(item);
                          },
                        ),
                        MyTextField(
                          controller: machineTypeController,
                          hintText: "Machine Type",
                          enabled: false,
                        ),
                        Obx(() => selectedMachine(_selectedMachineType.value)),
                        Obx(() => wagesTypeWidget(_selectedWagesType.value)),
                        MyTextField(
                          controller: wagesController,
                          hintText: "Wages(Rs)",
                          enabled: false,
                        ),
                        MyTextField(
                          focusNode: _detailsFocusNode,
                          controller: detailsController,
                          hintText: "Details",
                        ),
                        ExcludeFocusTraversal(
                          child: MyDropdownButtonFormField(
                            controller: emptyTypeController,
                            hintText: "Empty Type",
                            items: const ["Beam", "Bobbin", "Nothing"],
                          ),
                        ),
                        MyTextField(
                          enabled: false,
                          controller: totalQuantityController,
                          hintText: "Total Quantity",
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyAddItemsRemoveButton(
                          onPressed: () => removeSelectedItems(),
                        ),
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
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Spacer(),
                        SizedBox(
                          child: MySubmitButton(
                            onPressed:
                                controller.status.isLoading ? null : submit,
                          ),
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

  Widget itemsTable() {
    return Flexible(
      child: ExcludeFocusTraversal(
        child: MySFDataGridItemTable(
          controller: _dataGridController,
          shrinkWrapRows: false,
          scrollPhysics: const ScrollPhysics(),
          selectionMode: SelectionMode.single,
          source: dataSource,
          columns: [
            GridColumn(
              visible: false,
              columnName: 'id',
              label: const MyDataGridHeader(title: 'Yarn Name'),
            ),
            GridColumn(
              columnName: 'yarn_name',
              label: const MyDataGridHeader(title: 'Yarn Name'),
            ),
            GridColumn(
              columnName: 'color_name',
              label: const MyDataGridHeader(title: 'Color Name'),
            ),
            GridColumn(
              columnName: 'delivery_form',
              label: const MyDataGridHeader(title: 'Delivery From'),
            ),
            GridColumn(
              columnName: 'bag_box',
              label: const MyDataGridHeader(title: 'Bag/Box No'),
            ),
            GridColumn(
              width: 150,
              columnName: 'pack',
              label: const MyDataGridHeader(title: 'Pack'),
            ),
            GridColumn(
              width: 150,
              columnName: 'net_qty',
              label: const MyDataGridHeader(title: 'Net.Qty'),
            ),
          ],
          tableSummaryRows: [
            GridTableSummaryRow(
              showSummaryInRow: false,
              title: "",
              titleColumnSpan: 1,
              columns: [
                const GridSummaryColumn(
                  name: 'net_qty',
                  columnName: 'net_qty',
                  summaryType: GridSummaryType.sum,
                ),
              ],
              position: GridTableSummaryRowPosition.bottom,
            ),
          ],
          onRowSelected: (index) async {},
        ),
      ),
    );
  }

  Widget selectedMachine(String machineType) {
    if (machineType == "Winder") {
      return Wrap(
        children: [
          MyTextField(
            controller: windingTypeController,
            hintText: "Winding Type",
            enabled: false,
          ),
        ],
      );
    } else if (machineType == "TFO") {
      return Wrap(
        children: [
          MyTextField(
            controller: tfoDeckTypeController,
            hintText: "Deck Type",
            enabled: false,
          ),
          MyTextField(
            controller: tfoSpendileController,
            hintText: "SPENDILE",
            enabled: false,
          ),
        ],
      );
    } else if (machineType == "Jari") {
      return Wrap(
        children: [
          MyTextField(
            controller: jariDeckType1Controller,
            hintText: "Deck Type",
            enabled: false,
          ),
          MyTextField(
            controller: jariSpendile1Controller,
            hintText: "SPENDILE",
            enabled: false,
          ),
        ],
      );
    } else {
      return const Wrap(
        children: [],
      );
    }
  }

  Widget wagesTypeWidget(String wagesType) {
    if (wagesType == "Time") {
      return Wrap(
        children: [
          MyTextField(
            controller: hourController,
            hintText: "Time",
            enabled: false,
          ),
        ],
      );
    } else if (wagesType == "Kg") {
      return Wrap(
        children: [
          MyTextField(
            controller: kgController,
            hintText: "Weight",
            enabled: false,
          ),
        ],
      );
    } else if (wagesType == "Lot") {
      return Wrap(
        children: [
          MyTextField(
            controller: lotController,
            hintText: "Lot",
            enabled: false,
          ),
        ],
      );
    } else if (wagesType == "Meter") {
      return Wrap(
        children: [
          MyTextField(
            controller: meterController,
            hintText: "Meter",
            enabled: false,
          ),
        ],
      );
    } else {
      return const Wrap();
    }
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      String? wagesType = machineNameController.value?.wagesType;
      String machineType = machineTypeController.text;

      Map<String, dynamic> request = {
        "firm_id": firmNameController.value?.id,
        "e_date": entryDateController.text,
        "yarn_id": yarnNameController.value?.yarnId,
        "machine_id": machineNameController.value?.id,
        "machine_type": machineTypeController.text,
        "wages": double.tryParse(wagesController.text) ?? 0.0,
        "details": detailsController.text,
        "empty_type": emptyTypeController.text,
        "gross_quantity": double.tryParse(totalQuantityController.text) ?? 0.0,
        "wages_type": machineNameController.value?.wagesType,
        "entry": 123.00,
      };

      // wages type to change
      if (wagesType == "Kg") {
        request["weight"] = double.tryParse(kgController.text) ?? 0.0;
      } else if (wagesType == "Lot") {
        request["lots"] = int.tryParse(lotController.text) ?? 0;
      } else if (wagesType == "Meter") {
        request["meter"] = double.tryParse(meterController.text) ?? 0.0;
      } else {
        request["hours"] = double.tryParse(hourController.text) ?? 0.0;
      }

      // machine type to change
      if (machineType == "Winder") {
        request["winding_type"] = windingTypeController.text;
      } else if (machineType == "TFO") {
        request["deck_type"] = tfoDeckTypeController.text;
        request["spendile"] = tfoSpendileController.text;
      } else {
        request["deck_type"] = jariDeckType1Controller.text;
        request["spendile"] = jariSpendile1Controller.text;
      }
      request["twisting_delivery_details"] = controller.itemList;

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
    entryDateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    var firm = AppUtils.setDefaultFirmName(controller.firmDropdown);
    if (firm != null) {
      firmNameController.value = firm;
      firmNameTextController.text = firm.firmName ?? "";
    }
    if (Get.arguments != null) {
      var item = YarnDeliveryToTwisterModel.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      isUpdate.value = true;

      // firm
      var firmNameList = controller.firmDropdown
          .where((element) => '${element.id}' == '${item.firmId}')
          .toList();
      if (firmNameList.isNotEmpty) {
        firmNameController.value = firmNameList.first;
        firmNameTextController.text = "${firmNameList.first.firmName}";
      }
      var yarnNameList = controller.inwardYarnDetails
          .where((element) => '${element.yarnId}' == '${item.yarnId}')
          .toList();
      if (firmNameList.isNotEmpty) {
        yarnNameController.value = yarnNameList.first;
        yarnNameTextController.text = "${yarnNameList.first.yarnName}";
      }
      var machineList = controller.machineDetails
          .where((element) => '${element.id}' == '${item.machineId}')
          .toList();
      if (firmNameList.isNotEmpty) {
        machineNameController.value = machineList.first;
        machineNameTextController.text = "${machineList.first.machineName}";
      }

      entryDateController.text = item.eDate ?? '';
      wagesController.text = '${item.wages}';
      detailsController.text = item.details ?? '';
      emptyTypeController.text = item.emptyType ?? '';
      totalQuantityController.text = '${item.grossQuantity}';

      _selectedWagesType.value = "${item.wagesType}";
      _selectedMachineType.value = "${item.machineType}";
      String wagesType = "${item.wagesType}";
      String machineType = "${item.machineType}";

      machineTypeController.text = machineType;

      // wages type to change
      if (wagesType == "Kg") {
        kgController.text = "${item.weight}";
      } else if (wagesType == "Lot") {
        lotController.text = "${item.lots}";
      } else if (wagesType == "Meter") {
        meterController.text = "${item.meter}";
      } else {
        hourController.text = "${item.hours}";
      }

      // machine type to change
      if (machineType == "Winder") {
        windingTypeController.text = "${item.windingType}";
      } else if (machineType == "TFO") {
        tfoDeckTypeController.text = "${item.deckType}";
        tfoSpendileController.text = "${item.spendile}";
      } else {
        jariDeckType1Controller.text = "${item.deckType}";
        jariSpendile1Controller.text = "${item.spendile}";
      }

      item.twistingDeliveryDetails?.forEach((element) {
        var request = element.toJson();
        controller.itemList.add(request);
      });
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    }
  }

  void removeSelectedItems() {
    int? index = _dataGridController.selectedIndex;
    if (index >= 0) {
      controller.itemList.removeAt(index);
      qtyCalculation();
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
      _dataGridController.selectedIndex = -1;
    } else {
      AppUtils.infoAlert(message: "Select The Value");
    }
  }

  void _addItem() async {
    var result = await Get.to(() => const YarndeliveryToTwisterBottomsheet());
    if (result != null) {
      controller.itemList.add(result);
      qtyCalculation();
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    }
  }

  qtyCalculation() {
    double totalQty = 0.0;
    for (var e in controller.itemList) {
      totalQty += e["quantity"];
    }
    totalQuantityController.text = totalQty.toStringAsFixed(3);
  }

  void machineDetails(MachineDetailsModel data) {
    var wagesType = data.wagesType;
    var machineType = data.machineType;
    _selectedWagesType.value = "$wagesType";
    _selectedMachineType.value = "$machineType";
    machineTypeController.text = "${data.machineType}";
    wagesController.text = data.wages!.toStringAsFixed(2);

    // wages type to change
    if (wagesType == "Kg") {
      kgController.text = "${data.weight}";
    } else if (wagesType == "Lot") {
      lotController.text = "${data.lots}";
    } else if (wagesType == "Meter") {
      meterController.text = "${data.meter}";
    } else {
      hourController.text = "${data.hours}";
    }

    // machine type to change
    if (machineType == "Winder") {
      windingTypeController.text = "${data.windingType}";
    } else if (machineType == "TFO") {
      tfoDeckTypeController.text = "${data.deckType}";
      tfoSpendileController.text = "${data.spendile}";
    } else {
      jariDeckType1Controller.text = "${data.deckType}";
      jariSpendile1Controller.text = "${data.spendile}";
    }
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'id', value: e["id"]),
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e["yarn_name"]),
        DataGridCell<dynamic>(columnName: 'color_name', value: e["color_name"]),
        DataGridCell<dynamic>(
            columnName: 'delivery_form', value: e["stock_in"]),
        DataGridCell<dynamic>(columnName: 'bag_box', value: e["bag_box_no"]),
        DataGridCell<dynamic>(columnName: 'pack', value: e["pack"]),
        DataGridCell<dynamic>(columnName: 'net_qty', value: e["quantity"]),
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
        case 'net_qty':
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
      case 'net_qty':
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
