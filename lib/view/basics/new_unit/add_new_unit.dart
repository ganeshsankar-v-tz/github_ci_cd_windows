import 'dart:convert';
import 'package:abtxt/model/NewUnitModel.dart';
import 'package:abtxt/utils/constant.dart';
import 'package:abtxt/view/basics/new_unit/new_unit_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class AddNewUnit extends StatefulWidget {
  const AddNewUnit({Key? key}) : super(key: key);
  static const String routeName = '/add_new_unit';

  @override
  State<AddNewUnit> createState() => _State();
}

class _State extends State<AddNewUnit> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController decimalCodeController = TextEditingController();
  TextEditingController IsActiveCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late NewUnitController controller;
  var decimalList = ["0", "0.0", "0.00", "0.000"];
  final FocusNode _firstInputFocusNode = FocusNode();


  @override
  void initState() {
    _initValue();
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_firstInputFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewUnitController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title: Text("${idController.text == '' ? 'Add' : 'Update'} New Unit"),
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
        // bindings: {
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
        //       Get.back(),
        //   const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
        //       submit(),
        // },
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ,control: true): GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS,control: true): SaveIntent(),
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
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Form(
                        key: _formKey,
                        child: Container(
                          //color: Colors.green,
                          padding: EdgeInsets.all(16),
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
                                      // validate: "",
                                      enabled: false,
                                    ),
                                  ),
                                  MyTextField(
                                    controller: nameController,
                                    hintText: "Unit",
                                    validate: "string",
                                    focusNode: _firstInputFocusNode,
                                  ),
                                  MyDropdownButtonFormField(
                                    controller: decimalCodeController,
                                    hintText: "Decimal",
                                    items: decimalList,
                                  ),
                                  MyDropdownButtonFormField(
                                      controller: IsActiveCodeController,
                                      hintText: "Is Active",
                                      items: Constants.newUnitActiveStatus),
                                ],
                              ),
                              SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                 /* MyCloseButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Close'),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),*/
                                  MySubmitButton(
                                    onPressed: controller.status.isLoading ? null : submit,
                                    //child: Text("${Get.arguments == null ? 'Save' : 'Update'}"),
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
        ),
      );
    });
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      var data = "";
      for (int i = 0; i < decimalList.length; i++) {
        if (decimalList[i] == decimalCodeController.text) {
          data = "$i";
          break; // Exit the loop once the value is found
        }
      }

      Map<String, dynamic> request = {
        "unit_name": nameController.text,
        "decimal": data,
        "active_status": IsActiveCodeController.text
      };
      print(jsonEncode(request));
      var id = idController.text;
      if (id.isEmpty) {
        // var requestPayload = DioFormData.FormData.fromMap(request);
        controller.addUnit(request);
      } else {
        request['id'] = '$id';
        controller.editUnit(request);
      }
    }
  }

  void _initValue() {
    NewUnitController controller = Get.find();
    controller.request = <String, dynamic>{};
    decimalCodeController.text = Constants.decimalTypes[0].toString();
    IsActiveCodeController.text = Constants.newUnitActiveStatus[0];

    if (Get.arguments != null) {
      var item = NewUnitModel.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      nameController.text = '${item.unitName}';

      for (int i = 0; i < decimalList.length; i++) {
        if ('$i' == '${item.decimal}') {
          decimalCodeController.text = decimalList[i];
          break; // Exit the loop once the value is found
        }
      }
      IsActiveCodeController.text = '${item.activeStatus}';
    }
  }
}
