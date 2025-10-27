import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/LoomModel.dart';
import 'package:abtxt/model/warp_tracking/WarpCurrentPositionModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/production/warp_tracking/warp_tracking_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../widgets/MySubmitButton.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/my_search_field/my_search_field.dart';
import '../warp_tracking_history/warp_history.dart';

class WarpTrackingList extends StatefulWidget {
  const WarpTrackingList({super.key});

  static const String routeName = '/warp_tracking';

  @override
  State<WarpTrackingList> createState() => _State();
}

class _State extends State<WarpTrackingList> {
  TextEditingController weaverNameTextController = TextEditingController();
  Rxn<LedgerModel> weaverNameController = Rxn<LedgerModel>();
  TextEditingController loomNoTextController = TextEditingController();
  Rxn<LoomModel> loomNoController = Rxn<LoomModel>();
  RxList<WarpCurrentPositionModel> overAllWarpDetails =
      RxList<WarpCurrentPositionModel>([]);
  RxList<WarpCurrentPositionModel> mainWarpDetails =
      RxList<WarpCurrentPositionModel>([]);
  RxList<WarpCurrentPositionModel> otherWarpDetails =
      RxList<WarpCurrentPositionModel>([]);

  final _formKey = GlobalKey<FormState>();
  final WarpTrackingController controller = Get.find();

  final FocusNode _weaverFocusNode = FocusNode();
  final FocusNode _loomFocusNode = FocusNode();
  final FocusNode _submitFocusNode = FocusNode();

  @override
  void initState() {
    controller.loomList.clear();
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpTrackingController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: const Text("Warp Tracking"),
        ),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () => Get.back()),
            SaveIntent: SetCounterAction(perform: () => submit()),
          },
          child: FocusScope(
            autofocus: true,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        MySearchField(
                          label: "Weaver Name",
                          isValidate: false,
                          items: controller.ledgerDropdown,
                          textController: weaverNameTextController,
                          focusNode: _weaverFocusNode,
                          requestFocus: _loomFocusNode,
                          onChanged: (LedgerModel item) {
                            controller.loomInfo(item.id);
                            weaverNameController.value = item;
                            loomNoTextController.text = "";
                            loomNoController.value = null;
                            overAllWarpDetails.clear();
                          },
                        ),
                        MySearchField(
                          label: "Loom No",
                          isValidate: false,
                          items: controller.loomList,
                          textController: loomNoTextController,
                          focusNode: _loomFocusNode,
                          requestFocus: _submitFocusNode,
                          onChanged: (LoomModel item) {
                            loomNoController.value = item;
                            // submit();
                          },
                        ),
                        const SizedBox(width: 20),
                        MySubmitButton(
                          focusNode: _submitFocusNode,
                          onPressed:
                              controller.status.isLoading ? null : submit,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Main Warp Current Position",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: warpDetailsWidget(mainWarpDetails),
                  ),
                  const Text(
                    "Other Warp Current Position",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: warpDetailsWidget(otherWarpDetails),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  submit() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      if (weaverNameController.value == null) {
        return AppUtils.infoAlert(message: "Select the Weaver name");
      }

      if (loomNoController.value == null) {
        return AppUtils.infoAlert(message: "Select the Loom No");
      }
      apiCall();
    }
  }

  Widget warpDetailsWidget(List<WarpCurrentPositionModel> warpDetails) {
    return Obx(
      () => warpDetails.isEmpty
          ? const Center(
              child: Text(
                "No Data Found!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: warpDetails.length,
              shrinkWrap: false,
              physics: const ScrollPhysics(),
              itemBuilder: (context, index) {
                WarpCurrentPositionModel item = warpDetails[index];
                return InkWell(
                  onTap: () {
                    Get.toNamed(WarpHistory.routeName,
                        arguments: {"item": item});
                  },
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xffFAFAFA),
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Table(
                        border: const TableBorder(
                            horizontalInside: BorderSide.none,
                            verticalInside: BorderSide(color: Colors.black12)),
                        columnWidths: const {
                          0: FixedColumnWidth(150),
                          2: FixedColumnWidth(170),
                          3: FixedColumnWidth(170),
                          7: FixedColumnWidth(60),
                          8: FixedColumnWidth(90),
                        },
                        children: [
                          TableRow(
                            children: [
                              tableHeader("Entry"),
                              tableHeader("Ledger Name"),
                              tableHeader("Old Warp id"),
                              tableHeader("New Warp id"),
                              tableHeader("Warp Design"),
                              tableHeader("Details"),
                              tableHeader("Color"),
                              tableHeader("Qty"),
                              tableHeader("Meter", align: Alignment.center),
                            ],
                          ),
                          TableRow(
                            children: [
                              tableBody(item.entry ?? ""),
                              tableBody(item.ledgerName ?? ""),
                              tableBody(item.oldWarpId ?? ""),
                              tableBody(item.newWarpId ?? ""),
                              tableBody(item.warpName ?? ""),
                              tableBody(item.details ?? ""),
                              tableBody(item.warpColor ?? ""),
                              tableBody("${item.qty}"),
                              tableBody(
                                  NumberFormat.currency(
                                          locale: 'en_IN',
                                          name: "",
                                          decimalDigits: 3)
                                      .format(item.meter),
                                  align: Alignment.center),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget tableHeader(String text, {AlignmentGeometry? align}) {
    return Align(
      alignment: align ?? Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(text),
      ),
    );
  }

  Widget tableBody(String text, {AlignmentGeometry? align}) {
    return Align(
      alignment: align ?? Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Tooltip(
          message: text,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  void _initValue() async {
    if (Get.arguments != null) {
      var item = Get.arguments;

      var result = await controller.ledgerInfo();

      var weaverNameList = result
          .where((element) => '${element.id}' == '${item['weaver_id']}')
          .toList();
      if (weaverNameList.isNotEmpty) {
        weaverNameController.value = weaverNameList.first;
        weaverNameTextController.text = '${weaverNameList.first.ledgerName}';

        var result = await controller.loomInfo(weaverNameList.first.id);

        var loomList = result
            .where(
                (element) => '${element.subWeaverNo}' == '${item['loom_no']}')
            .toList();

        if (loomList.isNotEmpty) {
          loomNoController.value = loomList.first;
          loomNoTextController.text = "${loomList.first.subWeaverNo}";
          apiCall();
        }
      }
    }
  }

  apiCall() async {
    int weaverId = weaverNameController.value!.id!;
    int subWeaverNo = loomNoController.value!.id!;
    var result = await controller.currentPositionDetails(weaverId, subWeaverNo);

    overAllWarpDetails.value = result;

    mainWarpDetails.value =
        result.where((element) => element.warpType == "Main Warp").toList();

    otherWarpDetails.value =
        result.where((element) => element.warpType == "Other").toList();
  }
}
