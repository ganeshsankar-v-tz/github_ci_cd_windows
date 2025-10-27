import 'package:abtxt/widgets/MyAddButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/YarnModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/searchfield/decoration.dart';
import '../../../widgets/searchfield/searchfield.dart';
import '../yarn/add_yarn.dart';
import 'new_warp_controller.dart';

class NewWarpBottomSheet extends StatefulWidget {
  const NewWarpBottomSheet({Key? key}) : super(key: key);

  @override
  State<NewWarpBottomSheet> createState() => _State();
}

class _State extends State<NewWarpBottomSheet> {
  Rxn<YarnModel> yarn_name = Rxn<YarnModel>();
  TextEditingController yarnNameController = TextEditingController();
  TextEditingController noOfEndsController = TextEditingController();
  NewWarpController controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _yarnNameFocusNode = FocusNode();
  final FocusNode _noOfEndsFocusNode = FocusNode();
  var shortCut = RxString("");

  RxBool isUpdate = RxBool(false);

  @override
  void initState() {
    _yarnNameFocusNode.addListener(() => shortCutKeys());
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewWarpController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(title: const Text('Add item to New Warp')),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                width: Get.width / 2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xFFF9F3FF), width: 16),
                ),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      yarnNameDropDownWidget(),
                      /*MyAutoComplete(
                        label: 'Yarn Name',
                        forceNextFocus: true,
                        items: controller.yarnName,
                        selectedItem: yarn_name.value,
                        onChanged: (YarnModel item) {
                          yarn_name.value = item;
                        },
                      ),*/
                      MyTextField(
                        focusNode: _noOfEndsFocusNode,
                        controller: noOfEndsController,
                        hintText: 'No of Ends',
                        validate: 'number',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              shortCut.value,
                              style: AppUtils.shortCutTextStyle(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          MyAddButton(
                            onPressed: () => submit(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  /// Check The Yarn Id Already Added Or Not
  _checkYarnIdAlreadyExits(yarnId) {
    var warpType = controller.warpType;
    if (warpType == "Main Warp") {
      var exists =
          controller.itemList.any((element) => element['yarn_id'] == yarnId);
      return exists;
    } else {
      return false;
    }
  }

  shortCutKeys() {
    if (_yarnNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Yarn',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_yarnNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddYarn.routeName);

      if (result == "success") {
        controller.yarnNameInfo();
      }
    }
  }

  submit() {
    int noOfEnds = int.tryParse(noOfEndsController.text) ?? 0;
    var exists = _checkYarnIdAlreadyExits(yarn_name.value?.id);
    if (_formKey.currentState!.validate()) {
      if (!exists) {
        if (controller.totalEnds >= noOfEnds) {
          if (noOfEnds == 0) {
            return;
          }
          var request = {
            "yarn_id": yarn_name.value?.id,
            "yarn_name": yarn_name.value?.name,
            "no_of_ends": noOfEnds,
          };
          Get.back(result: request);
        } else {
          AppUtils.showErrorToast(message: "Total Ends Not Matched");
        }
      } else {
        AppUtils.showErrorToast(message: "The selected Yarn already exists!");
      }
    }
  }

  void _initValue() {
    NewWarpController controller = Get.find();

    noOfEndsController.text = "${controller.totalEnds}";

    /*if (Get.arguments != null) {
      isUpdate.value = true;
      var item = Get.arguments['item'];

      var yarnId = controller.yarnName
          .where((element) => '${element.id}' == '${item['yarn_id']}')
          .toList();
      if (yarnId.isNotEmpty) {
        yarn_name.value = yarnId.first;
      }
    } else*/
    if (controller.lastYarn != null) {
      var item = controller.lastYarn;
      var yarnId = controller.yarnName
          .where((element) => '${element.id}' == '${item['yarn_id']}')
          .toList();
      if (yarnId.isNotEmpty) {
        yarn_name.value = yarnId.first;
        yarnNameController.text = "${yarnId.first.name}";
      }
    }
  }

  yarnNameDropDownWidget() {
    var list = controller.yarnName;
    var suggestions = list.map(
      (e) {
        return SearchFieldListItem<YarnModel>('${e.name}', item: e);
      },
    ).toList();
    return Container(
      width: 240,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: SearchField<YarnModel>(
        suggestions: suggestions,
        maxSuggestionsInViewPort: 7,
        itemHeight: 50,
        controller: yarnNameController,
        searchInputDecoration: const InputDecoration(
            label: Text('Yarn Name'),
            labelStyle: TextStyle(fontSize: 14),
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
            ),
            suffixIcon: Icon(Icons.arrow_drop_down)),
        suggestionsDecoration:
            SuggestionDecoration(selectionColor: const Color(0xffA3D8FF)),
        focusNode: _yarnNameFocusNode,
        autofocus: true,
        onScroll: (a, b) {},
        onSuggestionTap: (value) {
          FocusScope.of(context).requestFocus(_noOfEndsFocusNode);
          var item = value.item!;
          yarn_name.value = item;
        },
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (yarnNameController.text.isEmpty) {
            return "Required";
          } else {
            return null;
          }
        },
      ),
    );
  }
}
