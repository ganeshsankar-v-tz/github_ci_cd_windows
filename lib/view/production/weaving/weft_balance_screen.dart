import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constant.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class WeftBalanceBottomSheet extends StatefulWidget {
  const WeftBalanceBottomSheet({Key? key}) : super(key: key);

  @override
  State<WeftBalanceBottomSheet> createState() => _WiderItemBottomSheetState();
}

class _WiderItemBottomSheetState extends State<WeftBalanceBottomSheet> {
  TextEditingController entry_type_idController = TextEditingController();
  TextEditingController weaver_name = TextEditingController();
  TextEditingController loom = TextEditingController();
  TextEditingController warpwise = TextEditingController();

  // Empty box Values
  TextEditingController delivered_qyt = TextEditingController();
  TextEditingController received_qyt = TextEditingController();
  TextEditingController balance_qyt = TextEditingController();
  TextEditingController delivered_cops = TextEditingController();
  TextEditingController received_cops = TextEditingController();
  TextEditingController balance_cops = TextEditingController();


  TextEditingController delivered_lnth = TextEditingController();
  TextEditingController received_lnth = TextEditingController();
  TextEditingController balance_lnth = TextEditingController();
  TextEditingController delivered_reel = TextEditingController();
  TextEditingController received_reel = TextEditingController();
  TextEditingController balance_reel = TextEditingController();

  var addWeftBalanceList = <dynamic>[].obs;

  final _formKey = GlobalKey<FormState>();
  var _selectedEntryType = Constants.ENTRY_TYPES[0].obs;

  @override
  void initState() {
    entry_type_idController.text = Constants.ENTRY_TYPES[0];
    super.initState();
    _initValue();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.90,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weft Balance', style: TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(height: 12),

           Container(
             width: Get.width,
             height: 120,
             decoration:  ShapeDecoration(
               color: Colors.white,
               shape: RoundedRectangleBorder(
                 side: BorderSide(width: 1, color: Color(0xFFCDCDCD)),
                 borderRadius: BorderRadius.circular(2),
               ),
             ),padding: EdgeInsets.only(left: 15,top: 20),
             child:  Wrap(
               children: [
                 MyTextField(
                   controller: weaver_name,
                   hintText: 'Weaver Name',
                   validate: 'string',
                 ),
                 MyDropdownButtonFormField(
                   controller: loom,
                   hintText: "Loom",
                   items: Constants.Hint,
                 ),
                 MyDropdownButtonFormField(
                   controller: warpwise,
                   hintText: "WarpWise",
                   items: Constants.WeaverName,
                 ),
               ],
             ),
           ),
            SizedBox(
              height: 10,
            ),

            Wrap(
              children: [
                Container(
                  child:Text("Delivered Qty",style: TextStyle(color: Colors.black),) ,
                ),
                SizedBox(
                  width: 25,
                ),
                Container(
                  child:Text("Received Qty",style: TextStyle(color: Colors.black),) ,
                ),SizedBox(
                  width: 30,
                ),
                Container(
                  child:Text("Balance Qty",style: TextStyle(color: Colors.black),) ,
                ),SizedBox(
                  width: 35,
                ),
                Container(
                  child:Text("Delivered Cops",style: TextStyle(color: Colors.black),) ,
                ),SizedBox(
                  width: 20,
                ),
                Container(
                  child:Text("Received Cops",style: TextStyle(color: Colors.black),) ,
                ),SizedBox(
                  width: 15,
                ),
                Container(
                  child:Text("Balance Cops",style: TextStyle(color: Colors.black),) ,
                ),

              ],
            ),
            SizedBox(
              height: 5,
            ),
            Wrap(
              children: [
                Container(
                  width: 103,
                  height: 27,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.40, color: Color(0xFF929292)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Delivered"),
                ),
                SizedBox(width: 10),

                Container(
                  width: 103,
                  height: 27,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.40, color: Color(0xFF929292)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Received"),
                ),
                SizedBox(width: 10),
                Container(
                  width: 103,
                  height: 27,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.40, color: Color(0xFF929292)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Balance"),
                ),
                SizedBox(width: 10),
                Container(
                  width: 103,
                  height: 27,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.40, color: Color(0xFF929292)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Delivered"),
                ),
                SizedBox(width: 10),
                Container(
                  width: 103,
                  height: 27,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.40, color: Color(0xFF929292)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Received"),
                ),
                SizedBox(width: 10),
                Container(
                  width: 103,
                  height: 27,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.40, color: Color(0xFF929292)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Balance"),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Wrap(
              children: [
                Container(
                  child:Text("Delivered Length",style: TextStyle(color: Colors.black),) ,
                ),
                SizedBox(
                  width: 6,
                ),
                Container(
                  child:Text("Received Length",style: TextStyle(color: Colors.black),) ,
                ),SizedBox(
                  width: 10,
                ),
                Container(
                  child:Text("Balance Length",style: TextStyle(color: Colors.black),) ,
                ),SizedBox(
                  width: 10,
                ),
                Container(
                  child:Text("Delivered Reel",style: TextStyle(color: Colors.black),) ,
                ),SizedBox(
                  width: 22,
                ),
                Container(
                  child:Text("Received Reel",style: TextStyle(color: Colors.black),) ,
                ),SizedBox(
                  width: 23,
                ),
                Container(
                  child:Text("Balance Reel",style: TextStyle(color: Colors.black),) ,
                ),

              ],
            ),SizedBox(
              height: 5,
            ),
            Wrap(
              children: [
                Container(
                  width: 103,
                  height: 27,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.40, color: Color(0xFF929292)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),padding: EdgeInsets.only(left: 10),
                  child: Text("Delivered"),
                ),
                SizedBox(width: 10),

                Container(
                  width: 103,
                  height: 27,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.40, color: Color(0xFF929292)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Received"),
                ),
                SizedBox(width: 10),
                Container(
                  width: 103,
                  height: 27,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.40, color: Color(0xFF929292)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Balance"),
                ),
                SizedBox(width: 10),
                Container(
                  width: 103,
                  height: 27,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.40, color: Color(0xFF929292)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Delivered"),
                ),
                SizedBox(width: 10),
                Container(
                  width: 103,
                  height: 27,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.40, color: Color(0xFF929292)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Received"),
                ),
                SizedBox(width: 10),
                Container(
                  width: 103,
                  height: 27,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.40, color: Color(0xFF929292)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Balance"),
                )
              ],
            ),
            // Wrap(
            //   children: [
            //     MyTextField(
            //       controller: delivered_qyt,
            //       hintText: 'Delivered Qyt',
            //       validate: 'string',
            //     ),
            //     MyTextField(
            //       controller: received_qyt,
            //       hintText: 'Received Qyt',
            //       validate: 'string',
            //     ),
            //     MyTextField(
            //       controller: balance_qyt,
            //       hintText: 'Balance Qyt',
            //       validate: 'string',
            //     ),
            //     MyTextField(
            //       controller: delivered_cops,
            //       hintText: 'Delivered Cops',
            //       validate: 'string',
            //     ),
            //     MyTextField(
            //       controller: received_cops,
            //       hintText: 'Received Cops',
            //       validate: 'string',
            //     ),
            //     MyTextField(
            //       controller: balance_cops,
            //       hintText: 'Balance Cops',
            //       validate: 'string',
            //     ),
            //   ],
            // ),
            // Wrap(
            //   children: [
            //     MyTextField(
            //       controller: delivered_lnth,
            //       hintText: 'Delivered Length',
            //       validate: 'string',
            //     ),
            //     MyTextField(
            //       controller: received_lnth,
            //       hintText: 'Received Length',
            //       validate: 'string',
            //     ),
            //     MyTextField(
            //       controller: balance_lnth,
            //       hintText: 'Balance Length',
            //       validate: 'string',
            //     ),
            //     MyTextField(
            //       controller: delivered_reel,
            //       hintText: 'Delivered Reel',
            //       validate: 'string',
            //     ),
            //     MyTextField(
            //       controller: received_reel,
            //       hintText: 'Received Reel',
            //       validate: 'string',
            //     ),
            //     MyTextField(
            //       controller: balance_reel,
            //       hintText: 'Balance Reel',
            //       validate: 'string',
            //     ),
            //   ],
            // ),
            SizedBox(
              height: 30,
            ),

            Container(
              width: Get.width,
              color: Color(0xFFF4EAFF),
              child: addweftbalancelist(),
            ),
            SizedBox(
              height: 30,
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

      ]),
          ],
        ),
      ),
    );
  }
  Widget addweftbalancelist() {
    return Obx(() => DataTable(
      onSelectAll: (b) {},
      sortColumnIndex: 0,
      sortAscending: true,
      columns: const <DataColumn>[
        DataColumn(label: Text("WarpStatus")),
        DataColumn(label: Text("YarnName")),
        DataColumn(label: Text("Recuired")),
        DataColumn(label: Text("Delivered")),
        DataColumn(label: Text("Balance")),
        DataColumn(label: Text("Used")),
        DataColumn(label: Text("Weaverstock")),

      ],
      rows: addWeftBalanceList.map((user) {
        return DataRow(
          cells: [
            DataCell(Text('${user['WarpStatus']}')),
            DataCell(Text('${user['YarnName']}')),
            DataCell(Text('${user['Recuired']}')),
            DataCell(Text('${user['Delivered']}')),
            DataCell(Text('${user['Balance']}')),
            DataCell(Text('${user['Used']}')),
            DataCell(Text('${user['WeaverStock']}')),


          ],
        );
      }).toList(),
    ),

    );

  }
  void _initValue(){
    weaver_name.text=" Data";
    loom.text=Constants.Hint[0];
    warpwise.text=Constants.WeaverName[0];
    // Empty box Values
    delivered_qyt.text=" ";
    received_qyt.text=" ";
    balance_qyt.text=" ";
    delivered_cops.text=" ";
    received_cops.text=" ";
    balance_cops.text=" ";

    delivered_lnth.text=" ";
    received_lnth.text=" ";
    balance_lnth.text=" ";
    delivered_reel.text=" ";
    received_reel.text=" ";
    balance_reel.text=" ";
  }



}
