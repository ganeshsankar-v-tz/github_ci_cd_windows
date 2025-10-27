import 'package:abtxt/widgets/MyFilterTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../flutter_core_widget.dart';
import '../../../../../model/FirmModel.dart';
import '../../../../../widgets/MyDropdownButtonFormField.dart';
import '../../../../../widgets/MyTextField.dart';
import '../../../../../widgets/my_search_field/my_search_field.dart';
import '../baking_report_controller.dart';

class CompletedListFilter extends StatefulWidget {
  const CompletedListFilter({super.key});

  @override
  State<CompletedListFilter> createState() => _CompletedListFilterState();
}

class _CompletedListFilterState extends State<CompletedListFilter> {
  BankingReportController controller = Get.put(BankingReportController());
  final formKey = GlobalKey<FormState>();

  Rxn<FirmModel> firmNameController = Rxn<FirmModel>();
  TextEditingController firmTextController = TextEditingController();
  TextEditingController chequeDateController = TextEditingController();
  TextEditingController chequeNoController = TextEditingController();
  TextEditingController bankNameController = TextEditingController(text: 'TMB');
  TextEditingController branchNameController =
  TextEditingController(text: "Elampillai");

  final FocusNode _firmFocusNode = FocusNode();
  final FocusNode _bankCheckBoxFocusNode = FocusNode();

  RxBool branchC = RxBool(false);
  RxBool bankNameC = RxBool(false);
  RxBool chequeNoC = RxBool(false);
  RxBool firmIdC = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankingReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
              key: formKey,
              child: SizedBox(
                width: 580,
                height: 350,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                            () =>
                            SizedBox(
                              width: 325,
                              child: ListTile(
                                leading: Checkbox(
                                  value: firmIdC.value,
                                  onChanged: (value) => firmIdC.value = value!,
                                ),
                                subtitle: MySearchField(
                                  label: "Firm",
                                  items: controller.firmDropdown,
                                  textController: firmTextController,
                                  focusNode: _firmFocusNode,
                                  requestFocus: _bankCheckBoxFocusNode,
                                  isValidate: firmIdC.value ? true : false,
                                  onChanged: (FirmModel item) {
                                    firmIdC.value = true;
                                    firmNameController.value = item;
                                  },
                                ),
                              ),
                            ),
                      ),
                      Obx(
                            () =>
                            SizedBox(
                              width: 325,
                              child: ListTile(
                                leading: Checkbox(
                                  focusNode: _bankCheckBoxFocusNode,
                                  value: bankNameC.value,
                                  onChanged: (value) =>
                                  bankNameC.value = value!,
                                ),
                                subtitle: MyDropdownButtonFormField(
                                  hintText: "Bank Name",
                                  controller: bankNameController,
                                  items: const [
                                    "TMB",
                                    "ICICI",
                                    "CANARA",
                                    "AXIS"
                                  ],
                                  onChanged: (value) {
                                    bankNameC.value = true;
                                  },
                                ),
                              ),
                            ),
                      ),
                      Obx(
                            () =>
                            SizedBox(
                              width: 325,
                              child: ListTile(
                                leading: Checkbox(
                                  value: branchC.value,
                                  onChanged: (value) => branchC.value = value!,
                                ),
                                subtitle: MyTextField(
                                  controller: branchNameController,
                                  hintText: "Branch Name",
                                  validate: branchC.value ? "string" : "",
                                  enabled: false,
                                ),
                              ),
                            ),
                      ),
                      Obx(
                            () =>
                            SizedBox(
                              width: 325,
                              child: ListTile(
                                leading: Checkbox(
                                  value: chequeNoC.value,
                                  onChanged: (value) =>
                                  chequeNoC.value = value!,
                                ),
                                subtitle: MyFilterTextField(
                                  controller: chequeNoController,
                                  hintText: "Cheque No",
                                  validate: chequeNoC.value ? "string" : "",
                                  onChanged: (value){
                                    chequeNoC.value = true;
                                  },
                                ),
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              )),
          actions: <Widget>[
            TextButton(onPressed: () => Get.back(), child: const Text("Close")),
            TextButton(
              child: const Text('Apply'),
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                var request = {};

                if (firmIdC.value == true) {
                  request["firm_id"] = firmNameController.value?.id;
                }

                if (bankNameC.value == true) {
                  request["bank_name"] = bankNameController.text;
                }

                if (branchC.value == true) {
                  request["branch_name"] = branchNameController.text;
                }

                if (chequeNoC.value == true) {
                  request["cheque_no"] = chequeNoController.text;
                }

                Get.back(result: controller.completedFilterData = request);
              },
            ),
          ],
        ),
      );
    });
  }
}
