import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/yarn_return_from_warper/yarn_return_from_warper_bottom_sheet.dart';
import 'package:abtxt/view/trasaction/yarn_return_from_warper/yarn_return_from_warper_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
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
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../basics/ledger/addledger.dart';

class AddYarnReturnFromWarper extends StatefulWidget {
  const AddYarnReturnFromWarper({super.key});

  static const String routeName = '/AddYarnReturnFromWarper';

  @override
  State<AddYarnReturnFromWarper> createState() => _State();
}

class _State extends State<AddYarnReturnFromWarper> {
  TextEditingController idController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  TextEditingController firmController = TextEditingController();
  Rxn<LedgerModel> warperName = Rxn<LedgerModel>();
  TextEditingController warperController = TextEditingController();
  TextEditingController returnDateController = TextEditingController();
  TextEditingController refNoController = TextEditingController();
  TextEditingController entryController =
      TextEditingController(text: "Delivery");
  TextEditingController emptyTypeController =
      TextEditingController(text: "Beam");
  TextEditingController quantityController = TextEditingController(text: '0');
  TextEditingController detailsController = TextEditingController();

  TextEditingController totalPackController = TextEditingController();
  TextEditingController totalNetQytController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final YarnReturnFromWarperController controller = Get.find();
  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _warperNameFocusNode = FocusNode();
  var shortCut = RxString("");

  /// created by and updated by details controllers
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? displayName;
  String? displayDate;

  late ItemDataSource dataSource;
  RxBool isUpdate = RxBool(false);

  final DataGridController _dataGridController = DataGridController();

  @override
  void initState() {
    controller.itemList.clear();
    _warperNameFocusNode.addListener(() => shortCutKeys());
    _initValue();
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
    return GetBuilder<YarnReturnFromWarperController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Yarn Return From Warper"),
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
              visible: idController.text.isNotEmpty,
              child: MyPrintButton(
                onPressed: () => _print(),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        loadingStatus: controller.status.isLoading,
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
            child: Container(
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
                          items: controller.firmDropdown,
                          // isValidate: false,
                          selectedItem: firmName.value,
                          enabled: !isUpdate.value,
                          onChanged: (FirmModel item) {
                            firmName.value = item;
                            //  _firmNameFocusNode.requestFocus();
                          },
                          autofocus: false,
                        ),
                        Focus(
                          focusNode: _warperNameFocusNode,
                          skipTraversal: true,
                          child: MyAutoComplete(
                            label: 'Warper Name',
                            items: controller.Warper,
                            selectedItem: warperName.value,
                            enabled: !isUpdate.value,
                            onChanged: (LedgerModel item) {
                              warperName.value = item;
                              controller.warperId = item.id;
                              controller.warperYarnStockBalance(item.id);
                            },
                          ),
                        ),
                        MyTextField(
                          controller: refNoController,
                          hintText: "Ref.No",
                          focusNode: _firstInputFocusNode,
                        ),
                        MyDateFilter(
                          controller: returnDateController,
                          labelText: 'Date',
                        ),
                        ExcludeFocusTraversal(
                          child: MyTextField(
                            controller: detailsController,
                            hintText: "Details",
                          ),
                        ),
                        ExcludeFocusTraversal(
                          child: MyDropdownButtonFormField(
                              controller: emptyTypeController,
                              hintText: "Empty Type",
                              items: const ["Beam", "Bobbin"]),
                        ),
                        ExcludeFocusTraversal(
                          child: MyDropdownButtonFormField(
                              controller: entryController,
                              hintText: "Entry",
                              items: const ["Delivery", "Return"]),
                        ),
                        ExcludeFocusTraversal(
                          child: MyTextField(
                            controller: quantityController,
                            hintText: "Quantity",
                            validate: "number",
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
                          onPressed: () => _addItem(),
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
      );
    });
  }

  Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }

    var request = {'id': idController.text};
    String? response =
        await controller.yarnReturnFromWarperPdf(request: request);

    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }

  shortCutKeys() {
    if (_warperNameFocusNode.hasFocus && Get.arguments == null) {
      shortCut.value = "To Create 'Warper',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  navigateAnotherPage() async {
    if (_warperNameFocusNode.hasFocus && Get.arguments == null) {
      var result = await Get.toNamed(AddLedger.routeName);

      if (result == "success") {
        controller.warperInfo();
      }
    }
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "firm_id": firmName.value?.id,
        "warper_id": warperName.value?.id,
        "ref_no": refNoController.text,
        "e_date": returnDateController.text,
        "details": detailsController.text,
        "empty_type": emptyTypeController.text,
        "ee_typ": entryController.text,
        "empty_qty": double.tryParse(quantityController.text) ?? 0.0,
      };

      request["item_details"] = controller.itemList;

      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        controller.add(request);
      } else {
        request['id'] = id;
        controller.edit(request);
      }
    }
  }

  void _initValue() {
    returnDateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    firmName.value = AppUtils.setDefaultFirmName(controller.firmDropdown);

    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = Get.arguments['item'];
      idController.text = tryCast(item['id']);
      refNoController.text = tryCast(item['ref_no']);
      returnDateController.text = tryCast(item['e_date']);
      detailsController.text = tryCast(item['details']);
      emptyTypeController.text = tryCast(item['empty_type']);
      entryController.text = tryCast(item['ee_typ']);
      quantityController.text = tryCast(item['empty_qty']);

      // Firm Name
      var firmNameList = controller.firmDropdown
          .where((element) => '${element.id}' == '${item['firm_id']}')
          .toList();
      if (firmNameList.isNotEmpty) {
        firmName.value = firmNameList.first;
        controller.request['firm_id'] = firmNameList.first.id;
        firmController.text = '${firmNameList.first.firmName}';
      }

      // Warper Name
      var warperNameList = controller.Warper.where(
          (element) => '${element.id}' == '${item['warper_id']}').toList();
      if (warperNameList.isNotEmpty) {
        warperName.value = warperNameList.first;
        controller.warperId = warperName.value?.id;
        controller.request['warper_id'] = warperNameList.first.id;
        warperController.text = '${warperNameList.first.ledgerName}';
      }

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        controller.warperYarnStockBalance(warperName.value?.id);
      });

      /// get created by and updated by details
      DateTime createDate = DateTime.parse(item["created_at"] ?? "0000-00-00");
      DateTime updateDate = DateTime.parse(item["updated_at"] ?? "0000-00-00");
      createdAt = AppUtils.dateFormatter.format(createDate);
      updatedAt = AppUtils.dateFormatter.format(updateDate);
      createdBy = item["creator_name"];
      updatedBy = item["updated_name"];
      if (updatedBy != null) {
        displayName = "Edit : $updatedBy";
        displayDate = updatedAt;
      } else {
        displayName = "New : $createdBy";
        displayDate = createdAt;
      }

      item['item_details'].forEach((element) {
        var request = element;
        controller.itemList.add(request);
      });
    }
  }

  Widget itemsTable() {
    return Flexible(
      child: MySFDataGridItemTable(
        selectionMode: SelectionMode.single,
        controller: _dataGridController,
        shrinkWrapRows: false,
        scrollPhysics: const ScrollPhysics(),
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
            label: const MyDataGridHeader(title: 'Stock to'),
          ),
          GridColumn(
            columnName: 'box_no',
            label: const MyDataGridHeader(title: 'Bag / Box No'),
          ),
          GridColumn(
            width: 120,
            columnName: 'pck',
            label: const MyDataGridHeader(title: 'Pack'),
          ),
          GridColumn(
            width: 120,
            columnName: 'quantity',
            label: const MyDataGridHeader(title: 'Net Quantity'),
          ),
          GridColumn(
            columnName: 'cr_no',
            label: const MyDataGridHeader(title: 'Cops/Reel \n Name'),
          ),
        ],
        tableSummaryRows: [
          GridTableSummaryRow(
            showSummaryInRow: false,
            title: 'Total: ',
            titleColumnSpan: 1,
            columns: [
              const GridSummaryColumn(
                name: 'pck',
                columnName: 'pck',
                summaryType: GridSummaryType.sum,
              ),
              const GridSummaryColumn(
                name: 'quantity',
                columnName: 'quantity',
                summaryType: GridSummaryType.sum,
              ),
            ],
            position: GridTableSummaryRowPosition.bottom,
          ),
        ],
        source: dataSource,
        onRowSelected: (index) async {
          var item = controller.itemList[index];
          var result = await Get.to(
              () => const YarnReturnFromWarperBottomSheet(),
              arguments: {'item': item});
          if (result != null) {
            controller.itemList[index] = result;
            dataSource.updateDataGridRows();
            dataSource.updateDataGridSource();
          }
        },
      ),
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
    if (controller.warperId == null) {
      return;
    }

    var result = await Get.to(() => const YarnReturnFromWarperBottomSheet());
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
        DataGridCell<dynamic>(columnName: 'pck', value: e['pck']),
        DataGridCell<dynamic>(columnName: 'quantity', value: e['quantity']),
        DataGridCell<dynamic>(
            columnName: 'cr_no',
            value: '${e['cr_no']} ' == '0' ? "Nothing" : "Nothing"),
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
        case 'pck':
          return buildFormattedCell(value, decimalPlaces: 0);
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
      case 'pck':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'quantity':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 3, alignment: alignment);
      default:
        /*  alignment = TextAlign.right;
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
