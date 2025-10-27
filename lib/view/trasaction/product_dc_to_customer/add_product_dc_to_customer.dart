import 'package:abtxt/model/product_dc_to_customer_model.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/product_dc_to_customer/product_dc_to_customer_bottomsheet.dart';
import 'package:abtxt/view/trasaction/product_dc_to_customer/product_dc_to_customer_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../basics/ledger/addledger.dart';

class AddProductDcToCustomer extends StatefulWidget {
  const AddProductDcToCustomer({super.key});

  static const String routeName = '/AddProductDcToCustomer';

  @override
  State<AddProductDcToCustomer> createState() => _State();
}

class _State extends State<AddProductDcToCustomer> {
  TextEditingController idController = TextEditingController();
  TextEditingController dcTaxController =
      TextEditingController(text: "Group Tax");
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  TextEditingController firmNameController = TextEditingController();
  Rxn<LedgerModel> customer = Rxn<LedgerModel>();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController dcNoController = TextEditingController();
  TextEditingController boxNoController = TextEditingController(text: '0');
  TextEditingController dateController = TextEditingController();
  TextEditingController orderController = TextEditingController(text: "No");
  TextEditingController orderDetailsController = TextEditingController();
  TextEditingController transportNameController = TextEditingController();
  TextEditingController bookingPlaceNameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController totalPiecesController = TextEditingController();
  TextEditingController totalQuantityController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late ProductDcToCustomerController controller = Get.find();
  final FocusNode _customerNameFocusNode = FocusNode();
  var shortCut = RxString("");

  var itemList = <dynamic>[];
  late ItemDataSource dataSource;
  RxBool isUpdate = RxBool(false);

  /// created by and updated by details controllers
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? displayName;
  String? displayDate;

  @override
  void initState() {
    _customerNameFocusNode.addListener(() => shortCutKeys());
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: itemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDcToCustomerController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Product D.C To Customer"),
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
          SingleActivator(LogicalKeyboardKey.keyN, control: true):
              AddNewIntent(),
          SingleActivator(LogicalKeyboardKey.keyP, control: true):
              PrintIntent(),
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
            PrintIntent: SetCounterAction(perform: () {
              _print();
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
                          MyDropdownButtonFormField(
                              controller: dcTaxController,
                              hintText: "DC Tax type",
                              enabled: !isUpdate.value,
                              items: const ["Group Tax"]),
                          MyAutoComplete(
                            label: 'Firm',
                            items: controller.firmName,
                            selectedItem: firmName.value,
                            enabled: !isUpdate.value,
                            onChanged: (FirmModel item) {
                              firmName.value = item;
                              //  _firmNameFocusNode.requestFocus();
                            },
                            autofocus: false,
                          ),
                          Focus(
                            focusNode: _customerNameFocusNode,
                            skipTraversal: true,
                            child: MyAutoComplete(
                              label: 'Customer Name',
                              items: controller.Customer,
                              selectedItem: customer.value,
                              onChanged: (LedgerModel item) async {
                                customer.value = item;
                              },
                            ),
                          ),
                          Visibility(
                            visible: dcNoController.text.isNotEmpty,
                            child: MyTextField(
                              controller: dcNoController,
                              hintText: "D.C No",
                              readonly: true,
                              enabled: !isUpdate.value,
                            ),
                          ),
                          MyTextField(
                            controller: boxNoController,
                            hintText: "Boxes No",
                            validate: 'number',
                          ),
                          MyDateFilter(
                            controller: dateController,
                            labelText: "Entry Date",
                          ),
                          MyTextField(
                            controller: transportNameController,
                            hintText: "Transport",
                          ),
                          MyTextField(
                            controller: bookingPlaceNameController,
                            hintText: "Booking Place",
                          ),
                          MyTextField(
                            controller: detailsController,
                            hintText: "Details",
                            // validate: "String",
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: AddItemsElevatedButton(
                          width: 135,
                          onPressed: () async {
                            _addItem();
                          },
                          child: const Text('Add Item'),
                        ),
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

  Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }

    var request = {'id': idController.text};
    String? response = await controller.productDCcustomerPdf(request: request);

    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }

  shortCutKeys() {
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

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "firm_id": firmName.value?.id,
        "customer_id": customer.value?.id,
        "no_of_boxes": int.tryParse(boxNoController.text) ?? 0,
        "details": detailsController.text,
        "transport": transportNameController.text,
        "booking_place": bookingPlaceNameController.text,
        "e_date": dateController.text,
        "dc_type": dcTaxController.text,
      };
      request["customer_item"] = itemList;

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
    controller.request = <String, dynamic>{};
    firmName.value = AppUtils.setDefaultFirmName(controller.firmName);

    if (Get.arguments != null) {
      isUpdate.value = true;
      var data = ProductDCtoCustomerModel.fromJson(Get.arguments['item']);

      idController.text = '${data.id}';

      var firmNameList = controller.firmName
          .where((element) => '${element.id}' == '${data.firmId}')
          .toList();
      if (firmNameList.isNotEmpty) {
        firmName.value = firmNameList.first;
        firmNameController.text = '${firmNameList.first.firmName}';
      }

      // Customer Name
      var customerList = controller.Customer.where(
          (element) => '${element.id}' == '${data.customerId}').toList();
      if (customerList.isNotEmpty) {
        customer.value = customerList.first;
        customerNameController.text = '${customerList.first.ledgerName}';
      }

      transportNameController.text = data.transport ?? '';
      bookingPlaceNameController.text = data.bookingPlace ?? '';
      dcNoController.text = tryCast(data.dcNo);
      boxNoController.text = tryCast(data.noOfBoxes);
      dcTaxController.text = "${data.dcType}";
      dateController.text = '${data.eDate}';
      detailsController.text = data.details ?? '';

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
        itemList.add(request);
      });
    }
  }

  Widget itemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'product_name',
          label: const MyDataGridHeader(title: 'Product Name'),
        ),
        GridColumn(
          columnName: 'design_no',
          label: const MyDataGridHeader(title: 'Design No'),
        ),
        GridColumn(
          columnName: 'work_no',
          label: const MyDataGridHeader(title: 'Work'),
        ),
        GridColumn(
          width: 120,
          columnName: 'deli_pieces',
          label: const MyDataGridHeader(title: 'Pieces'),
        ),
        GridColumn(
          width: 120,
          columnName: 'deli_qty',
          label: const MyDataGridHeader(title: 'Quantity'),
        ),
        GridColumn(
          width: 120,
          columnName: 'rate',
          label: const MyDataGridHeader(title: 'Rate(Rs)'),
        ),
        GridColumn(
          width: 120,
          columnName: 'amount',
          label: const MyDataGridHeader(title: 'Amount(Rs)'),
        ),
        GridColumn(
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
              name: 'deli_pieces',
              columnName: 'deli_pieces',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'deli_qty',
              columnName: 'deli_qty',
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

  void _addItem() async {
    var result = await Get.to(const ProductDCtoCustomerBottomSheet());
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
        DataGridCell<dynamic>(
            columnName: 'product_name', value: e['product_name']),
        DataGridCell<dynamic>(columnName: 'design_no', value: e['design_no']),
        DataGridCell<dynamic>(
            columnName: 'work_no',
            value: '${e['work_no']}' == '0' ? 'No' : 'Yes'),
        DataGridCell<dynamic>(
            columnName: 'deli_pieces', value: e['deli_pieces']),
        DataGridCell<dynamic>(columnName: 'deli_qty', value: e['deli_qty']),
        DataGridCell<dynamic>(columnName: 'rate', value: e['rate']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['amount']),
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
        case 'deli_pieces':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'deli_qty':
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
      case 'deli_pieces':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'deli_qty':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'amount':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      default:
        /* alignment = TextAlign.right;
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
