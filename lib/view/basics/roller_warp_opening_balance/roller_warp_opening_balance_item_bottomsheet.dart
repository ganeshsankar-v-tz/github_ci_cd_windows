//
import 'dart:convert';
import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/WarpDesignSheetModel.dart';
import 'package:abtxt/view/basics/roller_warp_opening_balance/roller_warp_opening_balance_controller.dart';
import 'package:abtxt/view/basics/warp_design_sheet/add_warp_design_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/utils/constant.dart';
import 'package:keymap/keymap.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/MultiSelect.dart';

class RollerWarpOpeningBalanceItemBottomSheet extends StatefulWidget {
  const RollerWarpOpeningBalanceItemBottomSheet({Key? key}) : super(key: key);

  @override
  State<RollerWarpOpeningBalanceItemBottomSheet> createState() => _State();
}

class _State extends State<RollerWarpOpeningBalanceItemBottomSheet> {
  Rxn<WarpDesignSheetModel> warpDesignDropdown = Rxn<WarpDesignSheetModel>();
  TextEditingController wapDesignController = TextEditingController();
  TextEditingController warpIDNoController = TextEditingController();
  TextEditingController productQtyController = TextEditingController();
  TextEditingController meterController = TextEditingController();
  TextEditingController deliveryEmptyController = TextEditingController();
  TextEditingController emptyQtyController = TextEditingController();
  TextEditingController sheetController = TextEditingController();
  Rxn<NewColorModel> warpColorDropdown = Rxn<NewColorModel>();

  var selectedWarpColor = <NewColorModel>[].obs;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RollerWarpOpeningBalanceController>(
        builder: (controller) {
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F3FF),
          appBar: AppBar(title: const Text('Add item to Roller Warp Opening Balance')),
          body: SingleChildScrollView(
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,                              children: [
                                Container(
                                  child: Wrap(
                                    children: [
                                      Row(
                                        children: [
                                          MyDialogList(
                                            labelText: 'Warp Design',
                                            controller: wapDesignController,
                                            list: controller.warp_dropdown,
                                            showCreateNew: true,
                                            onItemSelected: (WarpDesignSheetModel item) {
                                              wapDesignController.text =
                                              '${item.designName}';
                                              warpDesignDropdown.value = item;
                                              // controller.request['group_name'] = item.id;
                                            },
                                            onCreateNew: (value) async {
                                              //supplier.value = null;
                                              var item =
                                              await Get.toNamed(AddWarpDesignSheet.routeName);
                                              controller.onInit();
                                            },
                                          ),
                                          MyTextField(
                                            controller: warpIDNoController,
                                            hintText: 'Warp ID No',
                                            validate: 'string',
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyTextField(
                                            controller: productQtyController,
                                            hintText: 'Product Qty',
                                            validate: 'number',
                                          ),
                                          MyTextField(
                                            controller: meterController,
                                            hintText: 'Meter',
                                            validate: 'double',
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyDropdownButtonFormField(
                                              controller: deliveryEmptyController,
                                              hintText: 'Delivery Empty',
                                              items: Constants.deliveredEmpty),
                                          MyTextField(
                                            controller: emptyQtyController,
                                            hintText: 'Empty Qty',
                                            validate: 'number',
                                          ),
                                        ],
                                      ),
                                      MyTextField(
                                        controller: sheetController,
                                        hintText: 'Sheet',
                                        validate: 'number',
                                      ),
                                      Container(
                                        // margin: EdgeInsets.all(7),
                                        width: 240,
                                        child: DropDownMultiSelect(
                                          onChanged: (List<dynamic> x) {
                                            var json = jsonDecode(jsonEncode(x));
                                            var items = (json as List)
                                                .map((i) => NewColorModel.fromJson(i))
                                                .toList();
                                            selectedWarpColor.value = items;
                                          },
                                          labelText: 'Warp Color',
                                          options: controller.warpColor_dropdown,
                                          selectedValues: selectedWarpColor.value,

                                          validator: (value) =>
                                          selectedWarpColor.value.isEmpty
                                              ? 'Required'
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    MyCloseButton(
                                      onPressed: () => Get.back(),
                                      child: const Text('Close'),
                                    ),
                                    const SizedBox(width: 16),
                                    SizedBox(
                                      width: 200,
                                      child: MyElevatedButton(
                                        onPressed: () => submit(),
                                        child: const Text('ADD'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
        "warp_design_id": warpDesignDropdown.value?.id,
        "warp_design_name": warpDesignDropdown.value?.designName,
        "warp_id_no": warpIDNoController.text,
        "product_qty": int.tryParse(productQtyController.text)??0,
        "meter": int.tryParse(meterController.text)??0,
        "delivered_empty": int.tryParse(deliveryEmptyController.text)??0,
        "empty_qty": int.tryParse(emptyQtyController.text)??0,
        "sheet": int.tryParse(sheetController.text)??0,
        "warp_colour": selectedWarpColor.value.join(','),
      };
      Get.back(result: request);
    }
  }
  void _initValue() {
    RollerWarpOpeningBalanceController controller = Get.find();
    deliveryEmptyController.text = Constants.deliveredEmpty[0];
    if (Get.arguments != null){
      var item = Get.arguments ['item'];

      warpIDNoController.text = '${item['warp_id_no']}';
      productQtyController.text = '${item['product_qty']}';
      meterController.text = '${item['meter']}';
      emptyQtyController.text = '${item['empty_qty']}';
      sheetController.text = '${item['sheet']}';


      var warpDesignList = controller.warp_dropdown
          .where((element) => '${element.id}' == '${item['warp_design_id']}')
          .toList();
      if (warpDesignList.isNotEmpty) {
        warpDesignDropdown.value = warpDesignList.first;
        wapDesignController.text='${warpDesignList.first.designName}';
      }

    }


  }

}


