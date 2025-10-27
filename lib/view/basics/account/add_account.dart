import 'package:abtxt/view/basics/account/account_controller.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../model/AccountTypeModel.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({Key? key}) : super(key: key);
  static const String routeName = '/AddAccount';

  @override
  State<AddAccount> createState() => _State();
}

class _State extends State<AddAccount> {
  TextEditingController idController = TextEditingController();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController aliasController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late AccountController controller;
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
    return GetBuilder<AccountController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar:  AppBar(
          title: Text("${idController.text == '' ? 'Add' : 'Update'} Account"),
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
        // bindings:  {
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () => Get.back(),
        //   const SingleActivator(LogicalKeyboardKey.keyS, control: true): () => submit(),
        // },
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ,control: true): GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS,control: true): SaveIntent(),
        },
        loadingStatus: controller.status.isLoading,
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
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                //height: Get.height,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Form(
                        key: _formKey,
                        child: Container(
                          //color: Colors.green,
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
                                    controller: accountTypeController,
                                    hintText: "Account Type",
                                    validate: "string",
                                    focusNode: _firstInputFocusNode,
                                  ),
                                  MyTextField(
                                    controller: aliasController,
                                    hintText: "Alias",
                                    // validate: "string",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                 /* MyCloseButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Close'),
                                  ),
                                  const SizedBox(width: 12),*/
                                  MySubmitButton(
                                    onPressed: controller.status.isLoading ? null : submit,
                                   // child: Text("${Get.arguments == null ? 'Save' : 'Update'}"),
                                  ),
                                ],
                              ),
                            ],
                          ),
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

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "name": accountTypeController.text,
        "alias": aliasController.text,
      };

      print(request);
      var id = idController.text;
      if (id.isEmpty) {
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.addAccount(requestPayload);
      } else {
        request['id'] = '$id';
        controller.updateAccount(request);
      }

      print(request);
    }
  }

  void _initValue() {
    AccountController controller = Get.find();
    controller.request = <String, dynamic>{};


    if (Get.arguments != null) {
      var data = AccountTypeModel.fromJson(Get.arguments['item']);
      idController.text = '${data.id}';
      accountTypeController.text = '${data.name}';
      aliasController.text = data.alias ?? '';
    }
  }
}
