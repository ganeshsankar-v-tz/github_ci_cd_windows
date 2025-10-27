import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/MachineDetailsModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MySubmitButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import 'machine_details_controller.dart';

class AddMachineDetails extends StatefulWidget {
  const AddMachineDetails({super.key});

  static const String routeName = '/addmachine_details';

  @override
  State<AddMachineDetails> createState() => _AddMachineDetailsState();
}

class _AddMachineDetailsState extends State<AddMachineDetails> {
  MachineDetailsController controller = Get.find();
  TextEditingController idController = TextEditingController();
  TextEditingController machineNameController = TextEditingController();
  TextEditingController wagesTypeController =
      TextEditingController(text: "Time");
  TextEditingController wagesController = TextEditingController(text: "0.00");
  TextEditingController machineTypeController =
      TextEditingController(text: "Winder");
  TextEditingController windingTypeController =
      TextEditingController(text: "Cone Winding");

  // tfo
  TextEditingController tfoDeckTypeController =
      TextEditingController(text: "1");
  TextEditingController tfoSpendileController =
      TextEditingController(text: "200");

  // Jari
  TextEditingController jariDeckType1Controller =
      TextEditingController(text: "1");
  TextEditingController jariSpendile1Controller =
      TextEditingController(text: "70");
  TextEditingController hourController = TextEditingController(text: "0.00");
  TextEditingController kgController = TextEditingController(text: "0.00");
  TextEditingController lotController = TextEditingController(text: "0");
  TextEditingController meterController = TextEditingController(text: "0.000");

  final RxString _selectedMachineType = RxString("Winder");
  final RxString _selectedWagesType = RxString("Kg");

  final _formKey = GlobalKey<FormState>();
  final FocusNode _firstInputFocusNode = FocusNode();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MachineDetailsController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Machinen Details"),
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
                            autofocus: true,
                            controller: machineNameController,
                            hintText: "Machine Name",
                            validate: "string",
                            focusNode: _firstInputFocusNode,
                          ),
                          MyDropdownButtonFormField(
                            controller: machineTypeController,
                            hintText: "Machine Type",
                            items: const ['Winder', 'TFO', 'Jari'],
                            onChanged: (value) {
                              _selectedMachineType.value = value;
                            },
                          ),
                          MyDropdownButtonFormField(
                            controller: wagesTypeController,
                            hintText: "Wages Type",
                            items: const ['Kg', 'Time', 'Lot', 'Meter'],
                            onChanged: (value) {
                              _selectedWagesType.value = value;
                            },
                          ),
                          Obx(() => wagesTypeChange(_selectedWagesType.value)),
                          Focus(
                            skipTraversal: true,
                            child: MyTextField(
                              controller: wagesController,
                              hintText: "Wages",
                              validate: "double",
                            ),
                            onFocusChange: (hasFocus) {
                              AppUtils.fractionDigitsText(wagesController,
                                  fractionDigits: 2);
                            },
                          ),
                        ],
                      ),
                      Obx(() => updateWidget(_selectedMachineType.value)),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MySubmitButton(
                            onPressed:
                                controller.status.isLoading ? null : submit,
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

  Widget wagesTypeChange(String wagesType) {
    return GetBuilder<MachineDetailsController>(
      builder: (controller) {
        if (wagesType == "Time") {
          return Focus(
            skipTraversal: true,
            child: MyTextField(
              controller: hourController,
              hintText: "Hour",
              validate: "double",
              suffix: const Text(
                "Unit",
                style: TextStyle(color: Color(0XFF5700BC)),
              ),
            ),
            onFocusChange: (hasFocus) {
              AppUtils.fractionDigitsText(hourController, fractionDigits: 2);
            },
          );
        } else if (wagesType == "Kg") {
          return Focus(
            skipTraversal: true,
            child: MyTextField(
              controller: kgController,
              hintText: "KG",
              validate: "double",
            ),
            onFocusChange: (hasFocus) {
              AppUtils.fractionDigitsText(kgController, fractionDigits: 2);
            },
          );
        } else if (wagesType == "Lot") {
          return MyTextField(
            controller: lotController,
            hintText: "lot",
            validate: "number",
          );
        } else if (wagesType == "Meter") {
          return Focus(
            skipTraversal: true,
            child: MyTextField(
              controller: meterController,
              hintText: "meter",
              validate: "double",
            ),
            onFocusChange: (hasFocus) {
              AppUtils.fractionDigitsText(meterController, fractionDigits: 3);
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget updateWidget(String option) {
    return GetBuilder<MachineDetailsController>(
      builder: (controller) {
        if (option == 'Jari') {
          return Wrap(
            children: [
              MyDropdownButtonFormField(
                controller: jariDeckType1Controller,
                hintText: "Deck Type",
                items: const ['1', '2', '3', '4'],
              ),
              MyDropdownButtonFormField(
                controller: jariSpendile1Controller,
                hintText: "SPENDILE",
                items: const ['70', '100'],
              ),
            ],
          );
        } else if (option == 'TFO') {
          return Wrap(
            children: [
              MyDropdownButtonFormField(
                controller: tfoDeckTypeController,
                hintText: "Deck Type",
                items: const ['1', '2', '3', '4'],
              ),
              MyDropdownButtonFormField(
                controller: tfoSpendileController,
                hintText: "SPENDILE",
                items: const ['200'],
              )
            ],
          );
        } else if (option == "Winder") {
          return MyDropdownButtonFormField(
            controller: windingTypeController,
            hintText: "Winding Type",
            items: const ['Cone Winding', 'Unit Cutting Winding', 'Rewinding'],
          );
        } else {
          return Container();
        }
      },
    );
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      String wagesType = wagesTypeController.text;
      String machineType = machineTypeController.text;

      Map<String, dynamic> request = {
        "machine_name": machineNameController.text,
        "machine_type": machineType,
        "wages_type": wagesType,
        "wages": double.tryParse(wagesController.text) ?? 0.0,
      };

      // wages type to change
      if (wagesType == "Kg") {
        request["weight"] = double.tryParse(kgController.text) ?? 0.0;
      } else if (wagesType == "Lot") {
        request["lots"] = int.tryParse(lotController.text) ?? 0;
      } else if (wagesType == "Meter") {
        request["meter"] = double.tryParse(meterController.text) ?? 0.0;
      } else {
        request["hours"] = double.tryParse(hourController.text) ?? 0.0;
      }

      // machine type to change
      if (machineType == "Winder") {
        request["winding_type"] = windingTypeController.text;
      } else if (machineType == "TFO") {
        request["deck_type"] = tfoDeckTypeController.text;
        request["spendile"] = tfoSpendileController.text;
      } else {
        request["deck_type"] = jariDeckType1Controller.text;
        request["spendile"] = jariSpendile1Controller.text;
      }

      var id = idController.text;
      if (id.isEmpty) {
        controller.add(request);
      } else {
        request['id'] = id;
        controller.edit(request);
      }
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      var data = MachineDetailsModel.fromJson(Get.arguments['item']);
      idController.text = '${data.id}';
      machineNameController.text = '${data.machineName}';
      machineTypeController.text = '${data.machineType}';
      wagesTypeController.text = '${data.wagesType}';
      wagesController.text = '${data.wages}';

      _selectedWagesType.value = "${data.wagesType}";
      _selectedMachineType.value = "${data.machineType}";
      String wagesType = "${data.wagesType}";
      String machineType = "${data.machineType}";

      // wages type to change
      if (wagesType == "Kg") {
        kgController.text = "${data.weight}";
      } else if (wagesType == "Lot") {
        lotController.text = "${data.lots}";
      } else if (wagesType == "Meter") {
        meterController.text = "${data.meter}";
      } else {
        hourController.text = "${data.hours}";
      }

      // machine type to change
      if (machineType == "Winder") {
        windingTypeController.text = "${data.windingType}";
      } else if (machineType == "TFO") {
        tfoDeckTypeController.text = "${data.deckType}";
        tfoSpendileController.text = "${data.spendile}";
      } else {
        jariDeckType1Controller.text = "${data.deckType}";
        jariSpendile1Controller.text = "${data.spendile}";
      }
    }
  }
}
