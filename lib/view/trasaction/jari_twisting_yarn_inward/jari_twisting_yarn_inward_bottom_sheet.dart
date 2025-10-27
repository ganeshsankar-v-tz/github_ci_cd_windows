// import 'dart:convert';
//
// import 'package:abtxt/utils/app_utils.dart';
// import 'package:abtxt/widgets/MyCloseButton.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:keymap/keymap.dart';
//
// import '../../../model/NewColorModel.dart';
// import '../../../model/YarnModel.dart';
// import '../../../widgets/MyDialogList.dart';
// import '../../../widgets/MyElevatedButton.dart';
// import '../../../widgets/MyTextField.dart';
// import 'jari_twisting_yarn_inward_controller.dart';
//
// class JariTwistingYarnInwardBottomSheet extends StatefulWidget {
//   const JariTwistingYarnInwardBottomSheet({super.key});
//   static const String routeName = '/jari_twisting_yarn_inward_bottom_sheet';
//
//
//   @override
//   State<JariTwistingYarnInwardBottomSheet> createState() => _JariTwistingYarnInwardBottomSheetState();
// }
//
// class _JariTwistingYarnInwardBottomSheetState extends State<JariTwistingYarnInwardBottomSheet> {
//   Rxn<YarnModel> yarnName = Rxn<YarnModel>();
//   Rxn<NewColorModel> colorname = Rxn<NewColorModel>();
//   TextEditingController yarnController = TextEditingController();
//   TextEditingController colorController = TextEditingController();
//   TextEditingController consumedqtyController = TextEditingController();
//
//
//   final _formKey = GlobalKey<FormState>();
//
//
//
//   @override
//   void initState() {
//     _initValue();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<JariTwistingYarnInwardController>(builder: (controller) {
//       return KeyboardWidget(
//         bindings: [
//           KeyAction(
//             LogicalKeyboardKey.keyQ,
//             'Close',
//                 () => Get.back(),
//             isControlPressed: true,
//           ),
//         ],
//         child: Scaffold(
//           backgroundColor: const Color(0xFFF9F3FF),
//           appBar: AppBar(title: Text('Edit item to Jari Twisting - Yarn Inward')),
//           body: SingleChildScrollView(
//             child: Container(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Flexible(
//                     flex: 1,
//                     child: Container(
//                       color: Colors.white,
//                       padding: EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Form(
//                             key: _formKey,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Wrap(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         MyDialogList(
//                                           labelText: 'Yarn Name',
//                                           controller: yarnController,
//                                           list: controller.Yarn,
//                                           showCreateNew: false,
//                                           onItemSelected: (YarnModel item) {
//                                             yarnController.text = '${item.name}';
//                                             yarnName.value = item;
//                                           },
//                                           onCreateNew: ()  {
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         MyDialogList(
//                                           labelText: 'Color Name',
//                                           controller: colorController,
//                                           list: controller.Color,
//                                           showCreateNew: false,
//                                           onItemSelected: (NewColorModel item) {
//                                             colorController.text = '${item.name}';
//                                             colorname.value = item;
//                                           },
//                                           onCreateNew: () {
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     MyTextField(
//                                       controller: consumedqtyController,
//                                       hintText: "Consumed Qty",
//                                       validate: "double",
//                                       suffix: Text("Kgs",style: TextStyle( color: Color(0xFF5700BC)),),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 24),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               MyElevatedButton(
//                                 onPressed: () => submit(),
//                                 child: const Text('Edit'),
//                               ),
//                               const SizedBox(width: 16),
//                               MyCloseButton(
//                                   onPressed: ()=>Get.back(),
//                                   child: Text('Cancel')),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Flexible( flex:1,child: Container(color: Colors.white,)),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
//   submit(){
//     if (_formKey.currentState!.validate()) {
//       var request = {
//         "yarn_id" :yarnName.value?.id,
//         "colour_name" : colorController.text,
//         "quantity" : consumedqtyController.text,
//
//
//       };
//       Get.back(result: request);
//     }
//
//   }
//   void _initValue() {
//     if (Get.arguments != null) {
//       JariTwistingYarnInwardController controller = Get.find();
//
//       var item = Get.arguments['item'];
//       print('${jsonEncode(item)}');
//
//
//     consumedqtyController.text = tryCast(item['quantity']);
//     colorController.text = item['colour_name']??'';
//
//
//
//     // Yarn Name
//     var YarnName = controller.Yarn
//         .where((element) => '${element.id}' == '${item['yarn_id']}')
//         .toList();
//     if (YarnName.isNotEmpty) {
//       yarnName.value = YarnName.first;
//       yarnController.text = '${YarnName.first.name}';
//     }
//   }
//   }
//
// }
