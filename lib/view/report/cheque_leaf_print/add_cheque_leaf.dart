import 'package:abtxt/model/ChequeLeafModel/ChequeLeafModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/widgets/MyDeleteIconButton.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySubmitButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import 'cheque_leaf_controller.dart';

class AddChequeLeaf extends StatefulWidget {
  const AddChequeLeaf({super.key});

  static const String routeName = '/add_cheque_leaf';

  @override
  State<AddChequeLeaf> createState() => _State();
}

class _State extends State<AddChequeLeaf> {
  TextEditingController idController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController acPayeeController = TextEditingController(text: "No");
  TextEditingController favFromController =
      TextEditingController(text: "Database");
  TextEditingController favouringTextController = TextEditingController();
  Rxn<LedgerModel> ledgerController = Rxn<LedgerModel>();
  TextEditingController favouringController = TextEditingController();
  TextEditingController amountController = TextEditingController(text: "0.00");
  TextEditingController chequeNoController = TextEditingController();
  TextEditingController templateController = TextEditingController(text: "TMB");
  TextEditingController detailsController = TextEditingController();

  var favFromText = "".obs;

  final _formKey = GlobalKey<FormState>();
  final ChequeLeafController controller = Get.find();

  final FocusNode _favouringFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

  /// created by and updated by details controllers
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? displayName;
  String? displayDate;

  @override
  void initState() {
    favFromText.value = favFromController.text;

    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChequeLeafController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title:
              Text("${idController.text == '' ? 'Add' : 'Update'} Cheque Leaf"),
          actions: [
            Visibility(
                visible: idController.text.isNotEmpty,
                child: MyDeleteIconButton(
                  onPressed: (password) {
                    controller.delete(idController.text, password);
                  },
                )),
            const SizedBox(width: 8),
            Visibility(
              visible: idController.text.isNotEmpty,
              child: MyPrintButton(
                onPressed: () => _print(),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyP, control: true):
              PrintIntent(),
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
            PrintIntent: SetCounterAction(perform: () {
              _print();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
              ),
              // padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
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
                          MyDateFilter(
                            width: 180,
                            autofocus: true,
                            controller: dateController,
                            labelText: "Date",
                          ),
                          MyDropdownButtonFormField(
                            width: 150,
                            controller: acPayeeController,
                            hintText: "A/C Payee",
                            items: const ["No", "Yes"],
                          ),
                          MyDropdownButtonFormField(
                            controller: favFromController,
                            hintText: "Fav From",
                            items: const ["Database", "Manual Entry"],
                            onChanged: (value) {
                              favFromText.value = value;
                            },
                          ),
                          Obx(
                            () => Visibility(
                              visible: favFromText.value == "Manual Entry",
                              child: MyTextField(
                                width: 400,
                                controller: favouringTextController,
                                hintText: "Favouring",
                                validate: "string",
                              ),
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: favFromText.value == "Database",
                              child: MySearchField(
                                width: 400,
                                label: "Favouring",
                                items: controller.ledgerDropdown,
                                textController: favouringController,
                                focusNode: _favouringFocusNode,
                                requestFocus: _amountFocusNode,
                                onChanged: (LedgerModel item) {
                                  ledgerController.value = item;
                                },
                              ),
                            ),
                          ),
                          Focus(
                            skipTraversal: true,
                            child: MyTextField(
                              focusNode: _amountFocusNode,
                              controller: amountController,
                              hintText: "Amount (Rs)",
                              validate: "double",
                            ),
                            onFocusChange: (hasFocus) {
                              AppUtils.fractionDigitsText(
                                amountController,
                                fractionDigits: 2,
                              );
                            },
                          ),
                          MyTextField(
                            controller: chequeNoController,
                            hintText: "Cheque No",
                            validate: "number",
                          ),
                          MyDropdownButtonFormField(
                            controller: templateController,
                            hintText: "Template",
                            items: const [
                              "TMB",
                              "ICICI",
                              "CANARA",
                              "AXIS",
                            ],
                          ),
                          MyTextField(
                            controller: detailsController,
                            hintText: "Details",
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          crateAndUpdatedBy(),
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

  Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }

    var request = {'id': idController.text};
    String? response = await controller.chequeListPdf(request: request);
    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      double amount = double.tryParse(amountController.text) ?? 0.0;

      if (amount == 0) {
        return AppUtils.infoAlert(message: "Enter the valid Amount");
      }

      String? name = "";
      if (favFromController.text == "Database") {
        if (ledgerController.value == null) {
          return AppUtils.infoAlert(message: "Select the Favouring");
        }

        name = ledgerController.value!.ledgerName;
      } else {
        name = favouringTextController.text;
      }
      Map<String, dynamic> request = {
        "e_date": dateController.text,
        "is_open": acPayeeController.text,
        "entry_from": favFromController.text,
        "name": name,
        "amount": amount,
        "cheque_no": int.tryParse(chequeNoController.text),
        "template": templateController.text,
        "details": detailsController.text,
      };

      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        controller.add(request);
      } else {
        request['id'] = id;
        controller.edit(request);
      }
    }
  }

  void _initValue() {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");

    if (Get.arguments != null) {
      ChequeLeafModel item = ChequeLeafModel.fromJson(Get.arguments['item']);

      idController.text = "${item.id}";
      dateController.text = "${item.eDate}";
      acPayeeController.text = "${item.isOpen}";
      favFromController.text = "${item.entryFrom}";
      favFromText.value = "${item.entryFrom}";
      if (item.entryFrom == "Database") {
        var firmList = controller.ledgerDropdown
            .where((element) => '${element.ledgerName}' == '${item.name}')
            .toList();
        if (firmList.isNotEmpty) {
          ledgerController.value = firmList.first;
          favouringController.text = '${firmList.first.ledgerName}';
        }
      } else {
        favouringTextController.text = "${item.name}";
      }

      amountController.text = "${item.amount}";
      chequeNoController.text = "${item.chequeNo}";
      templateController.text = "${item.template}";
      detailsController.text = item.details ?? "";

      // f.text = "${item.entryFrom}";

      /// get created by and updated by details
      DateTime createDate = DateTime.parse(item.createdAt ?? "0000-00-00");
      DateTime updateDate = DateTime.parse(item.updatedAt ?? "0000-00-00");
      createdAt = AppUtils.dateFormatter.format(createDate);
      updatedAt = AppUtils.dateFormatter.format(updateDate);
      createdBy = item.createdName;
      updatedBy = item.updatedName;
      if (updatedBy != null) {
        displayName = "Edit : $updatedBy";
        displayDate = updatedAt;
      } else {
        displayName = "New : $createdBy";
        displayDate = createdAt;
      }
    }
  }

  Widget crateAndUpdatedBy() {
    String id = idController.text;
    String formattedDate = AppUtils.dateFormatter.format(DateTime.now());

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${id.isEmpty ? "New : ${AppUtils().loginName}" : displayName}",
          style: AppUtils.updateAndCreateTextStyle(),
        ),
        const SizedBox(width: 12),
        Text(
          "${id.isEmpty ? formattedDate : displayDate}",
          style: AppUtils.updateAndCreateTextStyle(),
        )
      ],
    );
  }
}
