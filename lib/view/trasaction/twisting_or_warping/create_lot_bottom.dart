import 'package:abtxt/model/AccountTypeModel.dart';
import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/view/trasaction/twisting_or_warping/twisting_or_warping_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constant.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../basics/account/add_account.dart';
import '../../basics/ledger/addledger.dart';

class TwisterCreateLotBottomSheet extends StatefulWidget {
  const TwisterCreateLotBottomSheet({Key? key}) : super(key: key);

  @override
  State<TwisterCreateLotBottomSheet> createState() => _State();
}

class _State extends State<TwisterCreateLotBottomSheet> {
  Rxn<LedgerModel> warperNameController = Rxn<LedgerModel>();
  Rxn<FirmModel> firmController = Rxn<FirmModel>();
  Rxn<AccountTypeModel> accountController = Rxn<AccountTypeModel>();
  TextEditingController lotController = TextEditingController();
  TextEditingController recordController = TextEditingController();
  TextEditingController transactionController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController yarnDeliveryController = TextEditingController();
  TextEditingController tokesController = TextEditingController();
  TextEditingController warpdyingController = TextEditingController();
  late TwistingOrWarpingController controller;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwistingOrWarpingController>(builder: (controller) {
      this.controller = controller;
      return Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.90,
        width: MediaQuery.of(context).size.width * 0.90,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Lot',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.only(left: 50),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 240,
                            padding: EdgeInsets.all(8),
                            child: DropdownButtonFormField(
                              style: TextStyle(
                                  color: Color(0xFF141414),
                                  fontSize: 14,
                                  fontFamily: 'Poppins'),
                              value: warperNameController.value,
                              items:
                                  controller.WarperName.map((LedgerModel item) {
                                return DropdownMenuItem<LedgerModel>(
                                  value: item,
                                  child: Text(
                                    '${item.ledgerName}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                );
                              }).toList(),
                              onChanged: (LedgerModel? value) {
                                warperNameController.value = value;
                              },
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8),
                                border: OutlineInputBorder(),
                                // hintText: 'Select',
                                labelText: 'Warper Name',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF939393),
                                    width: 0.4,
                                  ),
                                ),
                                labelStyle: TextStyle(fontSize: 14),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 11,
                          ),
                          MyCreateNew(
                            onPressed: () async {
                              var item = await Get.toNamed(AddLedger.routeName);
                              controller.onInit();
                            },
                          ),
                        ],
                      ),
                      MyTextField(
                        controller: lotController,
                        hintText: 'Lot',
                        validate: 'string',
                      ),
                      MyTextField(
                        controller: recordController,
                        hintText: 'Record No',
                        validate: 'string',
                      ),
                      Container(
                        width: 240,
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          style: TextStyle(
                              color: Color(0xFF141414),
                              fontSize: 14,
                              fontFamily: 'Poppins'),
                          value: firmController.value,
                          items: controller.firmDropdown.map((FirmModel item) {
                            return DropdownMenuItem<FirmModel>(
                              value: item,
                              child: Text(
                                '${item.firmName}',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            );
                          }).toList(),
                          onChanged: (FirmModel? value) {
                            firmController.value = value;
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            border: OutlineInputBorder(),
                            // hintText: 'Select',
                            labelText: 'Firm',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF939393),
                                width: 0.4,
                              ),
                            ),
                            labelStyle: TextStyle(fontSize: 14),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      MyDropdownButtonFormField(
                          controller: transactionController,
                          hintText: "Transaction Type",
                          items: Constants.TRANSACTIONTYPE),
                      Row(
                        children: [
                          Container(
                            width: 240,
                            padding: EdgeInsets.all(8),
                            child: DropdownButtonFormField(
                              style: TextStyle(
                                  color: Color(0xFF141414),
                                  fontSize: 14,
                                  fontFamily: 'Poppins'),
                              value: accountController.value,
                              items: controller.Account.map(
                                  (AccountTypeModel item) {
                                return DropdownMenuItem<AccountTypeModel>(
                                  value: item,
                                  child: Text(
                                    '${item.name}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                );
                              }).toList(),
                              onChanged: (AccountTypeModel? value) {
                                accountController.value = value;
                              },
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8),
                                border: OutlineInputBorder(),
                                // hintText: 'Select',
                                labelText: 'Account Type',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF939393),
                                    width: 0.4,
                                  ),
                                ),
                                labelStyle: TextStyle(fontSize: 14),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 11,
                          ),
                          MyCreateNew(
                            onPressed: () async {
                              var item =
                                  await Get.toNamed(AddAccount.routeName);
                              controller.onInit();
                            },
                          ),
                        ],
                      ),
                      MyTextField(
                        controller: detailsController,
                        hintText: 'Details',
                        validate: 'String',
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
                    SizedBox(
                      width: 200,
                      child: MyElevatedButton(
                        color: Colors.red,
                        onPressed: () => Get.back(),
                        child: const Text('CANCEL'),
                      ),
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
        ),
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "warper_id": warperNameController.value?.id,
        "lot": lotController.text,
        "recored_no": recordController.text,
        "firm_id": firmController.value?.id,
        "account_type_id": accountController.value?.id,
        "transaction_type": transactionController.text,
        "details": detailsController.text
      };
      controller.addLot(request);
    }
  }

  void _initValue() {
    transactionController.text = Constants.TRANSACTIONTYPE[0];
  }
}
