import 'package:abtxt/model/ProductDeliverToProcessor.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/product_deliver_to_process/product_deliver_to_process_bottomsheet.dart';
import 'package:abtxt/view/trasaction/product_deliver_to_process/product_deliver_to_process_bottomsheet_two.dart';
import 'package:abtxt/view/trasaction/product_deliver_to_process/product_deliver_to_process_controller.dart';
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
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../basics/ledger/addledger.dart';

class AddProductDeliverToProcess extends StatefulWidget {
  const AddProductDeliverToProcess({super.key});

  static const String routeName = '/Add_Product_Deliver_To_Process';

  @override
  State<AddProductDeliverToProcess> createState() => _State();
}

class _State extends State<AddProductDeliverToProcess> {
  TextEditingController idController = TextEditingController();
  TextEditingController firmNameController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  TextEditingController dcNoController = TextEditingController();
  Rxn<LedgerModel> process = Rxn<LedgerModel>();
  TextEditingController processController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController balesController = TextEditingController(text: "0");
  TextEditingController transportController = TextEditingController();
  TextEditingController vehicleNoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late ProductDeliverToProcessController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var itemList = <dynamic>[];
  late ProcessDeliveryItemDataSource dataSource;
  RxBool isUpdate = RxBool(false);
  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _processorFocusNode = FocusNode();
  var shortCut = RxString("");

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
    _processorFocusNode.addListener(() => shortCutKeys());
    super.initState();
    dataSource = ProcessDeliveryItemDataSource(list: itemList);
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_firstInputFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDeliverToProcessController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        scaffoldKey: _scaffoldKey,
        endDrawer: Container(
          color: Colors.white10.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Drawer(
                width: 520,
                child: ProductDeliverToProcessBottomSheet(
                  dataGridSource: dataSource,
                  itemDetails: itemList,
                  balesCalculation: itemDetailsCalculation,
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Product Deliver To Process"),
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
                onPressed: () {
                  _print();
                },
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
                          autofocus: false,
                          label: 'Firm',
                          items: controller.firmName,
                          selectedItem: firmName.value,
                          enabled: !isUpdate.value,
                          onChanged: (FirmModel item) {
                            firmName.value = item;
                          },
                        ),
                        Visibility(
                          visible: dcNoController.text.isNotEmpty,
                          child: MyTextField(
                            controller: dcNoController,
                            hintText: "DC No",
                            enabled: !isUpdate.value,
                            autofocus: false,
                          ),
                        ),
                        Focus(
                          focusNode: _processorFocusNode,
                          skipTraversal: true,
                          child: MyAutoComplete(
                            autofocus: true,
                            label: 'Processor Name',
                            items: controller.processName,
                            selectedItem: process.value,
                            enabled: !isUpdate.value,
                            onChanged: (LedgerModel item) async {
                              process.value = item;
                            },
                          ),
                        ),
                        MyDateFilter(
                          controller: dateController,
                          labelText: "Date",
                          focusNode: _firstInputFocusNode,
                        ),
                        MyTextField(
                          controller: transportController,
                          hintText: "Transport",
                        ),
                        MyTextField(
                          controller: vehicleNoController,
                          hintText: "Vehicle No",
                        ),
                        ExcludeFocusTraversal(
                          child: MyTextField(
                            controller: balesController,
                            hintText: "Bales",
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
      );
    });
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "firm_id": firmName.value?.id,
        "processor_id": process.value?.id,
        "e_date": dateController.text,
        "details": detailsController.text,
        "no_of_bales": int.tryParse(balesController.text) ?? 0,
        "transport": transportController.text,
        "vehicle_no": vehicleNoController.text,
      };
      var processorItemList = [];

      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "process_type": itemList[i]['process_type'],
          "product_id": itemList[i]['product_id'],
          "work_no": itemList[i]['work_no'],
          "pieces": itemList[i]['pieces'],
          "quantity": itemList[i]['quantity'],
          "rate": itemList[i]['rate'],
          "amount": itemList[i]['amount'],
          "bags": itemList[i]['bags'],
          "details": itemList[i]['details'],
          "agent_name": itemList[i]['agent_name'],
        };
        processorItemList.add(item);
      }
      request['item_details'] = processorItemList;

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
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    ProductDeliverToProcessController controller = Get.find();
    firmName.value = AppUtils.setDefaultFirmName(controller.firmName);

    if (Get.arguments != null) {
      isUpdate.value = true;
      ProductDeliverToProcessController controller = Get.find();
      var item = ProductDeliverToProcessor.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      dateController.text = '${item.eDate}';
      balesController.text = '${item.noOfBales}';
      detailsController.text = item.details ?? '';
      dcNoController.text = "${item.dcNo}";
      transportController.text = item.transport ?? '';
      vehicleNoController.text = item.vehicleNo ?? '';

      var firmNameList = controller.firmName
          .where((element) => '${element.id}' == '${item.firmId}')
          .toList();
      if (firmNameList.isNotEmpty) {
        firmName.value = firmNameList.first;
        firmNameController.text = '${firmNameList.first.firmName}';
      }
      var processList = controller.processName
          .where((element) => '${element.id}' == '${item.processorId}')
          .toList();
      if (processList.isNotEmpty) {
        process.value = processList.first;
        processController.text = '${processList.first.ledgerName}';
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
        itemList.add(request);
      });
    }
  }

  Widget itemsTable() {
    return ExcludeFocusTraversal(
      child: MySFDataGridItemTable(
        shrinkWrapRows: false,
        scrollPhysics: const ScrollPhysics(),
        controller: _dataGridController,
        selectionMode: SelectionMode.single,
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
            visible: false,
            columnName: 'design_no',
            label: const MyDataGridHeader(title: 'Design No'),
          ),
          GridColumn(
            visible: false,
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
            visible: false,
            width: 120,
            columnName: 'rate',
            label: const MyDataGridHeader(title: 'Rate(Rs)'),
          ),
          GridColumn(
            visible: false,
            width: 120,
            columnName: 'amount',
            label: const MyDataGridHeader(title: 'Amount(Rs)'),
          ),
          GridColumn(
            width: 120,
            columnName: 'bags',
            label: const MyDataGridHeader(title: 'Bags'),
          ),
          GridColumn(
            columnName: 'details',
            label: const MyDataGridHeader(title: 'Details'),
          ),
          GridColumn(
            columnName: 'agent_name',
            label: const MyDataGridHeader(title: 'Agent Name'),
          ),
        ],
        tableSummaryRows: [
          GridTableSummaryRow(
            showSummaryInRow: false,
            title: 'Total: ',
            titleColumnSpan: 1,
            columns: [
              const GridSummaryColumn(
                name: 'quantity',
                columnName: 'quantity',
                summaryType: GridSummaryType.sum,
              ),
              const GridSummaryColumn(
                name: 'bags',
                columnName: 'bags',
                summaryType: GridSummaryType.sum,
              ),
            ],
            position: GridTableSummaryRowPosition.bottom,
          ),
        ],
        source: dataSource,
        onRowSelected: (index) async {
          var item = itemList[index];
          controller.slipId = int.tryParse(idController.text);
          var result = await Get.to(
              () => const ProductDeliverToProcessBottomSheetTwo(),
              arguments: {"item": item});
          if (result != null) {
            itemList[index] = result;
            itemDetailsCalculation();
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
      itemList.removeAt(index);
      itemDetailsCalculation();
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
      _dataGridController.selectedIndex = -1;
    } else {
      AppUtils.infoAlert(message: "Select The Value");
    }
  }

  void _addItem() async {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }

    var request = {'id': idController.text};
    String? response = await controller.processDeliveryReport(request: request);

    if (response != null) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }

  shortCutKeys() {
    if (_processorFocusNode.hasFocus && Get.arguments == null) {
      shortCut.value = "To Create 'Processor',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  navigateAnotherPage() async {
    if (_processorFocusNode.hasFocus && Get.arguments == null) {
      var result = await Get.toNamed(AddLedger.routeName);

      if (result == "success") {
        debugPrint("True");
        controller.processTypeInfo();
      }
    }
  }

  void itemDetailsCalculation() {
    int bags = 0;
    for (var element in itemList) {
      bags += int.tryParse("${element["bags"]}") ?? 0;
    }
    balesController.text = "$bags";
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

class ProcessDeliveryItemDataSource extends DataGridSource {
  ProcessDeliveryItemDataSource({required List<dynamic> list}) {
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
        DataGridCell<dynamic>(columnName: 'pieces', value: e['pieces']),
        DataGridCell<dynamic>(columnName: 'quantity', value: e['quantity']),
        DataGridCell<dynamic>(columnName: 'rate', value: e['rate']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['amount']),
        DataGridCell<dynamic>(columnName: 'bags', value: e['bags']),
        DataGridCell<dynamic>(columnName: 'details', value: e['details']),
        DataGridCell<dynamic>(columnName: 'agent_name', value: e['agent_name']),
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
        case 'bags':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'quantity':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'rate':
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
      case 'bags':
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
