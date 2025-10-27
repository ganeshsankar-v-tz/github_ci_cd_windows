// import 'package:abtxt/utils/constant.dart';
// import 'package:abtxt/view/trasaction/empty_beam_bobbin_delivery_inward/empty_beam_bobbin_delivery_inward_controller.dart';
// import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../widgets/MyElevatedButton.dart';
// import '../../../widgets/MyTextField.dart';
//
// class EmptyBeamBobbinDeliveryInwardBottomSheet extends StatefulWidget {
//   const EmptyBeamBobbinDeliveryInwardBottomSheet({Key? key}) : super(key: key);
//
//   @override
//   State<EmptyBeamBobbinDeliveryInwardBottomSheet> createState() => _State();
// }
//
// class _State extends State<EmptyBeamBobbinDeliveryInwardBottomSheet> {
//   TextEditingController copsReelNameController = TextEditingController();
//   TextEditingController typeController = TextEditingController();
//   TextEditingController qtyController = TextEditingController();
//
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   void initState() {
//     _initValue();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<EmptyBeamBobbinDeliveryInwardController>(
//         builder: (controller) {
//       return Container(
//         padding: const EdgeInsets.all(16),
//         height: MediaQuery.of(context).size.height * 0.90,
//         width: MediaQuery.of(context).size.width * 0.90,
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Add item to Empty (Beam, Bobbin) Delivery / Inward ',
//                   style: TextStyle(fontWeight: FontWeight.w700),
//                 ),
//                 const SizedBox(height: 12),
//                 Container(
//                     padding: const EdgeInsets.only(left: 50),
//                     child: Wrap(
//                       children: [
//                         MyDropdownButtonFormField(
//                             controller: typeController,
//                             hintText: "Type",
//                             items: Constants.TYPE),
//                         MyTextField(
//                           controller: copsReelNameController,
//                           hintText: 'Cops / Reel Name',
//                           validate: 'string',
//                         ),
//                         MyTextField(
//                           controller: qtyController,
//                           hintText: 'Quantity',
//                           validate: 'number',
//                         ),
//                       ],
//                     )),
//                 const SizedBox(
//                   height: 100,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     SizedBox(
//                       width: 200,
//                       child: MyElevatedButton(
//                         color: Colors.red,
//                         onPressed: () => Get.back(),
//                         child: const Text('Cancel'),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     SizedBox(
//                       width: 200,
//                       child: MyElevatedButton(
//                         onPressed: () => submit(),
//                         child: const Text('ADD'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
//
//   submit() {
//     if (_formKey.currentState!.validate()) {
//       var request = {
//         "type": typeController.text,
//         "cops_reel": copsReelNameController.text,
//         "quantity": qtyController.text
//       };
//       Get.back(result: request);
//     }
//   }
//
//   void _initValue() {
//     typeController.text = Constants.TYPE[0];
//   }
// }
