// import 'dart:convert';
//
// import 'package:abtxt/widgets/MyElevatedButton.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../utils/constant.dart';
// import '../../../widgets/MyDropdownButtonFormField.dart';
// import '../../../widgets/MyTextField.dart';
// import 'job_work_controller.dart';
//
// class AddItemJobWork extends StatefulWidget {
//   const AddItemJobWork({Key? key}) : super(key: key);
//   static const String routeName = '/AddItemJobWork';
//
//   @override
//   State<AddItemJobWork> createState() => _State();
// }
//
// class _State extends State<AddItemJobWork> {
//   TextEditingController DateController = TextEditingController();
//   TextEditingController TransactionType = TextEditingController();
//   TextEditingController EntryTypeController = TextEditingController();
//   TextEditingController ProductController = TextEditingController();
//   TextEditingController EmptyController = TextEditingController();
//   TextEditingController WorkController = TextEditingController();
//   TextEditingController QuantityController = TextEditingController();
//   TextEditingController OrderWorkController = TextEditingController();
//
//   var dyername = false.obs;
//   var Entrytype = false.obs;
//   var Yarnname = false.obs;
//   var colorname = false.obs;
//
//   final _formKey = GlobalKey<FormState>();
//   late JobWorkController controller;
//
//   @override
//   void initState() {
//     DateController.text = "01";
//     TransactionType.text = "02";
//     EntryTypeController.text = "03";
//     ProductController.text = "1";
//     EmptyController.text = " ";
//     WorkController.text = "02";
//     QuantityController.text = "03";
//     OrderWorkController.text = "White";
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<JobWorkController>(builder: (controller) {
//       this.controller = controller;
//       return Scaffold(
//         backgroundColor: Color(0xFFF9F3FF),
//         appBar: AppBar(
//           elevation: 0,
//           title: Text("Add Item (Job Work)"),
//           centerTitle: false,
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: Colors.black12),
//             ),
//             //height: Get.height,
//             margin: EdgeInsets.all(16),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Flexible(
//                   flex: 3,
//                   child: Form(
//                     key: _formKey,
//                     child: Container(
//                       //color: Colors.green,
//                       padding: EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Wrap(
//                             children: [
//                               Row(
//                                 children: [
//                                   MyTextField(
//                                     controller: DateController,
//                                     hintText: "Date",
//                                     validate: 'number',
//                                   ),
//                                   MyDropdownButtonFormField(
//                                     controller: TransactionType,
//                                     hintText: "Account Type ",
//                                     items: Constants.Account,
//                                   ),
//                                   MyDropdownButtonFormField(
//                                     controller: EntryTypeController,
//                                     hintText: "Transaction Type ",
//                                     items: Constants.Trasaction,
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 100,
//                               ),
//                               Row(
//                                 children: [
//                                   MyTextField(
//                                     controller: ProductController,
//                                     hintText: "Lot",
//                                     validate: 'number',
//                                   ),
//                                   MyTextField(
//                                     controller: EmptyController,
//                                     hintText: " ",
//                                     validate: 'number',
//                                   ),
//                                   MyTextField(
//                                     controller: WorkController,
//                                     hintText: "Record No",
//                                     validate: "number",
//                                   ),
//                                   MyTextField(
//                                     controller: EmptyController,
//                                     hintText: " ",
//                                     validate: 'number',
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   MyTextField(
//                                     controller: QuantityController,
//                                     hintText: "Firm",
//                                     validate: "number&String",
//                                   ),
//                                   MyTextField(
//                                     controller: OrderWorkController,
//                                     hintText: "Details",
//                                     validate: "number&String",
//                                   ),
//                                   MyTextField(
//                                     controller: EmptyController,
//                                     hintText: " ",
//                                     validate: 'number',
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                           // Wrap(
//                           //   children: [
//                           //     Obx(
//                           //       () => LabeledCheckbox(
//                           //         label: "Yarn",
//                           //         value: dyername.value,
//                           //         onChanged: (value) {
//                           //           dyername.value == value;
//                           //         },
//                           //       ),
//                           //     ),
//                           //     Obx(
//                           //       () => LabeledCheckbox(
//                           //         label: "Wrap",
//                           //         value: Entrytype.value,
//                           //         onChanged: (value) {
//                           //           Entrytype.value = value;
//                           //         },
//                           //       ),
//                           //     ),
//                           //     Obx(
//                           //       () => LabeledCheckbox(
//                           //         label: "Saree",
//                           //         value: Yarnname.value,
//                           //         onChanged: (value) {
//                           //           Yarnname.value = value;
//                           //         },
//                           //       ),
//                           //     ),
//                           //   ],
//                           // ),
//                           SizedBox(height: 48),
//                           Row(
//                             children: [
//                               Container(
//                                 width: 200,
//                                 child: MyElevatedButton(
//                                   onPressed: () => submit(),
//                                   child: Text('Cancel'),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Container(
//                                 width: 200,
//                                 child: MyElevatedButton(
//                                   onPressed: () => submit(),
//                                   child: Text('Add'),
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
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
//         "Dyername": DateController.text,
//         "DcNo": TransactionType.text,
//         "EntryDate": EntryTypeController.text,
//         "Details": ProductController.text,
//         "EntryType": WorkController.text,
//         "YarnName": QuantityController.text,
//         "ColorName": OrderWorkController.text,
//         "tin_no": "1234",
//         "cst_no": "1234",
//         "area_id": 1,
//         "city_id": 1,
//         "country_id": 1,
//         "s_warp": dyername.value,
//         "s_yarn": Entrytype.value,
//         "s_saree": Yarnname.value,
//         "Color": colorname.value,
//         "agentName": "1234",
//       };
//
//       print(jsonEncode(request));
//
//       controller.addLedger(request);
//     }
//   }
// }
