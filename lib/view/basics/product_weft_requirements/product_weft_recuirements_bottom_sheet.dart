import 'package:abtxt/view/basics/product_weft_requirements/product_weft_requirements_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/YarnModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/searchfield/decoration.dart';
import '../../../widgets/searchfield/searchfield.dart';

class ProductWeftRecuirementsBottomSheet extends StatefulWidget {
  const ProductWeftRecuirementsBottomSheet({super.key});

  @override
  State<ProductWeftRecuirementsBottomSheet> createState() => _State();
}

class _State extends State<ProductWeftRecuirementsBottomSheet> {
  Rxn<YarnModel> yarnName = Rxn<YarnModel>();
  TextEditingController yarnNameController = TextEditingController();
  TextEditingController weftController =
      TextEditingController(text: "Main Weft");
  TextEditingController quantityController = TextEditingController();
  ProductWeftRecuirementsController controller = Get.find();
  final FocusNode _yarnNameFocusNode = FocusNode();
  final FocusNode _weftTypeFocusNode = FocusNode();
  final FocusNode _quantityFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  RxBool isUpdate = RxBool(false);

  @override
  void initState() {
    _initValue();
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (isUpdate.value) {
        FocusScope.of(context).requestFocus(_quantityFocusNode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductWeftRecuirementsController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: const Text('Add item to Product Weft Requirement'),
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
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          MyAutoComplete(
                            enabled: !isUpdate.value,
                            label: 'Yarn Name',
                            items: controller.YarnName,
                            selectedItem: yarnName.value,
                            onChanged: (YarnModel item) async {
                              yarnName.value = item;
                            },
                          ),
                          MyDropdownButtonFormField(
                            focusNode: _weftTypeFocusNode,
                            controller: weftController,
                            hintText: "Weft Type",
                            items: const [
                              "Main Weft",
                              "Other",
                            ],
                          ),
                          Focus(
                            skipTraversal: true,
                            child: MyTextField(
                              controller: quantityController,
                              hintText: 'Quantity',
                              validate: 'double',
                              focusNode: _quantityFocusNode,
                              suffix: const Text('Kg',
                                  style: TextStyle(color: Color(0xFF5700BC))),
                            ),
                            onFocusChange: (hasFocus) {
                              AppUtils.fractionDigitsText(
                                quantityController,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyAddButton(onPressed: () => submit()),
                        ],
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

  submit() {
    if (_formKey.currentState!.validate()) {
      double yarnQty = double.tryParse(quantityController.text) ?? 0.0;

      if (yarnQty == 0) {
        return AppUtils.infoAlert(message: "Yarn quantity is 0");
      }

      var yarnId = yarnName.value?.id;
      var weftType = weftController.text;

      var exists = _yarnAlreadyAddedOrNot(yarnId, weftType);

      var mainWeft = _maiWeftAlreadyAddedOrNot(weftType);

      if (mainWeft) {
        return AppUtils.infoAlert(message: "Main Weft Already Added");
      }

      if (exists) {
        AppUtils.infoAlert(message: "Yarn Already Added");
      } else {
        Map<String, dynamic> request = {
          "yarn_id": yarnId,
          "yarn_name": yarnName.value?.name,
          "weft_type": weftType,
          "quantity": yarnQty,
        };
        Get.back(result: request);
      }
    }
  }

  void _initValue() {
    ProductWeftRecuirementsController controller = Get.find();
    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = Get.arguments['item'];
      quantityController.text = '${item['quantity']}';

      var yarnId = controller.YarnName.where(
          (element) => '${element.id}' == '${item['yarn_id']}').toList();
      if (yarnId.isNotEmpty) {
        yarnName.value = yarnId.first;
        yarnNameController.text = '${yarnId.first.name}';
      }
    }
  }

  _yarnAlreadyAddedOrNot(var yarnId, var weftType) {
    if (Get.arguments == null) {
      var exists = controller.itemList
          .any((e) => e["yarn_id"] == yarnId && e["weft_type"] == weftType);
      return exists;
    } else {
      return false;
    }
  }

  _maiWeftAlreadyAddedOrNot(var weftType) {
    if (Get.arguments == null) {
      var exists = controller.itemList
          .any((e) => e["weft_type"] == "Main Weft" && weftType == "Main Weft");
      return exists;
    } else {
      return false;
    }
  }

  yarnNameDropDownWidget() {
    var list = controller.YarnName;
    var suggestions = list.map(
      (e) {
        return SearchFieldListItem<YarnModel>('${e.name}', item: e);
      },
    ).toList();
    return Container(
      width: 240,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: SearchField<YarnModel>(
        suggestions: suggestions,
        maxSuggestionsInViewPort: 7,
        itemHeight: 50,
        controller: yarnNameController,
        searchInputDecoration: const InputDecoration(
            label: Text('Yarn Name'),
            labelStyle: TextStyle(fontSize: 14),
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
            ),
            suffixIcon: Icon(Icons.arrow_drop_down)),
        suggestionsDecoration:
            SuggestionDecoration(selectionColor: const Color(0xffA3D8FF)),
        focusNode: _yarnNameFocusNode,
        autofocus: true,
        onScroll: (a, b) {},
        onSuggestionTap: (value) {
          FocusScope.of(context).requestFocus(_weftTypeFocusNode);
          var item = value.item!;
          yarnName.value = item;
        },
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (yarnNameController.text.isEmpty) {
            return "Required";
          } else {
            return null;
          }
        },
      ),
    );
  }
}
