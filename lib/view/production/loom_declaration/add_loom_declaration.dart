import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/LedgerModel.dart';
import '../../../model/loom_declaration_model.dart';
import '../../../widgets/LabeledCheckbox.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/searchfield/decoration.dart';
import '../../../widgets/searchfield/searchfield.dart';
import '../../basics/ledger/addledger.dart';
import 'loom_declaration_controller.dart';

class AddLoomDeclaration extends StatefulWidget {
  const AddLoomDeclaration({super.key});

  static const String routeName = '/add_loom_declaration';

  @override
  State<AddLoomDeclaration> createState() => _State();
}

class _State extends State<AddLoomDeclaration> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> weaverController = Rxn<LedgerModel>();
  TextEditingController weaverNameController = TextEditingController();
  TextEditingController loomController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController llnameController = TextEditingController();
  TextEditingController activeController = TextEditingController(text: "Yes");
  TextEditingController statusController =
      TextEditingController(text: "Nothing");
  TextEditingController breakController = TextEditingController(text: "");
  TextEditingController typeController = TextEditingController();

  var sunday = false.obs;
  var monday = false.obs;
  var tuesday = false.obs;
  var wednesday = false.obs;
  var thursday = false.obs;
  var friday = false.obs;
  var saturday = false.obs;
  final _formKey = GlobalKey<FormState>();
  late LoomDeclarationController controller;
  RxBool isUpdate = RxBool(false);

  /// Focus Nodes
  final FocusNode _weaverFocusNode = FocusNode();
  final FocusNode _loomNoFocusNode = FocusNode();
  var shortCut = RxString("");

  @override
  void initState() {
    _initValue();
    _weaverFocusNode.addListener(() => shortCutKeys());
    super.initState();
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_loomNoFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoomDeclarationController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Loom Declaration"),
          actions: [
            Visibility(
                visible: idController.text.isNotEmpty,
                child: MyDeleteIconButton(
                  onPressed: (password) {
                    controller.delete(idController.text, password);
                  },
                )),
            const SizedBox(width: 12),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true):
              NavigateAnotherPageIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            NavigateAnotherPageIntent: SetCounterAction(perform: () {
              navigateAnotherPage();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                child: Form(
                  key: _formKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: FocusTraversalGroup(
                          policy: OrderedTraversalPolicy(),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                weaverNameDropDownWidget(),
                                /*Focus(
                                  focusNode: _weaverFocusNode,
                                  skipTraversal: true,
                                  child: MyAutoComplete(
                                    forceNextFocus: true,
                                    label: 'Weaver Name',
                                    items: controller.Weaver,
                                    selectedItem: weaverController.value,
                                    enabled: !isUpdate.value,
                                    onChanged: (LedgerModel item) async {
                                      weaverController.value = item;
                                      clearTheControllers();
                                      WeaverIdByAccountDetails? data =
                                          await controller
                                              .weaverIdByAccount(item.id);
                                      accountDetails(data);
                                    },
                                  ),
                                ),*/
                                MyTextField(
                                  controller: loomController,
                                  hintText: "Loom No",
                                  validate: "string",
                                  focusNode: _loomNoFocusNode,
                                ),
                                MyTextField(
                                  controller: llnameController,
                                  hintText: "L.L Name",
                                ),
                                MyTextField(
                                  controller: detailsController,
                                  hintText: "Details",
                                ),
                                MyDropdownButtonFormField(
                                  controller: breakController,
                                  hintText: "Break",
                                  items: const ["", "Left", "Right"],
                                ),
                                /*MyDialogList(
                                    labelText: 'Break',
                                    isValidate: false,
                                    controller: breakController,
                                    list: const ["Left", "Right"],
                                    onItemSelected: (String item) {
                                      breakController.text = item;
                                    },
                                    onCreateNew: (value) async {},
                                  ),*/
                                Row(
                                  children: [
                                    MyDateField(
                                      controller: dateController,
                                      hintText: "Intro. Date",
                                      validate: "string",
                                      readonly: true,
                                    ),
                                    MyDropdownButtonFormField(
                                      hintText: 'Type',
                                      controller: typeController,
                                      items: const [
                                        "",
                                        "Under Pick",
                                        "Pick & Pick",
                                        "Power Loom",
                                        "Draw Box",
                                        "Rapiar Loom",
                                        "Auto Loom",
                                        "Hand Loom",
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Text("  Weekly Inward Days"),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Obx(
                                      () => LabeledCheckbox(
                                        label: "Sun",
                                        value: sunday.value,
                                        onChanged: (value) {
                                          sunday.value = value;
                                        },
                                      ),
                                    ),
                                    Obx(
                                      () => LabeledCheckbox(
                                        label: "Mon",
                                        value: monday.value,
                                        onChanged: (value) {
                                          monday.value = value;
                                        },
                                      ),
                                    ),
                                    Obx(
                                      () => LabeledCheckbox(
                                        label: "Tue",
                                        value: tuesday.value,
                                        onChanged: (value) {
                                          tuesday.value = value;
                                        },
                                      ),
                                    ),
                                    Obx(
                                      () => LabeledCheckbox(
                                        label: "Wed",
                                        value: wednesday.value,
                                        onChanged: (value) {
                                          wednesday.value = value;
                                        },
                                      ),
                                    ),
                                    Obx(
                                      () => LabeledCheckbox(
                                        label: "Thu",
                                        value: thursday.value,
                                        onChanged: (value) {
                                          thursday.value = value;
                                        },
                                      ),
                                    ),
                                    Obx(
                                      () => LabeledCheckbox(
                                        label: "Fri",
                                        value: friday.value,
                                        onChanged: (value) {
                                          friday.value = value;
                                        },
                                      ),
                                    ),
                                    Obx(
                                      () => LabeledCheckbox(
                                        label: "Sat",
                                        value: saturday.value,
                                        onChanged: (value) {
                                          saturday.value = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                MyDropdownButtonFormField(
                                  controller: activeController,
                                  hintText: "Is Active?",
                                  items: const ["Yes", "No", "Virtual Loom"],
                                ),
                                MyDropdownButtonFormField(
                                  controller: statusController,
                                  hintText: "Status",
                                  items: const ["Nothing"],
                                  enabled: !isUpdate.value,
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Obx(
                                      () => Text(shortCut.value,
                                          style: AppUtils.shortCutTextStyle()),
                                    ),
                                    const SizedBox(width: 12),
                                    MySubmitButton(
                                      onPressed: controller.status.isLoading
                                          ? null
                                          : submit,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
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

  submit() async {
    if (_formKey.currentState!.validate()) {
      if (weaverController.value == null) {
        return AppUtils.infoAlert(message: "Select the weaver name");
      }

      Map<String, dynamic> request = {
        "weaver_id": weaverController.value?.id,
        "intro_date": dateController.text,
        "details": detailsController.text,
        "ll_name": llnameController.text,
        "is_active": activeController.text,
        "loom_status": statusController.text,
        "sub_weaver_no": loomController.text.toUpperCase(),
        "lm_break": breakController.text == "" ? null : breakController.text,
        "loom_type": typeController.text == "" ? null : typeController.text,
        "sunday": sunday.value == true ? "Yes" : "No",
        "monday": monday.value == true ? "Yes" : "No",
        "tuesday": tuesday.value == true ? "Yes" : "No",
        "wednesday": wednesday.value == true ? "Yes" : "No",
        "thursday": thursday.value == true ? "Yes" : "No",
        "friday": friday.value == true ? "Yes" : "No",
        "saterday": saturday.value == true ? "Yes" : "No",
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
    LoomDeclarationController controller = Get.find();
    dateController.text = AppUtils.parseDateTime('${DateTime.now()}');
    controller.request = <String, dynamic>{};

    if (Get.arguments != null) {
      isUpdate.value = true;
      LoomDeclarationController controller = Get.find();
      var data = LoomDeclarationModel.fromJson(Get.arguments['item']);
      idController.text = '${data.id}';
      loomController.text = '${data.subWeaverNo}';
      llnameController.text = tryCast(data.llName);
      detailsController.text = tryCast(data.details);
      breakController.text = tryCast(data.lmBreak);
      dateController.text = '${data.introDate}';
      typeController.text = tryCast(data.loomType);
      sunday.value = data.sunday == "Yes" ? true : false;
      monday.value = data.monday == "Yes" ? true : false;
      tuesday.value = data.tuesday == "Yes" ? true : false;
      wednesday.value = data.wednesday == "Yes" ? true : false;
      thursday.value = data.thursday == "Yes" ? true : false;
      friday.value = data.friday == "Yes" ? true : false;
      saturday.value = data.saterday == "Yes" ? true : false;
      activeController.text = "${data.isActive}";
      statusController.text = "${data.loomStatus}";

      // Weaver
      var weaverList = controller.Weaver.where(
          (element) => '${element.id}' == '${data.weaverId}').toList();
      if (weaverList.isNotEmpty) {
        weaverController.value = weaverList.first;
        weaverNameController.text = "${weaverList.first.ledgerName}";
      }
    }
  }

  shortCutKeys() {
    if (_weaverFocusNode.hasFocus && Get.arguments == null) {
      shortCut.value = "To Create 'Weaver',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  navigateAnotherPage() async {
    if (_weaverFocusNode.hasFocus && Get.arguments == null) {
      var result = await Get.toNamed(AddLedger.routeName);

      if (result == "success") {
        controller.weaverInfo();
      }
    }
  }

  weaverNameDropDownWidget() {
    var list = controller.Weaver;
    var suggestions = list.map(
      (e) {
        return SearchFieldListItem<LedgerModel>('${e.ledgerName}', item: e);
      },
    ).toList();
    return Container(
      width: 240,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: SearchField<LedgerModel>(
        suggestions: suggestions,
        maxSuggestionsInViewPort: 7,
        itemHeight: 50,
        controller: weaverNameController,
        searchInputDecoration: const InputDecoration(
            label: Text('Weaver Name'),
            labelStyle: TextStyle(fontSize: 14),
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
            ),
            suffixIcon: Icon(Icons.arrow_drop_down)),
        suggestionsDecoration:
            SuggestionDecoration(selectionColor: const Color(0xffA3D8FF)),
        focusNode: _weaverFocusNode,
        autofocus: true,
        enabled: !isUpdate.value,
        onScroll: (a, b) {},
        onSuggestionTap: (value) async {
          FocusScope.of(context).requestFocus(_loomNoFocusNode);
          var item = value.item!;
          weaverController.value = item;
        },
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (weaverNameController.text.isEmpty) {
            return "Required";
          } else {
            return null;
          }
        },
      ),
    );
  }
}
