import 'package:abtxt/utils/constant.dart';
import 'package:abtxt/view/basics/ledger_opening_balance/ledger_opening_balance_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class LedgerOpeningBalanceModelBottomSheet extends StatefulWidget {
  const LedgerOpeningBalanceModelBottomSheet({Key? key}) : super(key: key);

  @override
  State<LedgerOpeningBalanceModelBottomSheet> createState() => _State();
}

class _State extends State<LedgerOpeningBalanceModelBottomSheet> {
  TextEditingController amountRs = TextEditingController();
  TextEditingController amountTypeController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LedgerOpeningBalanceController>(builder: (controller) {
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F3FF),
          appBar: AppBar(title: const Text('Add item to Ledger Opening Balance')),
          body: SingleChildScrollView(
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,                              children: [
                                Container(
                                  child: Wrap(
                                    children: [
                                      MyTextField(
                                        controller: amountRs,
                                        hintText: 'Amount (RS)',
                                        validate: 'double',
                                      ),
                                      Row(
                                        children: [
                                          MyDropdownButtonFormField(
                                              controller: amountTypeController,
                                              hintText: 'Amount Type',
                                              items: Constants.amountType),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyDropdownButtonFormField(
                                              controller: typeController,
                                              hintText: 'Type',
                                              items: Constants.type),
                                        ],
                                      ),
                                      MyTextField(
                                        controller: detailsController,
                                        hintText: 'Details',
                                        validate: 'string',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    MyCloseButton(
                                      onPressed: () => Get.back(),
                                      child: const Text('Close'),
                                    ),
                                    const SizedBox(width: 16),
                                    SizedBox(
                                      width: 200,
                                      child: MyElevatedButton(
                                        onPressed: () => submit(),
                                        child: const Text('ADD'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "amount": double.tryParse(amountRs.text)?? 0.0,
        "amount_type": amountTypeController.text,
        "type": typeController.text,
        "details": detailsController.text ?? '',
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    LedgerOpeningBalanceController controller = Get.find();
    amountTypeController.text = Constants.amountType[0];
    typeController.text = Constants.type[0];
  }
}
