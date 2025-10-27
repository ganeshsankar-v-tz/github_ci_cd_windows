import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/production/goods_inward_slip/goods_inward_slip_bottom_sheet_two.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MyDeleteIconButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/LedgerModel.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MySubmitButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../trasaction/payment_v2/add_payment_v2.dart';
import '../warp_or_yarn_delivery/add_warp_or_yarn_screen.dart';
import '../warp_or_yarn_delivery/warp_or_yarn_delivery_screen.dart';
import '../weaving_weft_balance/weft_delivery_balance.dart';
import 'goods_inward_slip_controller.dart';

class AddGoodsInwardSlip extends StatefulWidget {
  const AddGoodsInwardSlip({super.key});

  static const String routeName = '/add_goods_inward_slip';

  @override
  State<AddGoodsInwardSlip> createState() => _State();
}

class _State extends State<AddGoodsInwardSlip> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> weaverName = Rxn<LedgerModel>();
  TextEditingController dateController = TextEditingController();
  TextEditingController challonNoController = TextEditingController();

  bool? alertInit;
  bool alertCancel = true;
  RxBool addItemVisible = RxBool(false);

  /// created by and updated by details controllers
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? displayName;
  String? displayDate;

  final DataGridController _dataGridController = DataGridController();

  final _formKey = GlobalKey<FormState>();
  GoodsInwardSlipController controller = Get.find();
  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _addItemFocusNode = FocusNode();

  late GoodInwardItemDataSource dataSource;

  @override
  void initState() {
    controller.pendingQty.value = 0;
    controller.getBackBoolean.value = false;
    controller.shortCutToSave = false;
    controller.lastAddDetails = null;
    controller.loomList.clear();
    controller.warpStatus.clear();
    controller.itemList.clear();
    _initValue();
    super.initState();
    dataSource = GoodInwardItemDataSource(list: controller.itemList);
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_firstInputFocusNode);
      });
    }
  }

  getBackAlert() async {
    if (controller.getBackBoolean.value == true) {
      await AppUtils.showExitDialog(context) == true ? submit() : '';
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoodsInwardSlipController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Goods Inward Slip"),
          actions: [
            Tooltip(
              message: 'Yarn Delivery List ( Ctrl+L )',
              child: ElevatedButton(
                onPressed: () {
                  yarnDeliveryListScreen();
                },
                child: const Text("Yarn Delivery List"),
              ),
            ),
            const SizedBox(width: 12),
            Visibility(
              visible: challonNoController.text.isNotEmpty,
              child: Tooltip(
                message: 'Payment ( Ctrl+Shift+P )',
                child: ElevatedButton(
                  onPressed: () {
                    _paymentScreen();
                  },
                  child: const Text("Payment"),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Tooltip(
              message: 'Yarn Delivery ( Ctrl+Y )',
              child: ElevatedButton(
                onPressed: () {
                  yarnDeliveryScreen();
                },
                child: const Text("Yarn Delivery"),
              ),
            ),
            const SizedBox(width: 12),
            Tooltip(
              message: 'Weft Summary ( Ctrl+W )',
              child: ElevatedButton(
                onPressed: () {
                  _overAllWeft();
                },
                child: const Text("Weft Summary"),
              ),
            ),
            const SizedBox(width: 12),
            Visibility(
              visible: challonNoController.text.isNotEmpty,
              child: MyPrintButton(
                onPressed: () => _print(),
              ),
            ),
            const SizedBox(width: 12),
            Visibility(
                visible: idController.text.isNotEmpty,
                /*&& isEnable.value,*/
                child: MyDeleteIconButton(
                  onPressed: (password) {
                    var wagesStatus = "";
                    if (Get.arguments["item"] != null) {
                      wagesStatus = Get.arguments["item"]["wages"];
                    }
                    if (wagesStatus == "Paid") {
                      return AppUtils.infoAlert(
                          message:
                              "Payment has been issued so this entry cannot be deleted!");
                    }

                    controller.delete(idController.text, password);
                  },
                )),
            const SizedBox(width: 12),
          ],
        ),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyN, control: true):
              AddNewIntent(),
          SingleActivator(LogicalKeyboardKey.keyP, control: true):
              PrintIntent(),
          SingleActivator(LogicalKeyboardKey.keyR, control: true):
              RemoveIntent(),
          SingleActivator(LogicalKeyboardKey.keyW, control: true):
              OverAllWeftBalanceIntent(),
          SingleActivator(LogicalKeyboardKey.keyY, control: true):
              NavigateIntent(),
          SingleActivator(LogicalKeyboardKey.keyL, control: true): ListIntent(),
          SingleActivator(LogicalKeyboardKey.keyP, control: true, shift: true):
              NavigateAnotherPageIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              getBackAlert();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            AddNewIntent: SetCounterAction(perform: () {
              // _addItem();
            }),
            PrintIntent: SetCounterAction(perform: () {
              _print();
            }),
            RemoveIntent: SetCounterAction(perform: () {
              removeItem();
            }),
            OverAllWeftBalanceIntent: SetCounterAction(perform: () {
              _overAllWeft();
            }),
            NavigateIntent:
                SetCounterAction(perform: () => yarnDeliveryScreen()),
            ListIntent:
                SetCounterAction(perform: () => yarnDeliveryListScreen()),
            NavigateAnotherPageIntent: SetCounterAction(perform: () {
              _paymentScreen();
            }),
          },
          child: WillPopScope(
            onWillPop: () async {
              getBackAlert();
              return false;
            },
            child: FocusScope(
              autofocus: true,
              child: Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: LayoutBuilder(builder: (context, constraint) {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                topDetails(),
                                SizedBox(
                                  height: constraint.maxHeight - 80,
                                  child: bottomDetails(),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: addItemVisible.value,
                      child: Flexible(
                        flex: 2,
                        child: Container(
                          color: Colors.red,
                          child: GoodsInwardSlipBottomSheetTwo(
                            dataSource: dataSource,
                            saveOnPressed: submit,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget topDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 80,
          child: Wrap(
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
              Obx(
                () => MyAutoComplete(
                  label: 'Weaver Name',
                  items: controller.WeaverName,
                  enabled: Get.arguments == null && !addItemVisible.value,
                  selectedItem: weaverName.value,
                  onChanged: (LedgerModel item) async {
                    alertCancel = true;
                    // visible = true;
                    weaverName.value = item;
                    controller.itemList.clear();
                    dataSource.updateDataGridRows();
                    dataSource.updateDataGridSource();
                    FocusScope.of(context).requestFocus(_addItemFocusNode);
                    controller.weaverId = item.id;
                    controller.loomInfo(item.id);
                  },
                ),
              ),
              MyDateFilter(
                width: 160,
                controller: dateController,
                labelText: 'Date',
                focusNode: _firstInputFocusNode,
                /*enabled: !isEnable.value,*/
              ),
              Visibility(
                visible: challonNoController.text.isNotEmpty,
                child: MyTextField(
                  width: 160,
                  controller: challonNoController,
                  hintText: "Challon No.",
                  readonly: true,
                  enabled: false,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget bottomDetails() {
    return LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyAddItemsRemoveButton(onPressed: () => removeItem()),
                  const SizedBox(width: 12),
                  AddItemsElevatedButton(
                    focusNode: _addItemFocusNode,
                    onPressed: () => _addItem(),
                    child: const Text('Add Item'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: constraint.maxHeight - 50,
              child: Column(
                children: [
                  Flexible(child: itemsTable()),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      crateAndUpdatedBy(),
                      const Spacer(),
                      MySubmitButton(
                        onPressed: controller.status.isLoading ? null : submit,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }
    var request = {'id': idController.text};
    String? response = await controller.goodsInwardSlipPdf(request: request);

    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }

  submit() async {
    var weaverId = weaverName.value?.id;
    var date = dateController.text;
    if (weaverId == null || date.isEmpty) {
      return;
    }

    if (controller.id == null && controller.itemList.isEmpty) {
      alertInit = await controller.samDateGoodInwardOrNot(weaverId, date);
    }

    if (alertInit == false) {
      _dialogFoeSubmit(dateController.text);
    } else {
      if (_formKey.currentState!.validate()) {
        if (controller.itemList.isEmpty) {
          return AppUtils.infoAlert(message: "Add the item details");
        }

        Map<String, dynamic> request = {
          "weaver_id": weaverName.value?.id,
          "e_date": dateController.text,
        };

        controller.shortCutToSave = false;
        var id = controller.id;
        if (id == null) {
          controller.filterData = null;
          request["item_details"] = controller.itemList;
          controller.add(request);
          for (var item in controller.itemList) {
            item['sync'] = 1;
            dataSource.updateDataGridRows();
            dataSource.updateDataGridSource();
          }
        } else {
          updateApiCall(request);
        }
      }
    }
  }

  updateApiCall(Map<String, dynamic> request) {
    var id = controller.id;
    request["challan_no"] = controller.challanNo;

    var resentAdded = [];
    for (var item in controller.itemList) {
      if (item["sync"] == 0) {
        resentAdded.add(item);
      }
    }
    request["item_details"] = resentAdded;
    controller.edit(request, id);
    for (var item in controller.itemList) {
      item['sync'] = 1;
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    }
  }

  Future<void> _initValue() async {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");

    if (Get.arguments != null) {
      var obj = await Get.arguments["item"];
      var callanNo = obj["challan_no"];
      var recNo = obj["rec_no"];
      idController.text = "${obj["rec_no"]}";
      controller.id = obj["rec_no"];
      controller.challanNo = obj["challan_no"];

      /// get created by and updated by details
      DateTime createDate = DateTime.parse(obj["created_at"] ?? "0000-00-00");
      DateTime updateDate = DateTime.parse(obj["updated_at"] ?? "0000-00-00");
      createdAt = AppUtils.dateFormatter.format(createDate);
      updatedAt = AppUtils.dateFormatter.format(updateDate);
      createdBy = obj["creator_name"];
      updatedBy = obj["updated_name"];
      if (updatedBy != null) {
        displayName = "Edit : $updatedBy";
        displayDate = createdAt;
      } else {
        displayName = "New : $createdBy";
        displayDate = updatedAt;
      }

      /// api call for challan number by get details
      var item = await controller.challanNoByDetails(callanNo, recNo);
      dateController.text = item.eDate ?? '';
      challonNoController.text = tryCast(item.challanNo);

      var weaverList = controller.WeaverName.where(
          (element) => '${element.id}' == '${item.weaverId}').toList();
      if (weaverList.isNotEmpty) {
        weaverName.value = weaverList.first;

        /// Loom Info Call
        var id = weaverName.value?.id;
        controller.weaverId = id;
        controller.loomInfo(id);
        controller.request["weaver_id"] = weaverName.value?.id;
      }

      item.itemDetails?.forEach((element) {
        var result = element.toJson();
        controller.itemList.add(result);
        controller.pendingQtyCalculation();
        dataSource.updateDataGridRows();
        dataSource.updateDataGridSource();
      });
    }
  }

  Widget itemsTable() {
    return ExcludeFocusTraversal(
      child: MySFDataGridItemTable(
        scrollPhysics: const ScrollPhysics(),
        shrinkWrapRows: false,
        controller: _dataGridController,
        selectionMode: SelectionMode.single,
        columns: [
          GridColumn(
            columnName: 'loom',
            width: 55,
            label: const MyDataGridHeader(title: 'Loom'),
          ),
          GridColumn(
            width: 100,
            columnName: 'current_status',
            label: const MyDataGridHeader(title: 'Warp Sts'),
          ),
          GridColumn(
            width: 300,
            columnName: 'particulars',
            label: const MyDataGridHeader(title: 'Particulars'),
          ),
          GridColumn(
            width: 50,
            columnName: 'inward_qty',
            label: const MyDataGridHeader(title: 'Qty'),
          ),
          GridColumn(
            visible: false,
            width: 90,
            columnName: 'inward_meter',
            label: const MyDataGridHeader(title: 'Mtr/Yrds'),
          ),
          GridColumn(
            width: 70,
            columnName: 'wages',
            label: const MyDataGridHeader(title: 'Wages'),
          ),
          GridColumn(
            width: 100,
            columnName: 'credit',
            label: const MyDataGridHeader(title: 'Amount(Rs)'),
          ),
          GridColumn(
            width: 300,
            columnName: 'details',
            label: const MyDataGridHeader(title: 'Details'),
          ),
          GridColumn(
            columnName: 'sync',
            visible: false,
            label: const MyDataGridHeader(title: 'Sync'),
          ),
          GridColumn(
            columnName: 'e_date',
            visible: false,
            label: const MyDataGridHeader(title: 'e_date'),
          ),
        ],
        tableSummaryRows: [
          GridTableSummaryRow(
            showSummaryInRow: false,
            title: 'Total: ',
            titleColumnSpan: 1,
            columns: [
              const GridSummaryColumn(
                name: 'inward_meter',
                columnName: 'inward_meter',
                summaryType: GridSummaryType.sum,
              ),
              const GridSummaryColumn(
                name: 'inward_qty',
                columnName: 'inward_qty',
                summaryType: GridSummaryType.sum,
              ),
              const GridSummaryColumn(
                name: 'credit',
                columnName: 'credit',
                summaryType: GridSummaryType.sum,
              ),
              const GridSummaryColumn(
                name: 'particulars',
                columnName: 'particulars',
                summaryType: GridSummaryType.sum,
              ),
            ],
            position: GridTableSummaryRowPosition.bottom,
          ),
        ],
        source: dataSource,
      ),
    );
  }

  void removeSelectedItems() async {
    int? index = _dataGridController.selectedIndex;

    if (index >= 0) {
      var data = controller.itemList[index];

      if (data["sync"] == 0) {
        controller.itemList.removeAt(index);
        controller.pendingQtyCalculation();
        dataSource.updateDataGridRows();
        dataSource.updateDataGridSource();
        _dataGridController.selectedIndex = -1;
        Get.back();
      } else {
        var id = data["id"];
        var weavingAcId = data["weaving_ac_id"];
        var recordNo = controller.id;
        var result =
            await controller.selectedRowDelete(id, weavingAcId, recordNo);

        if (result["status"] == "Success") {
          controller.itemList.removeAt(index);
          controller.pendingQtyCalculation();
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
          _dataGridController.selectedIndex = -1;
          Get.back();
        } else if (result["status"] == "false") {
          Get.back();
          AppUtils.infoAlert(message: "${result["message"]}");
        }
      }
    } else {
      Get.back();
      AppUtils.infoAlert(message: "Select The Value");
    }
  }

  void removeItem() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 2,
          shadowColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: Colors.red,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Alert',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            'Do you want to Remove?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              autofocus: true,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red), // Border color
              ),
              child: const Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                removeSelectedItems();
              },
              autofocus: true,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue), // Border color
              ),
              child: const Text(
                'Ok',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addItem() async {
    // if (controller.itemList.isNotEmpty) {
    //   controller.lastAddDetails = controller.itemList.last;
    // }

    var weaverId = weaverName.value?.id;
    var date = dateController.text;
    if (weaverId == null || date.isEmpty) {
      return;
    }
    if (controller.id == null && controller.itemList.isEmpty) {
      alertInit = await controller.samDateGoodInwardOrNot(weaverId, date);
    }

    if (alertInit == false) {
      if (alertCancel == true) {
        _showAlertDialog(date);
      } else {
        bottomSheetNavigation();
      }
    } else {
      bottomSheetNavigation();
    }
  }

  bottomSheetNavigation() {
    addItemVisible.value = true;

    controller.id = int.tryParse(idController.text);
    controller.challanNo = int.tryParse(challonNoController.text);
    controller.date = dateController.text;
    controller.weaverId = weaverName.value?.id;

    /*var result = await Get.to(const GoodsInwardSlipBottomSheet());
      if (result != null) {
        controller.itemList.add(result);
        dataSource.updateDataGridRows();
        dataSource.updateDataGridSource();
      }*/
  }

  void _overAllWeft() {
    var weaverId = weaverName.value?.id;
    var weaveName = weaverName.value?.ledgerName;
    var request = {
      "weaver_id": weaverId,
      "weaver_name": weaveName,
    };
    if (weaverId == null) {
      return;
    }
    Get.toNamed(WeftDeliveryBalance.routeName, arguments: request);
  }

  void _showAlertDialog(String date) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 2,
          shadowColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: Colors.red,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Alert!',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            "Already Entry Available $date in this Date!",
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red), // Border color
              ),
              child: const Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                alertCancel = false;
                Get.back();
                bottomSheetNavigation();
              },
              autofocus: true,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue), // Border color
              ),
              child: const Text(
                'Ok',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _dialogFoeSubmit(String date) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 2,
          shadowColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: Colors.red,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Alert!',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SizedBox(
            height: 50,
            child: Column(
              children: [
                Text("Already Entry Available in $date this Date !"),
                const Text("Do You Want Add?")
              ],
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                Get.back();
                Get.back(result: 'success');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red), // Border color
              ),
              child: const Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Map<String, dynamic> request = {
                    "weaver_id": weaverName.value?.id,
                    "e_date": dateController.text,
                  };
                  request["item_details"] = controller.itemList;
                  for (var item in controller.itemList) {
                    item['sync'] = 1;
                    dataSource.updateDataGridRows();
                    dataSource.updateDataGridSource();
                  }
                  Get.back();
                  controller.add(request);
                }
              },
              autofocus: true,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue), // Border color
              ),
              child: const Text(
                'Ok',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  yarnDeliveryListScreen() {
    Get.toNamed(WarpOrYarnDeliveryProduction.routeName);
  }

  yarnDeliveryScreen() {
    if (controller.weaverId == null) {
      return;
    }
    var result = {
      "weaver_id": weaverName.value?.id,
      "enable": false,
    };
    Get.toNamed(AddWarporYarnDeliveryProduction.routeName, arguments: result);
  }

  void _paymentScreen() async {
    if (idController.text.isEmpty) {
      return;
    }
    var wagesStatus = "";
    if (Get.arguments["item"] != null) {
      wagesStatus = Get.arguments["item"]["wages"];
    }
    if (wagesStatus == "Paid") {
      AppUtils.infoAlert(message: "Already Wages Issued");
      return;
    }

    var arg = {
      "firm_name": "A B TEX PRIVATE LIMITED",
      "payment_type": "Weaver Amount",
      "ledger_id": weaverName.value?.id,
    };

    var result = await Get.toNamed(AddPaymentV2.routeName, arguments: arg);
    if (result == "success") {
      controller.paymentSaveToApiCall.value = true;
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
          id.isEmpty ? "New : ${AppUtils().loginName}" : "$displayName",
          style: AppUtils.updateAndCreateTextStyle(),
        ),
        const SizedBox(width: 12),
        Text(
          id.isEmpty ? formattedDate : "$displayDate",
          style: AppUtils.updateAndCreateTextStyle(),
        )
      ],
    );
  }
}

class GoodInwardItemDataSource extends DataGridSource {
  GoodInwardItemDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;
  var today = "${DateTime.now()}".substring(0, 10);

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var particulars = "";
      var details = "";
      var pending = "";
      var sareWeight = '';
      var checkerName = "";

      if (e["saree_weight"] != 0) {
        sareWeight = "${e["saree_weight"].toStringAsFixed(3)}, ";
      }

      if (e["saree_checker_name"] != null) {
        checkerName = "${e["saree_checker_name"]}, ";
      }

      if (e["damaged"] == "Yes") {
        particulars =
            "Damaged : ${e["product_name"]} ${tryCast(e["design_no"])}";
      } else if (e["pending"] == "Yes") {
        particulars = "${e["product_name"]} ${tryCast(e["design_no"])}";
        pending = "Pending : ${e["pending_qty"]}, ${e["pending_meter"]} ";
      } else {
        particulars = "${e["product_name"]} ${tryCast(e["design_no"])}";
      }
      var warpDetails = "";
      if (e["product_details"] != "" && e["product_details"] != null) {
        warpDetails = "${e["product_details"]},";
      }
      var otherWarp = '';

      if (e["used_other_warp"] != null) {
        otherWarp =
            "${e["used_other_warp"]}".replaceAll("[", "").replaceAll("]", "");
      }
      details = "$sareWeight$checkerName$warpDetails$pending$otherWarp";

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'loom', value: e['loom']),
        DataGridCell<dynamic>(
            columnName: 'current_status', value: e['current_status']),
        DataGridCell<dynamic>(columnName: 'particulars', value: particulars),
        DataGridCell<dynamic>(columnName: 'inward_qty', value: e['inward_qty']),
        DataGridCell<dynamic>(
            columnName: 'inward_meter', value: e['inward_meter']),
        DataGridCell<dynamic>(columnName: 'wages', value: e['wages']),
        DataGridCell<dynamic>(columnName: 'credit', value: e['credit']),
        DataGridCell<dynamic>(columnName: 'details', value: details),
        DataGridCell<dynamic>(columnName: 'sync', value: e['sync']),
        DataGridCell<dynamic>(columnName: 'e_date', value: e['e_date']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color? pendingCellText;
    Color getRowColor() {
      dynamic date = row.getCells()[9].value;
      if (date == today) {
        return Colors.yellow.shade400;
      } else {
        return Colors.transparent;
      }
    }

    return DataGridRowAdapter(
        color: getRowColor(),
        cells: row.getCells().map<Widget>((c) {
          TextStyle? getTextStyle() {
            dynamic sync = row.getCells()[8].value;
            if (sync == 0) {
              if (c.columnName == "details") {
                return TextStyle(
                  color: pendingCellText ?? Colors.blue,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.visible,
                );
              } else {
                return const TextStyle(
                  color: Colors.blue,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.visible,
                );
              }
            } else {
              if (c.columnName == "details") {
                return TextStyle(
                  color: pendingCellText ?? const Color(0xff9c2121),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.visible,
                );
              } else {
                return const TextStyle(
                  color: Color(0xff9c2121),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.visible,
                );
              }
            }
          }

          Color getColor() {
            String particulars = row.getCells()[2].value;

            /// quantity Column
            if (c.columnName == "particulars") {
              if (particulars.split(":").first == "Damaged ") {
                return Colors.redAccent.shade100;
              }
            }

            /// details Column
            if (c.columnName == "details") {
              String pending = "${c.value}"
                  .split(":")
                  .first
                  .split(",")
                  .last
                  .removeAllWhitespace;

              if (pending == "Pending") {
                pendingCellText = Colors.white;
                return Colors.redAccent;
              }
            }

            return Colors.transparent;
          }

          double value = double.tryParse('${c.value}') ?? 0;
          final columnName = c.columnName;
          switch (columnName) {
            case 'inward_meter':
              return buildFormattedCell(value,
                  decimalPlaces: 2, style: getTextStyle());
            case 'inward_qty':
              return buildFormattedCell(value,
                  decimalPlaces: 0, style: getTextStyle());
            case 'wages':
              return buildFormattedCell(value,
                  decimalPlaces: 2, style: getTextStyle());
            case 'credit':
              return buildFormattedCell(value,
                  decimalPlaces: 2, style: getTextStyle());
            default:
              return Container(
                color: getColor(),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  c.value != null ? '${c.value}' : '',
                  style: getTextStyle(),
                ),
              );
          }
        }).toList());
  }

  Widget buildFormattedCell(dynamic value,
      {int decimalPlaces = 2, TextStyle? style}) {
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
          style: style,
        ),
      );
    }
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        value != null ? '$value' : '',
        style: style,
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
    GoodsInwardSlipController controller = Get.find();

    if (columnName == "particulars") {
      return Container(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Pending Qty: ${controller.pendingQty.value}",
          style: AppUtils.footerTextStyle(),
        ),
      );
    }

    switch (columnName) {
      case 'inward_meter':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      case 'inward_qty':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'credit':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      default:
        /* alignment = TextAlign.left;
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
