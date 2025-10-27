import 'package:abtxt/view/basics/product_group/product_group_controller.dart';
import 'package:abtxt/widgets/MyAddButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class ProductListBottomSheet extends StatefulWidget {
  const ProductListBottomSheet({Key? key}) : super(key: key);

  @override
  State<ProductListBottomSheet> createState() => _State();
}

class _State extends State<ProductListBottomSheet> {
  TextEditingController designNo = TextEditingController();
  TextEditingController group = TextEditingController();
  TextEditingController productNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final FocusNode _firstInputFocusNode = FocusNode();


  @override
  void initState() {
    _initValue();
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_firstInputFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductGroupController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: const Text(
            'Add Item (Product Group)',
          ),
        ),
        // bindings:{
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
        //       Get.back(),
        //   const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
        //       submit(),
        // },

        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ,control: true): GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS,control: true): SaveIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),

                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //const SizedBox(height: 12),
                            Wrap(
                              children: [
                                //const SizedBox(height: 25),
                                Wrap(
                                  children: [
                                    Row(
                                      children: [
                                        MyTextField(
                                          controller: productNameController,
                                          hintText: 'Product Name',
                                          validate: 'string',
                                          focusNode: _firstInputFocusNode,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        MyTextField(
                                          controller: designNo,
                                          hintText: 'Design No',
                                          validate: 'string',
                                        ),
                                      ],
                                    ),
                                    MyTextField(
                                      controller: group,
                                      hintText: 'Group',
                                      validate: 'string',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               /* MyCloseButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Close'),
                                ),
                                const SizedBox(width: 16),*/
                                MyAddButton(
                                  onPressed: () => submit(),
                                  //child: const Text('ADD'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(flex: 1, child: Container(color: Colors.grey[400])),
                  ],
                ),
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
        "product_name": productNameController.text,
        "design_no": designNo.text,
        "group": group.text,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    ProductGroupController controller = Get.find();
    if (Get.arguments != null) {
      var item = Get.arguments['item'];
      productNameController.text = '${item['product_name']}';
      designNo.text = '${item['design_no']}';
      group.text = '${item['group']}';
    }
  }
}
