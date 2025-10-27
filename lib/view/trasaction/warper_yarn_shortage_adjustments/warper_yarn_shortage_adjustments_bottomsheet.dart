import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/YarnModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/warper_yarn_shortage_adjustments/warper_yarn_shortage_adjustments_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/searchfield/decoration.dart';
import '../../../widgets/searchfield/searchfield.dart';

class WarperYarnShortageAdjustmentsBottomSheet extends StatefulWidget {
  const WarperYarnShortageAdjustmentsBottomSheet({super.key});

  @override
  State<WarperYarnShortageAdjustmentsBottomSheet> createState() => _State();
}

class _State extends State<WarperYarnShortageAdjustmentsBottomSheet> {
  Rxn<YarnModel> yarnName = Rxn<YarnModel>();
  TextEditingController yarnNameController = TextEditingController();
  Rxn<NewColorModel> colorName = Rxn<NewColorModel>();
  TextEditingController colorNameController = TextEditingController();
  TextEditingController quantityController =
      TextEditingController(text: "0.000");

  /// Focus Nodes
  final FocusNode _yarnNameFocusNode = FocusNode();
  final FocusNode _colorNameFocusNode = FocusNode();
  final FocusNode _quantityNameFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  WarperYarnShortageAdjustmentsController controller = Get.find();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarperYarnShortageAdjustmentsController>(
        builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
            title: const Text('Add Item to Warper Yarn Shortage Adjustment')),
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
                    children: [
                      Row(
                        children: [
                          MyAutoComplete(
                            label: 'Yarn Name',
                            selectedItem: yarnName.value,
                            items: controller.yarnDropdown,
                            onChanged: (YarnModel item) {
                              yarnName.value = item;
                            },
                          ),
                          MyAutoComplete(
                            label: 'Color Name',
                            selectedItem: colorName.value,
                            items: controller.colorDropdown,
                            onChanged: (NewColorModel item) {
                              colorName.value = item;
                            },
                          ),
                          Focus(
                              skipTraversal: true,
                              child: MyTextField(
                                focusNode: _quantityNameFocusNode,
                                controller: quantityController,
                                hintText: 'Quantity',
                                validate: 'double',
                              ),
                              onFocusChange: (hasFocus) {
                                AppUtils.fractionDigitsText(quantityController);
                              }),
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
      var request = {
        "yarn_id": yarnName.value?.id,
        "yarn_name": yarnName.value?.name,
        "color_id": colorName.value?.id,
        "color_name": colorName.value?.name,
        //  "stock_balance": stockBalanceController.text,
        "qty": double.tryParse(quantityController.text) ?? 0
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    WarperYarnShortageAdjustmentsController controller = Get.find();

    // AUTO SELECT THE FIRST ITEM OF COLOUR.
    if (controller.colorDropdown.isNotEmpty) {
      colorName.value = controller.colorDropdown.first;
    }

    if (Get.arguments != null) {
      var item = Get.arguments['item'];
      quantityController.text = tryCast(item['qty']);

      var yarnNameList = controller.yarnDropdown
          .where((element) => '${element.id}' == '${item['yarn_id']}')
          .toList();
      if (yarnNameList.isNotEmpty) {
        yarnName.value = yarnNameList.first;
        yarnNameController.text = '${yarnNameList.first.name}';
      }

      var colorNameList = controller.colorDropdown
          .where((element) => '${element.id}' == '${item['color_id']}')
          .toList();
      if (colorNameList.isNotEmpty) {
        colorName.value = colorNameList.first;
        colorNameController.text = '${colorNameList.first.name}';
      }
    }
  }

  yarnNameDropDownWidget() {
    var list = controller.yarnDropdown;
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
        suggestionsDecoration:
            SuggestionDecoration(selectionColor: const Color(0xffA3D8FF)),
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
        focusNode: _yarnNameFocusNode,
        autofocus: true,
        onScroll: (a, b) {},
        onSuggestionTap: (value) {
          FocusScope.of(context).requestFocus(_colorNameFocusNode);
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

  colorNameDropDownWidget() {
    var list = controller.colorDropdown;
    var suggestions = list.map(
      (e) {
        return SearchFieldListItem<NewColorModel>('${e.name}', item: e);
      },
    ).toList();
    return Container(
      width: 240,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: SearchField<NewColorModel>(
        suggestions: suggestions,
        suggestionsDecoration:
            SuggestionDecoration(selectionColor: const Color(0xffA3D8FF)),
        maxSuggestionsInViewPort: 7,
        itemHeight: 50,
        controller: colorNameController,
        searchInputDecoration: const InputDecoration(
            label: Text('color Name'),
            labelStyle: TextStyle(fontSize: 14),
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
            ),
            suffixIcon: Icon(Icons.arrow_drop_down)),
        focusNode: _colorNameFocusNode,
        autofocus: true,
        onScroll: (a, b) {},
        onSuggestionTap: (value) {
          FocusScope.of(context).requestFocus(_quantityNameFocusNode);
          var item = value.item!;
          colorName.value = item;
        },
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (colorNameController.text.isEmpty) {
            return "Required";
          } else {
            return null;
          }
        },
      ),
    );
  }
}
