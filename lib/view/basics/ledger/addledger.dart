import 'dart:io';

import 'package:abtxt/model/AccountTypeModel.dart';
import 'package:abtxt/utils/constant.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:dio/src/multipart_file.dart' as DioMultipartFile;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../http/http_urls.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/ledger_role_model.dart';
import '../../../widgets/LabeledCheckbox.dart';
import '../../../widgets/MultiSelect.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import 'ledger_controller.dart';

class AddLedger extends StatefulWidget {
  const AddLedger({Key? key}) : super(key: key);
  static const String routeName = '/addledger';

  @override
  State<AddLedger> createState() => _State();
}

class _State extends State<AddLedger> {
  TextEditingController enterLedgerNameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController shortCodeController = TextEditingController();
  TextEditingController activeController = TextEditingController(text: 'Yes');
  Rxn<AccountTypeModel> accountname = Rxn<AccountTypeModel>();
  TextEditingController accountNameController = TextEditingController();
  Rxn<FirmModel> firmname = Rxn<FirmModel>();
  TextEditingController referredByController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController transportController = TextEditingController();
  TextEditingController altMobileNoController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController faxController = TextEditingController();
  TextEditingController tINNoController = TextEditingController();
  TextEditingController panNoController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  RxList<LedgerRoleModel> selectedRoles = RxList<LedgerRoleModel>([]);

  TextEditingController linkThroughController =
      TextEditingController(text: 'Self');
  TextEditingController llNameController = TextEditingController();

  final RxString _selectedEntryType = RxString(Constants.LINK_THROUGH[0]);

  TextEditingController registration = TextEditingController();

  TextEditingController pincodeController = TextEditingController();

  TextEditingController agentNameController = TextEditingController();
  TextEditingController aadhaarNoController = TextEditingController();
  TextEditingController gstNoController = TextEditingController();

  var s_yarn_status = false.obs;
  var s_warp_status = false.obs;
  var s_product_status = false.obs;

  var c_yarn_status = false.obs;
  var c_warp_status = false.obs;
  var c_product_status = false.obs;

  final _formKey = GlobalKey<FormState>();
  final supplierFormKey = GlobalKey<FormState>();
  final customerFormKey = GlobalKey<FormState>();
  late LedgerController controller;
  Rxn<File>? image = Rxn<File>();
  var imageUrl = Rxn<String>();
  var itemSelected = ''.obs;
  final FocusNode _firstInputFocusNode = FocusNode();

  @override
  void initState() {
    selectedRoles = RxList<LedgerRoleModel>([]);
    itemSelected = ''.obs;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_firstInputFocusNode);
    });
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LedgerController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title: Text("${idController.text == '' ? 'Add' : 'Update'} Ledger"),
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
        // bindings: {
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
        //       Get.back(),
        //   const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
        //       submit(),
        // },
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
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: const Color(0xFFF9F3FF), width: 16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: imageWidget(),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(
                          //color: Colors.green,
                          padding: const EdgeInsets.all(16),
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
                                  MyTextField(
                                    controller: enterLedgerNameController,
                                    hintText: "Ledger Name",
                                    validate: "string",
                                    focusNode: _firstInputFocusNode,
                                  ),
                                  MyTextField(
                                    controller: shortCodeController,
                                    hintText: "Short Code",
                                  ),
                                  MyDropdownButtonFormField(
                                    controller: activeController,
                                    hintText: "Is Active",
                                    items: const ["Yes", "No"],
                                  ),
                                  MyAutoComplete(
                                    label: 'Account Type',
                                    items: controller.accountGroup,
                                    selectedItem: accountname.value,
                                    onChanged: (AccountTypeModel item) {
                                      accountname.value = item;
                                    },
                                  ),
                                  Obx(
                                    () => Visibility(
                                      visible: accountname.value?.name ==
                                              'Bank Accounts' ||
                                          accountname.value?.name ==
                                              "Bank OCC A/c" ||
                                          accountname.value?.name ==
                                              "Bank OD A/c",
                                      child: MyAutoComplete(
                                        label: 'Firm',
                                        items: controller.firm_dropdown,
                                        selectedItem: firmname.value,
                                        isValidate: false,
                                        onChanged: (FirmModel item) {
                                          firmname.value = item;
                                        },
                                      ),
                                    ),
                                  ),
                                  MyTextField(
                                    controller: referredByController,
                                    hintText: "Referred By",
                                  ),
                                  MyTextField(
                                    controller: streetController,
                                    hintText: "Street",
                                  ),
                                  MyTextField(
                                    controller: areaController,
                                    hintText: "Area",
                                  ),
                                  MyTextField(
                                    controller: cityController,
                                    hintText: "City",
                                  ),
                                  MyTextField(
                                    controller: pinController,
                                    hintText: "Pin Code",
                                  ),
                                  MyTextField(
                                    controller: stateController,
                                    hintText: "State",
                                  ),
                                  MyTextField(
                                    controller: countryController,
                                    hintText: "Country",
                                  ),
                                  MyTextField(
                                    controller: transportController,
                                    hintText: "Transport",
                                  ),
                                  MyTextField(
                                    controller: mobileNoController,
                                    hintText: "Mobile No",
                                    inputType: TextInputType.phone,
                                  ),
                                  MyTextField(
                                    controller: altMobileNoController,
                                    hintText: "Alt Mobile No",
                                  ),
                                  MyTextField(
                                    controller: emailController,
                                    hintText: "Email",
                                    inputType: TextInputType.emailAddress,
                                  ),
                                  MyTextField(
                                    controller: faxController,
                                    hintText: "Fax",
                                  ),
                                  MyTextField(
                                    controller: tINNoController,
                                    hintText: "TIN No",
                                  ),
                                  MyTextField(
                                    controller: panNoController,
                                    hintText: "PAN No",
                                  ),
                                  MyTextField(
                                    controller: detailsController,
                                    hintText: "Details",
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DropDownMultiSelect(
                                    onChanged: (List<LedgerRoleModel> list) {
                                      selectedRoles.value = <LedgerRoleModel>[];
                                      selectedRoles.value = list;
                                      //selectedRoles.value = list.isNotEmpty ? list : <LedgerRoleModel>[];
                                    },
                                    labelText: 'Role',
                                    options: controller.ledgerRoles,
                                    selectedValues: selectedRoles.value,
                                    /*validator: (value) =>
                                          selectedRoles.value.isEmpty
                                              ? 'Required'
                                              : null,*/
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      /*Obx(() => Visibility(
                                          visible: selectedRoles.value.where((e) => e.name == 'Supplier').isNotEmpty,
                                          child: Container(
                                            width: 320,
                                            color: Color(0xFFFAFAFA),
                                            padding: EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(' Supplier'),
                                                Wrap(
                                                  children: [
                                                    Obx(
                                                          () => LabeledCheckbox(
                                                        label: "Yarn",
                                                        value: s_yarn_status.value,
                                                        onChanged: (value) {
                                                          s_yarn_status.value = value;
                                                        },
                                                      ),
                                                    ),
                                                    Obx(
                                                          () => LabeledCheckbox(
                                                        label: "Warp",
                                                        value: s_warp_status.value,
                                                        onChanged: (value) {
                                                          s_warp_status.value = value;
                                                        },
                                                      ),
                                                    ),
                                                    Obx(
                                                          () => LabeledCheckbox(
                                                        label: "Product",
                                                        value: s_product_status.value,
                                                        onChanged: (value) {
                                                          s_product_status.value = value;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                        Obx(() => Visibility(
                                          visible: selectedRoles.value.where((e) => e.name == 'Customer').isNotEmpty,
                                          child: Container(
                                            width: 320,
                                            color: Color(0xFFFAFAFA),
                                            padding: EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(' Customer'),
                                                Wrap(
                                                  children: [
                                                    Obx(
                                                          () => LabeledCheckbox(
                                                        label: "Yarn",
                                                        value: c_yarn_status.value,
                                                        onChanged: (value) {
                                                          c_yarn_status.value = value;
                                                        },
                                                      ),
                                                    ),
                                                    Obx(
                                                          () => LabeledCheckbox(
                                                        label: "Warp",
                                                        value: c_warp_status.value,
                                                        onChanged: (value) {
                                                          c_warp_status.value = value;
                                                        },
                                                      ),
                                                    ),
                                                    Obx(
                                                          () => LabeledCheckbox(
                                                        label: "Product",
                                                        value: c_product_status.value,
                                                        onChanged: (value) {
                                                          c_product_status.value = value;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),*/
                                      Obx(() {
                                        if (selectedRoles.value
                                            .where((e) => e.name == 'Supplier')
                                            .isNotEmpty) {
                                          return Container(
                                            width: 320,
                                            color: const Color(0xFFFAFAFA),
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Text(' Supplier'),
                                                Wrap(
                                                  children: [
                                                    Obx(
                                                      () => LabeledCheckbox(
                                                        label: "Yarn",
                                                        value:
                                                            s_yarn_status.value,
                                                        onChanged: (value) {
                                                          s_yarn_status.value =
                                                              value;
                                                        },
                                                      ),
                                                    ),
                                                    Obx(
                                                      () => LabeledCheckbox(
                                                        label: "Warp",
                                                        value:
                                                            s_warp_status.value,
                                                        onChanged: (value) {
                                                          s_warp_status.value =
                                                              value;
                                                        },
                                                      ),
                                                    ),
                                                    Obx(
                                                      () => LabeledCheckbox(
                                                        label: "Product",
                                                        value: s_product_status
                                                            .value,
                                                        onChanged: (value) {
                                                          s_product_status
                                                              .value = value;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                      Obx(() {
                                        if (selectedRoles.value
                                            .where((e) => e.name == 'Customer')
                                            .isNotEmpty) {
                                          return Container(
                                            width: 320,
                                            color: const Color(0xFFFAFAFA),
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Text(' Customer'),
                                                Wrap(
                                                  children: [
                                                    Obx(
                                                      () => LabeledCheckbox(
                                                        label: "Yarn",
                                                        value:
                                                            c_yarn_status.value,
                                                        onChanged: (value) {
                                                          c_yarn_status.value =
                                                              value;
                                                        },
                                                      ),
                                                    ),
                                                    Obx(
                                                      () => LabeledCheckbox(
                                                        label: "Warp",
                                                        value:
                                                            c_warp_status.value,
                                                        onChanged: (value) {
                                                          c_warp_status.value =
                                                              value;
                                                        },
                                                      ),
                                                    ),
                                                    Obx(
                                                      () => LabeledCheckbox(
                                                        label: "Product",
                                                        value: c_product_status
                                                            .value,
                                                        onChanged: (value) {
                                                          c_product_status
                                                              .value = value;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                              Wrap(
                                children: [
                                  MyDropdownButtonFormField(
                                    controller: linkThroughController,
                                    hintText: "Link Through",
                                    items: const [
                                      'Self',
                                      'Agent',
                                    ],
                                    onChanged: (value) {
                                      _selectedEntryType.value = value;
                                    },
                                  ),
                                  Obx(() {
                                    if (_selectedEntryType.value == 'Agent') {
                                      return MyTextField(
                                        controller: agentNameController,
                                        hintText: "Agent Name",
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
                                  /*MyDropdownButtonFormFieldNew(
                                      controller: registration,
                                      hintText: "Registration",
                                      items: Constants.Ledger_Registration,
                                    ),*/
                                  MyDropdownButtonFormField(
                                    controller: registration,
                                    hintText: "Registration",
                                    items: const [
                                      'Registered',
                                      'Un Registered'
                                    ],
                                  ),
                                  MyTextField(
                                    controller: aadhaarNoController,
                                    hintText: "Aadhaar Card No",
                                  ),
                                  MyTextField(
                                    controller: gstNoController,
                                    hintText: "GST No",
                                    validate: 'gst',
                                  ),
                                  MyTextField(
                                    controller: llNameController,
                                    hintText: "Enter L.L Name",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  /*crateAndUpdatedBy(),
                                  const Spacer(),*/
                                  MySubmitButton(
                                    onPressed: controller.status.isLoading
                                        ? null
                                        : submit,
                                    // child: Text("${Get.arguments == null ? 'Save' : 'Update'}"),
                                  ),
                                ],
                              )
                            ],
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

  // Widget widgetRoleSelect(String option) {
  //   option = selecteRole;
  //
  //   if (option == 'Supplier') {
  //     return Form(
  //       key: supplierFormKey,
  //       child: Wrap(
  //         children: [
  //           Container()
  //         ],
  //       ),
  //     );
  //   }   else if (option == 'Customer') {
  //     return Form(
  //       key: supplierFormKey,
  //       child: Wrap(
  //         children: [
  //           Container()
  //         ],
  //       ),
  //     );
  //   }
  //   else {
  //     return Container(
  //       width: 240,
  //     );
  //   }
  // }

  submit() async {
    var entryType = _selectedEntryType.value.toString();

    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "ledger_name": enterLedgerNameController.text,
        "short_code": shortCodeController.text,
        "is_active": activeController.text,
        "accout_type": accountname.value?.name ?? '',
        "firm_id": firmname.value?.id ?? '',
        "street": streetController.text,
        "area": areaController.text,
        "city": cityController.text,
        "pincode": pinController.text,
        "state": stateController.text,
        "country": countryController.text,
        "transport": transportController.text,
        "phone": altMobileNoController.text,
        "mobile_no": mobileNoController.text,
        "email": emailController.text,
        "fax": faxController.text,
        "tin_no": tINNoController.text,
        "details": detailsController.text ?? '',
        "pan_no": panNoController.text ?? '',
        "link_through": linkThroughController.text,
        "regtyp": registration.text == 'Registered' ? 'R' : 'U',
        "agent_name": agentNameController.text,
        "aadhar_no": aadhaarNoController.text,
        "gst_no": gstNoController.text,
        "ll_name": llNameController.text,
        "s_yarn_status": s_yarn_status.value ? "Yes" : "No",
        "s_warp_status": s_warp_status.value ? "Yes" : "No",
        "s_product_status": s_product_status.value ? "Yes" : "No",
        "c_yarn_status": c_yarn_status.value ? "Yes" : "No",
        "c_warp_status": c_warp_status.value ? "Yes" : "No",
        "c_product_status": c_product_status.value ? "Yes" : "No",
        // "warp_colour": selecteRole.value.join(','),
      };
      //"supplier":null,"customer":null,"warper":null,"weaver":null,"dyer":null,"roller":null,"employee":null,"processor":null,"job_worker":null,"winder":null

      request['supplier'] =
          selectedRoles.where((e) => e.name == 'Supplier').isNotEmpty
              ? 'Yes'
              : 'No';
      request['customer'] =
          selectedRoles.where((e) => e.name == 'Customer').isNotEmpty
              ? 'Yes'
              : 'No';
      request['warper'] =
          selectedRoles.where((e) => e.name == 'Warper').isNotEmpty
              ? 'Yes'
              : 'No';
      request['weaver'] =
          selectedRoles.where((e) => e.name == 'Weaver').isNotEmpty
              ? 'Yes'
              : 'No';
      request['dyer'] = selectedRoles.where((e) => e.name == 'Dyer').isNotEmpty
          ? 'Yes'
          : 'No';
      request['roller'] =
          selectedRoles.where((e) => e.name == 'Roller').isNotEmpty
              ? 'Yes'
              : 'No';
      request['employee'] =
          selectedRoles.where((e) => e.name == 'Employee').isNotEmpty
              ? 'Yes'
              : 'No';
      request['processor'] =
          selectedRoles.where((e) => e.name == 'Processor').isNotEmpty
              ? 'Yes'
              : 'No';
      request['job_worker'] =
          selectedRoles.where((e) => e.name == 'Job_Worker').isNotEmpty
              ? 'Yes'
              : 'No';
      request['winder'] =
          selectedRoles.where((e) => e.name == 'Winder').isNotEmpty
              ? 'Yes'
              : 'No';
      request['operator'] =
          selectedRoles.where((e) => e.name == 'Operator').isNotEmpty
              ? 'Yes'
              : 'No';

      if (image?.value != null) {
        String fileName = '${image?.value?.path.split('/').last}';
        request['image'] = await DioMultipartFile.MultipartFile.fromFile(
          '${image!.value?.path}',
          filename: fileName,
        );
      }
      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.addLedger(requestPayload);
      } else {
        request['id'] = id;
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.updateLedger(requestPayload);
      }
    }
  }

  void _initValue() async {
    LedgerController controller = Get.find();
    controller.request = <String, dynamic>{};
    registration.text = 'Registered';
    countryController.text = 'India';

    if (Get.arguments != null) {
      LedgerController controller = Get.find();
      var ledger = LedgerModel.fromJson(Get.arguments['item']);
      idController.text = '${ledger.id}';
      imageUrl.value = '${HttpUrl.baseUrl}${ledger.image}';
      enterLedgerNameController.text = ledger.ledgerName ?? '';
      shortCodeController.text = ledger.shortCode ?? '';

      var accountTypeList = controller.accountGroup
          .where((element) => '${element.name}' == '${ledger.accoutType}')
          .toList();
      if (accountTypeList.isNotEmpty) {
        accountname.value = accountTypeList.first;
        accountNameController.text = '${accountTypeList.first.name}';
      }

      //var dd = await controller.warpColorInfo();
      var firmName = controller.firm_dropdown
          .where((element) => '${element.id}' == '${ledger.firmId}')
          .toList();
      if (firmName.isNotEmpty) {
        firmname.value = firmName.first;
      }

      referredByController.text = ledger.referredBy ?? '';

      activeController.text = ledger.isActive ?? 'Yes';
      streetController.text = ledger.street ?? '';
      areaController.text = ledger.area ?? '';
      cityController.text = ledger.city ?? '';
      pinController.text = ledger.pincode ?? '';
      stateController.text = ledger.state ?? '';
      countryController.text = ledger.country ?? '';
      transportController.text = ledger.transport ?? '';
      altMobileNoController.text = ledger.phone ?? '';
      mobileNoController.text = ledger.mobileNo ?? '';
      emailController.text = ledger.email ?? '';
      faxController.text = ledger.fax ?? '';
      tINNoController.text = ledger.tinNo ?? '';
      detailsController.text = ledger.details ?? '';
      panNoController.text = ledger.panNo ?? '';
      agentNameController.text = ledger.agentName ?? '';
      llNameController.text = ledger.llName ?? '';
      streetController.text = ledger.street ?? '';
      aadhaarNoController.text = ledger.aadharNo ?? '';
      gstNoController.text = ledger.gstNo ?? '';
      s_warp_status.value = '${ledger.sWarpStatus}' == 'Yes' ? true : false;
      s_yarn_status.value = '${ledger.sYarnStatus}' == 'Yes' ? true : false;
      s_product_status.value =
          '${ledger.sProductStatus}' == 'Yes' ? true : false;

      c_warp_status.value = '${ledger.cWarpStatus}' == 'Yes' ? true : false;
      c_yarn_status.value = '${ledger.cYarnStatus}' == 'Yes' ? true : false;
      c_product_status.value =
          '${ledger.cProductStatus}' == 'Yes' ? true : false;

      if (Constants.LINK_THROUGH.contains(ledger.linkThrough)) {
        linkThroughController.text = '${ledger.linkThrough}';
      }
      if (ledger.regtyp == 'R') {
        registration.text = 'Registered';
      } else {
        registration.text = 'Un Registered';
      }
      // if (Constants.ISACTIVE.contains(ledger.isActive)) {
      //   registration.text = '${ledger.isActive}';
      // }

      if (ledger.supplier == 'Yes') {
        var ldd =
            controller.ledgerRoles.where((e) => e.name == 'Supplier').toList();
        selectedRoles.addAll(ldd);
      }
      if (ledger.customer == 'Yes') {
        var ldd =
            controller.ledgerRoles.where((e) => e.name == 'Customer').toList();
        selectedRoles.addAll(ldd);
      }
      if (ledger.warper == 'Yes') {
        var ldd =
            controller.ledgerRoles.where((e) => e.name == 'Warper').toList();
        selectedRoles.addAll(ldd);
      }
      if (ledger.weaver == 'Yes') {
        var ldd =
            controller.ledgerRoles.where((e) => e.name == 'Weaver').toList();
        selectedRoles.addAll(ldd);
      }
      if (ledger.dyer == 'Yes') {
        var ldd =
            controller.ledgerRoles.where((e) => e.name == 'Dyer').toList();
        selectedRoles.addAll(ldd);
      }
      if (ledger.roller == 'Yes') {
        var ldd =
            controller.ledgerRoles.where((e) => e.name == 'Roller').toList();
        selectedRoles.addAll(ldd);
      }
      if (ledger.employee == 'Yes') {
        var ldd =
            controller.ledgerRoles.where((e) => e.name == 'Employee').toList();
        selectedRoles.addAll(ldd);
      }
      if (ledger.processor == 'Yes') {
        var ldd =
            controller.ledgerRoles.where((e) => e.name == 'Processor').toList();
        selectedRoles.addAll(ldd);
      }
      if (ledger.jobWorker == 'Yes') {
        var ldd = controller.ledgerRoles
            .where((e) => e.name == 'Job_Worker')
            .toList();
        selectedRoles.addAll(ldd);
      }
      if (ledger.winder == 'Yes') {
        var ldd =
            controller.ledgerRoles.where((e) => e.name == 'Winder').toList();
        selectedRoles.addAll(ldd);
      }
      if (ledger.operator == 'Yes') {
        var ldd =
            controller.ledgerRoles.where((e) => e.name == 'Operator').toList();
        selectedRoles.addAll(ldd);
      }
    }
  }

  Widget imageWidget() {
    return Obx(() => Container(
          margin: const EdgeInsets.all(8),
          width: 230,
          height: 230,
          child: InkWell(
            canRequestFocus: false,
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg', 'png', 'jpeg'],
              );
              if (result != null) {
                image?.value = File('${result.files.single.path}');
              }
            },
            child: image?.value != null
                ? Image.file(
                    File('${image?.value?.path}'),
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: '${imageUrl.value}',
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Image.asset(
                      Constants.placeHolderPath,
                      fit: BoxFit.contain,
                    ),
                  ),
          ),
        ));
  }

/*  Widget crateAndUpdatedBy() {
    String id = idController.text;
    String formattedDate = AppUtils.dateFormatter.format(DateTime.now());
    String? createdAt;
    String? updatedAt;
    String? entryBy;

    if (Get.arguments != null) {
      var item = Get.arguments["item"];
      DateTime createDate = DateTime.parse(item["created_at"] ?? "0000-00-00");
      DateTime updateDate = DateTime.parse(item["updated_at"] ?? "0000-00-00");
      createdAt = AppUtils.dateFormatter.format(createDate);
      updatedAt = AppUtils.dateFormatter.format(updateDate);

      entryBy = item["creator_name"] ?? '';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          id.isEmpty ? AppUtils().loginName : "$entryBy",
          style: AppUtils.updateAndCreateTextStyle(),
        ),
        const SizedBox(width: 12),
        Text(
          id.isEmpty ? formattedDate : "${updatedAt ?? createdAt}",
          style: AppUtils.updateAndCreateTextStyle(),
        )
      ],
    );
  }*/
}
