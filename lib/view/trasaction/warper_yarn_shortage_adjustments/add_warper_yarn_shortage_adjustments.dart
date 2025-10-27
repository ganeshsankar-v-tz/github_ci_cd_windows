import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/warper_yarn_shortage_adjustments/warper_yarn_shortage_adjustments_bottomsheet.dart';
import 'package:abtxt/view/trasaction/warper_yarn_shortage_adjustments/warper_yarn_shortage_adjustments_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../basics/ledger/addledger.dart';

class AddWarperYarnShortageAdjustments extends StatefulWidget {
  const AddWarperYarnShortageAdjustments({super.key});

  static const String routeName = '/AddWarperYarnShortageAdjustments';

  @override
  State<AddWarperYarnShortageAdjustments> createState() => _State();
}

class _State extends State<AddWarperYarnShortageAdjustments> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> warperName = Rxn<LedgerModel>();
  TextEditingController warperNameController = TextEditingController();

  // TextEditingController entryNoController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController totalQuantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late WarperYarnShortageAdjustmentsController controller;

  var itemList = <dynamic>[];
  late ItemDataSource dataSource;

  final FocusNode _warperNameFocusNode = FocusNode();
  var shortCut = RxString("");

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
    _initValue();
    super.initState();
    _warperNameFocusNode.addListener(() => shortCutKeys());
    dataSource = ItemDataSource(list: itemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarperYarnShortageAdjustmentsController>(
        builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Warper Yarn Shortage Adjustments"),
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
          ],
        ),
        loadingStatus: controller.status.isLoading,
        // bindings: {
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
        //       Get.back(),
        //   const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
        //       _addItem(),
        //   const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
        //       submit(),
        // },
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyN, control: true):
              AddNewIntent(),
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
                          Focus(
                            focusNode: _warperNameFocusNode,
                            skipTraversal: true,
                            child: MyAutoComplete(
                                onChanged: (LedgerModel item) {
                                  warperName.value = item;
                                },
                                label: 'Warper Name',
                                selectedItem: warperName.value,
                                items: controller.ledgerDropdown),
                          ),

                          /*MyDialogList(
                            labelText: 'Warper Name',
                            controller: warperNameController,
                            list: controller.ledgerDropdown,
                            showCreateNew: false,
                            onItemSelected: (LedgerModel item) {
                              warperNameController.text = '${item.ledgerName}';
                              warperName.value = item;
                            },
                            onCreateNew: (value) async {
                              // var item =
                              // await Get.toNamed(AddYarn.routeName);
                              // controller.onInit();
                            },
                          ),*/
                          // MyTextField(
                          //   controller: entryNoController,
                          //   hintText: "Entry No",
                          // ),
                          MyDateFilter(
                            controller: dateController,
                            labelText: 'Date',
                          ),
                          MyTextField(
                            controller: detailsController,
                            hintText: "Details",
                            validate: "string",
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
                            onPressed: controller.status.isLoading ? null : submit,
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
        controller.ledgerInfo();
      }
    }
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "warper_id": warperName.value?.id,
        // "trans_no": entryNoController.text,
        "e_date": dateController.text,
        "details": detailsController.text,
      };

/*
      var yarnItemList = [];
      dynamic quantityTotal = 0;
      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "yarn_id": itemList[i]['yarn_id'],
          "color_id": itemList[i]['color_id'],
          "stock_balance": itemList[i]['stock_balance'],
          "qty": itemList[i]['qty'],
        };
        yarnItemList.add(item);
        // quantityTotal +=
        //     itemList[i]['qty'];
      }
      request['total_qty'] = quantityTotal;
      request['yarn_item'] = yarnItemList;
      print(request);
 */
      request["item_details"] = itemList;

      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        controller.add(request);
      } else {
        request['id'] = id;
        controller.edit(request, id);
      }

      // print(request);
    }
  }

  void _initValue() {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    WarperYarnShortageAdjustmentsController controller = Get.find();
    controller.request = <String, dynamic>{};

    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = Get.arguments['item'];
      idController.text = tryCast(item['id']);
      dateController.text = tryCast(item['e_date']);
      // entryNoController.text = tryCast(warpe.transNo);
      detailsController.text = tryCast(item['details']);

      var warperNameList = controller.ledgerDropdown
          .where((element) => '${element.id}' == '${item['warper_id']}')
          .toList();
      if (warperNameList.isNotEmpty) {
        warperName.value = warperNameList.first;
        controller.request['warper_id'] = warperNameList.first.id;
        warperNameController.text = '${warperNameList.first.ledgerName}';
      }

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
        //  print(jsonEncode(request));
        itemList.add(request);
      });
    }
  }

  Widget itemsTable() {
    return MySFDataGridItemTable(
      selectionMode: SelectionMode.single,
      controller: _dataGridController,
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
          width: 150,
          columnName: 'qty',
          label: const MyDataGridHeader(title: 'Quantity'),
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
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSource,
      onRowSelected: (index) async {
        if (isUpdate.value) {
          return;
        }
        var item = itemList[index];
        var result = await Get.to(
            const WarperYarnShortageAdjustmentsBottomSheet(),
            arguments: {'item': item});
        if (result != null) {
          itemList[index] = result;
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        }
      },
    );
  }

  void removeSelectedItems() {
    int? index = _dataGridController.selectedIndex;
    if (index >= 0) {
      itemList.removeAt(index);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
      _dataGridController.selectedIndex = -1;
    } else {
      AppUtils.infoAlert(message: "Select The Value");
    }
  }

  void _addItem() async {
    var result = await Get.to(const WarperYarnShortageAdjustmentsBottomSheet());
    if (result != null) {
      itemList.add(result);
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
        DataGridCell<dynamic>(columnName: 'qty', value: e['qty']),
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
      case 'qty':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 3, alignment: alignment);

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
