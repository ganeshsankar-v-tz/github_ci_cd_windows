import 'dart:convert';

import 'package:abtxt/flutter_core_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDropdownSearch.dart';
import '../../adjustments/alternative_warp_design/alternative_warp_design_list.dart';
import 'append_ledger_controller.dart';

class AppendLedgerScreen extends StatefulWidget {
  const AppendLedgerScreen({super.key});

  static const String routeName = '/append_ledger_screen';

  @override
  State<AppendLedgerScreen> createState() => _State();
}

class _State extends State<AppendLedgerScreen> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> weaverName = Rxn<LedgerModel>();

  final _formKey = GlobalKey<FormState>();
  late AppendLedgerController controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppendLedgerController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: const Text("Append Ledgers"),
        ),
        bindings:{
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () => Get.back(),
        },
        loadingStatus: controller.status.isLoading,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12),
            ),
            //height: Get.height,
            margin: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyAutoComplete(
                      label: 'Weaver Name',
                      items: controller.weaverList,
                      selectedItem: weaverName.value,
                      onChanged: (LedgerModel item) async {
                        weaverName.value = item;
                        controller.appendLedgers(item.id);
                      },
                    ),
                    Visibility(
                        visible: weaverName.value?.id != null,
                        child: Text('${weaverName.value?.city}')),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black12),
                            ),
                            // color: Colors.red,
                            height: 500,
                            width: 300,
                            child: _isLoading
                                ? Center(child: CircularProgressIndicator())
                                : ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                              controller.allLedgerList.length,
                              itemBuilder: (context, index) {
                                LedgerModel item =
                                controller.allLedgerList[index];
                                return ListTile(
                                  title: Text('${item.ledgerName}'),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      if (weaverName.value?.id !=
                                          null) {
                                        var id = item.id;
                                        var request = {
                                          'ledger_id': id,
                                          "weaver_id":
                                          weaverName.value?.id,
                                        };
                                        controller.add(request);
                                      } else {
                                        _validationDialog(context);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.green,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Flexible(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black12),
                            ),
                            height: 500,
                            width: 300,

                            // color: Colors.grey,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.appendLedgerList.length,
                              itemBuilder: (context, index) {
                                var item = controller.appendLedgerList[index];
                                return ListTile(
                                  title: Text('${item}'),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(8.0),
                                              ),
                                              content: const Text(
                                                'Do you want to Remove?',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Get.back(),
                                                  child: const Text(
                                                    'CANCEL',
                                                    style: TextStyle(
                                                        color: Colors.deepPurple),
                                                  ),
                                                ),
                                                TextButton(
                                                    child: const Text(
                                                      'OK',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    onPressed: () async {
                                                      Get.back();
                                                      var id = item.id;
                                                      AppendLedgerController
                                                      controller = Get.find();
                                                      await controller.delete(id);
                                                      dataSource
                                                          .notifyListeners();
                                                    }),
                                              ],
                                            ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _validationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Text('Validation!'),
          content: const Text('Select "Weaver Name" First'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
