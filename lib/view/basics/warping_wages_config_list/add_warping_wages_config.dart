import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/warping_wages_config_list/warping_wages_config_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/WarpingWagesConfigModel.dart';
import '../../../model/YarnModel.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../yarn/add_yarn.dart';

class AddWarpingWagesConfig extends StatefulWidget {
  const AddWarpingWagesConfig({super.key});

  static const String routeName = '/AddWarpingWagesConfig';

  @override
  State<AddWarpingWagesConfig> createState() => _State();
}

class _State extends State<AddWarpingWagesConfig> {
  WarpingWagesConfigController controller = Get.find();
  TextEditingController idController = TextEditingController();

  Rxn<YarnModel> yarn_name = Rxn<YarnModel>();
  TextEditingController yarnNameController = TextEditingController();
  TextEditingController calculateTypeController = TextEditingController();
  TextEditingController defaultWarpLenghtController = TextEditingController();
  var fromController = TextEditingController().obs;
  TextEditingController toController = TextEditingController();
  TextEditingController wagesrsController = TextEditingController();
  final RxString _selectedCalcType = RxString('Ends');
  final _formKey = GlobalKey<FormState>();
  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _yarnNameFocusNode = FocusNode();
  final FocusNode _typeFocusNode = FocusNode();
  var shortCut = RxString("");

  RxBool isUpdate = RxBool(false);

  @override
  void initState() {
    _yarnNameFocusNode.addListener(() => shortCutKeys());
    _initValue();
    super.initState();
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_firstInputFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpingWagesConfigController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          actions: [
            Visibility(
                visible: idController.text.isNotEmpty,
                child: ExcludeFocusTraversal(
                  child: Tooltip(
                    message: 'Delete',
                    child: TextButton.icon(
                      onPressed: () {
                        controller.delete(int.tryParse(idController.text));
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'DELETE',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                )),
          ],
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Warping Wages Config"),
        ),
        loadingStatus: controller.status.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
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
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
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
                                      validate: "",
                                      enabled: false,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Wrap(
                                        children: [
                                          MySearchField(
                                            label: 'Yarn Name',
                                            enabled: !isUpdate.value,
                                            items: controller.yarnName,
                                            textController: yarnNameController,
                                            focusNode: _yarnNameFocusNode,
                                            requestFocus: _typeFocusNode,
                                            onChanged: (YarnModel item) async {
                                              yarn_name.value = item;
                                              var result = await controller
                                                  .lastToEnds(item.id);
                                              fromController.value.text =
                                                  "${result['ends_to'] ?? 0}";
                                              defaultWarpLenghtController.text =
                                                  "${result['dft_meter'] ?? 0}";
                                            },
                                          ),
                                          MyDropdownButtonFormField(
                                            focusNode: _typeFocusNode,
                                            controller: calculateTypeController,
                                            hintText: "Calculate Type",
                                            enabled: !isUpdate.value,
                                            items: const [
                                              "Ends",
                                              "Yarn Usage",
                                              "Length",
                                            ],
                                            onChanged: (value) {
                                              _selectedCalcType.value = value;
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Wrap(
                                        children: [
                                          MyTextField(
                                            controller:
                                                defaultWarpLenghtController,
                                            hintText: "Default Warp Length",
                                            validate: "number",
                                            focusNode: _firstInputFocusNode,
                                          ),
                                          Obx(
                                            () => MyTextField(
                                              controller: fromController.value,
                                              hintText: "From",
                                              validate: "number",
                                              enabled:
                                                  fromController.value.text ==
                                                      '1',
                                              suffix: const Text('Ends',
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xFF5700BC))),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Wrap(
                                        children: [
                                          MyTextField(
                                            controller: toController,
                                            hintText: "To",
                                            validate: "number",
                                            enabled: !isUpdate.value,
                                            suffix: const Text('Ends',
                                                style: TextStyle(
                                                    color: Color(0xFF5700BC))),
                                          ),
                                          Focus(
                                            skipTraversal: true,
                                            child: MyTextField(
                                              controller: wagesrsController,
                                              hintText: "Wages (Rs)",
                                              validate: "double",
                                              suffix: Text(
                                                  _selectedCalcType.value ==
                                                          "Yarn Usage"
                                                      ? "Kgs"
                                                      : "",
                                                  style: const TextStyle(
                                                      color:
                                                          Color(0xFF5700BC))),
                                            ),
                                            onFocusChange: (hasFocus) {
                                              AppUtils.fractionDigitsText(
                                                  wagesrsController,
                                                  fractionDigits: 2);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /* crateAndUpdatedBy(),
                                  const Spacer(),*/
                                  Obx(
                                    () => Text(shortCut.value,
                                        style: AppUtils.shortCutTextStyle()),
                                  ),
                                  const SizedBox(width: 12),
                                  MySubmitButton(
                                    onPressed: controller.status.isLoading
                                        ? null
                                        : submit,
                                  ),
                                  /*const Spacer(),*/
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  shortCutKeys() {
    if (_yarnNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Yarn',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_yarnNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddYarn.routeName);

      if (result == "success") {
        controller.yarnNameInfo();
      }
    }
  }

  submit() async {
    int endsFrom = int.tryParse(fromController.value.text) ?? 0;
    int endsTo = int.tryParse(toController.text) ?? 0;
    if (_formKey.currentState!.validate()) {
      if (yarn_name.value == null) {
        return AppUtils.infoAlert(message: "Select the yarn name");
      }

      if (endsFrom < endsTo) {
        Map<String, dynamic> request = {
          "yarn_id": yarn_name.value?.id,
          "calc_type": calculateTypeController.text,
          "dft_meter": int.tryParse(defaultWarpLenghtController.text) ?? 0,
          "ends_from": endsFrom,
          "ends_to": endsTo,
          "wages": double.tryParse(wagesrsController.text) ?? 0.0,
        };

        var id = idController.text;
        if (id.isEmpty) {
          controller.lastYarnName = "${yarn_name.value?.name}";
          controller.filterData = null;
          controller.add(request);
        } else {
          request['id'] = id;
          controller.updateWarpWages(request);
        }
      } else {
        AppUtils.infoAlert(message: "From Ends Greater Than To Ends");
      }
    }
  }

  void _initValue() {
    controller.request = <String, dynamic>{};

    calculateTypeController.text = "Ends";

    if (controller.lastYarnName.isNotEmpty) {
      yarnNameController.text = controller.lastYarnName;
    }

    if (Get.arguments != null) {
      isUpdate.value = true;
      var data = WarpingWagesConfigModel.fromJson(Get.arguments['item']);
      idController.text = '${data.id}';

      var yarnId = controller.yarnName
          .where((element) => '${element.id}' == '${data.yarnId}')
          .toList();
      if (yarnId.isNotEmpty) {
        yarn_name.value = yarnId.first;
        yarnNameController.text = '${yarnId.first.name}';
      }

      _selectedCalcType.value = data.calcType!;
      calculateTypeController.text = '${data.calcType}';
      defaultWarpLenghtController.text = '${data.dftMeter}';
      fromController.value.text = '${data.endsFrom}';
      toController.text = '${data.endsTo}';
      wagesrsController.text = '${data.wages}';
    }
  }
}
