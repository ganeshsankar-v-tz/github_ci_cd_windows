import 'package:abtxt/model/TransportCopyProductSaleModel.dart';
import 'package:abtxt/view/trasaction/transport_copy_list/transport_copy_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyElevatedButton.dart';

class TransportCopyBottomSheet extends StatefulWidget {
  const TransportCopyBottomSheet({Key? key}) : super(key: key);

  @override
  State<TransportCopyBottomSheet> createState() => _State();
}

class _State extends State<TransportCopyBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late List<TransportCopyProductSaleModel> list = [];

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransportCopyController>(builder: (controller) {
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
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
                      ),
                      SizedBox(
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
                  const SizedBox(height: 100),
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
    TransportCopyController controller = Get.find();
    if (_formKey.currentState!.validate()) {
      List<TransportCopyProductSaleModel> checkedValues = [];
      for (TransportCopyProductSaleModel model in controller.productSales) {
        if (model.isChecked) {
          checkedValues.add(model);
        }
      }

      var salesNo = "";
      var invoiceDate = "";
      int totalQty = 0;
      int bundle = 0;
      double totalNetAmount = 0;

      for (var value in checkedValues) {
        salesNo += '${value.salesNo},';
        invoiceDate += '${value.salesDate},';
        totalQty += value.totalQty ?? 0;
        totalNetAmount += value.totalNetAmount ?? 0;
        bundle += value.boxes ?? 0;
      }
      var request = {
        "salesNo": salesNo,
        "invoiceDate": invoiceDate,
        "totalQty": totalQty.toString(),
        "totalNetAmount": totalNetAmount.toString(),
        "bundle": bundle.toString(),
      };

      Get.back(result: request);
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
        Align(
          alignment: Alignment.center,
          child: Row(
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
                    side:
                        const BorderSide(width: 0.50, color: Color(0xFFADADAD)),
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
                    side:
                        const BorderSide(width: 0.50, color: Color(0xFFADADAD)),
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
        ),
      ],
    );
  }
}
