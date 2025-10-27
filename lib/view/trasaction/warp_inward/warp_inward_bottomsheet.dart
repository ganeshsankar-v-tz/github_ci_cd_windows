
import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/YarnModel.dart';
import 'package:abtxt/view/trasaction/warp_inward/warp_inward_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class WarpInwardBottomSheet extends StatefulWidget {
  const WarpInwardBottomSheet({Key? key}) : super(key: key);

  @override
  State<WarpInwardBottomSheet> createState() => _State();
}

class _State extends State<WarpInwardBottomSheet> {
  Rxn<YarnModel> yarnName = Rxn<YarnModel>();
  TextEditingController yarnNameController = TextEditingController();
  Rxn<NewColorModel> colorName = Rxn<NewColorModel>();
  TextEditingController colorNameController = TextEditingController();
  TextEditingController noofEndsController = TextEditingController();
  TextEditingController usedYarnsController = TextEditingController();
  TextEditingController calculateTypeController = TextEditingController();
  TextEditingController wagesRsController = TextEditingController();
  TextEditingController amountRsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpInwardController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(title: const Text('Add Item to Warp Inward')),
        loadingStatus: controller.status.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ,control: true): GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS,control: true): SaveIntent(),
        },
        child: Actions(
          actions:  <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFF9F3FF), width: 16)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
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
                                              items: controller.yarnDropdown,
                                              selectedItem: yarnName.value,
                                              enabled: false,
                                              onChanged: (YarnModel item) {
                                                yarnNameController.text =
                                                    '${item.name}';
                                                yarnName.value = item;
                                              },
                                            ),
                                            MyAutoComplete(
                                              label: 'Color Name',
                                              items: controller.colorDropdown,
                                              onChanged: (NewColorModel item) {
                                                colorNameController.text =
                                                    '${item.name}';
                                                colorName.value = item;
                                              },
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            MyTextField(
                                              controller: noofEndsController,
                                              hintText: 'No of Ends',
                                              validate: 'number',
                                              readonly: true,
                                            ),
                                            MyTextField(
                                              controller: usedYarnsController,
                                              hintText: 'Used Yarns',
                                              validate: 'double',
                                              readonly: true,
                                              suffix: Obx(
                                                () => Text(
                                                  '${yarnName.value?.unitName}',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            MyTextField(
                                              controller: calculateTypeController,
                                              hintText: "Calculate Type",
                                              validate: 'string',
                                              readonly: true,
                                            ),
                                            MyTextField(
                                              controller: wagesRsController,
                                              hintText: 'Wages (Rs)',
                                              readonly: true,
                                              validate: 'double',
                                            ),
                                          ],
                                        ),
                                        MyTextField(
                                          controller: amountRsController,
                                          hintText: 'Amount (Rs)',
                                          validate: 'double',
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 32,),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MyAddButton(
                                        onPressed: () => submit(),
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
                    Flexible(
                        flex: 1, child: Container(color: Colors.grey[400])),
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
        "yarn_id": yarnName.value?.id,
        "yarn_name": yarnName.value?.name,
        "color_id": colorName.value?.id,
        "color_name": colorName.value?.name,
        "ends": int.tryParse(noofEndsController.text) ?? 0,
        "qty": double.tryParse(usedYarnsController.text) ?? 0.0,
        "calc_typ": calculateTypeController.text,
        "wages": wagesRsController.text,
        "amount": double.tryParse(amountRsController.text) ?? 0
      };
      Get.back(result: request);
    }
  }

  void _initValue() async {
    if (Get.arguments != null) {
      WarpInwardController controller = Get.find();

      var item = Get.arguments['item'];
      print("$item");
      noofEndsController.text = "${item["ends"]}";
      usedYarnsController.text = item["qty"] != null ? '${item["qty"]}' : '';
      calculateTypeController.text = "${item["calc_typ"]}";
      wagesRsController.text = item["wages"] != null ? '${item["wages"]}' : '';
      amountRsController.text =
          item["amount"] != null ? '${item["amount"]}' : '';
      var yarnList = controller.yarnDropdown
          .where((element) => '${element.id}' == '${item['yarn_id']}')
          .toList();
      if (yarnList.isNotEmpty) {
        yarnName.value = yarnList.first;
        yarnNameController.text = '${yarnList.first.name}';
      }
      var colorList = controller.colorDropdown
          .where((element) => '${element.id}' == '${item['color_id']}')
          .toList();
      if (colorList.isNotEmpty) {
        colorName.value = colorList.first;
        colorNameController.text = '${colorList.first.name}';
      }
    }
  }
}
