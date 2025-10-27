import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/tax_fix/tax_fix_controller.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/LedgerModel.dart';
import '../../../model/TaxFixingModel.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MySubmitButton.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class AddTaxfix extends StatefulWidget {
  const AddTaxfix({super.key});

  static const String routeName = '/AddTaxfix';

  @override
  State<AddTaxfix> createState() => _AddTaxfixState();
}

class _AddTaxfixState extends State<AddTaxfix> {
  final TaxFixController controller = Get.find();
  TextEditingController idController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController entryController =
      TextEditingController(text: 'Product Sales');
  TextEditingController activeController = TextEditingController(text: 'Yes');
  TextEditingController stateController =
      TextEditingController(text: 'Local (Intra State)');

  ///al1
  TextEditingController al1TypController = TextEditingController(text: "None");
  Rxn<LedgerModel> al1AccountNoController = Rxn<LedgerModel>();
  TextEditingController al1AccountNoTextController = TextEditingController();
  TextEditingController al1PercController = TextEditingController(text: "0");
  final FocusNode al1AccNoFocusNode = FocusNode();
  final FocusNode al1PercFocusNode = FocusNode();

  ///al2
  TextEditingController al2TypController = TextEditingController(text: "None");
  Rxn<LedgerModel> al2AccountNoController = Rxn<LedgerModel>();
  TextEditingController al2AccountNoTextController = TextEditingController();
  TextEditingController al2PercController = TextEditingController(text: "0");
  final FocusNode al2AccNoFocusNode = FocusNode();
  final FocusNode al2PercFocusNode = FocusNode();

  ///al3
  TextEditingController al3TypController = TextEditingController(text: "None");
  Rxn<LedgerModel> al3AccountNoController = Rxn<LedgerModel>();
  TextEditingController al3AccountNoTextController = TextEditingController();
  TextEditingController al3PercController = TextEditingController(text: "0");
  final FocusNode al3AccNoFocusNode = FocusNode();
  final FocusNode al3PercFocusNode = FocusNode();

  ///al4
  TextEditingController al4TypController = TextEditingController(text: "None");
  Rxn<LedgerModel> al4AccountNoController = Rxn<LedgerModel>();
  TextEditingController al4AccountNoTextController = TextEditingController();
  TextEditingController al4PercController = TextEditingController(text: "0");
  final FocusNode al4AccNoFocusNode = FocusNode();
  final FocusNode al4PercFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
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
    return GetBuilder<TaxFixController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text("${idController.text == '' ? 'Add' : 'Update'} Tax Fix"),
          actions: [
            Visibility(
              visible: idController.text.isNotEmpty,
              child: MyDeleteIconButton(
                onPressed: (password) {
                  controller.delete(idController.text, password);
                },
              ),
            ),
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
                      Center(
                        child: Wrap(
                          children: [
                            MyTextField(
                              controller: titleController,
                              hintText: "Title",
                              validate: "string",
                              focusNode: _firstInputFocusNode,
                            ),
                            MyDropdownButtonFormField(
                              controller: entryController,
                              hintText: "Entry",
                              items: const [
                                "Product Sales",
                                "JobWork Delivery",
                                "Warp Purchase",
                                "Yarn Purchase",
                                "Yarn Purchase Return",
                                "Process Delivery",
                                "Warp Sales",
                                "Yarn Sales"
                              ],
                            ),
                            MyDropdownButtonFormField(
                              controller: activeController,
                              hintText: "Is Active",
                              items: const ["Yes", "No"],
                            ),
                            MyDropdownButtonFormField(
                              controller: stateController,
                              hintText: "State",
                              items: const [
                                "Local (Intra State)",
                                "Other (Inter State)",
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      gstWidget(),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MySubmitButton(
                            onPressed:
                                controller.status.isLoading ? null : submit,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ),
      );
    });
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "tax_title": titleController.text,
        "entry_type": entryController.text,
        "is_active": activeController.text,
        "state": stateController.text,
        "tax_style": "All are Same"
      };

      // al1
      request["al1_typ"] = al1TypController.text;
      request["al1_perc"] = double.tryParse(al1PercController.text) ?? 0.00;
      request["al1_ano"] = al1AccountNoController.value?.id;
      request["cf1"] = "Goods Value";

      // al2
      request["al2_typ"] = al2TypController.text;
      request["al2_perc"] = double.tryParse(al2PercController.text) ?? 0.00;
      request["al2_ano"] = al2AccountNoController.value?.id;
      request["cf2"] = "Goods Value";

      //al3
      request["al3_typ"] = al3TypController.text;
      request["al3_perc"] = double.tryParse(al3PercController.text) ?? 0.00;
      request["al3_ano"] = al4AccountNoController.value?.id;
      request["cf3"] = "Goods Value";

      ///al4
      request["al4_typ"] = al4TypController.text;
      request["al4_perc"] = double.tryParse(al4PercController.text) ?? 0.00;
      request["al4_ano"] = al4AccountNoController.value?.id;
      request["cf4"] = "Goods Value";

      // return;
      var id = idController.text;
      if (id.isEmpty) {
        controller.add(request);
      } else {
        request['id'] = id;
        // return print(jsonEncode(request));
        controller.updateApi(request);
      }
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      var data = TaxFixingModel.fromJson(Get.arguments['item']);
      idController.text = '${data.id}';
      titleController.text = '${data.taxTitle}';
      activeController.text = data.isActive ?? 'Yes';
      entryController.text = data.entryType ?? 'Product Sales';
      stateController.text = data.state ?? 'Local (Intra State)';

      ///al1
      al1TypController.text = data.al1Typ ?? 'None';
      al1AccountNoTextController.text = tryCast(data.al1AnoName);
      al1AccountNoController.value =
          LedgerModel(id: data.al1Ano, ledgerName: data.al1AnoName);
      al1PercController.text = tryCast(data.al1Perc);

      ///al2
      al2TypController.text = data.al2Typ ?? 'None';
      al2AccountNoTextController.text = tryCast(data.al2AnoName);
      al2AccountNoController.value =
          LedgerModel(id: data.al2Ano, ledgerName: data.al2AnoName);
      al2PercController.text = tryCast(data.al2Perc);

      ///al3
      al3TypController.text = data.al3Typ ?? 'None';
      al3AccountNoTextController.text = tryCast(data.al3AnoName);
      al3AccountNoController.value =
          LedgerModel(id: data.al3Ano, ledgerName: data.al3AnoName);
      al3PercController.text = tryCast(data.al3Perc);

      ///al4
      al4TypController.text = data.al4Typ ?? 'None';
      al4AccountNoTextController.text = tryCast(data.al4AnoName);
      al4AccountNoController.value =
          LedgerModel(id: data.al4Ano, ledgerName: data.al4AnoName);
      al4PercController.text = tryCast(data.al4Perc);
    }
  }

  Widget gstWidget() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 1100,
        color: Colors.white,
        padding: const EdgeInsets.all(12.0),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(.5),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(.5),
          },
          children: [
            const TableRow(
              decoration: BoxDecoration(),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Type",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Account No",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Percentage",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),

            /// al1
            TableRow(
              children: [
                MyDropdownButtonFormField(
                  width: 100,
                  controller: al1TypController,
                  hintText: "",
                  items: const ["None", "Add", "Less"],
                  onChanged: (String item) {
                    al1TypController.text = item;
                    al1AccountNoTextController.text = "";
                    al1AccountNoController.value = null;
                    al1PercController.text = '0';
                  },
                ),
                MySearchField(
                  label: "",
                  isValidate: false,
                  enabled: al1TypController.text != "None",
                  items: controller.ledgerByTax,
                  textController: al1AccountNoTextController,
                  focusNode: al1AccNoFocusNode,
                  requestFocus: al1PercFocusNode,
                  onChanged: (LedgerModel item) {
                    al1AccountNoController.value = item;
                  },
                ),
                MyTextField(
                  focusNode: al1PercFocusNode,
                  controller: al1PercController,
                  enabled: al1TypController.text != "None",
                  validate: "double",
                  suffix: const Text(
                    "%",
                    style: TextStyle(color: Color(0XFF5700BC)),
                  ),
                  hintText: '',
                ),
              ],
            ),

            ///al2
            TableRow(
              children: [
                MyDropdownButtonFormField(
                  controller: al2TypController,
                  hintText: "",
                  items: const ["None", "Add", "Less"],
                  onChanged: (String item) {
                    al2TypController.text = item;
                    al2AccountNoTextController.text = "";
                    al2AccountNoController.value = null;
                    al2PercController.text = '0';
                  },
                ),
                MySearchField(
                  label: "",
                  isValidate: false,
                  enabled: al2TypController.text != "None",
                  items: controller.ledgerByTax,
                  textController: al2AccountNoTextController,
                  focusNode: al2AccNoFocusNode,
                  requestFocus: al2PercFocusNode,
                  onChanged: (LedgerModel item) {
                    al2AccountNoController.value = item;
                  },
                ),
                MyTextField(
                  hintText: "",
                  focusNode: al2PercFocusNode,
                  controller: al2PercController,
                  enabled: al2TypController.text != "None",
                  validate: "double",
                  suffix: const Text(
                    "%",
                    style: TextStyle(color: Color(0XFF5700BC)),
                  ),
                ),
              ],
            ),

            ///al3
            TableRow(
              children: [
                MyDropdownButtonFormField(
                  controller: al3TypController,
                  hintText: "",
                  items: const ["None", "Add", "Less"],
                  onChanged: (String item) {
                    al3TypController.text = item;
                    al3AccountNoTextController.text = "";
                    al3AccountNoController.value = null;
                    al3PercController.text = '0';
                  },
                ),
                MySearchField(
                  label: "",
                  isValidate: false,
                  enabled: al3TypController.text != "None",
                  items: controller.ledgerByTax,
                  textController: al3AccountNoTextController,
                  focusNode: al3AccNoFocusNode,
                  requestFocus: al3PercFocusNode,
                  onChanged: (LedgerModel item) {
                    al3AccountNoController.value = item;
                  },
                ),
                MyTextField(
                  hintText: "",
                  focusNode: al3PercFocusNode,
                  controller: al3PercController,
                  enabled: al3TypController.text != "None",
                  validate: "double",
                  suffix: const Text("%",
                      style: TextStyle(color: Color(0XFF5700BC))),
                ),
              ],
            ),

            ///al4
            TableRow(
              children: [
                MyDropdownButtonFormField(
                  controller: al4TypController,
                  hintText: "",
                  items: const ["None", "Add", "Less"],
                  onChanged: (String item) {
                    al4TypController.text = item;
                    al4AccountNoTextController.text = "";
                    al4AccountNoController.value = null;
                    al4PercController.text = '0';
                  },
                ),
                MySearchField(
                  label: "",
                  isValidate: false,
                  enabled: al4TypController.text != "None",
                  items: controller.ledgerByTax,
                  textController: al4AccountNoTextController,
                  focusNode: al4AccNoFocusNode,
                  requestFocus: al4PercFocusNode,
                  onChanged: (LedgerModel item) {
                    al4AccountNoController.value = item;
                  },
                ),
                MyTextField(
                  hintText: "",
                  focusNode: al4PercFocusNode,
                  controller: al4PercController,
                  enabled: al4TypController.text != "None",
                  validate: "double",
                  suffix: const Text(
                    "%",
                    style: TextStyle(color: Color(0XFF5700BC)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
