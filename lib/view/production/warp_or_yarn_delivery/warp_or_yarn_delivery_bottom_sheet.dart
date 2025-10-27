import 'package:abtxt/model/LoomGroup.dart';
import 'package:abtxt/model/NewWarpModel.dart';
import 'package:abtxt/model/weaving_models/WeaverCurrentProductModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/utils/constant.dart';
import 'package:abtxt/view/basics/productinfo/add_product_info.dart';
import 'package:abtxt/view/production/warp_or_yarn_delivery/warp_or_yarn_delivery_controller.dart';
import 'package:abtxt/widgets/my_autocompletes/loom_autocomplete.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/NewColorModel.dart';
import '../../../model/WarpType.dart';
import '../../../model/YarnModel.dart';
import '../../../model/weaving_models/WeaverByLoomStatusModel.dart';
import '../../../model/weaving_models/WeavingWarpDeliveryModel.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/my_autocompletes/eaving_warp_id_AutoComplete.dart';
import '../../../widgets/searchfield/decoration.dart';
import '../../../widgets/searchfield/searchfield.dart';
import '../../basics/new_color/add_new_color.dart';
import '../warp_tracking/warp_tracking.dart';
import '../weaving/add_weaving.dart';

class WarpOrYarnDeliveryProductionBottomSheet extends StatefulWidget {
  const WarpOrYarnDeliveryProductionBottomSheet({super.key});

  static const String routeName =
      '/Warp_or_Yarn_Delivery_Production_bottom_sheet';

  @override
  State<WarpOrYarnDeliveryProductionBottomSheet> createState() => _State();
}

class _State extends State<WarpOrYarnDeliveryProductionBottomSheet> {
  /// Default Controllers
  TextEditingController entryTypeController =
      TextEditingController(text: "Yarn Delivery");
  Rxn<WeaverByLoomStatusModel> warpStatusController =
      Rxn<WeaverByLoomStatusModel>();
  Rxn<LoomGroup> loomNoController = Rxn<LoomGroup>();
  final _selectedEntryType = Constants.ENTRY_TYPES_PRODUCTION[0].obs;
  final _formKey = GlobalKey<FormState>();
  WarpOrYarnDeliveryController controller = Get.find();
  final FocusNode _submitButtonFocusNode = FocusNode();

  /// Yarn Delivery Controllers
  Rxn<YarnModel> yarnDeliveryYarnName = Rxn<YarnModel>();
  Rxn<NewColorModel> yarnDeliveryColorName = Rxn<NewColorModel>();
  TextEditingController stockBalanceController =
      TextEditingController(text: "0");
  TextEditingController yarnDeliveryDeliveryFrom =
      TextEditingController(text: "Office");
  TextEditingController yarnDeliveryBoxNo = TextEditingController();
  TextEditingController yarnDeliveryPack = TextEditingController(text: '0');
  TextEditingController yarnDeliveryNos = TextEditingController(text: '0');
  TextEditingController yarnDeliveryGrossQty =
      TextEditingController(text: '0.000');
  TextEditingController yarnDeliveryLess = TextEditingController(text: '0.000');
  TextEditingController yarnDeliveryWeight = TextEditingController(text: '0');
  TextEditingController yarnDeliveryDetails = TextEditingController();
  TextEditingController yarnDeliveryNetQty = TextEditingController(text: '0');

  /// Return - Yarn Controllers
  Rxn<YarnModel> returnYarnYarnName = Rxn<YarnModel>();
  Rxn<NewColorModel> returnYarnColourName = Rxn<NewColorModel>();
  TextEditingController returnYarnStockIn =
      TextEditingController(text: "Office");
  TextEditingController returnYarnBoxNo = TextEditingController();
  TextEditingController returnYarnPack = TextEditingController(text: '0');
  TextEditingController returnYarnNos = TextEditingController(text: '0');
  TextEditingController returnYarnGrossQty =
      TextEditingController(text: '0.000');
  TextEditingController returnYarnLess = TextEditingController(text: '0.000');
  TextEditingController returnYarnWeight = TextEditingController(text: '0');
  TextEditingController returnYarnDetails = TextEditingController();
  TextEditingController returnYarnNetQty = TextEditingController(text: '0');

  /// Warp Delivery Controllers
  Rxn<WarpType> warpDeliveryWarpDesignController = Rxn<WarpType>();
  TextEditingController warpDeliveryWarpType = TextEditingController();
  Rxn<WeavingWarpDeliveryModel> warpDeliveryWarpIdNo =
      Rxn<WeavingWarpDeliveryModel>();
  TextEditingController warpDeliveryWarpIdController = TextEditingController();
  TextEditingController warpDeliveryProductQyt = TextEditingController();
  TextEditingController warpDeliveryMeter = TextEditingController();
  TextEditingController warpDeliveryEmptyType =
      TextEditingController(text: 'Nothing');
  TextEditingController warpDeliveryEmptyQyt = TextEditingController(text: "0");
  TextEditingController warpDeliverySheet = TextEditingController(text: "0");
  TextEditingController warpDeliveryDetails = TextEditingController();
  TextEditingController warpDeliveryWarpColor = TextEditingController();
  final FocusNode _warpDesignFocusNode = FocusNode();
  final FocusNode _warpIdFocusNode = FocusNode();
  final FocusNode _productQtyFocusNode = FocusNode();

  /// Empty - (In / Out) Controllers
  TextEditingController emptyInOutBeamIn = TextEditingController(text: '0');
  TextEditingController emptyInOutBeamOut = TextEditingController(text: '0');
  TextEditingController emptyInOutBobbinIn = TextEditingController(text: '0');
  TextEditingController emptyInOutBobbinOut = TextEditingController(text: '0');
  TextEditingController emptyInOutSheetIn = TextEditingController(text: '0');
  TextEditingController emptyInOutSheetOut = TextEditingController(text: '0');
  TextEditingController emptyInOutDetails = TextEditingController();
  TextEditingController emptyInOutBeamInDesignText = TextEditingController();
  TextEditingController emptyInOutBobbinInDesignText = TextEditingController();
  Rxn<NewWarpModel> emptyInOutBeamInDesign = Rxn<NewWarpModel>();
  Rxn<NewWarpModel> emptyInOutBobbinInDesign = Rxn<NewWarpModel>();
  final FocusNode _beamInDesignFocusNode = FocusNode();
  final FocusNode _bobbinInDesignFocusNode = FocusNode();
  final FocusNode _bobbinInFocusNode = FocusNode();
  final FocusNode _sheetInFocusNode = FocusNode();

  RxString otherWarp = RxString("");

  /// Inward Cops and Reels Controllers
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

  final FocusNode _warpStatusFocusNode = FocusNode();
  final FocusNode _colorNameFocusNode = FocusNode();
  final FocusNode _yarnDeliveryNetQtyFocusNode = FocusNode();
  final FocusNode _yarnDeliveryGrossQtyFocusNode = FocusNode();
  final FocusNode _returnYarnGrossQtyFocusNode = FocusNode();

  var shortCut = RxString("");
  RxString productName = RxString("");

  var weaverYarnStockDetails = <dynamic>[];
  List<WeaverCurrentProductModel> weaverWarpStockDetails =
      <WeaverCurrentProductModel>[];
  late ItemDataSource dataSource;
  late WarpStockDataSource warpStockDataSource;

  @override
  void initState() {
    controller.warpStatus.clear();
    _warpStatusFocusNode.addListener(() => shortCutKeys());
    _colorNameFocusNode.addListener(() => shortCutKeys());
    _warpDesignFocusNode.addListener(() => shortCutKeys());
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: weaverYarnStockDetails);
    warpStockDataSource = WarpStockDataSource(list: weaverWarpStockDetails);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpOrYarnDeliveryController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: const Text('Weaving...'),
          actions: [
            Tooltip(
              message: "Warp tracking (Ctrl+t)",
              child: TextButton(
                onPressed: () => warpTracking(),
                child: const Text('WARP TRACKING'),
              ),
            ),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
          SingleActivator(LogicalKeyboardKey.keyT, control: true):
              NavigateAnotherPageIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            NavigateIntent: SetCounterAction(perform: () {
              navigateAnotherPage();
            }),
            NavigateAnotherPageIntent:
                SetCounterAction(perform: () => warpTracking()),
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                MyLoomAutoComplete(
                                  label: 'Loom',
                                  items: controller.loomList,
                                  forceNextFocus: true,
                                  selectedItem: loomNoController.value,
                                  onChanged: (LoomGroup item) async {
                                    loomNoController.value = item;
                                    yarnDeliveryControllers();
                                    warpDeliverControllers();
                                    emptyInOutControllers();
                                    returnYarnController();
                                    productDetailsApiCall();

                                    warpStatusApiCall();
                                  },
                                ),
                                Focus(
                                  focusNode: _warpStatusFocusNode,
                                  skipTraversal: true,
                                  autofocus: false,
                                  child: MyAutoComplete(
                                    label: 'Warp Status',
                                    items: controller.warpStatus,
                                    selectedItem: warpStatusController.value,
                                    onChanged:
                                        (WeaverByLoomStatusModel item) async {
                                      warpStatusController.value = item;
                                      productName.value = item.productName!;
                                      _apiCals();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                MyDropdownButtonFormField(
                                  controller: entryTypeController,
                                  hintText: "Entry Type",
                                  items: Constants.ENTRY_TYPES_PRODUCTION,
                                  onChanged: (value) {
                                    _selectedEntryType.value = value;

                                    if (value == "Empty - (In / Out)") {
                                      runningWarpDetails();
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: 240,
                                  child: Text(
                                    productName.value,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.red,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Obx(() => updateWidget(_selectedEntryType.value)),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => Text(shortCut.value,
                                      style: AppUtils.shortCutTextStyle()),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  child: MyAddButton(
                                    focusNode: _submitButtonFocusNode,
                                    onPressed: () => submit(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    ExcludeFocus(
                        child: Flexible(
                            flex: 1,
                            child: Column(
                              children: [
                                weaverYarnStock(),
                                const SizedBox(height: 12),
                                weaverWarpStock(),
                              ],
                            ))),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget updateWidget(String option) {
    return GetBuilder<WarpOrYarnDeliveryController>(builder: (controller) {
      if (option == 'Yarn Delivery') {
        return Wrap(
          children: [
            MyAutoComplete(
              label: 'Yarn Name',
              items: controller.Yarn,
              selectedItem: yarnDeliveryYarnName.value,
              onChanged: (YarnModel item) async {
                yarnDeliveryYarnName.value = item;
                yarnStockBalanceCheck();
                _yarnDeliveryGrossQtyFocusNode.requestFocus();
              },
            ),
            Focus(
              skipTraversal: true,
              focusNode: _colorNameFocusNode,
              autofocus: false,
              child: MyAutoComplete(
                label: 'Color Name',
                items: controller.Color,
                selectedItem: yarnDeliveryColorName.value,
                onChanged: (NewColorModel item) async {
                  yarnDeliveryColorName.value = item;
                  yarnStockBalanceCheck();
                },
              ),
            ),
            Row(
              children: [
                MyDropdownButtonFormField(
                  controller: yarnDeliveryDeliveryFrom,
                  hintText: "Delivery From",
                  items: const ["Office", "Godown"],
                  onChanged: (value) async {
                    yarnStockBalanceCheck();
                  },
                ),
                MyTextField(
                  controller: yarnDeliveryBoxNo,
                  hintText: 'Box No',
                ),
              ],
            ),
            Row(
              children: [
                MyTextField(
                  controller: yarnDeliveryPack,
                  hintText: 'Pack',
                  validate: "number",
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
                  //  weaverYarnStockApiCall();
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
                      //  weaverYarnStockApiCall();
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
                      //  weaverYarnStockApiCall();
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
            Row(
              children: [
                MyTextField(
                  controller: yarnDeliveryDetails,
                  hintText: 'Details',
                ),
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    enabled: false,
                    controller: yarnDeliveryNetQty,
                    hintText: 'Net.Qty',
                    focusNode: _yarnDeliveryNetQtyFocusNode,
                    validate: 'double',
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(
                      yarnDeliveryNetQty,
                    );
                  },
                ),
              ],
            ),
          ],
        );
      } else if (option == 'Rtrn-Yarn') {
        return Wrap(
          children: [
            MyAutoComplete(
              label: 'Yarn Name',
              items: controller.Yarn,
              selectedItem: returnYarnYarnName.value,
              onChanged: (YarnModel item) async {
                returnYarnYarnName.value = item;
                _returnYarnGrossQtyFocusNode.requestFocus();
              },
            ),
            Focus(
              focusNode: _colorNameFocusNode,
              skipTraversal: true,
              autofocus: false,
              child: MyAutoComplete(
                label: 'Color Name',
                items: controller.Color,
                selectedItem: returnYarnColourName.value,
                onChanged: (NewColorModel item) async {
                  returnYarnColourName.value = item;
                },
              ),
            ),
            Row(
              children: [
                MyDropdownButtonFormField(
                    controller: returnYarnStockIn,
                    hintText: "Stock to",
                    items: const ["Office", "Godown"]),
                MyTextField(
                  controller: returnYarnBoxNo,
                  hintText: 'Box No',
                ),
              ],
            ),
            MyTextField(
              controller: returnYarnPack,
              hintText: 'Pack',
              validate: "number",
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
                  //  weaverYarnStockApiCall();
                },
              ),
              onFocusChange: (hasFocus) {
                AppUtils.fractionDigitsText(
                  returnYarnGrossQty,
                );
              },
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
                      //  weaverYarnStockApiCall();
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
                      //  weaverYarnStockApiCall();
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
            Row(
              children: [
                MyTextField(
                  controller: returnYarnDetails,
                  hintText: 'Details',
                ),
                MyTextField(
                  enabled: false,
                  controller: returnYarnNetQty,
                  hintText: 'Net.Qty',
                ),
              ],
            ),
          ],
        );
      } else if (option == 'Empty - (In / Out)') {
        return SizedBox(
          child: Wrap(
            children: [
              Row(
                children: [
                  MyTextField(
                    width: 150,
                    controller: emptyInOutBeamIn,
                    hintText: 'Beam Inward',
                    validate: 'number',
                  ),
                  MyTextField(
                    width: 150,
                    controller: emptyInOutBeamOut,
                    hintText: 'Beam Delivery',
                    validate: 'number',
                  ),
                  ExcludeFocusTraversal(
                    child: MySearchField(
                      label: "Main warp",
                      items: controller.newWarpDropDown,
                      textController: emptyInOutBeamInDesignText,
                      focusNode: _beamInDesignFocusNode,
                      requestFocus: _bobbinInFocusNode,
                      isValidate: false,
                      onChanged: (NewWarpModel item) {
                        emptyInOutBeamInDesign.value = item;
                      },
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  MyTextField(
                    width: 150,
                    focusNode: _bobbinInFocusNode,
                    controller: emptyInOutBobbinIn,
                    hintText: 'Bobbin Inward',
                    validate: 'number',
                  ),
                  MyTextField(
                    width: 150,
                    controller: emptyInOutBobbinOut,
                    hintText: 'Bobbin Delivery',
                    validate: 'number',
                  ),
                  ExcludeFocusTraversal(
                    child: MySearchField(
                      label: "Other warp",
                      items: controller.newWarpDropDown,
                      textController: emptyInOutBobbinInDesignText,
                      focusNode: _bobbinInDesignFocusNode,
                      requestFocus: _sheetInFocusNode,
                      isValidate: false,
                      onChanged: (NewWarpModel item) {
                        emptyInOutBobbinInDesign.value = item;
                      },
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  MyTextField(
                    width: 150,
                    focusNode: _sheetInFocusNode,
                    controller: emptyInOutSheetIn,
                    hintText: 'Sheet Inward',
                    validate: 'number',
                  ),
                  MyTextField(
                    width: 150,
                    controller: emptyInOutSheetOut,
                    hintText: 'Sheet Delivery',
                    validate: 'number',
                  ),
                ],
              ),
              Row(
                children: [
                  MyTextField(
                    controller: emptyInOutDetails,
                    hintText: 'Details',
                  ),
                  Obx(
                    () => Text(
                      otherWarp.value,
                      style: const TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      } else if (option == 'Inward - Cops, Reel') {
        return SizedBox(
          child: Wrap(
            children: [
              Row(
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
              Row(
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
              Row(
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
      } else if (option == 'Warp Delivery') {
        return Wrap(
          children: [
            Focus(
              focusNode: _warpDesignFocusNode,
              skipTraversal: true,
              child: MyAutoComplete(
                forceNextFocus: true,
                label: 'Warp Design',
                items: controller.warpTypeList,
                selectedItem: warpDeliveryWarpDesignController.value,
                onChanged: (WarpType item) {
                  warpDeliveryWarpDesignController.value = item;
                  warpDeliveryWarpType.text = tryCast(item.wrapType);
                  warpDeliveryWarpIdNo.value = null;
                  warpDeliveryProductQyt.text = "0";
                  warpDeliveryMeter.text = "0";
                  warpDeliveryEmptyQyt.text = "0";
                  warpDeliverySheet.text = "0";
                  warpDeliveryDetails.text = "";
                  warpDeliveryWarpColor.text = "";
                  int warpDesignId = item.warpDesignId!;
                  int weaverId = controller.weaverId!;
                  int subWeaverNo = loomNoController.value!.looms.first.id!;

                  controller.warpDelivery(warpDesignId, weaverId, subWeaverNo);
                },
              ),
            ),
            MyTextField(
              controller: warpDeliveryWarpType,
              hintText: "Warp Type",
              readonly: true,
            ),
            Row(
              children: [
                WeavWarpIdDropDown(
                  label: 'Warp Id No',
                  items: controller.warpDetails,
                  selectedItem: warpDeliveryWarpIdNo.value,
                  isValidate: true,
                  onChanged: (WeavingWarpDeliveryModel item) async {
                    warpDeliveryWarpIdNo.value = item;
                    warpDeliveryWarpDetails(item);
                    FocusScope.of(context).requestFocus(_submitButtonFocusNode);
                  },
                ),
                MyTextField(
                  focusNode: _productQtyFocusNode,
                  controller: warpDeliveryProductQyt,
                  hintText: "Prod.Qty",
                  readonly: true,
                ),
              ],
            ),
            Row(
              children: [
                Focus(
                  skipTraversal: true,
                  child: MyTextField(
                    controller: warpDeliveryMeter,
                    hintText: "Meter",
                    readonly: true,
                  ),
                  onFocusChange: (hasFocus) {
                    AppUtils.fractionDigitsText(
                      warpDeliveryMeter,
                    );
                  },
                ),
                MyDropdownButtonFormField(
                  enabled: false,
                  controller: warpDeliveryEmptyType,
                  hintText: "Empty Type",
                  items: const ["Nothing", "Beam", "Bobbin"],
                ),
              ],
            ),
            Row(
              children: [
                MyTextField(
                  controller: warpDeliveryEmptyQyt,
                  hintText: "Empty Qty",
                  readonly: true,
                ),
                MyTextField(
                  controller: warpDeliverySheet,
                  hintText: "Sheet",
                  readonly: true,
                ),
              ],
            ),
            Row(
              children: [
                MyTextField(
                  controller: warpDeliveryWarpColor,
                  hintText: "Warp Colour",
                  readonly: true,
                ),
                MyTextField(
                    controller: warpDeliveryDetails, hintText: "Details"),
              ],
            )
          ],
        );
      } else {
        return Container();
      }
    });
  }

  shortCutKeys() {
    if (_warpStatusFocusNode.hasFocus) {
      shortCut.value = "To Create 'Weaving Page',Press Alt+C ";
    } else if (_colorNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'YD Colour',Press Alt+C ";
    } else if (_warpDesignFocusNode.hasFocus) {
      shortCut.value = "To Create 'Warp Design',Press Alt+C";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_warpStatusFocusNode.hasFocus) {
      var weaverId = controller.weaverId;
      var loomNo = loomNoController.value?.loomNo;

      var request = {"weaver_id": weaverId, "loom_no": loomNo};

      if (weaverId == null || loomNo == null) {
        return;
      }

      var result = await Get.toNamed(AddWeaving.routeName, arguments: request);
      if (result == null) {
        var id = controller.weaverId;
        controller.loomInfo(id);
        warpStatusApiCall();
        productDetailsApiCall();
      }
    } else if (_colorNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddNewColor.routeName);

      if (result == "success") {
        controller.ColorInfo();
      }
    } else if (_warpDesignFocusNode.hasFocus) {
      var productId = warpStatusController.value?.productId;
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

  submit() {
    if (_formKey.currentState!.validate()) {
      var entryType = _selectedEntryType.value.toString();
      Map<String, dynamic> request = {
        "entry_type": entryType,
        "loom": loomNoController.value?.loomNo,
        "current_status": warpStatusController.value?.currentStatus,
        "product_name": warpStatusController.value?.productName,
        "sync": 0,
        "e_date": "${DateTime.now()}".substring(0, 10),
      };
      if (entryType == "Rtrn-Yarn") {
        double yarnQty = double.tryParse(returnYarnNetQty.text) ?? 0.0;

        if (yarnQty == 0) {
          return _dialogFoeSubmit();
        }

        request["yarn_name"] = returnYarnYarnName.value?.name;
        request["yarn_id"] = returnYarnYarnName.value?.id;
        request["yarn_color_name"] = returnYarnColourName.value?.name;
        request["yarn_color_id"] = returnYarnColourName.value?.id;
        request["stock_in"] = returnYarnStockIn.text;
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
        Get.back(result: request);
      } else if (entryType == "Empty - (In / Out)") {
        if (loomNoController.value?.loomNo?.toLowerCase() == "vl") {
          return;
        }

        int bmIn = int.tryParse(emptyInOutBeamIn.text) ?? 0;
        int bmOut = int.tryParse(emptyInOutBeamOut.text) ?? 0;
        int bbnIn = int.tryParse(emptyInOutBobbinIn.text) ?? 0;
        int bbnOut = int.tryParse(emptyInOutBobbinOut.text) ?? 0;
        int shtIn = int.tryParse(emptyInOutSheetIn.text) ?? 0;
        int shtOut = int.tryParse(emptyInOutSheetOut.text) ?? 0;

        var list = [];
        if (bmIn > 0) {
          if (emptyInOutBeamInDesign.value == null) {
            return AppUtils.infoAlert(message: "Select the manin warp");
          }

          var req = Map.from(request);
          req['bm_in'] = bmIn;
          req['bm_out'] = 0;
          req['bbn_in'] = 0;
          req['bbn_out'] = 0;
          req['sht_in'] = 0;
          req['sht_out'] = 0;
          req["product_details"] = emptyInOutDetails.text;
          req["empty_warp_desing_id"] = emptyInOutBeamInDesign.value?.id;
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
          if (emptyInOutBobbinInDesign.value == null) {
            return AppUtils.infoAlert(message: "Select the Other warp");
          }

          var req = Map.from(request);
          req['bm_in'] = 0;
          req['bm_out'] = 0;
          req['bbn_in'] = bbnIn;
          req['bbn_out'] = 0;
          req['sht_in'] = 0;
          req['sht_out'] = 0;
          req["product_details"] = emptyInOutDetails.text;
          req["empty_warp_desing_id"] = emptyInOutBobbinInDesign.value?.id;
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
        Get.back(result: request);
      } else if (entryType == "Yarn Delivery") {
        double yarnQty = double.tryParse(yarnDeliveryNetQty.text) ?? 0.0;

        if (yarnQty == 0) {
          return _dialogFoeSubmit();
        }

        request["yarn_name"] = yarnDeliveryYarnName.value?.name;
        request["yarn_id"] = yarnDeliveryYarnName.value?.id;
        request["yarn_color_id"] = yarnDeliveryColorName.value?.id;
        request["yarn_color_name"] = yarnDeliveryColorName.value?.name;
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
        Get.back(result: request);
      } else if (entryType == "Warp Delivery") {
        if (loomNoController.value?.loomNo?.toLowerCase() == "vl") {
          return;
        }
        String warpType = warpDeliveryWarpType.text;
        if (warpType == "Main Warp") {
          int warpQty = int.tryParse(warpDeliveryProductQyt.text) ?? 0;

          if (warpQty == 0) {
            return AppUtils.infoAlert(message: "Warp qty is '0'");
          }

          if (controller.mainWarpDeliverStatus == true) {
            AppUtils.infoAlert(message: "Main Warp Already Delivered");
          } else {
            request["warp_design_name"] =
                warpDeliveryWarpDesignController.value?.wrapDesign;
            request["warp_design_id"] =
                warpDeliveryWarpDesignController.value?.warpDesignId;
            request["warp_type"] = warpType;
            request["warp_id"] = warpDeliveryWarpIdNo.value?.newWarpId;
            request["warp_qty"] = warpQty;
            request["meter"] = double.tryParse(warpDeliveryMeter.text) ?? 0.0;
            var emptyType = warpDeliveryEmptyType.text;
            if (emptyType == "Beam") {
              request["bm_out"] = int.tryParse(warpDeliveryEmptyQyt.text) ?? 0;
            } else if (emptyType == "Bobbin") {
              request["bbn_out"] = int.tryParse(warpDeliveryEmptyQyt.text) ?? 0;
            }
            request["sht_out"] = int.tryParse(warpDeliverySheet.text) ?? 0;
            request["product_details"] = warpDeliveryDetails.text;
            Get.back(result: request);
          }
        } else {
          double warpMeter = double.tryParse(warpDeliveryMeter.text) ?? 0.0;

          if (warpMeter == 0) {
            return AppUtils.infoAlert(message: "Warp meter is '0'");
          }

          request["warp_design_name"] =
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
          Get.back(result: request);
        }
      }
    }
  }

  void _dialogFoeSubmit() {
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
          content: const Text("Delivery Yarn Qty Is ' 0 '"),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () => Get.back(),
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

  void _initValue() async {
    if (controller.Color.isNotEmpty) {
      yarnDeliveryColorName.value = controller.Color.first;
      returnYarnColourName.value = controller.Color.first;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      weaverYarnStockApiCall();
      if (controller.lastAddedDetails != null) {
        var item = controller.lastAddedDetails;
        var loomList = controller.loomList
            .where((element) => '${element.loomNo}' == '${item['loom']}')
            .toList();
        if (loomList.isNotEmpty) {
          loomNoController.value = loomList.first;

          var weaverId = controller.weaverId;
          var loomId = loomNoController.value?.loomNo;
          List<WeaverByLoomStatusModel> data =
              await controller.loomWarpStatus(weaverId, loomId);

          var warpStatus = data
              .where((element) =>
                  '${element.currentStatus}' == '${item['current_status']}')
              .toList();
          if (warpStatus.isNotEmpty) {
            warpStatusController.value = warpStatus.first;
            productName.value = warpStatus.first.productName!;
            _apiCals();
          }
        }
        if (controller.Color.isNotEmpty) {
          yarnDeliveryColorName.value = controller.Color.first;
        }
      }
    });
  }

  /// This Method Used To Display The Warp Deliver Warp Id By Details
  void warpDeliveryWarpDetails(WeavingWarpDeliveryModel item) {
    setState(() {
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
    });

    warpDeliveryProductQyt.text = "${item.qty}";
    warpDeliveryMeter.text = "${item.meter}";
    warpDeliverySheet.text = "${item.sheet}";
    warpDeliveryWarpColor.text = item.warpColor ?? '';
    warpDeliveryDetails.text = item.warpDet ?? "";
  }

  /// This Methods Used For Loom And Running Status Change to Set Default Values
  void yarnDeliveryControllers() {
    if (yarnDeliveryYarnName.value != null) {
      yarnDeliveryYarnName.value = null;
    }

    yarnDeliveryBoxNo.text = "";
    yarnDeliveryPack.text = "0";
    yarnDeliveryDetails.text = "";
    yarnDeliveryNetQty.text = "0";
  }

  void warpDeliverControllers() {
    if (warpDeliveryWarpDesignController.value != null) {
      warpDeliveryWarpDesignController.value = null;
    }
    if (warpDeliveryWarpDesignController.value != null) {
      warpDeliveryWarpIdNo.value = null;
    }
    warpDeliveryWarpType.text = "";
    warpDeliveryProductQyt.text = "0";
    warpDeliveryMeter.text = "0";
    warpDeliveryEmptyQyt.text = "0";
    warpDeliverySheet.text = "0";
    warpDeliveryDetails.text = "";
    warpDeliveryWarpColor.text = "";
  }

  void emptyInOutControllers() {
    emptyInOutBeamIn.text = "0";
    emptyInOutBeamOut.text = "0";
    emptyInOutBobbinIn.text = "0";
    emptyInOutBobbinOut.text = "0";
    emptyInOutSheetIn.text = "0";
    emptyInOutSheetOut.text = "0";
    emptyInOutDetails.text = "";
    emptyInOutBeamInDesignText.text = "";
    emptyInOutBobbinInDesignText.text = "";
    emptyInOutBeamInDesign.value = null;
    emptyInOutBobbinInDesign.value = null;
    otherWarp.value = "";
  }

  void returnYarnController() {
    if (returnYarnYarnName.value != null) {
      returnYarnYarnName.value = null;
    }
    returnYarnStockIn.text = "Office";
    returnYarnBoxNo.text = "";
    returnYarnPack.text = "0";
    returnYarnDetails.text = "";
    returnYarnNetQty.text = "0";
  }

  void _apiCals() async {
    yarnDeliveryControllers();
    warpDeliverControllers();
    emptyInOutControllers();
    returnYarnController();
    var weaverId = controller.weaverId;
    var loomNo = loomNoController.value?.loomNo;
    var currentStatus = warpStatusController.value?.currentStatus;
    var productId = warpStatusController.value?.productId;

    /// Product Id By Warp Details Call
    if (productId != null) {
      await controller.warpInfo(productId);
    }

    if (weaverId != null || loomNo != null || currentStatus != null) {
      await controller.loomWarpDeliveryStatus(weaverId, loomNo, currentStatus);
    }
    _mainWarpDeliveryStatusCheck();
  }

  _mainWarpDeliveryStatusCheck() {
    var loomId = loomNoController.value?.loomNo;
    var currentStatus = warpStatusController.value?.currentStatus;
    if (loomId == null || currentStatus == null) {
      return;
    }

    var ll = controller.itemList
        .where(
            (e) => e['loom'] == loomId && e['current_status'] == currentStatus)
        .toList();
    for (var e in ll) {
      if (e['entry_type'] == "Warp Delivery" && e["warp_type"] == "Main Warp") {
        controller.mainWarpDeliverStatus = true;
      }
    }
  }

  warpStatusApiCall() async {
    warpStatusController.value = null;
    var weaverId = controller.weaverId;
    var loomId = loomNoController.value?.loomNo;
    List<WeaverByLoomStatusModel> data =
        await controller.loomWarpStatus(weaverId, loomId);

    var index = data.indexWhere((e) => e.currentStatus == 'Running');
    initWarpStatus(index: index != -1 ? index : 0);
  }

  void initWarpStatus({var index = 0}) async {
    if (controller.warpStatus.isNotEmpty) {
      var item = controller.warpStatus[index];
      warpStatusController.value = item;
      productName.value = item.productName!;

      if (warpStatusController.value != null) {
        _apiCals();
      }
    }
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

  void weavingPage() {
    var weaverId = controller.weaverId;
    var loomNo = loomNoController.value?.loomNo;

    var request = {
      "weaver_id": weaverId,
      "loom_no": loomNo,
    };

    if (weaverId == null || loomNo == null) {
      return;
    }

    Get.toNamed(AddWeaving.routeName, arguments: request);
  }

  warpIdDropDownWidget() {
    var list = controller.warpDetails;
    // var suggestions = list.map((e) {
    //   return SearchFieldListItem<WeavingWarpDeliveryModel>('${e.newWarpId}',
    //       item: e);
    // }).toList();
    var suggestions = warpIdSuggestions(list);
    return Container(
      width: 240,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: SearchField<WeavingWarpDeliveryModel>(
        suggestions: suggestions,
        onSearchTextChanged: (value) {
          return warpIdSuggestions(list, query: value);
        },
        maxSuggestionsInViewPort: 7,
        itemHeight: 50,
        controller: warpDeliveryWarpIdController,
        searchInputDecoration: const InputDecoration(
            label: Text('Warp Id No'),
            labelStyle: TextStyle(fontSize: 14),
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
            ),
            suffixIcon: Icon(Icons.arrow_drop_down)),
        suggestionsDecoration: SuggestionDecoration(
            selectionColor: const Color(0xffA3D8FF), width: 500),
        focusNode: _warpIdFocusNode,
        autofocus: true,
        onScroll: (a, b) {},
        onSuggestionTap: (value) {
          FocusScope.of(context).requestFocus(_productQtyFocusNode);
          var item = value.item!;
          warpDeliveryWarpIdNo.value = item;
          warpDeliveryWarpDetails(item);
        },
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (warpDeliveryWarpIdController.text.isEmpty) {
            return "Required";
          } else {
            return null;
          }
        },
      ),
    );
  }

  warpIdSuggestions(List<WeavingWarpDeliveryModel> list, {String query = ''}) {
    var filter = list;
    if (query.isNotEmpty) {
      filter = list.where((e) {
        var newWarpId = '${e.newWarpId}'.toLowerCase();
        var warpDet = '${e.warpDet}'.toLowerCase();
        var warpColor = '${e.warpColor}'.toLowerCase();
        var q = query.toLowerCase();
        return newWarpId.contains(q) ||
            warpDet.contains(q) ||
            warpColor.contains(q);
      }).toList();
    }

    var suggestions = filter
        .map(
          (e) => SearchFieldListItem<WeavingWarpDeliveryModel>(
            '${e.newWarpId}',
            item: e,
            child: Row(
              children: [
                SizedBox(
                    width: 150,
                    child: Text('${e.newWarpId != "" ? e.newWarpId : ''}')),
                SizedBox(
                  width: 200,
                  child: Text("${e.warpDet != "" ? e.warpDet : ''}",
                      style: const TextStyle(overflow: TextOverflow.ellipsis)),
                ),
                SizedBox(
                  width: 100,
                  child: Text("${e.warpColor != "" ? e.warpColor : ''}",
                      style: const TextStyle(overflow: TextOverflow.ellipsis)),
                ),
              ],
            ),
          ),
        )
        .toList();

    return suggestions;
  }

  Widget weaverYarnStock() {
    return MySFDataGridItemTable(
      shrinkWrapRows: true,
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
      source: dataSource,
    );
  }

  Widget weaverWarpStock() {
    return MySFDataGridItemTable(
      shrinkWrapRows: true,
      scrollPhysics: const ScrollPhysics(),
      columns: [
        GridColumn(
          width: 100,
          columnName: 'warp_status',
          label: const MyDataGridHeader(title: 'Warp Status'),
        ),
        GridColumn(
          columnName: 'details',
          label: const MyDataGridHeader(title: 'Details'),
        ),
        GridColumn(
          width: 80,
          columnName: 'meter_qty',
          label: const MyDataGridHeader(title: 'Qty/Mtr'),
        ),
      ],
      source: warpStockDataSource,
    );
  }

  weaverYarnStockApiCall() async {
    var weaverId = controller.weaverId;
    var loomNo = "ALL";

    if (weaverId == null) {
      return;
    }

    List<dynamic> result =
        await controller.overAllWeftBalance(weaverId, loomNo);

    weaverYarnStockDetails.addAll(result);
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
  }

  /*weaverYarnStockApiCall() {
    var weaverId = controller.weaverId;
    var loomNo = "ALL";
    if (weaverId == null) {
      return;
    }
    weaverYarnStockDetails.clear();
    dataSource.updateDataGridRows();

    Future<OverAllWeftBalanceModel?> item =
        controller.overAllWeftBalance(weaverId, loomNo);
    item.then((e) {
      e?.weftBalance?.forEach((e) {
        var request = e.toJson();

        if (entryTypeController.text == 'Yarn Delivery') {
          if (request['yarn_name'] == "${yarnDeliveryYarnName.value}") {
            double data = request['wev_stock'];
            double netqty = double.tryParse(yarnDeliveryNetQty.text) ?? 0.0;
            request['wev_stock'] = data + netqty;
          } else {
            yarnDeliveryYarnName.value != null
                ? addNewItemToWeaverYarnDeliveryStockList()
                : '';
          }
        } else if (entryTypeController.text == 'Rtrn-Yarn') {
          if (request['yarn_name'] == "${returnYarnYarnName.value}") {
            double data = request['wev_stock'];
            double netqty = double.tryParse(returnYarnNetQty.text) ?? 0.0;
            request['wev_stock'] = data - netqty;
          } else {
            returnYarnYarnName.value != null
                ? addNewItemToWeaverYarnReturnStockList()
                : '';
          }
        }
        bool isDuplicate = weaverYarnStockDetails.any((element) =>
            element['wev_stock'] == request['wev_stock'] &&
            element['yarn_name'] == request['yarn_name']);

        if (!isDuplicate) {
          weaverYarnStockDetails.add(request);
        }
        dataSource.updateDataGridRows();
        dataSource.updateDataGridSource();
      });
    });
  }

  void addNewItemToWeaverYarnDeliveryStockList() {
    var data = double.tryParse(yarnDeliveryNetQty.text) ?? 0.0;
    Map<String, dynamic> newItem = {
      'yarn_name': "${yarnDeliveryYarnName.value}",
      // Replace with the actual yarn name
      'wev_stock': data
      // Replace with the actual stock value
    };
    isDuplicate(newItem);
  }

  void addNewItemToWeaverYarnReturnStockList() {
    var data = double.tryParse(returnYarnNetQty.text) ?? 0.0;
    Map<String, dynamic> newItem = {
      'yarn_name': "${returnYarnYarnName.value}",
      // Replace with the actual yarn name
      'wev_stock': -data
      // Replace with the actual stock value
    };
    isDuplicate(newItem);
  }

  void isDuplicate(newItem) {
    // Ensure the new item is not null or empty
    if (newItem['yarn_name'] != null &&
        newItem['yarn_name'].toString().isNotEmpty) {
      bool isDuplicate = weaverYarnStockDetails
          .any((element) => element['yarn_name'] == newItem['yarn_name']);

      // Add the new item if it's not a duplicate
      if (!isDuplicate) {
        weaverYarnStockDetails.add(newItem);
        dataSource.updateDataGridRows();
        dataSource.updateDataGridSource();
      }
    }
  }*/

  /// weaver and loom by get the current product details
  productDetailsApiCall() async {
    weaverWarpStockDetails.clear();
    warpStockDataSource.updateDataGridRows();
    warpStockDataSource.updateDataGridSource();

    var weaverId = controller.weaverId;
    var loomNo = loomNoController.value?.loomNo;
    if (weaverId == null) {
      return;
    }
    List<WeaverCurrentProductModel> result =
        await controller.weaverCurrentProducts(weaverId, loomNo);
    weaverWarpStockDetails.addAll(result);
    warpStockDataSource.updateDataGridRows();
    warpStockDataSource.updateDataGridSource();
  }

  yarnDeliveryCalculation() {
    double grossQuantity = double.tryParse(yarnDeliveryGrossQty.text) ?? 0.0;
    double nos = double.tryParse(yarnDeliveryNos.text) ?? 0.0;
    double weight = double.tryParse(yarnDeliveryWeight.text) ?? 0.0;
    var less = (nos * weight) / 1000;
    yarnDeliveryLess.text = less.toStringAsFixed(3);

    var netQty = grossQuantity - less;
    yarnDeliveryNetQty.text = netQty.toStringAsFixed(3);
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

  runningWarpDetails() async {
    String? loomNo = loomNoController.value?.loomNo;
    if (loomNo?.toLowerCase() == "vl") {
      return;
    }

    var result =
        await controller.runningWarpDetails(controller.weaverId!, loomNo!);
    List<dynamic> mainWarpList = result["main_warp"];
    List<dynamic> otherWarpList = result["other_warp"];

    if (mainWarpList.isNotEmpty) {
      emptyInOutBeamInDesignText.text = "${mainWarpList.first["warp_name"]}";
      emptyInOutBeamInDesign.value = NewWarpModel(
          id: mainWarpList.first["warp_design_id"], warpDetails: []);
    }

    if (otherWarpList.length == 1) {
      emptyInOutBobbinInDesignText.text = "${otherWarpList.first["warp_name"]}";
      emptyInOutBobbinInDesign.value = NewWarpModel(
          id: otherWarpList.first["warp_design_id"], warpDetails: []);
    } else {
      otherWarp.value = "";
      for (var e in otherWarpList) {
        otherWarp.value += "${e["warp_name"]}, ";
      }
    }
  }

  warpTracking() {
    if (controller.weaverId == null || loomNoController.value == null) {
      return;
    }

    var request = {
      "weaver_id": controller.weaverId,
      "loom_no": loomNoController.value?.loomNo,
    };

    Get.toNamed(WarpTrackingList.routeName, arguments: request);
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
      var wevYarn = e["wev_stock"];
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e['yarn_name']),
        DataGridCell<dynamic>(
            columnName: 'weaver_stock', value: wevYarn.toStringAsFixed(3)),
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

class WarpStockDataSource extends DataGridSource {
  WarpStockDataSource({required List<WeaverCurrentProductModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<WeaverCurrentProductModel> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var details = '';
      var productName = '';
      var warpDesign = '';
      var warpId = '';
      var balanceQty = '';
      var balanceMtr = '';
      var qtyMeter = '';

      if (e.productName != null) {
        productName = "${e.productName},  ";
      }
      if (e.warpName != null) {
        warpDesign = "${e.warpName},  ";
      }
      if (e.warpId != null && e.warpId != "NULL") {
        warpId = "${e.warpId},  ";
      }
      if (e.balanceQty != 0 && e.warpType == "Main Warp") {
        balanceQty = "Qty: ${e.balanceQty}, ";
      }

      if (e.balanceMeter != 0 && e.warpType == "Other") {
        balanceMtr = "Mtr ${e.balanceMeter}, ";
      }

      details = "$productName$warpDesign$warpId";
      qtyMeter = "$balanceQty$balanceMtr";

      return DataGridRow(cells: [
        DataGridCell<dynamic>(
            columnName: 'warp_status', value: e.currentStatus),
        DataGridCell<dynamic>(columnName: 'details', value: details),
        DataGridCell<dynamic>(columnName: 'meter_qty', value: qtyMeter),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      if (e.columnName == "meter_qty") {
        return Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            e.value != null ? '${e.value}' : '',
            style: const TextStyle(
              overflow: TextOverflow.visible,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.red,
            ),
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            e.value != null ? '${e.value}' : '',
            style: AppUtils.cellTextStyle(),
          ),
        );
      }
    }).toList());
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
