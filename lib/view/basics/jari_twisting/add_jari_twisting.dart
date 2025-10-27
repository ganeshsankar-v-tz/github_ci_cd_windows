import 'package:abtxt/model/JariTwistingModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/YarnModel.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../yarn/add_yarn.dart';
import 'jari_twisting_bottom_sheet.dart';
import 'jari_twisting_controller.dart';

class AddJariTwisting extends StatefulWidget {
  const AddJariTwisting({Key? key}) : super(key: key);
  static const String routeName = '/AddJariTwisting';

  @override
  State<AddJariTwisting> createState() => _State();
}

class _State extends State<AddJariTwisting> {
  TextEditingController idController = TextEditingController();
  Rxn<YarnModel> yarnName = Rxn<YarnModel>();
  TextEditingController yarnNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController wagesController = TextEditingController(text: "0");
  TextEditingController detailsController = TextEditingController();
  late JariTwistingController controller;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _qtyFocusNode = FocusNode();
  final FocusNode _yarnNameFocusNode = FocusNode();
  var shortCut = RxString("");
  final FocusNode _addItemFocusNode = FocusNode();

  var itemList = <dynamic>[];
  late ItemDataSource dataSource;
  RxBool isUpdate = RxBool(false);
  final DataGridController _dataGridController = DataGridController();

  @override
  void initState() {
    _yarnNameFocusNode.addListener(() => shortCutKeys());
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: itemList);
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_addItemFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JariTwistingController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Jari Twisting"),
          actions: [
            Visibility(
                visible: idController.text.isNotEmpty,
                child: MyDeleteIconButton(
                  onPressed: (password) {
                    controller.delete(idController.text, password);
                  },
                )),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        // bindings: {
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () => Get.back(),
        //   const SingleActivator(LogicalKeyboardKey.keyN, control: true): () => _addItem(),
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
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
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
            NavigateIntent: SetCounterAction(perform: () {
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
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text("Expected Yarn")],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
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
                            focusNode: _yarnNameFocusNode,
                            skipTraversal: true,
                            child: MyAutoComplete(
                              label: 'Yarn Name',
                              items: controller.yarnDropdown,
                              selectedItem: yarnName.value,
                              enabled: !isUpdate.value,
                              onChanged: (YarnModel item) {
                                yarnName.value = item;
                              },
                            ),
                          ),
                          Focus(
                            skipTraversal: true,
                            child: MyTextField(
                              focusNode: _qtyFocusNode,
                              controller: quantityController,
                              hintText: "Qty",
                              validate: "double",
                            ),
                            onFocusChange: (hasFocus) {
                              AppUtils.fractionDigitsText(
                                quantityController,
                              );
                            },
                          ),
                          Focus(
                            skipTraversal: true,
                            child: MyTextField(
                              controller: wagesController,
                              hintText: "Wages (Rs) Per Unit",
                              validate: "double",
                            ),
                            onFocusChange: (hasFocus) {
                              AppUtils.fractionDigitsText(wagesController,
                                  fractionDigits: 2);
                            },
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
                            focusNode: _addItemFocusNode,
                            width: 135,
                            onPressed: () async {
                              _addItem();
                            },
                            child: const Text('Add Item'),
                          ),
                        ],
                      ),
                      //const SizedBox(height: 5),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text("Required Yarn")],
                      ),
                      const SizedBox(height: 5),
                      ItemsTable(),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          /* crateAndUpdatedBy(),
                          const Spacer(),*/
                          Obx(
                            () => Text(shortCut.value,
                                style: AppUtils.shortCutTextStyle()),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            child: MySubmitButton(
                              onPressed:
                                  controller.status.isLoading ? null : submit,
                            ),
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

  shortCutKeys() {
    if (_yarnNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Yarn',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_yarnNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddYarn.routeName);

      if (result == "success") {
        controller.yarnNameInfo();
      }
    }
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "yarn_id": yarnName.value?.id,
        "details": detailsController.text,
        "default_qty": double.tryParse(quantityController.text) ?? 0,
        "wages": double.tryParse(wagesController.text) ?? 0,
      };
      var itemDetails = [];
      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "yarn_id": itemList[i]['yarn_id'],
          "usage": itemList[i]['usage'],
          "colour_name": itemList[i]['colour_name'],
          "colour_id": itemList[i]['colour_id'],
        };

        itemDetails.add(item);
      }
      request['item_details'] = itemDetails;

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
    JariTwistingController controller = Get.find();
    controller.request = <String, dynamic>{};

    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = JariTwistingModel.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      quantityController.text = tryCast(item.defaultQty);
      wagesController.text = tryCast(item.wages);
      detailsController.text = tryCast(item.details);

      var yarnList = controller.yarnDropdown
          .where((element) => '${element.id}' == '${item.yarnId}')
          .toList();
      if (yarnList.isNotEmpty) {
        yarnName.value = yarnList.first;
        yarnNameController.text = '${yarnList.first.name}';
      }

      item.itemDetails?.forEach((element) {
        var request = element.toJson();
        itemList.add(request);
      });
    }
  }

  Widget ItemsTable() {
    return MySFDataGridItemTable(
      selectionMode: SelectionMode.single,
      controller: _dataGridController,
      columns: [
        GridColumn(
          columnName: 'yarn_name',
          label: const MyDataGridHeader(title: 'Yarn Name'),
        ),
        GridColumn(
          columnName: 'colour_name',
          label: const MyDataGridHeader(title: 'Color Name'),
        ),
        GridColumn(
          width: 200,
          columnName: 'usage',
          label: const MyDataGridHeader(title: 'Usage'),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'usage',
              columnName: 'usage',
              summaryType: GridSummaryType.sum,
            ),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSource,
      onRowSelected: (index) async {
        var item = itemList[index];
        var result = await Get.to(const JariTwistingBottomSheet(),
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
    var result = await Get.to(const JariTwistingBottomSheet());
    if (result != null) {
      itemList.add(result);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    }
  }

  /*Widget crateAndUpdatedBy() {
    String id = idController.text;
    String formattedDate = AppUtils.dateFormatter.format(DateTime.now());
    String? createdAt;
    String? updatedAt;
    String? entryBy;

    if (Get.arguments != null) {
      var item = Get.arguments["item"];
      DateTime createDate = DateTime.parse(item["created_at"] ?? "0000-00-00");
      DateTime updateDate = DateTime.parse(item["updated_at"] ?? "0000-00-00");
      createdAt = AppUtils.dateFormatter.format(createDate);
      updatedAt = AppUtils.dateFormatter.format(updateDate);

      entryBy = item["creator_name"] ?? '';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          id.isEmpty ? AppUtils().loginName : "$entryBy",
          style: AppUtils.updateAndCreateTextStyle(),
        ),
        const SizedBox(width: 12),
        Text(
          id.isEmpty ? formattedDate : "${updatedAt ?? createdAt}",
          style: AppUtils.updateAndCreateTextStyle(),
        )
      ],
    );
  }*/
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
        DataGridCell<dynamic>(
            columnName: 'colour_name', value: e['colour_name']),
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
        case 'usage':
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
      case 'usage':
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
