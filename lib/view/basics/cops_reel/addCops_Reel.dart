import 'package:abtxt/model/CopsReelModel.dart';
import 'package:abtxt/utils/constant.dart';
import 'package:abtxt/view/basics/cops_reel/cops_reel_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class AddCops_Reel extends StatefulWidget {
  const AddCops_Reel({Key? key}) : super(key: key);
  static const String routeName = '/AddCops_Reel';

  @override
  State<AddCops_Reel> createState() => _State();
}

class _State extends State<AddCops_Reel> {
  TextEditingController idController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController activeController = TextEditingController(text: 'Yes');
  TextEditingController wightController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late CopsReelController controller;
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
    return GetBuilder<CopsReelController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title:
              Text("${idController.text == '' ? 'Add' : 'Update'} Cops / Reel"),
          actions: [
            Visibility(
                visible: idController.text.isNotEmpty,
                child: MyDeleteIconButton(
                  onPressed: (password) {
                    controller.delete(idController.text, password);
                  },
                )),
            const SizedBox(width: 12),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ,control: true): GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS,control: true): SaveIntent(),
        },
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
                                    controller: typeController,
                                    hintText: "Type",
                                    validate: "string",
                                    focusNode: _firstInputFocusNode,
                                  ),
                                  MyTextField(
                                    controller: nameController,
                                    hintText: "Name",
                                    validate: "string",
                                  ),
                                  MyTextField(
                                    controller: wightController,
                                    hintText: "Weight in Grams",
                                    validate: "number",
                                  ),
                                  MyTextField(
                                    controller: detailsController,
                                    hintText: "Details",
                                  ),
                                  MyDropdownButtonFormField(
                                    controller: activeController,
                                    hintText: "Is Active",
                                    items: Constants.ISACTIVE,
                                  ),
                                ],
                              ),
                              SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MySubmitButton(
                                    onPressed: controller.status.isLoading ? null : submit,
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
      Map<String, dynamic> request = {
        "type": typeController.text,
        "name": nameController.text,
        "weight": int.tryParse(wightController.text) ?? 0,
        "is_active": activeController.text,
        "details": detailsController.text ?? '',
      };
      var id = idController.text;
      if (id.isEmpty) {
        controller.addCopsreel(request);
      } else {
        controller.updateCopReels(request, id);
      }
    }
  }

  void _initValue() {
    CopsReelController controller = Get.find();
    controller.request = <String, dynamic>{};

    if (Get.arguments != null) {
      var item = CopsReelModel.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      typeController.text = '${item.type}';
      nameController.text = '${item.name}';
      wightController.text = '${item.weight}';
      detailsController.text = item.details ?? '';
      activeController.text = '${item.isActive}';
    }
  }
}
