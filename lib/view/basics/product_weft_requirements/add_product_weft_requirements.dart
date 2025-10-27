import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/product_weft_requirements/product_weft_recuirements_bottom_sheet.dart';
import 'package:abtxt/view/basics/product_weft_requirements/product_weft_requirements_controller.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/ProductInfoModel.dart';
import '../../../model/ProductWeftRequirementsModel.dart';
import '../../../utils/constant.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MySubmitButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class AddProductWeftRecuirements extends StatefulWidget {
  const AddProductWeftRecuirements({super.key});

  static const String routeName = '/addproduct_weft_requirements';

  @override
  State<AddProductWeftRecuirements> createState() => _State();
}

class _State extends State<AddProductWeftRecuirements> {
  TextEditingController idController = TextEditingController();
  TextEditingController productController = TextEditingController();
  Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
  TextEditingController designNo = TextEditingController();
  TextEditingController requirements = TextEditingController();
  TextEditingController weftForSaree = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  ProductWeftRecuirementsController controller = Get.find();
  final DataGridController _dataGridController = DataGridController();

  late ItemDataSource dataSource;

  @override
  void initState() {
    controller.itemList.clear();
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: controller.itemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductWeftRecuirementsController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Product Weft Requirements"),
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
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyN, control: true):
              AddNewIntent(),
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
            RemoveIntent:
                SetCounterAction(perform: () => removeSelectedItems()),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
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
                                  label: 'Product Name',
                                  items: controller.ProductName,
                                  selectedItem: productName.value,
                                  onChanged: (ProductInfoModel item) async {
                                    productName.value = item;
                                    designNo.text = item.designNo ?? '';
                                    controller.request['product_name'] =
                                        item.id;
                                  },
                                ),
                                MyTextField(
                                  controller: designNo,
                                  hintText: "Design No",
                                  readonly: true,
                                ),
                                MyDropdownButtonFormField(
                                    controller: requirements,
                                    hintText: "Requirement for",
                                    items: Constants.Recuirments),
                                MyTextField(
                                  controller: weftForSaree,
                                  hintText: "Weft For Saree",
                                  validate: "number",
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
                              /*  crateAndUpdatedBy(),
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
        "product_id": productName.value?.id,
        "design_no": designNo.text,
        "requirements": requirements.text,
        "weft_for_saree": weftForSaree.text,
      };

      for (var i = 0; i < controller.itemList.length; i++) {
        request['yarn_id[$i]'] = controller.itemList[i]['yarn_id'];
        request['weft_type[$i]'] = controller.itemList[i]['weft_type'];
        request['quantity[$i]'] = controller.itemList[i]['quantity'];
      }

      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.addproduct_wr(requestPayload);
      } else {
        request['id'] = id;
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.updateproduct_wr(requestPayload, id);
      }
    }
  }

  void _initValue() {
    ProductWeftRecuirementsController controller = Get.find();
    controller.request = <String, dynamic>{};
    requirements.text = Constants.Recuirments[0];
    if (Get.arguments != null) {
      var item = ProductWeftRequirementsModel.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      designNo.text = '${item.designNo}';
      requirements.text = '${item.requirements}';
      weftForSaree.text = '${item.weftForSaree}';

      var productId = controller.ProductName.where(
          (element) => '${element.id}' == '${item.productId}').toList();
      if (productId.isNotEmpty) {
        productName.value = productId.first;
        productController.text = '${productId.first.productName}';
      }
      item.yarnDetails?.forEach((element) {
        var result = element.toJson();
        controller.itemList.add(result);
      });
    }
  }

  Widget itemsTable() {
    return MySFDataGridItemTable(
      selectionMode: SelectionMode.single,
      controller: _dataGridController,
      columns: [
        GridColumn(
          columnName: 'yarn_name',
          label: const MyDataGridHeader(title: 'Yarn Name'),
        ),
        GridColumn(
          columnName: 'quantity',
          label: const MyDataGridHeader(title: 'Quantity (Kg)'),
        ),
        GridColumn(
          columnName: 'weft_type',
          label: const MyDataGridHeader(title: 'Weft Type'),
        ),
      ],
      source: dataSource,
      onRowSelected: (index) async {
        var item = controller.itemList[index];
        var result = await Get.to(const ProductWeftRecuirementsBottomSheet(),
            arguments: {'item': item});
        if (result != null) {
          controller.itemList[index] = result;
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        }
      },
    );
  }

  void _addItem() async {
    var result = await Get.to(const ProductWeftRecuirementsBottomSheet());
    if (result != null) {
      controller.itemList.add(result);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    }
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
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e['yarn_name']),
        DataGridCell<dynamic>(columnName: 'quantity', value: e['quantity']),
        DataGridCell<dynamic>(columnName: 'weft_type', value: e['weft_type']),
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
        case 'quantity':
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
        alignment: Alignment.centerLeft,
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
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
