import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/WarpDesignModel.dart';
import 'package:abtxt/model/WarpDetailsByWarpDesignIdModel.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_dyer_list/warp_delivery_to_dyer_controller.dart';
import 'package:abtxt/widgets/MyAddButton.dart';
import 'package:abtxt/widgets/my_search_field/dyer_warp_id_searchField.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../utils/app_utils.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import 'add_warp_delivery_to_dyer.dart';

class WarpDeliveryToDyerBottomSheetTwo extends StatefulWidget {
  final DyerDeliveryItemDataSource dataSource;

  const WarpDeliveryToDyerBottomSheetTwo({
    super.key,
    required this.dataSource,
  });

  @override
  State<WarpDeliveryToDyerBottomSheetTwo> createState() => _State();
}

class _State extends State<WarpDeliveryToDyerBottomSheetTwo> {
  Rxn<WarpDesignModel> warpDesign = Rxn<WarpDesignModel>();
  TextEditingController warpDesignController = TextEditingController();
  TextEditingController warpTypeController = TextEditingController();
  Rxn<WarpDetailsByWarpDesignIdModel> warpIdNo =
      Rxn<WarpDetailsByWarpDesignIdModel>();
  TextEditingController warpIdNoController = TextEditingController();
  TextEditingController productQtyController = TextEditingController(text: "0");
  TextEditingController meterController = TextEditingController(text: "0.000");
  TextEditingController warpWeightController = TextEditingController(text: "0");
  Rxn<NewColorModel> colorName = Rxn<NewColorModel>();
  TextEditingController colourController = TextEditingController();
  TextEditingController colourToDyeController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  WarpDeliveryToDyerController controller = Get.find();
  final FocusNode _warpDesignFocusNode = FocusNode();
  final FocusNode _warpIdNoFocusNode = FocusNode();
  final FocusNode _colourNameFocusNode = FocusNode();
  final FocusNode _detailsFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  RxBool isUpdate = RxBool(false);
  RxInt warpInward = RxInt(0);

  late ItemDataSource dataSource;

  // for backend tracking
  int? weaverId;
  int? subWeaverNo;
  String? warpTrackerId;
  String? warpFor;

  RxString weaverName = RxString("");
  RxString loomNo = RxString("");

  @override
  void initState() {
    super.initState();
    dataSource = ItemDataSource(list: controller.dyerBalanceWarp);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpDeliveryToDyerController>(builder: (controller) {
      return ShortCutWidget(
        loadingStatus: controller.status.isLoading,
        child: FocusScope(
          autofocus: true,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
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
                          onChanged: (WarpDesignModel item) {
                            warpDesign.value = item;
                            warpTypeController.text = "${item.warpType}";
                            warpIdNo.value = null;
                            warpIdNoController.text = "";
                            var id = item.warpDesignId;
                            controller.warpDetailsByWarpDesignId(id);
                          },
                        ),
                        MyTextField(
                          width: 140,
                          controller: warpTypeController,
                          hintText: 'Warp Type',
                          readonly: true,
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        Obx(
                          () => DyerWarpIdSearchField(
                            enabled: !isUpdate.value,
                            label: 'Warp Id',
                            textController: warpIdNoController,
                            focusNode: _warpIdNoFocusNode,
                            requestFocus: _detailsFocusNode,
                            items: controller.warpIdList,
                            onChanged: (WarpDetailsByWarpDesignIdModel item) {
                              warpIdDetails(item);
                              warpIdNo.value = item;
                              FocusScope.of(context)
                                  .requestFocus(_detailsFocusNode);
                            },
                          ),
                        ),
                        MyTextField(
                          width: 140,
                          controller: productQtyController,
                          hintText: 'Product Qty',
                          validate: "number",
                          readonly: true,
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        MyTextField(
                          width: 140,
                          controller: meterController,
                          hintText: 'Meter',
                          validate: "double",
                          readonly: true,
                        ),
                        MyTextField(
                          width: 140,
                          controller: warpWeightController,
                          hintText: 'Warp Weight',
                          validate: "double",
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        MySearchField(
                          width: 200,
                          label: 'Color Name',
                          textController: colourController,
                          focusNode: _colourNameFocusNode,
                          requestFocus: _detailsFocusNode,
                          items: controller.colorDropdown,
                          isValidate: false,
                          onChanged: (NewColorModel item) {
                            colourController.text = '${item.name}';
                            colourToDyeController.text += '${item.name}, ';
                            colorName.value = item;
                          },
                        ),
                        MyTextField(
                          controller: colourToDyeController,
                          hintText: 'Color To Dye',
                        ),
                      ],
                    ),
                    MyTextField(
                      controller: detailsController,
                      focusNode: _detailsFocusNode,
                      hintText: "Details",
                    ),
                    const SizedBox(height: 14),
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
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: MyAddButton(onPressed: () => submit()),
                    ),
                    const SizedBox(height: 12),
                    balanceWarpDetails(),
                  ],
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
            width: 50,
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
            width: 140,
            columnName: 'warp_id',
            label: const MyDataGridHeader(title: 'Warp ID'),
          ),
          GridColumn(
            minimumWidth: 270,
            columnName: 'details',
            label: const MyDataGridHeader(title: 'Details'),
          ),
          GridColumn(
            minimumWidth: 250,
            columnName: 'warp_color',
            label: const MyDataGridHeader(title: 'Warp Color'),
          ),
          GridColumn(
            minimumWidth: 150,
            columnName: 'weaver_name',
            label: const MyDataGridHeader(title: 'Weaver Nme'),
          ),
          GridColumn(
            width: 60,
            columnName: 'loom_no',
            label: const MyDataGridHeader(title: 'Loom'),
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
        "warp_id": warpIdNo.value?.warpId,
        "warp_type": warpTypeController.text,
        "product_qty": int.tryParse(productQtyController.text) ?? 0,
        "metre": double.tryParse(meterController.text) ?? 0,
        "color_to_dye": colourToDyeController.text,
        "warp_weight": double.tryParse(warpWeightController.text) ?? 0.0,
        "warp_det": detailsController.text,
        "warp_inward": warpInward.value,
        "weaver_id": weaverId,
        "sub_weaver_no": subWeaverNo,
        "warp_tracker_id": warpTrackerId,
        "warp_for": warpFor,
        "weaver_name": weaverName.value,
        "loom_no": loomNo.value,
      };
      controller.itemList.add(request);
      dataTableDetailsUpdate();
      controller.getBackBoolean.value = true;
      clearTheControllers();
      controller.warpIdList.clear();
      FocusScope.of(context).requestFocus(_warpDesignFocusNode);
    }
  }

  dataTableDetailsUpdate() {
    controller.itemList.sort((a, b) => a['warp_design_name']
        .toLowerCase()
        .compareTo(b['warp_design_name'].toLowerCase()));
    widget.dataSource.updateDataGridRows();
    widget.dataSource.updateDataGridSource();
  }

  clearTheControllers() {
    warpDesignController.text = "";
    warpIdNoController.text = "";
    productQtyController.text = "0";
    meterController.text = "0.000";
    warpWeightController.text = "0.000";
    colourToDyeController.text = "";
    detailsController.text = "";
    warpTrackerId = null;
    warpFor = null;
    subWeaverNo = null;
    weaverId = null;
    weaverName.value = "";
    loomNo.value = "";
  }

  warpIdDetails(WarpDetailsByWarpDesignIdModel item) {
    productQtyController.text = '${item.qty}';
    meterController.text = item.metre!.toStringAsFixed(3);
    warpWeightController.text = item.weight!.toStringAsFixed(3);
    colourToDyeController.text = item.warpColor ?? '';
    warpTrackerId = item.warpTrackerId;
    weaverId = item.weaverId;
    subWeaverNo = item.subWeaverNo;
    warpFor = item.warpFor;
    weaverName.value = item.weaverName ?? '';
    loomNo.value = item.loomNo ?? '';
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
        DataGridCell<dynamic>(columnName: 'warp_color', value: e['warp_color']),
        DataGridCell<dynamic>(
            columnName: 'weaver_name', value: e['weaver_name']),
        DataGridCell<dynamic>(columnName: 'loom_no', value: e['loom_no']),
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
