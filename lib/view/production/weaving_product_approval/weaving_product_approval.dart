import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/production/weaving_product_approval/weaving_product_approval_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../widgets/MyFilterIconButton.dart';

class WeavingProductApproval extends StatefulWidget {
  const WeavingProductApproval({super.key});

  static const String routeName = '/weaving_product_approval';

  @override
  State<WeavingProductApproval> createState() => _WeavingProductApprovalState();
}

class _WeavingProductApprovalState extends State<WeavingProductApproval> {
  WeavingProductApprovalController controller = Get.find();
  var statusController = TextEditingController(text: "Pending");

  @override
  void initState() {
    _api(request: "status[0]=Pending");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeavingProductApprovalController>(
      builder: (controller) {
        return CoreWidget(
          loadingStatus: false,
          bindings: {
            const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
                Get.back(),
            const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
                _filter(),
          },
          appBar: AppBar(
            title: const Text("Weaving Product Approval"),
            actions: [
              MyFilterIconButton(
                  onPressed: () => _filter(),
                  filterIcon: controller.filterData != null ? true : false,
                  tooltipText: "${controller.filterData}"),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.weavingPendingProductApprovalList.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount:
                            controller.weavingPendingProductApprovalList.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          var item = controller
                              .weavingPendingProductApprovalList[index];
                          int weavingId = item.id ?? 0;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: ShapeDecoration(
                              color: Colors.white.withAlpha(99),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 0.5, color: Color(0xFFE4E4E4)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Text section
                                  Expanded(
                                    child: Column(
                                      spacing: 4,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Weaver: ${item.weaverName ?? 'N/A'} , Loom: ${item.loomNo ?? 'N/A'}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          item.productName ?? '',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Wages: ₹${item.wages ?? 0}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          'Created By: ${item.createdByName ?? ""} At ${item.eDate ?? ""}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Visibility(
                                          visible: statusController.text !=
                                              "Pending",
                                          child: Text(
                                            '${statusController.text} By: ${item.approvedByName ?? ""} At ${item.updatedAt?.split(" ")[0] ?? ""}',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: statusController.text != "Pending",
                                    child: Text(
                                      statusController.text,
                                      style: TextStyle(
                                          color: statusController.text ==
                                                  "Approved"
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                  ),

                                  // Approve button
                                  Visibility(
                                    visible: statusController.text == "Pending",
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await _submit(weavingId, "Approved");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text("Approve"),
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // Reject button
                                  Visibility(
                                    visible: statusController.text == "Pending",
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await _submit(weavingId, "Rejected");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text("Reject"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: Center(
                        child: Text(
                          'No pending weaving products found!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit(int id, String status) async {
    var request = {
      'status': status,
    };
    await controller.weavingStatusChange(request, id);
  }

  _api({var request}) async {
    await controller.weavingProduct(request);
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: SingleChildScrollView(
          child: MyDropdownButtonFormField(
            controller: statusController,
            hintText: "Status",
            items: const [
              "Pending",
              "Approved",
              "Rejected",
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Close")),
          TextButton(
              onPressed: () {
                var request = "status[0]=${statusController.text}";
                Get.back(result: request);
              },
              child: const Text("Submit")),
        ],
      ),
    );
    result != null ? _api(request: result ?? "") : '';
  }
}
