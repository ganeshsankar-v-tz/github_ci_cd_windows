import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/TransportCopyModel.dart';
import 'package:abtxt/model/ledger_role_model.dart';
import 'package:abtxt/view/trasaction/transport_copy_list/transport_copy_bottomsheeet.dart';
import 'package:abtxt/view/trasaction/transport_copy_list/transport_copy_controller.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../utils/constant.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyTextField.dart';

class AddTransportCopy extends StatefulWidget {
  const AddTransportCopy({Key? key}) : super(key: key);
  static const String routeName = '/AddTransportCopy';

  @override
  State<AddTransportCopy> createState() => _State();
}

class _State extends State<AddTransportCopy> {
  TextEditingController idController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  TextEditingController firmNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  Rxn<LedgerRoleModel> roleName = Rxn<LedgerRoleModel>();
  TextEditingController roleNameController = TextEditingController();
  Rxn<LedgerModel> toCustomer = Rxn<LedgerModel>();
  TextEditingController toCustomerController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController invoiceNoController = TextEditingController();
  TextEditingController invoiceNoValueController = TextEditingController();
  TextEditingController invoiceDateController = TextEditingController();
  TextEditingController noOfQuantityController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController bundleController = TextEditingController();
  TextEditingController throughLorryController = TextEditingController();
  TextEditingController freightController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toPlaceController = TextEditingController();
  TextEditingController exportToController = TextEditingController();
  var productSalesList = <dynamic>[].obs;
  final _formKey = GlobalKey<FormState>();

  late TransportCopyController controller;
  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransportCopyController>(builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Transport Copy"),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Container(
              width: Get.width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
              ),
              margin: EdgeInsets.all(16),
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
                            validate: "",
                            enabled: false,
                          ),
                        ),
                        MyDialogList(
                          labelText: 'Firm',
                          controller: firmNameController,
                          showCreateNew: false,
                          list: controller.firmDropdown,
                          onItemSelected: (FirmModel item) {
                            firmNameController.text = '${item.firmName}';
                            firmName.value = item;
                          },
                          onCreateNew: (value) async {

                          },
                        ),
                        MyDateField(
                          controller: dateController,
                          hintText: "Date",
                          validate: "string",
                          readonly: true,
                        ),
                        MyDialogList(
                          labelText: 'Role',
                          controller: roleNameController,
                          showCreateNew: false,
                          list: controller.role,
                          onItemSelected: (LedgerRoleModel item) {
                            roleNameController.text = '${item.name}';
                            roleName.value = item;
                          },
                          onCreateNew: (value) async {

                          },
                        ),
                        MyDialogList(
                          labelText: 'To',
                          controller: toCustomerController,
                          showCreateNew: false,
                          list: controller.ledgerDropdown,
                          onItemSelected: (LedgerModel item) {
                            toCustomerController.text = '${item.ledgerName}';
                            toCustomer.value = item;
                          },
                          onCreateNew: (value) async {

                          },
                        ),
                        MyTextField(
                          controller: placeController,
                          hintText: "",
                          validate: "string",
                        ),
                        MyDropdownButtonFormField(
                          controller: invoiceNoController,
                          hintText: "Invoice No",
                          items: Constants.InvoiceNo,
                          onChanged: (value) async {
                            if (value == 'Product Sale') {
                              var result = await dyerOrderItemDialog();
                              invoiceNoValueController.text = result['salesNo'];
                              invoiceDateController.text = result["invoiceDate"];
                              noOfQuantityController.text = result["totalQty"];
                              bundleController.text = result["bundle"];
                              totalAmountController.text =
                                  result["totalNetAmount"];
                            } else {
                              invoiceDateController.clear();
                              invoiceNoValueController.clear();
                              noOfQuantityController.clear();
                              totalAmountController.clear();
                              bundleController.clear();
                            }
                          },
                        ),
                        MyTextField(
                          controller: invoiceNoValueController,
                          hintText: "",
                          validate: "string",
                        ),
                        MyTextField(
                          controller: invoiceDateController,
                          hintText: "Invoice Date",
                          validate: "string",
                        ),
                        MyTextField(
                          controller: noOfQuantityController,
                          hintText: "No of Quantity",
                          validate: "string",
                        ),
                        MyTextField(
                          controller: totalAmountController,
                          hintText: "Total Amount (Rs)",
                          validate: "string",
                        ),
                        MyTextField(
                          controller: bundleController,
                          hintText: "Bundle",
                          validate: "string",
                        ),
                        MyDropdownButtonFormField(
                            controller: throughLorryController,
                            hintText: "Through Lorry",
                            items: Constants.ThroughLorry),
                        MyDropdownButtonFormField(
                            controller: freightController,
                            hintText: "Freight",
                            items: Constants.Freight),
                        MyTextField(
                          controller: fromController,
                          hintText: "From",
                          validate: "string",
                        ),
                        MyTextField(
                          controller: toPlaceController,
                          hintText: "To Place",
                          validate: "string",
                        ),
                        MyTextField(
                          controller: exportToController,
                          hintText: "Export to",
                          validate: "string",
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: false,
                          child: SizedBox(
                            width: 200,
                            child: MyElevatedButton(
                              color: Colors.purple.shade400,
                              onPressed: () async {
                                var result = await dyerOrderItemDialog();
                                invoiceNoValueController.text = result['salesNo'];
                                invoiceDateController.text =
                                    result["invoiceDate"];
                                noOfQuantityController.text = result["totalQty"];
                                bundleController.text = result["bundle"];
                                totalAmountController.text =
                                    result["totalNetAmount"];
                              },
                              child: const Text('Bill'),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        MyCloseButton(
                          onPressed: () => Get.back(),
                          child: const Text('Close'),
                        ),
                        SizedBox(width: 16),
                        SizedBox(
                          child: MyElevatedButton(
                            onPressed: () => submit(),
                            child: Text('Save'),
                          ),
                        ),
                      ],
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

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "firm_id": firmName.value?.id,
        "date": dateController.text,
        "role_id": roleName.value?.id,
        "to": toCustomer.value?.id,
        "place": placeController.text,
        "invoice_no": invoiceNoController.text,
        "product_sale_bill": invoiceNoValueController.text,
        "invoice_date": invoiceDateController.text,
        "no_of_quantity": noOfQuantityController.text,
        "total_amount": totalAmountController.text,
        "bundle": bundleController.text,
        "through_lorry": throughLorryController.text,
        "freight": freightController.text,
        "from": fromController.text,
        "export_to": exportToController.text,
        "to_place": toPlaceController.text
      };
      var id = idController.text;
      if (id.isEmpty) {
        controller.add(request);
      } else {
        request['id'] = id;
        controller.edit(request, id);
      }
    }
  }

  void _initValue() {
    invoiceNoController.text = Constants.InvoiceNo[0];
    throughLorryController.text = Constants.ThroughLorry[0];
    freightController.text = Constants.Freight[0];
    if (Get.arguments != null) {
      TransportCopyController controller = Get.find();
      TransportCopyModel items = Get.arguments['item'];
      idController.text = '${items.id}';
      dateController.text = '${items.date}';
      placeController.text = '${items.place}';

      invoiceNoController.text = '${items.invoiceNo}';

      invoiceNoValueController.text = '${items.productSaleBill}';
      invoiceDateController.text = '${items.invoiceDate}';
      noOfQuantityController.text = '${items.noOfQuantity}';
      totalAmountController.text = '${items.totalAmount}';
      bundleController.text = '${items.bundle}';
      throughLorryController.text = '${items.throughLorry}';
      freightController.text = '${items.freight}';
      fromController.text = '${items.from}';
      toPlaceController.text = '${items.toPlace}';
      exportToController.text = '${items.exportTo}';

      var firmList = controller.firmDropdown
          .where((element) => '${element.id}' == '${items.firmId}')
          .toList();
      if (firmList.isNotEmpty) {
        firmName.value = firmList.first;
        firmNameController.text = '${firmList.first.firmName}';
      }
      var roleList = controller.role
          .where((element) => '${element.id}' == '${items.roleId}')
          .toList();
      if (roleList.isNotEmpty) {
        roleName.value = roleList.first;
        roleNameController.text = '${roleList.first.name}';

      }
      var toCustomerList = controller.ledgerDropdown
          .where((element) => '${element.id}' == '${items.to}')
          .toList();
      if (toCustomerList.isNotEmpty) {
        toCustomer.value = toCustomerList.first;
        toCustomerController.text = '${toCustomerList.first.ledgerName}';

      }
    }
  }

  dynamic dyerOrderItemDialog() async {
    var result = await showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        constraints: const BoxConstraints(maxWidth: 800),
        builder: (context) {
          return const TransportCopyBottomSheet();
        });
    return result;
  }
}
