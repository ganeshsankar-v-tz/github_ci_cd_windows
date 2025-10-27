import 'package:abtxt/model/LoomGroup.dart';
import 'package:abtxt/model/WeavingAccount.dart';
import 'package:abtxt/model/weaving_models/WeaverLoomDetailsModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/production/warp_tracking/warp_tracking.dart';
import 'package:abtxt/view/production/weaving/wagesChangesList.dart';
import 'package:abtxt/view/production/weaving/weaving_bottom_sheet_two.dart';
import 'package:abtxt/view/production/weaving/weaving_controller.dart';
import 'package:abtxt/view/production/weaving/weaving_new_record_screen.dart';
import 'package:abtxt/view/production/weaving/weaving_payment_details.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/weaving_models/WeaverTransferYarnModel.dart';
import '../../../model/weaving_models/WeavingFinishListModel.dart';
import '../../../model/weaving_models/WeavingOtherWarpBalanceModel.dart';
import '../../../model/weaving_models/weft_balance/PrivateWeftRequirementListModel.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyLabelTile.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/searchfield/decoration.dart';
import '../../../widgets/searchfield/searchfield.dart';
import '../../report/warp_reports/warp_search_report.dart';
import '../weaving_weft_balance/weft_balance_new_screen.dart';
import '../weaving_weft_balance/weft_delivery_balance.dart';

class AddWeaving extends StatefulWidget {
  const AddWeaving({super.key});

  static const String routeName = '/add_weaving';

  @override
  State<AddWeaving> createState() => _State();
}

class _State extends State<AddWeaving> {
  RxList<WeavingAccount> weavingList = RxList<WeavingAccount>([]);
  TextEditingController idController = TextEditingController();
  WeavingController controller = Get.put(WeavingController());
  Rxn<WeaverLoomDetailsModel> weaverController = Rxn<WeaverLoomDetailsModel>();
  Rxn<LoomGroup> loomController = Rxn<LoomGroup>();
  RxnString warpDetailsController = RxnString("");
  RxnString warpDetailsOtherController = RxnString("");
  RxnString warpColorController = RxnString("");
  RxnString warpColorOtherController = RxnString("");
  TextEditingController qtyController = TextEditingController(text: "0");
  TextEditingController meterController = TextEditingController(text: "0");
  TextEditingController wagesController = TextEditingController(text: "0");
  TextEditingController amountController = TextEditingController(text: "0");
  TextEditingController rowIdController = TextEditingController();
  late DataGridController _dataGridController = DataGridController();

  late WeavingItemDataSource dataSource;
  late Map<String, double> columnWidths = {
    'id': 60,
    'entry_date': 100,
    'entry_type': 150,
    'particulars': double.nan,
    'quantity': 60,
    'credit': 70,
    'debit': 70,
    'details': double.nan,
    'bm': 65,
    'bbn': 65,
    'sht': 65,
    'sync': double.nan,
  };

  /// Selected account private weft details
  late PrivateWeftItemDataSource privateWeftItemDataSource;

  var privateWeftDetails = [];

  // transfer table data source
  late TransferItemDataSource transferDatasource;
  List<dynamic> transferItemList = <dynamic>[].obs;

  RxNum totalQuantity = RxNum(0);
  RxNum receivedQuantity = RxNum(0);
  RxString bm = RxString('');
  RxString bbm = RxString('');
  RxString sht = RxString('');
  RxNum credit = RxNum(0);
  RxNum debit = RxNum(0);
  RxString creditBalance = RxString('');
  RxString debitBalance = RxString('');
  var weaverFocusNode = FocusNode();
  var loomFocusNode = FocusNode();
  var weaverTextEditingController = TextEditingController();
  var loomTextEditingController = TextEditingController();

  late CustomSelectionManager _customSelectionManager;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Rxn<WeavingAccount> weavingAccount = Rxn<WeavingAccount>();

  /// created by and updated by details controllers
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  RxString displayName = RxString("");
  RxString displayDate = RxString("");

  @override
  void initState() {
    _goodsInwardToInit();
    _dataGridController = DataGridController();
    privateWeftItemDataSource =
        PrivateWeftItemDataSource(list: privateWeftDetails);

    super.initState();
    weaverFocusNode.addListener(() {
      if (weaverFocusNode.hasFocus) {
        weaverTextEditingController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: weaverTextEditingController.text.length);
      }
    });
    loomFocusNode.addListener(() {
      if (loomFocusNode.hasFocus) {
        loomTextEditingController.selection = TextSelection(
            baseOffset: 0, extentOffset: loomTextEditingController.text.length);
      }
    });

    dataSource = WeavingItemDataSource(
      list: controller.itemList,
      totalQuantity: totalQuantity,
      receivedQuantity: receivedQuantity,
      beam: bm,
      bobbin: bbm,
      sheet: sht,
      credit: credit,
      debit: debit,
      creditBalance: creditBalance,
      debitBalance: debitBalance,
    );
    transferDatasource = TransferItemDataSource(list: transferItemList);
    _customSelectionManager = CustomSelectionManager(
      _dataGridController,
      dataSource,
      saveButton,
      _addItem,
      _payDetails,
      recordEdit,
      finishButton,
      newRecord,
      weftBalanceScreen,
      _overAllWeft,
      _loomFocus,
      _weaverFocus,
      newWarp,
      runningWarp,
      completeWarp,
      removeSelectedItems,
      warpTracking,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeavingController>(builder: (controller) {
      return ShortCutWidget(
        scaffoldKey: _scaffoldKey,
        appBar: AppBar(
          title: const Text("Weaving"),
          actions: [
            MyAddItemsRemoveButton(onPressed: () => removeSelectedItems()),
            Visibility(
              visible: idController.text.isNotEmpty,
              child: MyDeleteIconButton(
                onPressed: (password) async {
                  var result =
                      await controller.delete(idController.text, password);

                  if (result == "success") {
                    _initValue();
                    _loomFocus();
                  }
                },
              ),
            ),
            Tooltip(
              message: "Warp tracking (Ctrl+t)",
              child: TextButton(
                onPressed: () => warpTracking(),
                child: const Text('WARP TRACKING'),
              ),
            ),
            Tooltip(
              message: "Finish (Ctrl+F)",
              child: TextButton(
                onPressed: () async {
                  finishButton();
                },
                child: const Text('FINISH'),
              ),
            ),
            Tooltip(
              message: "All Weft (F7)",
              child: TextButton(
                onPressed: () => _overAllWeft(),
                child: const Text('All Weft'),
              ),
            ),
            Tooltip(
              message: "Save (Ctrl+S)",
              child: TextButton(
                onPressed: () async {
                  saveButton();
                },
                child: const Text('SAVE'),
              ),
            ),
            Tooltip(
              message: "Add (Ctrl+N)",
              child: TextButton(
                onPressed: () async => _addItem(),
                child: const Text('ADD'),
              ),
            ),
            PopupMenuButton(
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: const Tooltip(
                      message: "New Record (Shift+R)",
                      child: Text('New Record')),
                  onTap: () async {
                    newRecord();
                  },
                ),
                PopupMenuItem(
                  child: const Tooltip(
                      message: "Payment Details (Ctrl+P)",
                      child: Text('Payment Details')),
                  onTap: () async {
                    _payDetails();
                  },
                ),
                PopupMenuItem(
                  child: const Tooltip(
                      message: "Edit (Ctrl+E))", child: Text('Edit')),
                  onTap: () => recordEdit(),
                ),
                PopupMenuItem(
                  child: const Tooltip(
                      message: "Weft Balance  (Ctrl+W)",
                      child: Text('Weft Balance ')),
                  onTap: () {
                    weftBalanceScreen();
                  },
                ),
                PopupMenuItem(
                  child: const Text('Wages Changes List'),
                  onTap: () {
                    if (loomController.value == null) {
                      AppUtils.showErrorToast(
                          message: "Please select Loom to continue");
                      return;
                    }

                    Get.to(() => const WagesChangesList());
                  },
                ),
              ],
            ),
            const SizedBox(width: 12),
          ],
        ),
        endDrawer: Container(
          color: Colors.white10.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Drawer(
                width: 520,
                child: WeavingBottomSheetTwo(
                  weavingDataSource: dataSource,
                  weavingDataGridController: _dataGridController,
                  itemTableCalculation: _itemListCalculation,
                  transferDetails: transferItemList,
                  transferDataSource: transferDatasource,
                ),
              ),
            ],
          ),
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
          SingleActivator(LogicalKeyboardKey.keyE, control: true):
              RecordIntent(),
          SingleActivator(LogicalKeyboardKey.keyF, control: true):
              FinishIntent(),
          SingleActivator(LogicalKeyboardKey.keyR, shift: true):
              NewRecordIntent(),
          SingleActivator(LogicalKeyboardKey.keyW, control: true):
              WeftBalanceIntent(),
          SingleActivator(LogicalKeyboardKey.f7): OverAllWeftBalanceIntent(),
          SingleActivator(LogicalKeyboardKey.f5): LoomFocusIntent(),
          SingleActivator(LogicalKeyboardKey.f6): WeaverFocusIntent(),
          SingleActivator(LogicalKeyboardKey.f1): NewIntent(),
          SingleActivator(LogicalKeyboardKey.f2): RunningIntent(),
          SingleActivator(LogicalKeyboardKey.f3): CompletedIntent(),
          SingleActivator(LogicalKeyboardKey.keyR, control: true):
              RemoveIntent(),
          SingleActivator(LogicalKeyboardKey.keyT, control: true):
              NavigateAnotherPageIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              saveButton();
            }),
            AddNewIntent: SetCounterAction(perform: () {
              _addItem();
            }),
            PrintIntent: SetCounterAction(perform: () {
              _payDetails();
            }),
            RecordIntent: SetCounterAction(perform: () {
              recordEdit();
            }),
            FinishIntent: SetCounterAction(perform: () {
              finishButton();
            }),
            NewRecordIntent: SetCounterAction(perform: () {
              newRecord();
            }),
            WeftBalanceIntent: SetCounterAction(perform: () {
              weftBalanceScreen();
            }),
            OverAllWeftBalanceIntent: SetCounterAction(perform: () {
              _overAllWeft();
            }),
            NewIntent: SetCounterAction(perform: () {
              newWarp();
            }),
            RunningIntent: SetCounterAction(perform: () {
              runningWarp();
            }),
            CompletedIntent: SetCounterAction(perform: () {
              completeWarp();
            }),
            RemoveIntent: SetCounterAction(perform: () {
              removeSelectedItems();
            }),
            LoomFocusIntent: SetCounterAction(perform: () {
              _loomFocus();
            }),
            WeaverFocusIntent: SetCounterAction(perform: () {
              _weaverFocus();
            }),
            NavigateAnotherPageIntent:
                SetCounterAction(perform: () => warpTracking()),
          },
          child: FocusScope(
            autofocus: true,
            child: LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 190,
                      width: Get.width,
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Color(0xFFF9F3FF), width: 8),
                          )),
                      child: weaver(),
                    ),
                    SizedBox(
                      height: constraint.maxHeight - 190,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 8,
                            child: itemsTable(),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            flex: 2,
                            child: Column(
                              children: [
                                Obx(
                                  () => Visibility(
                                    visible: transferItemList.isNotEmpty,
                                    child: Flexible(
                                      flex: 2,
                                      child: transferDetails(),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: privateWeftItemTable(),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      );
    });
  }

  Widget weaver() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  weaverDropDownWidget(),
                  const SizedBox(height: 6),
                  Text(
                    " ${weaverController.value?.mobileNo ?? ''}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  loomDropDownWidget(),
                ],
              ),
            ),
            const SizedBox(width: 4),
            ExcludeFocusTraversal(
              child: Flexible(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Visibility(
                        visible: weavingAccount.value != null,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Table(
                                border: TableBorder.all(color: Colors.black12),
                                children: [
                                  TableRow(children: [
                                    MyLabelTile(
                                      title:
                                          ('${weavingAccount.value?.firmName}'),
                                      subtitle: ('Firm'),
                                    ),
                                    MyLabelTile(
                                      title:
                                          '${weavingAccount.value?.productName}',
                                      subtitle: ('Product'),
                                    ),
                                    MyLabelTile(
                                      title:
                                          ('${weavingAccount.value?.currentStatus}, ${weavingAccount.value?.id}'),
                                      subtitle: ('Weav Status'),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    MyLabelTile(
                                      title: ('${weavingAccount.value?.wages}'),
                                      subtitle: ('Wages (Rs)'),
                                    ),
                                    MyLabelTile(
                                      title:
                                          ('Unit Length : ${weavingAccount.value?.unitLength}'),
                                      subtitle:
                                          ('Pick & Width : ${weavingAccount.value?.pick} x ${weavingAccount.value?.width}'),
                                    ),
                                    MyLabelTile(
                                        title: displayName.value,
                                        /* ('${weaverController.value?.ledgerName}'),*/
                                        subtitle: displayDate.value
                                        /* ('${weaverController.value?.city ?? ''} | ${weaverController.value?.mobileNo ?? ''}'),*/
                                        ),
                                  ]),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Tooltip(
                                                message:
                                                    "${warpDetailsController.value}, ${warpDetailsOtherController.value}",
                                                child: RichText(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    text: "Details : ",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            '${warpDetailsController.value}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xff9c2121),
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${warpDetailsOtherController.value}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Tooltip(
                                                message:
                                                    "${warpColorController.value}, ${warpColorOtherController.value}",
                                                child: RichText(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    text: "Warp Color : ",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            '${warpColorController.value}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xff9c2121),
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${warpColorOtherController.value}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: ExcludeFocusTraversal(
                child: Container(
                  padding: const EdgeInsets.all(2),
                  child: Obx(
                    () => ListView.separated(
                      itemCount: weavingList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var item = weavingList[index];
                        return Tooltip(
                          message: '${item.currentStatus}',
                          child: Obx(
                            () {
                              var selectedId = weavingAccount.value?.id;
                              var idd = selectedId == item.id;
                              return Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.5,
                                        color:
                                            idd ? Colors.blue : Colors.grey)),
                                child: ListTile(
                                  selected: idd,
                                  trailing: Icon(
                                    Icons.circle,
                                    color: item.color == "GREEN"
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  onTap: () => initWeavingAccount(index: index),
                                  title: Text(
                                    '${item.currentStatus}',
                                    style: TextStyle(
                                        fontWeight: idd
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(height: 4);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget itemsTable() {
    return MySFDataGridItemTable(
      areFocusable: true,
      color: Colors.white,
      controller: _dataGridController,
      navigationMode: GridNavigationMode.cell,
      selectionMode: SelectionMode.single,
      selectionManager: _customSelectionManager,
      scrollPhysics: const AlwaysScrollableScrollPhysics(),
      shrinkWrapRows: false,
      filtering: true,
      allowColumnsResizing: true,
      columns: [
        GridColumn(
          allowFiltering: false,
          columnName: 'id',
          width: columnWidths['id']!,
          minimumWidth: 60,
          label: const MyDataGridHeader(title: 'S.No'),
        ),
        GridColumn(
          allowFiltering: false,
          width: columnWidths['entry_date']!,
          minimumWidth: 100,
          columnName: 'entry_date',
          label: const MyDataGridHeader(title: 'Date'),
        ),
        GridColumn(
          allowFiltering: true,
          width: columnWidths['entry_type']!,
          minimumWidth: 150,
          columnName: 'entry_type',
          label: const MyDataGridHeader(title: 'Entry Type'),
          filterPopupMenuOptions:
              const FilterPopupMenuOptions(canShowSortingOptions: false),
        ),
        GridColumn(
          allowFiltering: true,
          width: columnWidths['particulars']!,
          minimumWidth: 350,
          columnName: 'particulars',
          label: const MyDataGridHeader(title: 'Particulars'),
          filterPopupMenuOptions:
              const FilterPopupMenuOptions(canShowSortingOptions: false),
        ),
        GridColumn(
          allowFiltering: false,
          width: columnWidths['quantity']!,
          minimumWidth: 60,
          columnName: 'quantity',
          label: const MyDataGridHeader(title: 'Qty'),
        ),
        GridColumn(
          allowFiltering: false,
          width: columnWidths['credit']!,
          minimumWidth: 70,
          columnName: 'credit',
          label: const MyDataGridHeader(title: 'Credit'),
        ),
        GridColumn(
          allowFiltering: false,
          width: columnWidths['debit']!,
          minimumWidth: 70,
          columnName: 'debit',
          label: const MyDataGridHeader(title: 'Debit'),
        ),
        GridColumn(
          width: columnWidths['details']!,
          minimumWidth: 350,
          columnName: 'details',
          label: const MyDataGridHeader(title: 'Details'),
          filterPopupMenuOptions:
              const FilterPopupMenuOptions(canShowSortingOptions: false),
        ),
        GridColumn(
          allowFiltering: false,
          columnName: 'bm',
          width: columnWidths['bm']!,
          minimumWidth: 65,
          label: const MyDataGridHeader(title: 'bm'),
        ),
        GridColumn(
          allowFiltering: false,
          columnName: 'bbn',
          width: columnWidths['bbn']!,
          minimumWidth: 65,
          label: const MyDataGridHeader(title: 'bbn'),
        ),
        GridColumn(
          allowFiltering: false,
          columnName: 'sht',
          width: columnWidths['sht']!,
          minimumWidth: 65,
          label: const MyDataGridHeader(title: 'sht'),
        ),
        GridColumn(
          allowFiltering: false,
          columnName: 'sync',
          minimumWidth: double.nan,
          width: columnWidths['sync']!,
          visible: false,
          label: const MyDataGridHeader(title: 'Sync'),
        ),
      ],
      source: dataSource,
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'quantity',
              columnName: 'quantity',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'particulars',
              columnName: 'particulars',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'credit',
              columnName: 'credit',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'debit',
              columnName: 'debit',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'details',
              columnName: 'details',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'bm',
              columnName: 'bm',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'bbn',
              columnName: 'bbn',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'sht',
              columnName: 'sht',
              summaryType: GridSummaryType.sum,
            ),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      onRowSingleSelect: (index) {
        getCreatedByAndUpdatedByDetails(index);
      },
      onRowSelected: (index) async {
        var item = controller.itemList[index];
        /*if (item["entry_type"] == "Goods Inward") {
          var result = await _wagesChange(item);
          if (result == "success") {
            _initLogs();
          }
        } else*/
        if (item["entry_type"] == "Warp Delivery") {
          String? warpId;
          warpId = "${item["warp_id"]}";

          if (warpId.isNotEmpty) {
            Get.toNamed(WarpSearchReport.routeName, arguments: warpId);
          }
        }
      },
      onLongPress: (result) {
        var index = result['index'];
        var columnName = result['column_name'];
        var item = controller.itemList[index];
        if (columnName == 'entry_date') {
          DateTime dateTimeCreatedAt = DateTime.parse('${item['e_date']}');
          DateTime dateTimeNow = DateTime.now();
          final differenceInDays =
              dateTimeNow.difference(dateTimeCreatedAt).inDays;
          AppUtils.weavingToast(
              message: 'Last ${item['entry_type']} $differenceInDays days ago');
        } else if (columnName == "credit") {
          if (item["entry_type"] == "Goods Inward") {
            AppUtils.weavingToast(message: "Wages : ${item["wages"]}");
          }
        }
      },
      onColumnResizeUpdate: (details) {
        setState(() {
          columnWidths[details.column.columnName] = details.width;
        });
        return true;
      },
    );
  }

  /// transfer warp and yarn details table
  Widget transferDetails() {
    return MySFDataGridItemTable(
      color: Colors.white,
      source: transferDatasource,
      shrinkWrapRows: false,
      scrollPhysics: const AlwaysScrollableScrollPhysics(),
      columns: [
        GridColumn(
          columnName: 's_no',
          width: 40,
          label: const MyDataGridHeader(title: 'S.N'),
        ),
        GridColumn(
          width: 120,
          columnName: 'entry_type',
          label: const MyDataGridHeader(title: 'Entry Type'),
        ),
        GridColumn(
          minimumWidth: 300,
          columnName: 'particulars',
          label: const MyDataGridHeader(title: 'Particulars'),
        ),
        GridColumn(
          minimumWidth: 300,
          visible: false,
          columnName: 'warp_type',
          label: const MyDataGridHeader(title: 'Warp type'),
        ),
      ],
    );
  }

  /// private weft details table
  Widget privateWeftItemTable() {
    return MySFDataGridItemTable(
      color: Colors.white,
      selectionMode: SelectionMode.single,
      shrinkWrapRows: false,
      scrollPhysics: const AlwaysScrollableScrollPhysics(),
      columns: [
        GridColumn(
          width: 200,
          columnName: 'yarn_name',
          label: const MyDataGridHeader(title: 'Yarn Name'),
        ),
        GridColumn(
          width: 110,
          columnName: 'quantity',
          label: const MyDataGridHeader(title: 'Quantity'),
        ),
        GridColumn(
          width: 130,
          columnName: 'weft_type',
          label: const MyDataGridHeader(title: 'Weft Type'),
        ),
      ],
      source: privateWeftItemDataSource,
    );
  }

  /// private weft api call
  void privateWeftApiCall(var weavingAcId, var productId) async {
    privateWeftDetails.clear();
    privateWeftItemDataSource.updateDataGridRows();
    privateWeftItemDataSource.updateDataGridSource();

    PrivateWeftRequirementListModel? item = await controller
        .weavingAcIdByPrivateWeftDetails(weavingAcId, productId);
    item?.itemDetails?.forEach((element) {
      var result = element.toJson();
      privateWeftDetails.add(result);
      privateWeftItemDataSource.updateDataGridRows();
      privateWeftItemDataSource.updateDataGridSource();
    });
  }

  /// transfer balance details API call

  void transferDetailsApiCall(
      int? weavingAccountId, List<dynamic> weaverLogList) async {
    transferItemList.clear();
    transferDatasource.updateDataGridRows();
    transferDatasource.updateDataGridSource();
    List<WeaverTransferYarnModel> yarnList = [];
    List<WeavingOtherWarpBalanceModel> warpList = [];

    var results = await Future.wait([
      controller.transferYarnBalance(weavingAccountId),
      controller.otherWarpBalance(weavingAccountId),
    ]);

    yarnList = results[0] as List<WeaverTransferYarnModel>;
    warpList = results[1] as List<WeavingOtherWarpBalanceModel>;

    if (yarnList.isNotEmpty) {
      for (var e in yarnList) {
        transferItemList.add({
          "entry_type": "Trsfr - Yarn",
          "yarn_id": e.yarnId,
          "yarn_name": e.yarnName,
          "yarn_qty": e.weftBalance,
        });
      }
    }

    if (warpList.isNotEmpty) {
      for (var e in warpList) {
        transferItemList.add({
          "entry_type": "Trsfr - Warp",
          "warp_design_id": e.warpDesignId,
          "warp_name": e.warpName,
          "warp_qty": e.balanceQty,
          "warp_meter": e.balanceMeter,
          "warp_type": e.warpType,
        });
      }
    }

    if (weaverLogList.isNotEmpty) {
      num bmIn = 0;
      num bmOut = 0;
      num bbnIn = 0;
      num bbnOut = 0;
      num sheetIn = 0;
      num sheetOut = 0;

      num balanceBeam = 0;
      num balanceBobbin = 0;
      num balanceSheet = 0;
      num balanceAmount = 0;

      /// Amount
      num creditAmount = 0;
      num debitAmount = 0;

      for (var e in weaverLogList) {
        /// Credit Amount Calculation
        if (e['credit'] != 0 && e["credit"] != null) {
          creditAmount += e['credit'];
        }

        /// Debit Amount Calculation
        if (e['debit'] != 0 && e["debit"] != null) {
          debitAmount += e['debit'];
        }

        if (e["bm_in"] != null && e["bm_in"] != 0) {
          bmIn += e['bm_in'];
        }
        if (e["bm_out"] != null && e["bm_out"] != 0) {
          bmOut += e['bm_out'];
        }
        if (e["bbn_in"] != null && e["bbn_in"] != 0) {
          bbnIn += e['bbn_in'];
        }
        if (e["bbn_out"] != null && e["bbn_out"] != 0) {
          bbnOut += e['bbn_out'];
        }
        if (e["sht_in"] != null && e["sht_in"] != 0) {
          sheetIn += e['sht_in'];
        }
        if (e["sht_out"] != null && e["sht_out"] != 0) {
          sheetOut += e['sht_out'];
        }
      }

      balanceBeam = bmOut - bmIn;
      balanceBobbin = bbnOut - bbnIn;
      balanceSheet = sheetOut - sheetIn;
      balanceAmount = creditAmount - debitAmount;
      if (balanceAmount != 0) {
        transferItemList.add({
          "entry_type": "Trsfr - Amount",
          "details": balanceAmount,
        });
      }

      if (balanceSheet != 0 || balanceBobbin != 0 || balanceBeam != 0) {
        transferItemList.add({
          "entry_type": "Trsfr - Empty",
          "beam": balanceBeam,
          "bobbin": balanceBobbin,
          "sheet": balanceSheet,
        });
      }
    }

    transferItemList.sort((a, b) {
      String aCombined =
          '${a['entry_type'] ?? ''}${a["yarn_name"] ?? ''}${a["warp_name"] ?? ''}'
              .toLowerCase();
      String bCombined =
          '${b['entry_type'] ?? ''}${b["yarn_name"] ?? ''}${b["warp_name"] ?? ''}'
              .toLowerCase();

      return aCombined.compareTo(bCombined);
    });

    transferDatasource.updateDataGridRows();
    transferDatasource.updateDataGridSource();
  }

  /// If transfer warp or yarn data is added locally,
  /// but then removed after being added to the items table,
  /// return and display the transfer balance details table.

  transferBalanceDataRetrive(item) {
    var entryType = item["entry_type"];

    if (entryType == "Trsfr - Yarn") {
      transferItemList.add({
        "entry_type": "Trsfr - Yarn",
        "yarn_id": item["yarn_id"],
        "yarn_name": item["yarn_name"],
        "yarn_qty": item["yarn_qty"],
      });
    } else if (entryType == "Trsfr - Amount") {
      var amount = "0";
      if (item["credit"] != 0) {
        amount = "-${item["credit"]}";
      } else {
        amount = "${item["debit"]}";
      }
      transferItemList.add({
        "entry_type": "Trsfr - Amount",
        "details": double.tryParse(amount) ?? 0,
      });
    } else if (entryType == "Trsfr - Empty") {
      num bmIn = 0;
      num bmOut = 0;
      num bbnIn = 0;
      num bbnOut = 0;
      num sheetIn = 0;
      num sheetOut = 0;

      num balanceBeam = 0;
      num balanceBobbin = 0;
      num balanceSheet = 0;

      bmIn = item["bm_in"];
      bmOut = item["bm_out"];
      bbnIn = item["bbn_in"];
      bbnOut = item["bbn_out"];
      sheetIn = item["sht_in"];
      sheetOut = item["sht_out"];

      balanceBeam = bmIn - bmOut;
      balanceBobbin = bbnIn - bbnOut;
      balanceSheet = sheetIn - sheetOut;
      if (balanceSheet != 0 || balanceBobbin != 0 || balanceBeam != 0) {
        transferItemList.add({
          "entry_type": "Trsfr - Empty",
          "beam": balanceBeam,
          "bobbin": balanceBobbin,
          "sheet": balanceSheet,
        });
      }
    } else if (entryType == "Trsfr - Warp" || entryType == "Warp-Dropout") {
      transferItemList.add({
        "entry_type": "Trsfr - Warp",
        "warp_design_id": item["warp_design_id"],
        "warp_name": item["warp_design"],
        "warp_qty": item["warp_qty"],
        "warp_meter": item["meter"],
        "warp_type": item["warp_type"],
      });
    } else if (entryType == "Yarn Delivery" || entryType == "O.Bal - Yarn") {
      int yarnId = item["yarn_id"];
      double yarnQty = item["yarn_qty"];

      for (int i = 0; i < transferItemList.length; i++) {
        var list = transferItemList[i];
        if (list["yarn_id"] == yarnId) {
          double qty = list["yarn_qty"] - yarnQty;

          list["yarn_qty"] = qty;
        }
      }
    } else if (entryType == "Rtrn-Yarn" || entryType == "Yarn Wastage") {
      int yarnId = item["yarn_id"];
      double yarnQty = item["yarn_qty"];

      for (int i = 0; i < transferItemList.length; i++) {
        var list = transferItemList[i];
        if (list["yarn_id"] == yarnId) {
          double qty = list["yarn_qty"] + yarnQty;

          list["yarn_qty"] = qty;
        }
      }
    } else if (entryType == "Goods Inward" ||
        entryType == "Credit" ||
        entryType == "O.Bal - Amount") {
      double amount = 0.0;
      double credit = double.tryParse("${item["credit"]}") ?? 0.0;
      double debit = double.tryParse("${item["debit"]}") ?? 0.0;

      for (int i = 0; i < transferItemList.length; i++) {
        var list = transferItemList[i];

        if (credit != 0) {
          amount = (double.tryParse("${list["details"]}") ?? 0.0) - credit;
        } else {
          amount = (double.tryParse("${list["details"]}") ?? 0.0) + debit;
        }
        if (list["entry_type"] == "Trsfr - Amount") {
          transferItemList[i]["details"] = amount;
        }
      }
    } else if (entryType == "Payment" || entryType == "Debit") {
      double amount = 0.0;
      double credit = double.tryParse("${item["credit"]}") ?? 0.0;
      double debit = double.tryParse("${item["debit"]}") ?? 0.0;

      for (int i = 0; i < transferItemList.length; i++) {
        var list = transferItemList[i];

        if (credit != 0) {
          amount = (double.tryParse("${list["details"]}") ?? 0.0) - credit;
        } else {
          amount = (double.tryParse("${list["details"]}") ?? 0.0) + debit;
        }
        if (list["entry_type"] == "Trsfr - Amount") {
          transferItemList[i]["details"] = amount;
        }
      }
    } else if (entryType == "Warp Delivery" ||
        entryType == "Warp Excess" ||
        entryType == "O.Bal - Warp") {
      double meter = double.tryParse("${item["meter"]}") ?? 0.0;
      int warpDesignId = item["warp_design_id"];
      var warpType = item["warp_type"];

      for (int i = 0; i < transferItemList.length; i++) {
        var list = transferItemList[i];

        if (list["warp_design_id"] == warpDesignId) {
          if (warpType == "Other") {
            meter = (double.tryParse("${list["warp_meter"]}") ?? 0.0) - meter;

            transferItemList[i]["warp_meter"] = meter;
          }
        }
      }
    } else if (entryType == "Warp Shortage") {
      double meter = double.tryParse("${item["meter"]}") ?? 0.0;
      int warpDesignId = item["warp_design_id"];
      var warpType = item["warp_type"];

      for (int i = 0; i < transferItemList.length; i++) {
        var list = transferItemList[i];

        if (list["warp_design_id"] == warpDesignId) {
          if (warpType == "Other") {
            meter = (double.tryParse("${list["warp_meter"]}") ?? 0.0) + meter;

            transferItemList[i]["warp_meter"] = meter;
          }
        }
      }
    }

    /// data sorting
    transferItemList.sort((a, b) {
      String aCombined =
          '${a['entry_type'] ?? ''}${a["yarn_name"] ?? ''}${a["warp_name"] ?? ''}'
              .toLowerCase();
      String bCombined =
          '${b['entry_type'] ?? ''}${b["yarn_name"] ?? ''}${b["warp_name"] ?? ''}'
              .toLowerCase();

      return aCombined.compareTo(bCombined);
    });

    transferDatasource.updateDataGridRows();
    transferDatasource.updateDataGridSource();
  }

  Future<void> removeSelectedItems() async {
    int? index = _dataGridController.selectedIndex;
    if (index >= 0) {
      var item = controller.itemList[index];
      if (item["sync"] == 0) {
        transferBalanceDataRetrive(item);

        controller.itemList.removeAt(index);
        dataSource.updateDataGridRows();
        dataSource.updateDataGridSource();
        _dataGridController.selectedIndex = index - 1;
        _itemListCalculation();
        getCreatedByAndUpdatedByDetails(index - 1);
      } else {
        if (item["challan_no"] == null || item["challan_no"] == 0) {
          if (item["id"] != null) {
            var rowId = "${item["id"]}";
            removeDialogPassword(context, rowId, index);
          }
        }
      }
    }
  }

  void removeDialogPassword(BuildContext context, var rowId, var index) {
    final passwordFormKey = GlobalKey<FormState>();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          RxBool textVisible = RxBool(true);
          TextEditingController passwordText = TextEditingController();

          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            contentPadding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            title: RichText(
              textAlign: TextAlign.start,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'ALERT!\n',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Do you want to remove?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
            content: Form(
              key: passwordFormKey,
              child: Container(
                width: 270,
                height: 90,
                margin: const EdgeInsets.only(left: 8, right: 8),
                child: Obx(() => MyTextField(
                      autofocus: true,
                      obscureText: textVisible.value,
                      width: 280,
                      controller: passwordText,
                      hintText: "Password",
                      suffixIcon: IconButton(
                        focusNode: FocusNode(skipTraversal: true),
                        icon: Icon(
                          textVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => textVisible.value = !textVisible.value,
                      ),
                      validate: "string",
                    )),
              ),
            ),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () async {
                  if (passwordFormKey.currentState!.validate()) {
                    Get.back();
                    var result = await controller.itemTableRowDelete(
                        rowId, passwordText.text);
                    if (result["data"] == "success") {
                      refreshWarpStatus();
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue), // Border color
                ),
                child: const Text(
                  'YES',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red), // Border color
                ),
                child: const Text(
                  'CANCEL',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  void initWeavingAccount({var index = 0}) async {
    if (weavingList.isNotEmpty) {
      var item = weavingList[index];
      idController.text = "${item.id}";
      weavingAccount.value = item;
      controller.request['weaving_ac_id'] = item.id;
      controller.productId = item.productId;
      controller.request['product_design_no'] = item.designNo;
      controller.productMeter = item.unitLength;
      controller.productWages = item.wages;
      controller.request['loom_no'] = item.subWeaverNo;
      controller.request['current_status'] = '${item.currentStatus}';
      _initLogs();
    } else {
      _initValue();
    }
  }

  _initLogs({int? index}) async {
    transferItemList.clear();
    transferDatasource.updateDataGridRows();
    transferDatasource.updateDataGridSource();
    privateWeftDetails.clear();
    privateWeftItemDataSource.updateDataGridSource();
    privateWeftItemDataSource.updateDataGridRows();
    warpDetailsController.value = '';
    warpColorController.value = '';
    warpDetailsOtherController.value = "";
    warpColorOtherController.value = "";
    controller.itemList.clear();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
    totalQuantity.value = 0;
    receivedQuantity.value = 0;
    credit.value = 0;
    debit.value = 0;
    bm.value = '';
    bbm.value = '';
    sht.value = '';
    debitBalance.value = "";
    creditBalance.value = "";

    var weavingAccountId = controller.request['weaving_ac_id'];
    List<dynamic> result = await controller.weavingLogs(weavingAccountId);

    transferDetailsApiCall(weavingAccountId, result);

    privateWeftApiCall(weavingAccountId, weavingAccount.value?.productId);

    controller.itemList.clear();
    controller.itemList.addAll(result);
    getCreatedByAndUpdatedByDetails(-1);
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
    _itemListCalculation();
    if (index != null) {
      _dataGridController.selectedIndex = (index - 1);
    }
    _dataGridController.scrollToRow(
      position: DataGridScrollPosition.end,
      dataSource.rows.length - 1,
    );
  }

  _callWeavingByWeaverIdAndLoomNo() async {
    weavingAccount.value = null;
    weavingList.clear();
    controller.itemList.clear();
    _itemListCalculation();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();

    transferItemList.clear();

    /// transfer balance table clear
    transferDatasource.updateDataGridRows();
    transferDatasource.updateDataGridSource();

    privateWeftDetails.clear();
    privateWeftItemDataSource.updateDataGridSource();
    privateWeftItemDataSource.updateDataGridRows();

    if (weaverController.value != null && loomController.value != null) {
      var weaverId = weaverController.value?.id;
      var loomNo = loomController.value?.loomNo;

      var result =
          await controller.weavingByWeaverIdAndLoomNo(weaverId, loomNo);
      if (result['status'] == true) {
        List<WeavingAccount> list = result['data'];
        weavingList.addAll(list);
        var index = weavingList.indexWhere((e) => e.currentStatus == 'Running');
        initWeavingAccount(index: index != -1 ? index : 0);
      } /*else {
        _dialogBuilder(result['data'], loomNo);
      }*/
    } else {
      AppUtils.showErrorToast(message: "Select Weaver And Loom");
    }
  }

  _dialogBuilder(var content, var loomNo) {
    showDialog(
      context: context,
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
          content: Text('$content'),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () async {
                Get.back();
                controller.request['loom_id'] = loomNo;
                newRecord();
              },
              autofocus: true,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue), // Border color
              ),
              child: const Text(
                'New',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addItem() async {
    if (!controller.request.containsKey('weaving_ac_id')) {
      return;
    }
    var status = controller.request['current_status'];
    if (status == 'finished') {
      return;
    }
    controller.request["sub_weaver_no"] = loomController.value!.looms.first.id;

    getTheCompletedStatusWeavNo();
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _itemListCalculation() {
    warpDetailsDisplay();
    num bmIn = 0;
    num bmOut = 0;
    num bbnIn = 0;
    num bbnOut = 0;
    num sheetIn = 0;
    num sheetOut = 0;

    /// Amount
    num creditAmount = 0;
    num debitAmount = 0;
    num creditBal = 0;
    num debitBal = 0;

    dynamic recv = 0;
    dynamic tota = 0;
    for (var e in controller.itemList) {
      var entryType = e['entry_type'];

      /// Product Qty Calculation

      if (entryType == 'Warp Delivery' || entryType == "Warp Excess") {
        if (e["warp_type"] != "Other") {
          tota += e['warp_qty'] ?? 0;
        }
      } else if (entryType == "Warp Shortage" || entryType == "Warp-Dropout") {
        if (e["warp_type"] != "Other") {
          tota -= e['warp_qty'] ?? 0;
        }
      } else {
        recv += e['inward_qty'] ?? 0;
      }

      /// Credit Amount Calculation
      if (e['credit'] != 0 && e["credit"] != null) {
        creditAmount += e['credit'];
      }

      /// Debit Amount Calculation
      if (e['debit'] != 0 && e["debit"] != null) {
        debitAmount += e['debit'];
      }

      if (e["bm_in"] != null && e["bm_in"] != 0) {
        bmIn += e['bm_in'];
      }
      if (e["bm_out"] != null && e["bm_out"] != 0) {
        bmOut += e['bm_out'];
      }
      if (e["bbn_in"] != null && e["bbn_in"] != 0) {
        bbnIn += e['bbn_in'];
      }
      if (e["bbn_out"] != null && e["bbn_out"] != 0) {
        bbnOut += e['bbn_out'];
      }
      if (e["sht_in"] != null && e["sht_in"] != 0) {
        sheetIn += e['sht_in'];
      }
      if (e["sht_out"] != null && e["sht_out"] != 0) {
        sheetOut += e['sht_out'];
      }
    }

    creditBal = creditAmount - debitAmount;
    debitBal = debitAmount - creditAmount;
    if (creditBal >= 1) {
      creditBalance.value = "Cr Bal : $creditBal";
    } else {
      creditBalance.value = '';
    }
    if (debitBal >= 1) {
      debitBalance.value = "De Bal : $debitBal";
    } else {
      debitBalance.value = "";
    }

    totalQuantity.value = tota;
    receivedQuantity.value = recv;
    credit.value = creditAmount;
    debit.value = debitAmount;
    controller.creditAmount = creditAmount;
    controller.debitAmount = debitAmount;
    // controller.change(totalQuantity);

    controller.bmOut = bmOut;
    controller.bmIn = bmIn;
    controller.bbnOut = bbnOut;
    controller.bbnIn = bbnIn;
    controller.shtOut = sheetOut;
    controller.shtIn = sheetIn;
    bm.value = 'Bal : ${bmOut - bmIn}';
    bbm.value = 'Bal : ${bbnOut - bbnIn}';
    sht.value = 'Bal : ${sheetOut - sheetIn}';
  }

  void _initValue() {
    controller.request = <String, dynamic>{};
    warpDetailsController.value = "";
    warpColorController.value = "";
    warpDetailsOtherController.value = "";
    warpColorOtherController.value = "";
    weavingAccount.value = null;
    totalQuantity.value = 0;
    receivedQuantity.value = 0;
    credit.value = 0;
    debit.value = 0;
    creditBalance.value = "";
    debitBalance.value = "";
    loomController.value = null;
    loomTextEditingController.text = '';
    bm.value = '';
    bbm.value = '';
    sht.value = '';
    weavingList.clear();
    controller.itemList.clear();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
    warpDetailsDisplay();

    /// transfer balance table clear
    transferItemList.clear();
    transferDatasource.updateDataGridRows();
    transferDatasource.updateDataGridSource();
  }

  warpDetailsDisplay() {
    warpDetailsController.value = "";
    warpDetailsOtherController.value = "";
    warpColorOtherController.value = "";
    warpColorController.value = "";
    String mainWarpDetails = "";
    String otherWarpDetails = "";
    String mainWarpColor = "";
    String otherWarpColor = "";

    for (var e in controller.itemList) {
      if (e["entry_type"] == "Warp Delivery") {
        if (e["warp_type"] == "Main Warp") {
          mainWarpDetails += e["product_details"] != null
              ? "Main Warp : ${e["product_details"]} "
              : mainWarpDetails;

          mainWarpColor += e["warp_color"] != null
              ? "Main Warp : ${e["warp_color"]} "
              : mainWarpColor;
        } else if (e["warp_type"] == "Other") {
          otherWarpDetails += e["product_details"] != null
              ? "Other Warp : ${e["product_details"]} "
              : otherWarpDetails;
          otherWarpColor += e["warp_color"] != null
              ? "Other Warp : ${e["warp_color"]} "
              : otherWarpColor;
        }
      }
    }

    warpDetailsController.value = mainWarpDetails;
    warpDetailsOtherController.value = otherWarpDetails;
    warpColorController.value = mainWarpColor;
    warpColorOtherController.value = otherWarpColor;
  }

  /// Weaver Payment Details Screen Router Method
  void _payDetails() async {
    showDialog(
      context: context,
      builder: (_) => const WeavingPaymentDetails(),
    );
  }

  /// Weaving New Record Screen Edit
  void recordEdit() async {
    if (weaverController.value == null || loomController.value == null) {
      AppUtils.showErrorToast(message: "Select The Weaver Name And Loom");
      return;
    }

    var status = weavingAccount.value?.currentStatus;
    var args = weavingAccount.value;
    var result =
        await Get.toNamed(WeavingNewRecordScreen.routeName, arguments: args);
    if (result == 'success') {
      weavingList.clear();
      controller.itemList.clear();
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
      if (weaverController.value != null && loomController.value != null) {
        var weaverId = weaverController.value?.id;
        var loomNo = loomController.value?.loomNo;

        var result =
            await controller.weavingByWeaverIdAndLoomNo(weaverId, loomNo);
        if (result['status'] == true) {
          List<WeavingAccount> list = result['data'];
          weavingList.addAll(list);
          var index =
              weavingList.indexWhere((e) => e.currentStatus == '$status');
          initWeavingAccount(index: index != -1 ? index : 0);
        } else {
          _dialogBuilder(result['data'], loomNo);
        }
      }
    }
  }

  finishButton() async {
    if (weavingAccount.value?.currentStatus != "Completed") {
      return AppUtils.infoAlert(
          message: "This account is still not completed.");
    }

    finishPasswordDialog(context);
  }

  void finishPasswordDialog(BuildContext context) {
    final passwordFormKey = GlobalKey<FormState>();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          RxBool textVisible = RxBool(true);
          TextEditingController passwordText = TextEditingController();

          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            contentPadding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            title: RichText(
              textAlign: TextAlign.start,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Do you want to finish this warp?\n',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '\nonce finished, you can not alter the Record!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
            content: Form(
              key: passwordFormKey,
              child: Container(
                width: 270,
                height: 90,
                margin: const EdgeInsets.only(left: 8, right: 8),
                child: Obx(() => MyTextField(
                      autofocus: true,
                      obscureText: textVisible.value,
                      width: 280,
                      controller: passwordText,
                      hintText: "Password",
                      suffixIcon: IconButton(
                        focusNode: FocusNode(skipTraversal: true),
                        icon: Icon(
                          textVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => textVisible.value = !textVisible.value,
                      ),
                      validate: "string",
                    )),
              ),
            ),
            actions: <Widget>[
              ExcludeFocusTraversal(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('CANCEL'),
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  if (passwordFormKey.currentState!.validate()) {
                    var password = passwordText.text.toString();
                    Get.back();
                    var result = await controller.finishWeaving(password);
                    if (result["status"] == true && result["data"] == true) {
                      _callWeavingByWeaverIdAndLoomNo();
                    } else {
                      _finishList(result["data"]);
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue), // Border color
                ),
                child: const Text(
                  'YES',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  _finishList(WeavingFinishListModel data) {
    String amount = "";
    String balancePro = "";
    String bmBbnSht = "";
    String cpRelBal = "";
    String otherWarp = "";
    String yarnBalance = "";
    if (data.amount != 0) {
      amount = "Amount Balance\n";
    }
    if (data.balanceProQty != 0) {
      balancePro = "Product Balance\n";
    }
    if (data.beam != 0 || data.bobbin != 0 || data.sheet != 0) {
      bmBbnSht = "Beam,Bobbin,Sheet Balance\n";
    }
    if (data.cops != 0 || data.reel != 0) {
      cpRelBal = "Cops,Reel Balance\n";
    }
    if (data.otherWarp == true) {
      otherWarp = "Weaver Warp Stock\n";
    }
    if (data.yarnBalance == true) {
      yarnBalance = "Weaver yarn Stock\n";
    }

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
            height: 200,
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    "Selected Warp Having The Balance Value\nCheck The Following Items.."),
                const SizedBox(height: 20),
                Text(
                    "$amount$yarnBalance$otherWarp$cpRelBal$bmBbnSht$balancePro")
              ],
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () => Get.back(),
              autofocus: true,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue), // Border color
              ),
              child: const Text(
                'OK',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void saveButton() async {
    await controller.addWeavingLogs(controller.itemList);
    refreshWarpStatus();
  }

  void newRecord() async {
    /*  if (controller.request['loom_id'] == null || controller.weaverId == null) {
      return;
    }*/
    var result = await Get.toNamed(WeavingNewRecordScreen.routeName);
    if (result == 'success') {
      if (controller.weaverId == null ||
          controller.request["loom_id"] == null) {
        return;
      } else {
        /// Weaver Name Init
        var weList = controller.weaverList
            .where((element) => '${element.id}' == '${controller.weaverId}')
            .toList();
        if (weList.isNotEmpty) {
          weaverController.value = weList.first;
          var id = weList.first.id;
          controller.weaverId = id;
          weaverTextEditingController.text = "${weList.first.ledgerName}";

          /// Loom Api Call
          controller.loomInfo(id);
          var loomList = controller.loomList
              .where((element) =>
                  '${element.loomNo}' == '${controller.request['loom_id']}')
              .toList();
          if (loomList.isNotEmpty) {
            var dd = loomList[0];
            controller.request["loom_id"] = dd.loomNo;
            loomController.value = LoomGroup(loomNo: dd.loomNo);
            loomTextEditingController.text = "${dd.loomNo}";
          }
        }
        _callWeavingByWeaverIdAndLoomNo();
      }
    }
  }

  void weftBalanceScreen() async {
    if (controller.request.containsKey('weaving_ac_id') &&
        weavingAccount.value != null) {
      var args = {
        "weaving_account": weavingAccount.value,
        "receive_qty": receivedQuantity.value,
        "delivery_qty": totalQuantity.value,
        "balance_qty": totalQuantity.value - receivedQuantity.value
      };

      var result =
          await Get.toNamed(WeftBalanceNewScreen.routeName, arguments: args);
      if (result == null) {
        transferItemList.clear();
        transferDatasource.updateDataGridRows();
        transferDatasource.updateDataGridSource();
        transferDetailsApiCall(weavingAccount.value!.id, controller.itemList);

        privateWeftDetails.clear();
        privateWeftItemDataSource.updateDataGridSource();
        privateWeftItemDataSource.updateDataGridRows();
        privateWeftApiCall(
            weavingAccount.value!.id, weavingAccount.value?.productId);
      }
    }
  }

  void _overAllWeft() {
    var weaverId = weavingAccount.value?.weaverId;
    var weaverName = weavingAccount.value?.weaverName;
    var request = {
      "weaver_id": weaverId,
      "weaver_name": weaverName,
    };

    if (weaverId == null) {
      return;
    }

    Get.toNamed(WeftDeliveryBalance.routeName, arguments: request);
  }

  void _callCurrentStatus(String status) {
    var index = weavingList.indexWhere((e) => e.currentStatus == status);
    index != -1 ? initWeavingAccount(index: index) : '';
  }

  Future<void> _goodsInwardToInit() async {
    if (Get.arguments == null) {
      return;
    }
    var item = Get.arguments;

    var weaverId = item["weaver_id"];
    var loomNo = item["loom_no"];

    var result = await controller.weaver();
    weaverFocusNode.unfocus();

    /// Weaver Name Init
    var weList =
        result.where((element) => '${element.id}' == '$weaverId').toList();
    if (weList.isNotEmpty) {
      weaverController.value = weList.first;
      var id = weList.first.id;
      controller.weaverId = id;
      weaverTextEditingController.text = "${weList.first.ledgerName}";

      var result = await controller.loomInfo(id);

      /// Loom Api Call
      controller.loomInfo(id);
      var loomList =
          result.where((element) => '${element.loomNo}' == '$loomNo').toList();
      if (loomList.isNotEmpty) {
        var dd = loomList[0];
        loomController.value = LoomGroup(loomNo: dd.loomNo, looms: dd.looms);
        controller.request["loom_id"] = dd.loomNo;
        loomTextEditingController.text = "${dd.loomNo}";
        _callWeavingByWeaverIdAndLoomNo();
      }
    }
  }

  weaverDropDownWidget() {
    var list = controller.weaverList;
    return SearchField<WeaverLoomDetailsModel>(
      suggestions: weaverSuggestions(list),
      controller: weaverTextEditingController,
      itemHeight: 40,
      maxSuggestionsInViewPort: 15,
      onSearchTextChanged: (query) {
        if (query.isEmpty) {
          controller.loomList.clear();
          controller.update();
          _initValue();
        }
        return weaverSuggestions(list, query: query);
      },
      onSuggestionTap: (value) async {
        _initValue();
        var item = value.item!;
        var id = item.id;
        controller.weaverId = id;
        controller.loomList.clear();
        weaverController.value = item;
        controller.request["weaver_name"] = item.ledgerName;
        await controller.loomInfo(id);
        FocusScope.of(context).requestFocus(loomFocusNode);
      },
      searchInputDecoration: const InputDecoration(
          label: Text('Weaver'),
          labelStyle: TextStyle(fontSize: 14),
          contentPadding: EdgeInsets.symmetric(horizontal: 4),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
          ),
          suffixIcon: Icon(Icons.arrow_drop_down)),
      suggestionsDecoration: SuggestionDecoration(
          selectionColor: const Color(0xffA3D8FF), width: 670),
      autofocus: true,
      focusNode: weaverFocusNode,
    );
  }

  loomSuggestions(List<LoomGroup> list, {var query = ''}) {
    final filter = list
        .where((element) =>
            '$element'.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    var suggestions = filter.map(
      (e) {
        var newDD = e.looms.where((f) => f.currentStatus == 'New');
        var runningDD = e.looms.where((f) => f.currentStatus == 'Running');
        var completedDD = e.looms.where((f) => f.currentStatus == 'Completed');
        return SearchFieldListItem<LoomGroup>(
          '${e.loomNo}',
          item: e,
          child: Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(4),
                  width: 100,
                  child: Text('${e.loomNo}')),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(newDD.isNotEmpty ? 'New' : ''),
                  ),
                  SizedBox(
                      width: 100,
                      child: Text(runningDD.isNotEmpty ? 'Running' : '')),
                  SizedBox(
                      width: 100,
                      child: Text(completedDD.isNotEmpty ? 'Completed' : '')),
                ],
              ),
            ],
          ),
        );
      },
    ).toList();

    return suggestions;
  }

  loomDropDownWidget() {
    var list = controller.loomList;
    return SearchField<LoomGroup>(
      suggestions: loomSuggestions(list),
      itemHeight: 40,
      maxSuggestionsInViewPort: 10,
      controller: loomTextEditingController,
      onSearchTextChanged: (query) {
        return loomSuggestions(list, query: query);
      },
      searchInputDecoration: const InputDecoration(
          label: Text('Loom'),
          labelStyle: TextStyle(fontSize: 14),
          contentPadding: EdgeInsets.symmetric(horizontal: 4),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
          ),
          suffixIcon: Icon(Icons.arrow_drop_down)),
      suggestionsDecoration: SuggestionDecoration(
          selectionColor: const Color(0xffA3D8FF), width: 500),
      focusNode: loomFocusNode,
      onScroll: (a, b) {},
      onSuggestionTap: (value) {
        loomFocusNode.unfocus();
        var item = value.item!;
        loomController.value = item;
        controller.request['loom_id'] = item.loomNo;
        _callWeavingByWeaverIdAndLoomNo();
      },
    );
  }

  _loomFocus() {
    FocusScope.of(context).requestFocus(loomFocusNode);
  }

  _weaverFocus() {
    FocusScope.of(context).requestFocus(weaverFocusNode);
  }

  weaverSuggestions(List<WeaverLoomDetailsModel> list, {var query = ''}) {
    query = query.toLowerCase().trim().replaceAll(RegExp(r'(\n){3,}'), "\n\n");
    final filter = list
        .where((element) => '$element'.toLowerCase().startsWith(query))
        .toList();
    var suggestions = filter
        .map(
          (e) => SearchFieldListItem<WeaverLoomDetailsModel>(
            '${e.ledgerName}',
            item: e,
            child: Row(
              children: [
                Container(
                    padding: const EdgeInsets.only(left: 8, bottom: 2, top: 2),
                    width: 300,
                    child: Text('${e.ledgerName}')),
                Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        "${e.totalLooms != 0 ? e.totalLooms : ''}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        "${e.activeLooms != 0 ? e.activeLooms : ''}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        tryCast(e.city),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        "${e.virtualLoom != 0 ? e.virtualLoom : ""}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
        .toList();

    return suggestions;
  }

  refreshWarpStatus() async {
    var id = weavingAccount.value?.id;
    weavingList.clear();
    controller.itemList.clear();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
    if (weaverController.value != null && loomController.value != null) {
      var weaverId = weaverController.value?.id;
      var loomNo = loomController.value?.loomNo;

      var result =
          await controller.weavingByWeaverIdAndLoomNo(weaverId, loomNo);
      if (result['status'] == true) {
        List<WeavingAccount> list = result['data'];
        weavingList.addAll(list);
        var index = weavingList.indexWhere((e) => "${e.id}" == '$id');
        initWeavingAccount(index: index != -1 ? index : 0);
      }
    } else {
      AppUtils.showErrorToast(message: "Select Weaver And Loom");
    }
  }

  Widget crateAndUpdatedBy() {
    return Wrap(
      children: [
        Text(
          displayName.value,
          style: AppUtils.weavingWarpDetails(),
        ),
        const SizedBox(width: 12),
        Text(
          displayDate.value,
          style: AppUtils.weavingWarpDetails(),
        )
      ],
    );
  }

  getCreatedByAndUpdatedByDetails(int index) {
    if (index >= 0) {
      var item = controller.itemList[index];
      DateTime createDate = DateTime.parse(item["created_at"] ?? "0000-00-00");
      DateTime updateDate = DateTime.parse(item["updated_at"] ?? "0000-00-00");
      createdAt = AppUtils.dateFormatter.format(createDate);
      updatedAt = AppUtils.dateFormatter.format(updateDate);
      createdBy = "${item["creator_name"]}";
      updatedBy = item["updated_name"];
      if (updatedBy != null) {
        displayName.value = "Edit: ${updatedBy ?? ''}";
        displayDate.value = "$updatedAt";
      } else {
        displayName.value = "New: ${createdBy ?? ''}";
        displayDate.value = "$createdAt";
      }
    } else {
      if (controller.itemList.isEmpty) {
        return;
      }
      var item = controller.itemList.last;

      DateTime createDate = DateTime.parse(item["created_at"] ?? "0000-00-00");
      DateTime updateDate = DateTime.parse(item["updated_at"] ?? "0000-00-00");
      createdAt = AppUtils.dateFormatter.format(createDate);
      updatedAt = AppUtils.dateFormatter.format(updateDate);
      createdBy = item["creator_name"];
      updatedBy = item["updated_name"];
      if (updatedBy != null) {
        displayName.value = "Edit : $updatedBy";
        displayDate.value = "$updatedAt";
      } else {
        displayName.value = "New : $createdBy";
        displayDate.value = "$createdAt";
      }
    }
  }

  /// this methode used to remove the current loom
  /// completed warp status in transfer enter type's
  getTheCompletedStatusWeavNo() {
    var result =
        weavingList.where((e) => "${e.currentStatus}" == "Completed").toList();

    if (result.isNotEmpty) {
      controller.request["remove_weve_no"] = result.first.id;
    }
  }

  newWarp() {
    // change the New warp details
    controller.status.isLoading ? null : _callCurrentStatus("New");
  }

  runningWarp() {
    // change the Running warp details
    controller.status.isLoading ? null : _callCurrentStatus("Running");
  }

  completeWarp() {
    // change the Complete warp details
    controller.status.isLoading ? null : _callCurrentStatus("Completed");
  }

  warpTracking() {
    if (weaverController.value == null || loomController.value == null) {
      return;
    }

    var request = {
      "weaver_id": weaverController.value?.id,
      "weaver_name": weaverController.value?.ledgerName,
      "loom_no": loomController.value?.loomNo,
    };

    Get.toNamed(WarpTrackingList.routeName, arguments: request);
  }
}

class WeavingItemDataSource extends DataGridSource {
  WeavingItemDataSource({
    required List<dynamic> list,
    required totalQuantity,
    required receivedQuantity,
    required beam,
    required bobbin,
    required sheet,
    required credit,
    required debit,
    required debitBalance,
    required creditBalance,
  }) {
    _list = list;
    _totalQuantity = totalQuantity;
    _receivedQuantity = receivedQuantity;

    _beam = beam;
    _bobbin = bobbin;
    _sheet = sheet;
    _credit = credit;
    _debit = debit;
    _creditBalance = creditBalance;
    _debitBalance = debitBalance;
    updateDataGridRows();
  }

  var today = DateFormat('dd-MM-yyyy').format(DateTime.now()).substring(0, 10);
  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;
  late RxNum _totalQuantity;
  late RxNum _receivedQuantity;
  late RxNum _credit;
  late RxNum _debit;

  late RxString _beam;
  late RxString _bobbin;
  late RxString _sheet;
  late RxString _creditBalance;
  late RxString _debitBalance;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var index = _list.indexOf(e);
      DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
      DateTime eDate = DateTime.parse(e["e_date"] ?? "00-00-0000");
      var date = dateFormatter.format(eDate);

      var particulars = "";
      dynamic quantity = 0;
      dynamic credit = 0;
      dynamic debit = 0;

      dynamic bmIn = 0;
      dynamic bmOut = 0;
      dynamic bbnIn = 0;
      dynamic bbnOut = 0;
      dynamic shtIn = 0;
      dynamic shtOut = 0;
      var details = "";
      double yarnQty = 0.0;
      if (e["yarn_qty"] != null) {
        yarnQty = double.tryParse("${e["yarn_qty"]}") ?? 0;
      }

      bmIn = e['bm_in'] ?? 0;
      bmOut = e['bm_out'] ?? 0;

      bbnIn = e['bbn_in'] ?? 0;
      bbnOut = e['bbn_out'] ?? 0;

      shtIn = e['sht_in'] ?? 0;
      shtOut = e['sht_out'] ?? 0;

      /// Warp Delivery
      if (e["entry_type"] == "Warp Delivery") {
        particulars = "${e["warp_design"]}";
        var challanNo = "";
        if (e["challan_no"] != null && e["challan_no"] != 0) {
          challanNo = "ChNo ${e["challan_no"]},";
        }

        if (e["warp_type"] == "Other") {
          details = "$challanNo  ${e["warp_id"]}, Mr: ${e["meter"]}";
        } else {
          quantity = e["warp_qty"];
          details = "$challanNo  ${e["warp_id"]}";
        }
      }

      /// Yarn Delivery
      if (e["entry_type"] == "Yarn Delivery") {
        var challanNo = "";
        if (e["challan_no"] != null && e["challan_no"] != 0) {
          challanNo = "ChNo ${e["challan_no"]} ,";
        }

        particulars = "${e["yarn_name"]} - ${e["color_name"]}";
        if (e["yarn_empty_type"] == "Cops") {
          details =
              "$challanNo ${yarnQty.toStringAsFixed(3)} Kgs, C - ${e["cops_out"]}";
        } else if (e["yarn_empty_type"] == "Reel") {
          details =
              "$challanNo ${yarnQty.toStringAsFixed(3)} Kgs, R - ${e["reel_out"]}";
        } else {
          details = "$challanNo  ${yarnQty.toStringAsFixed(3)} Kgs";
        }
      }

      /// Goods Inward
      if (e["entry_type"] == "Goods Inward") {
        var sareWeight = '';
        var checkerName = "";
        var challanNo = "";

        if (e["challan_no"] != null && e["challan_no"] != 0) {
          challanNo = "ChNo ${e["challan_no"]}, ";
        }

        if (e["saree_weight"] != 0) {
          sareWeight = "${e["saree_weight"].toStringAsFixed(3)}, ";
        }

        if (e["saree_checker_name"] != null) {
          checkerName = "${e["saree_checker_name"]}, ";
        }

        var otherWarp = '';

        if (e["used_other_warp"] != null) {
          otherWarp =
              "${e["used_other_warp"]}".replaceAll("[", "").replaceAll("]", "");
        }

        var pending = "";
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
        quantity = e["inward_qty"];
        credit = e["credit"];
        details =
            "$sareWeight$checkerName$challanNo$warpDetails$pending$otherWarp";
      }

      /// Payment
      if (e["entry_type"] == "Payment") {
        var challanNo = "";
        if (e["challan_no"] != null && e["challan_no"] != 0) {
          challanNo = "ChNo ${e["challan_no"]},";
        }

        particulars = "To: ${e["pr_ledger_name"]}";
        debit = e["debit"];
        details = "$challanNo ${tryCast(e["product_details"])}";
      }

      /// Empty In/Out
      if (e["entry_type"] == "Empty - (In / Out)") {
        var challanNo = "";
        if (e["challan_no"] != null && e["challan_no"] != 0) {
          challanNo = "ChNo ${e["challan_no"]},";
        }

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
        details = "$challanNo ${tryCast(e["product_details"])}";
      }

      /// Return Yarn
      if (e["entry_type"] == "Rtrn-Yarn") {
        var challanNo = "";
        if (e["challan_no"] != null && e["challan_no"] != 0) {
          challanNo = "ChNo ${e["challan_no"]},";
        }

        particulars = "${e["yarn_name"]} - ${e["color_name"]}";

        if (e["yarn_empty_type"] == "Cops") {
          details =
              "$challanNo ${yarnQty.toStringAsFixed(3)} Kgs, C - ${e["cops_in"]}, ${e["product_details"]}";
        } else if (e["yarn_empty_type"] == "Reel") {
          details =
              "$challanNo ${yarnQty.toStringAsFixed(3)} Kgs, R - ${e["reel_in"]}, ${e["product_details"]}";
        } else {
          details = "$challanNo ${yarnQty.toStringAsFixed(3)} Kgs";
        }
      }

      /// Receipt
      if (e["entry_type"] == "Receipt") {
        particulars = "By : ${e["pr_ledger_name"]}";
        credit = e["credit"];
        details = tryCast(e["product_details"]);
      }

      /// Credit
      if (e["entry_type"] == "Credit") {
        particulars = "By : ${e["pr_ledger_name"]}";
        credit = e["credit"];
        details = tryCast(e["product_details"]);
      }

      /// Debit
      if (e["entry_type"] == "Debit") {
        var challanNo = "";
        if (e["challan_no"] != null && e["challan_no"] != 0) {
          challanNo = "ChNo ${e["challan_no"]},";
        }

        particulars = "To : ${e["pr_ledger_name"]}";
        debit = e["debit"] ?? 0;
        details = "$challanNo ${tryCast(e["product_details"])}";
      }

      /// Yarn Wastage
      if (e["entry_type"] == "Yarn Wastage") {
        particulars = "${e["yarn_name"]}";
        details = "${tryCast(e["yarn_qty"])} Kgs, ${e["product_details"]}";
      }

      /// Warp Excess
      if (e["entry_type"] == "Warp Excess") {
        particulars = "${e["warp_design"]}";

        if (e["warp_type"] == "Other") {
          details = "Mr: ${e["meter"]}, ${tryCast(e["we_details"])}";
        } else {
          details = tryCast(e["we_details"]);
          quantity = e["warp_qty"];
        }
      }

      /// Warp Shortage
      if (e["entry_type"] == "Warp Shortage") {
        var meter = "";
        if (e["meter"] != null &&
            e["meter"] != 0 &&
            e["warp_type"] == "Other") {
          meter = "Mr :${e["meter"]} ,";
        }
        particulars = "${e["warp_design"]}";
        if (e["warp_type"] != "Other") {
          quantity = e["warp_qty"];
        }
        details = "$meter ${tryCast(e["we_details"])}";
      }

      /// Message
      if (e["entry_type"] == "Message") {
        particulars = "${e["message"]}";
      }

      /// Transfer Amount
      if (e["entry_type"] == "Trsfr - Amount") {
        credit = e["credit"];
        debit = e["debit"];
        if (e["sync"] == 0) {
          details =
              "[No: ${e["trans_to_no"]} ], TrFr to Lm : ${e["loom"]} -> ${e["current_status"]}";
        } else {
          details = tryCast(e["product_details"]);
        }
      }

      /// Transfer Cops/Reels
      if (e["entry_type"] == "Trsfr - Cops,Reel") {
        if (e["sync"] == 0) {
          details =
              "[No: ${e["trans_to_no"]} ], TrFr to Lm : ${e["loom"]} -> ${e["current_status"]}";
        } else {
          details = tryCast(e["product_details"]);
        }
      }

      /// Transfer Warp
      if (e["entry_type"] == "Trsfr - Warp") {
        var yarnName = "";
        if (e["yarn_name"] != null) {
          yarnName = "( ${e["yarn_name"]} ), ";
        }
        particulars = "$yarnName${e["warp_design"]}";

        if (e["sync"] == 0) {
          details =
              "Mr : ${e["meter"]}, [No: ${e["trans_to_no"]} ], TrFr to Lm : ${e["loom"]} -> ${e["current_status"]}";
        } else {
          details = "Mr : ${e["meter"]}, ${tryCast(e["we_details"])}";
        }
      }

      /// Transfer Yarn
      if (e["entry_type"] == "Trsfr - Yarn") {
        particulars = "${e["yarn_name"]}";

        if (e["sync"] == 0) {
          details =
              "${yarnQty.toStringAsFixed(3)} Kgs, [No: ${e["trans_to_no"]} ], TrFr to Lm : ${e["loom"]} -> ${e["current_status"]}";
        } else {
          details = tryCast(e["product_details"]);
        }
      }

      /// Transfer Empty
      if (e["entry_type"] == "Trsfr - Empty") {
        var bmIn = "";
        var bmOut = "";
        var bbnIn = "";
        var bbnOut = "";
        var shtIn = "";
        var shtOut = "";

        /// Display The Deliver And Inward Beam Qty
        if (e["bm_in"] != 0 && e["bm_in"] != null) {
          bmIn = "Beam IN - ${e["bm_in"]}, ";
        } else if (e["bm_out"] != 0 && e["bm_out"] != null) {
          bmOut = "Beam OUT - ${e["bm_out"]}, ";
        }

        /// Display The Deliver And Inward Bobbin Qty
        if (e["bbn_in"] != 0 && e["bbn_in"] != null) {
          bbnIn = "Bobbin IN - ${e["bbn_in"]}, ";
        } else if (e["bbn_out"] != 0) {
          bbnOut = "Bobbin OUT - ${e["bbn_out"]}, ";
        }

        /// Display The Deliver And Inward Sheet Qty
        if (e["sht_in"] != 0 && e["sht_in"] != null) {
          shtIn = "Sheet IN - ${e["sht_in"]}, ";
        } else if (e["sht_out"] != 0 && e["sht_out"] != null) {
          shtOut = "Sheet OUT - ${e["sht_out"]}, ";
        }

        particulars = "$bmIn$bmOut$bbnIn$bbnOut$shtIn$shtOut";

        if (e["sync"] == 0) {
          details =
              "[No: ${e["trans_to_no"]} ], TrFr to Lm : ${e["loom"]} -> ${e["current_status"]}";
        } else {
          details = tryCast(e["product_details"]);
        }
      }

      /// O.Bal Amount
      if (e["entry_type"] == "O.Bal - Amount") {
        credit = e["credit"];
        debit = e["debit"];
        details = tryCast(e["product_details"]);
      }

      /// O.Bal Cops/Reels
      if (e["entry_type"] == "O.Bal - Cops,Reel") {
        particulars = "Cops Out: ${e["cops_out"]}, Reel Out: ${e["reel_out"]}";
        details = tryCast(e["product_details"]);
      }

      /// O.Bal Warp
      if (e["entry_type"] == "O.Bal - Warp") {
        var meter = "";
        if (e["meter"] != 0 && e["meter"] != null) {
          meter = "Mr : ${e["meter"]} ,";
        }
        particulars = "${e["warp_design"]}";
        details = "$meter ${tryCast(e["wo_details"])}";
      }

      /// O.Bal Yarn
      if (e["entry_type"] == "O.Bal - Yarn") {
        particulars = "${e["yarn_name"]}";
        details =
            "${yarnQty.toStringAsFixed(3)} ${tryCast(e["product_details"])}";
      }

      /// O.Bal Empty
      if (e["entry_type"] == "O.Bal - Empty") {
        var bmIn = "";
        var bmOut = "";
        var bbnIn = "";
        var bbnOut = "";
        var shtIn = "";
        var shtOut = "";

        /// Display The Deliver And Inward Beam Qty
        if (e["bm_in"] != 0 && e["bm_in"] != null) {
          bmIn = "Beam IN - ${e["bm_in"]}, ";
        } else if (e["bm_out"] != 0 && e["bm_out"] != null) {
          bmOut = "Beam OUT - ${e["bm_out"]}, ";
        }

        /// Display The Deliver And Inward Bobbin Qty
        if (e["bbn_in"] != 0 && e["bbn_in"] != null) {
          bbnIn = "Bobbin IN - ${e["bbn_in"]}, ";
        } else if (e["bbn_out"] != 0) {
          bbnOut = "Bobbin OUT - ${e["bbn_out"]}, ";
        }

        /// Display The Deliver And Inward Sheet Qty
        if (e["sht_in"] != 0 && e["sht_in"] != null) {
          shtIn = "Sheet IN - ${e["sht_in"]}, ";
        } else if (e["sht_out"] != 0 && e["sht_out"] != null) {
          shtOut = "Sheet OUT - ${e["sht_out"]}, ";
        }

        particulars = "$bmIn$bmOut$bbnIn$bbnOut$shtIn$shtOut";
        details = tryCast(e["product_details"]);
      }

      ///inward Cops Reel
      if (e["entry_type"] == "Inward - Cops, Reel") {
        var challanNo = "";
        if (e["challan_no"] != null && e["challan_no"] != 0) {
          challanNo = "ChNo ${e["challan_no"]}";
        }

        particulars = "";
        details = challanNo;
      }

      /// Warp-Dropout
      if (e["entry_type"] == "Warp-Dropout") {
        particulars = "${e["warp_design"]}";
        if (e["warp_type"] != "Other") {
          quantity = e["warp_qty"];
        }

        if (e["warp_type"] == "Other") {
          details = "${e["warp_id"]}, Mr: ${e["meter"]}";
        } else {
          details = "${e["warp_id"]} ${tryCast(e["product_details"])}";
        }
      }

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'id', value: '${index + 1}'),
        DataGridCell<dynamic>(columnName: 'e_date', value: date),
        DataGridCell<dynamic>(columnName: 'entry_type', value: e['entry_type']),
        DataGridCell<dynamic>(columnName: 'particulars', value: particulars),
        DataGridCell<dynamic>(
            columnName: 'quantity', value: "${quantity != 0 ? quantity : ""}"),
        DataGridCell<dynamic>(
            columnName: 'credit', value: "${credit != 0 ? credit : ""}"),
        DataGridCell<dynamic>(
            columnName: 'debit', value: "${debit != 0 ? debit : ""}"),
        DataGridCell<dynamic>(columnName: 'details', value: details),
        DataGridCell<dynamic>(
            columnName: 'bm',
            value:
                '${bmIn != 0 ? '$bmIn in' : ''} ${bmOut != 0 ? '$bmOut out' : ''}'),
        DataGridCell<dynamic>(
            columnName: 'bbn',
            value:
                '${bbnIn != 0 ? '$bbnIn in' : ''} ${bbnOut != 0 ? '$bbnOut out' : ''}'),
        DataGridCell<dynamic>(
            columnName: 'sht',
            value:
                '${shtIn != 0 ? '$shtIn in' : ''} ${shtOut != 0 ? '$shtOut out' : ''}'),
        DataGridCell<dynamic>(columnName: 'sync', value: e['sync']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color? pendingCellText;
    Color getRowColor() {
      dynamic date = row.getCells()[1].value;
      String entryType = row.getCells()[2].value;
      if (date == today) {
        return Colors.yellow;
      } else {
        if (entryType == "Warp Delivery") {
          return Colors.green.shade100;
        } else if (entryType == "Payment") {
          return Colors.yellow.shade50;
        } else if (entryType == "Goods Inward") {
          return const Color(0xffe6dadf);
        }

        return Colors.transparent;
      }
    }

    return DataGridRowAdapter(
        color: getRowColor(),
        cells: row.getCells().map<Widget>((c) {
          TextStyle? getTextStyle() {
            dynamic sync = row.getCells()[11].value;
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
            /// entry_type Column
            if (c.columnName == 'entry_type') {
              if (c.value == 'Warp Delivery' || c.value == "Warp Excess") {
                return Colors.green.shade200;
              } else if (c.value == "Warp Shortage" ||
                  c.value == "Rtrn-Yarn" ||
                  c.value == "Warp-Dropout") {
                return Colors.redAccent.shade100;
              } else if (c.value == "Yarn Wastage") {
                return Colors.purpleAccent.shade100;
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
              if (row.getCells()[2].value == "Rtrn-Yarn") {
                pendingCellText = Colors.white;
                return Colors.redAccent;
              } else if (row.getCells()[2].value == "Goods Inward" &&
                  pending == "Pending") {
                pendingCellText = Colors.white;
                return Colors.redAccent;
              } else if (row.getCells()[2].value == 'Warp-Dropout' &&
                  row.getCells()[4].value == "") {
                pendingCellText = Colors.white;
                return Colors.redAccent;
              } else if (row.getCells()[2].value == 'Warp Shortage' &&
                  row.getCells()[4].value == "") {
                pendingCellText = Colors.white;
                return Colors.redAccent;
              } else if (row.getCells()[2].value == "Warp Delivery") {
                return Colors.green.shade200;
              }
            }

            /// quantity Column
            if (c.columnName == "quantity") {
              if (row.getCells()[2].value == 'Warp Shortage' && c.value != "" ||
                  row.getCells()[2].value == 'Warp-Dropout' && c.value != "") {
                return Colors.redAccent.shade100;
              } else if (row.getCells()[2].value == 'Warp Delivery' &&
                      c.value != "" ||
                  row.getCells()[2].value == 'Warp Excess' && c.value != "") {
                return Colors.green.shade200;
              } else if (row.getCells()[2].value == 'Warp Delivery') {
                if (row.getCells()[4].value != "") {
                  return Colors.green.shade200;
                }
              }
            }

            String particulars = row.getCells()[3].value;

            /// particulars Column
            if (c.columnName == "particulars") {
              if (row.getCells()[2].value == 'Goods Inward') {
                if (particulars.split(":").first == "Damaged ") {
                  return Colors.redAccent.shade100;
                }
              } else if (row.getCells()[2].value == 'Warp Delivery') {
                if (row.getCells()[4].value != "") {
                  return Colors.green.shade200;
                }
              }
            }

            /// credit Column
            if (c.columnName == "credit") {
              if (row.getCells()[2].value == 'Warp Delivery') {
                if (row.getCells()[4].value != "") {
                  return Colors.green.shade200;
                }
              }
            }

            /// Debit Column
            if (c.columnName == "debit") {
              if (row.getCells()[2].value == 'Warp Delivery') {
                if (row.getCells()[4].value != "") {
                  return Colors.green.shade200;
                }
              }
              if (row.getCells()[2].value == 'Debit') {
                if (c.value != null) {
                  return Colors.red.shade200;
                }
              }
            }

            return Colors.transparent;
          }

          return Container(
            color: getColor(),
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: SelectionArea(
                child: Text(c.value.toString(), style: getTextStyle())),
          );
        }).toList());
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    var deliveryQty = "";
    var balanceQty = "";
    if (_totalQuantity.value != 0) {
      deliveryQty = "Delivery Qty : $_totalQuantity";
    }
    if (_totalQuantity.value - _receivedQuantity.value != 0) {
      balanceQty =
          "Balance Qty : ${_totalQuantity.value - _receivedQuantity.value}";
    }

    if (summaryColumn?.columnName == 'quantity') {
      return Container(
        padding: const EdgeInsets.all(4),
        child: Text('$_receivedQuantity / $_totalQuantity',
            style: AppUtils.footerTextStyle()),
      );
    } else if (summaryColumn?.columnName == 'particulars') {
      return Container(
        padding: const EdgeInsets.all(4),
        child: RichText(
          text: TextSpan(
            text: '$deliveryQty ',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: balanceQty,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      );
    } else if (summaryColumn?.columnName == 'bm') {
      return Container(
        padding: const EdgeInsets.all(4),
        child: Text('$_beam', style: AppUtils.footerTextStyle()),
      );
    } else if (summaryColumn?.columnName == 'bbn') {
      return Container(
        padding: const EdgeInsets.all(4),
        child: Text('$_bobbin', style: AppUtils.footerTextStyle()),
      );
    } else if (summaryColumn?.columnName == 'sht') {
      return Container(
        padding: const EdgeInsets.all(4),
        child: Text('$_sheet', style: AppUtils.footerTextStyle()),
      );
    } else if (summaryColumn?.columnName == 'credit') {
      return Container(
        padding: const EdgeInsets.all(4),
        child: Text("$_credit", style: AppUtils.footerTextStyle()),
      );
    } else if (summaryColumn?.columnName == 'debit') {
      return Container(
          padding: const EdgeInsets.all(4),
          child: Text("$_debit", style: AppUtils.footerTextStyle()));
    } else if (summaryColumn?.columnName == 'details') {
      return Container(
        padding: const EdgeInsets.all(4),
        child: RichText(
          text: TextSpan(
            text: _creditBalance.value,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: _debitBalance.value,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(4),
        child: Text(summaryValue),
      );
    }
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}

class TransferItemDataSource extends DataGridSource {
  TransferItemDataSource({
    required List<dynamic> list,
  }) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var index = _list.indexOf(e);
      var particulars = "";

      /// yarn
      var yarnName = "${e["yarn_name"] ?? ""}, ";
      var yarnQty = e["yarn_qty"] != 0
          ? "${myNumberFormat("${e["yarn_qty"]}", decimalPlace: 3)} Kgs"
          : "";

      /// warp
      var warpQty = e["warp_qty"] != 0 ? "${e["warp_qty"]} Qty" : "";
      var warpMeter = e["warp_meter"] != 0
          ? "${myNumberFormat("${e["warp_meter"]}", decimalPlace: 3)} Mtr"
          : "";
      var warpName = "${e["warp_name"] ?? ""}, ";
      var warpType = e["warp_type"];

      /// beam bobbin sheet

      var beam = e["beam"] != 0 ? "${e["beam"]} Beam, " : "";
      var bobbin = e["bobbin"] != 0 ? "${e["bobbin"]} Bobbin, " : "";
      var sheet = e["sheet"] != 0 ? "${e["sheet"]} Sheet, " : "";

      if (e["entry_type"] == "Trsfr - Yarn") {
        particulars = "$yarnName $yarnQty";
      } else if (e["entry_type"] == "Trsfr - Amount") {
        particulars = "${myNumberFormat("${e["details"]}")} Rs";
      } else if (e["entry_type"] == "Trsfr - Empty") {
        particulars = "$beam$bobbin$sheet";
      } else {
        if (warpType == "Main Warp") {
          particulars = "$warpName $warpQty";
        } else {
          particulars = "$warpName $warpMeter";
        }
      }

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'id', value: '${index + 1}'),
        DataGridCell<dynamic>(columnName: 'entry_type', value: e['entry_type']),
        DataGridCell<dynamic>(columnName: 'particulars', value: particulars),
        DataGridCell<dynamic>(columnName: 'wary_type', value: warpType),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color? textColor;
    FontWeight fontWeight = FontWeight.w500;
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((c) {
      if (row.getCells()[3].value == "Other") {
        textColor = Colors.indigo;
        fontWeight = FontWeight.bold;
      }

      return Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: SelectionArea(
          child: Text(
            c.value.toString(),
            style: TextStyle(
              overflow: TextOverflow.visible,
              fontWeight: fontWeight,
              fontSize: 14,
              color: textColor ?? Colors.black,
            ),
          ),
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

class CustomSelectionManager extends RowSelectionManager {
  CustomSelectionManager(
    this.dataGridController,
    this.dataSource,
    this.saveButton,
    this.addItem,
    this.payDetails,
    this.recordEdit,
    this.finishButton,
    this.newRecord,
    this.weftBalance,
    this.overAllWeft,
    this.loomFocus,
    this.weaverFocus,
    this.newWarp,
    this.runningWarp,
    this.completeWarp,
    this.remove,
    this.warpTracking,
  );

  DataGridController dataGridController;
  WeavingItemDataSource dataSource;
  Function saveButton,
      addItem,
      payDetails,
      recordEdit,
      finishButton,
      newRecord,
      weftBalance,
      overAllWeft,
      loomFocus,
      weaverFocus,
      newWarp,
      runningWarp,
      completeWarp,
      warpTracking,
      remove;

  @override
  Future<void> handleKeyEvent(KeyEvent keyEvent) async {
    final ctrl = HardwareKeyboard.instance.isControlPressed;
    final shift = HardwareKeyboard.instance.isShiftPressed;
    if (ctrl && keyEvent.logicalKey == LogicalKeyboardKey.keyC) {
      if (dataGridController.currentCell.rowIndex >= 0) {
        var copyText = dataSource
            .effectiveRows[dataGridController.currentCell.rowIndex]
            .getCells()[dataGridController.currentCell.columnIndex]
            .value
            .toString();

        if (copyText.isNotEmpty) {
          await Clipboard.setData(ClipboardData(text: copyText));
        }
      }
      return;
    } else if (ctrl && keyEvent.logicalKey == LogicalKeyboardKey.keyQ) {
      Get.back();
    } else if (ctrl && keyEvent.logicalKey == LogicalKeyboardKey.keyS) {
      saveButton();
    } else if (ctrl && keyEvent.logicalKey == LogicalKeyboardKey.keyN) {
      addItem();
    } else if (ctrl && keyEvent.logicalKey == LogicalKeyboardKey.keyP) {
      payDetails();
    } else if (ctrl && keyEvent.logicalKey == LogicalKeyboardKey.keyE) {
      recordEdit();
    } else if (ctrl && keyEvent.logicalKey == LogicalKeyboardKey.keyF) {
      finishButton();
    } else if (shift && keyEvent.logicalKey == LogicalKeyboardKey.keyR) {
      newRecord();
    } else if (ctrl && keyEvent.logicalKey == LogicalKeyboardKey.keyW) {
      weftBalance();
    } else if (ctrl && keyEvent.logicalKey == LogicalKeyboardKey.keyR) {
      remove();
    } else if (ctrl && keyEvent.logicalKey == LogicalKeyboardKey.keyT) {
      warpTracking();
    } else if (keyEvent.logicalKey == LogicalKeyboardKey.f7) {
      overAllWeft();
    } else if (keyEvent.logicalKey == LogicalKeyboardKey.f5) {
      loomFocus();
    } else if (keyEvent.logicalKey == LogicalKeyboardKey.f6) {
      weaverFocus();
    } else if (keyEvent.logicalKey == LogicalKeyboardKey.f1) {
      newWarp();
    } else if (keyEvent.logicalKey == LogicalKeyboardKey.f2) {
      runningWarp();
    } else if (keyEvent.logicalKey == LogicalKeyboardKey.f3) {
      completeWarp();
    }
    super.handleKeyEvent(keyEvent);
  }
}

class PrivateWeftItemDataSource extends DataGridSource {
  PrivateWeftItemDataSource({required List<dynamic> list}) {
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
