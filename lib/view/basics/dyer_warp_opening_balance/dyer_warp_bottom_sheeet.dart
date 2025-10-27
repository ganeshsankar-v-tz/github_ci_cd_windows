import 'dart:convert';
import 'package:abtxt/view/basics/dyer_warp_opening_balance/dyer_warp_opening_balance_controller.dart';
import 'package:abtxt/view/basics/warp_design_sheet/add_warp_design_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyTextField.dart';
import 'package:abtxt/model/WarpDesignSheetModel.dart';
import 'package:abtxt/model/NewColorModel.dart';
import '../../../widgets/MultiSelect.dart';


class DyerWarpBottomSheet extends StatefulWidget {
  const DyerWarpBottomSheet({Key? key}) : super(key: key);

  @override
  State<DyerWarpBottomSheet> createState() => _DyerWarpBottomSheetState();
}

class _DyerWarpBottomSheetState extends State<DyerWarpBottomSheet> {
  Rxn<WarpDesignSheetModel> warpDesign = Rxn<WarpDesignSheetModel>();

  TextEditingController warpDesignController = TextEditingController();
  TextEditingController warpTypeController = TextEditingController();
  TextEditingController productQuantityController = TextEditingController();
  TextEditingController meterController = TextEditingController();
  TextEditingController colorToDyeController = TextEditingController();

  Rxn<NewColorModel> warpColor = Rxn<NewColorModel>();
  var selectedColorToDye = <NewColorModel>[].obs;
  
  final _formKey = GlobalKey<FormState>();

  // var _selectedEntryType = Constants.ENTRY_TYPES[0].obs;

  @override
  void initState() {
    super.initState();
    _initValue();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DyerWarpOpeningBalanceController>(builder: (controller) {
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
          appBar: AppBar(title: const Text('Add item to Dyer Warp Opening Balance')),
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

                                      MyDialogList(
                                        labelText: 'Warp Design',
                                        controller: warpDesignController,
                                        list: controller.warpDesigndetails,
                                        showCreateNew: true,
                                        onItemSelected: (WarpDesignSheetModel item) {
                                          warpDesignController.text =
                                          '${item.designName}';
                                          warpDesign.value = item;
                                          // controller.request['group_name'] = item.id;
                                        },
                                        onCreateNew: (value) async {
                                          //supplier.value = null;
                                          var item =
                                          await Get.toNamed(AddWarpDesignSheet.routeName);
                                          controller.onInit();
                                        },
                                      ),

                                      Row(
                                        children: [
                                          MyTextField(
                                            controller: warpTypeController,
                                            hintText: 'Warp Type',
                                            // validate: 'number',
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyTextField(
                                            controller: productQuantityController,
                                            hintText: 'Product Quantity',
                                             validate: 'number',
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyTextField(
                                            controller: meterController,
                                            hintText: 'Meter',
                                            validate: 'double',
                                          ),
                                        ],
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
                                            selectedColorToDye.value = items;
                                          },
                                          labelText: 'Color To Dye',
                                          options: controller.colorDropdown,
                                          selectedValues: selectedColorToDye.value,

                                          validator: (value) =>
                                          selectedColorToDye.value.isEmpty
                                              ? 'Required'
                                              : null,
                                        ),
                                      )
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
        "designName": warpDesign.value?.designName,
        "warp_design_id": warpDesign.value?.id,
        "warp_type": warpTypeController.text,
        "product_qty": int.tryParse(productQuantityController.text)??0,
        "meter": int.tryParse(meterController.text)??0,
        "colour_to_dye": selectedColorToDye.value.join(','),
        // "total": 24,
      };
      print(request);
      Get.back(result: request);
    }
  }
  void _initValue(){
    DyerWarpOpeningBalanceController controller = Get.find();

    if (Get.arguments !=null){
      var item = Get.arguments['item'];

      warpTypeController.text = '${item['warp_type']}';
      productQuantityController.text = '${item['product_qty']}';
      meterController.text = '${item['meter']}';


      var warpDesignList = controller.warpDesigndetails
          .where((element) => '${element.id}' == '${item['warp_design_id']}')
          .toList();
      if (warpDesignList.isNotEmpty) {
        warpDesign.value = warpDesignList.first;
        warpDesignController.text = '${warpDesignList.first.designName}';
      }

    }
  }

}
