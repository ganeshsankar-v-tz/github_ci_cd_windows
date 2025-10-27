import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/WindingYarnConversationModel.dart';
import '../../../model/YarnModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../yarn/add_yarn.dart';
import 'winding_yarn_coversation_controller.dart';

class AddWindingYarnConversation extends StatefulWidget {
  const AddWindingYarnConversation({super.key});

  static const String routeName = '/AddWindingYarn';

  @override
  State<AddWindingYarnConversation> createState() => _State();
}

class _State extends State<AddWindingYarnConversation> {
  TextEditingController idController = TextEditingController();

  Rxn<YarnModel> fromYarnName = Rxn<YarnModel>();
  TextEditingController fromYarnNameController = TextEditingController();

  TextEditingController fromQtyController = TextEditingController();

  Rxn<YarnModel> toYarnName = Rxn<YarnModel>();
  TextEditingController toYarnNameController = TextEditingController();
  TextEditingController toQtyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late WindingYarnConversationController controller;
  var fromYarnList = <dynamic>[].obs;

  final FocusNode _fromQtyFocusNode = FocusNode();
  final FocusNode _toQtyFocusNode = FocusNode();
  final FocusNode _yarnNameFocusNode = FocusNode();
  var shortCut = RxString("");

  RxBool isUpdate = RxBool(false);

  @override
  void initState() {
    _yarnNameFocusNode.addListener(() => shortCutKeys());
    _initValue();
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null) {
        FocusScope.of(context).requestFocus(_fromQtyFocusNode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WindingYarnConversationController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Winding Yarn Conversations"),
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
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
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
            NavigateIntent: SetCounterAction(perform: () {
              navigateAnotherPage();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Focus(
                            focusNode: _yarnNameFocusNode,
                            skipTraversal: true,
                            child: MyAutoComplete(
                              label: 'From Yarn Name',
                              items: controller.fromYarns,
                              selectedItem: fromYarnName.value,
                              enabled: !isUpdate.value,
                              onChanged: (YarnModel item) {
                                fromYarnName.value = item;
                              },
                            ),
                          ),
                          Focus(
                            skipTraversal: true,
                            child: MyTextField(
                              focusNode: _fromQtyFocusNode,
                              controller: fromQtyController,
                              hintText: "From Yarn Quantity",
                              validate: "double",
                              suffix: Obx(
                                () => Text(
                                  fromYarnName.value?.unitName ?? "Unit",
                                ),
                              ),
                            ),
                            onFocusChange: (hasFocus) {
                              AppUtils.fractionDigitsText(fromQtyController);
                            },
                          ),
                          Focus(
                            focusNode: _yarnNameFocusNode,
                            skipTraversal: true,
                            child: MyAutoComplete(
                              label: 'To Yarn Name',
                              items: controller.fromYarns,
                              selectedItem: toYarnName.value,
                              enabled: !isUpdate.value,
                              onChanged: (YarnModel item) {
                                toYarnName.value = item;
                              },
                            ),
                          ),
                          Focus(
                            skipTraversal: true,
                            child: MyTextField(
                              focusNode: _toQtyFocusNode,
                              controller: toQtyController,
                              hintText: "To Yarn Quantity",
                              validate: "double",
                              suffix: Obx(
                                () => Text(
                                  toYarnName.value?.unitName ?? "Unit",
                                ),
                              ),
                            ),
                            onFocusChange: (hasFocus) {
                              AppUtils.fractionDigitsText(toQtyController);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         /* crateAndUpdatedBy(),
                          const Spacer(),*/
                          Obx(
                            () => Text(shortCut.value,
                                style: AppUtils.shortCutTextStyle()),
                          ),
                          const SizedBox(width: 12),
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
          ),
        ),
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "from_yarn_id": fromYarnName.value?.id,
        "from_qty": double.tryParse(fromQtyController.text) ?? 0.00,
        "to_yarn_id": toYarnName.value?.id,
        "to_qty": double.tryParse(toQtyController.text) ?? 0.00,
      };

      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        controller.addNewWindingYarn(request);
      } else {
        request['id'] = id;
        controller.updateNewWindingYarn(request, id);
      }
    }
  }

  shortCutKeys() {
    if (_yarnNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Yarn',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_yarnNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddYarn.routeName);

      if (result == "success") {
        controller.fromYarnInfo();
      }
    }
  }

  void _initValue() {
    WindingYarnConversationController controller = Get.find();
    controller.request = <String, dynamic>{};

    if (Get.arguments != null) {
      isUpdate.value = true;
      var winder = WindingYarnConversationModel.fromJson(Get.arguments['item']);
      idController.text = '${winder.id}';

      var yarnIdFrom = controller.fromYarns
          .where((element) => '${element.id}' == '${winder.fromYarnId}')
          .toList();
      if (yarnIdFrom.isNotEmpty) {
        fromYarnName.value = yarnIdFrom.first;
      }
      var yarnIdTo = controller.fromYarns
          .where((element) => '${element.id}' == '${winder.toYarnId}')
          .toList();
      if (yarnIdTo.isNotEmpty) {
        toYarnName.value = yarnIdTo.first;
      }

      fromQtyController.text = '${winder.fromQty}';
      toQtyController.text = '${winder.toQty}';
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
