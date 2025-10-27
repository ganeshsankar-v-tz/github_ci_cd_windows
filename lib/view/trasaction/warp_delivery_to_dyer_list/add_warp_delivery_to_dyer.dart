import 'dart:convert';

import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/saree_checker/SareeCheckerModel.dart';
import 'package:abtxt/model/warp_delivery_to_dyer_model.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_dyer_list/warp_delivery_to_dyer__bottomsheet.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_dyer_list/warp_delivery_to_dyer__bottomsheet_two.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_dyer_list/warp_delivery_to_dyer_controller.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
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
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../basics/ledger/addledger.dart';

class AddWarpDeliveryToDyer extends StatefulWidget {
  const AddWarpDeliveryToDyer({super.key});

  static const String routeName = '/AddWarpDeliveryToDyer';

  @override
  State<AddWarpDeliveryToDyer> createState() => _State();
}

class _State extends State<AddWarpDeliveryToDyer> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> dyerName = Rxn<LedgerModel>();
  TextEditingController dyerNameController = TextEditingController();
  TextEditingController dcNoController = TextEditingController();
  TextEditingController entryDateController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  var warpCheckerController = TextEditingController();
  Rxn<SareeCheckerModel> warpChecker = Rxn<SareeCheckerModel>();

  final _formKey = GlobalKey<FormState>();
  WarpDeliveryToDyerController controller = Get.find();
  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _dyerNameFocusNode = FocusNode();
  final FocusNode _addItemFocusNode = FocusNode();
  final FocusNode _warpCheckerFocusNode = FocusNode();
  var shortCut = RxString("");

  late DyerDeliveryItemDataSource dataSource;

  RxBool isUpdate = RxBool(false);
  RxBool addItemVisible = RxBool(false);

  // bool addItemVisible = false;
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
    controller.getBackBoolean.value = false;
    _dyerNameFocusNode.addListener(() => shortCutKeys());
    controller.itemList.clear();
    controller.lastWarp = null;
    _initValue();
    super.initState();
    dataSource = DyerDeliveryItemDataSource(list: controller.itemList);
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_addItemFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpDeliveryToDyerController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Warp Delivery To Dyer"),
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
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              getBackAlert();
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
          child: WillPopScope(
            onWillPop: () async {
              getBackAlert();
              return false;
            },
            child: FocusScope(
              autofocus: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: LayoutBuilder(builder: (context, constraint) {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 90,
                                  child: topDetails(),
                                ),
                                SizedBox(
                                  height: constraint.maxHeight - 90,
                                  child: bottomDetails(),
                                )
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: addItemVisible.value,
                      child: Flexible(
                          flex: 2,
                          child: WarpDeliveryToDyerBottomSheetTwo(
                            dataSource: dataSource,
                          )),
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

  Widget topDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
              label: 'Dyer Name',
              textController: dyerNameController,
              focusNode: _dyerNameFocusNode,
              requestFocus: _warpCheckerFocusNode,
              items: controller.ledgerDropdown,
              enabled: !isUpdate.value,
              onChanged: (LedgerModel item) {
                dyerName.value = item;
                controller.dyerWarpBalanceDetails(item.id);
              },
            ),
            Visibility(
              visible: dcNoController.text.isNotEmpty,
              child: MyTextField(
                width: 160,
                controller: dcNoController,
                hintText: "D.C No",
                enabled: !isUpdate.value,
              ),
            ),
            MySearchField(
              label: 'Warp Checker',
              textController: warpCheckerController,
              focusNode: _warpCheckerFocusNode,
              items: controller.warpCheckerDropdown,
              onChanged: (SareeCheckerModel item) {
                warpChecker.value = item;
              },
              requestFocus: _addItemFocusNode,
            ),
            MyDateFilter(
              width: 160,
              enabled: false,
              controller: entryDateController,
              labelText: "Entry Date",
              focusNode: _firstInputFocusNode,
            ),
            Visibility(
              visible: false,
              child: MyTextField(
                controller: detailsController,
                hintText: "Details",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget bottomDetails() {
    return LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
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
            ),
            SizedBox(
              height: constraint.maxHeight - 50,
              child: Column(
                children: [
                  Flexible(child: itemsTable()),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  shortCutKeys() {
    if (_dyerNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Dyer',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_dyerNameFocusNode.hasFocus) {
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
    var request = {'id': idController.text};

    String? response = await controller.warpDeliveryToDyerPdf(request: request);

    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "dyer_id": dyerName.value?.id,
        "e_date": entryDateController.text,
        "details": detailsController.text,
        "warp_checker_id": warpChecker.value?.id,
      };
      var dyerItemList = [];

      var itemList = controller.itemList;
      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "warp_design_id": itemList[i]['warp_design_id'],
          "warp_id": itemList[i]['warp_id'],
          "color_to_dye": itemList[i]['color_to_dye'],
          "warp_det": itemList[i]['warp_det'],
          "warp_weight": itemList[i]['warp_weight'],
          "product_qty": itemList[i]['product_qty'],
          "warp_inward": itemList[i]['warp_inward'],
          "metre": itemList[i]['metre'],
          "weaver_id": itemList[i]['weaver_id'],
          "sub_weaver_no": itemList[i]['sub_weaver_no'],
          "warp_tracker_id": itemList[i]['warp_tracker_id'],
          "warp_for": itemList[i]['warp_for'],
        };
        dyerItemList.add(item);
      }
      request['dyer_item'] = dyerItemList;

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
    entryDateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    if (Get.arguments != null) {
      isUpdate.value = true;
      WarpDeliveryToDyerController controller = Get.find();
      var data = WarpDeliveryToDyerModel.fromJson(Get.arguments['item']);
      idController.text = '${data.id}';
      dcNoController.text = '${data.dcNo}';
      entryDateController.text = '${data.eDate}';
      detailsController.text = data.details ?? '';

      var dyerList = controller.ledgerDropdown
          .where((element) => '${element.id}' == '${data.dyerId}')
          .toList();
      if (dyerList.isNotEmpty) {
        dyerName.value = dyerList.first;
        dyerNameController.text = '${dyerList.first.ledgerName}';
        controller.dyerWarpBalanceDetails(dyerList.first.id);
      }

      warpCheckerController.text = data.warpCheckerName ?? '';
      warpChecker.value = SareeCheckerModel(
        id: data.warpCheckerId,
        checkerName: data.warpCheckerName,
      );

      /// get created by and updated by details
      DateTime createDate = DateTime.parse(data.createdAt ?? "0000-00-00");
      DateTime updateDate = DateTime.parse(data.updatedAt ?? "0000-00-00");
      createdAt = AppUtils.dateFormatter.format(createDate);
      updatedAt = AppUtils.dateFormatter.format(updateDate);
      createdBy = data.creatorName;
      updatedBy = data.updatedName;
      if (updatedBy != null) {
        displayName = "Edit : $updatedBy";
        displayDate = updatedAt;
      } else {
        displayName = "New : $createdBy";
        displayDate = createdAt;
      }

      data.itemDetails?.forEach((element) {
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
          width: 40,
          columnName: 's_no',
          label: const MyDataGridHeader(title: 'S.N'),
        ),
        GridColumn(
          width: 300,
          columnName: 'warp_design_name',
          label: const MyDataGridHeader(title: 'Warp Design'),
        ),
        GridColumn(
          width: 150,
          columnName: 'warp_id',
          label: const MyDataGridHeader(title: 'Warp ID'),
        ),
        GridColumn(
          width: 50,
          columnName: 'product_qty',
          label: const MyDataGridHeader(title: 'Qty'),
        ),
        GridColumn(
          visible: false,
          width: 80,
          columnName: 'metre',
          label: const MyDataGridHeader(title: 'Metre'),
        ),
        GridColumn(
          width: 150,
          columnName: 'color_to_dye',
          label: const MyDataGridHeader(title: 'Color to Dye'),
        ),
        GridColumn(
          width: 150,
          columnName: 'warp_det',
          label: const MyDataGridHeader(title: 'Details'),
        ),
        GridColumn(
          width: 150,
          columnName: 'weaver_name',
          label: const MyDataGridHeader(title: 'Weaver Name'),
        ),
        GridColumn(
          width: 60,
          columnName: 'loom_no',
          label: const MyDataGridHeader(title: 'Loom'),
        ),
        GridColumn(
          width: 90,
          columnName: 'warp_weight',
          label: const MyDataGridHeader(title: 'Weight'),
        ),
        GridColumn(
          visible: false,
          columnName: 'warp_inward',
          label: const MyDataGridHeader(title: 'Warp Inward'),
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
              name: 'metre',
              columnName: 'metre',
              summaryType: GridSummaryType.sum,
            ),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSource,
      onRowSelected: (index) async {
        var item = controller.itemList[index];
        if (item["warp_inward"] == 1) {
          return AppUtils.infoAlert(
              message:
                  "This warp ID has already been inward, so the data cannot be change.");
        }

        var result = await Get.to(() => const WarpDeliveryToDyerBottomSheet(),
            arguments: {'item': item});
        if (result != null) {
          controller.itemList[index] = result;
          dataTableDetailsUpdate();
        }
      },
    );
  }

  removeSelectedItems() {
    int? index = _dataGridController.selectedIndex;
    var item = controller.itemList[index];
    if (index >= 0) {
      if (item["warp_inward"] == 1) {
        return AppUtils.infoAlert(
            message:
                "This warp ID has already been inward, so the data cannot be Remove.");
      }
      controller.itemList.removeAt(index);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
      _dataGridController.selectedIndex = -1;
    } else {
      AppUtils.infoAlert(message: "Select The Value");
    }
  }

  void _addItem() {
    addItemVisible.value = true;
  }

  /*void _addItem() async {
    if (controller.itemList.isNotEmpty) {
      controller.lastWarp = controller.itemList.last;
    }
    var result = await Get.to(const WarpDeliveryToDyerBottomSheet());
    if (result != null) {
      controller.itemList.add(result);
      dataTableDetailsUpdate();

      await Future.delayed(const Duration(milliseconds: 500));
      _addItem();
    }
  }*/

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

  dataTableDetailsUpdate() {
    controller.itemList.sort((a, b) => a['warp_design_name']
        .toLowerCase()
        .compareTo(b['warp_design_name'].toLowerCase()));
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
  }

  getBackAlert() async {
    if (controller.getBackBoolean.value == true) {
      await AppUtils.showExitDialog(context) == true ? submit() : '';
    } else {
      Get.back();
    }
  }
}

class DyerDeliveryItemDataSource extends DataGridSource {
  DyerDeliveryItemDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var index = _list.indexOf(e);
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 's_no', value: index + 1),
        DataGridCell<dynamic>(
            columnName: 'warp_design_name', value: e['warp_design_name']),
        DataGridCell<dynamic>(columnName: 'warp_id', value: e['warp_id']),
        DataGridCell<dynamic>(
            columnName: 'product_qty', value: e['product_qty']),
        DataGridCell<dynamic>(columnName: 'metre', value: e['metre']),
        DataGridCell<dynamic>(
            columnName: 'color_to_dye', value: e['color_to_dye']),
        DataGridCell<dynamic>(columnName: 'warp_det', value: e['warp_det']),
        DataGridCell<dynamic>(
            columnName: 'weaver_name', value: e['weaver_name']),
        DataGridCell<dynamic>(columnName: 'loom_no', value: e['loom_no']),
        DataGridCell<dynamic>(
            columnName: 'warp_weight', value: e['warp_weight']),
        DataGridCell<dynamic>(
            columnName: 'warp_inward', value: e['warp_inward']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color getRowColor() {
      if (row.getCells()[10].value == 1) {
        return Colors.green.shade100;
      } else {
        return Colors.transparent;
      }
    }

    return DataGridRowAdapter(
        color: getRowColor(),
        cells: row.getCells().map<Widget>((dataGridCell) {
          double value = double.tryParse('${dataGridCell.value}') ?? 0;
          final columnName = dataGridCell.columnName;
          switch (columnName) {
            case 'product_qty':
              return buildFormattedCell(value, decimalPlaces: 0);
            case 'metre':
              return buildFormattedCell(value, decimalPlaces: 0);
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
      case 'product_qty':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'metre':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      default:
        /*alignment = TextAlign.left;
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
