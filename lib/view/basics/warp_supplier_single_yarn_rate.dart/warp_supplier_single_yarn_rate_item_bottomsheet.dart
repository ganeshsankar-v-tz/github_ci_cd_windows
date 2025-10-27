import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/basics/warp_supplier_single_yarn_rate.dart/warp_supplier_single_yarn_rate_controller.dart';
import 'package:abtxt/widgets/MyAddButton.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../model/YarnModel.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class WarpSupplierSingleYarnRateItemBottomsheet extends StatefulWidget {
  const WarpSupplierSingleYarnRateItemBottomsheet({super.key});

  @override
  State<WarpSupplierSingleYarnRateItemBottomsheet> createState() =>
      _WarpSupplierSingleYarnRateItemBottomsheetState();
}

class _WarpSupplierSingleYarnRateItemBottomsheetState
    extends State<WarpSupplierSingleYarnRateItemBottomsheet> {
  //TextEditingController yarnNameController = TextEditingController();
  Rxn<YarnModel> yarn_name = Rxn<YarnModel>();
  TextEditingController yarnNameController = TextEditingController();
  TextEditingController yarnLengthController = TextEditingController();
  TextEditingController singleYarnRateController = TextEditingController();
  TextEditingController lengthTypeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpSupplierSingleYarnRateController>(
        builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
            title: const Text('Add item to Warp supplier single yarn rate')),
        // bindings:  {
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
        //       Get.back(),
        // },
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ,control: true): GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS,control: true): SaveIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child:Actions(
          actions: <Type, Action<Intent>>{
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(

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
                                              selectedItem: yarn_name.value,
                                              onChanged: (YarnModel item) {
                                                yarn_name.value = item;
                                              },
                                            ),
                                          ],
                                        ),
                                        Wrap(
                                          children: [
                                            MyDropdownButtonFormField(
                                                controller: lengthTypeController,
                                                hintText: "Length Type",
                                                items: Constants.LengthType),
                                            Row(
                                              children: [
                                                MyTextField(
                                                  controller:
                                                  yarnLengthController,
                                                  hintText: "Yarn Length",
                                                  validate: "double",
                                                  suffix: const Text('',
                                                      style: TextStyle(
                                                          color:
                                                          Color(0xFF5700BC))),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                MyTextField(
                                                  controller:
                                                  singleYarnRateController,
                                                  hintText:
                                                  "Single Yarn Rate(Rs)",
                                                  validate: "double",
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 32,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    /*  MyCloseButton(
                                        onPressed: () => Get.back(),
                                        child: const Text('Close'),
                                      ),
                                      const SizedBox(width: 16),*/
                                      MyAddButton(
                                        onPressed: () => submit(),
                                       // child: const Text('ADD'),
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
                    Flexible(flex: 1, child: Container(color: Colors.grey[400])),
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
        "yarn_id": yarn_name.value?.id,
        "yarn_name": yarn_name.value?.name,
        "yarn_length": double.parse(yarnLengthController.text),
        "length_type": lengthTypeController.text,
        "rate": double.parse(singleYarnRateController.text),
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    WarpSupplierSingleYarnRateController controller = Get.find();
    lengthTypeController.text = Constants.LengthType[0];

    if (Get.arguments != null) {
      var item = Get.arguments['item'];

      lengthTypeController.text = Constants.LengthType[0];

      lengthTypeController.text = '${item['length_type']}';
      yarnLengthController.text = '${item['yarn_length']}';
      singleYarnRateController.text = '${item['rate']}';

      var yarnName = controller.yarn_dropdown
          .where((element) => '${element.id}' == '${item['yarn_id']}')
          .toList();
      if (yarnName.isNotEmpty) {
        yarn_name.value = yarnName.first;
        yarnNameController.text = '${yarnName.first.name}';
      }
    }
  }
}
