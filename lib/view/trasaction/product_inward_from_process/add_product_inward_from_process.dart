import 'package:abtxt/model/ProcessorDcNoIdByDetailsModel.dart';
import 'package:abtxt/model/ProductInwardFromProcessModel.dart';
import 'package:abtxt/view/trasaction/product_inward_from_process/product_inward_from_jprocess_bottomsheet.dart';
import 'package:abtxt/view/trasaction/product_inward_from_process/product_inward_from_process_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:abtxt/widgets/my_search_field/processer_dc_no_searchField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/DropModel.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class AddProductInwardFromProcess extends StatefulWidget {
  const AddProductInwardFromProcess({super.key});

  static const String routeName = '/Add_Product_Inward_From_Process';

  @override
  State<AddProductInwardFromProcess> createState() => _State();
}

class _State extends State<AddProductInwardFromProcess> {
  TextEditingController idController = TextEditingController();
  TextEditingController firmNameController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  TextEditingController accountNameController = TextEditingController();
  Rxn<LedgerModel> accountType = Rxn<LedgerModel>();
  Rxn<DropModel> dcNumber = Rxn<DropModel>();
  TextEditingController processorController = TextEditingController();
  Rxn<LedgerModel> processor = Rxn<LedgerModel>();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController refNoController = TextEditingController();
  TextEditingController paymentController =
      TextEditingController(text: "Pending");
  var dcNoTextController = TextEditingController();

  RxDouble totalWages = RxDouble(0);

  final _formKey = GlobalKey<FormState>();
  ProductInwardFromProcessController controller = Get.find();

  late ProcessInwardItemDataSource dataSource;
  RxBool isUpdate = RxBool(false);
  final DataGridController _dataGridController = DataGridController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// created by and updated by details controllers
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? displayName;
  String? displayDate;

  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _dcNoFocusNode = FocusNode();
  final FocusNode _processorNameFocusNode = FocusNode();

  @override
  void initState() {
    controller.itemList.clear();
    controller.dcNo.clear();
    controller.dcRecNo = null;
    _initValue();
    super.initState();
    dataSource = ProcessInwardItemDataSource(list: controller.itemList);
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_firstInputFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductInwardFromProcessController>(
        builder: (controller) {
      return ShortCutWidget(
        scaffoldKey: _scaffoldKey,
        endDrawer: Container(
          color: Colors.white10.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Drawer(
                width: 520,
                child: ProductInwardFromProcessBottomSheet(
                  dataSource: dataSource,
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Product Inward From Process"),
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
            // Visibility(
            //   visible: dcNumber.value != null,
            //   child: MyPrintButton(
            //     onPressed: () => _print(),
            //   ),
            // ),
            const SizedBox(width: 12),
          ],
        ),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyN, control: true):
              AddNewIntent(),
          // SingleActivator(LogicalKeyboardKey.keyP, control: true): PrintIntent(),
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
            /* PrintIntent: SetCounterAction(perform: () {
              _print();
            }),*/
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
                          label: 'Firm Name',
                          items: controller.firmName,
                          selectedItem: firmName.value,
                          onChanged: (FirmModel item) {
                            firmName.value = item;
                          },
                          autofocus: false,
                        ),
                        MyAutoComplete(
                          label: 'Wages Account',
                          items: controller.accountDropDown,
                          selectedItem: accountType.value,
                          enabled: !isUpdate.value,
                          onChanged: (LedgerModel item) {
                            accountType.value = item;
                          },
                          autofocus: false,
                        ),
                        MySearchField(
                          label: 'Processor Name',
                          items: controller.processorName,
                          textController: processorController,
                          focusNode: _processorNameFocusNode,
                          requestFocus: _dcNoFocusNode,
                          enabled: !isUpdate.value,
                          textInputAction: TextInputAction.none,
                          onChanged: (LedgerModel item) async {
                            processor.value = item;
                            controller.dcNo.clear();
                            controller.itemList.clear();
                            dataSource.updateDataGridRows();
                            dataSource.updateDataGridSource();
                            dcNumber.value = null;
                            dcNoTextController.text = "";
                            await controller.processorIdByDcNo(item.id);
                          },
                        ),
                        ProcessorDcNoDropDownNew(
                          label: 'Dc No',
                          items: controller.dcNo,
                          enabled: !isUpdate.value,
                          focusNode: _dcNoFocusNode,
                          requestFocus: _firstInputFocusNode,
                          textController: dcNoTextController,
                          onChanged: (ProcessorIdByDcNoModel item) async {
                            dcNumber.value =
                                DropModel(id: item.id!, name: "${item.dcNo}");

                            controller.dcNoByProcessTypesDetails(item.id);
                            controller.itemList.clear();
                            dataSource.updateDataGridRows();
                            dataSource.updateDataGridSource();
                            var list =
                                await controller.dcNoIdByDetails(item.id);
                            dcNoValueDisplay(list);
                          },
                        ),
                        MyDateFilter(
                          focusNode: _firstInputFocusNode,
                          controller: dateController,
                          labelText: "Date",
                        ),
                        MyTextField(
                          controller: refNoController,
                          hintText: "Ref No",
                          validate: "string",
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
                            onPressed: () => removeSelectedItems()),
                        AddItemsElevatedButton(
                          onPressed: () => _addItem(),
                          child: const Text('Add Item'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Flexible(child: itemsTable()),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyDropdownButtonFormField(
                            controller: paymentController,
                            hintText: "Payment",
                            items: const ["Pending", "Paid"])
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        crateAndUpdatedBy(),
                        const Spacer(),
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

  /*Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }

    var request = {'id': idController.text};
    String? response = await controller.processInwardReport(request: request);

    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }*/

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "firm_id": firmName.value?.id,
        "processor_id": processor.value?.id,
        "e_date": dateController.text,
        "details": detailsController.text,
        "wages_ano": accountType.value?.id,
        "ref_no": refNoController.text,
        "pmt_sts": paymentController.text,
        "total_wages": totalWages.value,
        "deli_rec_no": dcNumber.value?.id,
      };
      var processItemList = [];

      for (var i = 0; i < controller.itemList.length; i++) {
        var item = {
          "product_id": controller.itemList[i]["product_id"],
          "work_no": controller.itemList[i]["work_no"],
          "pieces": controller.itemList[i]["pieces"],
          "quantity": controller.itemList[i]["quantity"],
          "wages": controller.itemList[i]["wages"],
          "amount": controller.itemList[i]["amount"],
          "process_type": controller.itemList[i]["process_type"],
        };
        processItemList.add(item);
      }
      request['item_details'] = processItemList;

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
    accountType.value = AppUtils.findLedgerAccountByName(
        controller.accountDropDown, 'Process Wages');
    firmName.value = AppUtils.setDefaultFirmName(controller.firmName);

    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = ProductInwardFromProcessModel.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      dateController.text = '${item.eDate}';
      refNoController.text = '${item.refNo}';
      detailsController.text = item.details ?? '';
      paymentController.text = "${item.pmtSts}";

      dcNumber.value = DropModel(id: item.deliRecNo!, name: '${item.dcNo}');
      dcNoTextController.text = '${item.dcNo}';

      var firmNameList = controller.firmName
          .where((element) => '${element.id}' == '${item.firmId}')
          .toList();
      if (firmNameList.isNotEmpty) {
        firmName.value = firmNameList.first;
        firmNameController.text = '${firmNameList.first.firmName}';
      }
      var accountList = controller.accountDropDown
          .where((element) => '${element.id}' == '${item.wagesAno}')
          .toList();
      if (accountList.isNotEmpty) {
        accountType.value = accountList.first;
        accountNameController.text = '${accountList.first.ledgerName}';
      }
      var processorList = controller.processorName
          .where((element) => '${element.id}' == '${item.processorId}')
          .toList();
      if (processorList.isNotEmpty) {
        processor.value = processorList.first;
        processorController.text = '${processorList.first.ledgerName}';
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
        totalWages.value += double.tryParse("${element.amount}") ?? 0.00;
        var request = element.toJson();
        controller.itemList.add(request);
      });

      // get the DC rec no by delivered details
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        controller.dcNoByProcessTypesDetails(item.deliRecNo);
        controller.dcRecNo = item.deliRecNo;
      });
    }
  }

  void dcNoValueDisplay(List<ProcessorDcNoIdByDetailsModel> list) {
    controller.itemList.clear();
    totalWages.value = 0;
    for (var element in list) {
      totalWages.value += double.tryParse("${element.amount}") ?? 0.00;
      controller.itemList.add(element.toJson());
    }
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
  }

  Widget itemsTable() {
    return MySFDataGridItemTable(
      selectionMode: SelectionMode.single,
      controller: _dataGridController,
      shrinkWrapRows: false,
      scrollPhysics: const ScrollPhysics(),
      columns: [
        GridColumn(
          columnName: 'process_type',
          label: const MyDataGridHeader(title: 'Process Type'),
        ),
        GridColumn(
          columnName: 'product_name',
          label: const MyDataGridHeader(title: 'Product Name'),
        ),
        GridColumn(
          width: 150,
          columnName: 'design_no',
          label: const MyDataGridHeader(title: 'Design No'),
        ),
        GridColumn(
          visible: false,
          columnName: 'work',
          label: const MyDataGridHeader(title: 'Work'),
        ),
        GridColumn(
          width: 120,
          columnName: 'pieces',
          label: const MyDataGridHeader(title: 'Pieces'),
        ),
        GridColumn(
          width: 120,
          columnName: 'quantity',
          label: const MyDataGridHeader(title: 'Quantity'),
        ),
        GridColumn(
          width: 120,
          columnName: 'wages',
          label: const MyDataGridHeader(title: 'Wages(Rs)'),
        ),
        GridColumn(
          width: 120,
          columnName: 'amount',
          label: const MyDataGridHeader(title: 'Amount(Rs)'),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'pieces',
              columnName: 'pieces',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'quantity',
              columnName: 'quantity',
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
      source: dataSource,
    );
  }

  _addItem() {
    controller.dcRecNo = dcNumber.value?.id;
    _scaffoldKey.currentState!.openEndDrawer();
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

class ProcessInwardItemDataSource extends DataGridSource {
  ProcessInwardItemDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(
            columnName: 'process_type', value: e['process_type']),
        DataGridCell<dynamic>(
            columnName: 'product_name', value: e['product_name']),
        DataGridCell<dynamic>(columnName: 'design_no', value: e['design_no']),
        DataGridCell<dynamic>(columnName: 'work', value: e['work_no']),
        DataGridCell<dynamic>(columnName: 'pieces', value: e['pieces']),
        DataGridCell<dynamic>(columnName: 'quantity', value: e['quantity']),
        DataGridCell<dynamic>(columnName: 'wages', value: e['wages']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['amount']),
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
        case 'pieces':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'quantity':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'wages':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'amount':
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
      case 'pieces':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'quantity':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'amount':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
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
