import 'package:abtxt/model/saree_checker/SareeCheckerModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/warp_checker/warp_checker_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class AddWarpChecker extends StatefulWidget {
  const AddWarpChecker({super.key});

  static const String routeName = '/add_warp_checker';

  @override
  State<AddWarpChecker> createState() => _State();
}

class _State extends State<AddWarpChecker> {
  TextEditingController idController = TextEditingController();
  TextEditingController checkerNameController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController cellNoController = TextEditingController();
  TextEditingController isActiveController = TextEditingController(text: "Yes");

  final _formKey = GlobalKey<FormState>();
  WarpCheckerController controller = Get.find();
  final FocusNode _firstInputFocusNode = FocusNode();
  RxBool isUpdate = RxBool(false);

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
    return GetBuilder<WarpCheckerController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Warp Checker"),
          actions: [
            Visibility(
              visible: false,
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
            GetBackIntent: SetCounterAction(perform: () => Get.back()),
            SaveIntent: SetCounterAction(perform: () => submit()),
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
                            controller: checkerNameController,
                            hintText: "Checker Name",
                            validate: "string",
                            enabled: !isUpdate.value,
                            focusNode: _firstInputFocusNode,
                          ),
                          /*MyTextField(
                            controller: areaController,
                            hintText: "Area",
                            validate: "",
                          ),
                          MyTextField(
                            controller: cellNoController,
                            hintText: "Cell No",
                          ),*/
                          MyDropdownButtonFormField(
                            controller: isActiveController,
                            hintText: "Is Active",
                            items: const ["Yes", "No"],
                          )
                        ],
                      ),
                      const SizedBox(height: 22),
                      Align(
                        alignment: Alignment.center,
                        child: MySubmitButton(
                          onPressed:
                              controller.status.isLoading ? null : submit,
                        ),
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
        "checker_name": checkerNameController.text,
        "area": areaController.text,
        "cell_no": cellNoController.text,
        "is_active": isActiveController.text,
      };

      var id = idController.text;
      if (id.isEmpty) {
        controller.add(request);
      } else {
        request['id'] = id;
        controller.edit(request, id);
      }
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      SareeCheckerModel item = Get.arguments["item"];
      isUpdate.value = true;
      idController.text = "${item.id}";
      checkerNameController.text = "${item.checkerName}";
      areaController.text = tryCast(item.area);
      cellNoController.text = item.cellNo ?? "";
      isActiveController.text = "${item.isActive}";
    }
  }
}
