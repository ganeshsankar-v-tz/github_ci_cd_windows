import 'package:abtxt/view/basics/productinfo/productDetailsItemBottomSheet.dart';
import 'package:abtxt/view/basics/productinfo/product_info_controller.dart';
import 'package:abtxt/view/basics/productinfo/wrapDetailsItemBottomSheet.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/ProductGroupModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../model/ProductUnitModel.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/constant.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/my_search_field/my_search_field.dart';

class AddProductInfo extends StatefulWidget {
  const AddProductInfo({super.key});

  static const String routeName = '/add_product_info';

  @override
  State<AddProductInfo> createState() => _State();
}

class _State extends State<AddProductInfo> {
  TextEditingController idController = TextEditingController();
  TextEditingController productName = TextEditingController();
  TextEditingController llName = TextEditingController();
  TextEditingController designNo = TextEditingController();
  TextEditingController integratedName = TextEditingController();
  Rxn<ProductGroupModel> group = Rxn<ProductGroupModel>();
  TextEditingController groupController = TextEditingController();
  TextEditingController unitController = TextEditingController(text: 'Saree');
  TextEditingController length = TextEditingController(text: '6.2');
  TextEditingController lengthType = TextEditingController();
  TextEditingController weaverWagesPer = TextEditingController();
  TextEditingController wagesrs = TextEditingController();
  TextEditingController used = TextEditingController(text: "Sales");

  TextEditingController width = TextEditingController();
  TextEditingController pick = TextEditingController();
  TextEditingController reed = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController isActive = TextEditingController();
  Rxn<ProductUnitModel> productUnit = Rxn<ProductUnitModel>();
  final DataGridController _warpDataGridController = DataGridController();

  /// Focus Nodes
  final FocusNode _productNameFocusNode = FocusNode();
  final FocusNode _groupFocusNode = FocusNode();
  final FocusNode _llNameFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _formKeyItemTable = GlobalKey<FormState>();
  ProductInfoController controller = Get.find();
  RxBool isUpdate = RxBool(false);

  final RxString _isIntegrated = RxString(Constants.Intergrated[0]);

  Widget changeableScreenWidget = Container();

  Future<void> integratedScreen() async {
    if (integratedName.text == "No") {
      changeableScreenWidget = warpItemsTable();
    } else if (integratedName.text == "Yes") {
      changeableScreenWidget = productItemsTable();
    }
  }

  late WarpItemDataSource warpDataSource;

  var productItemList = <dynamic>[];
  late ProductItemDataSource productDataSource;

  @override
  void initState() {
    controller.warpItemList.clear();
    _initValue();
    warpDataSource = WarpItemDataSource(warpList: controller.warpItemList);
    productDataSource = ProductItemDataSource(productList: productItemList);
    integratedScreen();
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_productNameFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductInfoController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Product Info"),
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
        loadingStatus: controller.status.isLoading,
        // bindings: {
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
        //       Get.back(),
        //   const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
        //       _warpAddItem(),
        //   const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
        //       submit(),
        // },
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyN, control: true):
              AddNewIntent(),
          SingleActivator(LogicalKeyboardKey.keyR, control: true):
              RemoveIntent(),
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
              _warpAddItem();
            }),
            RemoveIntent:
                SetCounterAction(perform: () => removeSelectedItems()),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FocusTraversalGroup(
                            policy: OrderedTraversalPolicy(),
                            child: Flexible(
                              flex: 1,
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: false,
                                    child: MyTextField(
                                      controller: idController,
                                      hintText: "Id",
                                      enabled: false,
                                    ),
                                  ),
                                  MyTextField(
                                    controller: productName,
                                    hintText: "Product Name",
                                    validate: "string",
                                    focusNode: _productNameFocusNode,
                                  ),
                                  MySearchField(
                                    label: "Group",
                                    items: controller.groups,
                                    textController: groupController,
                                    focusNode: _groupFocusNode,
                                    requestFocus: _llNameFocusNode,
                                    onChanged: (item) {
                                      group.value = item;
                                    },
                                  ),
                                  MyTextField(
                                    focusNode: _llNameFocusNode,
                                    controller: llName,
                                    hintText: "L.L Name",
                                  ),
                                  MyTextField(
                                    controller: details,
                                    hintText: "Details",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  children: [
                                    MyTextField(
                                      controller: designNo,
                                      hintText: "Design No ",
                                    ),
                                    MyTextField(
                                      controller: integratedName,
                                      hintText: "Is Integrated",
                                      validate: "string",
                                      readonly: true,
                                      enabled: !isUpdate.value,
                                      onChanged: (value) {
                                        _isIntegrated.value = value;
                                      },
                                    ),
                                  ],
                                ),
                                Wrap(
                                  children: [
                                    MyDropdownButtonFormField(
                                      controller: unitController,
                                      hintText: "Product Unit",
                                      items: const [
                                        'Bit',
                                        'Blouse',
                                        'Carpet',
                                        'Dhoti',
                                        'Dusti',
                                        'Khed',
                                        'Lungi',
                                        'Madi',
                                        'Metre',
                                        'Nos',
                                        'Patkas',
                                        'Pavada',
                                        'Piece',
                                        'Saree',
                                        'Sath',
                                        'Set',
                                        'Shall',
                                        'Than',
                                        'Towel',
                                        'Upparna',
                                        'Yards'
                                      ],
                                    ),
                                    MyTextField(
                                      controller: length,
                                      hintText: "Length",
                                      validate: "double",
                                    ),
                                    MyDropdownButtonFormField(
                                      controller: lengthType,
                                      hintText: "Length Type",
                                      items: Constants.LengthType,
                                      enabled: !isUpdate.value,
                                    ),
                                  ],
                                ),
                                Obx(
                                  () => Visibility(
                                    visible: _isIntegrated.value == "No",
                                    child: Wrap(
                                      children: [
                                        MyTextField(
                                          controller: width,
                                          hintText: "Width",
                                          validate: "number",
                                        ),
                                        MyTextField(
                                          controller: pick,
                                          hintText: "Pick",
                                          validate: "number",
                                        ),
                                        MyTextField(
                                          controller: reed,
                                          hintText: "Reed",
                                          validate: "number",
                                        ),
                                        MyDropdownButtonFormField(
                                            controller: weaverWagesPer,
                                            hintText: "Weaver Wages Per",
                                            enabled: !isUpdate.value,
                                            items: Constants.WeaverName),
                                        Focus(
                                          skipTraversal: true,
                                          child: MyTextField(
                                            controller: wagesrs,
                                            hintText: "Wages (Rs)",
                                            validate: "double",
                                          ),
                                          onFocusChange: (hasFocus) {
                                            AppUtils.fractionDigitsText(wagesrs,
                                                fractionDigits: 2);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Wrap(
                                  children: [
                                    MyDropdownButtonFormField(
                                        controller: used,
                                        hintText: "Used for",
                                        items: const [
                                          "ALL",
                                          "Weaving",
                                          "Sales",
                                          "Job work"
                                        ]),
                                    MyDropdownButtonFormField(
                                        controller: isActive,
                                        hintText: "Is Active",
                                        items: const ['Yes', 'No']),
                                  ],
                                ),
                              ],
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
                              if (integratedName.text == "No") {
                                _warpAddItem();
                              } else if (integratedName.text == "Yes") {
                                _productAddItem();
                              }
                            },
                            child: const Text('Add Item'),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            'Finished Product Warps',
                            style: TextStyle(
                              color: Color(0xFF5700BC),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Form(
                        key: _formKeyItemTable,
                        child:
                            Obx(() => widgetByEntryType(_isIntegrated.value)),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          /* crateAndUpdatedBy(),
                          const Spacer(),*/
                          MySubmitButton(
                            onPressed:
                                controller.status.isLoading ? null : submit,
                            //child: Text(Get.arguments == null ? 'Save' : 'Update'),
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

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "product_name": productName.text,
        "ll_name": llName.text,
        "design_no": designNo.text,
        "integrated": integratedName.text,
        "group_id": group.value?.id,
        "product_unit": unitController.text,
        "unit_meter": double.tryParse(length.text) ?? 0.0,
        "length_type": lengthType.text,
        "weaver_wages_per": weaverWagesPer.text,
        "wages": double.tryParse(wagesrs.text) ?? 0.0,
        "used_for": used.text,
        "width": int.tryParse(width.text) ?? 0,
        "pick": int.tryParse(pick.text) ?? 0,
        "reed": int.tryParse(reed.text) ?? 0,
        "details": details.text,
        "is_active": isActive.text,
      };

      for (var i = 0; i < controller.warpItemList.length; i++) {
        request['warp_design_id[$i]'] =
            controller.warpItemList[i]['warp_design_id'];
      }
      for (var i = 0; i < productItemList.length; i++) {
        request['p_product_name[$i]'] = productItemList[i]['p_product_name'];
        request['p_work_name[$i]'] = productItemList[i]['p_work_name'];
        request['p_quantity[$i]'] = productItemList[i]['p_quantity'];
        request['p_design_no[$i]'] = productItemList[i]['p_design_no'];
        request['p_unit[$i]'] = productItemList[i]['p_unit'];
      }

      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.addProductInfo(requestPayload);
      } else {
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.updateProductInfo(requestPayload, id);
      }
    }
  }

  Widget widgetByEntryType(String option) {
    if (integratedName.text == "No") {
      return warpItemsTable();
    } else {
      return productItemsTable();
    }
  }

  void _initValue() async {
    integratedName.text = "No";
    lengthType.text = Constants.LengthType[0];
    weaverWagesPer.text = Constants.WeaverName[0];
    isActive.text = 'Yes';

    if (Get.arguments != null) {
      if (Get.arguments["item"] != null) {
        var item = ProductInfoModel.fromJson(Get.arguments['item']);
        int sync = 0;
        detailsDisPlay(item, sync);
      } else {
        var productId = Get.arguments["product_id"];
        ProductInfoModel? item =
            await controller.warpOrYarnDeliverToAddWarp(productId);
        if (item != null) {
          int sync = 1;
          detailsDisPlay(item, sync);
        }
      }
    }
  }

  detailsDisPlay(ProductInfoModel item, int sync) {
    isUpdate.value = true;
    idController.text = '${item.id}';
    productName.text = '${item.productName}';
    llName.text = item.llName ?? '';
    designNo.text = item.designNo ?? '';
    integratedName.text = '${item.integrated}';
    _isIntegrated.value = '${item.integrated}';
    unitController.text = '${item.productUnit}';
    // //group
    // var groupList = controller.groups
    //     .where((element) => '${element.id}' == '${item.groupId}')
    //     .toList();
    // if (groupList.isNotEmpty) {
    //   group.value = groupList.first;
    //   groupController.text = "${groupList.first.groupName}";
    // }
    group.value =
        ProductGroupModel(id: item.groupId, groupName: item.groupName);
    groupController.text = "${item.groupName}";

    length.text = '${item.unitMeter}';
    lengthType.text = '${item.lengthType}';
    weaverWagesPer.text = '${item.weaverWagesPer}';
    wagesrs.text = '${item.wages}';
    used.text = '${item.usedFor}';
    width.text = '${item.width}';
    pick.text = '${item.pick}';
    reed.text = '${item.reed}';
    details.text = item.details ?? '';
    isActive.text = '${item.isActive}';
    item.wrapDetails?.forEach((element) {
      var request = element.toJson();
      controller.warpItemList.add(request);
      if (sync == 1) {
        warpDataSource.updateDataGridRows();
        warpDataSource.updateDataGridSource();
      }
    });
    item.productDetails?.forEach((element) {
      var request = element.toJson();
      productItemList.add(request);
    });
  }

  Widget warpItemsTable() {
    return MySFDataGridItemTable(
      selectionMode: SelectionMode.multiple,
      controller: _warpDataGridController,
      columns: [
        GridColumn(
          columnName: 'warp_design',
          label: const MyDataGridHeader(title: 'Warp Design'),
        ),
        GridColumn(
          columnName: 'warp_type',
          label: const MyDataGridHeader(title: 'Warp Type'),
        ),
      ],
      source: warpDataSource,
    );
  }

  void removeSelectedItems() {
    // Get all selected rows
    List<DataGridRow> selectedRows = _warpDataGridController.selectedRows;

    if (selectedRows.isNotEmpty) {
      // Extract the indices of the selected rows
      List<int> selectedIndices = selectedRows
          .map((row) => warpDataSource.rows.indexOf(row))
          .where((index) => index >= 0)
          .toList();
      // Sort indices in descending order to avoid index shifting
      selectedIndices.sort((a, b) => b.compareTo(a));

      for (int index in selectedIndices) {
        controller.warpItemList.removeAt(index);
      }
      warpDataSource.updateDataGridRows();
      warpDataSource.updateDataGridSource();
      //  _warpDataGridController.selectedRows.clear();
    } else {
      AppUtils.infoAlert(message: "Select the values to remove");
    }
  }
//remove single index code:
  /*void removeSelectedItems() {
    int? index = _warpDataGridController.selectedIndex;
    if (index >= 0) {
      controller.warpItemList.removeAt(index);
      warpDataSource.updateDataGridRows();
      warpDataSource.updateDataGridSource();
      _warpDataGridController.selectedIndex = -1;
    } else {
      AppUtils.infoAlert(message: "Select The Value");
    }
  }*/

  void _warpAddItem() async {
    var result = await Get.to(() => const wrapDetailsItemBottomSheet());
    if (result != null) {
      controller.warpItemList.add(result);
      warpDataSource.updateDataGridRows();
      warpDataSource.updateDataGridSource();
    }
  }

  Widget productItemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'p_product_name',
          label: const MyDataGridHeader(title: 'Product Name'),
        ),
        GridColumn(
          columnName: 'p_work_name',
          label: const MyDataGridHeader(title: 'Work Name'),
        ),
        GridColumn(
          columnName: 'p_quantity',
          label: const MyDataGridHeader(title: 'Quantity'),
        ),
        GridColumn(
          columnName: 'p_unit',
          label: const MyDataGridHeader(title: 'Unit'),
        ),
      ],
      source: productDataSource,
      onRowSelected: (index) async {
        var item = productItemList[index];
        var result = await Get.to(const productDetailsItemBottomSheet(),
            arguments: {'item': item});
        if (result['item'] == 'delete') {
          productItemList.removeAt(index);
          productDataSource.updateDataGridRows();
          productDataSource.updateDataGridSource();
        } else if (result != null) {
          productItemList[index] = result;
          productDataSource.updateDataGridRows();
          productDataSource.updateDataGridSource();
        }
      },
    );
  }

  void _productAddItem() async {
    var result = await Get.to(const productDetailsItemBottomSheet());
    if (result != null) {
      productItemList.add(result);
      productDataSource.updateDataGridRows();
      productDataSource.updateDataGridSource();
    }
  }
}

class WarpItemDataSource extends DataGridSource {
  WarpItemDataSource({required List<dynamic> warpList}) {
    _list = warpList;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(
            columnName: 'warp_design', value: e['warp_design']),
        DataGridCell<dynamic>(columnName: 'warp_type', value: e['warp_type']),
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
            columnName: 'p_product_name', value: e['p_product_name']),
        DataGridCell<dynamic>(
            columnName: 'p_work_name', value: e['p_work_name']),
        DataGridCell<dynamic>(columnName: 'p_quantity', value: e['p_quantity']),
        DataGridCell<dynamic>(columnName: 'p_unit', value: e['p_unit']),
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
