import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../model/TransportCopyProductSaleModel.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyElevatedButton.dart';
import 'handloom_certificate_controller.dart';

class HandLoomBottomSheet extends StatefulWidget {
  const HandLoomBottomSheet({Key? key}) : super(key: key);

  @override
  State<HandLoomBottomSheet> createState() => _State();
}

class _State extends State<HandLoomBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandLoomController>(builder: (controller) {
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
        ],
        child: Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.90,
          width: MediaQuery.of(context).size.width * 0.90,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Product Sale Bill',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Container(
                            width: 110,
                            height: 27,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 0.50, color: Color(0xFFADADAD)),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            child: const Center(
                                child: Text(
                              "Date",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Container(
                            width: 110,
                            height: 27,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 0.50, color: Color(0xFFADADAD)),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            child: const Center(
                                child: Text(
                              "Sales No",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Container(
                            width: 110,
                            height: 27,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 0.50, color: Color(0xFFADADAD)),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            child: const Center(
                                child: Text(
                              "Bundles",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Container(
                            width: 110,
                            height: 27,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 0.50, color: Color(0xFFADADAD)),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Quantity",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Container(
                            width: 110,
                            height: 27,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 0.50, color: Color(0xFFADADAD)),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Net Amount (Rs)",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 400,
                        width: double.infinity,
                        child: ListView.builder(
                          itemBuilder: ((context, index) {
                            return SalesItemWidget(
                                controller.productSales[index]);
                          }),
                          itemCount: controller.productSales.length,
                          padding: const EdgeInsets.only(top: 5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyCloseButton(
                          onPressed: () => Get.back(),
                          child: const Text('Close'),
                        ),
                        SizedBox(width: 12,),
                        SizedBox(
                          child: MyElevatedButton(
                            onPressed: () => submit(),
                            child: const Text('OK'),
                          ),
                        ),
                      ],
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
    HandLoomController controller = Get.find();
    if (_formKey.currentState!.validate()) {
      List<TransportCopyProductSaleModel> selectedList = [];
      for (TransportCopyProductSaleModel model in controller.productSales) {
        if (model.isChecked) {
          selectedList.add(model);
        }
      }
      Get.back(result: selectedList);
    }
  }

  void _initValue() {}
}

class SalesItemWidget extends StatefulWidget {
  TransportCopyProductSaleModel model;

  SalesItemWidget(this.model, {super.key});

  @override
  State<SalesItemWidget> createState() => _SalesItemWidgetState(model);
}

class _SalesItemWidgetState extends State<SalesItemWidget> {
  TransportCopyProductSaleModel model;

  _SalesItemWidgetState(this.model);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: model.isChecked,
              onChanged: (bool? value) {
                setState(() {
                  model.isChecked = value ?? false;
                });
              },
            ),
            Container(
              width: 110,
              height: 27,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Color(0xFFADADAD)),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              child: Center(
                  child: Text(
                model.salesDate!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              )),
            ),
            const SizedBox(
              width: 12,
            ),
            Container(
              width: 110,
              height: 27,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Color(0xFFADADAD)),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              child: Center(
                  child: Text(
                model.salesNo.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              )),
            ),
            const SizedBox(
              width: 12,
            ),
            Container(
              width: 110,
              height: 27,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Color(0xFFADADAD)),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              child: Center(
                  child: Text(
                model.boxes.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              )),
            ),
            const SizedBox(
              width: 12,
            ),
            Container(
              width: 110,
              height: 27,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.50, color: Color(0xFFADADAD)),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              child: Center(
                  child: Text(
                model.totalQty.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              )),
            ),
            const SizedBox(
              width: 12,
            ),
            Container(
              width: 110,
              height: 27,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.50, color: Color(0xFFADADAD)),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              child: Center(
                child: Text(
                  model.totalNetAmount.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
