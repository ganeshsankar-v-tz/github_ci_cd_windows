import 'package:abtxt/model/YarnModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/new_unit/add_new_unit.dart';
import 'package:abtxt/view/basics/yarn/yarn_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/NewUnitModel.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class AddYarn extends StatefulWidget {
  const AddYarn({Key? key}) : super(key: key);
  static const String routeName = '/AddYarn';

  @override
  State<AddYarn> createState() => _State();
}

class _State extends State<AddYarn> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController llNameController = TextEditingController();
  Rxn<NewUnitModel> unitName = Rxn<NewUnitModel>();
  TextEditingController holderController =
      TextEditingController(text: "Nothing");
  TextEditingController netWeightUnitController = TextEditingController();
  TextEditingController holderUnitController = TextEditingController(text: "0");
  TextEditingController detailsController = TextEditingController();
  TextEditingController isActiveController = TextEditingController(text: "Yes");
  TextEditingController typeController = TextEditingController(text: "Other");
  TextEditingController hsnController = TextEditingController(text: "HSN");
  TextEditingController hsnCodeController = TextEditingController();
  TextEditingController defaultMeterController =
      TextEditingController(text: '0');
  TextEditingController singleYarnConsumptionController =
      TextEditingController(text: '0');
  final RxString _selectedHolder = RxString('Cops');

  final _formKey = GlobalKey<FormState>();
  late YarnController controller;
  RxBool enable = RxBool(false);

  final FocusNode _holderFocusNode = FocusNode();

  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _unitNameFocusNode = FocusNode();
  var shortCut = RxString("");

  @override
  void initState() {
    _unitNameFocusNode.addListener(() => shortCutKeys());
    _initValue();
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_firstInputFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title: Text("${idController.text == '' ? 'Add' : 'Update'} Yarn"),
          actions: [
            Visibility(
                visible: idController.text.isNotEmpty,
                child: MyDeleteIconButton(
                  onPressed: (password) {
                    controller.delete(idController.text, password);
                  },
                )),
          ],
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
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            NavigateIntent: SetCounterAction(perform: () {
              navigateAnotherPage();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(16),
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
                                enabled: false,
                              ),
                            ),
                            MyTextField(
                              controller: nameController,
                              hintText: "Yarn Name",
                              validate: "string",
                              focusNode: _firstInputFocusNode,
                            ),
                            Focus(
                              focusNode: _unitNameFocusNode,
                              skipTraversal: true,
                              child: MyAutoComplete(
                                label: 'Unit Name',
                                items: controller.unitDropdown,
                                selectedItem: unitName.value,
                                onChanged: (NewUnitModel item) {
                                  unitName.value = item;
                                  if (unitName.value?.unitName == "Kgs") {
                                    netWeightUnitController.text = "1";
                                    enable.value = true;
                                  } else {
                                    enable.value = false;
                                    netWeightUnitController.text = "0";
                                  }
                                  _holderFocusNode.requestFocus();
                                },
                              ),
                            ),
                            MyDropdownButtonFormField(
                              focusNode: _holderFocusNode,
                              controller: holderController,
                              hintText: "Holder",
                              items: const ["Cops", "Reel", "Nothing"],
                              onChanged: (value) {
                                _selectedHolder.value = value;
                              },
                            ),
                            Obx(
                              () => MyTextField(
                                controller: netWeightUnitController,
                                hintText: "Net Weight / Unit",
                                validate: "number",
                                enabled: !enable.value,
                              ),
                            ),
                            Obx(
                              () => Visibility(
                                visible: _selectedHolder.value != "Nothing",
                                child: MyTextField(
                                  controller: holderUnitController,
                                  hintText:
                                      "${_selectedHolder.value} / ${unitName.value?.unitName ?? 'Unit'}",
                                  validate: "number",
                                  enabled: !enable.value,
                                ),
                              ),
                            ),
                            MyDropdownButtonFormField(
                                controller: typeController,
                                hintText: "Type",
                                items: const ["Twisted", "Other", "Raw"]),
                            MyTextField(
                              controller: detailsController,
                              hintText: "Details",
                            ),
                            MyTextField(
                              controller: llNameController,
                              hintText: "L.L Name",
                            ),
                            MyDropdownButtonFormField(
                                controller: hsnController,
                                hintText: "HSN",
                                items: const ["HSN"]),
                            MyTextField(
                              controller: hsnCodeController,
                              hintText: "HSN Code",
                            ),
                            MyDropdownButtonFormField(
                              controller: isActiveController,
                              hintText: "Is Active",
                              items: const ["Yes", "No"],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text("Warping.. Yarn Consumption"),
                        const SizedBox(height: 12),
                        Wrap(
                          children: [
                            MyTextField(
                              controller: defaultMeterController,
                              hintText: "Default Meter",
                              validate: "double",
                            ),
                            MyTextField(
                              controller: singleYarnConsumptionController,
                              hintText: "Single Yarn Consumption",
                              validate: "double",
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            /* crateAndUpdatedBy(),
                            const Spacer(),*/
                            Obx(
                              () => Text(shortCut.value,
                                  style: AppUtils.shortCutTextStyle()),
                            ),
                            const SizedBox(width: 12),
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

  shortCutKeys() {
    if (_unitNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Unit',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_unitNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddNewUnit.routeName);

      if (result == "success") {
        controller.unitInfo();
      }
    }
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "name": nameController.text,
        "ll_name": llNameController.text,
        "unit_id": unitName.value?.id,
        "holder": holderController.text,
        "net_weight": netWeightUnitController.text,
        "holder_unit": holderUnitController.text,
        "is_active": isActiveController.text,
        "details": detailsController.text,
        "hsn_code": hsnCodeController.text,
        "yarn_typ": typeController.text,
        "codetyp": hsnController.text,
        "dft_length": double.tryParse(defaultMeterController.text) ?? 0,
        "sycons": double.tryParse(singleYarnConsumptionController.text) ?? 0,
      };
      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        controller.addyarn(request);
      } else {
        request['id'] = id;
        controller.updateyarn(request);
      }
    }
  }

  void _initValue() {
    YarnController controller = Get.find();
    controller.request = <String, dynamic>{};

    if (Get.arguments != null) {
      var item = YarnModel.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      nameController.text = '${item.name}';
      llNameController.text = item.llName ?? '';
      detailsController.text = item.details ?? '';
      _selectedHolder.value = "${item.holder}";
      var unitList = controller.unitDropdown
          .where((element) => '${element.id}' == '${item.unitId}')
          .toList();
      if (unitList.isNotEmpty) {
        unitController.text = '${unitList.first.unitName}';
        unitName.value = unitList.first;
      }

      holderController.text = '${item.holder}';
      netWeightUnitController.text = tryCast(item.netWeight);
      holderUnitController.text = '${item.holderUnit}';
      isActiveController.text = '${item.isActive}';
      typeController.text = '${item.yarnTyp}';
      hsnController.text = '${item.codetyp}';
      hsnCodeController.text = tryCast(item.hsnCode);
      defaultMeterController.text = tryCast(item.dftLength);
      singleYarnConsumptionController.text = tryCast(item.sycons);
    }
  }

/*  Widget crateAndUpdatedBy() {
    String id = idController.text;
    String formattedDate = AppUtils.dateFormatter.format(DateTime.now());
    String? createdAt;
    String? updatedAt;
    String? entryBy;

    if (Get.arguments != null) {
      var item = Get.arguments["item"];
      DateTime createDate = DateTime.parse(item["created_at"] ?? "0000-00-00");
      DateTime updateDate = DateTime.parse(item["updated_at"] ?? "0000-00-00");
      createdAt = AppUtils.dateFormatter.format(createDate);
      updatedAt = AppUtils.dateFormatter.format(updateDate);

      entryBy = item["creator_name"] ?? '';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          id.isEmpty ? AppUtils().loginName : "$entryBy",
          style: AppUtils.updateAndCreateTextStyle(),
        ),
        const SizedBox(width: 12),
        Text(
          id.isEmpty ? formattedDate : "${updatedAt ?? createdAt}",
          style: AppUtils.updateAndCreateTextStyle(),
        )
      ],
    );
  }*/
}
