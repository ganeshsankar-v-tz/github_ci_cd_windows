import 'dart:convert';

import 'package:abtxt/view/basics/product_image/product_image_controller.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../model/ProductInfoModel.dart';
import '../../../model/new_product_image.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyTextField.dart';

class AddProductImage extends StatefulWidget {
  const AddProductImage({Key? key}) : super(key: key);
  static const String routeName = '/add_product_image';

  @override
  State<AddProductImage> createState() => _State();
}

class _State extends State<AddProductImage> {
  TextEditingController idController = TextEditingController();
  Rxn<ProductInfoModel> product_name = Rxn<ProductInfoModel>();
  TextEditingController DesignController = TextEditingController();
  TextEditingController SareeLengthController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late ProductImageController controller;

  @override
  void initState() {
    _initValue();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductImageController>(builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title:
                Text("${idController.text == '' ? 'Add' : 'Update'} Product Image"),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
              ),
              //height: Get.height,
              margin: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        //color: Colors.green,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   'Product',
                                    //   style: TextStyle(
                                    //       fontWeight: FontWeight.w600,
                                    //       color: Colors.black87),
                                    // ),
                                    Container(
                                      width: 240,
                                      padding: EdgeInsets.all(8),
                                      child: DropdownButtonFormField(
                                        style: TextStyle(
                                            color: Color(0xFF141414),
                                            fontSize: 14,
                                            fontFamily: 'Poppins'),
                                        value: product_name.value,
                                        items: controller.products
                                            .map((ProductInfoModel item) {
                                          return DropdownMenuItem<
                                              ProductInfoModel>(
                                            value: item,
                                            child: Text('${item.productName}',style: TextStyle(fontWeight: FontWeight.normal),),
                                          );
                                        }).toList(),
                                        onChanged: (ProductInfoModel? value) {
                                          product_name.value = value;
                                        },
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.symmetric(horizontal: 8),
                                          border: OutlineInputBorder(),
                                          // hintText: '',
                                          labelText: 'Product Name',
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF939393),
                                              width: 0.4,
                                            ),
                                          ),
                                          labelStyle: TextStyle(fontSize: 14),
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                MyTextField(
                                  controller: DesignController,
                                  hintText: "Design No",
                                  validate: "String",
                                ),
                                MyTextField(
                                  controller: SareeLengthController,
                                  hintText: "Saree Length",
                                  validate: "String",
                                ),
                              ],
                            ),
                            SizedBox(height: 48),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                                MyCloseButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Close'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 200,
                                  child: MyElevatedButton(
                                    onPressed: () {
                                      submit();
                                    },
                                    child: Text(
                                        "${Get.arguments == null ? 'Save' : 'Update'}"),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
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
        "product_id": product_name.value?.id,
        "design_no": DesignController.text,
        "length": SareeLengthController.text,
      };

      print(jsonEncode(request));
      var id = idController.text;
      if (id.isEmpty) {
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.addNewProductImage(requestPayload);
      } else {
        // request['id'] = '$id';
        var requestPayload = DioFormData.FormData.fromMap(request);
        controller.updateNewProductImage(requestPayload);
      }

      controller.addNewProductImage(request);
    }
  }

  void _initValue() {
    ProductImageController controller = Get.find();
    product_name.value = controller.products.first;


    if (Get.arguments != null) {
      ProductImageController controller = Get.find();
      NewProductImageModel image = Get.arguments['item'];
      idController.text = '${image.id}';
      product_name.value = controller.products
          .where((element) => '${element.id}' == '${image.productId}')
          .toList()
          .first;
      DesignController.text = '${image.designNo}';
      SareeLengthController.text = '${image.length}';
    }
  }
}
