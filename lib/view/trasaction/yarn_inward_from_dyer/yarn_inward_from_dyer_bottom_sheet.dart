import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/YarnModel.dart';
import 'package:abtxt/view/trasaction/yarn_inward_from_dyer/yarn_inward_from_dyer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class YarnInwardFromDyerBottomSheet extends StatefulWidget {
  const YarnInwardFromDyerBottomSheet({Key? key}) : super(key: key);

  @override
  State<YarnInwardFromDyerBottomSheet> createState() => _State();
}

class _State extends State<YarnInwardFromDyerBottomSheet> {
  Rxn<YarnModel> yarnNameController = Rxn<YarnModel>();
  TextEditingController yarnController = TextEditingController();
  Rxn<NewColorModel> colorNameController = Rxn<NewColorModel>();
  TextEditingController colorController = TextEditingController();
  TextEditingController yarnBalanceController = TextEditingController();
  TextEditingController yarnOrderBalanceController = TextEditingController();
  TextEditingController bagBoxNoController = TextEditingController();
  TextEditingController stocktoController = TextEditingController();
  TextEditingController packController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController lessController = TextEditingController();
  TextEditingController netQuantityController = TextEditingController();
  TextEditingController calculateTypeController = TextEditingController();
  TextEditingController wagesRsController = TextEditingController();
  TextEditingController amountRsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnInwardFromDyerController>(builder: (controller) {
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
          KeyAction(
            LogicalKeyboardKey.keyS,
            'Save',
                () async => submit(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text('Add Item Yarn Inward from Dyer')),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFF9F3FF),width: 16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(

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
                                      MyAutoComplete(
                                        label: 'Yarn Name',
                                        items: controller.DyerName,
                                        selectedItem: yarnNameController.value,
                                        onChanged: (YarnModel item) {
                                          yarnNameController.value = item;
                                          //  _firmNameFocusNode.requestFocus();
                                        },
                                      ),
                                      /*MyDialogList(
                                        labelText: 'Yarn Name',
                                        controller: yarnController,
                                        list: controller.YarnName,
                                        showCreateNew: false,
                                        onItemSelected: (YarnModel item) {
                                          yarnController.text = '${item.name}';
                                          yarnNameController.value = item;
                                        },
                                        onCreateNew: (value) async {
                                        },
                                      ),*/
                                      MyTextField(
                                        controller: yarnBalanceController,
                                        hintText: 'Yarn Balance',
                                        validate: 'number',
                                        suffix: const Text('Pondhu',
                                            style: TextStyle(color: Color(0xFF5700BC))),
                                      ),

                                      Row(
                                        children: [
                                          MyAutoComplete(
                                            label: 'Color Name',
                                            items: controller.ColorName,
                                            selectedItem: colorNameController.value,
                                            onChanged: (NewColorModel item) {
                                              colorNameController.value = item;
                                              //  _firmNameFocusNode.requestFocus();
                                            },
                                          ),
                                          /*MyDialogList(
                                            labelText: 'Color Name',
                                            controller: colorController,
                                            list: controller.ColorName,
                                            showCreateNew: false,
                                            onItemSelected: (NewColorModel item) {
                                              colorController.text = '${item.name}';
                                              colorNameController.value = item;
                                            },
                                            onCreateNew: (value) async {

                                            },
                                          ),*/
                                          MyTextField(
                                            controller: yarnOrderBalanceController,
                                            hintText: 'Yarn Order Balance',
                                            validate: 'number',
                                            suffix: const Text('Pondhu',
                                                style: TextStyle(color: Color(0xFF5700BC))),
                                          ),

                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyDropdownButtonFormField(
                                            controller: stocktoController,
                                            hintText: "Stock to",
                                            items: Constants.Stock,
                                          ),
                                          MyTextField(
                                            controller: bagBoxNoController,
                                            hintText: 'Bag /Box No',
                                            validate: 'String',
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyTextField(
                                            controller: packController,
                                            hintText: 'Pack',
                                            validate: 'number',
                                            onChanged: (value) {
                                              _sumQuantityRate();
                                            },
                                          ),
                                          MyTextField(
                                            controller: quantityController,
                                            hintText: 'Quantity',
                                            validate: 'double',
                                            suffix: const Text('Pondhu',
                                                style: TextStyle(color: Color(0xFF5700BC))),
                                            onChanged: (value) {
                                              _sumQuantityRate();
                                            },
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          MyTextField(
                                            controller: lessController,
                                            hintText: 'Less (-)',
                                            validate: 'double',
                                            onChanged: (value) {
                                              _sumQuantityRate();
                                            },
                                          ),
                                          MyTextField(
                                            controller: netQuantityController,
                                            hintText: 'Net Quantity',
                                            validate: 'double',
                                            suffix: const Text('Pondhu',
                                                style: TextStyle(color: Color(0xFF5700BC))),
                                            readonly: true,
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          MyDropdownButtonFormField(
                                            controller: calculateTypeController,
                                            hintText: "Calculate Type",
                                            items: Constants.Calculate_type,
                                            onChanged: (value) {
                                              _sumQuantityRate();
                                            },
                                          ),
                                          MyTextField(
                                            controller: wagesRsController,
                                            hintText: 'Wages (Rs)',
                                            validate: 'double',
                                            onChanged: (value) {
                                              _sumQuantityRate();
                                            },
                                          ),
                                        ],
                                      ),
                                      MyTextField(
                                        controller: amountRsController,
                                        hintText: 'Amount (Rs)',
                                        validate: 'double',
                                        readonly: true,
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
                                    Visibility(
                                      visible: Get.arguments != null,
                                      child: MyElevatedButton(
                                        color: Colors.red,
                                        onPressed: () =>
                                            Get.back(result: {'item': 'delete'}),
                                        child: const Text('DELETE'),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    SizedBox(
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
        "yarn_id": yarnNameController.value?.id,
        "yarn_balance": yarnBalanceController.text,
        "color_id": colorNameController.value?.id,
        "yarn_order_balance": yarnOrderBalanceController.text,
        "stock_no": stocktoController.text,
        "bag_box_no": bagBoxNoController.text,
        "pack": int.tryParse(packController.text)??0,
        "less": lessController.text,
        "net_qty": netQuantityController.text,
        "calculate_type": calculateTypeController.text,
        "wages":wagesRsController.text,
        "amount": double.tryParse(amountRsController.text)??0.0,
        "yarn_name": yarnNameController.value?.name,
        "color_name": colorNameController.value?.name,
        "quantity": double.tryParse(quantityController.text)??0.0,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    YarnInwardFromDyerController controller = Get.find();
    calculateTypeController.text = Constants.Calculate_type[0];
    stocktoController.text = Constants.Stock[0];
    if(Get.arguments!=null){
      var item = Get.arguments['item'];
      yarnBalanceController.text= '${item['yarn_balance']}';
      yarnOrderBalanceController.text= '${item['yarn_order_balance']}';
      stocktoController.text= '${item['stock_no']}';
      bagBoxNoController.text= '${item['bag_box_no']}';
      packController.text= '${item['pack']}';
      quantityController.text= '${item['quantity']}';
      lessController.text= '${item['less']}';
      netQuantityController.text= '${item['net_qty']}';
      calculateTypeController.text= '${item['calculate_type']}';
      wagesRsController.text= '${item['wages']}';
      amountRsController.text= '${item['amount']}';


      var yarnList = controller.YarnName
          .where((element) => '${element.id}' == '${item['yarn_id']}')
          .toList();
      if (yarnList.isNotEmpty) {
        yarnNameController.value = yarnList.first;
        yarnController.text = '${yarnList.first.name}';
      }

      var colorList = controller.ColorName
          .where((element) => '${element.id}' == '${item['color_id']}')
          .toList();
      if (colorList.isNotEmpty) {
        colorNameController.value = colorList.first;
        colorController.text = '${colorList.first.name}';
      }

    }

  }

  void _sumQuantityRate() {
    double quantity = double.tryParse(quantityController.text) ?? 0.0;
    double less = double.tryParse(lessController.text) ?? 0.0;
    double wage = double.tryParse(wagesRsController.text) ?? 0.0;
    int pack = int.tryParse(packController.text) ?? 0;
    var netQuantity = quantity - less;
    netQuantityController.text = '$netQuantity';

    dynamic amount = 0;
    if (calculateTypeController.text == 'Pack x Wages') {
      amount = pack * wage;

    } else {
      amount = netQuantity * wage;

    }
    amountRsController.text = '$amount';
  }
}
