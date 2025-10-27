import 'dart:io';

import 'package:abtxt/model/DropModel.dart';
import 'package:abtxt/model/LoomGroup.dart';
import 'package:abtxt/model/weaving_models/WeaverLoomDetailsModel.dart';
import 'package:abtxt/model/weaving_models/WeavingProductListModel.dart';
import 'package:abtxt/model/weaving_models/WeavingRunningProductModel.dart';
import 'package:abtxt/view/production/weaving/weaving_controller.dart';
import 'package:abtxt/widgets/my_autocompletes/loom_autocomplete.dart';
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
import '../../../model/WeavingAccount.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/searchfield/decoration.dart';
import '../../../widgets/searchfield/searchfield.dart';

class WeavingNewRecordScreen extends StatefulWidget {
  const WeavingNewRecordScreen({super.key});

  static const String routeName = '/weaving_new_record_screen';

  @override
  State<WeavingNewRecordScreen> createState() => _State();
}

class _State extends State<WeavingNewRecordScreen> {
  TextEditingController idController = TextEditingController();
  Rxn<DropModel> weaverName = Rxn<DropModel>();
  Rxn<LoomGroup> loomNo = Rxn<LoomGroup>();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  Rxn<WeavingProductListModel> productName = Rxn<WeavingProductListModel>();
  Rxn<LedgerModel> wagesAccount = Rxn<LedgerModel>();
  TextEditingController wagesController = TextEditingController();
  TextEditingController deductionController = TextEditingController(text: "0");
  TextEditingController transactionTypeController =
      TextEditingController(text: "Fresh");
  TextEditingController weavingTypeController =
      TextEditingController(text: "Qty");
  TextEditingController designNoController = TextEditingController();
  TextEditingController copsReelsController = TextEditingController(text: "No");
  TextEditingController widthPickController =
      TextEditingController(text: "Yes");
  TextEditingController pinningController = TextEditingController(text: "No");
  TextEditingController privateWrController =
      TextEditingController(text: "Yes");

  ScrollController scroll = ScrollController();
  RxBool isUpdate = RxBool(false);
  RxBool firmUpdate = RxBool(false);
  Rxn<File>? image = Rxn<File>();
  var imageUrl = Rxn<String>();

  final _formKey = GlobalKey<FormState>();
  late WeavingController controller;

  RxList productionEntryType = <dynamic>[
    {'entry_type': "Warp Delivery", 'active': true},
    {'entry_type': "Yarn Delivery", 'active': true},
    {'entry_type': "Goods Inward", 'active': true},
    {'entry_type': "Payment", 'active': true},
    {'entry_type': "Empty - (In / Out)", 'active': true},
    {'entry_type': "Receipt", 'active': true},
    {'entry_type': "Rtrn-Yarn", 'active': true},
    {'entry_type': "Credit", 'active': true},
    {'entry_type': "Debit", 'active': true},
    {'entry_type': "Yarn Wastage", 'active': true},
    {'entry_type': "Warp Excess", 'active': true},
    {'entry_type': "Message", 'active': true},
    {'entry_type': "Warp Shortage", 'active': true},
    {'entry_type': "Trsfr - Amount", 'active': true},
    // {'entry_type': "Trsfr - Cops,Reel", 'active': true},
    {'entry_type': "Trsfr - Empty", 'active': true},
    {'entry_type': "Trsfr - Warp", 'active': true},
    {'entry_type': "Trsfr - Yarn", 'active': true},
    {'entry_type': "Adjustment Wt", 'active': true},
    {'entry_type': "Warp-Dropout", 'active': true},
    {'entry_type': "O.Bal - Amount", 'active': true},
    {'entry_type': "O.Bal - Cops,Reel", 'active': true},
    {'entry_type': "O.Bal - Warp", 'active': true},
    {'entry_type': "O.Bal - Yarn", 'active': true},
    // {'entry_type': "Inward - Cops, Reel", 'active': true},
    {'entry_type': "O.Bal - Empty", 'active': true},
  ].obs;

  var productEditingController = TextEditingController();
  var productFocusNode = FocusNode();
  var wagesFocusNode = FocusNode();

  /// created by and updated by details controllers
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? displayName;
  String? displayDate;

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    productFocusNode.addListener(() {
      if (productFocusNode.hasFocus) {
        productEditingController.selection = TextSelection(
            baseOffset: 0, extentOffset: productEditingController.text.length);
      }
    });

    return GetBuilder<WeavingController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title: const Text("Weaving - New Record"),
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
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: SingleChildScrollView(
                        child: FocusTraversalGroup(
                          policy: OrderedTraversalPolicy(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  MyAutoComplete(
                                    enabled: !isUpdate.value,
                                    label: 'Weaver',
                                    items: controller.weaverList,
                                    selectedItem: weaverName.value,
                                    onChanged: (WeaverLoomDetailsModel item) {
                                      weaverName.value = DropModel(
                                          id: item.id, name: item.ledgerName);
                                      controller.loomList.clear();
                                      loomNo.value = null;

                                      var id = "${item.id}";
                                      controller.loomInfo(id);
                                    },
                                  ),
                                  MyLoomAutoComplete(
                                    textInputAction: TextInputAction.next,
                                    enabled: !isUpdate.value,
                                    label: 'Loom',
                                    items: controller.loomList,
                                    selectedItem: loomNo.value,
                                    onChanged: (LoomGroup item) {
                                      loomNo.value = item;
                                      weaverAndLoomByProduct();
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    child: ProductWidget(),
                                    width: 350,
                                  ),
                                  /*ProductNameAutoComplete(
                                    width: 350,
                                    label: 'Product Name',
                                    items: controller.productDropdown,
                                    selectedItem: productName.value,
                                    onChanged: (WeavingProductListModel item) {
                                      productName.value = item;
                                      wagesController.text = "${item.wages}";
                                    },
                                  ),*/
                                  MyTextField(
                                    width: 130,
                                    controller: designNoController,
                                    hintText: "Design No",
                                    enabled: false,
                                    // validate: "String",
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Focus(
                                    skipTraversal: true,
                                    child: MyTextField(
                                      focusNode: wagesFocusNode,
                                      controller: wagesController,
                                      hintText: "Wages(Rs)",
                                      validate: "double",
                                    ),
                                    onFocusChange: (hasFocus) {
                                      AppUtils.fractionDigitsText(
                                          wagesController,
                                          fractionDigits: 2);
                                    },
                                  ),
                                  Focus(
                                    skipTraversal: true,
                                    child: MyTextField(
                                      // enabled: !isUpdate.value,
                                      controller: deductionController,
                                      hintText: "Deduction(Rs)",
                                      validate: "double",
                                    ),
                                    onFocusChange: (hasFocus) {
                                      AppUtils.fractionDigitsText(
                                          deductionController,
                                          fractionDigits: 2);
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  MyAutoComplete(
                                    enabled: !firmUpdate.value,
                                    label: 'Firm Name',
                                    items: controller.firm_dropdown,
                                    selectedItem: firmName.value,
                                    onChanged: (FirmModel item) {
                                      firmName.value = item;
                                    },
                                  ),
                                  MyAutoComplete(
                                    // enabled: !isUpdate.value,
                                    label: 'Wages Account',
                                    items: controller.newRecordAccount,
                                    selectedItem: wagesAccount.value,
                                    onChanged: (LedgerModel item) {
                                      wagesAccount.value = item;
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  MyDropdownButtonFormField(
                                    // enabled: !isUpdate.value,
                                    controller: transactionTypeController,
                                    hintText: " Transaction Type",
                                    items: Constants.TrasactionType,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  MyDropdownButtonFormField(
                                    // enabled: !isUpdate.value,
                                    controller: copsReelsController,
                                    hintText: "Cops/Reel",
                                    items: const ['Yes', 'No'],
                                  ),
                                  MyDropdownButtonFormField(
                                    // enabled: !isUpdate.value,
                                    controller: widthPickController,
                                    hintText: "Width/Pick",
                                    items: const ['Yes', 'No'],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  MyDropdownButtonFormField(
                                    // enabled: !isUpdate.value,
                                    controller: pinningController,
                                    hintText: "Pinning",
                                    items: const ['Yes', 'No'],
                                  ),
                                  MyDropdownButtonFormField(
                                    // enabled: !isUpdate.value,
                                    controller: privateWrController,
                                    hintText: "Private Weft Requirement",
                                    items: const ['Yes', 'No'],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  MyDropdownButtonFormField(
                                    enabled: !isUpdate.value,
                                    controller: weavingTypeController,
                                    hintText: "Weaving Type",
                                    items: Constants.WeavingType,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  crateAndUpdatedBy(),
                                  MyElevatedButton(
                                    onPressed: () => submit(),
                                    child: const Text('SUBMIT'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: LayoutBuilder(builder: (context, constraint) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 400,
                                child: LayoutBuilder(
                                    builder: (context, constraint2) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 60,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'check the following items to complete the warp:'),
                                            SizedBox(height: 5),
                                            Text('Entry Types'),
                                            SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: constraint2.maxHeight - 60,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: .5)),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: productionEntryType.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var item =
                                                productionEntryType[index];
                                            return CheckboxListTile(
                                              contentPadding: EdgeInsets.zero,
                                              title: Text(
                                                item['entry_type'],
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFF141414),
                                                    fontFamily: 'Poppins'),
                                              ),
                                              value: item['active'],
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              onChanged: (bool? value) {
                                                if (isUpdate.value == true) {
                                                  productionEntryType[index]
                                                      ['active'] = value;
                                                  controller.change(
                                                      productionEntryType);
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                              SizedBox(
                                height: constraint.maxHeight - 400,
                                child: Center(child: imageWidget()),
                              )
                            ],
                          ),
                        );
                      }),
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

  weaverSuggestions(List<WeavingProductListModel> list, {var query = ''}) {
    final filter = list
        .where(
            (element) => '$element'.toLowerCase().contains(query.toLowerCase()))
        .toList();
    var suggestions = filter
        .map(
          (e) => SearchFieldListItem<WeavingProductListModel>(
            '${e.productName}',
            item: e,
            child: SizedBox(width: 300, child: Text('${e.productName}')),
          ),
        )
        .toList();

    return suggestions;
  }

  ProductWidget() {
    var initialValue = null;
    if (productName.value != null) {
      initialValue = SearchFieldListItem<WeavingProductListModel>(
        '${productName.value?.productName}',
        item: productName.value,
        child: SizedBox(
            width: 300, child: Text('${productName.value?.productName}')),
      );
    }

    var list = controller.productDropdown;
    var suggestions = weaverSuggestions(list);
    return SearchField<WeavingProductListModel>(
      suggestions: suggestions,
      itemHeight: 40,
      initialValue: initialValue,
      maxSuggestionsInViewPort: 10,
      suggestionState: Suggestion.expand,
      controller: productEditingController,
      onSearchTextChanged: (query) {
        /*if (query.isEmpty) {
          controller.loomList.clear();
          controller.update();
          _initValue();
        }*/
        return weaverSuggestions(list, query: query);
      },
      searchInputDecoration: const InputDecoration(
        label: Text('Product Name'),
        labelStyle: TextStyle(fontSize: 14),
        contentPadding: EdgeInsets.symmetric(horizontal: 4),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
        ),
        suffixIcon: Icon(Icons.arrow_drop_down),
      ),
      suggestionsDecoration: SuggestionDecoration(
          selectionColor: const Color(0xffA3D8FF), width: 500),
      focusNode: productFocusNode,
      autofocus: true,
      onSuggestionTap: (value) {
        FocusScope.of(context).requestFocus(wagesFocusNode);
        var item = value.item!;
        productName.value = item;
        wagesController.text = "${item.wages}";
      },
    );
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      final entryTypes =
          productionEntryType.where((e) => (e['active'] == true)).toList();

      Map<String, dynamic> request = {
        "weaver_id": weaverName.value?.id,
        "loom": loomNo.value?.loomNo,
        "product_id": productName.value?.id,
        "wages": double.tryParse(wagesController.text) ?? 0,
        "deduction_amt": double.tryParse(deductionController.text) ?? 0,
        "firm_id": firmName.value?.id,
        "wages_ano": wagesAccount.value?.id,
        "transaction_type": transactionTypeController.text,
        "cops_reels": copsReelsController.text,
        "width_pick": widthPickController.text,
        "pinning": pinningController.text,
        "private_weft": privateWrController.text,
        "comp_check": weavingTypeController.text,
      };

      if (image?.value != null) {
        String fileName = '${image?.value?.path.split('/').last}';
        request['design_image'] = await DioMultipartFile.MultipartFile.fromFile(
          image!.value!.path,
          filename: fileName,
        );
      }

      for (int i = 0; i < entryTypes.length; i++) {
        request["entry_type[$i]"] = entryTypes[i]["entry_type"];
        request["active[$i]"] = entryTypes[i]["active"];
      }

      bool canSubmit = await controller.weavingChecking(
        weaverName.value?.id,
        loomNo.value?.loomNo,
      );
      if (!canSubmit) return;
      var id = idController.text;
      if (id.isEmpty) {
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.weavingNewRecAdd(requestPayload);
      } else {
        request["id"] = int.parse(id);
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.weavingNewRecEdit(requestPayload, id);
      }
    }
  }

  void _initValue() {
    WeavingController controller = Get.find();

    wagesAccount.value = AppUtils.findLedgerAccountByName(
        controller.newRecordAccount, 'Weaver Wages Account');
    firmName.value = AppUtils.setDefaultFirmName(controller.firm_dropdown);

    if (controller.weaverId != null && controller.request["loom_id"] != null) {
      var weList = controller.weaverList
          .where((element) => '${element.id}' == '${controller.weaverId}')
          .toList();
      if (weList.isNotEmpty) {
        var dd = weList[0];
        weaverName.value = DropModel(id: dd.id, name: dd.ledgerName);
      }
    }

    if (controller.weaverId != null && controller.request["loom_id"] != null) {
      var loomList = controller.loomList
          .where((element) =>
              '${element.loomNo}' == '${controller.request['loom_id']}')
          .toList();
      if (loomList.isNotEmpty) {
        var dd = loomList[0];
        loomNo.value = dd;
      }
    }

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (Get.arguments != null) {
        return;
      }

      if (controller.weaverId != null &&
          controller.request["loom_id"] != null) {
        WeavingRunningProductModel? data = await controller.getRunningProductId(
            controller.weaverId, controller.request["loom_id"]);
        if (data != null) {
          var pList = controller.productDropdown
              .where((element) => '${element.id}' == '${data.productId}')
              .toList();
          if (pList.isNotEmpty) {
            var dd = pList[0];
            productName.value = dd;
            productEditingController.text = "${dd.productName}";
          }
          wagesController.text = "${data.wages}";
          imageUrl.value = '${HttpUrl.baseUrl}${data.designImage}';
        }
      }
    });

    if (Get.arguments != null) {
      isUpdate.value = true;
      for (var e in controller.itemList) {
        if (e["entry_type"] == "Goods Inward") {
          firmUpdate.value = true;
        }
      }

      WeavingAccount item = Get.arguments;

      idController.text = "${item.id}";
      imageUrl.value = '${HttpUrl.baseUrl}${item.designImage}';
      wagesController.text = item.wages!.toStringAsFixed(2);
      deductionController.text = "${item.deduction ?? 0.0.toStringAsFixed(2)}";
      transactionTypeController.text = '${item.transactionType}';
      copsReelsController.text = '${item.copsReels}';
      widthPickController.text = '${item.widthPick}';
      pinningController.text = '${item.pinning}';
      privateWrController.text = '${item.privateWeft}';
      weavingTypeController.text = '${item.compCheck}';

      // Weaver Name
      weaverName.value = DropModel(id: item.weaverId!, name: item.weaverName);
      // Product Name
      productName.value = WeavingProductListModel(
          id: item.productId, productName: item.productName);

      // Loom no
      loomNo.value = LoomGroup(loomNo: item.loomNo);

      // Firm Name
      var firmList = controller.firm_dropdown
          .where((element) => '${element.id}' == '${item.firmId}')
          .toList();
      if (firmList.isNotEmpty) {
        firmName.value = firmList.first;
      }

      // Account List
      var accountList = controller.newRecordAccount
          .where((element) => '${element.id}' == '${item.wagesAno}')
          .toList();
      if (accountList.isNotEmpty) {
        wagesAccount.value = accountList.first;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        var i = 0;
        for (var element in productionEntryType) {
          var has = item.entryTypes
                  ?.map((e) => e.entryType)
                  .contains(element['entry_type']) ??
              false;
          if (has) {
            productionEntryType[i]['active'] = true;
          } else {
            productionEntryType[i]['active'] = false;
          }
          i++;
        }
        controller.change(productionEntryType);
      });

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

  void weaverAndLoomByProduct() async {
    if (productName.value != null) {
      productName.value = null;
    }

    var weaverId = weaverName.value?.id;
    var loom = loomNo.value?.loomNo;

    WeavingRunningProductModel? data =
        await controller.getRunningProductId(weaverId, loom);
    if (data != null) {
      var pList = controller.productDropdown
          .where((element) => '${element.id}' == '${data.productId}')
          .toList();
      if (pList.isNotEmpty) {
        var dd = pList[0];
        productName.value = dd;
      }
      wagesController.text = "${data.wages}";
      imageUrl.value = '${HttpUrl.baseUrl}${data.designImage}';
    }
  }

  Widget imageWidget() {
    return Obx(
      () => Container(
        margin: const EdgeInsets.all(8),
        width: 230,
        height: 230,
        decoration: BoxDecoration(
            border: Border.all(
          width: .5,
        )),
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
      ),
    );
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
