import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/product_order/product_order_bottom_sheet.dart';
import 'package:abtxt/view/trasaction/product_order/product_order_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
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
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MySubmitButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../basics/ledger/addledger.dart';

class AddProductOrder extends StatefulWidget {
  const AddProductOrder({super.key});

  static const String routeName = '/add_product_order';

  @override
  State<AddProductOrder> createState() => _State();
}

class _State extends State<AddProductOrder> {
  TextEditingController idController = TextEditingController();
  TextEditingController orderNoController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  Rxn<LedgerModel> customerName = Rxn<LedgerModel>();
  TextEditingController orderDateController = TextEditingController();
  TextEditingController transportController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  var enquiryFromController = TextEditingController(text: "Direct");
  var enquiryInfoController = TextEditingController();

  late ProductOrderItemDataSource dataSource;

  final _formKey = GlobalKey<FormState>();
  final ProductOrderController controller = Get.find();

  RxBool isUpdate = RxBool(false);
  final FocusNode _customerNameFocusNode = FocusNode();
  final FocusNode _firstInputFocusNode = FocusNode();
  var shortCut = RxString("");

  final DataGridController _dataGridController = DataGridController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    controller.itemList.clear();
    _customerNameFocusNode.addListener(() => shortCutKeys());
    _initValue();
    super.initState();
    dataSource = ProductOrderItemDataSource(list: controller.itemList);
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_firstInputFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductOrderController>(builder: (controller) {
      return ShortCutWidget(
        scaffoldKey: _scaffoldKey,
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Product Order"),
          actions: [
            Visibility(
                visible: idController.text.isNotEmpty,
                child: MyDeleteIconButton(
                  onPressed: (password) {
                    controller.delete(idController.text, password);
                  },
                )),
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
        //
        endDrawer: Container(
          color: Colors.white10.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Drawer(
                width: 520,
                child: AddProductOrderBottomSheet(
                  dataSource: dataSource,
                ),
              ),
            ],
          ),
        ),

        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyP, control: true):
              PrintIntent(),
          SingleActivator(LogicalKeyboardKey.keyR, control: true):
              RemoveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
          SingleActivator(LogicalKeyboardKey.keyN, control: true):
              AddNewIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: WillPopScope(
          onWillPop: () async {
            getBackAlert();
            return false;
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              GetBackIntent: SetCounterAction(perform: () => getBackAlert()),
              SaveIntent: SetCounterAction(perform: () => submit()),
              PrintIntent: SetCounterAction(perform: () => _print()),
              RemoveIntent:
                  SetCounterAction(perform: () => removeSelectedItems()),
              NavigateIntent:
                  SetCounterAction(perform: () => navigateAnotherPage()),
              AddNewIntent: SetCounterAction(perform: () => _addItem()),
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
                          MyAutoComplete(
                            label: 'Firm',
                            autofocus: false,
                            selectedItem: firmName.value,
                            items: controller.firmDropdown,
                            onChanged: (FirmModel item) {
                              firmName.value = item;
                            },
                          ),
                          Focus(
                            focusNode: _customerNameFocusNode,
                            skipTraversal: true,
                            child: MyAutoComplete(
                              enabled: !isUpdate.value,
                              label: 'Customer Name',
                              items: controller.customerName,
                              selectedItem: customerName.value,
                              onChanged: (LedgerModel item) async {
                                customerName.value = item;
                                controller.customerId = item.id;
                              },
                            ),
                          ),
                          MyDateFilter(
                            focusNode: _firstInputFocusNode,
                            width: 160,
                            controller: orderDateController,
                            labelText: "Order Date",
                          ),
                          MyTextField(
                            controller: transportController,
                            hintText: "Transport",
                          ),
                          MyTextField(
                            controller: detailsController,
                            hintText: "Details",
                          ),
                          MyDropdownButtonFormField(
                            controller: enquiryFromController,
                            hintText: "Enquiry Info",
                            width: 120,
                            items: const [
                              "Direct",
                              "Online",
                              "E-mail",
                            ],
                          ),
                          MyTextField(
                            controller: enquiryInfoController,
                            hintText: "Enquiry Info",
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
        ),
      );
    });
  }

  Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }

    var request = {'id': idController.text};
    String? response = await controller.productOrderPdf(request: request);
    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }

  void shortCutKeys() {
    if (_customerNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Customer',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_customerNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddLedger.routeName);

      if (result == "success") {
        controller.customerInfo();
      }
    }
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "customer_id": customerName.value?.id,
        "firm_id": firmName.value?.id,
        "e_date": orderDateController.text,
        "transport": transportController.text,
        "details": detailsController.text,
        "enquiry_from": enquiryFromController.text,
        "enquiry_info": enquiryInfoController.text,
      };
      request['product_order_details'] = controller.itemList;

      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        controller.add(request);
      } else {
        request["order_no"] = orderNoController.text;
        request['id'] = int.tryParse(id);
        controller.edit(request);
      }
    }
  }

  void _initValue() {
    orderDateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    firmName.value = AppUtils.setDefaultFirmName(controller.firmDropdown);

    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = Get.arguments['item'];
      idController.text = tryCast(item['id']);
      detailsController.text = tryCast(item['details']);
      controller.customerId = item["customer_id"];
      transportController.text = item["transport"] ?? "";
      orderNoController.text = "${item["order_no"]}";

      customerName.value = LedgerModel(
          id: item["customer_id"], ledgerName: item["customer_name"]);
      firmName.value =
          FirmModel(id: item["firm_id"], firmName: item["firm_name"]);

      item["product_order_details"]?.forEach((element) {
        controller.itemList.add(element);
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
          minimumWidth: 250,
          columnName: 'product_name',
          label: const MyDataGridHeader(title: 'Product Name'),
        ),
        GridColumn(
          width: 80,
          columnName: 'quantity',
          label:
              const MyDataGridHeader(alignment: Alignment.center, title: 'Qty'),
        ),
        GridColumn(
          width: 100,
          columnName: 'rate',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Rate'),
        ),
        GridColumn(
          width: 110,
          columnName: 'discount_per',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Discount ( % ) '),
        ),
        GridColumn(
          width: 120,
          columnName: 'discount',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Discount ( Rs. ) '),
        ),
        GridColumn(
          width: 120,
          columnName: 'amount',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Amount'),
        ),
        GridColumn(
          minimumWidth: 250,
          columnName: 'details',
          label: const MyDataGridHeader(title: 'Details'),
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

  void removeItem(index) {
    Get.defaultDialog(
      barrierDismissible: false,
      title: 'ALERT!',
      titleStyle: const TextStyle(color: Colors.red, fontSize: 18),
      radius: 10,
      content: const Text("Are you sure you want to remove?"),
      actions: <Widget>[
        TextButton(
          child: const Text("CLOSE"),
          onPressed: () => Get.back(),
        ),
        TextButton(
          autofocus: true,
          onPressed: () {
            Get.back();
            controller.itemList.removeAt(index);
            dataSource.updateDataGridRows();
            dataSource.updateDataGridSource();
          },
          child: const Text("REMOVE"),
        ),
      ],
    );
  }

  void _addItem() async {
    if (customerName.value == null) {
      return;
    }

    _scaffoldKey.currentState!.openEndDrawer();
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

  Future<void> getBackAlert() async {
    if (controller.getBackBoolean.value == true) {
      await AppUtils.showExitDialog(context) == true ? submit() : '';
    } else {
      Get.back();
    }
  }
}

class ProductOrderItemDataSource extends DataGridSource {
  ProductOrderItemDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(
            columnName: 'product_name', value: e['product_name']),
        DataGridCell<dynamic>(columnName: 'quantity', value: e['quantity']),
        DataGridCell<dynamic>(columnName: 'rate', value: e['rate']),
        DataGridCell<dynamic>(columnName: 'discount_per', value: e['discount_per']),
        DataGridCell<dynamic>(columnName: 'discount', value: e['discount']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['total_amount']),
        DataGridCell<dynamic>(columnName: 'details', value: e['details']),
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
        case 'amount':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'rate':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'discount':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'discount_per':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'quantity':
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
      case 'amount':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      case 'quantity':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
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
