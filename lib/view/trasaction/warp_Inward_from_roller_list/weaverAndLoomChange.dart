import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_roller_list/warp_Inward_from_roller_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../../model/LedgerModel.dart';
import '../../../model/LoomModel.dart';
import '../../../widgets/my_search_field/my_search_field.dart';

class WeaverAndLoomChange extends StatefulWidget {
  String trackingId;

  WeaverAndLoomChange({
    super.key,
    required this.trackingId,
  });

  @override
  State<WeaverAndLoomChange> createState() => _WeaverAndLoomChangeState();
}

class _WeaverAndLoomChangeState extends State<WeaverAndLoomChange> {
  Rxn<LedgerModel> weaverNameController = Rxn<LedgerModel>();
  TextEditingController weaverNameTextController = TextEditingController();
  Rxn<LoomModel> loomNoController = Rxn<LoomModel>();
  TextEditingController loomNoTextController = TextEditingController();
  final FocusNode weaverFocusNode = FocusNode();
  final FocusNode loomFocusNode = FocusNode();
  final FocusNode submitFocusNode = FocusNode();
  WarpInwardFromRollerController controller =
      Get.put(WarpInwardFromRollerController());

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.loomList.clear();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(weaverFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpInwardFromRollerController>(
      builder: (controller) {
        return CoreWidget(
          loadingStatus: controller.status.isLoading,
          backgroundColor: Colors.transparent,
          child: AlertDialog(
            title: const Text("Weaver And Loom Change"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: Form(
              key: formKey,
              child: SizedBox(
                width: 300,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MySearchField(
                      setInitialValue: false,
                      autofocus: true,
                      label: "Weaver Name",
                      items: controller.weaverDropdown,
                      textController: weaverNameTextController,
                      focusNode: weaverFocusNode,
                      requestFocus: loomFocusNode,
                      onChanged: (LedgerModel item) {
                        controller.loomInfo(item.id);
                        weaverNameController.value = item;
                        loomNoTextController.text = "";
                        loomNoController.value = null;
                      },
                    ),
                    MySearchField(
                      label: "Loom No",
                      setInitialValue: false,
                      items: controller.loomList,
                      textController: loomNoTextController,
                      focusNode: loomFocusNode,
                      requestFocus: submitFocusNode,
                      onChanged: (LoomModel item) {
                        loomNoController.value = item;
                      },
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("CLOSE"),
              ),
              TextButton(
                focusNode: submitFocusNode,
                onPressed: () async {
                  var request = {
                    "warp_tracker_id": widget.trackingId,
                    "weaver_id": weaverNameController.value?.id,
                    "sub_weaver_no": loomNoController.value?.id,
                    "warp_for": "Weaving"
                  };

                  var result = await controller.weaverAndLoomChange(request);

                  if (result == "success") {
                    Get.back(result: {
                      "weaver_name": weaverNameController.value?.ledgerName,
                      "loom_no": loomNoController.value?.subWeaverNo,
                      "weaver_id": weaverNameController.value?.id,
                      "sub_weaver_no": loomNoController.value?.id,
                      "warp_for": "Weaving"
                    });
                  }
                },
                child: const Text("SUBMIT"),
              ),
            ],
          ),
        );
      },
    );
  }
}
