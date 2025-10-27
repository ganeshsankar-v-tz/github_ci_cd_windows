import 'dart:async';
import 'dart:io';

import 'package:abtxt/http/http_urls.dart';
import 'package:abtxt/utils/constant.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:dio/src/multipart_file.dart' as DioMultipartFile;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../http/dio_client.dart';
import '../../../model/FirmModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import 'firm_controller.dart';

class AddFirm extends StatefulWidget {
  const AddFirm({super.key});

  static const String routeName = '/addfirm';

  @override
  State<AddFirm> createState() => _State();
}

class _State extends State<AddFirm> {
  TextEditingController idController = TextEditingController();
  TextEditingController firmNameController = TextEditingController();
  TextEditingController shortCodeController = TextEditingController();
  TextEditingController businessTypeController = TextEditingController();
  TextEditingController registeredGSTCodeController = TextEditingController();
  TextEditingController registeredTINCodeController = TextEditingController();
  TextEditingController webController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController emailIDController = TextEditingController();
  TextEditingController faxController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController pINCodeController = TextEditingController();
  TextEditingController jurishdicationController = TextEditingController();
  TextEditingController iACNoController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController bankAccountNoController = TextEditingController();
  TextEditingController iFSCNoController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();


  final FocusNode _firstInputFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  late FirmController controller;
  Rxn<File>? image = Rxn<File>();
  var imageUrl = Rxn<String>();

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
    return GetBuilder<FirmController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title: Text("${idController.text == '' ? 'Add' : 'Update'} Firm"),
          actions: [
            Visibility(
                visible: idController.text.isNotEmpty,
                child: MyDeleteIconButton(
                  onPressed: (password) {
                    controller.delete(idController.text, password);
                  },
                )),
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
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: const Color(0xFFF9F3FF), width: 16),
                  ),
                  //height: Get.height,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        flex: 1,
                        child: Container(
                            padding: const EdgeInsets.all(12),
                            child: imageWidget()),
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
                                    focusNode: _firstInputFocusNode,
                                    controller: firmNameController,
                                    hintText: 'Firm Name',
                                    validate: 'string',
                                  ),
                                  MyTextField(
                                    controller: shortCodeController,
                                    //  focusNode: a,
                                    maxLength: 4,
                                    hintText: "Short Code",
                                  ),
                                  MyTextField(
                                    controller: businessTypeController,
                                    hintText: "Business Type",
                                    //  focusNode: b,
                                  ),
                                  MyTextField(
                                    controller: registeredGSTCodeController,
                                    hintText: "Registered GST Code",
                                    // focusNode: c,
                                  ),
                                  MyTextField(
                                    controller: registeredTINCodeController,
                                    hintText: "Registered TIN Code",
                                    // focusNode: d,
                                  ),
                                  MyTextField(
                                    controller: webController,
                                    hintText: "Web",
                                    // focusNode: e,
                                  ),
                                  MyTextField(
                                    controller: phoneNoController,
                                    hintText: "Phone No",
                                    // focusNode: f,
                                  ),
                                  MyTextField(
                                    controller: mobile,
                                    hintText: "Mobile No",
                                    // focusNode: g,
                                  ),
                                  MyTextField(
                                    controller: emailIDController,
                                    hintText: "Email ID",
                                    //focusNode: h,
                                  ),
                                  MyTextField(
                                    controller: faxController,
                                    hintText: "Fax",
                                    // focusNode: i,
                                  ),
                                  MyTextField(
                                    controller: streetController,
                                    hintText: "Street",
                                    //focusNode: j,
                                  ),
                                  MyTextField(
                                    controller: areaController,
                                    hintText: "Area",
                                    // focusNode: k,
                                  ),
                                  MyTextField(
                                    controller: cityController,
                                    hintText: "City",
                                    //focusNode: l,
                                  ),
                                  MyTextField(
                                    controller: pINCodeController,
                                    hintText: "Pin Code",
                                    // focusNode: m,
                                  ),
                                  MyTextField(
                                    controller: stateController,
                                    hintText: "State",
                                    // focusNode: n,
                                  ),
                                  MyTextField(
                                    controller: countryController,
                                    hintText: "Country",
                                    // focusNode: o,
                                  ),
                                  MyTextField(
                                    controller: jurishdicationController,
                                    hintText: "Jurisdiction",
                                    // focusNode: p,
                                  ),
                                  MyTextField(
                                    controller: iACNoController,
                                    hintText: "IAC No",
                                    // focusNode: q,
                                  ),
                                  MyTextField(
                                    controller: bankNameController,
                                    hintText: "Bank Name",
                                    // focusNode: r,
                                  ),
                                  MyTextField(
                                    controller: bankAccountNoController,
                                    hintText: "Bank Account No",
                                    // focusNode: s,
                                  ),
                                  MyTextField(
                                    controller: iFSCNoController,
                                    hintText: "IFSC",
                                    validate: "ifsc_code",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                /*  crateAndUpdatedBy(),
                                  const Spacer(),*/
                                  MySubmitButton(
                                    onPressed: controller.status.isLoading ? null : submit,
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

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "firm_name": firmNameController.text,
        "short_code": shortCodeController.text,
        "bussiness_type": businessTypeController.text,
        "gst_no": registeredGSTCodeController.text,
        "tin_no": registeredTINCodeController.text,
        "web": webController.text,
        "phone": phoneNoController.text,
        "mobile": mobile.text,
        "email": emailIDController.text,
        "fax": faxController.text,
        "street": streetController.text,
        "area": areaController.text,
        "city": cityController.text,
        "pincode": pINCodeController.text,
        "state": stateController.text,
        "country": countryController.text,
        "jurisdiction": jurishdicationController.text,
        "iac_no": iACNoController.text,
        "bank_name": bankNameController.text,
        "bank_account_no": bankAccountNoController.text,
        "ifsc_code": iFSCNoController.text,
      };

      if (image?.value != null) {
        String fileName = '${image?.value?.path.split('/').last}';
        request['logo'] = await DioMultipartFile.MultipartFile.fromFile(
          '${image!.value?.path}',
          filename: fileName,
        );
      }
      var id = idController.text;
      if (id.isEmpty) {
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.addFirm(requestPayload);
      } else {
        request['id'] = id;
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.updateFirm(requestPayload, id);
      }
    }
  }

  Future<void> _initValue() async {
    FirmController controller = Get.find();
    controller.request = <String, dynamic>{};

    countryController.text = "India";
    if (Get.arguments != null) {
      var firm = FirmModel.fromJson(Get.arguments['item']);
      idController.text = '${firm.id}';
      firmNameController.text = firm.firmName ?? '';
      shortCodeController.text = firm.shortCode ?? '';
      businessTypeController.text = firm.bussinessType ?? '';
      registeredGSTCodeController.text = firm.gstNo ?? '';
      registeredTINCodeController.text = firm.tinNo ?? '';
      webController.text = firm.web ?? '';
      phoneNoController.text = firm.phone ?? '';
      mobile.text = firm.mobile ?? '';
      emailIDController.text = firm.email ?? '';
      faxController.text = firm.fax ?? '';
      streetController.text = firm.street ?? '';
      imageUrl.value = '${HttpUrl.baseUrl}${firm.logo}';
      areaController.text = firm.area ?? "";
      cityController.text = firm.city ?? "";
      stateController.text = firm.state ?? "";
      countryController.text = firm.country ?? "";
      pINCodeController.text = firm.pincode ?? '';
      jurishdicationController.text = firm.jurisdiction ?? '';
      iACNoController.text = firm.iacNo ?? '';
      bankNameController.text = firm.bankName ?? '';
      bankAccountNoController.text = firm.bankAccountNo ?? '';
      iFSCNoController.text = firm.ifscCode ?? '';
    }
  }

  Widget imageWidget() {
    return Obx(() => Container(
          margin: const EdgeInsets.all(8),
          width: 223,
          height: 223,
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
                      fit: BoxFit.cover,
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
          id.isEmpty
              ? formattedDate
              : "${updatedAt ?? createdAt}",
          style: AppUtils.updateAndCreateTextStyle(),
        )
      ],
    );
  }*/
}
