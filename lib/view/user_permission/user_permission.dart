import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/user_permission/user_permissions_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class UserPermission extends StatefulWidget {
  const UserPermission({super.key});

  static const String routeName = '/user_permission';

  @override
  State<UserPermission> createState() => _State();
}

class _State extends State<UserPermission> {
  UserPermissionController controller = Get.put(UserPermissionController());
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserPermissionController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(title: Text('${controller.item.userName}')),
        loadingStatus: controller.status.isLoading,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(16),
                child: MaterialSegmentedControl(
                  children: modules,
                  selectionIndex: selectIndex,
                  selectedColor: Colors.grey.shade200,
                  unselectedColor: Colors.white,
                  selectedTextStyle: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedTextStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  borderWidth: 0.5,
                  borderRadius: 15,
                  onSegmentTapped: (index) {
                    setState(() {
                      selectIndex = index;
                    });
                    selectedValue(index);
                  },
                ),
              ),
              Container(
                width: Get.width / 2,
                child: GroupedListView<dynamic, String>(
                  shrinkWrap: true,
                  elements: controller.filterList,
                  groupBy: (element) => "${element['sub_module']}",
                  useStickyGroupSeparators: true,
                  groupSeparatorBuilder: (String groupByValue) {
                    return Container(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        groupByValue,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    );
                  },
                  itemBuilder: (context, dynamic subItem) {
                    return CheckboxListTile(
                      title: Text(
                        subItem['permission'] ?? '',
                      ),
                      subtitle: Text('${subItem['id']}'),
                      value: subItem['access'],
                      onChanged: (bool? value) {
                        var request = {
                          'user_id': controller.item.id,
                          'permission_id': subItem['id'],
                          'access': value
                        };
                        print(request);
                        controller.userPermission(request);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  final Map<int, Widget> modules = {
    0: const SizedBox(
      width: 100,
      child: Center(
          child: Text(
        "Basic",
      )),
    ),
    1: const SizedBox(
      width: 100,
      child: Center(
          child: Text(
        "Transaction",
      )),
    ),
    2: const SizedBox(
      width: 100,
      child: Center(
          child: Text(
        "Production",
      )),
    ),
    3: const SizedBox(
      width: 100,
      child: Center(
          child: Text(
        "Adjustment",
      )),
    ),
    4: const SizedBox(
      width: 100,
      child: Center(
          child: Text(
        "Report",
      )),
    ),
  };

  Future<void> selectedValue(int index) async {
    String name = '';
    if (index == 0) {
      name = "Basic";
    } else if (index == 1) {
      name = "Transaction";
    } else if (index == 2) {
      name = "Production";
    } else if (index == 3) {
      name = "Adjustment";
    } else if (index == 4) {
      name = "Report";
    }

    controller.filterList = controller.list.where((i) => i['module'] == name).toList();
    controller.change(controller.filterList, status: RxStatus.success());

  }
}
