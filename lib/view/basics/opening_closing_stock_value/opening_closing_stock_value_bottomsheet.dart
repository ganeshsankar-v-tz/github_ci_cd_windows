import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';
import '../ledger_opening_balance/ledger_opening_balance_controller.dart';
import 'opening_closing_stock_value_controller.dart';

class OpeningClosingStockValueBottomSheet extends StatefulWidget {
  const OpeningClosingStockValueBottomSheet({Key? key}) : super(key: key);

  @override
  State<OpeningClosingStockValueBottomSheet> createState() => _State();
}

class _State extends State<OpeningClosingStockValueBottomSheet> {
  TextEditingController ledger_Account = TextEditingController();
  TextEditingController opening_stock = TextEditingController();
  TextEditingController closing_stock = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OpeningClosingStockValueController>(
        builder: (controller) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.90,
        width: MediaQuery.of(context).size.width * 0.90,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Item (Opening Closing Stock Value)',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.only(left: 50),
                child: Wrap(
                  children: [
                    MyTextField(
                      controller: ledger_Account,
                      hintText: 'Ledger Account',
                      validate: 'string',
                    ),
                    MyTextField(
                      controller: opening_stock,
                      hintText: 'Opening Stock Value',
                      validate: 'double',
                    ),
                    MyTextField(
                      controller: closing_stock,
                      hintText: 'Closing Stock Value',
                      validate: 'double',
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
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "ledger_ac": ledger_Account.text,
        "opening_stock": opening_stock.text,
        "closing_stock": closing_stock.text,
      };
      Get.back(result: request);
    }
  }
}
