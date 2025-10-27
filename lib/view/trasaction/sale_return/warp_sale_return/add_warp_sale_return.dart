import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/view/trasaction/sale_return/warp_sale_return/warp_sale_return_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../model/credit_note/WarpSaleReturnSlipNoModel.dart';
import '../../../../utils/app_utils.dart';
import '../../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../../widgets/MyDataGridHeader.dart';
import '../../../../widgets/MyDateFilter.dart';
import '../../../../widgets/MySFDataGridItemTable.dart';
import '../../../../widgets/MySubmitButton.dart';
import '../../../../widgets/MyTextField.dart';
import '../../../../widgets/flutter_shortcut_widget.dart';
import '../../../../widgets/my_search_field/my_search_field.dart';

class AddWarpSaleReturn extends StatefulWidget {
  final Map? value;

  const AddWarpSaleReturn({
    super.key,
    this.value,
  });

  static const String routeName = '/add_warp_sale_return';

  @override
  State<AddWarpSaleReturn> createState() => _State();
}

class _State extends State<AddWarpSaleReturn> {
  TextEditingController idController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  TextEditingController firmController = TextEditingController();
  Rxn<LedgerModel> customerName = Rxn<LedgerModel>();
  TextEditingController customerController = TextEditingController();
  Rxn<WarpSaleReturnSlipNoModel> slipNoValue = Rxn<WarpSaleReturnSlipNoModel>();
  TextEditingController slipNoController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final WarpSaleReturnController controller =
      Get.put(WarpSaleReturnController());
  final DataGridController _dataGridController = DataGridController();

  RxBool isUpdate = RxBool(false);
  final FocusNode _firmFocusNode = FocusNode();
  final FocusNode _customerNameFocusNode = FocusNode();
  final FocusNode _slipNoFocusNode = FocusNode();
  final FocusNode _returnDateFocusNode = FocusNode();

  late ItemDataSource dataSource;
  var itemList = <dynamic>[];

  /// this details used for update purpose only
  int? challanNo;
  int? referId;

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
    dataSource = ItemDataSource(list: itemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpSaleReturnController>(builder: (controller) {
      return ShortCutWidget(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyR, control: true):
              RemoveIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            RemoveIntent: SetCounterAction(perform: () {
              removeSelectedItems();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: Form(
              key: _formKey,
              child: Container(
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
                        MySearchField(
                          label: 'Firm',
                          enabled: !isUpdate.value,
                          items: controller.firmDropdown,
                          textController: firmController,
                          focusNode: _firmFocusNode,
                          requestFocus: _customerNameFocusNode,
                          onChanged: (FirmModel item) {
                            firmName.value = item;
                          },
                        ),
                        MySearchField(
                          width: 350,
                          label: 'Customer',
                          items: controller.ledgerDropdown,
                          textController: customerController,
                          focusNode: _customerNameFocusNode,
                          requestFocus: _slipNoFocusNode,
                          enabled: !isUpdate.value,
                          onChanged: (LedgerModel item) async {
                            customerName.value = item;
                            _apiCalls();
                          },
                        ),
                        MySearchField(
                          label: "Slip No",
                          enabled: !isUpdate.value,
                          isValidate: !isUpdate.value,
                          items: controller.slipNoDropdown,
                          textController: slipNoController,
                          focusNode: _slipNoFocusNode,
                          requestFocus: _returnDateFocusNode,
                          onChanged: (WarpSaleReturnSlipNoModel value) {
                            slipNoValue.value = value;

                            _selectedSlipNoDisplay(value);
                          },
                        ),
                        MyDateFilter(
                          width: 160,
                          focusNode: _returnDateFocusNode,
                          controller: dateController,
                          labelText: "Return Date",
                        ),
                        MyTextField(
                          controller: detailsController,
                          hintText: "Details",
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: MyAddItemsRemoveButton(
                          onPressed: () => removeSelectedItems()),
                    ),
                    const SizedBox(height: 12),
                    Flexible(child: itemsTable()),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        crateAndUpdatedBy(),
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
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      double netTotal = 0;

      for (var e in itemList) {
        netTotal += e["amount"];
      }

      var request = {
        "credit_note_type": "Warp sale return",
        "firm_id": firmName.value?.id,
        "customer_id": customerName.value?.id,
        "slip_no": slipNoValue.value?.id,
        "e_date": dateController.text,
        "details": detailsController.text,
        "net_total": netTotal,
        "round_off": 0,
      };

      request['item_details'] = itemList;

      var id = idController.text;
      if (id.isEmpty) {
        controller.add(request);
      } else {
        request["refer_id"] = referId;
        request["challan_no"] = challanNo;
        controller.edit(request, id);
      }
    }
  }

  void _initValue() async {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");

    if (widget.value != null && widget.value!.isNotEmpty) {
      isUpdate.value = true;

      var id = widget.value!["id"];
      referId = widget.value!['refer_id'];
      challanNo = widget.value!['challan_no'];
      var item = await controller.selectedDebitNoteDetails(id);
      if (item != null) {
        idController.text = "${item["id"]}";
        firmName.value =
            FirmModel(id: item["firm_id"], firmName: item["firm_name"]);
        firmController.text = item["firm_name"];

        customerName.value = LedgerModel(
            id: item["customer_id"], ledgerName: item["customer_name"]);
        customerController.text = "${item["customer_name"]}";

        slipNoValue.value = WarpSaleReturnSlipNoModel(id: item["slip_no"]);
        slipNoController.text = "${item["slip_no"]}";

        dateController.text = item["e_date"] ?? "";

        /// get created by and updated by details
        DateTime createDate =
            DateTime.parse(item["created_at"] ?? "0000-00-00");
        DateTime updateDate =
            DateTime.parse(item["updated_at"] ?? "0000-00-00");
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
          itemList.add(request);

          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        });
      }
    }
  }

  Widget itemsTable() {
    return MySFDataGridItemTable(
      controller: _dataGridController,
      selectionMode: SelectionMode.single,
      scrollPhysics: const ScrollPhysics(),
      shrinkWrapRows: false,
      source: dataSource,
      columns: [
        GridColumn(
          columnName: 'warp_design_name',
          label: const MyDataGridHeader(title: 'Warp Design'),
        ),
        GridColumn(
          width: 110,
          columnName: 'warp_type',
          label: const MyDataGridHeader(title: 'Warp Type'),
        ),
        GridColumn(
          width: 160,
          columnName: 'warp_id',
          label: const MyDataGridHeader(title: 'Warp ID'),
        ),
        GridColumn(
          width: 60,
          columnName: 'product_qty',
          label: const MyDataGridHeader(
            title: 'Qyt',
            alignment: Alignment.center,
          ),
        ),
        GridColumn(
          width: 80,
          columnName: 'meter',
          label: const MyDataGridHeader(
            title: 'Meter',
            alignment: Alignment.center,
          ),
        ),
        GridColumn(
          width: 80,
          columnName: 'sheet',
          label: const MyDataGridHeader(
            title: 'Sheet',
            alignment: Alignment.center,
          ),
        ),
        GridColumn(
          columnName: 'warp_color',
          label: const MyDataGridHeader(title: 'Warp Color'),
        ),
        GridColumn(
          columnName: 'details',
          label: const MyDataGridHeader(title: 'Details'),
        ),
        GridColumn(
          visible: false,
          width: 120,
          columnName: 'warp_weight',
          label: const MyDataGridHeader(
            title: 'Weight',
            alignment: Alignment.center,
          ),
        ),
        GridColumn(
          width: 120,
          columnName: 'amount',
          label: const MyDataGridHeader(
            title: 'Amount(Rs)',
            alignment: Alignment.center,
          ),
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
              name: 'meter',
              columnName: 'meter',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'sheet',
              columnName: 'sheet',
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
      /* onRowSelected: (index) async {
        var item = itemList[index];
        var result = await Get.to(() => const WarpSaleReturnBottomSheet(),
            arguments: {'item': item});
        if (result != null) {
          itemList[index] = result;
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        }
      },*/
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

  void _selectedSlipNoDisplay(WarpSaleReturnSlipNoModel item) {
    itemList.clear();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();

    item.itemDetails?.forEach((element) {
      var request = element.toJson();
      itemList.add(request);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    });
  }

  void _apiCalls() {
    itemList.clear();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
    slipNoValue.value = null;
    slipNoController.text = "";

    controller.slipNoDetails(
        "Warp sale return", firmName.value?.id, customerName.value?.id);
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
            columnName: 'warp_design_name', value: e['warp_design_name']),
        DataGridCell<dynamic>(columnName: 'warp_type', value: e['warp_type']),
        DataGridCell<dynamic>(columnName: 'warp_id', value: e['warp_id']),
        DataGridCell<dynamic>(
            columnName: 'product_qty', value: e['product_qty']),
        DataGridCell<dynamic>(columnName: 'meter', value: e['meter']),
        DataGridCell<dynamic>(columnName: 'sheet', value: e['sheet']),
        DataGridCell<dynamic>(
            columnName: 'warp_color', value: e['warp_color'] ?? ''),
        DataGridCell<dynamic>(columnName: 'details', value: e['details'] ?? ''),
        DataGridCell<dynamic>(
            columnName: 'warp_weight', value: e['warp_weight']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['amount']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      var amount = "";
      if (e.columnName == "amount") {
        amount = formater("${e.value}");
      }

      return Container(
        padding: const EdgeInsets.all(8),
        alignment: (e.columnName == "meter" ||
                e.columnName == "sheet" ||
                e.columnName == "product_qty" ||
                e.columnName == "product_qty" ||
                e.columnName == "warp_weight")
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Text(
          e.columnName == "amount"
              ? amount
              : e.value != null
                  ? '${e.value}'
                  : '',
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
    var e = summaryColumn?.columnName;

    var amount = "";
    if (e == "amount") {
      amount = formater(summaryValue);
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: (e == "meter" ||
              e == "sheet" ||
              e == "product_qty" ||
              e == "amount" ||
              e == "warp_weight")
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Text(
        e == "amount" ? amount : summaryValue,
        style: AppUtils.footerTextStyle(),
      ),
    );
  }

  String formater(String value) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      decimalDigits: 2,
      name: '',
    );
    double amount = double.tryParse(value) ?? 0.0;

    return formatter.format(amount);
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
