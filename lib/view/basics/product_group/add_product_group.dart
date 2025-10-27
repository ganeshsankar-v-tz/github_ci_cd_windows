import 'package:abtxt/model/ProductGroupModel.dart';
import 'package:abtxt/model/ProductUnitModel.dart';
import 'package:abtxt/utils/constant.dart';
import 'package:abtxt/view/basics/product_group/product_group_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../utils/app_utils.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import 'ProductListBottomSheet.dart';
import 'SupplierListBottomSheet.dart';

class AddProductGroup extends StatefulWidget {
  const AddProductGroup({super.key});

  static const String routeName = '/AddProductGroup';

  @override
  State<AddProductGroup> createState() => _State();
}

class _State extends State<AddProductGroup> {
  TextEditingController idController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  Rxn<ProductUnitModel> unit = Rxn<ProductUnitModel>();
  TextEditingController purchaseRateController =
      TextEditingController(text: "0");
  TextEditingController introDateController = TextEditingController();
  TextEditingController isActiveController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  ProductGroupController controller = Get.find();

  var supplierItemList = <dynamic>[];
  late SupplierItemDataSource supplierDataSource;

  var productItemList = <dynamic>[];
  late ProductItemDataSource productDataSource;

  final DataGridController _supplierDataGridController = DataGridController();
  final DataGridController _productDataGridController = DataGridController();

  @override
  void initState() {
    _initValue();
    supplierDataSource = SupplierItemDataSource(supplierList: supplierItemList);
    productDataSource = ProductItemDataSource(productList: productItemList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductGroupController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Product Group"),
          actions: [
            Visibility(
                visible: idController.text.isNotEmpty,
                child: MyDeleteIconButton(
                  onPressed: (password) =>
                      controller.delete(idController.text, password),
                )),
            MyAddItemsRemoveButton(onPressed: () => removeSelectedItems()),
            const SizedBox(width: 12),
          ],
        ),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
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
            RemoveIntent:
                SetCounterAction(perform: () => removeSelectedItems()),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
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
                          padding: const EdgeInsets.all(16),
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
                                  MyTextField(
                                    autofocus: true,
                                    controller: groupNameController,
                                    hintText: "Group Name",
                                    validate: "string",
                                  ),
                                  MyAutoComplete(
                                    autofocus: false,
                                    label: 'Product Unit',
                                    items: controller.productUnit,
                                    selectedItem: unit.value,
                                    onChanged: (ProductUnitModel item) {
                                      unit.value = item;
                                    },
                                  ),
                                  /*MyDialogList(
                                    labelText: 'Product Unit',
                                    controller: unitController,
                                    list: controller.productUnit,
                                    onItemSelected: (ProductUnitModel item) {
                                      unitController.text = '${item.unitName}';
                                      unit.value = item;
                                    },
                                    onCreateNew: (value) async {},
                                  ),*/
                                  Focus(
                                    skipTraversal: true,
                                    child: MyTextField(
                                      controller: purchaseRateController,
                                      hintText: "Purchase Rate",
                                      validate: "double",
                                    ),
                                    onFocusChange: (hasFocus) {
                                      AppUtils.fractionDigitsText(
                                          purchaseRateController,
                                          fractionDigits: 2);
                                    },
                                  ),
                                  MyDateFilter(
                                    controller: introDateController,
                                    labelText: "Intro Date",
                                  ),
                                  MyDropdownButtonFormField(
                                      controller: isActiveController,
                                      hintText: "Is Active",
                                      items: Constants.ISACTIVE),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(child: supplierListItems()),
                                  const SizedBox(width: 12),
                                  Flexible(child: productListItems()),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                               /*   crateAndUpdatedBy(),
                                  const Spacer(),*/
                                  MySubmitButton(
                                    onPressed: controller.status.isLoading ? null : submit,
                                  ),
                                ],
                              )
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
        ),
      );
    });
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "group_name": groupNameController.text,
        "unit": unit.value?.unitName,
        "purchase_rate": double.parse(purchaseRateController.text),
        "date": introDateController.text,
        "is_active": isActiveController.text,
      };

      for (var i = 0; i < supplierItemList.length; i++) {
        request['suplier[$i]'] = supplierItemList[i]['suplier'];
        request['last_pur_rate[$i]'] =
            double.parse(supplierItemList[i]['last_pur_rate']);
        request['area[$i]'] = supplierItemList[i]['area'];
        request['supplier_date[$i]'] = supplierItemList[i]['date'];
      }

      for (var i = 0; i < productItemList.length; i++) {
        request['product_name[$i]'] = productItemList[i]['product_name'];
        request['design_no[$i]'] = productItemList[i]['design_no'];
        request['group[$i]'] = productItemList[i]['group'];
      }

      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.addProductGroupList(requestPayload);
      } else {
        request['id'] = id;
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.editProductGroup(requestPayload, id);
      }
    }
  }

  void _initValue() {
    isActiveController.text = Constants.ISACTIVE[0];
    introDateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    ProductGroupController controller = Get.find();
    controller.request = <String, dynamic>{};

    if (Get.arguments != null) {
      var item = ProductGroupModel.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      groupNameController.text = '${item.groupName}';
      purchaseRateController.text = '${item.purchaseRate}';
      introDateController.text = '${item.date}';
      isActiveController.text = '${item.isActive}';
      var unitList = controller.productUnit
          .where((element) => '${element.unitName}' == '${item.unit}')
          .toList();
      if (unitList.isNotEmpty) {
        unit.value = unitList.first;
      }

      item.supplierList?.forEach((element) {
        var request = element.toJson();
        supplierItemList.add(request);
      });
      item.productList?.forEach((element) {
        var request = element.toJson();
        productItemList.add(request);
      });
    }
  }

  Widget supplierListItems() {
    return Container(
      color: const Color(0xFFF4F2FF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              const Text(
                'SUPPLIER LIST',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: AddItemsElevatedButton(
                  onPressed: () => _supplierAddItem(),
                  child: const Text('Add Item'),
                ),
              ),
              const SizedBox(height: 20),
            ]),
          ),
          MySFDataGridItemTable(
            selectionMode: SelectionMode.single,
            controller: _supplierDataGridController,
            columns: [
              GridColumn(
                columnName: 'suplier',
                label: const MyDataGridHeader(title: 'Supplier Name'),
              ),
              GridColumn(
                columnName: 'area',
                label: const MyDataGridHeader(title: 'Area'),
              ),
              GridColumn(
                columnName: 'last_pur_rate',
                label: const MyDataGridHeader(title: 'Last Pur Rate'),
              ),
              GridColumn(
                columnName: 'date',
                label: const MyDataGridHeader(title: 'Date'),
              ),
            ],
            source: supplierDataSource,
            onRowSelected: (index) async {
              var item = supplierItemList[index];
              var result = await Get.to(const SupplierListBottomSheet(),
                  arguments: {'item': item});
              if (result != null) {
                supplierItemList[index] = result;
                supplierDataSource.updateDataGridRows();
                supplierDataSource.updateDataGridSource();
              }
            },
          )
        ],
      ),
    );
  }

  Widget productListItems() {
    return Container(
      color: const Color(0xFFF4F2FF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Text(
                  'PRODUCT LIST',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: AddItemsElevatedButton(
                    onPressed: () => _productAddItem(),
                    child: const Text('Add Item'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          MySFDataGridItemTable(
            selectionMode: SelectionMode.single,
            controller: _productDataGridController,
            columns: [
              GridColumn(
                columnName: 'product_name',
                label: const MyDataGridHeader(title: 'Product Name'),
              ),
              GridColumn(
                columnName: 'design_no',
                label: const MyDataGridHeader(title: 'Design No'),
              ),
            ],
            source: productDataSource,
            onRowSelected: (index) async {
              var item = productItemList[index];
              var result = await Get.to(const ProductListBottomSheet(),
                  arguments: {'item': item});
              if (result != null) {
                productItemList[index] = result;
                productDataSource.updateDataGridRows();
                productDataSource.updateDataGridSource();
              }
            },
          )
        ],
      ),
    );
  }

  void _supplierAddItem() async {
    var result = await Get.to(const SupplierListBottomSheet());
    if (result != null) {
      supplierItemList.add(result);
      supplierDataSource.updateDataGridRows();
      supplierDataSource.updateDataGridSource();
    }
  }

  void _productAddItem() async {
    var result = await Get.to(const ProductListBottomSheet());
    if (result != null) {
      productItemList.add(result);
      productDataSource.updateDataGridRows();
      productDataSource.updateDataGridSource();
    }
  }

  void removeSelectedItems() {
    int? supplierIndex = _supplierDataGridController.selectedIndex;
    int? productIndex = _productDataGridController.selectedIndex;
    if (supplierIndex >= 0 || productIndex >= 0) {
      if (supplierIndex >= 0) {
        supplierItemList.removeAt(supplierIndex);
        supplierDataSource.updateDataGridRows();
        supplierDataSource.updateDataGridSource();
        _supplierDataGridController.selectedIndex = -1;
      } else if (productIndex >= 0) {
        productItemList.removeAt(productIndex);
        productDataSource.updateDataGridRows();
        productDataSource.updateDataGridSource();
        _productDataGridController.selectedIndex = -1;
      }
    } else {
      AppUtils.infoAlert(message: "Select The Value");
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

class SupplierItemDataSource extends DataGridSource {
  SupplierItemDataSource({required List<dynamic> supplierList}) {
    _list = supplierList;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'suplier', value: e['suplier']),
        DataGridCell<dynamic>(columnName: 'area', value: e['area']),
        DataGridCell<dynamic>(
            columnName: 'last_pur_rate', value: e['last_pur_rate']),
        DataGridCell<dynamic>(columnName: 'date', value: e['supplier_date']),
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

class ProductItemDataSource extends DataGridSource {
  ProductItemDataSource({required List<dynamic> productList}) {
    _list = productList;
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
