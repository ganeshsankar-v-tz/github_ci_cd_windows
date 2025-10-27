import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/YarnDeliverytoWinderModel.dart';
import 'package:abtxt/view/trasaction/yarn_delivery_to_winder/yarn_delivery_to_winder_bottomsheet.dart';
import 'package:abtxt/view/trasaction/yarn_delivery_to_winder/yarn_delivery_to_winder_controller.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_utils.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MySubmitButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../basics/ledger/addledger.dart';

class AddDeliveryWinder extends StatefulWidget {
  const AddDeliveryWinder({super.key});

  static const String routeName = '/add_yarn_delivery_to_winder';

  @override
  State<AddDeliveryWinder> createState() => _State();
}

class _State extends State<AddDeliveryWinder> {
  TextEditingController idController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  TextEditingController firmNameController = TextEditingController();
  Rxn<LedgerModel> winder = Rxn<LedgerModel>();
  TextEditingController winderNameController = TextEditingController();
  TextEditingController dCNoController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  Rxn<LedgerModel> accountType = Rxn<LedgerModel>();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController paymentStatusController =
      TextEditingController(text: "Pending");

  final _formKey = GlobalKey<FormState>();
  YarnDeliveryToWinderController controller = Get.find();

  late ItemDataSource dataSource;
  RxBool isUpdate = RxBool(false);

  final DataGridController _dataGridController = DataGridController();
  final FocusNode _accountTypeFocusNode = FocusNode();
  final FocusNode _winderNameFocusNode = FocusNode();
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
    _accountTypeFocusNode.addListener(() => shortCutKeys());
    _winderNameFocusNode.addListener(() => shortCutKeys());
    controller.itemList.clear();
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: controller.itemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnDeliveryToWinderController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Yarn Delivery To Winder"),
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
              visible: dCNoController.text.isNotEmpty,
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
            PrintIntent: SetCounterAction(perform: () {
              _print();
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
                border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
              ),
              child: Form(
                key: _formKey,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyAutoComplete(
                                label: 'Firm',
                                items: controller.firmDropdown,
                                selectedItem: firmName.value,
                                enabled: !isUpdate.value,
                                onChanged: (FirmModel item) {
                                  firmName.value = item;
                                },
                                autofocus: false,
                              ),
                              Focus(
                                focusNode: _accountTypeFocusNode,
                                skipTraversal: true,
                                child: MyAutoComplete(
                                  label: 'Account Type',
                                  items: controller.purchaseAccountDropdown,
                                  selectedItem: accountType.value,
                                  onChanged: (LedgerModel item) {
                                    accountType.value = item;
                                  },
                                  autofocus: false,
                                ),
                              ),
                              Focus(
                                focusNode: _winderNameFocusNode,
                                skipTraversal: true,
                                child: MyAutoComplete(
                                  label: 'Winder Name',
                                  items: controller.ledgerDropdown,
                                  selectedItem: winder.value,
                                  enabled: !isUpdate.value,
                                  onChanged: (LedgerModel item) {
                                    winder.value = item;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: dCNoController.text.isNotEmpty,
                            child: MyTextField(
                              controller: dCNoController,
                              hintText: "D.C No",
                              readonly: true,
                              enabled: !isUpdate.value,
                            ),
                          ),
                          MyDateFilter(
                            controller: dateController,
                            labelText: "Entry Date",
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
                      Flexible(child: itemsTable()),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: MyDropdownButtonFormField(
                          enabled: paymentStatusController.text != "Paid",
                          controller: paymentStatusController,
                          hintText: "Payment Status",
                          items: const ["Pending", "Paid"],
                        ),
                      ),
                      const SizedBox(height: 32),
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

  Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }

    var request = {'id': idController.text};
    String? response =
        await controller.yarnDelierytoWinderPdf(request: request);
    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }

  shortCutKeys() {
    if (_accountTypeFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Account',Press Alt+C ";
    } else if (_winderNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Winder',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_accountTypeFocusNode.hasFocus) {
      var result = await Get.toNamed(AddLedger.routeName);

      if (result == "success") {
        controller.purchaseAccount();
      }
    } else if (_winderNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddLedger.routeName);

      if (result == "success") {
        controller.ledgerInfo();
      }
    }
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "firm_id": firmName.value?.id,
        "winder_id": winder.value?.id,
        "wages_ano": accountType.value?.id,
        "e_date": dateController.text,
        "details": detailsController.text,
        "wages_status": paymentStatusController.text,
      };
      var winderItem = [];

      for (var i = 0; i < controller.itemList.length; i++) {
        var item = {
          "yarn_id": controller.itemList[i]['yarn_id'],
          "color_id": controller.itemList[i]['color_id'],
          "stock_in": controller.itemList[i]['stock_in'],
          "box_no": controller.itemList[i]['box_no'],
          "pack": controller.itemList[i]['pack'],
          "quantity": controller.itemList[i]['quantity'],
          "less_quanitty": controller.itemList[i]['less_quanitty'],
          "gross_quantity": controller.itemList[i]['gross_quantity'],
          "calculate_type": controller.itemList[i]['calculate_type'],
          "wages": controller.itemList[i]['wages'],
          "amount": controller.itemList[i]['amount'],
          "exp_yarn_id": controller.itemList[i]['exp_yarn_id'],
          "exp_quantity": controller.itemList[i]['exp_quantity'],
        };

        winderItem.add(item);
      }
      request['winder_item'] = winderItem;
      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        controller.add(request);
      } else {
        request['id'] = id;
        request['dc_no'] = int.tryParse(dCNoController.text);
        controller.edit(request);
      }
    }
  }

  void _initValue() {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    YarnDeliveryToWinderController controller = Get.find();
    controller.request = <String, dynamic>{};
    accountType.value = AppUtils.findLedgerAccountByName(
        controller.purchaseAccountDropdown, 'Cone Winding Wages');
    firmName.value = AppUtils.setDefaultFirmName(controller.firmDropdown);
    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = YarnDeliveryToWinderModel.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      dCNoController.text = '${item.dcNo}';
      dateController.text = '${item.eDate}';
      detailsController.text = item.details ?? '';
      paymentStatusController.text = "${item.wagesStatus}";

      var firmList = controller.firmDropdown
          .where((element) => '${element.id}' == '${item.firmId}')
          .toList();
      if (firmList.isNotEmpty) {
        controller.request['firm_id'] = firmList.first.id;
        firmName.value = firmList.first;
        firmNameController.text = '${firmList.first.firmName}';
      }
      var winderList = controller.ledgerDropdown
          .where((element) => '${element.id}' == '${item.winderId}')
          .toList();
      if (winderList.isNotEmpty) {
        controller.request['winder_id'] = winderList.first.id;
        winder.value = winderList.first;
        winderNameController.text = '${winderList.first.ledgerName}';
      }

      var accountTypeList = controller.purchaseAccountDropdown
          .where((element) => '${item.wagesAno}' == '${element.id}')
          .toList();
      if (accountTypeList.isNotEmpty) {
        accountType.value = accountTypeList.first;
        accountTypeController.text = '${accountTypeList.first.ledgerName}';
        //controller.request['account_type_id'] = accountTypeList.first.id;
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
        var request = element.toJson();
        controller.itemList.add(request);
      });
    }
  }

  Widget itemsTable() {
    return MySFDataGridItemTable(
      shrinkWrapRows: false,
      scrollPhysics: const ScrollPhysics(),
      controller: _dataGridController,
      selectionMode: SelectionMode.single,
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
          columnName: 'stock_in',
          label: const MyDataGridHeader(title: 'Delivery from'),
        ),
        GridColumn(
          columnName: 'box_no',
          label: const MyDataGridHeader(title: 'Bag / Box No'),
        ),
        GridColumn(
          width: 80,
          columnName: 'pack',
          label: const MyDataGridHeader(title: 'Pack'),
        ),
        GridColumn(
          width: 120,
          columnName: 'gross_quantity',
          label: const MyDataGridHeader(title: 'Net. Qty'),
        ),
        GridColumn(
          columnName: 'calculate_type',
          label: const MyDataGridHeader(title: 'Cal. Type'),
        ),
        GridColumn(
          width: 120,
          columnName: 'wages',
          label: const MyDataGridHeader(title: 'Wages (Rs)'),
        ),
        GridColumn(
          width: 120,
          columnName: 'amount',
          label: const MyDataGridHeader(title: 'Amount (Rs)'),
        ),
        GridColumn(
          columnName: 'exp_yarn_name',
          label: const MyDataGridHeader(title: 'Exp Yarn Name'),
        ),
        GridColumn(
          width: 100,
          columnName: 'exp_quantity',
          label: const MyDataGridHeader(title: 'Exp Qty'),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'pack',
              columnName: 'pack',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'gross_quantity',
              columnName: 'gross_quantity',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'amount',
              columnName: 'amount',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'exp_quantity',
              columnName: 'exp_quantity',
              summaryType: GridSummaryType.sum,
            ),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSource,
      onRowSelected: (index) async {
        var item = controller.itemList[index];
        var result = await Get.to(const YarnDeliveryToWinderBottomSheet(),
            arguments: {'item': item});
        if (result != null) {
          controller.itemList[index] = result;
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        }
      },
    );
  }

  void removeSelectedItems() async {
    int? index = _dataGridController.selectedIndex;
    var item = controller.itemList[index];

    if (index >= 0) {
      if (item["sync"] == 0) {
        _removeItem(index);
        return;
      }

      var result = await controller.rowRemoveCheck(
          item["id"],
          item["yarn_delivery_to_winder_id"],
          item["yarn_id"],
          item["exp_yarn_id"]);

      if (result == "Sucess") {
        _removeItem(index);
      }
    } else {
      AppUtils.infoAlert(message: "Select The Value");
    }
  }

  void _removeItem(int index) {
    controller.itemList.removeAt(index);
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
    _dataGridController.selectedIndex = -1;
  }

  void _addItem() async {
    if (controller.itemList.isNotEmpty) {
      controller.yarnName = controller.itemList.last["yarn_name"];
    } else {
      controller.yarnName = "";
    }

    var result = await Get.to(const YarnDeliveryToWinderBottomSheet());
    if (result != null) {
      controller.itemList.add(result);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
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
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e['yarn_name']),
        DataGridCell<dynamic>(columnName: 'color_name', value: e['color_name']),
        DataGridCell<dynamic>(columnName: 'stock_in', value: e['stock_in']),
        DataGridCell<dynamic>(columnName: 'box_no', value: e['box_no']),
        DataGridCell<dynamic>(columnName: 'pack', value: e['pack']),
        DataGridCell<dynamic>(
            columnName: 'gross_quantity', value: e['gross_quantity']),
        DataGridCell<dynamic>(
            columnName: 'calculate_type', value: e['calculate_type']),
        DataGridCell<dynamic>(columnName: 'wages', value: e['wages']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['amount']),
        DataGridCell<dynamic>(
            columnName: 'exp_yarn_name', value: e['exp_yarn_name']),
        DataGridCell<dynamic>(
            columnName: 'exp_quantity', value: e['exp_quantity']),
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
        case 'amount':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'wages':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'exp_quantity':
          return buildFormattedCell(value, decimalPlaces: 3);
        case 'gross_quantity':
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
      case 'amount':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      case 'gross_quantity':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 3, alignment: alignment);
      case 'exp_quantity':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 3, alignment: alignment);
      case 'pack':
        alignment = TextAlign.left;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
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
