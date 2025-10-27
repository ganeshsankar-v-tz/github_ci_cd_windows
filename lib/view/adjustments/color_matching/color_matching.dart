import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../model/color_matching_list_data.dart';
import '../../../widgets/MyTextField.dart';
import 'color_matching_controller.dart';

class ColorMatching extends StatefulWidget {
  const ColorMatching({Key? key}) : super(key: key);
  static const String routeName = '/color_matching';

  @override
  State<ColorMatching> createState() => _State();
}

class _State extends State<ColorMatching> {
  TextEditingController idController = TextEditingController();

  Rxn<ColorMatchingListData> productname = Rxn<ColorMatchingListData>();
  TextEditingController designNoController = TextEditingController();

  Rxn<ProductDetails> warpColor = Rxn<ProductDetails>();
  var productDetails = <ProductDetails>[].obs;
  // TextEditingController weftColor = TextEditingController();

//  var weftColor = "";

  final _formKey = GlobalKey<FormState>();
  var weftColor = <dynamic>[].obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ColorMatchingController>(builder: (controller) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Adjustment / Color Matching '),
            centerTitle: false,
            elevation: 0,
          ),
          body: SingleChildScrollView(
              child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12),
            ),
            margin: const EdgeInsets.all(16),
            child: Row(
              children: [
                Flexible(
                  flex: 3,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Center(
                          child: Wrap(
                            children: [
                              MyTextField(
                                controller: idController,
                                hintText: "ID",
                                validate: "",
                                enabled: false,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 240,
                                    padding: const EdgeInsets.only(
                                        top: 0, bottom: 12, right: 12),
                                    child: DropdownButtonFormField(
                                      value: productname.value,
                                      items: controller.products
                                          .map((ColorMatchingListData item) {
                                        return DropdownMenuItem<
                                            ColorMatchingListData>(
                                          value: item,
                                          child: Text(
                                            '${item.productName}',
                                            style: const TextStyle(
                                                fontWeight:
                                                    FontWeight.normal),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged:
                                          (ColorMatchingListData? value) {
                                        productname.value = value;
                                        designNoController.text =
                                            '${value?.designNo}';
                                        productDetails.value =
                                            value?.productDetails ?? [];
                                        warpColor.value =
                                            value?.productDetails?.first;
                                      },
                                      decoration: const InputDecoration(
                                          contentPadding:
                                              EdgeInsets.symmetric(
                                                  horizontal: 8),
                                          border: OutlineInputBorder(),
                                          // hintText: 'Select',
                                          labelText: 'Product'),
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
                                controller: designNoController,
                                hintText: "Design No",
                                validate: "string",
                                readonly: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Wrap(
                          children: [
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
                                Obx(() => Container(
                                      width: 240,
                                      padding: const EdgeInsets.only(
                                          top: 0, bottom: 12, right: 12),
                                      child: DropdownButtonFormField(
                                        value: warpColor.value,
                                        items: productDetails
                                            .map((ProductDetails item) {
                                          return DropdownMenuItem<
                                              ProductDetails>(
                                            value: item,
                                            child: Text(
                                              '${item.warpColor}',
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (ProductDetails? value) {
                                          warpColor.value = value;
                                          weftColor.value =
                                              '${value?.weftColor}' as List;
                                          // warpColor.value = value.productDetails ?? [];

                                          // warpColor.value = value?.warpColor
                                          //     as ProductDetails?;
                                          // weftColor.value =
                                          //     value?.warpColor as List;
                                        },
                                        decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8),
                                            border: OutlineInputBorder(),
                                            // hintText: 'Select',
                                            labelText: 'Warp Color'),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Required';
                                          }
                                          return null;
                                        },
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text(
                                "Alternative Warp:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF5700BC),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          children: [
                            Text('test:$weftColor'),
                          ],
                        ),
                        Container(
                          width: Get.width,
                          color: Color(0xFFF4F2FF),
                          child: addlistyarnStock(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )));
    });
  }

  Widget addlistyarnStock() {
    return Obx(() => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Container(
              width: Get.width,
              color: Color(0xFFF4F2FF),
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                      label:
                          Text("Weft Color", overflow: TextOverflow.ellipsis)),
                ],
                rows: weftColor.map((user) {
                  return DataRow(
                    cells: [
                      DataCell(Text('', overflow: TextOverflow.ellipsis)),
                    ],
                  );
                }).toList(),
              )),
        ));
  }
}
