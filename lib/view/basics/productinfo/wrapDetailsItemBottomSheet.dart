import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/productinfo/product_info_controller.dart';
import 'package:abtxt/widgets/MyAddButton.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/NewWarpModel.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class wrapDetailsItemBottomSheet extends StatefulWidget {
  const wrapDetailsItemBottomSheet({super.key});

  @override
  State<wrapDetailsItemBottomSheet> createState() => _State();
}

class _State extends State<wrapDetailsItemBottomSheet> {
  Rxn<NewWarpModel> warpDesign = Rxn<NewWarpModel>();
  TextEditingController warpType = TextEditingController();
  TextEditingController warpDesignController = TextEditingController();
  final FocusNode _warpDesignFocus = FocusNode();
  final FocusNode _addFocus = FocusNode();
  ProductInfoController controller = Get.find();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductInfoController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: const Text('Add Item (Product Info)'),
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
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        children: [
                          MySearchField(
                            label: 'Warp Design',
                            items: controller.warpDesignDropdown,
                            textController: warpDesignController,
                            focusNode: _warpDesignFocus,
                            requestFocus: _addFocus,
                            onChanged: (NewWarpModel item) {
                              warpDesign.value = item;
                              warpType.text = item.warpType ?? '';
                            },
                          ),
                          ExcludeFocus(
                            child: MyTextField(
                              controller: warpType,
                              hintText: "WarpType",
                              readonly: true,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.center,
                        child: MyAddButton(
                          focusNode: _addFocus,
                          onPressed: () => submit(),
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

  submit() {
    if (_formKey.currentState!.validate()) {
      var exists = _checkWarpIdAlreadyExits(warpDesign.value?.id);
      if (!exists) {
        var request = {
          "warp_design_id": warpDesign.value?.id,
          "warp_design": warpDesign.value?.warpName,
          "warp_type": warpType.text,
        };
        Get.back(result: request);
      } else {
        AppUtils.infoAlert(
            message: "The selected warp Design already exists !");
      }
    }
  }

  _checkWarpIdAlreadyExits(warpDesignId) {
    var exists = controller.warpItemList
        .any((element) => element['warp_design_id'] == warpDesignId);
    return exists;
  }
}
