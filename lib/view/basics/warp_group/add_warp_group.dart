import 'package:abtxt/model/WarpGroupModel.dart';
import 'package:abtxt/view/basics/warp_group/warp_group_controller.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class AddWarpGroup extends StatefulWidget {
  const AddWarpGroup({super.key});

  static const String routeName = '/add_warp_group';

  @override
  State<AddWarpGroup> createState() => _State();
}

class _State extends State<AddWarpGroup> {
  TextEditingController idController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  TextEditingController isActiveController = TextEditingController(text: "Yes");

  final _formKey = GlobalKey<FormState>();
  late WarpGroupController controller;
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
    return GetBuilder<WarpGroupController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title:
              Text("${idController.text == '' ? 'Add' : 'Update'} Warp Group"),
          actions: [
            Visibility(
              visible: idController.text.isNotEmpty,
              child: MyDeleteIconButton(
                onPressed: (password) =>
                    controller.delete(idController.text, password),
              ),
            ),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
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
                              validate: "",
                              enabled: false,
                            ),
                          ),
                          MyTextField(
                            controller: groupNameController,
                            hintText: "Group Name",
                            validate: "string",
                            focusNode: _firstInputFocusNode,
                          ),
                          MyDropdownButtonFormField(
                            controller: isActiveController,
                            hintText: "Is Active ",
                            items: const ['Yes', 'No'],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MySubmitButton(
                            onPressed: controller.status.isLoading ? null : submit,
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

  submit() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "group_name": groupNameController.text,
        "is_active": isActiveController.text,
      };

      var id = idController.text;
      if (id.isEmpty) {
        controller.addNewWarp(request);
      } else {
        request['id'] = id;
        controller.updateNewWarp(request, id);
      }
    }
  }

  void _initValue() {
    WarpGroupController controller = Get.find();
    controller.request = <String, dynamic>{};

    if (Get.arguments != null) {
      var warp = WarpGroupModel.fromJson(Get.arguments['item']);
      idController.text = '${warp.id}';
      groupNameController.text = '${warp.groupName}';
      isActiveController.text = '${warp.isActive}';
    }
  }
}
