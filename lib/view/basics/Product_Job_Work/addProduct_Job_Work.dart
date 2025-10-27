import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/Product_Job_Work/ProductJobWork_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class AddProductJobWork extends StatefulWidget {
  const AddProductJobWork({super.key});

  static const String routeName = '/AddProductJobWork';

  @override
  State<AddProductJobWork> createState() => _State();
}

class _State extends State<AddProductJobWork> {
  TextEditingController idController = TextEditingController();
  TextEditingController workNameController = TextEditingController();
  TextEditingController workTypeController =
      TextEditingController(text: "JobWork");
  TextEditingController lLNameController = TextEditingController();
  TextEditingController laborWagesController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController unitNameController =
      TextEditingController(text: "Saree");
  TextEditingController activeController = TextEditingController(text: "Yes");

  final _formKey = GlobalKey<FormState>();
  ProductJobWorkController controller = Get.find();
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
    return GetBuilder<ProductJobWorkController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Product Job Work"),
          actions: [
            Visibility(
                visible: idController.text.isNotEmpty,
                child: MyDeleteIconButton(
                  onPressed: (password) =>
                      controller.delete(idController.text, password),
                )),
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
            child: SingleChildScrollView(
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
                            Row(
                              children: [
                                Wrap(
                                  children: [
                                    MyDropdownButtonFormField(
                                      controller: workTypeController,
                                      hintText: "Work Type",
                                      items: const ["JobWork", "Process"],
                                      focusNode: _firstInputFocusNode,
                                    ),
                                    MyTextField(
                                      controller: workNameController,
                                      hintText: "Work Name",
                                      validate: "string",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Wrap(
                                  children: [
                                    MyTextField(
                                      controller: lLNameController,
                                      hintText: "L.L Name",
                                    ),
                                    Focus(
                                      skipTraversal: true,
                                      child: MyTextField(
                                        controller: laborWagesController,
                                        hintText: "Labour Wages (Rs)",
                                        validate: "double",
                                      ),
                                      onFocusChange: (hasFocus) {
                                        AppUtils.fractionDigitsText(
                                            laborWagesController,
                                            fractionDigits: 2);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Wrap(
                                  children: [
                                    MyTextField(
                                      controller: detailsController,
                                      hintText: "Details",
                                    ),
                                    MyTextField(
                                      controller: unitNameController,
                                      hintText: "Unit Name",
                                      validate: "string",
                                    ),
                                    MyDropdownButtonFormField(
                                      controller: activeController,
                                      hintText: "Is Active",
                                      items: const ["Yes", "No"],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            /*crateAndUpdatedBy(),
                            const Spacer(),*/
                            MySubmitButton(
                              onPressed: controller.status.isLoading ? null : submit,
                            ),
                           /* const Spacer(),*/
                          ],
                        ),
                      ],
                    ),
                  ),
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
        "work_typ": workTypeController.text,
        "work_name": workNameController.text,
        "ll_name": lLNameController.text,
        "labour_wages": int.tryParse(laborWagesController.text) ?? 0,
        "details": detailsController.text,
        "is_active": activeController.text,
        "unit_name": unitNameController.text,
      };

      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.addProductJobWork(requestPayload);
      } else {
        request['id'] = id;
        controller.updateProductJobWork(request, id);
      }
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      var item = Get.arguments['item'];
      idController.text = tryCast(item['id']);
      workTypeController.text = item['work_typ'] ?? 'JobWork';
      workNameController.text = item['work_name'] ?? '';
      lLNameController.text = item['ll_name'] ?? '';
      detailsController.text = item['details'] ?? '';
      activeController.text = item['is_active'] ?? 'Yes';
      laborWagesController.text = tryCast(item['labour_wages']);
    }
  }

/*
  Widget crateAndUpdatedBy() {
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
  }
*/
}
