import 'package:abtxt/model/ProductInfoModel.dart';
import 'package:abtxt/view/basics/job_work_product_opening_balance/job_work_product_opening_balance_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class JobWorkProductOpeningBalanceBottomSheet extends StatefulWidget {
  const JobWorkProductOpeningBalanceBottomSheet({Key? key}) : super(key: key);

  @override
  State<JobWorkProductOpeningBalanceBottomSheet> createState() => _State();
}

class _State extends State<JobWorkProductOpeningBalanceBottomSheet> {
  Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController designNoController = TextEditingController();
  TextEditingController orderedWorkController = TextEditingController();
  TextEditingController piecesController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initValue();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobWorkProductOpeningBalanceController>(
        builder: (controller) {
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
          KeyAction(
            LogicalKeyboardKey.enter,
            'Add',
                () => submit(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F3FF),
          appBar: AppBar(title: const Text('Add item to JobWork Product Opening Balance')),
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
                                      MyDialogList(
                                        labelText: 'Product Name',
                                        controller: productNameController,
                                        list: controller.products,
                                        showCreateNew: false,
                                        onItemSelected: (ProductInfoModel item) {
                                          productNameController.text =
                                          '${item.productName}';
                                          productName.value = item;
                                          designNoController.text='${item.designNo}';
                                          // controller.request['group_name'] = item.id;

                                        },
                                        onCreateNew: (value) async {
                                        },
                                      ),
                                      Row(
                                        children: [
                                          MyTextField(
                                            controller: designNoController,
                                            hintText: 'Design No',
                                            validate: 'string',
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyDropdownButtonFormField(
                                              controller: orderedWorkController,
                                              hintText: "Ordered Work",
                                              items: ['Yes' , 'No']),
                                          // MyTextField(
                                          //   controller: orderedWorkController,
                                          //   hintText: 'Ordered Work',
                                          //   validate: 'string',
                                          // ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyTextField(
                                            controller: piecesController,
                                            hintText: 'Pieces',
                                            validate: 'number',
                                          ),
                                        ],
                                      ),
                                      MyTextField(
                                        controller: quantityController,
                                        hintText: 'Quantity',
                                        validate: 'number',
                                        suffix:Text('${productName.value?.productUnit}', style: TextStyle(color: Color(0xFF5700BC))),

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
        "product_name": productName.value?.productName,
        "product_id": productName.value?.id,
        "design_no": designNoController.text,
        "ordered_work": orderedWorkController.text,
        "pcs": piecesController.text,
        "quantity": int.tryParse(quantityController.text)??0,
      };
      Get.back(result: request);
    }
  }
  void _initValue(){
   JobWorkProductOpeningBalanceController controller = Get.find();
   orderedWorkController.text = 'Yes';


   if(Get.arguments !=null){
     var item = Get.arguments['item'];
     designNoController.text ='${item['design_no']}';
     orderedWorkController.text ='${item['ordered_work']}';
     piecesController.text ='${item['pcs']}';
     quantityController.text ='${item['quantity']}';

     
     var productNameList = controller.products
         .where((element) => '${element.id}' == '${item['product_id']}')
         .toList();
     if (productNameList.isNotEmpty) {
       productName.value = productNameList.first;
       productNameController.text = '${productNameList.first.productName}';
     }
   }

  }
}
