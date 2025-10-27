import 'package:abtxt/model/weaving_models/weft_balance/PrivateWeftRequirementListModel.dart';
import 'package:abtxt/view/production/weaving_weft_balance/private_weft_requirement/private_weft_recuirements_bottom_sheet.dart';
import 'package:abtxt/view/production/weaving_weft_balance/private_weft_requirement/private_weft_requirement_controller.dart';
import 'package:abtxt/view/production/weaving_weft_balance/private_weft_requirement/private_weft_requirements.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../utils/app_utils.dart';
import '../../../../widgets/AddItemsElevatedButton.dart';
import '../../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../../widgets/MyDataGridHeader.dart';
import '../../../../widgets/MyDropdownButtonFormField.dart';
import '../../../../widgets/MySFDataGridItemTable.dart';
import '../../../../widgets/MySubmitButton.dart';
import '../../../../widgets/MyTextField.dart';
import '../../../../widgets/flutter_shortcut_widget.dart';

class AddPrivateWeftRequirement extends StatefulWidget {
  const AddPrivateWeftRequirement({super.key});

  static const String routeName = '/add_private_weft_requirement';

  @override
  State<AddPrivateWeftRequirement> createState() => _State();
}

class _State extends State<AddPrivateWeftRequirement> {
  TextEditingController idController = TextEditingController();
  TextEditingController weaverNameController = TextEditingController();
  TextEditingController weavNoController = TextEditingController();
  TextEditingController loomController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productIdController = TextEditingController();
  TextEditingController requirements = TextEditingController(text: "Unit");
  TextEditingController weftForSaree = TextEditingController(text: "1");
  final FocusNode _firstInputFocusNode = FocusNode();
  final DataGridController _dataGridController = DataGridController();
  final _formKey = GlobalKey<FormState>();
  PrivateWeftRequirementController controller = Get.find();

  late ItemDataSource dataSource;

  @override
  void initState() {
    controller.itemList.clear();

    super.initState();
    dataSource = ItemDataSource(list: controller.itemList);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initValue();
      FocusScope.of(context).requestFocus(_firstInputFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrivateWeftRequirementController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: const Text("Product Weft Requirements"),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () async {
                var request = {"id": idController.text};
                if (idController.text.isNotEmpty) {
                  var result = await Get.toNamed(
                    PrivateWeftRequirements.routeName,
                    arguments: request,
                  );
                  PrivateWeftRequirementListModel? item = result;
                  if (item != null) {
                    idController.text = '${item.weavingAcId}';
                    requirements.text = '${item.reqFor}';
                    weftForSaree.text = '${item.noOfUnit}';
                    productNameController.text = "${item.productName}";
                    productIdController.text = "${item.productId}";
                    controller.itemList.clear();
                    item.itemDetails?.forEach((element) {
                      var result = element.toJson();
                      controller.itemList.add(result);
                    });
                    dataSource.updateDataGridRows();
                    dataSource.updateDataGridSource();
                  }
                }
              },
              child: const Text(
                'List',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12)
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black12),
                ),
                margin: const EdgeInsets.all(16),
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
                                    enabled: false,
                                    controller: weaverNameController,
                                    hintText: "Weaver",
                                    readonly: true,
                                  ),
                                  MyTextField(
                                    enabled: false,
                                    controller: weavNoController,
                                    hintText: "Weav No",
                                    readonly: true,
                                  ),
                                  MyTextField(
                                    enabled: false,
                                    controller: loomController,
                                    hintText: "Loom",
                                    readonly: true,
                                  ),
                                  MyTextField(
                                    controller: productNameController,
                                    hintText: "Product Name",
                                    enabled: false,
                                  ),
                                  MyDropdownButtonFormField(
                                      enabled: false,
                                      controller: requirements,
                                      hintText: "Requirement for",
                                      items: const [
                                        "Unit",
                                        "Length",
                                      ]),
                                  MyTextField(
                                    controller: weftForSaree,
                                    hintText: "Weft For Saree",
                                    validate: "number",
                                    focusNode: _firstInputFocusNode,
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
                              const SizedBox(height: 20),
                              itemsTable(),
                              const SizedBox(height: 48),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child:
                                      MySubmitButton(onPressed: () => submit()))
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
        "weaving_ac_id": idController.text,
        "product_id": productIdController.text,
        "req_for": requirements.text,
        "no_of_unit": weftForSaree.text,
      };

      request['weft_details'] = controller.itemList;
      controller.edit(request);
    }
  }

  void _initValue() async {
    if (Get.arguments != null) {
      var data = Get.arguments;
      var weavingAcId = data["id"];
      var productId = data["product_id"];

      PrivateWeftRequirementListModel? item = await controller
          .weavingAcIdByPrivateWeftDetails(weavingAcId, productId);
      if (item != null) {
        loomController.text = "${item.loom}";
        weaverNameController.text = "${item.weaverName}";
        weavNoController.text = "${item.weavingAcId}";
        idController.text = '${item.weavingAcId}';
        requirements.text = '${item.reqFor}';
        weftForSaree.text = '${item.noOfUnit}';
        productNameController.text = "${item.productName}";
        productIdController.text = "${item.productId}";

        item.itemDetails?.forEach((element) {
          var result = element.toJson();
          controller.itemList.add(result);
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        });
      }
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
        var result = await Get.to(const PrivateWeftRequirementBottomSheet(),
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
    var result = await Get.to(const PrivateWeftRequirementBottomSheet());
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
