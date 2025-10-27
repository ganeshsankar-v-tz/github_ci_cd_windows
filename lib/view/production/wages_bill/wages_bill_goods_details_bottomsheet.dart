import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/weaving_models/WeaverAdvanceDetailsModel.dart';
import 'package:abtxt/view/production/wages_bill/wages_bill_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class WagesBillGoodsDetailsBottomSheet extends StatefulWidget {
  const WagesBillGoodsDetailsBottomSheet({Key? key}) : super(key: key);

  @override
  State<WagesBillGoodsDetailsBottomSheet> createState() => _State();
}

class _State extends State<WagesBillGoodsDetailsBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  Rxn<WeaverAdvanceDetailsModel> details = Rxn<WeaverAdvanceDetailsModel>();

  TextEditingController totalAddLessController =
      TextEditingController(text: 'Yes');
  TextEditingController addLessAmountController =
      TextEditingController(text: '0.0');
  TextEditingController netAmountController =
      TextEditingController(text: '0.0');

  WagesbillController controller = Get.find();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WagesbillController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(title: const Text('Wages Pending...Goods Inward Slip')),
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
              submit(),
        },
        loadingStatus: controller.status.isLoading,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(
                          height: 400,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: Get.width,
                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text('Date')),
                                    DataColumn(label: Text('Slip No')),
                                    DataColumn(label: Text('Qty')),
                                    DataColumn(label: Text('Meter / Yard')),
                                    DataColumn(label: Text('Amount (Rs)')),
                                  ],
                                  rows: controller.goodsDetails.map(
                                    (e) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text('${e.eDate}')),
                                          DataCell(Text('${e.challanNo}')),
                                          DataCell(Text('${e.inwardQty}')),
                                          DataCell(Text('${e.inwardMeter}')),
                                          DataCell(Text('${e.credit}')),
                                        ],
                                        selected: e.selected,
                                        onSelectChanged: (bool? value) {
                                          setState(() {
                                            e.selected = value!;
                                          });
                                          _goodsCalculations();
                                        },
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      /*Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(
                          height: 400,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: Get.width,
                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text('Date')),
                                    DataColumn(label: Text('W B No')),
                                    DataColumn(label: Text('Balance')),
                                    DataColumn(label: Text('Excess')),
                                    DataColumn(label: Text('Details')),
                                  ],
                                  rows: controller.advDetails.map(
                                    (e) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text('${e.ledgerId}')),
                                          DataCell(Text('${e.ledgerId}')),
                                          DataCell(Text('${e.ledgerId}')),
                                          DataCell(Text('${e.ledgerId}')),
                                          DataCell(Text('${e.ledgerId}')),
                                        ],
                                        selected: e.selected,
                                        onSelectChanged: (bool? value) {
                                          setState(() {
                                            e.selected = value!;
                                            print("Data $value");
                                          });
                                        },
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),*/
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Column(
                          children: [
                            /*Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MyDropdownButtonFormField(
                                    controller: totalAddLessController,
                                    hintText: "Add / Less",
                                    items: const ["Yes", "No"]),
                                MyTextField(
                                  controller: addLessAmountController,
                                  hintText: "",
                                  validate: "double",
                                  onChanged: (value) {
                                    _goodsCalculations();
                                  },
                                ),
                              ],
                            ),*/
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MyTextField(
                                  controller: netAmountController,
                                  hintText: "Net Amount",
                                  validate: "double",
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyElevatedButton(
                        onPressed: () => submit(),
                        child: Text(Get.arguments == null ? 'Save' : 'Update'),
                      ),
                    ],
                  )
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
      var selectedGoodsInwardList =
          controller.goodsDetails.where((e) => e.selected).toList();
      var list = [];
      selectedGoodsInwardList.forEach((e) {
        var request = {
          'e_date': e.eDate,
          'gi_slip_rec_no': e.giSlipRecNo,
          'challan_no': e.challanNo,
          'inward_qty': e.inwardQty,
          'inward_meter': e.inwardMeter,
          'credit': double.tryParse("${e.credit}") ?? 0.0,
        };
        request["add_less"] =
            double.tryParse(addLessAmountController.text) ?? 0.00;
        list.add(request);
      });
      int i = 0;
      controller.goodsDetails.forEach((element) {
        controller.goodsDetails[i].selected = false;
        i++;
      });

      Get.back(result: list);
    }
  }

//
  void _initValue() async {}

  void _goodsCalculations() {
    var list = controller.goodsDetails.where((e) => e.selected).toList();
    double goodsInwardAmount = 0;
    list.forEach((e) {
      goodsInwardAmount += double.tryParse('${e.credit}') ?? 0;
    });
    double addLessAmount = double.tryParse(addLessAmountController.text) ?? 0;
    double netAmount = goodsInwardAmount + addLessAmount;
    netAmountController.text = '$netAmount';
  }
}
