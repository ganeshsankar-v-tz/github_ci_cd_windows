//TwisterItemBottomSheet

import 'dart:convert';

import 'package:abtxt/view/trasaction/warp_or_yarn_dying/warp_or_yarn_dying_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/NewColorModel.dart';
import '../../../model/WarpDesignSheetModel.dart';
import '../../../model/YarnModel.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MultiSelect.dart';
import '../../../widgets/MyDropdown.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../basics/new_color/add_new_color.dart';
import '../../basics/warp_design_sheet/add_warp_design_sheet.dart';
import '../../basics/yarn/add_yarn.dart';


class WarpOrYarnDyingBottomSheet extends StatefulWidget {
  const WarpOrYarnDyingBottomSheet({super.key});

  @override
  State<WarpOrYarnDyingBottomSheet> createState() => _warpyarnBottomSheetState();
}
class _warpyarnBottomSheetState extends State<WarpOrYarnDyingBottomSheet> {
  TextEditingController Date = TextEditingController();
  TextEditingController transaction_type_idController = TextEditingController();
  TextEditingController entry_type_idController = TextEditingController();

late WarpOrYarnDyingController controller;

  //Warp Delivery

  Rxn<WarpDesignSheetModel> warpDesignController = Rxn<WarpDesignSheetModel>();
  TextEditingController warp_type = TextEditingController();
  TextEditingController warp_id_no = TextEditingController();
  TextEditingController product_qyt = TextEditingController();
  TextEditingController yards = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController wages = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController color_to_dye = TextEditingController();

  //Yarn Delivery
  Rxn<YarnModel> _yarnname = Rxn<YarnModel>();
  Rxn<NewColorModel> _colorname = Rxn<NewColorModel>();
  TextEditingController lotsno = TextEditingController();
  TextEditingController _deliveryfrom = TextEditingController();
  TextEditingController _boxno = TextEditingController();
  TextEditingController _toks = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController wagesrs = TextEditingController();
  TextEditingController amountrs = TextEditingController();

  Rxn<NewColorModel> warpColors = Rxn<NewColorModel>();
  var selectedWarpColor = <NewColorModel>[].obs;

  //Yarn Inward
  Rxn<YarnModel> yarnname = Rxn<YarnModel>();
  Rxn<NewColorModel> colorname = Rxn<NewColorModel>();
  TextEditingController _lotsno = TextEditingController();
  TextEditingController stockto = TextEditingController();
  TextEditingController _bagbox = TextEditingController();
  TextEditingController toks = TextEditingController();
  TextEditingController _deliveredQuantity = TextEditingController();
  TextEditingController _receivedQuantity = TextEditingController();

  // Warp Inward
  Rxn<WarpDesignSheetModel> _warpDesignController = Rxn<WarpDesignSheetModel>();
  TextEditingController _warptype = TextEditingController();
  TextEditingController _oldwarpid = TextEditingController();
  TextEditingController _productQyt = TextEditingController();
  TextEditingController _yards = TextEditingController();
  TextEditingController _weight = TextEditingController();
  Rxn<NewColorModel> warpColor = Rxn<NewColorModel>();
  var selectColorOfWarp = <NewColorModel>[].obs;




  final _formKey = GlobalKey<FormState>();
  final _warpDeliveryformKey = GlobalKey<FormState>();
  final _yarnDeliveryformKey = GlobalKey<FormState>();
  final _yarnInwardformkey = GlobalKey<FormState>();
  final _warpInwardformkey = GlobalKey<FormState>();




  var _transactionEntryType = Constants.WARP_COLOR[0].obs;
  var _selectedEntryType = Constants.ENTRY_TYPE[0].obs;

  get option => null;



  @override
  void initState() {
    transaction_type_idController.text = Constants.WARP_COLOR[0];
    entry_type_idController.text = Constants.ENTRY_TYPE[0];
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpOrYarnDyingController>(
        builder: (controller) {
          this.controller= controller;
          return Container(
            padding: EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.90,
            width: MediaQuery.of(context).size.width * 0.90,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Add Item(Wap Or Yan Dying)',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.only(left: 50),
                    child:
                    Wrap(
                      children: [
                        MyTextField(
                          controller: Date,
                          hintText: 'Date',
                          validate: 'number',
                        ),
                        MyDropdown(
                          hintText: "Transaction Type",
                          items: Constants.TRANSACTIONTYPE,
                          onChanged: (value) {
                            _transactionEntryType.value = value;
                          },
                        ),
                        MyDropdown(
                          hintText: "Entry Type",
                          items: Constants.Warp_Or_Yarn,
                          onChanged: (value) {
                            _selectedEntryType.value = value;
                          },
                        ),


                      ],
                    ),
                  ),


                  Form(
                    key: _formKey,
                    child: Obx(() => updateWidget(_selectedEntryType.value)),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 200,
                        child: MyElevatedButton(
                          color: Colors.red,
                          onPressed: () => Get.back(),
                          child: Text('Cancel'),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 200,
                        child: MyElevatedButton(
                          onPressed: () => submit(),
                          child: Text(
                              "${Get.arguments == null ? 'Save' : 'Update'}"),
                        ),
                      ),
                    ],
                  )

                ],
              ),
            ),
          );
        });
  }
  submit() {
    if (_formKey.currentState!.validate()) {

    }else
      if (option == 'Warp Delivery') {
        if(_warpDeliveryformKey.currentState!.validate()){

        }
      }else
if(option == 'Yarn Delivery'){
  if(_yarnDeliveryformKey.currentState!.validate()){


  }
}else
if(option == 'Warp Delivery'){
  if(_warpInwardformkey.currentState!.validate()){


  }
}else
if(option == 'Yarn Inward'){
  if(_yarnInwardformkey.currentState!.validate()){


  }
}

  }

  Widget updateWidget(String option) {
    if (option == 'Warp Delivery') {
      return Form(
        key: _warpDeliveryformKey,
        child: Wrap(

          children: [
            Padding(padding: EdgeInsets.only(left: 50)),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Text(
                //   'Warp Design',
                //   style: TextStyle(
                //       fontWeight: FontWeight.w600,
                //       color: Colors.black87),
                // ),
                Container(
                  width: 240,
                  padding: EdgeInsets.all(8),
                  child: DropdownButtonFormField(
                    value: warpDesignController.value,
                    items: controller.WarpdesignSheet
                        .map((WarpDesignSheetModel item) {
                      return DropdownMenuItem<WarpDesignSheetModel>(
                        value: item,
                        child: Text('${item.designName}',style: TextStyle(fontWeight: FontWeight.normal)),
                      );
                    }).toList(),
                    onChanged: (WarpDesignSheetModel? value) {
                      warpDesignController.value = value;
                    },
                    decoration: const InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                      // hintText: 'Select',
                      labelText: 'Warp Design'
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
            SizedBox(
              width: 11,
            ),
            Container(
              margin: const EdgeInsets.only(top: 17.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(AddWarpDesignSheet.routeName);
                  },
                  splashColor: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  child: Ink(
                    width: 140,
                    height: 30,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFDCFFDB),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 0.20, color: Color(0xFF00DE16)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 16,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            ' Create New',
                            style: TextStyle(
                              color: Color(0xFF202020),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),


           Row(
             children: [
               Padding(padding: EdgeInsets.only(left: 50)),
               MyTextField(
                 controller: warp_type,
                 hintText: 'Warp Type',
                 validate: 'number',
               ),
               MyTextField(
                 controller: warp_id_no,
                 hintText: 'Warp ID No',
                 validate: 'number',
               ),
             ],
           ),
           Row(
             children: [
               Padding(padding: EdgeInsets.only(left: 50)),
               MyTextField(
                 controller: product_qyt,
                 hintText: 'Product Qty',
                 validate: 'number',
               ),
               MyTextField(
                 controller: yards,
                 hintText: 'Yards',
                 validate: 'number',
               ),
             ],
           ),Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 50)),
                MyTextField(
                  controller: weight,
                  hintText: 'Weight',
                  validate: 'number',
                ),
                MyTextField(
                  controller: wages,
                  hintText: 'Wages',
                  validate: 'String',
                ),
              ],
            ),
          Row(
            children: [

              Padding(padding: EdgeInsets.only(left: 50)),
              MyTextField(
                controller: amount,
                hintText: 'Amount (Rs)',
                validate: 'number',
              ),
              MyTextField(
                controller: color_to_dye,
                hintText: 'Color To Dye',
                validate: 'String',
              ),
            ],
          )
          ],
        ),
      );
    } else if (option == 'Yarn Delivery') {
      return Form(
        key: _yarnDeliveryformKey,
        child: Wrap(
          children: [
            const Padding(padding: EdgeInsets.only(left: 50)),
            MyTextField(
              controller: lotsno,
              hintText: 'Lot.s.No',
              validate: 'number',
            ),
           Row(
             children: [
               const Padding(padding: EdgeInsets.only(left: 50)),
               Column(
                 mainAxisSize: MainAxisSize.min,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   // const Text(
                   //   'Yarn Name',
                   //   style: TextStyle(
                   //       fontWeight: FontWeight.w600,
                   //       color: Colors.black87),
                   // ),
                   Container(
                     width: 240,
                     padding: EdgeInsets.all(8),
                     child: DropdownButtonFormField(
                       value: _yarnname.value,
                       items: controller.Yarn
                           .map((YarnModel item) {
                         return DropdownMenuItem<YarnModel>(
                           value: item,
                           child: Text('${item.name}',style: TextStyle(fontWeight: FontWeight.normal)),
                         );
                       }).toList(),
                       onChanged: (YarnModel? value) {
                         _yarnname.value = value;
                       },
                       decoration: const InputDecoration(
                           contentPadding:
                           EdgeInsets.symmetric(horizontal: 8),
                           border: OutlineInputBorder(),
                           // hintText: '',
                           labelText: 'Yarn Name'
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
               SizedBox(
                 width: 11,
               ),
               Container(
                 child: Material(
                   color: Colors.transparent,
                   child: InkWell(
                     onTap: () {
                       Get.toNamed(
                           AddYarn.routeName);
                     },
                     splashColor: Colors.deepPurple.withOpacity(0.1),
                     borderRadius: BorderRadius.circular(20),
                     child: Ink(
                       width: 140,
                       height: 30,
                       decoration: ShapeDecoration(
                         color: const Color(0xFFDCFFDB),
                         shape: RoundedRectangleBorder(
                           side: const BorderSide(
                               width: 0.20, color: Color(0xFF00DE16)),
                           borderRadius: BorderRadius.circular(20),
                         ),
                       ),
                       child: const Center(
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(
                               Icons.add,
                               size: 16,
                               color: Colors.black,
                             ),
                             SizedBox(
                               width: 4,
                             ),
                             Text(
                               ' Create New',
                               style: TextStyle(
                                 color: Color(0xFF202020),
                                 fontSize: 16,
                                 fontFamily: 'Poppins',
                                 fontWeight: FontWeight.w400,
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 ),
               ),
             ],
           ),


         Row(
           children: [
             const Padding(padding: EdgeInsets.only(left: 50)),
             Column(
               mainAxisSize: MainAxisSize.min,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 // const Text(
                 //   'Color Name',
                 //   style: TextStyle(
                 //       fontWeight: FontWeight.w600,
                 //       color: Colors.black87),
                 // ),
                 Container(
                   width: 240,
                   padding: EdgeInsets.all(8),
                   child: DropdownButtonFormField(
                     value: _colorname.value,
                     items: controller.Color
                         .map((NewColorModel item) {
                       return DropdownMenuItem<NewColorModel>(
                         value: item,
                         child: Text('${item.name}',style: TextStyle(fontWeight: FontWeight.normal)),
                       );
                     }).toList(),
                     onChanged: (NewColorModel? value) {
                       _colorname.value = value;
                     },
                     decoration: const InputDecoration(
                         contentPadding:
                         EdgeInsets.symmetric(horizontal: 8),
                         border: OutlineInputBorder(),
                         // hintText: 'Select',
                         labelText: 'Color Name'
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
             SizedBox(
               width: 11,
             ),
             Container(
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   onTap: () {
                     Get.toNamed(AddNewColor.routeName);
                   },
                   splashColor: Colors.deepPurple.withOpacity(0.1),
                   borderRadius: BorderRadius.circular(20),
                   child: Ink(
                     width: 140,
                     height: 30,
                     decoration: ShapeDecoration(
                       color: const Color(0xFFDCFFDB),
                       shape: RoundedRectangleBorder(
                         side: const BorderSide(
                             width: 0.20, color: Color(0xFF00DE16)),
                         borderRadius: BorderRadius.circular(20),
                       ),
                     ),
                     child: const Center(
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(
                             Icons.add,
                             size: 16,
                             color: Colors.black,
                           ),
                           SizedBox(
                             width: 4,
                           ),
                           Text(
                             ' Create New',
                             style: TextStyle(
                               color: Color(0xFF202020),
                               fontSize: 16,
                               fontFamily: 'Poppins',
                               fontWeight: FontWeight.w400,
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
                 ),
               ),
             ),
           ],
         ),

         Row(
           children: [
             const Padding(padding: EdgeInsets.only(left: 50)),
             MyDropdownButtonFormField(
               controller: _deliveryfrom,
               hintText: "Delivery From",
               items: Constants.deliveredFrom,
             ),
             MyTextField(
               controller: _boxno,
               hintText: 'Box / Box No',
               validate: 'number',
             ),
           ],
         ),
          Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 50)),
              MyTextField(
                controller: _toks,
                hintText: 'Toks',
                validate: 'number',
              ),
              MyTextField(
                controller: quantity,
                hintText: 'Quantity',
                validate: 'number',
              ),
            ],
          ),
        Row(
          children: [
            const Padding(padding: EdgeInsets.only(left: 50)),
            MyTextField(
              controller: wagesrs,
              hintText: 'Wages (Rs)',
              validate: 'number',
            ),
            MyTextField(
              controller: amountrs,
              hintText: 'Amount (Rs)',
              validate: 'number',
            ),
          ],
        ), const Padding(padding: EdgeInsets.only(left: 50)),
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
                  margin: EdgeInsets.all(7),
                  width: 226,
                  child: DropDownMultiSelect(
                    onChanged: (List<dynamic> x) {
                      var json = jsonDecode(jsonEncode(x));
                      var items = (json as List)
                          .map((i) => NewColorModel.fromJson(i))
                          .toList();
                      selectedWarpColor.value = items;
                    },
                    labelText:'Warp Color',
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
        ),
      );
    } else if (option == 'Yarn Inward') {
      return Form(
        key: _yarnInwardformkey,
        child: Wrap(
          children: [
            const Padding(padding: EdgeInsets.only(left: 50)),
            MyTextField(
              controller: _lotsno,
              hintText: 'Lot.s.No',
              validate: 'number',
            ),
          Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 50)),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text(
                  //   'Yarn Name',
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.w600,
                  //       color: Colors.black87),
                  // ),
                  Container(
                    width: 240,
                    padding: EdgeInsets.all(8),
                    child: DropdownButtonFormField(
                      value: yarnname.value,
                      items: controller.Yarn
                          .map((YarnModel item) {
                        return DropdownMenuItem<YarnModel>(
                          value: item,
                          child: Text('${item.name}',style: TextStyle(fontWeight: FontWeight.normal)),
                        );
                      }).toList(),
                      onChanged: (YarnModel? value) {
                        yarnname.value = value;
                      },
                      decoration: const InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 8),
                          border: OutlineInputBorder(),
                          // hintText: '',
                          labelText: 'Yarn Name'
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
              SizedBox(
                width: 11,
              ),
              Container(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(AddYarn.routeName);
                    },
                    splashColor: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    child: Ink(
                      width: 140,
                      height: 30,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFDCFFDB),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 0.20, color: Color(0xFF00DE16)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              ' Create New',
                              style: TextStyle(
                                color: Color(0xFF202020),
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
            Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 50)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text(
                    //   'Color Name',
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.w600,
                    //       color: Colors.black87),
                    // ),
                    Container(
                      width: 240,
                      padding: EdgeInsets.all(8),
                      child: DropdownButtonFormField(
                        value: colorname.value,
                        items: controller.Color
                            .map((NewColorModel item) {
                          return DropdownMenuItem<NewColorModel>(
                            value: item,
                            child: Text('${item.name}',style: TextStyle(fontWeight: FontWeight.normal)),
                          );
                        }).toList(),
                        onChanged: (NewColorModel? value) {
                          colorname.value = value;
                        },
                        decoration: const InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 8),
                            border: OutlineInputBorder(),
                            // hintText: 'Select',
                            labelText: 'Color Name'
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
                SizedBox(
                  width: 11,
                ),
                Container(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(AddNewColor.routeName);
                      },
                      splashColor: Colors.deepPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      child: Ink(
                        width: 140,
                        height: 30,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFDCFFDB),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 0.20, color: Color(0xFF00DE16)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                ' Create New',
                                style: TextStyle(
                                  color: Color(0xFF202020),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
           Row(
             children: [
               const Padding(padding: EdgeInsets.only(left: 50)),

               MyDropdownButtonFormField(
                 controller: stockto,
                 hintText: "Stock to",
                 items: Constants.stockTo,
               ),
               MyTextField(
                 controller: _bagbox,
                 hintText: 'Bag / Box No',
                 validate: 'String',
               ),
             ],
           ),
            Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 50)),
                MyTextField(
                  controller: toks,
                  hintText: 'Toks',
                  validate: 'number',
                ),
                MyTextField(
                  controller: _deliveredQuantity,
                  hintText: 'Delivered Quantity',
                  validate: 'number',
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(left: 50)),
            MyTextField(
              controller: _receivedQuantity,
              hintText: 'Received Quantity',
              validate: 'number',
            ),

          ],
        ),
      );
    } else if (option == 'Warp Inward') {
      return Form(
        key: _warpInwardformkey,

        child: Wrap(

          children: [
            const Padding(padding: EdgeInsets.only(left: 50)),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                // const Text(
                //   'Warp Design',
                //   style: TextStyle(
                //       fontWeight: FontWeight.w600,
                //       color: Colors.black87),
                // ),
                Container(
                  width: 240,
                  padding: EdgeInsets.all(8),
                  child: DropdownButtonFormField(
                    value: _warpDesignController.value,
                    items: controller.WarpdesignSheet
                        .map((WarpDesignSheetModel item) {
                      return DropdownMenuItem<WarpDesignSheetModel>(
                        value: item,
                        child: Text('${item.designName}',style: TextStyle(fontWeight: FontWeight.normal)),
                      );
                    }).toList(),
                    onChanged: (WarpDesignSheetModel? value) {
                      _warpDesignController.value = value;
                    },
                    decoration: const InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                      // hintText: 'Select',
                      labelText: 'Warp Design'
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
            SizedBox(
              width: 11,
            ),
            Container(
              margin: const EdgeInsets.only(top: 17.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(AddWarpDesignSheet.routeName);
                  },
                  splashColor: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  child: Ink(
                    width: 140,
                    height: 30,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFDCFFDB),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 0.20, color: Color(0xFF00DE16)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 16,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            ' Create New',
                            style: TextStyle(
                              color: Color(0xFF202020),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 50)),
              MyTextField(
                controller: _warptype,
                hintText: 'Warp Type',
                validate: 'String',
              ),
              MyTextField(
                controller: _oldwarpid,
                hintText: 'Old Warp ID',
                validate: 'number',
              ),
            ],
          ),

          Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 50)),
              MyTextField(
                controller: _productQyt,
                hintText: 'Product Qyt',
                validate: 'number',
              ),
              MyTextField(
                controller: _yards,
                hintText: 'Yards',
                validate: 'number',
              ),
            ],
          ),  const Padding(padding: EdgeInsets.only(left: 50)),
            MyTextField(
              controller: _weight,
              hintText: 'Weight',
              validate: 'number',
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
                  margin: EdgeInsets.all(7),
                  width: 226,
                  child: DropDownMultiSelect(
                    onChanged: (List<dynamic> x) {
                      var json = jsonDecode(jsonEncode(x));
                      var items = (json as List)
                          .map((i) => NewColorModel.fromJson(i))
                          .toList();
                      selectColorOfWarp.value = items;
                    },
                    labelText:'Warp Color',
                    options: controller.colorDropdown,
                    selectedValues: selectColorOfWarp.value,
                    validator: (value) =>
                    selectColorOfWarp.value.isEmpty
                        ? 'Required'
                        : null,
                  ),
                ),
              ],
            ),

          ],
        ),
      );
    }
    else {
      return Container();
    }
  }




  void _initValue() {
    WarpOrYarnDyingController controller = Get.find();
    stockto.text = Constants.stockTo[0];
    _deliveryfrom.text = Constants.deliveredFrom[0];


    if (Get.arguments != null) {
      WarpOrYarnDyingController controller = Get.find();

    }
  }

  // dynamic WeftBalanceBottomsheetDetailsDialogue() async {
  //   var result = await showModalBottomSheet(
  //       context: context,
  //       isDismissible: true,
  //       isScrollControlled: true,
  //       constraints: const BoxConstraints(maxWidth: 800),
  //       builder: (context) {
  //         return const WeftBalanceBottomSheet();
  //       });
  //   return result;
  // }
}
