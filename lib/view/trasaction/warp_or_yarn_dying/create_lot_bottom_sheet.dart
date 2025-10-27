import 'package:abtxt/view/basics/account/add_account.dart';
import 'package:abtxt/view/trasaction/warp_or_yarn_dying/warp_or_yarn_dying_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/AccountTypeModel.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../basics/ledger/addledger.dart';

class CreateLotBottomSheet extends StatefulWidget {
  const CreateLotBottomSheet({Key? key}) : super(key: key);

  @override
  State<CreateLotBottomSheet> createState() => _State();
}

class _State extends State<CreateLotBottomSheet> {
  Rxn<LedgerModel> dyerNameController = Rxn<LedgerModel>();
  Rxn<FirmModel> firmController = Rxn<FirmModel>();
  Rxn<AccountTypeModel> accountController = Rxn<AccountTypeModel>();
  TextEditingController lotController = TextEditingController();
  TextEditingController recordController = TextEditingController();
  TextEditingController transactionController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController yarnDeliveryController = TextEditingController();
  TextEditingController tokesController = TextEditingController();
  TextEditingController warpdyingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late WarpOrYarnDyingController controller;

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpOrYarnDyingController>(builder: (controller) {
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
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Text(
                          //   'Dyer Name',
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.w600,
                          //       color: Colors.black87),
                          // ),
                          Container(
                            width: 240,
                            padding: EdgeInsets.all(8),
                            child: DropdownButtonFormField(
                              value: dyerNameController.value,
                              items:
                                  controller.DyerName.map((LedgerModel item) {
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
                                dyerNameController.value = value;
                              },
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8),
                                  border: OutlineInputBorder(),
                                  // hintText: 'Select',
                                  labelText: 'Dyer Name'),
                              validator: (value) {
                                if (value == null) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 17.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(AddLedger.routeName);
                            },
                            splashColor: Colors.deepPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            child: Ink(
                              width: 140,
                              height: 30,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFDCFFDB),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 0.20, color: Color(0xFF00DE16)),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      ' Create New',
                                      style: TextStyle(
                                        color: Color(0xFF202020),
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MyTextField(
                        controller: lotController,
                        hintText: 'Lot',
                        validate: 'number',
                      ),
                      MyTextField(
                        controller: recordController,
                        hintText: 'Record No',
                        validate: 'number',
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Text(
                          //   'Firm',
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.w600,
                          //       color: Colors.black87),
                          // ),
                          Container(
                            width: 240,
                            padding: EdgeInsets.all(8),
                            child: DropdownButtonFormField(
                              value: firmController.value,
                              items: controller.Firm.map((FirmModel item) {
                                return DropdownMenuItem<FirmModel>(
                                  value: item,
                                  child: Text(
                                    '${item.firmName}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                );
                              }).toList(),
                              onChanged: (FirmModel? value) {
                                firmController.value = value;
                              },
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8),
                                  border: OutlineInputBorder(),
                                  // hintText: 'Select',
                                  labelText: 'Firm'),
                              validator: (value) {
                                if (value == null) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Text(
                          //   'Account Type',
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.w600,
                          //       color: Colors.black87),
                          // ),
                          Container(
                            width: 240,
                            padding: EdgeInsets.all(8),
                            child: DropdownButtonFormField(
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
                                  labelText: 'Account Type'),
                              validator: (value) {
                                if (value == null) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 17.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(AddAccount.routeName);
                            },
                            splashColor: Colors.deepPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            child: Ink(
                              width: 140,
                              height: 30,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFDCFFDB),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 0.20, color: Color(0xFF00DE16)),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      ' Create New',
                                      style: TextStyle(
                                        color: Color(0xFF202020),
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MyDropdownButtonFormField(
                          controller: transactionController,
                          hintText: "Transaction Type",
                          items: Constants.TRANSACTIONTYPE),
                      MyTextField(
                        controller: detailsController,
                        hintText: 'Details',
                        validate: 'String',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    "Maintenance",
                    style: TextStyle(
                        color: Color(0xFF5700BC),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Wrap(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 50, top: 20),
                      child: Row(
                        children: [
                          MyDropdownButtonFormField(
                              controller: yarnDeliveryController,
                              hintText: "Yarn Delivery Wages",
                              items: Constants.YarnDeliverWages),
                          MyDropdownButtonFormField(
                              controller: tokesController,
                              hintText: "Toks Delivery",
                              items: Constants.TokesDelivery),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 50, top: 10),
                      child: Row(
                        children: [
                          MyDropdownButtonFormField(
                              controller: warpdyingController,
                              hintText: "Warp Dyeing Wages",
                              items: Constants.WarpDyingWages),
                        ],
                      ),
                    )
                  ],
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
                        child: const Text('Cancel'),
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
        // "product_name": dyerNameController.value?.productName,
        "product_id": dyerNameController.value?.id,
        "design_no": lotController.text,
        "work": firmController.value?.id,
        "pieces": recordController.text,
        "rate": accountController.value?.id,
        "net_amount": transactionController.text,
        "stock": detailsController.text,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    WarpOrYarnDyingController controller = Get.find();
    transactionController.text = Constants.TRANSACTIONTYPE[0];
    yarnDeliveryController.text = Constants.YarnDeliverWages[0];
    tokesController.text = Constants.TokesDelivery[0];
    warpdyingController.text = Constants.WarpDyingWages[0];
  }
}
