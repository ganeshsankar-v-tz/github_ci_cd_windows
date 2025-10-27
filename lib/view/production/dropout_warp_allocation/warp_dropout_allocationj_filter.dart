import 'package:abtxt/model/NewWarpModel.dart';
import 'package:abtxt/view/production/dropout_warp_allocation/warp_dropout_allocation_controller.dart';
import 'package:abtxt/widgets/MyFilterTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../model/LedgerModel.dart';
import '../../../model/LoomModel.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/my_search_field/my_search_field.dart';

class WarpDropoutAllocationFilter extends StatefulWidget {
  const WarpDropoutAllocationFilter({super.key});

  @override
  State<WarpDropoutAllocationFilter> createState() =>
      _WarpDropoutAllocationFilterState();
}

class _WarpDropoutAllocationFilterState
    extends State<WarpDropoutAllocationFilter> {
  WarpDropOutAllocationController controller = Get.find();
  RxBool dateC = RxBool(true);
  RxBool weaverNameC = RxBool(false);
  RxBool loomNoC = RxBool(false);
  RxBool warpIdNoC = RxBool(false);
  RxBool warpDesignC = RxBool(false);

  var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController warpID = TextEditingController();
  TextEditingController weaverNameTextController = TextEditingController();
  Rxn<LedgerModel> weaverNameController = Rxn<LedgerModel>();
  TextEditingController loomNoTextController = TextEditingController();
  Rxn<LoomModel> loomNoController = Rxn<LoomModel>();
  Rxn<NewWarpModel> warpDesignController = Rxn<NewWarpModel>();
  TextEditingController warpDesignTextController = TextEditingController();

  final FocusNode _weaverFocusNode = FocusNode();
  final FocusNode _loomFocusChNode = FocusNode();
  final FocusNode _loomFocusNode = FocusNode();
  final FocusNode _warpDesignFocusNode = FocusNode();
  final FocusNode _warpDesignCFocusNode = FocusNode();
  final FocusNode _warpIdFocusNode = FocusNode();
  final FocusNode _warpIdCFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    fromDateController.text = today;
    toDateController.text = today;
    controller.loomList.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpDropOutAllocationController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 580,
            height: 450,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return ListTile(
                      leading: Checkbox(
                        value: dateC.value,
                        onChanged: (value) => dateC.value = value!,
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            children: [
                              MyDateFilter(
                                controller: fromDateController,
                                labelText: "From Date",
                                required: dateC.value,
                                autofocus: true,
                              ),
                              MyDateFilter(
                                controller: toDateController,
                                labelText: "To Date",
                                required: dateC.value,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  Obx(
                    () => SizedBox(
                      width: 325,
                      child: ListTile(
                        leading: Checkbox(
                          value: weaverNameC.value,
                          onChanged: (value) => weaverNameC.value = value!,
                        ),
                        subtitle: MySearchField(
                          label: "Weaver Name",
                          items: controller.ledgerDropdown,
                          textController: weaverNameTextController,
                          focusNode: _weaverFocusNode,
                          requestFocus: _loomFocusChNode,
                          isValidate: loomNoC.value,
                          onChanged: (LedgerModel item) {
                            controller.loomInfo(item.id);
                            weaverNameController.value = item;
                            loomNoTextController.text = "";
                            loomNoController.value = null;
                            weaverNameC.value = true;
                          },
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      width: 325,
                      child: ListTile(
                        leading: Checkbox(
                          focusNode: _loomFocusChNode,
                          value: loomNoC.value,
                          onChanged: (value) => loomNoC.value = value!,
                        ),
                        subtitle: MySearchField(
                          label: "Loom No",
                          items: controller.loomList,
                          textController: loomNoTextController,
                          focusNode: _loomFocusNode,
                          isValidate: loomNoC.value,
                          requestFocus: _warpDesignCFocusNode,
                          onChanged: (LoomModel item) {
                            loomNoController.value = item;
                            loomNoC.value = true;
                          },
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      width: 325,
                      child: ListTile(
                        leading: Checkbox(
                          focusNode: _warpDesignCFocusNode,
                          value: warpDesignC.value,
                          onChanged: (value) => warpDesignC.value = value!,
                        ),
                        subtitle: MySearchField(
                          label: "Warp Design",
                          items: controller.newWarpDropDown,
                          textController: warpDesignTextController,
                          focusNode: _warpDesignFocusNode,
                          isValidate: warpDesignC.value,
                          requestFocus: _warpIdCFocusNode,
                          onChanged: (NewWarpModel item) {
                            warpDesignController.value = item;
                            warpDesignC.value = true;
                          },
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      width: 325,
                      child: ListTile(
                        leading: Checkbox(
                          focusNode: _warpIdCFocusNode,
                          value: warpIdNoC.value,
                          onChanged: (value) => warpIdNoC.value = value!,
                        ),
                        subtitle: MyFilterTextField(
                          focusNode: _warpIdFocusNode,
                          controller: warpID,
                          hintText: 'Warp Id',
                          validate: warpIdNoC.value ? 'string' : '',
                          onChanged: (value) {
                            warpIdNoC.value = true;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('APPLY'),
            onPressed: () {
              if (!formKey.currentState!.validate()) {
                return;
              }
              var request = {};
              if (dateC.value == true) {
                request['from_date'] = fromDateController.text;
                request['to_date'] = toDateController.text;
              }
              if (weaverNameC.value == true) {
                request['weaver_id'] = weaverNameController.value?.id;
              }
              if (warpDesignC.value == true) {
                request['warp_design_id'] = warpDesignController.value?.id;
              }
              if (loomNoC.value == true) {
                request['sub_weaver_no'] = loomNoController.value?.id;
              }

              if (warpIdNoC.value == true) {
                request['warp_id'] = warpID.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
