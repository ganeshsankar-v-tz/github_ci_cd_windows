import 'package:abtxt/model/DropModel.dart';
import 'package:abtxt/model/JobWorkerDcNoIdByDetails.dart';
import 'package:abtxt/model/ProductInwardFromJobWorkerModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/product_inward_from_jobworker/product_inward_from_jobworker_bottomsheet.dart';
import 'package:abtxt/view/trasaction/product_inward_from_jobworker/product_inward_from_jobworker_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:abtxt/widgets/my_autocompletes/jobWorker_dcNo_autoComplete.dart';
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

class AddProductInwardFromJobWorker extends StatefulWidget {
  const AddProductInwardFromJobWorker({super.key});

  static const String routeName = '/Add_Product_Inward_FromJobWorker';

  @override
  State<AddProductInwardFromJobWorker> createState() => _State();
}

class _State extends State<AddProductInwardFromJobWorker> {
  TextEditingController idController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  Rxn<LedgerModel> accountType = Rxn<LedgerModel>();
  TextEditingController dcNoController = TextEditingController();
  Rxn<DropModel> dcNumber = Rxn<DropModel>();
  Rxn<LedgerModel> jobWorker = Rxn<LedgerModel>();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController refNoController = TextEditingController();
  TextEditingController balanceController =
      TextEditingController(text: "Pending");
  RxDouble totalWages = RxDouble(0);

  final _formKey = GlobalKey<FormState>();
  ProductInwardFromJobWorkerController controller = Get.find();

  late ItemDataSource dataSource;
  RxBool isUpdate = RxBool(false);

  final DataGridController _dataGridController = DataGridController();

  /// created by and updated by details controllers
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? displayName;
  String? displayDate;

  final FocusNode _firstInputFocusNode = FocusNode();

  @override
  void initState() {
    controller.itemList.clear();
    controller.dcRecNo = null;
    controller.dcNo.clear();
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
    return GetBuilder<ProductInwardFromJobWorkerController>(
        builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Product Inward From JobWorker"),
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
        loadingStatus: controller.status.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyP, control: true):
              PrintIntent(),
          SingleActivator(LogicalKeyboardKey.keyR, control: true):
              RemoveIntent(),
          SingleActivator(LogicalKeyboardKey.keyN, control: true):
              AddNewIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            PrintIntent: SetCounterAction(perform: () {
              _print();
            }),
            RemoveIntent: SetCounterAction(perform: () {
              removeSelectedItems();
            }),
            AddNewIntent: SetCounterAction(perform: () => _addItem()),
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
                            items: controller.firmNameList,
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
                          MyAutoComplete(
                            label: 'JobWorker Name',
                            items: controller.jobWorkerName,
                            selectedItem: jobWorker.value,
                            enabled: !isUpdate.value,
                            textInputAction: TextInputAction.none,
                            onChanged: (LedgerModel item) async {
                              jobWorker.value = item;
                              controller.itemList.clear();
                              dataSource.updateDataGridRows();
                              dataSource.updateDataGridSource();
                              controller.dcNo.clear();
                              dcNumber.value = null;
                              await controller.dcNoInfo(item.id);
                            },
                          ),
                          JobWorkerDcNoDropDown(
                            label: 'Dc No',
                            items: controller.dcNo,
                            enabled: !isUpdate.value,
                            selectedItem: dcNumber.value,
                            onChanged: (JobWorkerIdByDcNo item) async {
                              dcNumber.value =
                                  DropModel(id: item.id!, name: "${item.dcNo}");
                              controller.itemList.clear();
                              dataSource.updateDataGridRows();
                              dataSource.updateDataGridSource();
                              controller.dcNoBuOrderedWorksDetails(item.id);
                              var list =
                                  await controller.dcNoIdByDetails(item.id);
                              dcNoValueDisplay(list);
                            },
                          ),
                          MyDateFilter(
                            focusNode: _firstInputFocusNode,
                            controller: dateController,
                            labelText: 'Date',
                          ),
                          MyTextField(
                            controller: refNoController,
                            hintText: "Ref No",
                            validate: "number",
                          ),
                          MyTextField(
                            controller: detailsController,
                            hintText: "Details",
                          ),
                          MyDropdownButtonFormField(
                            controller: balanceController,
                            hintText: "Balance",
                            items: const ["Pending", "Paid"],
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
        ),
      );
    });
  }

  void _addItem() async {
    controller.dcRecNo = dcNumber.value?.id;
    var result = await Get.to(const ProductInwardFromJobWorkerBottomSheet());
    if (result != null) {
      controller.itemList.add(result);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    }
  }

  Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }

    var request = {'id': idController.text};

    String? response = await controller.jobWorkInwardReport(request: request);

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
        "firm_id": firmName.value?.id,
        "job_worker_id": jobWorker.value?.id,
        "e_date": dateController.text,
        "details": detailsController.text,
        "wages_ano": accountType.value?.id,
        "ref_no": refNoController.text,
        "pmt_sts": balanceController.text,
        "totel_wages": totalWages.value,
        "deli_rec_no": dcNumber.value?.id,
      };
      request['item_details'] = controller.itemList;

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
    ProductInwardFromJobWorkerController controller = Get.find();
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    accountType.value = AppUtils.findLedgerAccountByName(
        controller.accountDropDown, 'JobWork Wages');
    firmName.value = AppUtils.setDefaultFirmName(controller.firmNameList);
    if (Get.arguments != null) {
      isUpdate.value = true;
      var item =
          ProductInwardFromJobWorkerModel.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      dateController.text = item.eDate ?? '';
      refNoController.text = tryCast(item.refNo);
      detailsController.text = item.details ?? '';
      balanceController.text = "${item.pmtSts}";
      dcNoController.text = "${item.dcNo}";

      dcNumber.value = DropModel(id: item.deliRecNo!, name: '${item.dcNo}');

      var firmNameList = controller.firmNameList
          .where((element) => '${element.id}' == '${item.firmId}')
          .toList();
      if (firmNameList.isNotEmpty) {
        firmName.value = firmNameList.first;
      }
      var accountList = controller.accountDropDown
          .where((element) => '${element.id}' == '${item.wagesAno}')
          .toList();
      if (accountList.isNotEmpty) {
        accountType.value = accountList.first;
      }
      var jobWorkerList = controller.jobWorkerName
          .where((element) => '${element.id}' == '${item.jobWorkerId}')
          .toList();
      if (jobWorkerList.isNotEmpty) {
        jobWorker.value = jobWorkerList.first;
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
        totalWages.value += double.tryParse("${element.wages}") ?? 0.00;
        var request = element.toJson();
        controller.itemList.add(request);
      });

      // get the DC rec no by delivered details
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        controller.dcNoBuOrderedWorksDetails(item.deliRecNo);
        controller.dcRecNo = item.deliRecNo;
      });
    }
  }

  void dcNoValueDisplay(List<JobWorkerDcNoIdByDetails> list) {
    controller.itemList.clear();
    totalWages.value = 0;
    for (var element in list) {
      totalWages.value += double.tryParse("${element.wages}") ?? 0.00;
      controller.itemList.add(element.toJson());
    }
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
  }

  Widget itemsTable() {
    return MySFDataGridItemTable(
      selectionMode: SelectionMode.single,
      controller: _dataGridController,
      columns: [
        GridColumn(
          columnName: 'ordered_work',
          label: const MyDataGridHeader(title: 'Ordered Work'),
        ),
        GridColumn(
          columnName: 'product_name',
          label: const MyDataGridHeader(title: 'Product Name'),
        ),
        GridColumn(
          width: 100,
          columnName: 'design_no',
          label: const MyDataGridHeader(title: 'Design No'),
        ),
        GridColumn(
          width: 100,
          columnName: 'work',
          label: const MyDataGridHeader(title: 'Work'),
        ),
        GridColumn(
          width: 100,
          columnName: 'pieces',
          label: const MyDataGridHeader(title: 'Pieces'),
        ),
        GridColumn(
          width: 100,
          columnName: 'qty',
          label: const MyDataGridHeader(title: 'Quantity'),
        ),
        GridColumn(
          width: 100,
          columnName: 'wages',
          label: const MyDataGridHeader(title: 'Wages(Rs)'),
        ),
        GridColumn(
          width: 100,
          columnName: 'amount',
          label: const MyDataGridHeader(title: 'Amount(Rs)'),
        ),
        GridColumn(
          width: 140,
          columnName: 'inw_typ',
          label: const MyDataGridHeader(title: 'Inward type'),
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
              name: 'qty',
              columnName: 'qty',
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
      onRowSelected: (index) async {
        var item = controller.itemList[index];
        var result = await Get.to(const ProductInwardFromJobWorkerBottomSheet(),
            arguments: {'item': item});
        if (result != null) {
          controller.itemList[index] = result;
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        }
      },
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
        DataGridCell<dynamic>(
            columnName: 'ordered_work', value: e['work_name']),
        DataGridCell<dynamic>(
            columnName: 'product_name', value: e['product_name']),
        DataGridCell<dynamic>(columnName: 'design_no', value: e['design_no']),
        DataGridCell<dynamic>(columnName: 'work', value: e['work_no']),
        DataGridCell<dynamic>(columnName: 'pieces', value: e['pieces']),
        DataGridCell<dynamic>(columnName: 'qty', value: e['qty']),
        DataGridCell<dynamic>(columnName: 'wages', value: e['wages']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['amount']),
        DataGridCell<dynamic>(columnName: 'inw_typ', value: e['inw_typ']),
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
        case 'qty':
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
      case 'qty':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'amount':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      default:
        /*   alignment = TextAlign.left;
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
