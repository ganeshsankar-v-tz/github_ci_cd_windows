import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/NewColorModel.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import 'new_color_controller.dart';

class AddNewColor extends StatefulWidget {
  const AddNewColor({Key? key}) : super(key: key);
  static const String routeName = '/addcolor';

  @override
  State<AddNewColor> createState() => _State();
}

class _State extends State<AddNewColor> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController llnameController = TextEditingController();
  TextEditingController activeController = TextEditingController();
  var hex = "#fffafafa".obs;

  //var hex = HexColor('#aabbcc').obs;

  final _formKey = GlobalKey<FormState>();
  late NewColorController controller;
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
    return GetBuilder<NewColorController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title:
              Text("${idController.text == '' ? 'Add' : 'Update'} New Color"),
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
        // bindings: {
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
        //       Get.back(),
        //   const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
        //       submit(),
        // },
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
                                    controller: nameController,
                                    hintText: "Color Name",
                                    validate: "string",
                                    focusNode: _firstInputFocusNode,
                                  ),
                                  /*InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Pick a color!'),
                                              content: SingleChildScrollView(
                                                child: ColorPicker(
                                                  pickerColor: Colors.red,
                                                  onColorChanged:
                                                      (Color color) {
                                                    hex.value =
                                                        '#${color.value.toRadixString(16)}';
                                                  },
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Obx(
                                      () => Container(
                                        margin: const EdgeInsets.all(8),
                                        color: HexColor('${hex.value}'),
                                        height: 42,
                                        width: 42,
                                        child: const Icon(
                                          Icons.colorize,
                                          color: Colors.black38,
                                        ),
                                      ),
                                    ),
                                  ),*/
                                  MyTextField(
                                    controller: llnameController,
                                    hintText: "L.L Name",
                                  ),
                                  MyDropdownButtonFormField(
                                    controller: activeController,
                                    hintText: "Is Active",
                                    items: const ['Yes', 'No'],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                 /* crateAndUpdatedBy(),
                                  const Spacer(),*/
                                  MySubmitButton(
                                    onPressed: controller.status.isLoading ? null : submit,
                                  ),
                                 /* const Spacer(),*/
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
        "name": nameController.text,
        "ll_name": llnameController.text,
        "hex_code": hex.value,
        "is_active": activeController.text,
      };
      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        controller.addColor(request);
      } else {
        request['id'] = id;
        controller.edit(request);
      }
    }
  }

  void _initValue() {
    NewColorController controller = Get.find();
    controller.request = <String, dynamic>{};
    activeController.text = 'Yes';

    if (Get.arguments != null) {
      var data = NewColorModel.fromJson(Get.arguments['item']);
      idController.text = '${data.id}';
      nameController.text = '${data.name}';
      activeController.text = '${data.isActive}';
      llnameController.text = tryCast(data.llName);
      hex.value = '${data.hexCode}';
    }
  }

 /* Widget crateAndUpdatedBy() {
    String id = idController.text;
    String formattedDate = AppUtils.dateFormatter.format(DateTime.now());
    String? createdAt;
    String? updatedAt;
    String? entryBy;

    if (Get.arguments != null) {
      var item = Get.arguments["item"];
      DateTime createDate = DateTime.parse(item["created_at"] ?? "0000-00-00");
      DateTime updateDate = DateTime.parse(item["updated_at"] ?? "0000-00-00");
      createdAt = AppUtils.dateFormatter.format(createDate);
      updatedAt = AppUtils.dateFormatter.format(updateDate);

      entryBy = item["creator_name"] ?? '';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          id.isEmpty ? AppUtils().loginName : "$entryBy",
          style: AppUtils.updateAndCreateTextStyle(),
        ),
        const SizedBox(width: 12),
        Text(
          id.isEmpty ? formattedDate : "${updatedAt ?? createdAt}",
          style: AppUtils.updateAndCreateTextStyle(),
        )
      ],
    );
  }*/
}
