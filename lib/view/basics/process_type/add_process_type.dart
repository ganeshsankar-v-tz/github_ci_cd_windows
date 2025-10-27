import 'package:abtxt/view/basics/process_type/process_type_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class AddProcessType extends StatefulWidget {
  const AddProcessType({super.key});

  static const String routeName = '/AddProcessType';

  @override
  State<AddProcessType> createState() => _State();
}

class _State extends State<AddProcessType> {
  TextEditingController idController = TextEditingController();
  TextEditingController processTypeController = TextEditingController();
  TextEditingController activeController = TextEditingController(text: "Yes");

  final _formKey = GlobalKey<FormState>();
  ProcessTypeController controller = Get.find();
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
    return GetBuilder<ProcessTypeController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Process Type"),
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
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
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
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
              ),
              child: Form(
                key: _formKey,
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
                          focusNode: _firstInputFocusNode,
                          controller: processTypeController,
                          hintText: "Process Type",
                          validate: "string",
                        ),
                        MyDropdownButtonFormField(
                          controller: activeController,
                          hintText: "Is Active",
                          items: const ["Yes", "No"],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        MySubmitButton(
                          onPressed:
                              controller.status.isLoading ? null : submit,
                        ),
                      ],
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
        "process_type": processTypeController.text,
        "is_active": activeController.text,
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
      var item = Get.arguments['item'];
      idController.text = "${item['id']}";
      processTypeController.text = item['process_type'];
      activeController.text = item['is_active'];
    }
  }
}
