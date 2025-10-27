import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/view/trasaction/jari_twisting_yarn_inward_v2/add_jari_twisting_yarn_inward_V2.dart';
import 'package:abtxt/widgets/MyAddButton.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../utils/app_utils.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/my_search_field/my_search_field.dart';
import 'jari_twisting_yarn_inward_controller_v2.dart';

class JariTwistingYarnInwardBottomSheetV2 extends StatefulWidget {
  final OperatorsItemDataSource dataGridSource;
  final List<dynamic> itemDetails;
  final Function amountCalculation;

  const JariTwistingYarnInwardBottomSheetV2({
    super.key,
    required this.dataGridSource,
    required this.itemDetails,
    required this.amountCalculation,
  });

  @override
  State<JariTwistingYarnInwardBottomSheetV2> createState() => _State();
}

class _State extends State<JariTwistingYarnInwardBottomSheetV2> {
  Rxn<LedgerModel> operatorNameController = Rxn<LedgerModel>();
  TextEditingController operatorNameTextController = TextEditingController();
  TextEditingController hoursController = TextEditingController(text: "0.00");
  TextEditingController kgController = TextEditingController(text: "0.00");
  TextEditingController lotController = TextEditingController(text: "0");
  TextEditingController meterController = TextEditingController(text: "0.000");

  TextEditingController wagesController = TextEditingController(text: "0.00");
  TextEditingController detailsController = TextEditingController();

  JariTwistingYarnInwardControllerV2 controller = Get.find();

  final _formKey = GlobalKey<FormState>();

  final FocusNode _processTypeFocusNode = FocusNode();
  final FocusNode _hoursFocusNode = FocusNode();
  final FocusNode _kgFocusNode = FocusNode();
  final FocusNode _lotFocusNode = FocusNode();
  final FocusNode _meterFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JariTwistingYarnInwardControllerV2>(
        builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(title: const Text('Add Operators')),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true):
              NavigateAnotherPageIntent(),
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        MySearchField(
                          setInitialValue: false,
                          label: 'Operator Name',
                          items: controller.operatorDetails,
                          textController: operatorNameTextController,
                          focusNode: _processTypeFocusNode,
                          requestFocus: _processTypeFocusNode,
                          onChanged: (LedgerModel item) async {
                            operatorNameController.value = item;
                          },
                        ),
                        ExcludeFocusTraversal(
                          child: OutlinedButton(
                            onPressed: () => operatorAddDialog(),
                            style: ButtonStyle(
                              minimumSize:
                                  WidgetStateProperty.all(const Size(50, 46)),
                              foregroundColor: WidgetStateProperty.resolveWith(
                                  (states) => Colors.white),
                              shape: WidgetStateProperty.resolveWith((s) =>
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(4.0))),
                              backgroundColor:
                                  WidgetStateProperty.resolveWith((states) {
                                return const Color(0xff28C600);
                              }),
                            ),
                            child: const Icon(Icons.add),
                          ),
                        )
                      ],
                    ),
                    Wrap(
                      children: [
                        Obx(() => wagsType(controller.wagesType.value)),
                        MyTextField(
                          enabled: false,
                          controller: wagesController,
                          hintText: "Wages",
                          validate: "double",
                        ),
                      ],
                    ),
                    MyTextField(
                      controller: detailsController,
                      hintText: "Details",
                    ),
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerRight,
                      child: MyAddButton(
                        onPressed: () => submit(),
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

  Widget wagsType(String option) {
    return GetBuilder<JariTwistingYarnInwardControllerV2>(
      builder: (controller) {
        if (option == "Time") {
          return Focus(
            skipTraversal: true,
            child: MyTextField(
              width: 150,
              focusNode: _hoursFocusNode,
              controller: hoursController,
              hintText: "Time",
              validate: "double",
              onChanged: (value) => _calculate(),
              suffix: const Text(
                "Hour",
                style: TextStyle(color: Color(0XFF5700BC)),
              ),
            ),
            onFocusChange: (hasFocus) {
              AppUtils.fractionDigitsText(
                hoursController,
                fractionDigits: 2,
              );
            },
          );
        } else if (option == "Kg") {
          return Focus(
            skipTraversal: true,
            child: MyTextField(
              width: 150,
              focusNode: _kgFocusNode,
              controller: kgController,
              hintText: "Kg",
              validate: "double",
              onChanged: (value) => _calculate(),
              suffix: const Text(
                "Kg",
                style: TextStyle(color: Color(0XFF5700BC)),
              ),
            ),
            onFocusChange: (hasFocus) {
              AppUtils.fractionDigitsText(
                kgController,
                fractionDigits: 2,
              );
            },
          );
        } else if (option == "Lot") {
          return MyTextField(
            width: 150,
            focusNode: _lotFocusNode,
            controller: lotController,
            hintText: "Lot",
            validate: "number",
            onChanged: (value) => _calculate(),
          );
        } else if (option == "Meter") {
          return Focus(
            skipTraversal: true,
            child: MyTextField(
              width: 150,
              focusNode: _meterFocusNode,
              controller: meterController,
              hintText: "Meter",
              validate: "double",
              onChanged: (value) => _calculate(),
            ),
            onFocusChange: (hasFocus) {
              AppUtils.fractionDigitsText(
                meterController,
                fractionDigits: 3,
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  operatorAddDialog() {
    TextEditingController operatorNameController = TextEditingController();
    TextEditingController phoneNoController = TextEditingController();
    TextEditingController shortCodeController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Center(
            child: Text(
              "CREATE OPERATOR",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          content: SizedBox(
            height: 300,
            width: 350,
            child: Column(
              children: [
                const SizedBox(height: 12),
                MyTextField(
                  autofocus: true,
                  controller: operatorNameController,
                  hintText: "Operator Name",
                  validate: "string",
                ),
                const SizedBox(height: 12),
                MyTextField(
                  controller: phoneNoController,
                  hintText: "Phone No",
                  inputType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                MyTextField(
                  controller: shortCodeController,
                  hintText: "Short Code",
                ),
              ],
            ),
          ),
          actions: [
            MySubmitButton(
              message: "",
              onPressed: () async {
                var request = {
                  "ledger_name": operatorNameController.text,
                  "operator": "Yes",
                  "short_code": shortCodeController.text,
                  "is_active": "Yes",
                  "accout_type": "Sundry Creditors"
                };
                var requestPayload = DioFormData.FormData.fromMap(request);
                var result = await controller.addNewOperator(requestPayload);

                if (result == "success") {
                  controller.operatorInfo();
                }
              },
            ),
            OutlinedButton(
              onPressed: () => Get.back(),
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(const Size(180, 46)),
                foregroundColor:
                    WidgetStateProperty.resolveWith((states) => Colors.black26),
                shape: WidgetStateProperty.resolveWith((s) =>
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0))),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  return const Color(0xffE3E3E3);
                }),
              ),
              child: const Text(
                "CLOSE",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        );
      },
    );
  }

  _calculate() {
    double wages = controller.wages.value;

    double time = double.tryParse(hoursController.text) ?? 0.0;
    double kg = double.tryParse(kgController.text) ?? 0.0;
    int lot = int.tryParse(lotController.text) ?? 0;
    double meter = double.tryParse(meterController.text) ?? 0.0;

    double totalWages = 0.0;
    if (controller.wagesType.value == "Time") {
      totalWages = wages * time;
      wagesController.text = totalWages.toStringAsFixed(2);
    } else if (controller.wagesType.value == "Kg") {
      totalWages = wages * kg;
      wagesController.text = totalWages.toStringAsFixed(2);
    } else if (controller.wagesType.value == "Lot") {
      totalWages = wages * lot;
      wagesController.text = totalWages.toStringAsFixed(2);
    } else {
      totalWages = wages * meter;
      wagesController.text = totalWages.toStringAsFixed(2);
    }
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      if (operatorNameController.value == null) {
        return AppUtils.infoAlert(message: "Select the operator name");
      }

      for (var e in widget.itemDetails) {
        if (e["operator_id"] == operatorNameController.value?.id) {
          return AppUtils.infoAlert(message: "This operator already added");
        }
      }

      var request = {
        "operator_id": operatorNameController.value?.id,
        "operator_name": operatorNameController.value?.ledgerName,
        "wages": double.tryParse(wagesController.text) ?? 0.00,
        "details": detailsController.text
      };

      if (controller.wagesType.value == "Time") {
        request["hours"] = double.tryParse(hoursController.text) ?? 0.0;
      } else if (controller.wagesType.value == "Kg") {
        request["weight"] = double.tryParse(kgController.text) ?? 0.0;
      } else if (controller.wagesType.value == "Lot") {
        request["lots"] = int.tryParse(lotController.text) ?? 0;
      } else {
        request["meter"] = double.tryParse(wagesController.text) ?? 0.0;
      }

      // return print(request);
      widget.itemDetails.add(request);
      widget.dataGridSource.updateDataGridRows();
      widget.dataGridSource.updateDataGridSource();
      widget.amountCalculation();
      controllerClear();
    }
  }

  controllerClear() {
    operatorNameController.value = null;
    operatorNameTextController.text = "";
    hoursController.text = "0.00";
    kgController.text = "0.00";
    meterController.text = "0.000";
    lotController.text = "0";
    wagesController.text = "0.00";
    detailsController.text = "";

    FocusScope.of(context).requestFocus(_processTypeFocusNode);
  }
}
