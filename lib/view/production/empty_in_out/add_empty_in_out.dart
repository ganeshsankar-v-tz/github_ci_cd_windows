import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/production/empty_in_out/empty_in_out_bottom_sheet.dart';
import 'package:abtxt/widgets/MySmallTextField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/LedgerModel.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import 'empty_in_out_controller.dart';

class AddEmptyInOut extends StatefulWidget {
  const AddEmptyInOut({super.key});

  static const String routeName = '/add_empty_in_out';

  @override
  State<AddEmptyInOut> createState() => _State();
}

class _State extends State<AddEmptyInOut> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> weaverName = Rxn<LedgerModel>();
  TextEditingController dateController = TextEditingController();
  TextEditingController challonNoController = TextEditingController();
  TextEditingController inbeamController = TextEditingController();
  TextEditingController outbeamController = TextEditingController();
  TextEditingController inBobbinController = TextEditingController();
  TextEditingController outBobbinController = TextEditingController();
  TextEditingController inSheetController = TextEditingController();
  TextEditingController outSheetController = TextEditingController();

  bool? alertInit;
  bool alertCancel = true;

  final _formKey = GlobalKey<FormState>();
  EmptyInOutController controller = Get.find();

  late ItemDataSource dataSource;
  RxBool isUpdate = RxBool(false);
  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _addItemFocusNode = FocusNode();
  final DataGridController _dataGridController = DataGridController();

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
    controller.lastAddedDetails = null;
    controller.itemList.clear();
    _initValue();
    super.initState();

    dataSource = ItemDataSource(list: controller.itemList);
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_addItemFocusNode);
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
    return GetBuilder<EmptyInOutController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Empty In/Out"),
          actions: [
            Visibility(
                visible: idController.text.isNotEmpty,
                child: MyDeleteIconButton(
                  onPressed: (password) {
                    controller.delete(idController.text, password);
                  },
                )),
            const SizedBox(width: 12),
            Visibility(
              visible: idController.text.isNotEmpty,
              child: MyPrintButton(
                onPressed: () => _print(),
              ),
            ),
            const SizedBox(width: 12),
            Visibility(
              visible: idController.text.isNotEmpty,
              child: TextButton.icon(
                onPressed: () async {
                  int id = int.tryParse(idController.text) ?? 0;
                  var result = await controller.labelPrintPdf(id);
                  if (result!.isNotEmpty) {
                    final Uri url = Uri.parse(result);
                    if (!await launchUrl(url)) {
                      throw Exception('Error : $result');
                    }
                  }
                },
                icon: const Icon(
                  Icons.print,
                  color: Color(0x960D30E3),
                ),
                label: const Text(
                  'LABEL PRINT',
                  style: TextStyle(color: Color(0x960D30E3)),
                ),
              ),
            ),
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
              _addItem();
            }),
            PrintIntent: SetCounterAction(perform: () {
              _print();
            }),
            RemoveIntent: SetCounterAction(perform: () {
              removeItem();
            }),
          },
          child: WillPopScope(
            onWillPop: () async {
              getBackAlert();
              return false;
            },
            child: FocusScope(
              autofocus: true,
              child: SingleChildScrollView(
                child: Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: const Color(0xFFF9F3FF), width: 16),
                  ),
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
                            Row(
                              children: [
                                Obx(
                                  () => MyAutoComplete(
                                    label: 'Weaver Name',
                                    items: controller.WeaverName,
                                    selectedItem: weaverName.value,
                                    enabled: !isUpdate.value,
                                    onChanged: (LedgerModel item) async {
                                      alertCancel = true;
                                      weaverName.value = item;
                                      int? id = item.id;
                                      controller.weaverId = id;
                                      FocusScope.of(context)
                                          .requestFocus(_addItemFocusNode);
                                      controller.loomInfo(id);
                                    },
                                  ),
                                ),
                                MyDateFilter(
                                  controller: dateController,
                                  labelText: 'Date',
                                  focusNode: _firstInputFocusNode,
                                ),
                                Visibility(
                                  visible: true,
                                  child: MyTextField(
                                    controller: challonNoController,
                                    hintText: "Challon No.",
                                    readonly: true,
                                    enabled: false,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MyAddItemsRemoveButton(onPressed: () {
                              removeItem();
                            }),
                            const SizedBox(width: 12),
                            AddItemsElevatedButton(
                              focusNode: _addItemFocusNode,
                              onPressed: () => _addItem(),
                              child: const Text('Add Item'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        itemsTable(),
                        const SizedBox(height: 12),
                        beamBobbinSheetDetails(),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            crateAndUpdatedBy(),
                            const Spacer(),
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
        ),
      );
    });
  }

  Widget beamBobbinSheetDetails() {
    return ExcludeFocusTraversal(
      excluding: true,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
            width: 300,
            color: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    Text(
                      'In :',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      'Out :',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                  ],
                ),
                Row(
                  children: [
                    const Text('Beam :'),
                    const Spacer(),
                    MySmallTextField(
                      controller: inbeamController,
                      readonly: true,
                      validate: '',
                    ),
                    MySmallTextField(
                      controller: outbeamController,
                      readonly: true,
                      validate: '',
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Bobbin :'),
                    const Spacer(),
                    MySmallTextField(
                      controller: inBobbinController,
                      readonly: true,
                      validate: '',
                    ),
                    MySmallTextField(
                      controller: outBobbinController,
                      readonly: true,
                      validate: '',
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Sheet :'),
                    const Spacer(),
                    MySmallTextField(
                      controller: inSheetController,
                      readonly: true,
                      validate: '',
                    ),
                    MySmallTextField(
                      controller: outSheetController,
                      readonly: true,
                      validate: '',
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }
    var request = {
      'id': idController.text,
      "challan_no": challonNoController.text
    };
    String? response = await controller.emptyInOutPdf(request: request);
    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }

  submit() {
    if (alertInit == false) {
      _dialogFoeSubmit(dateController.text);
    } else {
      if (_formKey.currentState!.validate()) {
        if (controller.itemList.isEmpty) {
          return AppUtils.infoAlert(message: "Item Details Required");
        }

        Map<String, dynamic> request = {
          "weaver_id": weaverName.value?.id,
          "e_date": dateController.text,
        };
        var id = idController.text;
        if (id.isEmpty) {
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
    request["challan_no"] = challonNoController.text;
    request["id"] = int.tryParse(idController.text);

    var resentAdded = [];
    for (var item in controller.itemList) {
      if (item["sync"] == 0) {
        resentAdded.add(item);
      }
    }
    request["item_details"] = resentAdded;
    controller.edit(request);
    for (var item in controller.itemList) {
      item['sync'] = 1;
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    }
  }

  void _initValue() async {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    if (Get.arguments != null) {
      isUpdate.value = true;
      var obj = Get.arguments['item'];

      if (obj != null) {
        var challanNo = obj['challan_no'];
        var recNo = obj["rec_no"];
        idController.text = "$recNo";

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

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          var item = await controller.weaverDetailByChallanNo(challanNo, recNo);

          dateController.text = item.eDate ?? '';
          challonNoController.text = tryCast(item.challanNo);

          // weaver Name
          var weaverList = controller.WeaverName.where(
              (element) => '${element.id}' == '${item.weaverId}').toList();
          if (weaverList.isNotEmpty) {
            weaverName.value = weaverList.first;

            /// Loom Info Call
            var id = weaverName.value?.id;
            controller.weaverId = id;
            controller.loomInfo(id);
          }

          controller.itemList.clear();
          item.itemDetails?.forEach((element) {
            var request = element.toJson();
            controller.itemList.add(request);
            dataSource.updateDataGridRows();
            dataSource.updateDataGridSource();
            beamBobbinSheetCalculation();
          });
        });
      }
    }
  }

  beamBobbinSheetCalculation() {
    int beamIn = 0;
    int beamOut = 0;
    int bobbinIn = 0;
    int bobbinOut = 0;
    int sheetIn = 0;
    int sheetOut = 0;

    for (var e in controller.itemList) {
      beamIn += int.tryParse("${e["bm_in"]}") ?? 0;
      beamOut += int.tryParse("${e["bm_out"]}") ?? 0;
      bobbinIn += int.tryParse("${e["bbn_in"]}") ?? 0;
      bobbinOut += int.tryParse("${e["bbn_out"]}") ?? 0;
      sheetIn += int.tryParse("${e["sht_in"]}") ?? 0;
      sheetOut += int.tryParse("${e["sht_out"]}") ?? 0;
    }
    inbeamController.text = '$beamIn';
    outbeamController.text = '$beamOut';
    inBobbinController.text = '$bobbinIn';
    outBobbinController.text = '$bobbinOut';
    inSheetController.text = '$sheetIn';
    outSheetController.text = '$sheetOut';
  }

  Widget itemsTable() {
    return MySFDataGridItemTable(
      scrollPhysics: const ScrollPhysics(),
      shrinkWrapRows: false,
      controller: _dataGridController,
      selectionMode: SelectionMode.single,
      columns: [
        GridColumn(
          width: 100,
          columnName: 'loom',
          label: const MyDataGridHeader(title: 'Loom'),
        ),
        GridColumn(
          width: 150,
          columnName: 'current_status',
          label: const MyDataGridHeader(title: 'Warp Status'),
        ),
        GridColumn(
          width: 180,
          columnName: 'entry_type',
          label: const MyDataGridHeader(title: 'Entry Type'),
        ),
        GridColumn(
          columnName: 'particulars',
          label: const MyDataGridHeader(title: 'Particulars'),
        ),
        GridColumn(
          visible: false,
          width: 100,
          columnName: 'qty',
          label: const MyDataGridHeader(title: 'Qty'),
        ),
        GridColumn(
          visible: false,
          width: 100,
          columnName: 'meter',
          label: const MyDataGridHeader(title: 'Meter'),
        ),
        GridColumn(
          columnName: 'product_details',
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
          label: const MyDataGridHeader(title: 'date'),
        ),
      ],
      source: dataSource,
    );
  }

  void removeSelectedItems() async {
    int? index = _dataGridController.selectedIndex;
    if (index >= 0) {
      var data = controller.itemList[index];

      if (data["sync"] == 0) {
        controller.itemList.removeAt(index);
        dataSource.updateDataGridRows();
        dataSource.updateDataGridSource();
        beamBobbinSheetCalculation();
        _dataGridController.selectedIndex = -1;
      } else {
        var id = data["id"];
        var weavingAcId = data["weaving_ac_id"];
        var result = await controller.selectedRowDelete(id, weavingAcId);
        if (result == "Success") {
          controller.itemList.removeAt(index);
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
          beamBobbinSheetCalculation();
          _dataGridController.selectedIndex = -1;
        }
      }
      Get.back();
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
    if (controller.itemList.isNotEmpty) {
      controller.lastAddedDetails = controller.itemList.last;
    }

    var weaverId = weaverName.value?.id;
    var date = dateController.text;

    if (weaverId == null || date.isEmpty) {
      return;
    }
    // controller.date = date;
    if (controller.itemList.isEmpty && idController.text.isEmpty) {
      alertInit = await controller.samDateProductAddedOrNot(weaverId, date);
    }

    if (alertInit == false) {
      if (alertCancel == true) {
        _dialogForAddItem(date);
      } else {
        bottomSheetNavigate();
      }
    } else {
      bottomSheetNavigate();
    }
  }

  bottomSheetNavigate() async {
    var result = await Get.to(() => const EmptyInOutBottomSheet());
    if (result != null) {
      var list = result['list'];
      controller.itemList.addAll(list);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
      controller.getBackBoolean.value = true;

      beamBobbinSheetCalculation();
    }
  }

  _dialogForAddItem(String date) {
    Get.defaultDialog(
      title: "ALERT!",
      titleStyle: const TextStyle(fontSize: 16, color: Colors.red),
      barrierDismissible: false,
      radius: 10,
      content: Text("Already Entry Available in $date this Date !"),
      actions: [
        OutlinedButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        OutlinedButton(
          onPressed: () async {
            alertCancel = false;
            Get.back();
            bottomSheetNavigate();
          },
          autofocus: true,
          child: const Text(
            'Ok',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  _dialogFoeSubmit(String date) {
    Get.defaultDialog(
      title: "ALERT!",
      titleStyle: const TextStyle(fontSize: 16, color: Colors.red),
      barrierDismissible: false,
      radius: 10,
      content: Column(
        children: [
          Text("Already Entry Available in $date this Date !"),
          const Text("Do You Want Add?")
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(fontWeight: FontWeight.bold),
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
          child: const Text(
            'Ok',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
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
}

class ItemDataSource extends DataGridSource {
  ItemDataSource({required List<dynamic> list}) {
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

      /// Empty In/Ou
      if (e["entry_type"] == "Empty - (In / Out)") {
        /// Display The Deliver And Inward Beam Qty
        if (e["bm_in"] != 0) {
          particulars = "Beam Inward ( ${e["bm_in"]} )";
        } else if (e["bm_out"] != 0) {
          particulars = "Beam Delivery ( ${e["bm_out"]} )";
        }

        /// Display The Deliver And Inward Bobbin Qty
        if (e["bbn_in"] != 0) {
          particulars = "Bobbin Inward ( ${e["bbn_in"]} )";
        } else if (e["bbn_out"] != 0) {
          particulars = "Bobbin Delivery ( ${e["bbn_out"]} )";
        }

        /// Display The Deliver And Inward Sheet Qty
        if (e["sht_in"] != 0) {
          particulars = "Sheet Inward ( ${e["sht_in"]} )";
        } else if (e["sht_out"] != 0) {
          particulars = "Sheet Delivery ( ${e["sht_out"]} )";
        }
        details =
            "${tryCast(e["product_details"])}  ${tryCast(e["empty_warp_desing_name"])}";
      }

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'loom', value: e['loom']),
        DataGridCell<dynamic>(
            columnName: 'current_status', value: e['current_status']),
        DataGridCell<dynamic>(columnName: 'entry_type', value: e['entry_type']),
        DataGridCell<dynamic>(columnName: 'particulars', value: particulars),
        const DataGridCell<dynamic>(columnName: 'qty', value: ""),
        const DataGridCell<dynamic>(columnName: 'meter', value: ""),
        DataGridCell<dynamic>(columnName: 'product_details', value: details),
        DataGridCell<dynamic>(columnName: 'sync', value: e['sync']),
        DataGridCell<dynamic>(columnName: 'e_date', value: e['e_date']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color getRowColor() {
      dynamic date = row.getCells()[8].value;
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
            dynamic sync = row.getCells()[7].value;
            if (sync == 0) {
              return const TextStyle(
                color: Colors.blue,
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

          return Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Text(
              c.value != null ? '${c.value}' : ' ',
              style: getTextStyle(),
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
      padding: const EdgeInsets.all(12),
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
