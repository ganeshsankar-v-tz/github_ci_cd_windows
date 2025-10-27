import 'package:abtxt/view/trasaction/yarn_inward_from_winder/winder_item_bottomsheet.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/LedgerModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import 'yarn_inward_from_winder_controller.dart';

class AddYarnInwardFromWinder extends StatefulWidget {
  const AddYarnInwardFromWinder({super.key});

  static const String routeName = '/add_yarn_inward_from_winder';

  @override
  State<AddYarnInwardFromWinder> createState() => _State();
}

class _State extends State<AddYarnInwardFromWinder> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> winderName = Rxn<LedgerModel>();
  TextEditingController referenceNoController = TextEditingController();
  TextEditingController entryDateController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController totalPackController = TextEditingController();
  TextEditingController totalNetQytController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  YarnInwardFromWinderController controller = Get.find();

  // var winderList = <dynamic>[].obs
  final FocusNode _firstInputFocusNode = FocusNode();
  RxBool isUpdate = RxBool(false);
  final DataGridController _dataGridController = DataGridController();
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
    controller.lastDcNo.dcNo = "";
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
    return GetBuilder<YarnInwardFromWinderController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Yarn Inward From Winder"),
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
              visible: Get.arguments != null,
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
                        MyAutoComplete(
                          label: 'Winder Name',
                          items: controller.ledger_dropdown,
                          selectedItem: winderName.value,
                          enabled: !isUpdate.value,
                          onChanged: (LedgerModel item) {
                            winderName.value = item;
                            controller.itemList.clear();
                            dataSource.updateDataGridRows();
                            dataSource.updateDataGridSource();
                            controller.request["winder_id"] = item.id;
                          },
                        ),
                        MyTextField(
                          focusNode: _firstInputFocusNode,
                          controller: referenceNoController,
                          hintText: "Reference No",
                        ),
                        MyDateFilter(
                          controller: entryDateController,
                          labelText: "Entry Date",
                        ),
                        MyTextField(
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
                    Flexible(child: itemsTable()),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        crateAndUpdatedBy(),
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

  Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }

    var request = {'id': idController.text};
    String? response = await controller.yarnInwardFromWinder(request: request);
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
        "winder_id": winderName.value?.id,
        "referance_no": referenceNoController.text,
        "e_date": entryDateController.text,
        "details": detailsController.text,
      };

      var winderItemLIst = [];
      for (var i = 0; i < controller.itemList.length; i++) {
        Map<String, dynamic> item = {
          "entry_type": controller.itemList[i]['entry_type'],
          "yarn_id": controller.itemList[i]['yarn_id'],
          "color_id": controller.itemList[i]['color_id'],
          "deli_rec_no": controller.itemList[i]['deli_rec_no'],
        };

        if (controller.itemList[i]['entry_type'] == 'Excess') {
          item['quantity'] = controller.itemList[i]['quantity'];
          item['gross_quantity'] = controller.itemList[i]['gross_quantity'];
        }

        if (controller.itemList[i]['entry_type'] == 'Wastage') {
          item['quantity'] = controller.itemList[i]['quantity'];
          item['gross_quantity'] = controller.itemList[i]['gross_quantity'];
          item['stock_in'] = controller.itemList[i]['stock_in'];
        }
        if (controller.itemList[i]['entry_type'] == 'Inward') {
          item['stock_in'] = controller.itemList[i]['stock_in'];
          item['bag_box_no'] = controller.itemList[i]['bag_box_no'];
          item['pack'] = controller.itemList[i]['pack'];
          item['quantity'] = controller.itemList[i]['quantity'];
          item['less_quanitty'] = controller.itemList[i]['less_quanitty'];
          item['gross_quantity'] = controller.itemList[i]['gross_quantity'];
        }
        if (controller.itemList[i]['entry_type'] == 'Return') {
          item['stock_in'] = controller.itemList[i]['stock_in'];
          item['bag_box_no'] = controller.itemList[i]['bag_box_no'];
          item['pack'] = controller.itemList[i]['pack'];
          item['quantity'] = controller.itemList[i]['quantity'];
          item['less_quanitty'] = controller.itemList[i]['less_quanitty'];
          item['gross_quantity'] = controller.itemList[i]['gross_quantity'];
        }
        winderItemLIst.add(item);
      }
      request['winder_item'] = winderItemLIst;

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
    if (Get.arguments != null) {
      isUpdate.value = true;
      YarnInwardFromWinderController controller = Get.find();
      controller.request = <String, dynamic>{};

      var item = Get.arguments['item'];
      idController.text = '${item.id}';

      var winderNameList = controller.ledger_dropdown
          .where((element) => '${element.id}' == '${item.winderId}')
          .toList();
      if (winderNameList.isNotEmpty) {
        winderName.value = winderNameList.first;
        controller.request['winder_id'] = winderNameList.first.id;
      }
      referenceNoController.text = item.referanceNo ?? '';
      entryDateController.text = '${item.eDate}';
      detailsController.text = item.details ?? '';

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
          columnName: 'entry_type',
          label: const MyDataGridHeader(title: 'Entry Type'),
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
          columnName: 'stock_in',
          label: const MyDataGridHeader(title: 'Stock Place'),
        ),
        GridColumn(
          columnName: 'bag_box_no',
          label: const MyDataGridHeader(title: 'Bag/Box No.'),
        ),
        GridColumn(
          width: 120,
          columnName: 'pack',
          label: const MyDataGridHeader(title: 'Pack'),
        ),
        GridColumn(
          width: 120,
          columnName: 'gross_quantity',
          label: const MyDataGridHeader(title: 'Quantity'),
        ),
        GridColumn(
          columnName: 'dc_no',
          label: const MyDataGridHeader(title: 'Dc.No'),
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
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSource,
      onRowSelected: (index) async {
/*        if (winderName.value == null) {
          return;
        }
        var winderId = winderName.value?.id;

        var item = itemList[index];
        var result = await Get.to(const WiderItemBottomSheet(),
            arguments: {'item': item, 'winder_id': winderId});
        if (result['item'] == 'delete') {
          itemList.removeAt(index);
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        } else if (result != null) {
          itemList[index] = result;
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        }*/
      },
    );
  }

  Future<void> removeSelectedItems() async {
    int? index = _dataGridController.selectedIndex;
    var item = controller.itemList[index];

    if (index >= 0) {
      if (item["sync"] != 0) {
        var result = await controller.selectedRowRemove(item["id"]);

        if (result == true) {
          controller.itemList.removeAt(index);
        }
      } else {
        controller.itemList.removeAt(index);
      }

      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
      _dataGridController.selectedIndex = -1;
    } else {
      AppUtils.infoAlert(message: "Select The Value");
    }
  }

  void _addItem() async {
    if (winderName.value == null) {
      return;
    }
    var result = await Get.to(() => const WiderItemBottomSheet());
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
        DataGridCell<dynamic>(columnName: 'entry_type', value: e['entry_type']),
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e['yarn_name']),
        DataGridCell<dynamic>(columnName: 'color_name', value: e['color_name']),
        DataGridCell<dynamic>(columnName: 'stock_in', value: e['stock_in']),
        DataGridCell<dynamic>(columnName: 'bag_box_no', value: e['bag_box_no']),
        DataGridCell<dynamic>(columnName: 'pack', value: e['pack']),
        DataGridCell<dynamic>(
            columnName: 'gross_quantity', value: e['gross_quantity']),
        DataGridCell<dynamic>(columnName: 'dc_no', value: e['dc_no']),
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
      case 'gross_quantity':
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
