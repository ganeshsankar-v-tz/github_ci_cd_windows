import 'dart:convert';
import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/WarpOpeningStockModel.dart';
import 'package:abtxt/utils/constant.dart';
import 'package:abtxt/view/basics/warp_opening_stock/warp_opening_stock_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import '../../../widgets/MultiSelect.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class WarpOpeningStockBottomSheet extends StatefulWidget {
  const WarpOpeningStockBottomSheet({Key? key}) : super(key: key);

  @override
  State<WarpOpeningStockBottomSheet> createState() => _State();
}

class _State extends State<WarpOpeningStockBottomSheet> {
  TextEditingController warpID = TextEditingController();
  TextEditingController productQuantity = TextEditingController();
  TextEditingController meter = TextEditingController();
  TextEditingController warpCondition = TextEditingController();
  TextEditingController emptyType = TextEditingController();
  TextEditingController emptyQty = TextEditingController();
  TextEditingController sheet = TextEditingController();
  final RxString _isIntegrated = RxString( Constants.emptyType[0]);


  Rxn<NewColorModel> warpColor = Rxn<NewColorModel>();
  var selectedWarpColor = <NewColorModel>[].obs;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpOpeningStockController>(builder: (controller) {
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
          appBar: AppBar(title: const Text('Add item to Warp Opening Stock')),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Wrap(
                                    children: [
                                      MyTextField(
                                        controller: warpID,
                                        hintText: 'Warp ID',
                                        validate: 'string',
                                      ),
                                      MyTextField(
                                        controller: productQuantity,
                                        hintText: 'Product Quantity',
                                        validate: 'number',
                                      ),
                                      Row(
                                        children: [
                                          MyTextField(
                                            controller: meter,
                                            hintText: 'Meter',
                                            validate: 'double',
                                          ),
                                          MyDropdownButtonFormField(
                                              controller: warpCondition,
                                              hintText: "Warp Condition",
                                              items: Constants.WarpCondition),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyDropdownButtonFormField(
                                              controller: emptyType,
                                              hintText: "Empty Type",
                                              items: Constants.emptyType,
                                          onChanged: (value){_isIntegrated.value=value;},),
                                          Obx(()=>
                                             Visibility(
                                               visible: _isIntegrated.value != "Nothing",
                                               child: MyTextField(
                                                controller: emptyQty,
                                                hintText: 'Empty Qty',
                                                // validate: 'number',
                                                                                           ),
                                             ),
                                          ),
                                        ],
                                      ),
                                      Obx(()=>
                                         Visibility(
                                           visible:_isIntegrated.value !="Nothing" ,
                                           child: MyTextField(
                                            controller: sheet,
                                            hintText: 'Sheet',
                                            // validate: 'number',
                                           ),
                                         ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // const Text(
                                          //   'Warp Color',
                                          //   style: TextStyle(
                                          //       fontWeight: FontWeight.w600,
                                          //       color: Colors.black87),
                                          // ),
                                          Container(
                                            // margin: EdgeInsets.all(5),
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

                                              options: controller.colorDropdown,
                                              selectedValues: selectedWarpColor.value,

                                              validator: (value) =>
                                              selectedWarpColor.value.isEmpty
                                                  ? 'Required'
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
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
        "warp_id_no": warpID.text,
        "product_quantity": int.tryParse(productQuantity.text)??0,
        "meter": int.tryParse(meter.text)??0,
        "warp_condition": warpCondition.text,
        "empty_type": emptyType.text,
        "empty_quantity": emptyQty.text,
        "sheet": sheet.text,
        "warp_colour": selectedWarpColor.value.join(','),
      };
      Get.back(result: request);
    }
  }

  Future<void> _initValue() async {
    WarpOpeningStockController controller = Get.find();
    warpCondition.text = Constants.WarpCondition[0];
    emptyType.text = Constants.emptyType[0];



    if(Get.arguments != null){
      var item = Get.arguments['item'];
      warpID.text = '${item['warp_id_no']}';
      productQuantity.text = '${item['product_quantity']}';
      meter.text = '${item['meter']}';
      warpCondition.text = '${item['warp_condition']}';
      emptyType.text = '${item['empty_type']}';
      emptyQty.text = '${item['empty_quantity']}';
      sheet.text = '${item['sheet']}';


    }
  }
}
