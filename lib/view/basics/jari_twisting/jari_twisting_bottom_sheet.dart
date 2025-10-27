import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/NewColorModel.dart';
import '../../../model/YarnModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../new_color/add_new_color.dart';
import '../yarn/add_yarn.dart';
import 'jari_twisting_controller.dart';

class JariTwistingBottomSheet extends StatefulWidget {
  const JariTwistingBottomSheet({Key? key}) : super(key: key);

  @override
  State<JariTwistingBottomSheet> createState() => _State();
}

class _State extends State<JariTwistingBottomSheet> {
  Rxn<NewColorModel> colorName = Rxn<NewColorModel>();
  TextEditingController colorNameController = TextEditingController();
  Rxn<YarnModel> yarnName = Rxn<YarnModel>();
  TextEditingController yarnNameController = TextEditingController();
  TextEditingController usageController = TextEditingController();
  final FocusNode yarnNameFocusNode = FocusNode();
  final FocusNode colorNameFocusNode = FocusNode();
  var shortCut = RxString("");

  final _formKey = GlobalKey<FormState>();
  FocusNode _yarnNameFocusNode = FocusNode();
  RxBool isUpdate = RxBool(false);

  JariTwistingController controller = Get.find();

  //FocusNode _colorNameFocusNode = FocusNode();

  @override
  void initState() {
    yarnNameFocusNode.addListener(() => shortCutKeys());
    colorNameFocusNode.addListener(() => shortCutKeys());
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JariTwistingController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(title: const Text('Add item to Jari Twisting')),
        // bindings: {
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
        //       Get.back(),
        //   const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
        //       submit(),
        // },
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
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Wrap(
                        children: [
                          Focus(
                            focusNode: yarnNameFocusNode,
                            skipTraversal: true,
                            child: MyAutoComplete(
                              label: 'Yarn Name',
                              items: controller.yarnDropdown,
                              selectedItem: yarnName.value,
                              enabled: !isUpdate.value,
                              onChanged: (YarnModel item) {
                                yarnName.value = item;
                              },
                            ),
                          ),
                          Focus(
                            focusNode: colorNameFocusNode,
                            skipTraversal: true,
                            child: MyAutoComplete(
                              label: 'Color Name',
                              items: controller.colorDropdown,
                              selectedItem: colorName.value,
                              onChanged: (NewColorModel item) {
                                colorName.value = item;
                                // _colorNameFocusNode.requestFocus();
                              },
                            ),
                          ),
                          Focus(
                            skipTraversal: true,
                            child: MyTextField(
                              controller: usageController,
                              focusNode: _yarnNameFocusNode,
                              hintText: 'Usage',
                              validate: 'double',
                            ),
                            onFocusChange: (hasFocus) {
                              AppUtils.fractionDigitsText(
                                usageController,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),
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
                              onPressed: () => submit(),
                            ),
                          ),
                        ],
                      ),
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

  shortCutKeys() {
    if (yarnNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Yarn',Press Alt+C ";
    } else if (colorNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Color',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (yarnNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddYarn.routeName);

      print("$result");
      if (result == "success") {
        controller.yarnNameInfo();
      }
    } else if (colorNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddNewColor.routeName);

      if (result == "success") {
        controller.colorInfo();
      }
    }
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "yarn_id": yarnName.value?.id,
        "yarn_name": yarnName.value?.name,
        "usage": double.tryParse(usageController.text) ?? 0.0,
        "colour_name": colorName.value?.name,
        "colour_id": colorName.value?.id,
      };
      Get.back(result: request);
    }
  }

  void _initValue() async {
    if (Get.arguments != null) {
      isUpdate.value = true;
      JariTwistingController controller = Get.find();

      var item = Get.arguments['item'];

      print("$item");
      usageController.text = "${item["usage"]}";

      var yarnList = controller.yarnDropdown
          .where((element) => '${element.id}' == '${item['yarn_id']}')
          .toList();
      if (yarnList.isNotEmpty) {
        yarnName.value = yarnList.first;
        yarnNameController.text = '${yarnList.first.name}';
      }
      var colorList = controller.colorDropdown
          .where((element) => '${element.id}' == '${item['colour_id']}')
          .toList();
      if (colorList.isNotEmpty) {
        colorName.value = colorList.first;
        colorNameController.text = '${colorList.first.name}';
      }
    }
  }
}
