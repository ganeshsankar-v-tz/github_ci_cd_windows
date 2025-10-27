import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/LoomModel.dart';
import 'package:abtxt/model/warp_dropout_allocation/WarpDropoutAllocationModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/production/dropout_warp_allocation/warp_dropout_allocation_controller.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/warp_dropout_allocation/DropoutWarpDetailsModel.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class AddWarpDropoutAllocation extends StatefulWidget {
  const AddWarpDropoutAllocation({super.key});

  static const String routeName = '/add_warp_dropout_allocation';

  @override
  State<AddWarpDropoutAllocation> createState() => _State();
}

class _State extends State<AddWarpDropoutAllocation> {
  TextEditingController idController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController weaverNameTextController = TextEditingController();
  Rxn<LedgerModel> weaverNameController = Rxn<LedgerModel>();
  TextEditingController loomNoTextController = TextEditingController();
  Rxn<LoomModel> loomNoController = Rxn<LoomModel>();
  TextEditingController warpIdTextController = TextEditingController();
  Rxn<DropoutWarpDetailsModel> warpIdController =
      Rxn<DropoutWarpDetailsModel>();
  TextEditingController warpForController =
      TextEditingController(text: "Weaving");

  /// warp tracker id this for backend process
  String? warpTrackerId;

  RxBool warpFor = RxBool(true);

  final _formKey = GlobalKey<FormState>();
  final WarpDropOutAllocationController controller = Get.find();

  final FocusNode _weaverFocusNode = FocusNode();
  final FocusNode _loomFocusNode = FocusNode();
  final FocusNode _warpIdFocusNode = FocusNode();
  final FocusNode _submitFocusNode = FocusNode();

  RxBool isUpdate = RxBool(false);

  var itemList = <dynamic>[];
  late ItemDataSource dataSource;

  /// created by and updated by details controllers
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? displayName;
  String? displayDate;

  @override
  void initState() {
    controller.loomList.clear();
    _initValue();
    super.initState();
    controller.dropoutWarpIdDetails();
    dataSource = ItemDataSource(list: itemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpDropOutAllocationController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Warp Dropout Allocation"),
          /* actions: [
            Visibility(
                visible: idController.text.isNotEmpty,
                child: MyDeleteIconButton(
                  onPressed: (password) {
                    controller.delete(idController.text, password);
                  },
                )),
            const SizedBox(width: 8),
          ],*/
        ),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
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
          },
          child: FocusScope(
            autofocus: true,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
              ),
              // padding: EdgeInsets.all(16),
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
                          MyDateField(
                            controller: dateController,
                            hintText: "Date",
                          ),
                          MyDropdownButtonFormField(
                            controller: warpForController,
                            hintText: "Warp For",
                            items: const ["Weaving", "Sale"],
                            onChanged: (value) {
                              warpFor.value = value == "Weaving" ? true : false;
                            },
                          ),
                          Obx(
                            () => Visibility(
                              visible: warpFor.value == true,
                              child: MySearchField(
                                label: "Weaver Name",
                                setInitialValue: warpFor.value,
                                items: controller.ledgerDropdown,
                                textController: weaverNameTextController,
                                focusNode: _weaverFocusNode,
                                requestFocus: _loomFocusNode,
                                onChanged: (LedgerModel item) {
                                  controller.loomInfo(item.id);
                                  weaverNameController.value = item;
                                  loomNoTextController.text = "";
                                  loomNoController.value = null;
                                },
                              ),
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: warpFor.value == true,
                              child: MySearchField(
                                label: "Loom No",
                                setInitialValue: warpFor.value,
                                items: controller.loomList,
                                textController: loomNoTextController,
                                focusNode: _loomFocusNode,
                                requestFocus: _warpIdFocusNode,
                                onChanged: (LoomModel item) {
                                  loomNoController.value = item;
                                },
                              ),
                            ),
                          ),
                          MySearchField(
                            label: "Warp Id",
                            enabled: !isUpdate.value,
                            setInitialValue: !isUpdate.value,
                            items: controller.dropoutWarpId,
                            textController: warpIdTextController,
                            focusNode: _warpIdFocusNode,
                            requestFocus: _submitFocusNode,
                            isArrayValidate: false,
                            onChanged: (DropoutWarpDetailsModel item) {
                              warpIdController.value = item;
                              selectedDetailsDisplay(item);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      itemsTable(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          crateAndUpdatedBy(),
                          MySubmitButton(
                            focusNode: _submitFocusNode,
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

  submit() {
    if (_formKey.currentState!.validate()) {
      if (warpForController.text == "Weaving") {
        if (weaverNameController.value == null) {
          return AppUtils.infoAlert(message: "Select the Weaver Name");
        }
        if (loomNoController.value == null) {
          return AppUtils.infoAlert(message: "Select the Loom No");
        }
      }

      if (warpIdController.value == null) {
        return AppUtils.infoAlert(message: "Select the warp id");
      }

      Map<String, dynamic> request = {
        "warp_id": warpIdController.value?.newWarpId,
        "e_date": dateController.text,
        "warp_for": warpForController.text,
      };

      if (warpForController.text == "Weaving") {
        request["weaver_id"] = weaverNameController.value?.id;
        request["sub_weaver_no"] = loomNoController.value?.id;
      } else {
        request["weaver_id"] = 0;
        request["sub_weaver_no"] = 0;
      }

      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        controller.add(request);
      } else {
        request['id'] = id;
        request['warp_tracker_id'] = warpTrackerId;
        controller.edit(request);
      }
    }
  }

  void _initValue() {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");

    if (Get.arguments != null) {
      isUpdate.value = true;

      WarpDropoutAllocationModel item = Get.arguments["item"];
      idController.text = "${item.id}";
      dateController.text = "${item.warpAllocateDate}";
      warpIdTextController.text = "${item.warpId}";
      warpIdController.value =
          DropoutWarpDetailsModel(newWarpId: "${item.warpId}");

      // loom details API call
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (item.weaverId != null && item.weaverId != 0) {
          controller.loomInfo(item.weaverId);
        }
      });

      warpForController.text = "${item.warpFor}";
      warpFor.value = item.warpFor == "Weaving" ? true : false;
      if (warpForController.text == "Weaving") {
        weaverNameController.value =
            LedgerModel(id: item.weaverId ?? 0, ledgerName: item.weaverName);
        weaverNameTextController.text = "${item.weaverName}";

        loomNoController.value =
            LoomModel(id: item.subWeaverNo, subWeaverNo: item.loomNo);
        loomNoTextController.text = "${item.loomNo}";
      }

      itemList.add({
        "warp_design_name": item.warpName,
        "qty": item.warpQty,
        "meter": item.meter,
        "beam": item.bm,
        "bobbin": item.bbn,
        "sheet": item.sht,
        "warp_color": "",
        "details": item.warpColor,
      });

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
    }
  }

  Widget itemsTable() {
    return Flexible(
      child: ExcludeFocusTraversal(
        child: MySFDataGridItemTable(
          selectionMode: SelectionMode.single,
          shrinkWrapRows: false,
          scrollPhysics: const ScrollPhysics(),
          columns: [
            GridColumn(
              minimumWidth: 200,
              columnName: 'warp_design_name',
              label: const MyDataGridHeader(title: 'Design Name'),
            ),
            GridColumn(
              width: 80,
              columnName: 'qty',
              label: const MyDataGridHeader(title: 'qty'),
            ),
            GridColumn(
              width: 90,
              columnName: 'mete',
              label: const MyDataGridHeader(
                  alignment: Alignment.center, title: 'Meter'),
            ),
            GridColumn(
              width: 60,
              columnName: 'beam',
              label: const MyDataGridHeader(title: 'Beam'),
            ),
            GridColumn(
              width: 70,
              columnName: 'bobbin',
              label: const MyDataGridHeader(title: 'Bobbin'),
            ),
            GridColumn(
              width: 60,
              columnName: 'sheet',
              label: const MyDataGridHeader(title: 'Sheet'),
            ),
            GridColumn(
              minimumWidth: 150,
              columnName: 'warp_color',
              label: const MyDataGridHeader(title: 'Warp Color'),
            ),
            GridColumn(
              minimumWidth: 150,
              columnName: 'details',
              label: const MyDataGridHeader(title: 'Details'),
            ),
          ],
          source: dataSource,
        ),
      ),
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

  selectedDetailsDisplay(DropoutWarpDetailsModel item) {
    itemList.add({
      "warp_design_name": item.warpName,
      "qty": item.qty,
      "meter": item.meter,
      "beam": item.beam,
      "bobbin": item.bobbin,
      "sheet": item.sheet,
      "warp_color": item.warpColor,
      "details": item.warpDet,
    });

    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
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
        DataGridCell<dynamic>(columnName: 'qty', value: e['qty']),
        DataGridCell<dynamic>(columnName: 'meter', value: e['meter']),
        DataGridCell<dynamic>(columnName: 'beam', value: e['beam']),
        DataGridCell<dynamic>(columnName: 'bobbin', value: e['bobbin']),
        DataGridCell<dynamic>(columnName: 'sheet', value: e['sheet']),
        DataGridCell<dynamic>(columnName: 'warp_color', value: e['warp_color']),
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
        case 'meter':
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
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
