import 'package:abtxt/view/report/finance/tds_report/tds_amount_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../flutter_core_widget.dart';
import '../../../../../model/FirmModel.dart';
import '../../../../../widgets/MyDropdownButtonFormField.dart';
import '../../../../../widgets/MyTextField.dart';
import '../../../../../widgets/my_search_field/my_search_field.dart';
import '../../../../widgets/MyDateFilter.dart';

class TdsBankingDetailsFilter extends StatefulWidget {
  const TdsBankingDetailsFilter({super.key});

  @override
  State<TdsBankingDetailsFilter> createState() =>
      _TdsBankingDetailsFilterState();
}

class _TdsBankingDetailsFilterState extends State<TdsBankingDetailsFilter> {
  TdsAmountReportController controller = Get.put(TdsAmountReportController());
  final formKey = GlobalKey<FormState>();

  var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  Rxn<FirmModel> firmNameController = Rxn<FirmModel>();
  TextEditingController firmTextController = TextEditingController();
  TextEditingController chequeDateController = TextEditingController();
  TextEditingController chequeNoController = TextEditingController();
  TextEditingController bankNameController = TextEditingController(text: 'TMB');
  TextEditingController branchNameController =
      TextEditingController(text: "Elampillai");

  final FocusNode _firmFocusNode = FocusNode();
  final FocusNode _bankCheckBoxFocusNode = FocusNode();

  RxBool dateC = RxBool(true);
  RxBool branchC = RxBool(false);
  RxBool bankNameC = RxBool(false);
  RxBool chequeNoC = RxBool(false);
  RxBool firmIdC = RxBool(false);

  @override
  void initState() {
    fromDateController.text = "$today";
    toDateController.text = "$today";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TdsAmountReportController>(builder: (controller) {
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
                height: 400,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Checkbox(
                          value: dateC.value,
                          onChanged: (value) => dateC.value = value!,
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              children: [
                                MyDateFilter(
                                  controller: fromDateController,
                                  labelText: "From Date",
                                  required: dateC.value,
                                  autofocus: true,
                                ),
                                // SizedBox(width: 4),
                                MyDateFilter(
                                  controller: toDateController,
                                  labelText: "To Date",
                                  required: dateC.value,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => SizedBox(
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
                                firmNameController.value = item;
                                firmIdC.value = true;
                              },
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => SizedBox(
                          width: 325,
                          child: ListTile(
                            leading: Checkbox(
                              focusNode: _bankCheckBoxFocusNode,
                              value: bankNameC.value,
                              onChanged: (value) => bankNameC.value = value!,
                            ),
                            subtitle: MyDropdownButtonFormField(
                              hintText: "Bank Name",
                              controller: bankNameController,
                              items: const ["TMB", "ICICI", "CANARA", "AXIS"],
                              onChanged: (value) {
                                bankNameC.value = true;
                              },
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => SizedBox(
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
                              onChanged: (value) {
                                branchC.value = true;
                              },
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => SizedBox(
                          width: 325,
                          child: ListTile(
                            leading: Checkbox(
                              value: chequeNoC.value,
                              onChanged: (value) => chequeNoC.value = value!,
                            ),
                            subtitle: MyTextField(
                              controller: chequeNoController,
                              hintText: "Cheque No",
                              validate: chequeNoC.value ? "string" : "",
                              onChanged: (value) {
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
                if (dateC.value == true) {
                  request['from_date'] = fromDateController.text;
                  request['to_date'] = toDateController.text;
                }

                if (firmIdC.value == true) {
                  request["firm_id"] = firmNameController.value?.id;
                }

                if (bankNameC.value == true) {
                  request["bank_name"] = bankNameController.text;
                }

                if (branchC.value == true) {
                  request["branch_no"] = branchNameController.text;
                }

                if (chequeNoC.value == true) {
                  request["cheque_no"] = chequeNoController.text;
                }

                Get.back(result: controller.filterData = request);
              },
            ),
          ],
        ),
      );
    });
  }
}
