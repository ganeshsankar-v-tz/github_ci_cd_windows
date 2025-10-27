import 'package:abtxt/model/AccountModel.dart';
import 'package:abtxt/model/WarpExcessModel.dart';
import 'package:abtxt/model/WarpType.dart';
import 'package:abtxt/model/weaving_models/WeaverByLoomStatusModel.dart';
import 'package:abtxt/model/weaving_models/weft_balance/OtherWarpBalanceModel.dart';
import 'package:abtxt/model/weaving_models/weft_balance/OverAllWeftBalanceModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/production/weaving/weaving_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/my_autocompletes/eaving_warp_id_AutoComplete.dart';
import 'package:abtxt/widgets/my_autocompletes/weaving_tranfer_warp_autoComplete.dart';
import 'package:abtxt/widgets/my_autocompletes/weaving_transfer_yarn_autoComplete.dart';
import 'package:abtxt/widgets/my_autocompletes/weaving_warp_design_autoComplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/LoomGroup.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/WeavingEntryTypeModel.dart';
import '../../../model/YarnModel.dart';
import '../../../model/warp_id_details/NewWarpIdDetailsModel.dart';
import '../../../model/weaving_models/WeaverTransferYarnModel.dart';
import '../../../model/weaving_models/WeavingOtherWarpBalanceModel.dart';
import '../../../model/weaving_models/WeavingProductListModel.dart';
import '../../../model/weaving_models/WeavingWarpDeliveryModel.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../basics/productinfo/add_product_info.dart';
import 'add_weaving.dart';

class WeavingBottomSheetTwo extends StatefulWidget {
  final WeavingItemDataSource weavingDataSource;
  final DataGridController weavingDataGridController;
  final Function itemTableCalculation;
  final List transferDetails;
  final TransferItemDataSource transferDataSource;

  const WeavingBottomSheetTwo({
    super.key,
    required this.weavingDataSource,
    required this.weavingDataGridController,
    required this.itemTableCalculation,
    required this.transferDetails,
    required this.transferDataSource,
  });

  @override
  State<WeavingBottomSheetTwo> createState() => _WeavingItemBottomSheetState();
}

class _WeavingItemBottomSheetState extends State<WeavingBottomSheetTwo> {
  TextEditingController dateController = TextEditingController();
  final FocusNode _dateFocusNode = FocusNode();
  TextEditingController transactionTypeController =
      TextEditingController(text: "Fresh");

  /// weaver yarn stock details
  var weaverYarnStockLocal = <WeftBalance>[];
  late WeaverYarnStockDataSource weaverYarnStockDataSource;

  /// weaver other warp stock details
  var weaverOtherWarpStockLocal = <OtherWarpBalanceModel>[];
  late WeaverOtherWarpDataSource weaverOtherWarpDataSource;

  WeavingController controller = Get.put(WeavingController());
  RxList<WeavingEntryTypeModel> entryTypes = RxList<WeavingEntryTypeModel>([]);
  final Rxn<WeavingEntryTypeModel> _selectedEntryType =
      Rxn<WeavingEntryTypeModel>();
  final _formKey = GlobalKey<FormState>();

  /// 1) warpDelivery Controllers
  Rxn<WarpType> warpDeliveryWarpDesignController = Rxn<WarpType>();
  TextEditingController warpDeliveryWarpType = TextEditingController();
  Rxn<WeavingWarpDeliveryModel> warpDeliveryWarpIdNo =
      Rxn<WeavingWarpDeliveryModel>();
  TextEditingController warpDeliveryProductQyt = TextEditingController();
  TextEditingController warpDeliveryMeter = TextEditingController();
  TextEditingController warpDeliveryEmptyType =
      TextEditingController(text: 'Beam');
  TextEditingController warpDeliveryEmptyQyt =
      TextEditingController(text: "Nothing");
  TextEditingController warpDeliverySheet = TextEditingController();
  TextEditingController warpDeliveryDetails = TextEditingController();
  TextEditingController warpDeliveryWarpColor = TextEditingController();
  final FocusNode _warpDesignFocusNode = FocusNode();

  /// 2) yarnDelivery Controllers
  Rxn<YarnModel> yarnDeliveryYarnName = Rxn<YarnModel>();
  Rxn<NewColorModel> yarnDeliveryColorName = Rxn<NewColorModel>();
  TextEditingController stockBalanceController =
      TextEditingController(text: "0");
  TextEditingController yarnDeliveryDeliveryFrom =
      TextEditingController(text: "Office");
  TextEditingController yarnDeliveryBoxNo = TextEditingController();
  TextEditingController yarnDeliveryPack = TextEditingController(text: "0");
  TextEditingController yarnDeliveryNos = TextEditingController(text: '0');
  TextEditingController yarnDeliveryGrossQty =
      TextEditingController(text: '0.000');
  TextEditingController yarnDeliveryLess = TextEditingController(text: '0.000');
  TextEditingController yarnDeliveryWeight = TextEditingController(text: '0');
  TextEditingController yarnDeliveryDetails = TextEditingController();
  TextEditingController yarnDeliveryNetQuantity =
      TextEditingController(text: "0");

  /// 3) goodsInward Controllers
  Rxn<WeavingProductListModel> goodsInwardProduct =
      Rxn<WeavingProductListModel>();
  TextEditingController goodsInwardDesignNo = TextEditingController();
  TextEditingController goodsInwardInwardQty = TextEditingController();
  TextEditingController goodsInwardMeterInWard = TextEditingController();
  TextEditingController goodsInwardWages = TextEditingController();
  TextEditingController goodsInwardAmount = TextEditingController();
  TextEditingController goodsInwardDamaged = TextEditingController(text: "No");
  TextEditingController goodsInwardDetails = TextEditingController();
  TextEditingController goodsInwardPending = TextEditingController(text: "No");
  TextEditingController goodsInwardPendingQty =
      TextEditingController(text: "0");
  TextEditingController goodsInwardPendingMeter =
      TextEditingController(text: "0");

  /// 4) payment Controllers
  Rxn<AccountModel> paymentTo = Rxn<AccountModel>();
  TextEditingController paymentAmount = TextEditingController();
  TextEditingController paymentType = TextEditingController(text: "Wages");
  TextEditingController paymentDetail = TextEditingController();

  ///  5) emptyInOut Controllers
  TextEditingController emptyInOutBeamIn = TextEditingController(text: "0");
  TextEditingController emptyInOutBeamOut = TextEditingController(text: "0");
  TextEditingController emptyInOutBobbinIn = TextEditingController(text: "0");
  TextEditingController emptyInOutBobbinOut = TextEditingController(text: "0");
  TextEditingController emptyInOutSheetIn = TextEditingController(text: "0");
  TextEditingController emptyInOutSheetOut = TextEditingController(text: "0");
  TextEditingController emptyInOutDetails = TextEditingController();

  /// 6) receipt Controllers
  Rxn<AccountModel> receiptBy = Rxn<AccountModel>();
  TextEditingController receiptAmounts = TextEditingController();
  TextEditingController receiptDetail = TextEditingController();

  /// 7) returnYarn Controllers
  Rxn<YarnModel> returnYarnYarnName = Rxn<YarnModel>();
  Rxn<NewColorModel> returnYarnColorName = Rxn<NewColorModel>();
  TextEditingController returnYarnStockTo =
      TextEditingController(text: "Office");
  TextEditingController returnYarnBoxNo = TextEditingController();
  TextEditingController returnYarnPack = TextEditingController(text: "0");
  TextEditingController returnYarnNos = TextEditingController(text: '0');
  TextEditingController returnYarnGrossQty =
      TextEditingController(text: '0.000');
  TextEditingController returnYarnLess = TextEditingController(text: '0.000');
  TextEditingController returnYarnWeight = TextEditingController(text: '0');
  TextEditingController returnYarnDetails = TextEditingController();
  TextEditingController returnYarnNetQty = TextEditingController(text: "0");
  final FocusNode _yarnDeliveryGrossQtyFocusNode = FocusNode();
  final FocusNode _returnYarnGrossQtyFocusNode = FocusNode();

  /// 8) credit Controllers
  Rxn<AccountModel> creditBy = Rxn<AccountModel>();
  TextEditingController creditAmountRs = TextEditingController();
  TextEditingController creditDetails = TextEditingController();

  /// 9) debit Controllers
  Rxn<AccountModel> debitBy = Rxn<AccountModel>();
  TextEditingController debitAmountRs = TextEditingController();
  TextEditingController debitDetails = TextEditingController();

  /// 10) yarnWastage Controllers
  Rxn<WeaverTransferYarnModel> yarnWastageYarn = Rxn<WeaverTransferYarnModel>();
  TextEditingController yarnWastageWeaver = TextEditingController();
  TextEditingController yarnWastageQuantity = TextEditingController();
  TextEditingController yarnWastageDetails = TextEditingController();

  /// 11) warpExcess Controllers
  Rxn<WarpExcessModel> warpExcessWarpDesign = Rxn<WarpExcessModel>();
  TextEditingController warpExcessWarpType = TextEditingController();
  TextEditingController warpExcessBalanceQty = TextEditingController();
  TextEditingController warpExcessBalanceMeter = TextEditingController();
  TextEditingController warpExcessWarpQty = TextEditingController(text: "0");
  TextEditingController warpExcessWarpMeter = TextEditingController(text: "0");
  TextEditingController warpExcessDetails = TextEditingController();
  TextEditingController warpExcessWarpId = TextEditingController();

  /// 12) message Controllers
  TextEditingController messageLanguage =
      TextEditingController(text: "English");
  TextEditingController messageMsgType = TextEditingController(text: "Normal");
  TextEditingController messageMsg = TextEditingController();

  /// 13) warpShortage Controllers
  Rxn<WarpExcessModel> warpShortageWarpDesign = Rxn<WarpExcessModel>();
  TextEditingController warpShortageWarpType = TextEditingController();
  TextEditingController warpShortageBalanceQty = TextEditingController();
  TextEditingController warpShortageBalanceMeter = TextEditingController();
  TextEditingController warpShortageWarpQty = TextEditingController();
  TextEditingController warpShortageWarpMeter = TextEditingController();
  TextEditingController warpShortageDetails = TextEditingController();
  TextEditingController warpShortageWarpId = TextEditingController();

  /// 14) transferAmount Controllers
  TextEditingController transferAmountDebit = TextEditingController();
  TextEditingController transferAmountCredit = TextEditingController();
  Rxn<LoomGroup> transferAmountTo = Rxn<LoomGroup>();
  Rxn<WeaverByLoomStatusModel> transferAmountStatus =
      Rxn<WeaverByLoomStatusModel>();
  TextEditingController transferAmountWeavNo = TextEditingController();

  /// 15) transferCopsReels Controllers
  TextEditingController transferCopsReelsCops = TextEditingController();
  TextEditingController transferCopsReelsReel = TextEditingController();
  Rxn<LoomGroup> transferCopsReelsTo = Rxn<LoomGroup>();
  Rxn<WeaverByLoomStatusModel> transferCopsReelsStatus =
      Rxn<WeaverByLoomStatusModel>();
  TextEditingController transferCopsReelsWeavNo = TextEditingController();

  /// 16) transferEmpty Controllers
  TextEditingController transferEmptyBeam = TextEditingController(text: "0");
  TextEditingController transferEmptyBobbin = TextEditingController(text: "0");
  TextEditingController transferEmptySheet = TextEditingController(text: "0");
  TextEditingController transferEmptyBeamIn = TextEditingController(text: "0");
  TextEditingController transferEmptyBeamOut = TextEditingController(text: "0");
  TextEditingController transferEmptyBobbinIn =
      TextEditingController(text: "0");
  TextEditingController transferEmptyBobbinOut =
      TextEditingController(text: "0");
  TextEditingController transferEmptySheetIn = TextEditingController(text: "0");
  TextEditingController transferEmptySheetOut =
      TextEditingController(text: "0");
  Rxn<LoomGroup> transferEmptyTo = Rxn<LoomGroup>();
  Rxn<WeaverByLoomStatusModel> transferEmptyStatus =
      Rxn<WeaverByLoomStatusModel>();
  TextEditingController transferEmptyWeavNo = TextEditingController();

  /// 17) transferWarp Controllers
  Rxn<WeavingOtherWarpBalanceModel> transferWarpWarpDesign =
      Rxn<WeavingOtherWarpBalanceModel>();
  TextEditingController transferWarpWarpType = TextEditingController();
  TextEditingController transferWarpBalanceMeter = TextEditingController();
  Rxn<LoomGroup> transferWarpTo = Rxn<LoomGroup>();
  Rxn<WeaverByLoomStatusModel> transferWarpStatus =
      Rxn<WeaverByLoomStatusModel>();
  TextEditingController transferWarpWeavNo = TextEditingController();
  TextEditingController transferWarpWarpId = TextEditingController();

  /// 18) transferYarn Controllers
  Rxn<WeaverTransferYarnModel> transferYarnYarnName =
      Rxn<WeaverTransferYarnModel>();
  TextEditingController transferYarnWeaverStockQty = TextEditingController();
  Rxn<LoomGroup> transferYarnTo = Rxn<LoomGroup>();
  Rxn<WeaverByLoomStatusModel> transferYarnStatus =
      Rxn<WeaverByLoomStatusModel>();
  TextEditingController transferYarnWeavNo = TextEditingController();

  /// 19) adjustmentWt Controllers
  TextEditingController adjustmentWtDeliveryWeight = TextEditingController();
  TextEditingController adjustmentWtReceivedWight = TextEditingController();
  TextEditingController adjustmentWtDetails = TextEditingController();

  /// 20) Inward Cops reel
  TextEditingController inwardCopRelCops = TextEditingController(text: "0");
  TextEditingController inwardCopRelCopsType =
      TextEditingController(text: "Nothing");
  TextEditingController inwardCopRelReel = TextEditingController(text: "0");
  TextEditingController inwardCopRelReelType =
      TextEditingController(text: "J.Reel");
  TextEditingController inwardCopRelCone = TextEditingController(text: "0");
  TextEditingController inwardCopRelConeType =
      TextEditingController(text: "Nothing");
  TextEditingController inwardCopRelDetails = TextEditingController();

  /// 21) Opening Balance Amount
  TextEditingController openBalAmountDebit = TextEditingController(text: "0");
  TextEditingController openBalAmountCredit = TextEditingController(text: "0");
  TextEditingController openBalAmountDetails = TextEditingController();

  /// 22) Opening Balance Cops And Reel
  TextEditingController openBalCopRelCopType =
      TextEditingController(text: "Nothing");
  TextEditingController openBalCopRelCopIn = TextEditingController(text: "0");
  TextEditingController openBalCopRelCopOut = TextEditingController(text: "0");
  TextEditingController openBalCopRelRelType =
      TextEditingController(text: "Nothing");
  TextEditingController openBalCopRelRelIn = TextEditingController(text: "0");
  TextEditingController openBalCopRelRelOut = TextEditingController(text: "0");
  TextEditingController openBalCopRelConeType =
      TextEditingController(text: "Nothing");
  TextEditingController openBalCopRelConeIn = TextEditingController(text: "0");
  TextEditingController openBalCopRelConeOut = TextEditingController(text: "0");
  TextEditingController openBalCopRelDetails = TextEditingController();

  /// 23) Opening Balance Empty
  TextEditingController openBalBeamIn = TextEditingController(text: "0");
  TextEditingController openBalBeamOut = TextEditingController(text: "0");
  TextEditingController openBalBobbinIn = TextEditingController(text: "0");
  TextEditingController openBalBobbinOut = TextEditingController(text: "0");
  TextEditingController openBalSheetIn = TextEditingController(text: "0");
  TextEditingController openBalSheetOut = TextEditingController(text: "0");
  TextEditingController openBalDetails = TextEditingController();

  /// 24) Opening Balance Warp
  Rxn<WarpType> openBalWarpDesign = Rxn<WarpType>();
  TextEditingController openBalWarpType = TextEditingController();
  TextEditingController openBalWarpMetre = TextEditingController(text: "0");
  TextEditingController openBalWarpEmptyType =
      TextEditingController(text: "Nothing");
  TextEditingController openBalWarpEmptyQty = TextEditingController(text: "0");
  TextEditingController openBalWarpSheet = TextEditingController(text: "0");
  TextEditingController openBalWarpDetails = TextEditingController();

  /// 25) Opening Balance Yarn
  Rxn<YarnModel> openBalYarnYarnName = Rxn<YarnModel>();
  Rxn<NewColorModel> openBalYarnColourName = Rxn<NewColorModel>();
  TextEditingController openBalYarnPack = TextEditingController(text: "0");
  TextEditingController openBalYarnQty = TextEditingController(text: "0");
  TextEditingController openBalYarnDetails = TextEditingController();

  /// 26) Warp Dropout
  Rxn<WarpExcessModel> warpDropWarpDesign = Rxn<WarpExcessModel>();
  TextEditingController warpDropWarpType = TextEditingController();
  TextEditingController warpDropWarpIdNo = TextEditingController();
  var warpDropOldWarpIdNo = TextEditingController().obs;
  TextEditingController warpDropProductQty = TextEditingController(text: "0");
  TextEditingController warpDropMetre = TextEditingController(text: "0");
  TextEditingController warpDropEmptyType =
      TextEditingController(text: "Nothing");
  TextEditingController warpDropEmptyQty = TextEditingController(text: "0");
  TextEditingController warpDropSheet = TextEditingController(text: "0");
  TextEditingController warpDropDetails = TextEditingController();
  TextEditingController warpDropRunningWarpId = TextEditingController();

  var shortCut = RxString("");

  @override
  void initState() {
    _warpDesignFocusNode.addListener(() => shortCutKeys());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initValue();
    });

    super.initState();
    weaverYarnStockDataSource =
        WeaverYarnStockDataSource(list: weaverYarnStockLocal);

    weaverOtherWarpDataSource =
        WeaverOtherWarpDataSource(list: weaverOtherWarpStockLocal);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeavingController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: const Text('Add Item (Weaving)'),
        ),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () => Get.back()),
            SaveIntent: SetCounterAction(perform: () => submit()),
            NavigateIntent:
                SetCounterAction(perform: () => navigateAnotherPage()),
          },
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
                          MyDropdownButtonFormField(
                            controller: transactionTypeController,
                            hintText: "Transaction Type",
                            items: Constants.TRANSACTION_TYPE,
                          ),
                        ],
                      ),
                      Wrap(
                        children: [
                          MyDateFilter(
                            controller: dateController,
                            labelText: 'Date',
                            autofocus: true,
                            focusNode: _dateFocusNode,
                          ),
                          Obx(
                            () => MyAutoComplete(
                              label: 'Entry Type',
                              items: entryTypes,
                              isContainsSearch: false,
                              selectedItem: _selectedEntryType.value,
                              onChanged: (WeavingEntryTypeModel item) async {
                                _selectedEntryType.value = item;
                                //FocusManager.instance.primaryFocus?.nextFocus();
                                await _apiCall(item.entryType);
                              },
                            ),
                          ),
                        ],
                      ),
                      Obx(
                        () => updateWidget(
                            '${_selectedEntryType.value?.entryType}'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Obx(
                            () => Text(shortCut.value,
                                style: AppUtils.shortCutTextStyle()),
                          ),
                          const SizedBox(width: 12),
                          MyElevatedButton(
                            onPressed: () => submit(),
                            child: const Text("ADD"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text("Over All Yarn Stock"),
                      weaverYarnStockTable(),
                      const SizedBox(height: 12),
                      const Text("Over All Other Warp Stock"),
                      weaverOtherWarpStockTable(),
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

  Widget updateWidget(String option) {
    if (option == 'Warp Delivery') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Focus(
                  focusNode: _warpDesignFocusNode,
                  skipTraversal: true,
                  child: MyAutoComplete(
                    label: 'Warp Design',
                    items: controller.warpTypeList,
                    selectedItem: warpDeliveryWarpDesignController.value,
                    onChanged: (WarpType item) {
                      warpDeliveryWarpDesignController.value = item;
                      warpDeliveryWarpType.text = tryCast(item.wrapType);
                      if (warpDeliveryWarpIdNo.value != null) {
                        warpDeliveryWarpIdNo.value = null;
                      }
                      int warpDesignId = item.warpDesignId!;
                      int weaverId = controller.weaverId!;
                      int subWeaverNo = controller.request['sub_weaver_no'];

                      controller.warpDelivery(
                          warpDesignId, weaverId, subWeaverNo);
                    },
                  ),
                ),
                MyTextField(
                  controller: warpDeliveryWarpType,
                  hintText: 'Warp Type',
                  readonly: true,
                ),
              ],
            ),
            Wrap(
              children: [
                WeavWarpIdDropDown(
                  label: 'Warp Id No',
                  items: controller.warpDetails,
                  selectedItem: warpDeliveryWarpIdNo.value,
                  onChanged: (WeavingWarpDeliveryModel item) {
                    warpDeliveryWarpIdNo.value = item;
                    warpDeliveryWarpDetails(item);
                  },
                ),
                MyTextField(
                  controller: warpDeliveryProductQyt,
                  hintText: 'Product Qty',
                  validate: 'number',
                ),
              ],
            ),
            Wrap(
              children: [
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: warpDeliveryMeter,
                    hintText: 'Meter',
                    validate: 'double',
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(
                      warpDeliveryMeter,
                    );
                  },
                ),
                MyDropdownButtonFormField(
                  controller: warpDeliveryEmptyType,
                  hintText: "Empty Type",
                  items: Constants.emptyType,
                ),
              ],
            ),
            Wrap(
              children: [
                MyTextField(
                  controller: warpDeliveryEmptyQyt,
                  hintText: 'Empty Qty',
                  validate: 'number',
                ),
                MyTextField(
                  controller: warpDeliverySheet,
                  hintText: 'Sheet',
                  validate: 'number',
                ),
              ],
            ),
            Wrap(
              children: [
                MyTextField(
                  controller: warpDeliveryWarpColor,
                  hintText: 'Warp Colour',
                ),
                MyTextField(
                  controller: warpDeliveryDetails,
                  hintText: 'Details',
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'Yarn Delivery') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                MyAutoComplete(
                  label: 'Yarn',
                  items: controller.yarnDropdown,
                  selectedItem: yarnDeliveryYarnName.value,
                  onChanged: (YarnModel item) {
                    yarnDeliveryYarnName.value = item;
                    yarnStockBalanceCheck();
                    _yarnDeliveryGrossQtyFocusNode.requestFocus();
                  },
                ),
                MyAutoComplete(
                  label: 'Color',
                  items: controller.colorDropdown,
                  selectedItem: yarnDeliveryColorName.value,
                  onChanged: (NewColorModel item) {
                    yarnDeliveryColorName.value = item;
                    yarnStockBalanceCheck();
                  },
                ),
              ],
            ),
            Wrap(
              children: [
                MyDropdownButtonFormField(
                  controller: yarnDeliveryDeliveryFrom,
                  hintText: 'Delivery From',
                  items: Constants.deliveredFrom,
                  onChanged: (value) async {
                    yarnStockBalanceCheck();
                  },
                ),
                MyTextField(
                  controller: yarnDeliveryBoxNo,
                  hintText: 'Box / Box No',
                ),
              ],
            ),
            Wrap(
              children: [
                MyTextField(
                  controller: yarnDeliveryPack,
                  hintText: 'Pack',
                  validate: 'number',
                ),
                ExcludeFocus(
                  child: MyTextField(
                    controller: stockBalanceController,
                    hintText: 'Stock',
                    readonly: true,
                  ),
                ),
              ],
            ),
            Focus(
              skipTraversal: true,
              child: MyTextField(
                controller: yarnDeliveryGrossQty,
                focusNode: _yarnDeliveryGrossQtyFocusNode,
                hintText: 'Gross Qty',
                validate: "double",
                onChanged: (value) {
                  yarnDeliveryCalculation();
                },
              ),
              onFocusChange: (hasFocus) {
                AppUtils.fractionDigitsText(
                  yarnDeliveryGrossQty,
                );
              },
            ),
            Row(
              children: [
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    width: 100,
                    controller: yarnDeliveryNos,
                    hintText: 'Nos.',
                    validate: "number",
                    onChanged: (value) {
                      yarnDeliveryCalculation();
                    },
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(
                      yarnDeliveryNos,
                      fractionDigits: 0,
                    );
                  },
                ),
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    width: 100,
                    controller: yarnDeliveryWeight,
                    hintText: 'Wt.(Grams) ',
                    validate: "number",
                    onChanged: (value) {
                      yarnDeliveryCalculation();
                    },
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(
                      yarnDeliveryWeight,
                      fractionDigits: 0,
                    );
                  },
                ),
                MyTextField(
                  enabled: false,
                  controller: yarnDeliveryLess,
                  hintText: '',
                  validate: "double",
                  onChanged: (value) {
                    yarnDeliveryCalculation();
                  },
                ),
                const Text(
                  "( - )",
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
            Wrap(
              children: [
                MyTextField(
                  controller: yarnDeliveryDetails,
                  hintText: 'Details',
                ),
                MyTextField(
                  controller: yarnDeliveryNetQuantity,
                  hintText: 'Net.Qty',
                  validate: 'double',
                  enabled: false,
                ),
              ],
            )
          ],
        ),
      );
    } else if (option == 'Goods Inward') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                MyAutoComplete(
                  label: 'Product',
                  items: controller.productDropdown,
                  selectedItem: goodsInwardProduct.value,
                  onChanged: (WeavingProductListModel item) async {
                    goodsInwardProduct.value = item;
                  },
                ),
                MyTextField(
                  controller: goodsInwardDesignNo,
                  hintText: 'Design No',
                  readonly: true,
                ),
              ],
            ),
            Wrap(
              children: [
                MyTextField(
                  controller: goodsInwardInwardQty,
                  hintText: 'Inward Qty',
                  validate: 'number',
                  onChanged: (value) {
                    _goodsInwardCalculation();
                  },
                ),
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: goodsInwardMeterInWard,
                    hintText: 'Meter',
                    readonly: true,
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(
                      goodsInwardMeterInWard,
                    );
                  },
                ),
              ],
            ),
            Wrap(
              children: [
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: goodsInwardWages,
                    hintText: 'Wages(Rs)',
                    validate: 'double',
                    suffix: const Text(
                      "Saree",
                      style: TextStyle(color: Color(0xff5700BC)),
                    ),
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(goodsInwardWages,
                        fractionDigits: 2);
                  },
                ),
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: goodsInwardAmount,
                    hintText: 'Amount(Rs)',
                    validate: 'double',
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(goodsInwardAmount,
                        fractionDigits: 2);
                  },
                ),
              ],
            ),
            Wrap(
              children: [
                MyDropdownButtonFormField(
                    controller: goodsInwardDamaged,
                    hintText: 'Damaged',
                    items: Constants.Weight),
                MyTextField(
                  controller: goodsInwardDetails,
                  hintText: 'Details',
                ),
              ],
            ),
            Wrap(
              children: [
                MyDropdownButtonFormField(
                    controller: goodsInwardPending,
                    hintText: 'Pending',
                    items: Constants.Weight),
                MyTextField(
                  controller: goodsInwardPendingQty,
                  hintText: 'Pending Quantity',
                  validate: "number",
                  onChanged: (value) {
                    _goodsInwardCalculation();
                  },
                ),
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: goodsInwardPendingMeter,
                    hintText: 'Pending Meter',
                    readonly: true,
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(
                      goodsInwardPendingMeter,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'Payment') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                MyAutoComplete(
                  label: 'To',
                  items: controller.paymentAccount,
                  selectedItem: paymentTo.value,
                  onChanged: (AccountModel item) {
                    paymentTo.value = item;
                  },
                ),
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: paymentAmount,
                    hintText: 'Amount(Rs)',
                    validate: 'double',
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(paymentAmount,
                        fractionDigits: 2);
                  },
                ),
              ],
            ),
            Wrap(
              children: [
                MyDropdownButtonFormField(
                  controller: paymentType,
                  hintText: "Type",
                  items: Constants.Tokes,
                ),
                MyTextField(
                  controller: paymentDetail,
                  hintText: 'Details',
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'Empty - (In / Out)') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                MyTextField(
                  controller: emptyInOutBeamIn,
                  hintText: 'Beam Inward',
                  validate: 'number',
                ),
                MyTextField(
                  controller: emptyInOutBeamOut,
                  hintText: 'Beam Delivery',
                  validate: 'number',
                ),
              ],
            ),
            Wrap(
              children: [
                MyTextField(
                  controller: emptyInOutBobbinIn,
                  hintText: 'Bobbin Inward',
                  validate: 'number',
                ),
                MyTextField(
                  controller: emptyInOutBobbinOut,
                  hintText: 'Bobbin Delivery',
                  validate: 'number',
                ),
              ],
            ),
            Wrap(
              children: [
                MyTextField(
                  controller: emptyInOutSheetIn,
                  hintText: 'Sheet Inward',
                  validate: 'number',
                ),
                MyTextField(
                  controller: emptyInOutSheetOut,
                  hintText: 'Sheet Delivery',
                  validate: 'number',
                ),
              ],
            ),
            Wrap(
              children: [
                MyTextField(
                  controller: emptyInOutDetails,
                  hintText: 'Details',
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'Receipt') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                MyAutoComplete(
                  label: 'By',
                  items: controller.paymentAccount,
                  selectedItem: paymentTo.value,
                  onChanged: (AccountModel item) {
                    receiptBy.value = item;
                  },
                ),
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: receiptAmounts,
                    hintText: 'Amount',
                    validate: 'double',
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(receiptAmounts,
                        fractionDigits: 2);
                  },
                ),
              ],
            ),
            Wrap(
              children: [
                MyTextField(
                  controller: receiptDetail,
                  hintText: 'Details',
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'Rtrn-Yarn') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                MyAutoComplete(
                  label: 'Yarn',
                  items: controller.yarnDropdown,
                  selectedItem: returnYarnYarnName.value,
                  onChanged: (YarnModel item) {
                    returnYarnYarnName.value = item;
                    _returnYarnGrossQtyFocusNode.requestFocus();
                  },
                ),
                MyAutoComplete(
                  label: 'Color',
                  items: controller.colorDropdown,
                  selectedItem: returnYarnColorName.value,
                  onChanged: (NewColorModel item) {
                    returnYarnColorName.value = item;
                  },
                ),
              ],
            ),
            Wrap(
              children: [
                MyDropdownButtonFormField(
                  controller: returnYarnStockTo,
                  hintText: 'Stock To',
                  items: Constants.stockTo,
                ),
                MyTextField(
                  controller: returnYarnBoxNo,
                  hintText: 'Box No',
                ),
              ],
            ),
            Row(
              children: [
                MyTextField(
                  controller: returnYarnPack,
                  hintText: 'Pack',
                  validate: 'number',
                ),
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: returnYarnGrossQty,
                    focusNode: _returnYarnGrossQtyFocusNode,
                    hintText: 'Gross Qty',
                    validate: "double",
                    onChanged: (value) {
                      returnYarnCalculation();
                    },
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(
                      returnYarnGrossQty,
                    );
                  },
                ),
              ],
            ),
            Row(
              children: [
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    width: 100,
                    controller: returnYarnNos,
                    hintText: 'Nos.',
                    validate: "number",
                    onChanged: (value) {
                      returnYarnCalculation();
                    },
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(
                      returnYarnNos,
                      fractionDigits: 0,
                    );
                  },
                ),
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    width: 100,
                    controller: returnYarnWeight,
                    hintText: 'Wt.(Grams) ',
                    validate: "number",
                    onChanged: (value) {
                      returnYarnCalculation();
                    },
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(
                      returnYarnWeight,
                      fractionDigits: 0,
                    );
                  },
                ),
                MyTextField(
                  enabled: false,
                  controller: returnYarnLess,
                  hintText: '',
                  validate: "double",
                  onChanged: (value) {
                    returnYarnCalculation();
                  },
                ),
                const Text(
                  "( - )",
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
            Wrap(
              children: [
                MyTextField(
                  controller: returnYarnDetails,
                  hintText: 'Details',
                ),
                MyTextField(
                  controller: returnYarnNetQty,
                  hintText: 'Net Qty',
                  validate: 'double',
                  enabled: false,
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'Credit') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                MyAutoComplete(
                  label: 'By',
                  items: controller.debitAccount,
                  selectedItem: creditBy.value,
                  onChanged: (AccountModel item) {
                    creditBy.value = item;
                  },
                ),
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: creditAmountRs,
                    hintText: 'Amount (Rs)',
                    validate: 'double',
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(creditAmountRs,
                        fractionDigits: 2);
                  },
                ),
              ],
            ),
            Wrap(
              children: [
                MyTextField(
                  controller: creditDetails,
                  hintText: 'Details',
                  validate: 'string',
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'Debit') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                MyAutoComplete(
                  label: 'By',
                  items: controller.debitAccount,
                  selectedItem: debitBy.value,
                  onChanged: (AccountModel item) {
                    debitBy.value = item;
                  },
                ),
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: debitAmountRs,
                    hintText: 'Amount (Rs)',
                    validate: 'double',
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(debitAmountRs,
                        fractionDigits: 2);
                  },
                ),
              ],
            ),
            Wrap(
              children: [
                MyTextField(
                  controller: debitDetails,
                  hintText: 'Details',
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'Yarn Wastage') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                WeavingTransferYarnAutoComplete(
                  label: 'Yarn',
                  items: controller.transferYarn,
                  selectedItem: yarnWastageYarn.value,
                  onChanged: (WeaverTransferYarnModel item) {
                    yarnWastageYarn.value = item;
                    yarnWastageWeaver.text = '${item.weftBalance}';
                  },
                ),
                MyTextField(
                  controller: yarnWastageWeaver,
                  hintText: 'Weaver Stock',
                  suffix: const Text("Kgs"),
                  readonly: true,
                ),
              ],
            ),
            Wrap(
              children: [
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: yarnWastageQuantity,
                    hintText: 'Quantity',
                    validate: 'double',
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(
                      yarnWastageQuantity,
                    );
                  },
                ),
                MyTextField(
                  controller: yarnWastageDetails,
                  hintText: 'Details',
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'Message') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                MyDropdownButtonFormField(
                  controller: messageLanguage,
                  hintText: "Language",
                  items: Constants.language,
                ),
                MyDropdownButtonFormField(
                  controller: messageMsgType,
                  hintText: "Message Type",
                  items: Constants.messageType,
                ),
              ],
            ),
            Wrap(
              children: [
                MyTextField(
                  controller: messageMsg,
                  hintText: 'Message',
                  validate: 'string',
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'Warp Excess') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                WeavingWarpDesignAutoComplete(
                  label: 'Warp Design',
                  items: controller.warpExcess,
                  selectedItem: warpExcessWarpDesign.value,
                  onChanged: (WarpExcessModel item) {
                    warpExcessWarpDesign.value = item;
                    warpExcessValueInit(item);
                  },
                ),
                MyTextField(
                  controller: warpExcessWarpType,
                  hintText: 'Warp Type',
                  readonly: true,
                ),
              ],
            ),
            Wrap(
              children: [
                Visibility(
                  visible: warpExcessWarpType.text == "Main Warp" ||
                      warpExcessWarpType.text == "",
                  child: MyTextField(
                    controller: warpExcessBalanceQty,
                    hintText: "Balance Qty",
                    readonly: true,
                  ),
                ),
                Visibility(
                  visible: warpExcessWarpType.text == "Other" ||
                      warpExcessWarpType.text == "",
                  child: MyTextField(
                    controller: warpExcessBalanceMeter,
                    hintText: 'Balance Metre',
                    readonly: true,
                  ),
                ),
              ],
            ),
            Wrap(
              children: [
                Visibility(
                  visible: warpExcessWarpType.text == "Main Warp" ||
                      warpExcessWarpType.text == "",
                  child: MyTextField(
                    controller: warpExcessWarpQty,
                    hintText: 'Warp Qty',
                    validate: 'number',
                  ),
                ),
                Visibility(
                  visible: warpExcessWarpType.text == "Other" ||
                      warpExcessWarpType.text == "",
                  child: Focus(
                    skipTraversal: true,
                    child: MyTextField(
                      controller: warpExcessWarpMeter,
                      hintText: 'Warp Metre',
                      validate: 'double',
                    ),
                    onFocusChange: (hasFocus) {
                      AppUtils.fractionDigitsText(
                        warpExcessWarpMeter,
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                MyTextField(
                  controller: warpExcessWarpId,
                  hintText: 'Warp Id',
                  enabled: false,
                ),
                MyTextField(
                  controller: warpExcessDetails,
                  hintText: 'Details',
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'Warp Shortage') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Wrap(
              children: [
                WeavingWarpDesignAutoComplete(
                  label: 'Warp Design',
                  items: controller.warpExcess,
                  selectedItem: warpShortageWarpDesign.value,
                  onChanged: (WarpExcessModel item) {
                    warpShortageWarpDesign.value = item;
                    warpShortAgeValueInit(item);
                  },
                ),
                MyTextField(
                  controller: warpShortageWarpType,
                  hintText: 'Warp Type',
                  readonly: true,
                ),
              ],
            ),
            Wrap(
              children: [
                Visibility(
                  visible: warpShortageWarpType.text == "Main Warp" ||
                      warpShortageWarpType.text == "",
                  child: MyTextField(
                    controller: warpShortageBalanceQty,
                    hintText: "Balance Qty",
                    validate: "number",
                    readonly: true,
                  ),
                ),
                Visibility(
                  visible: warpShortageWarpType.text == "Other" ||
                      warpShortageWarpType.text == "",
                  child: Focus(
                    skipTraversal: true,
                    child: MyTextField(
                      controller: warpShortageBalanceMeter,
                      hintText: 'Balance Metre',
                      validate: "double",
                      readonly: true,
                    ),
                    onFocusChange: (hasFocus) {
                      AppUtils.fractionDigitsText(
                        warpShortageBalanceMeter,
                      );
                    },
                  ),
                ),
              ],
            ),
            Wrap(
              children: [
                Visibility(
                  visible: warpShortageWarpType.text == "Main Warp" ||
                      warpShortageWarpType.text == "",
                  child: MyTextField(
                    controller: warpShortageWarpQty,
                    hintText: 'Warp Qty',
                    validate: 'number',
                    onChanged: (value) {
                      warpShortAgeCalculation();
                    },
                  ),
                ),
                Visibility(
                  visible: warpShortageWarpType.text == "Other" ||
                      warpShortageWarpType.text == "",
                  child: Focus(
                    skipTraversal: true,
                    child: MyTextField(
                      controller: warpShortageWarpMeter,
                      hintText: 'Warp Metre',
                      validate: 'double',
                    ),
                    onFocusChange: (hasFocus) {
                      AppUtils.fractionDigitsText(
                        warpShortageWarpMeter,
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                MyTextField(
                  controller: warpShortageWarpId,
                  hintText: 'Warp Id',
                  enabled: false,
                ),
                MyTextField(
                  controller: warpShortageDetails,
                  hintText: 'Details',
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'Trsfr - Amount') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    // enabled: transferAmountDebit.text != "0",
                    controller: transferAmountDebit,
                    hintText: "Debit (Or) Paid",
                    validate: 'double',
                    readonly: true,
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(transferAmountDebit,
                        fractionDigits: 2);
                  },
                ),
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: transferAmountCredit,
                    hintText: "Credit (Or) Wages",
                    validate: 'double',
                    readonly: true,
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(transferAmountCredit,
                        fractionDigits: 2);
                  },
                ),
              ],
            ),
            Wrap(
              children: [
                MyAutoComplete(
                  label: 'Loom',
                  items: controller.loomList,
                  selectedItem: transferAmountTo.value,
                  onChanged: (LoomGroup item) async {
                    controller.loomStatus.clear();
                    transferAmountStatus.value = null;
                    transferAmountWeavNo.text = "";
                    transferAmountTo.value = item;

                    /// Current Status Api Call
                    warpStatusApiCall(item.loomNo);
                  },
                ),
                MyAutoComplete(
                  label: 'Warp Status',
                  items: controller.loomStatus,
                  selectedItem: transferAmountStatus.value,
                  onChanged: (WeaverByLoomStatusModel item) async {
                    transferAmountStatus.value = item;
                    transferAmountWeavNo.text = "${item.weaveNo}";
                  },
                ),
                MyTextField(
                  controller: transferAmountWeavNo,
                  hintText: 'Weav No',
                  validate: 'number',
                  readonly: true,
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'Trsfr - Cops,Reel') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                MyTextField(
                  controller: transferCopsReelsCops,
                  hintText: 'Cops',
                  readonly: true,
                ),
                MyTextField(
                  controller: transferCopsReelsReel,
                  hintText: 'Reel',
                  readonly: true,
                ),
              ],
            ),
            Wrap(
              children: [
                MyAutoComplete(
                  label: 'Loom',
                  items: controller.loomList,
                  selectedItem: transferCopsReelsTo.value,
                  onChanged: (LoomGroup item) {
                    controller.loomStatus.clear();
                    transferCopsReelsStatus.value = null;
                    transferCopsReelsWeavNo.text = "";
                    transferCopsReelsTo.value = item;

                    /// Current Status Api Call
                    warpStatusApiCall(item.loomNo);
                  },
                ),
                MyAutoComplete(
                  label: 'Warp Status',
                  items: controller.loomStatus,
                  selectedItem: transferCopsReelsStatus.value,
                  onChanged: (WeaverByLoomStatusModel item) async {
                    transferCopsReelsStatus.value = item;
                    transferCopsReelsWeavNo.text = "${item.weaveNo}";
                  },
                ),
                MyTextField(
                  controller: transferCopsReelsWeavNo,
                  hintText: 'Weav No',
                  validate: 'number',
                  readonly: true,
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'Trsfr - Empty') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                MyTextField(
                  controller: transferEmptyBeam,
                  hintText: 'Beam',
                  readonly: true,
                ),
                MyTextField(
                  controller: transferEmptyBobbin,
                  hintText: 'Bobbin',
                  readonly: true,
                ),
                MyTextField(
                  controller: transferEmptySheet,
                  hintText: 'Sheet',
                  readonly: true,
                ),
              ],
            ),
            Wrap(
              children: [
                MyAutoComplete(
                  label: 'Loom',
                  items: controller.loomList,
                  selectedItem: transferEmptyTo.value,
                  onChanged: (LoomGroup item) {
                    controller.loomStatus.clear();
                    transferEmptyStatus.value = null;
                    transferEmptyWeavNo.text = "";
                    transferEmptyTo.value = item;

                    /// Current Status Api Call
                    warpStatusApiCall(item.loomNo);
                  },
                ),
                MyAutoComplete(
                  label: 'Warp Status',
                  items: controller.loomStatus,
                  selectedItem: transferEmptyStatus.value,
                  onChanged: (WeaverByLoomStatusModel item) async {
                    transferEmptyStatus.value = item;
                    transferEmptyWeavNo.text = "${item.weaveNo}";
                  },
                ),
                MyTextField(
                  controller: transferEmptyWeavNo,
                  hintText: 'Weav No',
                  validate: 'number',
                  readonly: true,
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'Trsfr - Warp') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                WeavingTransferWarpAutoComplete(
                  label: 'Warp Design',
                  items: controller.transferWarp,
                  selectedItem: transferWarpWarpDesign.value,
                  onChanged: (WeavingOtherWarpBalanceModel item) {
                    transferWarpWarpDesign.value = item;
                    transferWarpDetails(item);
                  },
                ),
                MyTextField(
                  controller: transferWarpWarpType,
                  hintText: 'Warp Type',
                  readonly: true,
                ),
              ],
            ),
            Wrap(
              children: [
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: transferWarpBalanceMeter,
                    hintText: 'Balance Meter',
                    validate: "double",
                    readonly: true,
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(
                      transferWarpBalanceMeter,
                    );
                  },
                ),
                MyTextField(
                  controller: transferWarpWarpId,
                  hintText: 'Warp Id',
                  enabled: false,
                )
              ],
            ),
            Wrap(
              children: [
                MyAutoComplete(
                  label: 'Loom',
                  items: controller.loomList,
                  selectedItem: transferWarpTo.value,
                  onChanged: (LoomGroup item) {
                    controller.loomStatus.clear();
                    transferWarpStatus.value = null;
                    transferWarpWeavNo.text = "";
                    transferWarpTo.value = item;

                    /// Current Status Api Call
                    warpStatusApiCall(item.loomNo);
                  },
                ),
                MyAutoComplete(
                  label: 'Warp Status',
                  items: controller.loomStatus,
                  selectedItem: transferWarpStatus.value,
                  onChanged: (WeaverByLoomStatusModel item) async {
                    transferWarpStatus.value = item;
                    transferWarpWeavNo.text = "${item.weaveNo}";
                  },
                ),
                MyTextField(
                  controller: transferWarpWeavNo,
                  hintText: 'Weav No',
                  validate: 'number',
                  readonly: true,
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'Trsfr - Yarn') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                WeavingTransferYarnAutoComplete(
                  label: 'Yarn',
                  items: controller.transferYarn,
                  selectedItem: transferYarnYarnName.value,
                  onChanged: (WeaverTransferYarnModel item) {
                    transferYarnYarnName.value = item;
                    transferYarnWeaverStockQty.text =
                        item.weftBalance!.toStringAsFixed(3);
                  },
                ),
                MyTextField(
                  controller: transferYarnWeaverStockQty,
                  hintText: 'Weaver Stock Qty',
                  readonly: true,
                ),
              ],
            ),
            Wrap(
              children: [
                MyAutoComplete(
                  label: 'Loom',
                  items: controller.loomList,
                  selectedItem: transferYarnTo.value,
                  onChanged: (LoomGroup item) {
                    controller.loomStatus.clear();
                    transferYarnStatus.value = null;
                    transferYarnWeavNo.text = "";
                    transferYarnTo.value = item;

                    /// Current Status Api Call
                    warpStatusApiCall(item.loomNo);
                  },
                ),
                MyAutoComplete(
                  label: 'Warp Status',
                  items: controller.loomStatus,
                  selectedItem: transferYarnStatus.value,
                  onChanged: (WeaverByLoomStatusModel item) async {
                    transferYarnStatus.value = item;
                    transferYarnWeavNo.text = "${item.weaveNo}";
                  },
                ),
                MyTextField(
                  controller: transferYarnWeavNo,
                  hintText: 'Weav No',
                  validate: 'number',
                  readonly: true,
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'Adjustment Wt') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: adjustmentWtDeliveryWeight,
                    hintText: 'Delivered Wight',
                    validate: 'double',
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(
                      adjustmentWtDeliveryWeight,
                    );
                  },
                ),
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: adjustmentWtReceivedWight,
                    hintText: 'Received Wight',
                    validate: 'double',
                  ),
                  onFocusChange: (haFocus) {
                    AppUtils.fractionDigitsText(
                      adjustmentWtReceivedWight,
                    );
                  },
                ),
              ],
            ),
            Wrap(
              children: [
                MyTextField(
                  controller: adjustmentWtDetails,
                  hintText: 'Details',
                  validate: 'string',
                ),
              ],
            ),
          ],
        ),
      );
    } else if (option == 'O.Bal - Empty') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                MyTextField(
                  controller: openBalBeamIn,
                  hintText: 'Beam IN',
                  validate: "number",
                ),
                MyTextField(
                  controller: openBalBeamOut,
                  hintText: 'Beam Out',
                  validate: "number",
                ),
              ],
            ),
            Wrap(
              children: [
                MyTextField(
                  controller: openBalBobbinIn,
                  hintText: 'Bobbin IN',
                ),
                MyTextField(
                  controller: openBalBobbinOut,
                  hintText: 'Bobbin Out',
                ),
              ],
            ),
            Wrap(
              children: [
                MyTextField(
                  controller: openBalSheetIn,
                  hintText: 'Sheet IN',
                  validate: "number",
                ),
                MyTextField(
                  controller: openBalSheetOut,
                  hintText: 'Sheet Out',
                  validate: "number",
                ),
              ],
            ),
            MyTextField(
              controller: openBalDetails,
              hintText: 'Details',
            ),
          ],
        ),
      );
    } else if (option == 'Inward - Cops, Reel') {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                MyDropdownButtonFormField(
                    controller: inwardCopRelCopsType,
                    hintText: "",
                    items: const ["Nothing"]),
                MyTextField(
                  controller: inwardCopRelCops,
                  hintText: "Cops",
                  validate: "number",
                )
              ],
            ),
            Wrap(
              children: [
                MyDropdownButtonFormField(
                    controller: inwardCopRelReelType,
                    hintText: "",
                    items: const ["J.Reel"]),
                MyTextField(
                  controller: inwardCopRelReel,
                  hintText: "Cops",
                  validate: "number",
                )
              ],
            ),
            Wrap(
              children: [
                MyDropdownButtonFormField(
                    controller: inwardCopRelConeType,
                    hintText: "",
                    items: const ["Nothing"]),
                MyTextField(
                  controller: inwardCopRelCone,
                  hintText: "Cone",
                  validate: "number",
                )
              ],
            ),
            MyTextField(
              controller: inwardCopRelDetails,
              hintText: "Details",
            )
          ],
        ),
      );
    } else if (option == "O.Bal - Amount") {
      return SizedBox(
        child: Wrap(
          children: [
            Row(
              children: [
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: openBalAmountDebit,
                    hintText: 'Debit (Or) Paid',
                    validate: 'double',
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(openBalAmountDebit,
                        fractionDigits: 2);
                  },
                ),
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: openBalAmountCredit,
                    hintText: 'Credit (Or) Wages',
                    validate: 'double',
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(openBalAmountCredit,
                        fractionDigits: 2);
                  },
                ),
              ],
            ),
            MyTextField(
              controller: openBalAmountDetails,
              hintText: 'Details',
            ),
          ],
        ),
      );
    } else if (option == "O.Bal - Cops,Reel") {
      return SizedBox(
        child: Wrap(
          children: [
            MyDropdownButtonFormField(
                controller: openBalCopRelCopType,
                hintText: "",
                items: const ["Nothing"]),
            MyTextField(
              controller: openBalCopRelCopIn,
              hintText: "Cops In",
              validate: "number",
            ),
            MyTextField(
              controller: openBalCopRelCopOut,
              hintText: "Cops Out",
              validate: "number",
            ),
            MyDropdownButtonFormField(
                controller: openBalCopRelRelType,
                hintText: "",
                items: const ["Nothing"]),
            MyTextField(
              controller: openBalCopRelRelIn,
              hintText: "Reel In",
              validate: "number",
            ),
            MyTextField(
              controller: openBalCopRelCopOut,
              hintText: "Reel Out",
              validate: "number",
            ),
            MyDropdownButtonFormField(
                controller: openBalCopRelConeType,
                hintText: "",
                items: const ["Nothing"]),
            MyTextField(
              controller: openBalCopRelConeIn,
              hintText: "Cone In",
              validate: "number",
            ),
            MyTextField(
              controller: openBalCopRelConeOut,
              hintText: "Cone Out",
              validate: "number",
            ),
            MyTextField(
              controller: openBalCopRelDetails,
              hintText: "Details",
            ),
          ],
        ),
      );
    } else if (option == "O.Bal - Warp") {
      return SizedBox(
        child: Wrap(
          children: [
            Row(
              children: [
                MyAutoComplete(
                  label: 'Warp Design',
                  items: controller.warpTypeList,
                  selectedItem: openBalWarpDesign.value,
                  onChanged: (WarpType item) {
                    openBalWarpDesign.value = item;
                    openBalWarpType.text = "${item.wrapType}";
                  },
                ),
                MyTextField(
                  controller: openBalWarpType,
                  hintText: "Warp Type",
                  readonly: true,
                ),
              ],
            ),
            Row(
              children: [
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: openBalWarpMetre,
                    hintText: "Metre",
                    validate: "double",
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(
                      openBalWarpMetre,
                    );
                  },
                ),
                MyTextField(
                  controller: openBalWarpSheet,
                  hintText: "Sheet",
                  validate: "number",
                ),
              ],
            ),
            Row(
              children: [
                MyDropdownButtonFormField(
                    controller: openBalWarpEmptyType,
                    hintText: "Empty Type",
                    items: const ["Nothing", "Beam", "Bobbin"]),
                MyTextField(
                  controller: openBalWarpEmptyQty,
                  hintText: "Empty Qty",
                  validate: "number",
                ),
              ],
            ),
            Row(
              children: [
                MyTextField(
                  controller: openBalWarpDetails,
                  hintText: "Details",
                )
              ],
            )
          ],
        ),
      );
    } else if (option == "O.Bal - Yarn") {
      return SizedBox(
        child: Wrap(
          children: [
            Row(
              children: [
                MyAutoComplete(
                  label: 'Yarn',
                  items: controller.yarnDropdown,
                  selectedItem: openBalYarnYarnName.value,
                  onChanged: (YarnModel item) {
                    openBalYarnYarnName.value = item;
                  },
                ),
                MyAutoComplete(
                  label: 'Color',
                  items: controller.colorDropdown,
                  selectedItem: openBalYarnColourName.value,
                  onChanged: (NewColorModel item) {
                    openBalYarnColourName.value = item;
                  },
                ),
              ],
            ),
            Row(
              children: [
                MyTextField(
                  controller: openBalYarnPack,
                  hintText: "Pack",
                  validate: "number",
                ),
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: openBalYarnQty,
                    hintText: "Qty",
                    validate: "double",
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(
                      openBalYarnQty,
                    );
                  },
                ),
              ],
            ),
            MyTextField(
              controller: openBalYarnDetails,
              hintText: "Details",
            ),
          ],
        ),
      );
    } else if (option == "Warp-Dropout") {
      return SizedBox(
        child: Wrap(
          children: <Widget>[
            Row(
              children: [
                WeavingWarpDesignAutoComplete(
                  label: 'Warp Design',
                  items: controller.warpExcess,
                  selectedItem: warpDropWarpDesign.value,
                  onChanged: (WarpExcessModel item) {
                    warpDropWarpDesign.value = item;
                    warpDropoutValueInit(item);
                  },
                ),
                MyTextField(
                  controller: warpDropWarpType,
                  hintText: "Warp type",
                  readonly: true,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Old Warp Id : ${warpDropOldWarpIdNo.value.text}",
                style: const TextStyle(color: Colors.red),
              ),
            ),
            Row(
              children: [
                MyTextField(
                  controller: warpDropWarpIdNo,
                  hintText: "Warp Id No",
                  validate: "string",
                ),
                MyTextField(
                  controller: warpDropProductQty,
                  hintText: "Product Qty",
                  readonly: true,
                ),
              ],
            ),
            Row(
              children: [
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: warpDropMetre,
                    hintText: "Metre",
                    readonly: true,
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(
                      warpDropMetre,
                    );
                  },
                ),
                MyDropdownButtonFormField(
                  controller: warpDropEmptyType,
                  hintText: "Empty Type",
                  items: const ["Nothing", "Beam", "Bobbin"],
                  onChanged: (value) {
                    if (value == "Nothing") {
                      warpDropSheet.text = "0";
                      warpDropEmptyQty.text = "0";
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                MyTextField(
                  controller: warpDropEmptyQty,
                  hintText: "Empty Qty",
                  validate: "number",
                ),
                MyTextField(
                  controller: warpDropSheet,
                  hintText: "Sheet",
                  validate: "number",
                ),
              ],
            ),
            Row(
              children: [
                MyTextField(
                  controller: warpDropRunningWarpId,
                  hintText: "Current Warp Id",
                  enabled: false,
                ),
                MyTextField(
                  controller: warpDropDetails,
                  hintText: "Details",
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget weaverYarnStockTable() {
    return MySFDataGridItemTable(
      shrinkWrapRows: false,
      scrollPhysics: const ScrollPhysics(),
      columns: [
        GridColumn(
          columnName: 'yarn_name',
          label: const MyDataGridHeader(title: 'Yarn Name'),
        ),
        GridColumn(
          width: 150,
          columnName: 'weaver_stock',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Weaver Stock'),
        ),
      ],
      source: weaverYarnStockDataSource,
    );
  }

  Widget weaverOtherWarpStockTable() {
    return MySFDataGridItemTable(
      shrinkWrapRows: false,
      scrollPhysics: const ScrollPhysics(),
      columns: [
        GridColumn(
          columnName: 'warp_design_name',
          label: const MyDataGridHeader(title: 'Warp Design'),
        ),
        GridColumn(
          width: 150,
          columnName: 'weaver_stock',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Weaver Stock'),
        ),
      ],
      source: weaverOtherWarpDataSource,
    );
  }

  /// this method is called on initState and submit button on press
  weaverYarnStockApiCall() async {
    var weaverId = controller.weaverId;
    var loomNo = "ALL";

    if (weaverId == null) {
      return;
    }

    var result = await controller.weaverOverAllYarnStock(weaverId, loomNo);

    if (result.isNotEmpty) {
      controller.weaverYarnStockApiValue = result;
    }
    weaverYarnStockChange();
  }

  weaverYarnStockChange() {
    var localDetails =
        controller.itemList.where((element) => element["sync"] == 0).toList();
    var apiDetails = controller.weaverYarnStockApiValue;

    /// local added yarn quantity calculation
    ///
    /// if entry type = [ yarn delivery, O.Bal - Yarn ]
    /// add the weaver stock and local yarn qty
    ///
    /// if entry type = [ return yarn,Rtrn-Yarn, Trsfr - Yarn ]
    /// minus the weaver stock and local yarn qty
    // Create a map for quick lookup by yarnId
    var apiDetailsMap = {for (var d in apiDetails) d.yarnId: d};
    for (var e in localDetails) {
      var yarnId = e["yarn_id"];
      var entryType = e["entry_type"];
      var yarnQty = e["yarn_qty"];

      // Check if the yarnId exists in the map
      if (apiDetailsMap.containsKey(yarnId)) {
        var apiItem = apiDetailsMap[yarnId];
        var currentStock = (double.tryParse("${apiItem?.wevStock}") ?? 0);

        if (entryType == "Yarn Delivery" || entryType == "O.Bal - Yarn") {
          apiItem!.wevStock = currentStock + yarnQty;
        } else if (entryType == "Rtrn-Yarn" ||
            entryType == "Yarn Wastage" ||
            entryType == "Trsfr - Yarn") {
          apiItem!.wevStock = currentStock - yarnQty;
        }
      }
    }

    weaverYarnStockLocal.clear();

    weaverYarnStockLocal.addAll(apiDetails.toList());
    weaverYarnStockDataSource.updateDataGridRows();
    weaverYarnStockDataSource.updateDataGridSource();
  }

  /// this method is called on initState and submit button on press
  weaverOtherWarpApiCall(var warpType) async {
    if (warpType != "Other") {
      return;
    }

    var weaverId = controller.weaverId;
    var loomNo = "ALL";

    if (weaverId == null) {
      return;
    }
    var result = await controller.weaverOverAllOtherWarp(weaverId, loomNo);

    if (result.isNotEmpty) {
      controller.weaverOtherWarpStockApiValue = result;
    }

    weaverOtherWarpStockChange();
  }

  weaverOtherWarpStockChange() {
    var localDetails =
        controller.itemList.where((element) => element["sync"] == 0).toList();
    var apiDetails = controller.weaverOtherWarpStockApiValue;

    /// local added other warp quantity calculation
    ///
    /// if entry type = [ warp excess, warp delivery, O.Bal - Warp ]
    /// add the weaver stock and local other warp meter
    ///
    /// if entry type = [ warp shortage, warp dropout,Trsfr - Warp ]
    /// minus the weaver stock and local other warp meter
    ///
    // Create a map for quick lookup by warpDesignId

    var apiDetailsMap = {for (var d in apiDetails) d.warpDesignId: d};

    for (var e in localDetails) {
      var warpDesignId = e["warp_design_id"];
      var entryType = e["entry_type"];
      var meter = e["meter"];

      // Check if the warpDesignId exists in the map
      if (apiDetailsMap.containsKey(warpDesignId)) {
        var apiItem = apiDetailsMap[warpDesignId];
        var currentStock = (double.tryParse("${apiItem?.weaverStock}") ?? 0);

        if (entryType == "Warp Delivery" ||
            entryType == "Warp Excess" ||
            entryType == "O.Bal - Warp") {
          apiItem!.weaverStock = currentStock + meter;
        } else if (entryType == "Warp Shortage" ||
            entryType == "Warp-Dropout" ||
            entryType == "Trsfr - Warp") {
          apiItem!.weaverStock = currentStock - meter;
        }
      }
    }

    weaverOtherWarpStockLocal.clear();

    weaverOtherWarpStockLocal.addAll(apiDetails.toList());
    weaverOtherWarpDataSource.updateDataGridRows();
    weaverOtherWarpDataSource.updateDataGridSource();
  }

  shortCutKeys() {
    if (_warpDesignFocusNode.hasFocus) {
      shortCut.value = "To Create 'Warp Design',Press Alt+C";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_warpDesignFocusNode.hasFocus) {
      var productId = controller.productId;
      if (productId == null) {
        return;
      }

      var request = {"product_id": productId};
      var result =
          await Get.toNamed(AddProductInfo.routeName, arguments: request);
      if (result == "success") {
        controller.warpInfo(productId);
      }
    }
  }

  _initValue() async {
    weaverYarnStockApiCall();
    weaverOtherWarpApiCall("Other");

    dateController.text = AppUtils.parseDateTime('${DateTime.now()}');

    if (controller.colorDropdown.isNotEmpty) {
      openBalYarnColourName.value = controller.colorDropdown.first;
      yarnDeliveryColorName.value = controller.colorDropdown.first;
      returnYarnColorName.value = controller.colorDropdown.first;
    }

    var weavingId = controller.request['weaving_ac_id'];

    entryTypes.value = await controller.entryType(weavingId);
  }

  /// This Method Used To Display The Warp Deliver Warp Id By Details
  void warpDeliveryWarpDetails(WeavingWarpDeliveryModel item) {
    if (item.beam != 0) {
      warpDeliveryEmptyQyt.text = "${item.beam}";
      warpDeliveryEmptyType.text = "Beam";
    } else if (item.bobbin != 0) {
      warpDeliveryEmptyQyt.text = "${item.bobbin}";
      warpDeliveryEmptyType.text = "Bobbin";
    } else {
      warpDeliveryEmptyQyt.text = "0";
      warpDeliveryEmptyType.text = "Nothing";
    }

    warpDeliveryProductQyt.text = "${item.qty}";
    warpDeliveryMeter.text = "${item.meter}";
    warpDeliverySheet.text = "${item.sheet}";
    warpDeliveryWarpColor.text = item.warpColor ?? '';
    warpDeliveryDetails.text = item.warpDet ?? "";
  }

  void transferAmountIntValues(var entryType) {
    if (entryType != "Trsfr - Amount") {
      return;
    }

    num creditAmount = controller.creditAmount ?? 0;
    num debitAmount = controller.debitAmount ?? 0;

    num creditBalance = creditAmount - debitAmount;
    num debitBalance = debitAmount - creditAmount;

    if (creditBalance > 0) {
      transferAmountCredit.text = "$creditBalance";
    } else {
      transferAmountCredit.text = "0";
    }

    if (debitBalance > 0) {
      transferAmountDebit.text = "$debitBalance";
    } else {
      transferAmountDebit.text = "0";
    }
  }

  void transferEmptyIntValues(var entryType) {
    if (entryType != "Trsfr - Empty") {
      return;
    }
    num bmIn = controller.bmIn ?? 0;
    num bmOut = controller.bmOut ?? 0;
    num bbnIn = controller.bbnIn ?? 0;
    num bbnOut = controller.bbnOut ?? 0;
    num sheetIn = controller.shtIn ?? 0;
    num sheetOut = controller.shtOut ?? 0;

    num balanceBmIn = bmIn - bmOut;
    num balanceBmOut = bmOut - bmIn;
    num balanceBbnIn = bbnIn - bbnOut;
    num balanceBbnOut = bbnOut - bbnIn;
    num balanceSheetIn = sheetIn - sheetOut;
    num balanceSheetOut = sheetOut - sheetIn;

    transferEmptyBeam.text = "$balanceBmOut";
    transferEmptyBobbin.text = "$balanceBbnOut";
    transferEmptySheet.text = "$balanceSheetOut";

    /// Beam In Balance
    if (balanceBmIn > 0) {
      transferEmptyBeamIn.text = "$balanceBmIn";
    } else {
      transferEmptyBeamIn.text = "0";
    }

    /// Beam Out Balance
    if (balanceBmOut > 0) {
      transferEmptyBeamOut.text = "$balanceBmOut";
    } else {
      transferEmptyBeamOut.text = "0";
    }

    /// Bobbin In Balance
    if (balanceBbnIn > 0) {
      transferEmptyBobbinIn.text = "$balanceBbnIn";
    } else {
      transferEmptyBobbinIn.text = "0";
    }

    /// Bobbin Out Balance
    if (balanceBbnOut > 0) {
      transferEmptyBobbinOut.text = "$balanceBbnOut";
    } else {
      transferEmptyBobbinOut.text = "0";
    }

    /// Sheet In Balance
    if (balanceSheetIn > 0) {
      transferEmptySheetIn.text = "$balanceSheetIn";
    } else {
      transferEmptySheetIn.text = "0";
    }

    /// Sheet Out Balance
    if (balanceSheetOut > 0) {
      transferEmptySheetOut.text = "$balanceSheetOut";
    } else {
      transferEmptySheetOut.text = "0";
    }
  }

  void _goodsInwardCalculation() {
    num meter = controller.productMeter ?? 0;
    int qty = int.tryParse(goodsInwardInwardQty.text) ?? 0;
    int pendingQty = int.tryParse(goodsInwardPendingQty.text) ?? 0;
    double wages = double.tryParse(goodsInwardWages.text) ?? 0.00;
    double amount = 0.00;
    num pendingMeter = pendingQty * meter;

    num proMeter = qty * meter;
    amount = qty * wages;
    goodsInwardAmount.text = "$amount";
    goodsInwardMeterInWard.text = "$proMeter";
    goodsInwardPendingMeter.text = "$pendingMeter";
  }

  _apiCall(var entryType) async {
    var weavingId = controller.request['weaving_ac_id'];
    var productId = controller.productId;

    /// send value to warpExcessInfo methode
    if (entryType == "Warp-Dropout" ||
        entryType == "Warp Shortage" ||
        entryType == "Warp Excess") {
      await controller.warpExcessInfo(weavingId);
    }

    /// Transfer Yarn Api Call

    if (entryType == "Trsfr - Yarn" || entryType == "Yarn Wastage") {
      controller.transferYarnBalance(weavingId);
    }

    if (entryType == "Warp Delivery" || entryType == "O.Bal - Warp") {
      await controller.warpInfo(productId);
    }

    /// Transfer Warp Api Call
    transferWarp(entryType);

    /// Good Inward
    goodsInwardIntValue(entryType);

    /// Transfer Amount
    transferAmountIntValues(entryType);

    /// Transfer Empty
    transferEmptyIntValues(entryType);

    /// All Transfer To And Warp Status Init
    _transferLoomInt(entryType);

    /// Payment Accounts

    if (entryType == "Payment") {
      controller.paymentAccountInfo();
    }

    if (entryType == "Credit") {
      controller.debitAccountInfo();
    }
  }

  void goodsInwardIntValue(var entryType) {
    if (entryType != "Goods Inward") {
      return;
    }

    /// product info value display in goods inward
    var productId = controller.productId;
    var productMeter = controller.productMeter;
    var productWages = controller.productWages;
    var productDesignNo = controller.request['product_design_no'];

    var productList = controller.productDropdown
        .where((element) => '${element.id}' == '$productId')
        .toList();
    if (productList.isNotEmpty) {
      goodsInwardProduct.value = productList.first;
    }
    goodsInwardDesignNo.text = tryCast(productDesignNo);
    goodsInwardMeterInWard.text = "$productMeter";
    goodsInwardWages.text = "$productWages";
  }

  _transferLoomInt(var entryType) async {
    if (entryType == "Trsfr - Empty" ||
        entryType == "Trsfr - Amount" ||
        entryType == "Trsfr - Cops,Reel" ||
        entryType == "Trsfr - Warp" ||
        entryType == "Trsfr - Yarn") {
      var loomNo = controller.request['loom_id'];

      var loomList = controller.loomList
          .where((element) => '${element.loomNo}' == '$loomNo')
          .toList();
      if (loomList.isNotEmpty) {
        transferAmountTo.value = loomList.first;
        transferCopsReelsTo.value = loomList.first;
        transferEmptyTo.value = loomList.first;
        transferWarpTo.value = loomList.first;
        transferYarnTo.value = loomList.first;

        /// Current Status Api Call
        warpStatusApiCall(loomNo);
      }
    }
  }

  void warpShortAgeCalculation() {
    int warpQty = int.tryParse(warpShortageWarpQty.text) ?? 0;
    num? meter = controller.productMeter;

    num warpMeter = warpQty * meter!;

    warpShortageWarpMeter.text = "$warpMeter";
  }

  void transferWarp(var entryType) async {
    if (entryType != "Trsfr - Warp") {
      return;
    }

    var weavingAcId = controller.request['weaving_ac_id'];
    await controller.otherWarpBalance(weavingAcId);
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      var entryType = _selectedEntryType.value.toString();
      Map<String, dynamic> request = {
        "e_date": dateController.text,
        "transaction_type": transactionTypeController.text,
        "entry_type": entryType,
        "weaving_ac_id": controller.request["weaving_ac_id"],
        "created_at": "${DateTime.now()}",
        "creator_name": AppUtils().loginName,
        "sync": 0,
      };

      if (entryType == "Warp Delivery") {
        var warpType = warpDeliveryWarpType.text;
        double warpMeter = double.tryParse(warpDeliveryMeter.text) ?? 0.0;
        request["warp_design"] =
            warpDeliveryWarpDesignController.value?.wrapDesign;
        request["warp_design_id"] =
            warpDeliveryWarpDesignController.value?.warpDesignId;
        request["warp_type"] = warpType;
        request["warp_id"] = warpDeliveryWarpIdNo.value?.newWarpId;
        request["warp_qty"] = int.tryParse(warpDeliveryProductQyt.text) ?? 0;
        request["meter"] = warpMeter;
        var emptyType = warpDeliveryEmptyType.text;
        if (emptyType == "Beam") {
          request["bm_out"] = int.tryParse(warpDeliveryEmptyQyt.text) ?? 0;
        } else if (emptyType == "Bobbin") {
          request["bbn_out"] = int.tryParse(warpDeliveryEmptyQyt.text) ?? 0;
        }
        request["sht_out"] = int.tryParse(warpDeliverySheet.text) ?? 0;
        request["product_details"] = warpDeliveryDetails.text;
        request["warp_color"] = warpDeliveryWarpColor.text;
        // transferTableWarpDetailsAdd(entryType, warpType,
        //     warpDeliveryWarpDesignController.value?.warpDesignId, warpMeter)
        // Get.back(result: request);
      } else if (entryType == "Yarn Delivery") {
        double yarnQty = double.tryParse(yarnDeliveryNetQuantity.text) ?? 0.0;

        if (yarnQty == 0) {
          return AppUtils.infoAlert(message: "Delivery Yarn Qty Is ' 0 '");
        }

        request["yarn_name"] = yarnDeliveryYarnName.value?.name;
        request["yarn_id"] = yarnDeliveryYarnName.value?.id;
        request["yarn_color_id"] = yarnDeliveryColorName.value?.id;
        request["color_name"] = yarnDeliveryColorName.value?.name;
        request["stock_in"] = yarnDeliveryDeliveryFrom.text;
        request["box_serial_no"] = yarnDeliveryBoxNo.text;
        request["yarn_pack"] = yarnDeliveryPack.text;
        request["yarn_gross_qty"] =
            double.tryParse(yarnDeliveryGrossQty.text) ?? 0.0;
        request["yarn_empty_type"] = 'Nothing';
        request["yarn_single_empty_wt"] =
            double.tryParse(yarnDeliveryWeight.text) ?? 0.0;
        request["yarn_less_wt"] = double.tryParse(yarnDeliveryLess.text) ?? 0.0;
        request["product_details"] = yarnDeliveryDetails.text;
        request["yarn_qty"] = yarnQty;
        transferTableYarnDetailsAdd(
            entryType, yarnQty, yarnDeliveryYarnName.value?.id);
        dataSourcesUpdate(request, entryType);
      } else if (entryType == "Goods Inward") {
        double credit = double.tryParse(goodsInwardAmount.text) ?? 0.0;

        request["product_name"] = goodsInwardProduct.value?.productName;
        request["product_id"] = goodsInwardProduct.value?.id;
        request["design_no"] = goodsInwardDesignNo.text;
        request["inward_qty"] = int.tryParse(goodsInwardInwardQty.text) ?? 0;
        request["inward_meter"] =
            double.tryParse(goodsInwardMeterInWard.text) ?? 0.0;
        request["wages"] = double.tryParse(goodsInwardWages.text) ?? 0.0;
        request["credit"] = credit;
        request["damaged"] = goodsInwardDamaged.text;
        request["product_details"] = goodsInwardDetails.text;
        request["pending"] = goodsInwardPending.text;
        request["pending_qty"] = int.tryParse(goodsInwardPendingQty.text) ?? 0;
        request["pending_meter"] =
            double.tryParse(goodsInwardPendingMeter.text) ?? 0.0;
        // transferTableAmountDetailsAdd(entryType, credit, 0);
        // Get.back(result: request);
      } else if (entryType == "Payment") {
        double debit = double.tryParse(paymentAmount.text) ?? 0.0;

        request["pr_ledger_id"] = paymentTo.value?.id;
        request["pr_ledger_name"] = paymentTo.value?.name;
        request["debit"] = debit;
        request["payment_type"] = paymentType.text;
        request["product_details"] = paymentDetail.text;

        transferTableAmountDetailsAdd(entryType, 0, debit);
        dataSourcesUpdate(request, entryType);
      } else if (entryType == "Empty - (In / Out)") {
        int bmIn = int.tryParse(emptyInOutBeamIn.text) ?? 0;
        int bmOut = int.tryParse(emptyInOutBeamOut.text) ?? 0;
        int bbnIn = int.tryParse(emptyInOutBobbinIn.text) ?? 0;
        int bbnOut = int.tryParse(emptyInOutBobbinOut.text) ?? 0;
        int shtIn = int.tryParse(emptyInOutSheetIn.text) ?? 0;
        int shtOut = int.tryParse(emptyInOutSheetOut.text) ?? 0;

        var list = [];
        if (bmIn > 0) {
          var req = Map.from(request);
          req['bm_in'] = bmIn;
          req['bm_out'] = 0;
          req['bbn_in'] = 0;
          req['bbn_out'] = 0;
          req['sht_in'] = 0;
          req['sht_out'] = 0;
          req["product_details"] = emptyInOutDetails.text;
          list.add(req);
        }
        if (bmOut > 0) {
          var req = Map.from(request);
          req['bm_in'] = 0;
          req['bm_out'] = bmOut;
          req['bbn_in'] = 0;
          req['bbn_out'] = 0;
          req['sht_in'] = 0;
          req['sht_out'] = 0;
          req["product_details"] = emptyInOutDetails.text;
          list.add(req);
        }
        if (bbnIn > 0) {
          var req = Map.from(request);
          req['bm_in'] = 0;
          req['bm_out'] = 0;
          req['bbn_in'] = bbnIn;
          req['bbn_out'] = 0;
          req['sht_in'] = 0;
          req['sht_out'] = 0;
          req["product_details"] = emptyInOutDetails.text;
          list.add(req);
        }
        if (bbnOut > 0) {
          var req = Map.from(request);
          req['bm_in'] = 0;
          req['bm_out'] = 0;
          req['bbn_in'] = 0;
          req['bbn_out'] = bbnOut;
          req['sht_in'] = 0;
          req['sht_out'] = 0;
          req["product_details"] = emptyInOutDetails.text;
          list.add(req);
        }
        if (shtIn > 0) {
          var req = Map.from(request);
          req['bm_in'] = 0;
          req['bm_out'] = 0;
          req['bbn_in'] = 0;
          req['bbn_out'] = 0;
          req['sht_in'] = shtIn;
          req['sht_out'] = 0;
          req["product_details"] = emptyInOutDetails.text;
          list.add(req);
        }
        if (shtOut > 0) {
          var req = Map.from(request);
          req['bm_in'] = 0;
          req['bm_out'] = 0;
          req['bbn_in'] = 0;
          req['bbn_out'] = 0;
          req['sht_in'] = 0;
          req['sht_out'] = shtOut;
          req["product_details"] = emptyInOutDetails.text;
          list.add(req);
        }
        request['list'] = list;
        dataSourcesUpdate(request, entryType);
      } else if (entryType == "Receipt") {
        request["by"] = receiptBy.value?.id;
        request["by_name"] = receiptBy.value?.name;
        request["amount"] = double.tryParse(receiptAmounts.text) ?? 0.0;
        request["product_details"] = receiptDetail.text;
        dataSourcesUpdate(request, entryType);
      } else if (entryType == "Rtrn-Yarn") {
        double yarnQty = double.tryParse(returnYarnNetQty.text) ?? 0.0;

        if (yarnQty == 0) {
          return AppUtils.infoAlert(message: "Delivery Yarn Qty Is ' 0 '");
        }

        request["yarn_name"] = returnYarnYarnName.value?.name;
        request["yarn_id"] = returnYarnYarnName.value?.id;
        request["color_name"] = returnYarnColorName.value?.name;
        request["yarn_color_id"] = returnYarnColorName.value?.id;
        request["stock_in"] = returnYarnStockTo.text;
        request["box_serial_no"] = returnYarnBoxNo.text;
        request["yarn_pack"] = int.tryParse(returnYarnPack.text) ?? 0;
        request["yarn_gross_qty"] =
            double.tryParse(returnYarnGrossQty.text) ?? 0.0;
        request["yarn_empty_type"] = "Nothing";
        request["yarn_single_empty_wt"] =
            double.tryParse(returnYarnWeight.text) ?? 0.0;
        request["yarn_less_wt"] = double.tryParse(returnYarnLess.text) ?? 0.0;
        request["product_details"] = returnYarnDetails.text;
        request["yarn_qty"] = yarnQty;
        transferTableYarnDetailsAdd(
            entryType, yarnQty, returnYarnYarnName.value?.id);
        dataSourcesUpdate(request, entryType);
      } else if (entryType == "Credit") {
        double credit = double.tryParse(creditAmountRs.text) ?? 0.0;
        request["pr_ledger_id"] = creditBy.value?.id;
        request["pr_ledger_name"] = creditBy.value?.name;
        request["credit"] = credit;
        request["product_details"] = creditDetails.text;

        transferTableAmountDetailsAdd(entryType, credit, 0);
        dataSourcesUpdate(request, entryType);
      } else if (entryType == "Debit") {
        double debit = double.tryParse(debitAmountRs.text) ?? 0.0;

        request["pr_ledger_id"] = debitBy.value?.id;
        request["pr_ledger_name"] = debitBy.value?.name;
        request["debit"] = debit;
        request["product_details"] = debitDetails.text;
        transferTableAmountDetailsAdd(entryType, 0, debit);
        dataSourcesUpdate(request, entryType);
      } else if (entryType == "Yarn Wastage") {
        double yarnQty = double.tryParse(yarnWastageQuantity.text) ?? 0.0;

        request["yarn_name"] = yarnWastageYarn.value?.yarnName;
        request["yarn_id"] = yarnWastageYarn.value?.yarnId;
        request["yarn_qty"] = yarnQty;
        request["product_details"] = yarnWastageDetails.text;
        transferTableYarnDetailsAdd(
            entryType, yarnQty, yarnWastageYarn.value?.yarnId);
        dataSourcesUpdate(request, entryType);
      } else if (entryType == "Warp Excess") {
        var warpType = warpExcessWarpType.text;

        if (warpType == "Other") {
          if (warpExcessWarpDesign.value?.warpId == null ||
              warpExcessWarpDesign.value!.warpId!.isEmpty) {
            return AppUtils.infoAlert(message: "Select the warp id");
          }
        }

        int qty = int.tryParse(warpExcessWarpQty.text) ?? 0;
        double meter = double.tryParse(warpExcessWarpMeter.text) ?? 0.0;

        var alert = await sameWarpStatusCheck(qty, entryType, warpType);
        if (alert == "Running") {
          return AppUtils.infoAlert(
              message:
                  "Already running account is available, so you can't add a warp excess.");
        }

        for (var e in controller.itemList) {
          if (e["entry_type"] == "Warp Shortage" && e["sync"] == 0) {
            return AppUtils.infoAlert(message: "Save the last added data");
          }
        }

        request["warp_design_id"] = warpExcessWarpDesign.value?.warpDesignId;
        request["warp_design"] = warpExcessWarpDesign.value?.warpName;
        request["warp_type"] = warpExcessWarpType.text;
        request["warp_qty"] = qty;
        request["meter"] = meter;
        request["we_details"] = warpExcessDetails.text;
        if (warpType == "Other") {
          request["other_warpid"] = warpExcessWarpDesign.value?.warpId;
        } else {
          request["other_warpid"] = null;
        }

        transferTableWarpDetailsAdd(entryType, warpType,
            warpExcessWarpDesign.value?.warpDesignId, meter);
        dataSourcesUpdate(request, entryType, warpTypr: warpType);
      } else if (entryType == "Message") {
        request["language"] = messageLanguage.text;
        request["message_type"] = messageMsgType.text;
        request["message"] = messageMsg.text;
        dataSourcesUpdate(request, entryType);
      } else if (entryType == "Warp Shortage") {
        int qty = int.tryParse(warpShortageWarpQty.text) ?? 0;
        var warpType = warpShortageWarpType.text;

        var alert = await sameWarpStatusCheck(qty, entryType, warpType);
        if (alert == "Completed") {
          return AppUtils.infoAlert(
              message:
                  "Already completed account is available, so you can't add a warp shortage.");
        }

        for (var e in controller.itemList) {
          if (e["entry_type"] == "Warp Excess" && e["sync"] == 0) {
            return AppUtils.infoAlert(message: "Save the last added data");
          }
        }

        int warpBalanceQty = int.tryParse(warpShortageBalanceQty.text) ?? 0;
        double warpMeter =
            double.tryParse(warpShortageBalanceMeter.text) ?? 0.0;

        double balanceMeter =
            double.tryParse(warpShortageWarpMeter.text) ?? 0.0;

        if (warpType == "Main Warp") {
          if (warpBalanceQty >= qty) {
            request["warp_design_id"] =
                warpShortageWarpDesign.value?.warpDesignId;
            request["warp_design"] = warpShortageWarpDesign.value?.warpName;
            request["warp_type"] = warpType;
            request["warp_qty"] = qty;
            request["meter"] = balanceMeter;
            request["we_details"] = warpShortageDetails.text;
            dataSourcesUpdate(request, entryType, warpTypr: warpType);
          } else {
            AppUtils.infoAlert(message: "Balance Warp Qty Less Then Warp Qty");
          }
        } else {
          if (warpShortageWarpDesign.value?.warpId == null ||
              warpShortageWarpDesign.value!.warpId!.isEmpty) {
            return AppUtils.infoAlert(message: "Select the warp id");
          }

          if (warpMeter >= balanceMeter && balanceMeter > 0) {
            request["warp_design_id"] =
                warpShortageWarpDesign.value?.warpDesignId;
            request["warp_design"] = warpShortageWarpDesign.value?.warpName;
            request["warp_type"] = warpType;
            request["warp_qty"] = qty;
            request["meter"] = balanceMeter;
            request["we_details"] = warpShortageDetails.text;
            request["other_warpid"] = warpShortageWarpDesign.value?.warpId;
            transferTableWarpDetailsAdd(entryType, warpType,
                warpShortageWarpDesign.value?.warpDesignId, balanceMeter);
            dataSourcesUpdate(request, entryType, warpTypr: warpType);
          } else {
            AppUtils.infoAlert(
                message: "Balance Warp Meter Less Then Warp Meter");
          }
        }
      } else if (entryType == "Trsfr - Amount") {
        request["credit"] = double.tryParse(transferAmountDebit.text) ?? 0.0;
        request["debit"] = double.tryParse(transferAmountCredit.text) ?? 0.0;
        request["trans_to_no"] = int.tryParse(transferAmountWeavNo.text) ?? 0;
        request["loom"] = transferAmountTo.value?.loomNo;
        request["current_status"] = transferAmountStatus.value?.currentStatus;
        transferItemRemove(entryType, 0);

        dataSourcesUpdate(request, entryType);
      } else if (entryType == "Trsfr - Cops,Reel") {
        request["cops_in"] = int.tryParse(transferCopsReelsCops.text) ?? 0;
        request["reel_in"] = int.tryParse(transferCopsReelsReel.text) ?? 0;
        request["trans_to_no"] =
            int.tryParse(transferCopsReelsWeavNo.text) ?? 0;
        request["loom"] = transferCopsReelsTo.value?.loomNo;
        request["current_status"] =
            transferCopsReelsStatus.value?.currentStatus;
        dataSourcesUpdate(request, entryType);
      } else if (entryType == "Trsfr - Empty") {
        request["bm_in"] = int.tryParse(transferEmptyBeamOut.text) ?? 0;
        request["bm_out"] = int.tryParse(transferEmptyBeamIn.text) ?? 0;
        request["bbn_in"] = int.tryParse(transferEmptyBobbinOut.text) ?? 0;
        request["bbn_out"] = int.tryParse(transferEmptyBobbinIn.text) ?? 0;
        request["sht_in"] = int.tryParse(transferEmptySheetOut.text) ?? 0;
        request["sht_out"] = int.tryParse(transferEmptySheetIn.text) ?? 0;
        request["trans_to_no"] = int.tryParse(transferEmptyWeavNo.text) ?? 0;
        request["loom"] = transferEmptyTo.value?.loomNo;
        request["current_status"] = transferEmptyStatus.value?.currentStatus;
        transferItemRemove(entryType, 0);

        dataSourcesUpdate(request, entryType);
      } else if (entryType == "Trsfr - Warp") {
        if (transferWarpWarpDesign.value?.otherWarpId == null) {
          return AppUtils.infoAlert(message: "Select the other warp Id");
        }

        if (transferWarpTo.value?.loomNo!.toLowerCase() == "Vl".toLowerCase()) {
          return AppUtils.infoAlert(message: "Warp Not transfer to VL loom");
        }

        request["warp_design_id"] = transferWarpWarpDesign.value?.warpDesignId;
        request["warp_design"] = transferWarpWarpDesign.value?.warpName;
        request["warp_type"] = transferWarpWarpType.text;
        request["meter"] =
            double.tryParse(transferWarpBalanceMeter.text) ?? 0.0;
        request["trans_to_no"] = int.tryParse(transferWarpWeavNo.text) ?? 0;
        request["loom"] = transferWarpTo.value?.loomNo;
        request["current_status"] = transferWarpStatus.value?.currentStatus;
        request["other_warpid"] = transferWarpWarpDesign.value?.otherWarpId;
        transferItemRemove(
            entryType, transferWarpWarpDesign.value?.warpDesignId);

        dataSourcesUpdate(request, entryType, warpTypr: "Other");
      } else if (entryType == "Trsfr - Yarn") {
        request["yarn_id"] = transferYarnYarnName.value?.yarnId;
        request["yarn_name"] = transferYarnYarnName.value?.yarnName;
        request["yarn_qty"] =
            double.tryParse(transferYarnWeaverStockQty.text) ?? 0.0;
        request["trans_to_no"] = int.tryParse(transferYarnWeavNo.text) ?? 0;
        request["loom"] = transferYarnTo.value?.loomNo;
        request["current_status"] = transferYarnStatus.value?.currentStatus;

        transferItemRemove(entryType, transferYarnYarnName.value?.yarnId);

        dataSourcesUpdate(request, entryType);
      } else if (entryType == "Adjustment Wt") {
        request["delivery_weight"] =
            double.tryParse(adjustmentWtDeliveryWeight.text) ?? 0.0;
        request["received_Weight"] =
            double.tryParse(adjustmentWtReceivedWight.text) ?? 0.0;
        request["product_details"] = adjustmentWtDetails.text;
        dataSourcesUpdate(request, entryType);
      } else if (entryType == "O.Bal - Empty") {
        request["bm_in"] = int.tryParse(openBalBeamIn.text) ?? 0;
        request["bm_out"] = int.tryParse(openBalBeamOut.text) ?? 0;
        request["bbn_in"] = int.tryParse(openBalBobbinIn.text) ?? 0;
        request["bbn_out"] = int.tryParse(openBalBobbinOut.text) ?? 0;
        request["sht_in"] = int.tryParse(openBalSheetIn.text) ?? 0;
        request["sht_out"] = int.tryParse(openBalSheetOut.text) ?? 0;
        request["product_details"] = openBalDetails.text;
        dataSourcesUpdate(request, entryType);
      } else if (entryType == "O.Bal - Amount") {
        double credit = double.tryParse(openBalAmountCredit.text) ?? 0.0;
        double debit = double.tryParse(openBalAmountDebit.text) ?? 0.0;

        request["debit"] = debit;
        request["credit"] = credit;
        request["product_details"] = openBalAmountDetails.text;

        transferTableAmountDetailsAdd(entryType, credit, debit);
        dataSourcesUpdate(request, entryType);
      } else if (entryType == "O.Bal - Warp") {
        var warpType = openBalWarpType.text;
        double warpMeter = double.tryParse(openBalWarpMetre.text) ?? 0.00;

        request["warp_design_id"] = openBalWarpDesign.value?.warpDesignId;
        request["warp_design"] = openBalWarpDesign.value?.wrapDesign;
        request["warp_type"] = warpType;
        request["meter"] = warpMeter;
        var emptyType = openBalWarpEmptyType.text;
        if (emptyType == "Beam") {
          request["bm_out"] = int.tryParse(openBalWarpEmptyQty.text) ?? 0;
        } else {
          request["bbn_out"] = int.tryParse(openBalWarpEmptyQty.text) ?? 0;
        }
        request["wo_details"] = openBalWarpDetails.text;
//         transferTableWarpDetailsAdd(entryType, warpType,
//             openBalWarpDesign.value?.warpDesignId, warpMeter);
//         dataSourcesUpdate(request, entryType, warpTypr: warpType);
      } else if (entryType == "O.Bal - Yarn") {
        double yarnQty = double.tryParse(openBalYarnQty.text) ?? 0.0;

        request["yarn_id"] = openBalYarnYarnName.value?.id;
        request["yarn_name"] = openBalYarnYarnName.value?.name;
        request["yarn_qty"] = yarnQty;
        request["yarn_color_id"] = openBalYarnColourName.value?.id;
        request["color_name"] = openBalYarnColourName.value?.name;
        request["yarn_pack"] = int.tryParse(openBalYarnPack.text) ?? 0;
        request["product_details"] = openBalYarnDetails.text;
        transferTableYarnDetailsAdd(
            entryType, yarnQty, openBalYarnYarnName.value?.id);
        dataSourcesUpdate(request, entryType);
      } else if (entryType == "Warp-Dropout") {
        var warpType = warpDropWarpType.text;
        if (warpType == "Other") {
          if (warpDropWarpDesign.value?.warpId == null ||
              warpDropWarpDesign.value!.warpId!.isEmpty) {
            return AppUtils.infoAlert(message: "Select the Warp id");
          }
        }

        if (warpDropWarpIdNo.text == warpDropOldWarpIdNo.value.text) {
          return AppUtils.infoAlert(
              message: "This warp id is already available in dropout");
        }

        var result = await controller.dropOutWarpIdCheck(warpDropWarpIdNo.text);

        if (result == "False") {
          return;
        }

        int qty = int.tryParse(warpDropProductQty.text) ?? 0;
        double meter = double.tryParse(warpDropMetre.text) ?? 0.0;
        int emptyQty = int.tryParse(warpDropEmptyQty.text) ?? 0;

        if (warpType == "Main Warp") {
          if (qty == 0) {
            return AppUtils.infoAlert(
                message:
                    "Product quantity is '0', so the warp cannot be dropped out.");
          }

          if (warpDropEmptyType.text != "Nothing" && emptyQty == 0) {
            return AppUtils.infoAlert(message: "Enter the empty qty");
          }
        } else {
          if (meter == 0) {
            return AppUtils.infoAlert(
                message:
                    "Product meter is '0', so the warp cannot be dropped out.");
          }

          if (warpDropEmptyType.text != "Nothing" && emptyQty == 0) {
            return AppUtils.infoAlert(message: "Enter the empty qty");
          }
        }

        var alert = await sameWarpStatusCheck(qty, entryType, warpType);
        if (alert == "Completed") {
          return AppUtils.infoAlert(
              message:
                  "Already completed account is available, so you can't drop out of this warp.");
        }

        request["warp_design_id"] = warpDropWarpDesign.value?.warpDesignId;
        request["warp_design"] = warpDropWarpDesign.value?.warpName;
        request["warp_id"] = warpDropWarpIdNo.text.toUpperCase();
        request["warp_qty"] = qty;
        request["meter"] = meter;
        request["warp_type"] = warpDropWarpType.text;
        request["sht_in"] = int.tryParse(warpDropSheet.text) ?? 0;
        request["product_details"] = warpDropDetails.text;
        if (warpType == "Other") {
          request["other_warpid"] = warpDropWarpDesign.value?.warpId;
        }
        var emptyType = warpDropEmptyType.text;
        if (emptyType == "Beam") {
          request["bm_in"] = emptyQty;
        } else {
          request["bbn_in"] = emptyQty;
        }
        transferItemRemove(entryType, warpDropWarpDesign.value?.warpDesignId);
        dataSourcesUpdate(request, entryType, warpTypr: warpType);
      }
    }
  }

  /// after data is submit
  /// weaving page data table refresh
  void dataSourcesUpdate(Map<String, dynamic> request, String entryType,
      {var warpTypr}) {
    controller.itemList.add(request);
    widget.weavingDataSource.updateDataGridRows();
    widget.weavingDataSource.updateDataGridSource();
    widget.weavingDataGridController.scrollToRow(
      position: DataGridScrollPosition.end,
      widget.weavingDataSource.rows.length - 1,
    );

    widget.itemTableCalculation();

    // controller clear methode
    controllersClear();

    if (entryType == "Yarn Delivery" ||
        entryType == "Rtrn-Yarn" ||
        entryType == "Yarn Wastage" ||
        entryType == "O.Bal - Yarn" ||
        entryType == "Trsfr - Yarn") {
      weaverYarnStockApiCall();
    }

    if (entryType == "Warp Delivery" ||
        entryType == "Warp Excess" ||
        entryType == "Warp Shortage" ||
        entryType == "Warp-Dropout" ||
        entryType == "Trsfr - Warp" ||
        entryType == "O.Bal - Warp") {
      weaverOtherWarpApiCall(warpTypr);
    }
  }

  /// transfer entry types loom status API call
  /// current warp status is removed
  warpStatusApiCall(var loomId) async {
    var weaverId = controller.weaverId;
    var weavingAcId = controller.request['weaving_ac_id'];
    var weavNo = controller.request["remove_weve_no"];

    List<WeaverByLoomStatusModel> data =
        await controller.transferLoomStatus(weaverId, loomId, weavingAcId);

    data = data
      ..removeWhere((element) =>
          "${element.weaveNo}" == "$weavNo" &&
          "${element.currentStatus}" == "Completed");

    var index = data.indexWhere((e) => e.currentStatus == 'Running');
    initWarpStatus(index: index != -1 ? index : 0);
  }

  void initWarpStatus({var index = 0}) async {
    if (controller.loomStatus.isNotEmpty) {
      var item = controller.loomStatus[index];

      /// transfer Amount
      transferAmountStatus.value = item;
      transferAmountWeavNo.text = "${item.weaveNo}";

      /// transfer Cops Reel
      transferCopsReelsStatus.value = item;
      transferCopsReelsWeavNo.text = "${item.weaveNo}";

      /// transfer Empty
      transferEmptyStatus.value = item;
      transferEmptyWeavNo.text = "${item.weaveNo}";

      /// transfer Warp
      transferWarpStatus.value = item;
      transferWarpWeavNo.text = "${item.weaveNo}";

      /// transfer Yarn
      transferYarnStatus.value = item;
      transferYarnWeavNo.text = "${item.weaveNo}";
    }
  }

  Future<void> warpDropoutValueInit(WarpExcessModel item) async {
    var details =
        '${controller.request["weaver_name"]}, Loom No ${controller.request['loom_id']}';

    warpDropWarpType.text = "${item.warpType}";
    if (item.warpType == "Main Warp") {
      warpDropProductQty.text = "${item.balanceQty}";
      warpDropMetre.text = "0.000";
    } else {
      warpDropMetre.text = item.balanceMeter!.toStringAsFixed(3);
      warpDropProductQty.text = "0";
    }
    warpDropEmptyType.text = "${item.emptyType}";
    warpDropEmptyQty.text = "${item.emptyQty}";
    warpDropSheet.text = "${item.sheet}";
    warpDropDetails.text = "$details, ${item.warpColor}";
    warpDropRunningWarpId.text = item.warpId ?? "";

    var warpId = controller.itemList
        .where((e) => e['sync'] == 0 && e['entry_type'] == 'Warp-Dropout')
        .toList();
    if (warpId.isNotEmpty) {
      String id = warpId.last["warp_id"];

      final split = id.split('-');
      if (split.isNotEmpty) {
        var number = int.parse(split.last);
        warpDropWarpIdNo.text = '${split.first}-${number + 1}';
        warpDropOldWarpIdNo.value.text = '${split.first}-$number';
      }
    } else {
      NewWarpIdDetailsModel? data = await controller.newWarpIdForWarpDropout();

      warpDropWarpIdNo.text = "${data?.newWarpId}";
      warpDropOldWarpIdNo.value.text = "${data?.lastWarpId}";
    }
  }

  void warpShortAgeValueInit(WarpExcessModel item) {
    warpShortageWarpQty.text = "0";
    warpShortageWarpMeter.text = "0.000";
    warpShortageWarpType.text = '${item.warpType}';
    warpShortageWarpId.text = item.warpId ?? "";
    if (item.warpType == "Other") {
      warpShortageBalanceMeter.text = item.balanceMeter!.toStringAsFixed(3);
      warpShortageBalanceQty.text = "0";
    } else {
      warpShortageBalanceQty.text = '${item.balanceQty}';
      warpShortageBalanceMeter.text = "0.000";
    }
  }

  void warpExcessValueInit(WarpExcessModel item) {
    warpExcessWarpQty.text = "0";
    warpExcessWarpMeter.text = "0.00";
    warpExcessWarpType.text = '${item.warpType}';
    warpExcessWarpId.text = item.warpId ?? "";
    if (item.warpType == "Other") {
      warpExcessBalanceMeter.text = item.balanceMeter!.toStringAsFixed(3);
      warpExcessBalanceQty.text = "0";
    } else {
      warpExcessBalanceQty.text = '${item.balanceQty}';
      warpExcessBalanceMeter.text = '0.000';
    }
  }

  void transferWarpDetails(WeavingOtherWarpBalanceModel item) {
    transferWarpWarpType.text = '${item.warpType}';
    transferWarpBalanceMeter.text = item.balanceMeter!.toStringAsFixed(3);
    transferWarpWarpId.text = item.otherWarpId ?? "";
  }

  yarnDeliveryCalculation() {
    double grossQuantity = double.tryParse(yarnDeliveryGrossQty.text) ?? 0.0;
    double nos = double.tryParse(yarnDeliveryNos.text) ?? 0.0;
    double weight = double.tryParse(yarnDeliveryWeight.text) ?? 0.0;
    var less = (nos * weight) / 1000;
    yarnDeliveryLess.text = less.toStringAsFixed(3);

    var netQty = grossQuantity - less;
    yarnDeliveryNetQuantity.text = netQty.toStringAsFixed(3);
  }

  returnYarnCalculation() {
    double grossQuantity = double.tryParse(returnYarnGrossQty.text) ?? 0.0;
    double nos = double.tryParse(returnYarnNos.text) ?? 0.0;
    double weight = double.tryParse(returnYarnWeight.text) ?? 0.0;
    var less = (nos * weight) / 1000;
    returnYarnLess.text = less.toStringAsFixed(3);

    var netQty = grossQuantity - less;
    returnYarnNetQty.text = netQty.toStringAsFixed(3);
  }

  Future<void> yarnStockBalanceCheck() async {
    var stockIn = yarnDeliveryDeliveryFrom.text;
    var yarnId = yarnDeliveryYarnName.value?.id;
    var colorId = yarnDeliveryColorName.value?.id;
    double deliveryQty = 0.0;

    var data = await controller.yarnStockBalance(yarnId, colorId, stockIn);

    double stockQty = double.tryParse("${data?.balanceQty}") ?? 0.0;
    var ll = controller.itemList
        .where((e) => e['yarn_id'] == yarnId && e['yarn_color_id'] == colorId)
        .toList();
    for (var element in ll) {
      deliveryQty += element['yarn_qty'];
    }
    var formatter = NumberFormat('#,##,000.000');
    stockBalanceController.text = formatter.format((stockQty - deliveryQty));
  }

  sameWarpStatusCheck(int productQty, String entryType, String warpType) {
    /// Check the selected weaver, loom, warp status, and inward quantity
    /// to verify if the same warp status is already available

    if (warpType == "Other") {
      return;
    }

    int inwardQty = 0;
    int deliveryQty = 0;

    for (var e in controller.itemList) {
      var entryType = e['entry_type'];

      /// Product Qty Calculation
      if (entryType == 'Warp Delivery' || entryType == "Warp Excess") {
        if (e["warp_type"] != "Other") {
          deliveryQty += int.tryParse("${e['warp_qty']}") ?? 0;
        }
      } else if (entryType == "Warp Shortage" || entryType == "Warp-Dropout") {
        if (e["warp_type"] != "Other") {
          deliveryQty -= int.tryParse("${e['warp_qty']}") ?? 0;
        }
      } else {
        inwardQty += int.tryParse("${e['inward_qty']}") ?? 0;
      }
    }

    var currentStatus = controller.request["current_status"];
    int balanceQty = deliveryQty - (inwardQty + productQty);

    if (entryType == "Warp-Dropout" ||
        entryType == "Warp Shortage" && currentStatus == "Running") {
      if (balanceQty == 0) {
        var result = controller.weavingAccountList
            .where((element) => "${element.currentStatus}" == "Completed");

        if (result.isNotEmpty) {
          return "Completed";
        }
      }
    }

    if (entryType == "Warp Excess" && currentStatus == "Completed") {
      var result = controller.weavingAccountList
          .where((element) => "${element.currentStatus}" == "Running");

      if (result.isNotEmpty) {
        return "Running";
      }
    }
  }

  /// after submit button is pressed
  /// clear the controller details and focus the date field

  controllersClear() {
    _selectedEntryType.value = null;

    // Good inward controllers
    goodsInwardProduct.value = null;
    goodsInwardDesignNo.text = "";
    goodsInwardInwardQty.text = "";
    goodsInwardMeterInWard.text = "";
    goodsInwardWages.text = "";
    goodsInwardAmount.text = "";
    goodsInwardDamaged.text = "No";
    goodsInwardDetails.text = "";
    goodsInwardPending.text = "No";
    goodsInwardPendingQty.text = "";
    goodsInwardPendingMeter.text = "";

    // Warp delivery controllers
    warpDeliveryWarpDesignController.value = null;
    warpDeliveryWarpIdNo.value = null;
    warpDeliveryWarpType.text = "";
    warpDeliveryProductQyt.text = "";
    warpDeliveryMeter.text = "";
    warpDeliveryEmptyType.text = "Beam";
    warpDeliveryEmptyQyt.text = "Nothing";
    warpDeliverySheet.text = "";
    warpDeliveryDetails.text = "";
    warpDeliveryWarpColor.text = "";

    // Yarn delivery controllers
    yarnDeliveryYarnName.value = null;
    stockBalanceController.text = "0";
    yarnDeliveryDeliveryFrom.text = "Office";
    yarnDeliveryBoxNo.text = "";
    yarnDeliveryPack.text = "0";
    yarnDeliveryNos.text = "0";
    yarnDeliveryGrossQty.text = "0.00";
    yarnDeliveryLess.text = "0.00";
    yarnDeliveryWeight.text = "0";
    yarnDeliveryDetails.text = "";
    yarnDeliveryNetQuantity.text = "0";

    // Empty in out controllers
    emptyInOutBeamIn.text = "0";
    emptyInOutBeamOut.text = "0";
    emptyInOutBobbinIn.text = "0";
    emptyInOutBobbinOut.text = "0";
    emptyInOutSheetIn.text = "0";
    emptyInOutSheetOut.text = "0";
    emptyInOutDetails.text = "";

    // Payment controllers
    paymentTo.value = null;
    paymentAmount.text = "";
    paymentType.text = "Wages";
    paymentDetail.text = "";

    // Receipt controllers
    receiptBy.value = null;
    receiptAmounts.text = "";
    receiptDetail.text = "";

    // Return Yarn controllers
    returnYarnYarnName.value = null;
    returnYarnStockTo.text = "Office";
    returnYarnBoxNo.text = "";
    returnYarnPack.text = "0";
    returnYarnNos.text = "0";
    returnYarnGrossQty.text = "0.00";
    returnYarnLess.text = "0.00";
    returnYarnWeight.text = "0";
    returnYarnDetails.text = "";
    returnYarnNetQty.text = "0";

    // credit controllers
    creditBy.value = null;
    creditAmountRs.text = "";
    creditDetails.text = "";

    // Debit controllers
    debitBy.value = null;
    debitAmountRs.text = "";
    debitDetails.text = "";

    // Yarn wastage controllers
    yarnWastageYarn.value = null;
    yarnWastageWeaver.text = "";
    yarnWastageQuantity.text = "";
    yarnWastageDetails.text = "";

    // Warp Excess controllers
    warpExcessWarpDesign.value = null;
    warpExcessWarpType.text = "";
    warpExcessBalanceQty.text = "";
    warpExcessBalanceMeter.text = "";
    warpExcessWarpQty.text = "0";
    warpExcessWarpMeter.text = "0";
    warpExcessDetails.text = "";
    warpExcessWarpId.text = "";

    // Warp Shortage controllers
    warpShortageWarpDesign.value = null;
    warpShortageWarpType.text = "";
    warpShortageBalanceQty.text = "";
    warpShortageBalanceMeter.text = "";
    warpShortageWarpQty.text = "";
    warpShortageWarpMeter.text = "";
    warpShortageDetails.text = "";
    warpShortageWarpId.text = "";

    // Message controllers
    messageLanguage.text = "English";
    messageMsgType.text = "Normal";
    messageMsg.text = "";

    // Transfer amount controllers
    transferAmountDebit.text = "";
    transferAmountCredit.text = "";
    transferAmountWeavNo.text = "";
    transferAmountStatus.value = null;
    transferAmountTo.value = null;

    // Transfer empty controllers
    transferEmptyBeam.text = "0";
    transferEmptyBobbin.text = "0";
    transferEmptySheet.text = "0";
    transferEmptyBeamIn.text = "0";
    transferEmptyBeamOut.text = "0";
    transferEmptyBobbinIn.text = "0";
    transferEmptyBobbinOut.text = "0";
    transferEmptySheetIn.text = "0";
    transferEmptySheetOut.text = "0";
    transferEmptyTo.value = null;
    transferEmptyStatus.value = null;
    transferEmptyWeavNo.text = "";

    // Transfer copes reel controllers
    transferCopsReelsCops.text = "";
    transferCopsReelsReel.text = "";
    transferCopsReelsTo.value = null;
    transferCopsReelsStatus.value = null;
    transferCopsReelsWeavNo.text = "";

    // Transfer warp controllers
    transferWarpWarpDesign.value = null;
    transferWarpTo.value = null;
    transferWarpStatus.value = null;
    transferWarpWarpType.text = "";
    transferWarpBalanceMeter.text = "";
    transferWarpWeavNo.text = "";
    transferWarpWarpId.text = "";

    // Transfer yarn controllers
    transferYarnYarnName.value = null;
    transferYarnTo.value = null;
    transferYarnStatus.value = null;
    transferYarnWeaverStockQty.text = "";
    transferYarnWeavNo.text = "";

    // Opening balance amount controllers
    openBalAmountDebit.text = "0";
    openBalAmountCredit.text = "0";
    openBalAmountDetails.text = "";

    // Opening balance warp controllers
    openBalWarpDesign.value = null;
    openBalWarpType.text = "";
    openBalWarpMetre.text = "0";
    openBalWarpEmptyType.text = "Nothing";
    openBalWarpEmptyQty.text = "0";
    openBalWarpSheet.text = "0";
    openBalWarpDetails.text = "";

    // Opening balance yarn controllers
    openBalYarnYarnName.value = null;
    openBalYarnPack.text = "0";
    openBalYarnQty.text = "0";
    openBalYarnDetails.text = "";

    // Opening balance empty controllers
    openBalBeamIn.text = "0";
    openBalBeamOut.text = "0";
    openBalBobbinIn.text = "0";
    openBalBobbinOut.text = "0";
    openBalSheetIn.text = "0";
    openBalSheetOut.text = "0";
    openBalDetails.text = "";

    // Opening balance copes reel controllers
    openBalCopRelCopType.text = "Nothing";
    openBalCopRelCopIn.text = "0";
    openBalCopRelCopOut.text = "0";
    openBalCopRelRelType.text = "Nothing";
    openBalCopRelRelIn.text = "0";
    openBalCopRelRelOut.text = "0";
    openBalCopRelConeType.text = "Nothing";
    openBalCopRelConeIn.text = "0";
    openBalCopRelConeOut.text = "0";
    openBalCopRelDetails.text = "";

    // Adjustment wt controllers
    adjustmentWtReceivedWight.text = "";
    adjustmentWtDeliveryWeight.text = "";
    adjustmentWtDetails.text = "";

    // warp dropout controllers
    warpDropWarpDesign.value = null;
    warpDropWarpType.text = "";
    warpDropWarpIdNo.text = "";
    warpDropOldWarpIdNo.value.text = "";
    warpDropProductQty.text = "0";
    warpDropMetre.text = "0";
    warpDropEmptyType.text = "Nothing";
    warpDropEmptyQty.text = "0";
    warpDropSheet.text = "0";
    warpDropDetails.text = "";
    warpDropRunningWarpId.text = "";

    /// focus transfer to date field
    FocusScope.of(context).requestFocus(_dateFocusNode);
  }

  void transferItemRemove(String entryType, int? id) {
    if (entryType == "Trsfr - Yarn") {
      widget.transferDetails.removeWhere((element) => element["yarn_id"] == id);
    } else if (entryType == "Trsfr - Amount") {
      widget.transferDetails
          .removeWhere((element) => element["entry_type"] == "Trsfr - Amount");
    } else if (entryType == "Trsfr - Empty") {
      widget.transferDetails
          .removeWhere((element) => element["entry_type"] == "Trsfr - Empty");
    } else {
      widget.transferDetails
          .removeWhere((element) => element["warp_design_id"] == id);
    }

    widget.transferDataSource.updateDataGridRows();
    widget.transferDataSource.updateDataGridSource();
  }

  transferTableYarnDetailsAdd(String entryType, double yarnQty, int? yarnId) {
    // add a locally added details in transfer details table

    if (entryType == "Yarn Delivery" || entryType == "O.Bal - Yarn") {
      for (int i = 0; i < widget.transferDetails.length; i++) {
        var list = widget.transferDetails[i];

        if (list["yarn_id"] == yarnId) {
          double qty = list["yarn_qty"] + yarnQty;

          list["yarn_qty"] = qty;
        }
      }
    } else if (entryType == "Rtrn-Yarn" || entryType == "Yarn Wastage") {
      for (int i = 0; i < widget.transferDetails.length; i++) {
        var list = widget.transferDetails[i];

        if (list["yarn_id"] == yarnId) {
          double qty = list["yarn_qty"] - yarnQty;

          list["yarn_qty"] = qty;
        }
      }
    }
    widget.transferDataSource.updateDataGridRows();
    widget.transferDataSource.updateDataGridSource();
  }

  transferTableAmountDetailsAdd(String entryType, double credit, debit) {
    // add a locally added details in transfer details table

    if (entryType == "Goods Inward" ||
        entryType == "Credit" ||
        entryType == "O.Bal - Amount") {
      double amount = 0.0;

      for (int i = 0; i < widget.transferDetails.length; i++) {
        var list = widget.transferDetails[i];

        if (credit != 0) {
          amount = (double.tryParse("${list["details"]}") ?? 0.0) + credit;
        } else {
          amount = (double.tryParse("${list["details"]}") ?? 0.0) - debit;
        }
        if (list["entry_type"] == "Trsfr - Amount") {
          widget.transferDetails[i]["details"] = amount;
        }
      }
    } else if (entryType == "Payment" || entryType == "Debit") {
      double amount = 0.0;

      for (int i = 0; i < widget.transferDetails.length; i++) {
        var list = widget.transferDetails[i];

        if (credit != 0) {
          amount = (double.tryParse("${list["details"]}") ?? 0.0) + credit;
        } else {
          amount = (double.tryParse("${list["details"]}") ?? 0.0) - debit;
        }
        if (list["entry_type"] == "Trsfr - Amount") {
          widget.transferDetails[i]["details"] = amount;
        }
      }
    }

    widget.transferDataSource.updateDataGridRows();
    widget.transferDataSource.updateDataGridSource();
  }

  transferTableWarpDetailsAdd(
      String entryType, warpType, int? warpDesignId, double warpMeter) {
    if (entryType == "Warp Delivery" ||
        entryType == "Warp Excess" ||
        entryType == "O.Bal - Warp") {
      double meter = 0.0;

      for (int i = 0; i < widget.transferDetails.length; i++) {
        var list = widget.transferDetails[i];

        if (list["warp_design_id"] == warpDesignId) {
          if (warpType == "Other") {
            meter =
                (double.tryParse("${list["warp_meter"]}") ?? 0.0) + warpMeter;

            widget.transferDetails[i]["warp_meter"] = meter;
          }
        }
      }
    } else if (entryType == "Warp Shortage") {
      double meter = 0.0;
      for (int i = 0; i < widget.transferDetails.length; i++) {
        var list = widget.transferDetails[i];

        if (list["warp_design_id"] == warpDesignId) {
          if (warpType == "Other") {
            meter =
                (double.tryParse("${list["warp_meter"]}") ?? 0.0) - warpMeter;

            widget.transferDetails[i]["warp_meter"] = meter;
          }
        }
      }
    }

    widget.transferDataSource.updateDataGridRows();
    widget.transferDataSource.updateDataGridSource();
  }
}

class WeaverYarnStockDataSource extends DataGridSource {
  WeaverYarnStockDataSource({required List<WeftBalance> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<WeftBalance> _list;
  var today = "${DateTime.now()}".substring(0, 10);

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var wevYarn = e.wevStock;
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e.yarnName),
        DataGridCell<dynamic>(
            columnName: 'weaver_stock', value: wevYarn?.toStringAsFixed(3)),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color? weaverStockText;
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      TextStyle? getTextStyle() {
        if (e.columnName == "weaver_stock") {
          return TextStyle(
            color: weaverStockText ?? Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.visible,
          );
        } else {
          return const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.visible,
          );
        }
      }

      if (e.columnName == "weaver_stock") {
        double data = double.tryParse("${e.value}") ?? 0.0;

        if (data < 0) {
          weaverStockText = Colors.red;
        }
      }

      return Container(
        padding: const EdgeInsets.all(8),
        alignment: e.columnName == "weaver_stock"
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Text(
          e.value != null ? '${e.value}' : ' ',
          style: getTextStyle(),
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

class WeaverOtherWarpDataSource extends DataGridSource {
  WeaverOtherWarpDataSource({required List<OtherWarpBalanceModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<OtherWarpBalanceModel> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var stock = e.weaverStock;

      return DataGridRow(cells: [
        DataGridCell<dynamic>(
            columnName: 'warp_design_name', value: e.warpDesignName),
        DataGridCell<dynamic>(
            columnName: 'weaver_stock', value: stock?.toStringAsFixed(3)),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color? weaverStockText;

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      TextStyle? getTextStyle() {
        if (e.columnName == "weaver_stock") {
          return TextStyle(
            color: weaverStockText ?? Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.visible,
          );
        } else {
          return const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.visible,
          );
        }
      }

      return Container(
        padding: const EdgeInsets.all(8),
        alignment: e.columnName == "weaver_stock"
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Text(
          e.value != null ? '${e.value}' : '',
          style: getTextStyle(),
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
