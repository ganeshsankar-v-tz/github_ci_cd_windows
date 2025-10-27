import 'dart:convert';
import 'package:abtxt/model/NewWarpModel.dart';
import 'package:abtxt/utils/constant.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import '../../../model/warping_design_charges_config_model.dart';
import 'package:abtxt/view/basics/warping_design_charges_config/warping_design_charges_config_controller.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDropdownSearch.dart';
import '../../../widgets/MyTextField.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';

//test
class AddWarpingDesignChargesConfig extends StatefulWidget {
  const AddWarpingDesignChargesConfig({Key? key}) : super(key: key);
  static const String routeName = '/AddWarpingDesignCharges';

  @override
  State<AddWarpingDesignChargesConfig> createState() => _State();
}

class _State extends State<AddWarpingDesignChargesConfig> {

  TextEditingController warpDesignNameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController warpTypeController = TextEditingController();
  TextEditingController lengthTypeController = TextEditingController();
  TextEditingController asthiriController = TextEditingController();
  TextEditingController designChargesController = TextEditingController();
  TextEditingController chargesPerController = TextEditingController();
  TextEditingController yarnsController = TextEditingController();

  Rxn<NewWarpModel> warpDesign = Rxn<NewWarpModel>();

  final _formKey = GlobalKey<FormState>();
  late WarpingDesignChargesConfigController controller;
  FocusNode _warpDesignFocusNode = FocusNode();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpingDesignChargesConfigController>(builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close',
            () => Get.back(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Warping Design Charges Config"),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFF9F3FF), width: 12),
              ),
              //height: Get.height,
             // margin: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        //color: Colors.green,
                        padding:  EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyAutoComplete(
                                      label: 'Warp Design',
                                      items: controller.warpDesign,
                                      selectedItem: warpDesign.value,
                                      onChanged: (NewWarpModel item) {
                                        warpDesign.value = item;
                                      },
                                    ),
                                    MyTextField(
                                      focusNode: _warpDesignFocusNode,
                                      controller: warpTypeController,
                                      hintText: "Warp Type",
                                      validate: "string",
                                      readonly: true,
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    MyTextField(
                                      controller: lengthTypeController,
                                      hintText: "Length Type",
                                      validate: "string",
                                      readonly: true,
                                    ),
                                    MyTextField(
                                      controller: asthiriController,
                                      hintText: "Asthiri",
                                      validate: 'number',
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    MyTextField(
                                      controller: designChargesController,
                                      hintText: "Design Charges (RS)",
                                      validate: "double",
                                    ),
                                    MyDropdownButtonFormField(
                                        controller: chargesPerController,
                                        hintText: "Charges Per",
                                        items: Constants.chargesPer),
                                  ],
                                ),
                                Row(
                                  children: [
                                    MyTextField(
                                      controller: yarnsController,
                                      hintText: "Yarns",
                                      validate: "string",
                                      readonly: true,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 48),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MyCloseButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Close'),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 200,
                                  child: MyElevatedButton(
                                    onPressed: () {
                                      submit();
                                    },
                                    child: Text(
                                        "${Get.arguments == null ? 'Save' : 'Update'}"),
                                  ),
                                ),
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
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "wrap_design_id": warpDesign.value?.id,
        "wrap_type": warpTypeController.text,
        "length_type": lengthTypeController.text,
        "asthiri": asthiriController.text,
        "design_changes": designChargesController.text,
        "charges_per": chargesPerController.text,
        "yarns": yarnsController.text,
      };

      print(jsonEncode(request));
      var id = idController.text;
      if (id.isEmpty) {
        // var requestPayload = DioFormData.FormData.fromMap(request);
        controller.add(request);
      } else {
        request['id'] = '$id';
        controller.edit(request);
      }
    }
  }

  void _initValue() {
    WarpingDesignChargesConfigController controller = Get.find();
    chargesPerController.text = Constants.chargesPer[0];

    if (Get.arguments != null) {
      WarpDesignChargesConfigModel warpDesignChargeDetails =
          Get.arguments['item'];
      idController.text = '${warpDesignChargeDetails.id}';

      var wrapDesignId = controller.warpDesign
          .where((element) =>
              '${element.id}' == '${warpDesignChargeDetails.wrapDesignId}')
          .toList();
      if (wrapDesignId.isNotEmpty) {
        warpDesign.value = wrapDesignId.first;
        warpDesignNameController.text = '${wrapDesignId.first.warpName}';
      }

      warpTypeController.text = '${warpDesignChargeDetails.wrapType}';
      lengthTypeController.text = '${warpDesignChargeDetails.lengthType}';
      asthiriController.text = '${warpDesignChargeDetails.asthiri}';
      designChargesController.text = '${warpDesignChargeDetails.designChanges}';
      chargesPerController.text = '${warpDesignChargeDetails.chargesPer}';
      yarnsController.text = '${warpDesignChargeDetails.yarns}';
    }
  }
}
