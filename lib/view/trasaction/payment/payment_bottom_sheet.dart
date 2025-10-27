import 'dart:convert';

import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/payment/payment_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class PaymentBottomSheet extends StatefulWidget {
  const PaymentBottomSheet({super.key});

  static const String routeName = '/jari_twisting_yarn_inward_bottom_sheet';

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  TextEditingController orderedWorkController = TextEditingController();
  Rxn<LedgerModel> toledgerName = Rxn<LedgerModel>();
  TextEditingController creditController = TextEditingController();
  TextEditingController isCompanyChqcontroller =
      TextEditingController(text: "Yes");
  TextEditingController chequeController = TextEditingController();
  TextEditingController dateContoller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(title: Text('Add Item - Payment')),
        bindings:  {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () => Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyS, control: true): () => submit(),
        },
        loadingStatus: controller.status.isLoading,
        child:SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Color(0xFFF9F3FF),
                width: 16,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  Row(
                                    children: [
                                      Wrap(
                                        children: [
                                          MyAutoComplete(
                                            label: 'To',
                                            items: controller.toledgerDropdown,
                                            selectedItem: toledgerName.value,
                                            onChanged: (LedgerModel item) async {
                                              toledgerName.value = item;
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
                                            controller: creditController,
                                            hintText: "Credit",
                                            validate: "double",
                                          ),
                                          MyDropdownButtonFormField(
                                              controller: isCompanyChqcontroller,
                                              hintText: "Is Company Chq?",
                                              items: ["Yes", "No"]),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Wrap(
                                        children: [
                                          MyTextField(
                                            controller: chequeController,
                                            hintText: "Chq.No",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           /* MyCloseButton(
                                onPressed: () => Get.back(),
                                child: Text('Cancel')),
                            const SizedBox(width: 16),*/
                            MyAddButton(
                              onPressed: () => submit(),
                             // child: const Text('ADD'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        ),
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "to_ledger_no": toledgerName.value?.id,
        "ledger_name": toledgerName.value?.ledgerName,
        "credit_amount": double.tryParse(creditController.text) ?? 0.0,
        "is_com_chq": isCompanyChqcontroller.text,
        "ch_no": chequeController.text,
        "ch_dt": dateContoller.text,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      PaymentController controller = Get.find();

      var item = Get.arguments['item'];
      print('${jsonEncode(item)}');

      creditController.text = tryCast(item['credit_amount']);
      isCompanyChqcontroller.text = tryCast(item['is_com_chq']);
      chequeController.text = tryCast(item['ch_no'] );

      // // Ledger Name

      var ledgerList = controller.toledgerDropdown
          .where((element) => '${element.id}' == '${item['to_ledger_no']}')
          .toList();
      if (ledgerList.isNotEmpty) {
        toledgerName.value = ledgerList.first;
      }
    }
  }
}
