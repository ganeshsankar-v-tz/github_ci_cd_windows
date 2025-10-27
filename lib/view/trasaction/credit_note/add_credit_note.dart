import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/trasaction/sale_return/product_sale_return/add_product_sale_return.dart';
import 'package:abtxt/view/trasaction/sale_return/warp_sale_return/add_warp_sale_return.dart';
import 'package:abtxt/view/trasaction/sale_return/yarn_sales_return/add_yarn_sales_return.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyPrintButton.dart';
import 'credit_note_controller.dart';

class AddCreditNote extends StatefulWidget {
  const AddCreditNote({super.key});

  static const String routeName = '/add_credit_note';

  @override
  State<AddCreditNote> createState() => _AddCreditNoteState();
}

class _AddCreditNoteState extends State<AddCreditNote> {
  CreditNoteController controller = Get.find<CreditNoteController>();

  var debitNoteTypeController =
      TextEditingController(text: 'Product sale return');
  var debitNoteDateController = TextEditingController();

  var id = "".obs;
  var selectedReturnType = "".obs;
  var selectedRowDetails = <String, dynamic>{}.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreditNoteController>(
      builder: (controller) {
        return CoreWidget(
          loadingStatus: controller.status.isLoading,
          appBar: AppBar(
            title: Obx(() {
              return Text(
                  "Add Credit Note${selectedReturnType.value.isNotEmpty ? " / ${selectedReturnType.value}" : ""}");
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
          },
          child: Obx(
            () => selectedReturnType.value == "Product sale return"
                ? AddProductSalesReturn(value: selectedRowDetails)
                : selectedReturnType.value == "Warp sale return"
                    ? AddWarpSaleReturn(value: selectedRowDetails)
                    : selectedReturnType.value == "Yarn sale return"
                        ? AddYarnSalesReturn(value: selectedRowDetails)
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
                "Product sale return",
                "Yarn sale return",
                "Warp sale return",
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
      selectedReturnType.value = selectedRowDetails["credit_note_type"];
      id.value = "${Get.arguments["item"]["id"]}";
    }
  }

  Future<void> _print() async {
    if (id.isEmpty) {
      return;
    }

    String? response = await controller.creditNotePdf(id.value);
    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }
}
