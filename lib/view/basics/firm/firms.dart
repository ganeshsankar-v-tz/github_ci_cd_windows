import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/firm/add_firm.dart';
import 'package:abtxt/view/basics/firm/firm_controller.dart';
import 'package:abtxt/widgets/MyDataGridHeader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';

TextEditingController _passwordController = TextEditingController();
bool _passwordVisible = false;
var obscurePassword = true.obs;

class Firms extends StatefulWidget {
  const Firms({super.key});

  static const String routeName = '/firms';

  @override
  State<Firms> createState() => _FirmsState();
}

class _FirmsState extends State<Firms> {
  FirmController controller = Get.put(FirmController());
  final _formKey = GlobalKey<FormState>();
  List<dynamic> list = <dynamic>[];
  late MyDataSource dataSource;

  // Soft delete
  // TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    _api();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FirmController>(
      builder: (controller) {
        return CoreWidget(
          appBar: AppBar(
            title: const Text('Basic Info / Firm'),
            actions: [
              MyRefreshIconButton(onPressed: () => _api()),
              const SizedBox(width: 12),
              MyAddItemButton(
                onPressed: () => _add(),
              ),
              SizedBox(width: 12),
            ],
          ),
          bindings: {
            const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
                Get.back(),
            const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
                _add(),
            const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
                _api(),
          },
          loadingStatus: controller.status.isLoading,
          child: MySFDataGridRawTable(
            source: dataSource,
            isLoading: controller.status.isLoading,
            onRowSelected: (index) async {
              var item = list[index];
              _add(args: {'item': item});
            },
            columns: [
              GridColumn(
                width: 80,
                columnName: 'id',
                label: const MyDataGridHeader(title: 'ID'),
              ),
              GridColumn(
                width: 250,
                columnName: 'firm_name',
                label: const MyDataGridHeader(title: 'Firm Name'),
              ),
              GridColumn(
                width: 105,
                columnName: 'short_code',
                label: const MyDataGridHeader(title: 'Short Code'),
              ),
              GridColumn(
                width: 230,
                columnName: 'mobile_no',
                label: const MyDataGridHeader(title: 'Mobile No'),
              ),
              GridColumn(
                width: 300,
                columnName: 'area',
                label: const MyDataGridHeader(title: 'Area'),
              ),
              GridColumn(
                width: 180,
                columnName: 'city',
                label: const MyDataGridHeader(title: 'City'),
              ),
              GridColumn(
                columnName: 'bussiness_type',
                label: const MyDataGridHeader(title: 'Business Type'),
              ),
              // GridColumn(
              //   columnName: 'action',
              //   label: Center(child: Text('Action')),
              // ),
            ],
          ),
        );
      },
    );
  }

  void _api({var request = const {}}) async {
    var response = await controller.firms(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddFirm.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api();
    }
  }

  // void _filter() async {
  //   final result = await showDialog(
  //     context: context,
  //     builder: (_) => const FirmFilter(),
  //   );
  //   result != null ? _api(request: result ?? {}) : '';;
  // }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<dynamic> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e['id']),
        DataGridCell<dynamic>(columnName: 'firm_name', value: e['firm_name']),
        DataGridCell<dynamic>(columnName: 'short_code', value: e['short_code']),
        DataGridCell<dynamic>(columnName: 'mobile', value: e['mobile']),
        DataGridCell<dynamic>(columnName: 'area', value: e['area']),
        DataGridCell<dynamic>(columnName: 'city', value: e['city']),
        DataGridCell<dynamic>(
            columnName: 'bussiness_type', value: e['bussiness_type']),
        // DataGridCell(
        //   columnName: 'action',
        //   value: null,
        // )
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          e.value != null ? '${e.value}' : '',
          style: AppUtils.cellTextStyle(),
        ),
        // child: LayoutBuilder(builder: (context, constraints) {
        //   if (e.columnName == 'action') {
        //     return Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         SoftDeletePage(),
        //       ],
        //     );
        //   } else {
        //     return Text(e.value.toString());
        //   }
        // }),
      );
    }).toList());
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        '${summaryValue}',
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

// //soft delete
//
// class SoftDeletePage extends StatefulWidget {
//   @override
//   _SoftDeletePageState createState() => _SoftDeletePageState();
// }
//
// class _SoftDeletePageState extends State<SoftDeletePage> {
//   TextEditingController _passwordController = TextEditingController();
//   bool passwordVisible = true;
//
//   void _softDeleteRecord(String recordId, String password) async {
//     // Check if the entered password is correct (replace 'adminPassword' with your actual admin password)
//     if (password == 'admin') {
//       // Mark the record as deleted
//       // await recordRef.update({
//       //   'isDeleted': true,
//       // });
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Record deleted successfully.'),
//       ));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Incorrect password.'),
//       ));
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     passwordVisible = true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Icon(
//         Icons.delete,
//         color: Colors.red,
//       ),
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Enter Admin Password'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   TextField(
//                     controller: _passwordController,
//                     keyboardType: TextInputType.visiblePassword,
//                     obscureText: passwordVisible,
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Password',
//                         hintText: 'Enter secure password',
//                         suffixIcon: IconButton(
//                           icon: Icon(passwordVisible
//                               ? Icons.visibility
//                               : Icons.visibility_off),
//                           onPressed: () {
//                             setState(() {
//                               passwordVisible = !passwordVisible;
//                             });
//                           },
//                         )),
//                   ),
//                 ],
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   child: Text('Cancel'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 TextButton(
//                   child: Text('Delete'),
//                   onPressed: () {
//                     String password = _passwordController.text.trim();
//                     String recordId = 'your_record_id_here';
//                     _softDeleteRecord(recordId, password);
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   //
//   @override
//   void dispose() {
//     _passwordController.dispose();
//     super.dispose();
//   }
// }
