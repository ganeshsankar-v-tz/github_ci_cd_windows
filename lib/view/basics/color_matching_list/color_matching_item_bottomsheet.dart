
import 'package:abtxt/view/basics/color_matching_list/color_matching_list_controller.dart';
import 'package:abtxt/view/basics/new_color/add_new_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:abtxt/model/NewColorModel.dart';
import 'package:keymap/keymap.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class ColorMatchingItemBottomSheet extends StatefulWidget {
  const ColorMatchingItemBottomSheet({Key? key}) : super(key: key);

  @override
  State<ColorMatchingItemBottomSheet> createState() => _State();
}

class _State extends State<ColorMatchingItemBottomSheet> {
  Rxn<NewColorModel> weftColorName = Rxn<NewColorModel>();
  Rxn<NewColorModel> warpColorName = Rxn<NewColorModel>();

  TextEditingController warp_color = TextEditingController();
  TextEditingController warpColorController = TextEditingController();

  TextEditingController weft_color = TextEditingController();
  TextEditingController weftColorController = TextEditingController();

  TextEditingController activeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {

    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ColorMatchingListController>(builder: (controller) {
    return KeyboardWidget(
      bindings: [
        KeyAction(
          LogicalKeyboardKey.keyQ,
          'Close', () => Get.back(),
          isControlPressed: true,
        ),
      ],
      child: Scaffold(

        backgroundColor: const Color(0xFFF9F3FF),
        appBar: AppBar(title: const Text('Add item to color matching')),
        body: SingleChildScrollView(
          child: Container(
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,                              children: [
                                Container(
                                  child: Wrap(
  children: [
                                      Row(
                                        children: [
                                          MyDialogList(
                                            labelText: 'Warp Color',
                                            controller: warpColorController,
                                            list: controller.color_dropdown,
                                            showCreateNew: true,
                                            onItemSelected: (NewColorModel item) {
                                              warpColorController.text =
                                              '${item.name}';
                                              warpColorName.value = item;
                                              controller.request['name'] = item.id;
                                            },
                                            onCreateNew: (value) async {
                                              //supplier.value = null;
                                              var item =
                                              await Get.toNamed(AddNewColor.routeName);
                                              controller.onInit();
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyDialogList(
                                            labelText: 'Weft Color',
                                            controller: weftColorController,
                                            list: controller.color_dropdown,
                                            showCreateNew: false,
                                            onItemSelected: (NewColorModel item) {
                                              weftColorController.text =
                                              '${item.name}';
                                              weftColorName.value = item;
                                              controller.request['name'] = item.id;
                                            },
                                            onCreateNew: (value) async {

                                            },
                                          ),
                                        ],
                                      ),
                                      MyDropdownButtonFormField(
                                        controller: activeController,
                                        hintText: "Is Active",
                                        items: Constants.ISACTIVE,
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
                                    MyCloseButton(
                                      onPressed: () => Get.back(),
                                      child: const Text('Close'),
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
      ),
    );
  });
  }
  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "warp_color": warpColorName.value?.name,
        "weft_color": weftColorName.value?.name,
        "is_active": activeController.text,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {

    ColorMatchingListController controller = Get.find();
    activeController.text = Constants.ISACTIVE[0];

    if(Get.arguments != null){
      var item = Get.arguments['item'];

      activeController.text = '${item['is_active']}';

      var warpcolorList = controller.color_dropdown
          .where((element) => '${element.id}' == '${item['warp_color']}')
          .toList();
      if (warpcolorList.isNotEmpty) {
        warpColorName.value = warpcolorList.first;
        warp_color.text ='${warpcolorList.first.name}';
      }

      var weftcolorList = controller.color_dropdown
          .where((element) => '${element.id}' == '${item['weft_color']}')
          .toList();
      if (weftcolorList.isNotEmpty) {
        weftColorName.value = weftcolorList.first;
        weft_color.text ='${weftcolorList.first.name}';
      }
    }
  }
}
