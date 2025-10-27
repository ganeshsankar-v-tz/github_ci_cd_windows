import 'package:abtxt/view/trasaction/Process/process_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../model/ProductInfoModel.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyDropdown.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class ProcessBottomSheet extends StatefulWidget {
  const ProcessBottomSheet({super.key});

  @override
  State<ProcessBottomSheet> createState() => _venkiState();
}

class _venkiState extends State<ProcessBottomSheet> {
  TextEditingController entry_type_idController = TextEditingController();
  //main 3
  TextEditingController dateController = TextEditingController();
  // TextEditingController transactionTypeController = TextEditingController();
  //TextEditingController entry_type_idController = TextEditingController();

  //select item
  Rxn<ProductInfoModel> productNameController = Rxn<ProductInfoModel>();
  TextEditingController workController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController wagesqtyController = TextEditingController();
  TextEditingController amountControl = TextEditingController();
  TextEditingController balanceControl = TextEditingController();
  TextEditingController detailsControl_inward = TextEditingController();
  //Details

  final _formKey = GlobalKey<FormState>();
  var _selectedEntryType = Constants.ENTRY_TYPES_PROCESS[0].obs;

  @override
  void initState() {
    entry_type_idController.text = Constants.ENTRY_TYPES_PROCESS[0];
    _initValue();
    super.initState();
  }

  late ProcessController controller;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProcessController>(builder: (controller) {
      this.controller = controller;
      return Container(
        padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.90,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Item to Yarn inward from winder',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Row(
                  children: [
                    MyTextField(
                      controller: dateController,
                      hintText: "Date",
                      validate: "String",
                    ),
                    MyDropdown(
                      hintText: "Entry Type",
                      items: Constants.ENTRY_TYPES_PROCESS,
                      onChanged: (value) {
                        _selectedEntryType.value = value;
                      },
                    ),
                  ],
                ),
              ),

              Form(
                key: _formKey,
                child: Obx(() => Container(
                    padding: const EdgeInsets.only(left: 50),
                    child: updateWidget(_selectedEntryType.value))),
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
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "date": dateController.text,
        "entry_type": _selectedEntryType.value.toString(),
        // "delivered_qty": quantityController.text,
        // "recived_qty": quantityController.text,
        // "wages": wagesqtyController.text,
        // "particulars": detailsControl_inward,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    dateController.text = "2023-10-10";
    workController.text = Constants.WORK[0];
  }

  Widget updateWidget(String option) {
    return GetBuilder<ProcessController>(builder: (controller) {
      if (option == 'Delivery') {
        return Wrap(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Text(
                //   'Product Name',
                //   style: TextStyle(
                //       fontWeight: FontWeight.w600, color: Colors.black87),
                // ),
                Container(
                  width: 240,
                  padding: EdgeInsets.all(8),
                  child: DropdownButtonFormField(
                    value: productNameController.value,
                    items:
                        controller.productDropdown.map((ProductInfoModel item) {
                      return DropdownMenuItem<ProductInfoModel>(
                        value: item,
                        child: Text('${item.productName}',style: TextStyle(fontWeight: FontWeight.normal),),
                      );
                    }).toList(),
                    onChanged: (ProductInfoModel? value) {
                      productNameController.value = value;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                      hintText: '',
                      labelText: 'Product Name'
                    ),
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
            MyDropdownButtonFormField(
              controller: workController,
              hintText: "Work",
              items: Constants.WORK,
            ),
            MyTextField(
              controller: quantityController,
              hintText: 'Quantity',
              validate: 'number',
            ),
            MyTextField(
              controller: detailsController,
              hintText: 'Details',
              validate: 'String',
            ),
          ],
        );
      } else if (option == 'Inward') {
        return Wrap(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Text(
                //   'Product Name',
                //   style: TextStyle(
                //       fontWeight: FontWeight.w600, color: Colors.black87),
                // ),
                Container(
                  width: 240,
               padding: EdgeInsets.all(8),
                  child: DropdownButtonFormField(
                    value: productNameController.value,
                    items:
                        controller.productDropdown.map((ProductInfoModel item) {
                      return DropdownMenuItem<ProductInfoModel>(
                        value: item,
                        child: Text('${item.productName}',style: TextStyle(fontWeight: FontWeight.normal),),
                      );
                    }).toList(),
                    onChanged: (ProductInfoModel? value) {
                      productNameController.value = value;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                      // hintText: '',
                      labelText: 'Product Name'
                    ),
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
            MyDropdownButtonFormField(
              controller: workController,
              hintText: "Work Name",
              items: Constants.WORK,
            ),
            MyTextField(
              controller: quantityController,
              hintText: 'Quantity',
              validate: 'number',
            ),
            MyTextField(
              controller: wagesqtyController,
              hintText: 'Wages Quantity',
              validate: 'number',
            ),
            MyTextField(
              controller: amountControl,
              hintText: 'Amount (Rs)',
              validate: 'number',
            ),
            MyTextField(
              controller: balanceControl,
              hintText: 'Balance',
              validate: 'number',
            ),
            MyTextField(
              controller: detailsControl_inward,
              hintText: 'Details',
              validate: 'String',
            ),
          ],
        );
      } else {
        return Container();
      }
    });
  }
}
