import 'package:abtxt/model/vehicle_details/VehicleDetailsModel.dart';
import 'package:abtxt/view/basics/vehicle_details/vehicle_details_controller.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class AddVehicleDetails extends StatefulWidget {
  const AddVehicleDetails({super.key});

  static const String routeName = '/add_vehicle_details';

  @override
  State<AddVehicleDetails> createState() => _State();
}

class _State extends State<AddVehicleDetails> {
  TextEditingController idController = TextEditingController();
  TextEditingController transportNameController = TextEditingController();
  TextEditingController vehicleNoController = TextEditingController();
  TextEditingController vehicleGstController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final VehicleDetailsController controller = Get.find();
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
    return GetBuilder<VehicleDetailsController>(
      builder: (controller) {
        return ShortCutWidget(
          appBar: AppBar(
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Vehicle Details"),
            actions: [
              Visibility(
                  visible: idController.text.isNotEmpty,
                  child: MyDeleteIconButton(
                    onPressed: (password) {
                      controller.delete(idController.text, password);
                    },
                  )),
              const SizedBox(width: 8),
            ],
          ),
          loadingStatus: controller.status.isLoading,
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.keyQ, control: true):
                GetBackIntent(),
            SingleActivator(LogicalKeyboardKey.keyS, control: true):
                SaveIntent(),
          },
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
                              enabled: false,
                            ),
                          ),
                          MyTextField(
                            controller: transportNameController,
                            hintText: "Transport Name",
                            validate: "string",
                            focusNode: _firstInputFocusNode,
                          ),
                          MyTextField(
                            controller: vehicleNoController,
                            hintText: "Vehicle No",
                          ),
                          MyTextField(
                            controller: vehicleGstController,
                            hintText: "GST Number",
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
        );
      },
    );
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "transport_name": transportNameController.text,
        "vehicle_no": vehicleNoController.text,
        "vehicle_gst": vehicleGstController.text,
      };
      var id = idController.text;
      if (id.isEmpty) {
        controller.add(request);
      } else {
        request["id"] = int.tryParse(idController.text);
        controller.edit(request);
      }
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      VehicleDetailsModel item = Get.arguments['item'];
      idController.text = '${item.id}';
      transportNameController.text = "${item.transportName}";
      vehicleNoController.text = "${item.vehicleNo}";
      vehicleGstController.text = item.vehicleGst ?? "";
    }
  }
}
