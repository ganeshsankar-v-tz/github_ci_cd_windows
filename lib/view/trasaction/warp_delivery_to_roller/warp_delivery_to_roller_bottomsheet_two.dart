import 'package:abtxt/model/WarpDesignModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_roller/add_warp_delivery_to_roller.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_roller/warp_delivery_to_roller_controller.dart';
import 'package:abtxt/view/trasaction/warp_inward/warp_inward_controller.dart';
import 'package:abtxt/widgets/my_search_field/rollerr_warp_id_searchField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/RollerDeliverWarpDetails.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/my_search_field/my_search_field.dart';

class WarpDeliveryToRollerBottomSheetTwo extends StatefulWidget {
  final RollerDeliveryItemDataSource dataSource;

  const WarpDeliveryToRollerBottomSheetTwo(
      {super.key, required this.dataSource});

  @override
  State<WarpDeliveryToRollerBottomSheetTwo> createState() => _State();
}

class _State extends State<WarpDeliveryToRollerBottomSheetTwo> {
  TextEditingController warpDesignController = TextEditingController();
  Rxn<WarpDesignModel> warpDesign = Rxn<WarpDesignModel>();
  TextEditingController warpTypeController = TextEditingController();
  TextEditingController warpIdNoController = TextEditingController();
  Rxn<RollerDeliverWarpDetails> warpId = Rxn<RollerDeliverWarpDetails>();
  TextEditingController productQytController = TextEditingController();
  TextEditingController meterController = TextEditingController(text: "0.000");
  TextEditingController warpWeightController = TextEditingController();
  TextEditingController deliveredEmptyController =
      TextEditingController(text: "Beam");
  TextEditingController emptyQytController = TextEditingController(text: "1");
  TextEditingController sheetController = TextEditingController(text: "0");
  TextEditingController warpColourController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  var detailText = "";
  final _formKey = GlobalKey<FormState>();
  RxBool isUpdate = RxBool(false);
  WarpDeliveryToRollerController controller = Get.find();

  final FocusNode _warpDesignFocusNode = FocusNode();
  final FocusNode _warpIdNoFocusNode = FocusNode();
  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _detailsFocusNode = FocusNode();
  Rxn<WarpInwardDetailsModel> details = Rxn<WarpInwardDetailsModel>();

  // for backend tracking
  int? weaverId;
  int? subWeaverNo;
  String? warpTrackerId;
  String? warpFor;

  RxString weaverName = RxString("");
  RxString loomNo = RxString("");

  RxInt warpInward = RxInt(0);

  late ItemDataSource dataSource;

  @override
  void initState() {
    controller.detailsColumnData();
    super.initState();
    dataSource = ItemDataSource(list: controller.rollerBalanceWarp);
  }

  void detailsTextData() {
    var comma = detailText.isNotEmpty ? "," : "";
    var text = details.value?.toString().isEmpty ?? true
        ? detailsController.text
        : details.value.toString();
    detailsController.text = '$text$comma $detailText';
    Get.back();
  }

  void _showDetailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: SizedBox(
            width: 270,
            height: 460,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                width: 250,
                child: MyAutoComplete(
                  label: 'Details',
                  selectedItem: details.value,
                  items: controller.detailsData,
                  onChanged: (WarpInwardDetailsModel item) async {
                    details.value = item;
                    detailsTextData();
                  },
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Get.back(), child: const Text('CANCEL')),
            TextButton(
              child: const Text('SUBMIT'),
              onPressed: () async {
                detailsTextData();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpDeliveryToRollerController>(builder: (controller) {
      return ShortCutWidget(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.f2): DetailsIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            DetailsIntent: SetCounterAction(perform: () => _showDetailDialog()),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Wrap(
                        children: [
                          MySearchField(
                            label: 'Warp Design',
                            textController: warpDesignController,
                            focusNode: _warpDesignFocusNode,
                            requestFocus: _warpIdNoFocusNode,
                            items: controller.warpDesignDropdown,
                            enabled: !isUpdate.value,
                            onChanged: (WarpDesignModel item) async {
                              controller.warpIdList.clear();
                              warpIdNoController.text = "";
                              warpId.value = null;
                              warpTypeController.text = '${item.warpType}';
                              warpDesign.value = item;
                              controller.wapDetailsByWarpId(item.warpDesignId);
                            },
                          ),
                          MyTextField(
                            width: 140,
                            controller: warpTypeController,
                            hintText: 'Warp Type',
                            enabled: false,
                          ),
                          Wrap(
                            children: [
                              Obx(
                                () => RollerWarpIdSearchField(
                                  enabled: !isUpdate.value,
                                  label: 'Warp Id',
                                  textController: warpIdNoController,
                                  focusNode: _warpIdNoFocusNode,
                                  requestFocus: _detailsFocusNode,
                                  items: controller.warpIdList,
                                  onChanged: (RollerDeliverWarpDetails item) {
                                    FocusScope.of(context)
                                        .requestFocus(_detailsFocusNode);
                                    warpId.value = item;
                                    displayWarpIdDetails(item);
                                  },
                                ),
                              ),
                              MyTextField(
                                width: 140,
                                controller: productQytController,
                                hintText: 'Product Qty',
                                validate: 'number',
                                readonly: true,
                                enabled: !isUpdate.value,
                              ),
                            ],
                          ),
                          Wrap(
                            children: [
                              MyTextField(
                                controller: meterController,
                                hintText: 'Meter',
                                validate: 'double',
                                readonly: true,
                                enabled: !isUpdate.value,
                              ),
                              MyTextField(
                                width: 140,
                                controller: warpWeightController,
                                hintText: 'Warp Weight',
                                validate: 'double',
                                // readonly: true,
                                focusNode: _firstInputFocusNode,
                              ),
                            ],
                          ),
                          Wrap(
                            children: [
                              MyDropdownButtonFormField(
                                controller: deliveredEmptyController,
                                hintText: "Delivered Empty",
                                items: const ["Beam", "Bobbin", "Nothing"],
                                onChanged: (value) {
                                  if (value == "Beam") {
                                    emptyQytController.text = "1";
                                    sheetController.text = "40";
                                  } else if (value == "Bobbin") {
                                    emptyQytController.text = "2";
                                    sheetController.text = "0";
                                  } else {
                                    emptyQytController.text = "0";
                                    sheetController.text = "0";
                                  }
                                },
                              ),
                              MyTextField(
                                width: 140,
                                controller: emptyQytController,
                                hintText: 'Empty Qty',
                                validate: 'number',
                              ),
                            ],
                          ),
                          Wrap(
                            children: [
                              MyTextField(
                                controller: sheetController,
                                hintText: 'Sheet',
                                validate: 'number',
                              ),
                              MyTextField(
                                controller: warpColourController,
                                hintText: 'Warp Color',
                                readonly: true,
                              ),
                            ],
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              MyTextField(
                                width: 400,
                                focusNode: _detailsFocusNode,
                                controller: detailsController,
                                hintText: 'Details',
                              ),
                              const Text(
                                'F2',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        children: [
                          const Text("Weaver Name:  "),
                          Obx(
                            () => Text(weaverName.value,
                                style: const TextStyle(color: Colors.red)),
                          ),
                          const SizedBox(width: 10),
                          const Text("Loom No:  "),
                          Obx(
                            () => Text(loomNo.value,
                                style: const TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: MyAddButton(onPressed: () => submit()),
                      ),
                      const SizedBox(height: 12),
                      balanceWarpDetails()
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

  Widget balanceWarpDetails() {
    return ExcludeFocusTraversal(
      child: MySFDataGridItemTable(
        shrinkWrapRows: false,
        scrollPhysics: const ScrollPhysics(),
        selectionMode: SelectionMode.single,
        columns: [
          GridColumn(
            minimumWidth: 40,
            columnName: 's_no',
            label: const MyDataGridHeader(title: 'S.N'),
          ),
          GridColumn(
            minimumWidth: 100,
            columnName: 'e_date',
            label: const MyDataGridHeader(title: 'Date'),
          ),
          GridColumn(
            minimumWidth: 220,
            columnName: 'warp_name',
            label: const MyDataGridHeader(title: 'Warp Design'),
          ),
          GridColumn(
            width: 120,
            columnName: 'warp_id',
            label: const MyDataGridHeader(title: 'Warp ID'),
          ),
          GridColumn(
            minimumWidth: 270,
            columnName: 'details',
            label: const MyDataGridHeader(title: 'Details'),
          ),
          GridColumn(
            width: 180,
            columnName: 'weaver_name',
            label: const MyDataGridHeader(title: 'Weaver Name'),
          ),
          GridColumn(
            width: 60,
            columnName: 'loom_no',
            label: const MyDataGridHeader(title: 'Loom'),
          ),
          GridColumn(
            minimumWidth: 250,
            columnName: 'warp_color',
            label: const MyDataGridHeader(title: 'Warp Color'),
          ),
        ],
        source: dataSource,
      ),
    );
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "warp_design_id": warpDesign.value?.warpDesignId,
        "warp_design_name": warpDesign.value?.warpName,
        "warp_id": warpId.value?.warpId,
        "product_qty": int.tryParse(productQytController.text) ?? 0,
        "meter": double.tryParse(meterController.text) ?? 0.0,
        "warp_weight": double.tryParse(warpWeightController.text) ?? 0.0,
        "empty_type": deliveredEmptyController.text,
        "empty_qty": int.tryParse(emptyQytController.text) ?? 0,
        "sheet": int.tryParse(sheetController.text) ?? 0,
        "warp_color": warpColourController.text,
        "warp_det": detailsController.text,
        "warp_type": warpTypeController.text,
        "warp_inward": warpInward.value,
        "weaver_id": weaverId,
        "sub_weaver_no": subWeaverNo,
        "warp_tracker_id": warpTrackerId,
        "warp_for": warpFor,
        "weaver_name": weaverName.value,
        "loom_no": loomNo.value,
      };

      controller.itemList.add(request);
      controller.itemList.sort((a, b) => a['warp_design_name']
          .toLowerCase()
          .compareTo(b['warp_design_name'].toLowerCase()));

      dataTableDetailsUpdate();
      clearTheController();
      controller.getBackBoolean.value = true;
      controller.warpIdList.clear();
      FocusScope.of(context).requestFocus(_warpDesignFocusNode);
    }
  }

  void displayWarpIdDetails(RollerDeliverWarpDetails item) {
    var warpColour = "";

    if (item.warpColor != null) {
      warpColour = "${item.warpColor}, ";
    }

    productQytController.text = "${item.qty}";
    meterController.text = item.metre!.toStringAsFixed(3);
    warpWeightController.text = item.weight!.toStringAsFixed(3);
    warpColourController.text = "$warpColour${tryCast(item.details)}";
    detailsController.text = "";
    detailText = '';
    if (warpTypeController.text == "Main Warp") {
      setState(() {
        deliveredEmptyController.text = "Beam";
      });
      sheetController.text = "40";
      emptyQytController.text = "1";
    } else {
      setState(() {
        deliveredEmptyController.text = "Bobbin";
      });
      sheetController.text = "0";
      emptyQytController.text = "2";
    }
    warpTrackerId = item.warpTrackerId;
    weaverId = item.weaverId;
    subWeaverNo = item.subWeaverNo;
    warpFor = item.warpFor;
    weaverName.value = item.weaverName ?? '';
    loomNo.value = item.loomNo ?? '';
  }

  dataTableDetailsUpdate() {
    /*widget.dataSource.sortedColumns.add(const SortColumnDetails(
      name: "warp_design_name",
      sortDirection: DataGridSortDirection.ascending,
    ));
    widget.dataSource.sort();*/
    widget.dataSource.updateDataGridRows();
    widget.dataSource.updateDataGridSource();
  }

  clearTheController() {
    warpDesignController.text = "";
    warpDesign.value = null;
    warpTypeController.text = "";
    warpIdNoController.text = "";
    warpId.value = null;
    productQytController.text = "0";
    meterController.text = "0.000";
    warpWeightController.text = "0.000";
    deliveredEmptyController.text = "Beam";
    emptyQytController.text = "0";
    sheetController.text = "0";
    warpColourController.text = "";
    warpColourController.text = "";
    warpTrackerId = null;
    warpFor = null;
    subWeaverNo = null;
    weaverId = null;
    weaverName.value = "";
    loomNo.value = "";
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
      var index = _list.indexOf(e);
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 's_no', value: index + 1),
        DataGridCell<dynamic>(columnName: 'e_date', value: e['e_date']),
        DataGridCell<dynamic>(columnName: 'warp_name', value: e['warp_name']),
        DataGridCell<dynamic>(columnName: 'warp_id', value: e['warp_id']),
        DataGridCell<dynamic>(columnName: 'details', value: e["details"]),
        DataGridCell<dynamic>(
            columnName: 'weaver_name', value: e["weaver_name"]),
        DataGridCell<dynamic>(columnName: 'loom_no', value: e["loom_no"]),
        DataGridCell<dynamic>(columnName: 'warp_color', value: e['warp_color']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          dataGridCell.value != null ? '${dataGridCell.value}' : '',
          style: AppUtils.cellTextStyle(),
        ),
      );
    }).toList());
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
