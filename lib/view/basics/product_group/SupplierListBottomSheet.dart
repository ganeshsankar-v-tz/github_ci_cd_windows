import 'package:abtxt/view/basics/product_group/product_group_controller.dart';
import 'package:abtxt/widgets/MyAddButton.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/LedgerModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/searchfield/decoration.dart';
import '../../../widgets/searchfield/searchfield.dart';

class SupplierListBottomSheet extends StatefulWidget {
  const SupplierListBottomSheet({Key? key}) : super(key: key);

  @override
  State<SupplierListBottomSheet> createState() => _State();
}

class _State extends State<SupplierListBottomSheet> {
  Rxn<LedgerModel> supplierName = Rxn<LedgerModel>();
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController lastPurRate = TextEditingController();
  ProductGroupController controller = Get.find();

  /// Focus Node
  final FocusNode _supplierFocusNode = FocusNode();
  final FocusNode _areaFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductGroupController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(title: const Text('Add Item (Product Group)')),
        // bindings: {
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
        //       Get.back(),
        //   const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
        //       submit(),
        // },
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
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
                            Wrap(
                              children: [
                                /*MyAutoComplete(
                                  forceNextFocus: true,
                                  label: 'Supplier Name',
                                  items: controller.suplier_name,
                                  selectedItem: suplier_name.value,
                                  onChanged: (LedgerModel item) {
                                    suplier_name.value = item;
                                  },
                                ),*/
                                supplierDropDownWidget(),
                                Row(
                                  children: [
                                    MyTextField(
                                      focusNode: _areaFocusNode,
                                      controller: areaController,
                                      hintText: 'Area',
                                      validate: 'string',
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Focus(
                                      skipTraversal: true,
                                      child: MyTextField(
                                        controller: lastPurRate,
                                        hintText: 'Last Pur Rate',
                                        validate: 'double',
                                      ),
                                      onFocusChange: (hasFocus) {
                                        AppUtils.fractionDigitsText(lastPurRate,
                                            fractionDigits: 2);
                                      },
                                    ),
                                  ],
                                ),
                                MyDateFilter(
                                  controller: dateController,
                                  labelText: "Date",
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /*MyCloseButton(
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
                    Flexible(
                        flex: 1, child: Container(color: Colors.grey[400])),
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
        "suplier": supplierName.value?.ledgerName,
        "area": areaController.text,
        "last_pur_rate": lastPurRate.text,
        "supplier_date": dateController.text,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    ProductGroupController controller = Get.find();
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    if (Get.arguments != null) {
      var item = Get.arguments['item'];

      areaController.text = '${item['area']}';
      lastPurRate.text = '${item['last_pur_rate']}';
      dateController.text = '${item['date']}';

      var supplierList = controller.suplier_name
          .where((element) => '${element.ledgerName}' == '${item['suplier']}')
          .toList();
      if (supplierList.isNotEmpty) {
        supplierName.value = supplierList.first;
        supplierNameController.text = '${supplierList.first.ledgerName}';
      }
    }
  }

  supplierDropDownWidget() {
    var list = controller.suplier_name;
    var suggestions = list.map(
      (e) {
        return SearchFieldListItem<LedgerModel>('${e.ledgerName}', item: e);
      },
    ).toList();
    return Container(
      width: 240,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: SearchField<LedgerModel>(
        suggestions: suggestions,
        maxSuggestionsInViewPort: 7,
        itemHeight: 50,
        controller: supplierNameController,
        searchInputDecoration: const InputDecoration(
            label: Text('Supplier Name'),
            labelStyle: TextStyle(fontSize: 14),
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
            ),
            suffixIcon: Icon(Icons.arrow_drop_down)),
        suggestionsDecoration:
            SuggestionDecoration(selectionColor: const Color(0xffA3D8FF)),
        focusNode: _supplierFocusNode,
        autofocus: true,
        onScroll: (a, b) {},
        onSuggestionTap: (value) {
          FocusScope.of(context).requestFocus(_areaFocusNode);
          var item = value.item!;
          supplierName.value = item;
          areaController.text = "${item.area}";
        },
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (supplierNameController.text.isEmpty) {
            return "Required";
          } else {
            return null;
          }
        },
      ),
    );
  }
}
