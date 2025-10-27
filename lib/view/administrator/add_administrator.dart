import 'package:abtxt/model/administrator/AdministratorModel.dart';
import 'package:abtxt/view/user_permission/user_permission.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/flutter_shortcut_widget.dart';
import '../../utils/app_utils.dart';
import '../../widgets/MyDataGridHeader.dart';
import '../../widgets/MySFDataGridItemTable.dart';
import 'administrator_controller.dart';

class AddAdministrator extends StatefulWidget {
  const AddAdministrator({super.key});

  static const String routeName = '/add_administrator';

  @override
  State<AddAdministrator> createState() => _State();
}

class _State extends State<AddAdministrator> {
  TextEditingController adminNameController = TextEditingController();
  TextEditingController adminPasswordController = TextEditingController();
  var userNameController = TextEditingController().obs;
  var userTypeController = TextEditingController(text: "User").obs;
  var userPasswordController = TextEditingController().obs;
  var retypePasswordController = TextEditingController().obs;
  var isActiveController = TextEditingController(text: "Yes").obs;

  RxBool adminObscurePassword = RxBool(true);
  RxBool userObscurePassword = RxBool(true);
  RxBool retypeObscurePassword = RxBool(true);
  RxBool isEnable = RxBool(true);

  final _formKey = GlobalKey<FormState>();
  AdministratorController controller = Get.find();

  final FocusNode _adminFocusNode = FocusNode();

  final DataGridController _dataGridController = DataGridController();
  late ItemDataSource dataSource;
  List<AdministratorModel> itemList = <AdministratorModel>[];

  @override
  void initState() {
    _apiCall();
    super.initState();
    dataSource = ItemDataSource(list: itemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdministratorController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: const Text("Administrator"),
        ),
        loadingStatus: controller.status.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () => Get.back()),
            SaveIntent: SetCounterAction(perform: () => submit()),
          },
          child: FocusScope(
            autofocus: true,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FocusTraversalGroup(
                          policy: OrderedTraversalPolicy(),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              MyTextField(
                                autofocus: true,
                                controller: adminNameController,
                                hintText: "Administrator",
                                validate: "string",
                                focusNode: _adminFocusNode,
                              ),
                              Obx(
                                () => MyTextField(
                                  obscureText: adminObscurePassword.value,
                                  controller: adminPasswordController,
                                  hintText: "Password",
                                  validate: "string",
                                  suffixIcon: IconButton(
                                    focusNode: FocusNode(skipTraversal: true),
                                    icon: Icon(adminObscurePassword.value
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    color: Colors.black54,
                                    onPressed: () {
                                      adminObscurePassword.value =
                                          !adminObscurePassword.value;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 40),
                              OutlinedButton(
                                onPressed: () => adminNameAndPasswordCheck(),
                                style: ButtonStyle(
                                  minimumSize: WidgetStateProperty.all(
                                      const Size(60, 46)),
                                  shape: WidgetStateProperty.resolveWith((s) =>
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0))),
                                ),
                                child: const Text(
                                  "OK",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        FocusTraversalGroup(
                          policy: OrderedTraversalPolicy(),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => Wrap(
                                    children: [
                                      MyTextField(
                                        enabled: !isEnable.value,
                                        controller: userNameController.value,
                                        hintText: "User Name",
                                        validate: "string",
                                      ),
                                      MyDropdownButtonFormField(
                                        enabled: !isEnable.value,
                                        controller: userTypeController.value,
                                        hintText: "User Type",
                                        items: const [
                                          "User",
                                          "Admin",
                                          "Delete",
                                          "Finish",
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Obx(
                                  () => Wrap(
                                    children: [
                                      MyTextField(
                                        enabled: !isEnable.value,
                                        controller:
                                            userPasswordController.value,
                                        obscureText: userObscurePassword.value,
                                        hintText: "Password",
                                        validate: "string",
                                        suffixIcon: Visibility(
                                          visible: !isEnable.value,
                                          child: IconButton(
                                            focusNode:
                                                FocusNode(skipTraversal: true),
                                            icon: Icon(userObscurePassword.value
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                            color: Colors.black54,
                                            onPressed: () {
                                              userObscurePassword.value =
                                                  !userObscurePassword.value;
                                            },
                                          ),
                                        ),
                                      ),
                                      MyTextField(
                                        enabled: !isEnable.value,
                                        obscureText:
                                            retypeObscurePassword.value,
                                        controller:
                                            retypePasswordController.value,
                                        hintText: "Retype Password",
                                        validate: "string",
                                        suffixIcon: Visibility(
                                          visible: !isEnable.value,
                                          child: IconButton(
                                            focusNode:
                                                FocusNode(skipTraversal: true),
                                            icon: Icon(
                                                retypeObscurePassword.value
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                            color: Colors.black54,
                                            onPressed: () {
                                              retypeObscurePassword.value =
                                                  !retypeObscurePassword.value;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Obx(
                                  () => MyDropdownButtonFormField(
                                    enabled: !isEnable.value,
                                    controller: isActiveController.value,
                                    hintText: "Is Active",
                                    items: const ["Yes", "No"],
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        isEnable.value ? null : submit(),
                                    style: ButtonStyle(
                                      minimumSize: WidgetStateProperty.all(
                                          const Size(60, 46)),
                                      shape: WidgetStateProperty.resolveWith(
                                          (s) => RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0))),
                                    ),
                                    child: const Text(
                                      "SUBMIT",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    flex: 2,
                    child: SizedBox(height: Get.height, child: itemsTable()),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      var userType = userTypeController.value.text;
      var password = userPasswordController.value.text;
      var retypePassword = retypePasswordController.value.text;

      if (userType == "Admin") {
        userType = "A";
      } else if (userType == "User") {
        userType = "U";
      } else if (userType == "Delete") {
        userType = "D";
      } else {
        userType = "F";
      }

      if (password != retypePassword) {
        return AppUtils.infoAlert(message: "Password entered is incorrect");
      }

      Map<String, dynamic> request = {
        "user_name": userNameController.value.text,
        "user_type": userType,
        "password": password,
        "c_password": retypePassword,
        "is_active": isActiveController.value.text,
      };

      var result = await controller.newUserAdd(request);

      if (result == true) {
        isEnable.value = true;
        _apiCall();
      }
    }
  }

  void _apiCall() async {
    var response = await controller.userDetailsList();
    itemList.clear();
    itemList.addAll(response);
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
  }

  Widget itemsTable() {
    return ExcludeFocus(
      child: MySFDataGridItemTable(
        controller: _dataGridController,
        rowHeight: 42,
        scrollPhysics: const ScrollPhysics(),
        columns: [
          GridColumn(
            visible: false,
            columnName: 'id',
            label: const MyDataGridHeader(title: 'Id'),
          ),
          GridColumn(
            columnName: 'user_name',
            label: const MyDataGridHeader(title: 'User'),
          ),
          GridColumn(
            columnName: 'user_type',
            label: const MyDataGridHeader(title: 'Type'),
          ),
          GridColumn(
            columnName: 'is_active',
            label: const MyDataGridHeader(
                alignment: Alignment.center, title: 'Is Active'),
          ),
        ],
        source: dataSource,
        onRowSelected: (index) async {
          var item = itemList[index];
          Get.toNamed(UserPermission.routeName, arguments: item);
        },
      ),
    );
  }

  adminNameAndPasswordCheck() async {
    var name = adminNameController.text;
    var password = adminPasswordController.text;

    if (name.isEmpty || password.isEmpty) {
      return AppUtils.infoAlert(message: "Enter the user name and password");
    }

    var result = await controller.adminLoginCheck(name, password);

    if (result == true) {
      isEnable.value = false;
    } else {
      isEnable.value = true;
    }
  }
}

class ItemDataSource extends DataGridSource {
  ItemDataSource({required List<AdministratorModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<AdministratorModel> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var userType = "";
      if (e.userType == "A") {
        userType = "Admin";
      } else if (e.userType == "U") {
        userType = "User";
      } else if (e.userType == "D") {
        userType = "Delete";
      } else {
        userType = "Finish";
      }

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'id', value: e.id),
        DataGridCell<dynamic>(columnName: 'user_name', value: e.userName),
        DataGridCell<dynamic>(columnName: 'user_type', value: userType),
        DataGridCell<dynamic>(columnName: 'is_Active', value: e.isActive),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // const List<Widget> activeStatus = <Widget>[Text('Yes'), Text('No')];
    // final List<bool> isActive = [true, false].obs;
    RxInt selectIndex = RxInt(0);

    final Map<int, Widget> status = {
      0: const Text(
        "Yes",
      ),
      1: const Text(
        "No",
      ),
    };

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      if (dataGridCell.columnName == "is_Active") {
        /// API value integration
        var item = dataGridCell.value;

        if (item == "Yes") {
          selectIndex.value = 0;
        } else {
          selectIndex.value = 1;
        }

        return Obx(
          () => segmentWidget(status, selectIndex, row),
        );

        /*  return Obx(() => Container(
              alignment: Alignment.center,
              child: ToggleButtons(
                onPressed: (int index) {
                  AdministratorController controller = Get.find();

                  var id = row.getCells()[0].value;
                  var status = "";
                  var userType = row.getCells()[2].value;

                  /// user type check
                  if (userType == "Admin") {
                    return AppUtils.infoAlert(
                        message: "The admin active status cannot be changed.");
                  }

                  for (int i = 0; i < isActive.length; i++) {
                    isActive[i] = i == index;
                  }

                  /// selected status convert
                  if (index == 0) {
                    status = "Yes";
                  } else {
                    status = "No";
                  }

                  /// send the user status in API
                  Map<String, dynamic> request = {
                    "activeSts": status,
                    "user_id": id,
                  };

                  controller.userActiveStatusChange(request);
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedColor: Colors.white,
                fillColor: Colors.red[200],
                color: Colors.red[400],
                constraints: const BoxConstraints(
                  minHeight: 25,
                  minWidth: 60,
                ),
                isSelected: isActive,
                children: activeStatus,
              ),
            ));*/
      } else {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dataGridCell.value != null ? '${dataGridCell.value}' : '',
            style: AppUtils.cellTextStyle(),
          ),
        );
      }
    }).toList());
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }

  segmentWidget(Map<int, Widget> status, RxInt selectIndex, DataGridRow row) {
    return SizedBox(
      height: 10,
      child: MaterialSegmentedControl(
        children: status,
        selectionIndex: selectIndex.value,
        selectedColor: Colors.red.shade300,
        unselectedColor: Colors.white,
        selectedTextStyle: const TextStyle(
            color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        unselectedTextStyle: const TextStyle(
            color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
        borderWidth: 0.5,
        borderRadius: 3,
        verticalOffset: 6,
        onSegmentTapped: (index) {
          AdministratorController controller = Get.find();

          var id = row.getCells()[0].value;
          var status = "";
          var userType = row.getCells()[2].value;

          /// user type check
          if (userType == "Admin") {
            return AppUtils.infoAlert(
                message: "The admin active status cannot be changed.");
          }
          selectIndex.value = index;

          /// selected status convert
          if (index == 0) {
            status = "Yes";
          } else {
            status = "No";
          }

          /// send the user status in API
          Map<String, dynamic> request = {
            "activeSts": status,
            "user_id": id,
          };

          controller.userActiveStatusChange(request);
        },
      ),
    );
  }
}
