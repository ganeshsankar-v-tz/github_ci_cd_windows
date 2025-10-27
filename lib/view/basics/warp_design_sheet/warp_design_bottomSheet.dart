import 'package:abtxt/view/basics/warp_design_sheet/warp_design_sheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import '../../../model/WarpDesignSheetModel.dart';
import '../../../model/YarnModel.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyDropdownSearch.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';
import '../yarn/add_yarn.dart';
import 'package:abtxt/view/basics/new_color/add_new_color.dart';
import 'package:abtxt/model/NewColorModel.dart';

class WarpDesignBottomSheet extends StatefulWidget {
  const WarpDesignBottomSheet({Key? key}) : super(key: key);

  @override
  State<WarpDesignBottomSheet> createState() => _State();
}

class _State extends State<WarpDesignBottomSheet> {
  Rxn<YarnModel> yarnName = Rxn<YarnModel>();
  Rxn<NewColorModel> colorName = Rxn<NewColorModel>();
  TextEditingController yarnController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController endsController = TextEditingController();
  TextEditingController hintController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  FocusNode _yarnNameFocusNode = FocusNode();
  FocusNode _colorNameFocusNode = FocusNode();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpDesignSheetController>(
        builder: (controller) {
          return KeyboardWidget(
            bindings: [
              KeyAction(
                LogicalKeyboardKey.keyQ,
                'Close', () => Get.back(),
                isControlPressed: true,
              ),
            ],
            child: Scaffold(
              backgroundColor: Colors.white,
             // backgroundColor: const Color(0xFFF9F3FF),
              appBar: AppBar(
                  title: const Text('Add item to Warp Design Sheet')),
              body: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFF9F3FF), width: 12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                         // color: Colors.white,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Wrap(
                                        children: [
                                          Row(
                                            children: [
                                              MyAutoComplete(
                                                label: 'Yarn Name',
                                                items: controller.yarn_dropdown,
                                                selectedItem:  yarnName.value,
                                                onChanged: (YarnModel item) {
                                                  yarnName.value = item;
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              MyTextField(
                                                focusNode: _yarnNameFocusNode,
                                                controller: endsController,
                                                hintText: "Ends",
                                                validate: "number",
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              MyAutoComplete(
                                                label: 'Color Name',
                                                items: controller.color_dropdown,
                                                selectedItem:  colorName.value,
                                                onChanged: (NewColorModel item) {
                                                  colorName.value = item;
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              MyDropdownButtonFormField(
                                                focusNode: _colorNameFocusNode,
                                                controller: hintController,
                                                hintText: "Hints",
                                                items: Constants.Hints,
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Visibility(
                                          visible: Get.arguments != null,
                                          child: MyElevatedButton(
                                            color: Colors.red,
                                            onPressed: () =>
                                                Get.back(result: {'item': 'delete'}),
                                            child: const Text('DELETE'),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        SizedBox(
                                          width: 200,
                                          child: MyElevatedButton(
                                            onPressed: () => submit(),
                                            child: const Text('ADD'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "yarn_name": yarnName.value?.name,
        "color_name": colorName.value?.name,
        "ends": int.tryParse(endsController.text) ?? 0,
        "hint": hintController.text,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    WarpDesignSheetController controller = Get.find();
    hintController.text = Constants.Hints[0];
    if (Get.arguments != null) {
      var item = Get.arguments['item'];
      endsController.text = '${item['ends']}';



      var yarnId = controller.yarn_dropdown
          .where((element) => '${element.id}' == '${item['yarn_name']}')
          .toList();
      if (yarnId.isNotEmpty) {
        yarnName.value = yarnId.first;
        yarnController.text = '${yarnId.first.name}';
      }
      var colorId = controller.color_dropdown
          .where((element) => '${element.id}' == '${item['color_name']}')
          .toList();
      if (colorId.isNotEmpty) {
        colorName.value = colorId.first;
        colorController.text = '${colorId.first.name}';
      }
    }
  }
}
