import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/utils/constant.dart';
import 'package:abtxt/view/basics/new_wrap/new_warp_controller.dart';
import 'package:abtxt/view/basics/warp_group/add_warp_group.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/NewWarpModel.dart';
import '../../../model/WarpGroupModel.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import 'new_warp_bottomsheet.dart';

class AddNewWarp extends StatefulWidget {
  const AddNewWarp({super.key});

  static const String routeName = '/add_new_warp_list';

  @override
  State<AddNewWarp> createState() => _State();
}

class _State extends State<AddNewWarp> {
  TextEditingController idController = TextEditingController();
  TextEditingController warpDesignController = TextEditingController();
  TextEditingController warpTypeController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  Rxn<WarpGroupModel> groupNName = Rxn<WarpGroupModel>();
  TextEditingController patternController = TextEditingController();
  TextEditingController lengthTypeController = TextEditingController();
  TextEditingController totalEndsController = TextEditingController();
  TextEditingController isActiveController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  NewWarpController controller = Get.find();

  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _warpGroupFocusNode = FocusNode();
  final FocusNode _totalEndsFocusNode = FocusNode();
  final FocusNode _addItemFocusNode = FocusNode();
  var shortCut = RxString("");

  late ItemDataSource dataSource;
  final DataGridController _dataGridController = DataGridController();

  RxBool isUpdate = RxBool(false);

  @override
  void initState() {
    _warpGroupFocusNode.addListener(() => shortCutKeys());
    controller.itemList.clear();
    controller.lastYarn = null;
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: controller.itemList);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null) {
        FocusScope.of(context).requestFocus(_addItemFocusNode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewWarpController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title: Text("${idController.text == '' ? 'Add' : 'Update'} New Warp"),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        //color: Colors.green,
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
                                MyTextField(
                                  autofocus: true,
                                  controller: warpDesignController,
                                  hintText: "Warp Design",
                                  validate: "string",
                                  focusNode: _firstInputFocusNode,
                                  onChanged: (value) {
                                    _sumQuantityRate();
                                  },
                                ),
                                MyDropdownButtonFormField(
                                  controller: warpTypeController,
                                  hintText: "Warp Type",
                                  enabled: !isUpdate.value,
                                  items: Constants.WarpType,
                                  onChanged: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_warpGroupFocusNode);
                                  },
                                ),
                                MySearchField(
                                    label: 'Group Name',
                                    items: controller.groups,
                                    textController: groupNameController,
                                    focusNode: _warpGroupFocusNode,
                                    requestFocus: _totalEndsFocusNode,
                                    onChanged: (WarpGroupModel item) {
                                      groupNName.value = item;
                                      // _groupNameFocusNode.requestFocus();
                                    }),
                                MyDropdownButtonFormField(
                                  controller: patternController,
                                  hintText: "Pattern",
                                  enabled: false,
                                  items: const ["Nothing"],
                                ),
                                MyTextField(
                                  focusNode: _totalEndsFocusNode,
                                  controller: totalEndsController,
                                  hintText: "Total Ends",
                                  validate: "number",
                                ),
                                MyDropdownButtonFormField(
                                  controller: lengthTypeController,
                                  hintText: "Length Type",
                                  enabled: !isUpdate.value,
                                  items: Constants.LengthType,
                                  onChanged: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_addItemFocusNode);
                                  },
                                ),
                                ExcludeFocusTraversal(
                                  child: MyDropdownButtonFormField(
                                      controller: isActiveController,
                                      hintText: "Is Active",
                                      items: Constants.ISACTIVE),
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
                                Obx(
                                  () => Text(shortCut.value,
                                      style: AppUtils.shortCutTextStyle()),
                                ),
                                const SizedBox(width: 12),
                                MySubmitButton(
                                  onPressed: controller.status.isLoading
                                      ? null
                                      : submit,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  shortCutKeys() {
    if (_warpGroupFocusNode.hasFocus) {
      shortCut.value = "To Create 'Warp Group',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_warpGroupFocusNode.hasFocus) {
      var result = await Get.toNamed(AddWarpGroup.routeName);

      if (result == "success") {
        controller.groupNameInfo();
      }
    }
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "warp_name": warpDesignController.text,
        "warp_type": warpTypeController.text,
        "group_id": groupNName.value?.id,
        "patterns": patternController.text,
        "total_ends": totalEndsController.text,
        "length_type": lengthTypeController.text,
        "is_active": isActiveController.text,
      };

      request['warp_details'] = controller.itemList;

      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        controller.addNewwarps(request);
      } else {
        request['id'] = id;
        controller.updateNewWarps(request);
      }
    }
  }

  void _initValue() {
    NewWarpController controller = Get.find();
    controller.request = <String, dynamic>{};

    warpTypeController.text = Constants.WarpType[0];
    lengthTypeController.text = Constants.LengthType[0];
    patternController.text = Constants.Pattern[0];
    isActiveController.text = Constants.ISACTIVE[0];

    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = NewWarpModel.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      warpDesignController.text = '${item.warpName}';
      warpTypeController.text = '${item.warpType}';
      patternController.text = '${item.patterns}';
      totalEndsController.text = '${item.totalEnds}';
      lengthTypeController.text = '${item.lengthType}';
      isActiveController.text = '${item.isActive}';

      var groupId = controller.groups
          .where((element) => '${element.id}' == '${item.groupId}')
          .toList();
      if (groupId.isNotEmpty) {
        groupNName.value = groupId.first;
        groupNameController.text = '${groupId.first.groupName}';
      }
      item.warpDetails?.forEach((element) {
        var request = element.toJson();
        controller.itemList.add(request);
      });
    }
  }

  void _sumQuantityRate() {
    var nums = warpDesignController.text.split("+");
    int total = 0;
    for (String num in nums) {
      var value = num.replaceAll(RegExp(r'[^0-9]'), '');

      total += int.tryParse(value) ?? 0;
    }
    totalEndsController.text = '$total';
  }

  Widget itemsTable() {
    return Flexible(
      child: MySFDataGridItemTable(
        scrollPhysics: const ScrollPhysics(),
        shrinkWrapRows: false,
        selectionMode: SelectionMode.single,
        controller: _dataGridController,
        columns: [
          GridColumn(
            columnName: 'yarn_name',
            label: const MyDataGridHeader(title: 'Yarn Name'),
          ),
          GridColumn(
            columnName: 'no_of_ends',
            label: const MyDataGridHeader(title: 'No.of Ends'),
          ),
        ],
        tableSummaryRows: [
          GridTableSummaryRow(
            showSummaryInRow: false,
            title: 'Total: ',
            titleColumnSpan: 1,
            columns: [
              const GridSummaryColumn(
                name: 'no_of_ends',
                columnName: 'no_of_ends',
                summaryType: GridSummaryType.sum,
              ),
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
          /*var item = controller.itemList[index];
          var result = await Get.to(const NewWarpBottomSheet(), arguments: {'item': item});
           if (result['item'] == 'delete') {
            controller.itemList.removeAt(index);
            dataSource.updateDataGridRows();
            dataSource.updateDataGridSource();
          } else
          if (result != null) {
            controller.itemList[index] = result;
            dataSource.updateDataGridRows();
            dataSource.updateDataGridSource();
          }*/
        },
      ),
    );
  }

  // void selectedItemIndexes(index) {
  //   if (SELECTED_ITEM_INDEXES.contains(index)) {
  //     SELECTED_ITEM_INDEXES.remove(index);
  //   } else {
  //     SELECTED_ITEM_INDEXES.add(index);
  //   }
  // }

  void removeSelectedItems() {
    int? index = _dataGridController.selectedIndex;
    if (index >= 0) {
      controller.itemList.removeAt(index);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
      _dataGridController.selectedIndex = index - 1;
    } else {
      AppUtils.infoAlert(message: "Select The Value");
    }
  }

  void _addItem() async {
    if (controller.itemList.isNotEmpty) {
      controller.lastYarn = controller.itemList.last;
    }
    controller.warpType = warpTypeController.text;
    int totalEnds = int.tryParse(totalEndsController.text) ?? 0;
    if (controller.itemList.isEmpty) {
      controller.totalEnds = totalEnds;
    } else {
      int noOfEnds = 0;
      for (var e in controller.itemList) {
        noOfEnds += int.tryParse("${e["no_of_ends"]}") ?? 0;
      }
      controller.totalEnds = totalEnds - noOfEnds;
    }
    if (controller.totalEnds == 0) {
      return;
    }

    var result = await Get.to(() => const NewWarpBottomSheet());
    if (result != null) {
      controller.itemList.add(result);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();

      await Future.delayed(const Duration(milliseconds: 500));
      _addItem();
    }
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
            columnName: 'yarn_name', value: '${e['yarn_name']}'),
        DataGridCell<int>(columnName: 'no_of_ends', value: e['no_of_ends']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          dataGridCell.value != null ? '${dataGridCell.value}' : '',
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
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        summaryValue,
        style: AppUtils.footerTextStyle(),
      ),
    );
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
