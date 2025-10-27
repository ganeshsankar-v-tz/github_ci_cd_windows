import 'package:abtxt/model/NewWarpModel.dart';
import 'package:abtxt/model/ProductInfoModel.dart';
import 'package:abtxt/model/WarpNotificationModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/production/warp_notification/warp_notification_controller.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class AddWarpNotification extends StatefulWidget {
  const AddWarpNotification({Key? key}) : super(key: key);
  static const String routeName = '/AddWarpNotification';

  @override
  State<AddWarpNotification> createState() => _State();
}

class _State extends State<AddWarpNotification> {
  TextEditingController idController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController recNoController = TextEditingController();
  Rxn<LedgerModel> weaverName = Rxn<LedgerModel>();
  TextEditingController loomNoController = TextEditingController();
  Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
  Rxn<NewWarpModel> warpDesign = Rxn<NewWarpModel>();
  TextEditingController warpTypeController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController statusController =
      TextEditingController(text: "Pending");

  final _formKey = GlobalKey<FormState>();
  late WarpNotificationController controller;
  RxBool isUpdate = RxBool(false);


  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpNotificationController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Warp Notification"),
          actions: [],
        ),
        loadingStatus: controller.status.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ,control: true): GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS,control: true): SaveIntent(),
        },
        child: Actions(
          actions:  <Type, Action<Intent>>{
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
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Form(
                              key: _formKey,
                              child: Wrap(
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
                                  Row(
                                    children: [
                                      MyDateField(
                                          controller: dateController,
                                          hintText: "Date"),
                                      Visibility(
                                        visible: recNoController.text.isNotEmpty,
                                        child: MyTextField(
                                          controller: recNoController,
                                          hintText: "Record No",
                                          readonly: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      MyAutoComplete(
                                        label: 'Weaver Name',
                                        items: controller.weaverName,
                                        selectedItem: weaverName.value,
                                        onChanged: (LedgerModel item) {
                                          weaverName.value = item;
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      MyTextField(
                                        controller: loomNoController,
                                        hintText: "Loom",
                                        validate: "string",
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      MyAutoComplete(
                                        label: 'Product Name',
                                        items: controller.productName,
                                        selectedItem: productName.value,
                                        enabled: !isUpdate.value,
                                        onChanged: (ProductInfoModel item) {
                                          productName.value = item;
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      MyAutoComplete(
                                        label: 'Warp Design',
                                        items: controller.warpName,
                                        selectedItem: warpDesign.value,
                                        enabled: !isUpdate.value,
                                        onChanged: (NewWarpModel item) {
                                          warpDesign.value = item;
                                          warpTypeController.text =
                                              "${item.warpType}";
                                        },
                                      ),
                                      MyTextField(
                                        controller: warpTypeController,
                                        hintText: "Warp Type",
                                        readonly: true,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      MyTextField(
                                        controller: detailsController,
                                        hintText: "Details",
                                      ),
                                    ],
                                  ),
                                  MyDropdownButtonFormField(
                                    controller: statusController,
                                    hintText: "Status",
                                    items: const [
                                      "Pending",
                                      "Completed",
                                      "Accepted"
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MySubmitButton(onPressed: () => submit(),),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 1, child: Container(color: Colors.grey[400])),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "e_date": dateController.text,
        "weaver_id": weaverName.value?.id,
        "loom": loomNoController.text,
        "product_id": productName.value?.id,
        "warp_design_id": warpDesign.value?.id,
        "details": detailsController.text ?? '',
        "warp_status": statusController.text,
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
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    WarpNotificationController controller = Get.find();

    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = WarpNotificationModel.fromJson(Get.arguments['item']);

      idController.text = "${item.id}";
      dateController.text = "${item.eDate}";
      recNoController.text = "${item.id}";
      loomNoController.text = "${item.loom}";
      detailsController.text = tryCast(item.details);
      statusController.text = "${item.warpStatus}";

      var weaverList = controller.weaverName
          .where((element) => '${element.id}' == '${item.weaverId}')
          .toList();
      if (weaverList.isNotEmpty) {
        weaverName.value = weaverList.first;
      }
      var productList = controller.productName
          .where((element) => '${element.id}' == '${item.productId}')
          .toList();
      if (productList.isNotEmpty) {
        productName.value = productList.first;
      }
      var warpDesignList = controller.warpName
          .where((element) => '${element.id}' == '${item.warpDesignId}')
          .toList();
      if (warpDesignList.isNotEmpty) {
        warpDesign.value = warpDesignList.first;
        warpTypeController.text = "${warpDesignList.first.warpType}";
      }
    }
  }
}
