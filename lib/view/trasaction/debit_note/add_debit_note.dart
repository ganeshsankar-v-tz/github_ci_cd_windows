import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/trasaction/purchase_return/product_purchase_return/add_product_purchase_return.dart';
import 'package:abtxt/view/trasaction/purchase_return/warp_purchase_return/add_warp_purchase_return.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyPrintButton.dart';
import '../purchase_return/yarn_purchase_return/add_yarn_purchase_return.dart';
import 'debit_note_controller.dart';

class AddDebitNote extends StatefulWidget {
  const AddDebitNote({super.key});

  static const String routeName = '/add_debit_note';

  @override
  State<AddDebitNote> createState() => _AddDebitNoteState();
}

class _AddDebitNoteState extends State<AddDebitNote> {
  DebitNoteController controller = Get.find<DebitNoteController>();

  var debitNoteTypeController =
      TextEditingController(text: 'Yarn purchase return');
  var debitNoteDateController = TextEditingController();

  var id = "".obs;
  var selectedReturnType = "".obs;
  var selectedRowDetails = {}.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DebitNoteController>(
      builder: (controller) {
        return CoreWidget(
          loadingStatus: controller.status.isLoading,
          appBar: AppBar(
            title: Obx(() {
              return Text(
                  "Add Debit Note${selectedReturnType.value.isNotEmpty ? " / ${selectedReturnType.value}" : ""}");
            }),
            actions: [
              Obx(() {
                return Visibility(
                  visible: id.isNotEmpty,
                  child: MyDeleteIconButton(
                    isDialogOpen: false,
                    onPressed: () {
                      controller.delete(id.value);
                    },
                  ),
                );
              }),
              const SizedBox(width: 8),
              Obx(() {
                return Visibility(
                  visible: id.isNotEmpty,
                  child: MyPrintButton(
                    onPressed: () => _print(),
                  ),
                );
              }),
              const SizedBox(width: 12),
            ],
          ),
          bindings: {
            const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
                Get.back(),
            const SingleActivator(LogicalKeyboardKey.keyP, control: true): () =>
                _print(),
          },
          child: Obx(
            () => selectedReturnType.value == "Yarn purchase return"
                ? AddYarnPurchaseReturn(value: selectedRowDetails)
                : selectedReturnType.value == "Warp purchase return"
                    ? AddWarpPurchaseReturn(value: selectedRowDetails)
                    : selectedReturnType.value == "Product purchase return"
                        ? const AddProductPurchaseReturn()
                        : Container(),
          ),
        );
      },
    );
  }

  Widget myAlertDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            MyDropdownButtonFormField(
              autofocus: true,
              controller: debitNoteTypeController,
              hintText: "Select Return Type",
              items: const [
                "Yarn purchase return",
                "Warp purchase return",
                /* "Product purchase return",*/
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: debitNoteTypeController.text);
          },
          child: const Text("OK"),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }

  void _initValue() async {
    if (Get.arguments == null) {
      var result = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => myAlertDialog(),
      );

      if (result != null) {
        selectedReturnType.value = result;
      }
    } else {
      selectedRowDetails.value = Get.arguments["item"];

      selectedReturnType.value = selectedRowDetails["debit_note_type"];
      id.value = "${Get.arguments["item"]["id"]}";
    }
  }

  Future<void> _print() async {
    if (id.isEmpty) {
      return;
    }

    String? response = await controller.debitNotePdf(id.value);
    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }
}
