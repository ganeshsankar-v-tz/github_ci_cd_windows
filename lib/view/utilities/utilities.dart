import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../utils/constant.dart';

class Utilities extends StatefulWidget {
  const Utilities({super.key});

  @override
  State<Utilities> createState() => _UtilitiesState();
}

class _UtilitiesState extends State<Utilities> {
  var name = "".obs;
  var email = "".obs;
  TextEditingController languageController = TextEditingController();
  TextEditingController themeController = TextEditingController();
  TextEditingController displayController = TextEditingController();
  TextEditingController notificationController = TextEditingController();

  static const bool isSwitched = false;

  @override
  void initState() {
    _initValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: Container(
              height: Get.height,
              width: Get.width,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 100,
                            backgroundImage: AssetImage('assets/images/ic_user.png'),
                          ),
                          SizedBox(height: 12),
                          Obx(() => Text(
                                '${name}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          Obx(() => Text('${email}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF717171)))),
                          SizedBox(height: 12),
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Color(0xFFD252FF),
                              ),
                            ),
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Edit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'App Version: 1.0\n',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 600,
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: boxDecoration(),
                        child: ListTile(
                          leading: Icon(Icons.notifications_active_outlined),
                          title: Text(
                            'Notification',
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: MyDropdownButtonFormField(
                            controller: notificationController,
                            hintText: '',
                            items: Constants.ISACTIVE,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: boxDecoration(),
                        child: ListTile(
                          leading: Icon(Icons.g_translate_outlined),
                          title: Text(
                            'Language',
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: MyDropdownButtonFormField(
                              controller: languageController,
                              hintText: '',
                              items: Constants.Language),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: boxDecoration(),
                        child: ListTile(
                          leading: Icon(Icons.settings),
                          title: Text(
                            'Theme',
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: MyDropdownButtonFormField(
                            controller: themeController,
                            hintText: '',
                            items: Constants.Theme,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: boxDecoration(),
                        child: ListTile(
                          leading: Icon(Icons.monitor),
                          title: Text(
                            'Display',
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: MyDropdownButtonFormField(
                              controller: displayController,
                              hintText: '',
                              items: Constants.DisplaySize),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: boxDecoration(),
                        child: ListTile(
                          leading: Icon(Icons.file_copy),
                          title: Text(
                            'Terms & Conditions',
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Icon(Icons.chevron_right),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: boxDecoration(),
                        child: ListTile(
                          leading: Icon(Icons.info_outline),
                          title: Text(
                            'App Info',
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Icon(Icons.chevron_right),
                        ),
                      ),
                      SizedBox(height: 24),
                      MyElevatedButton(
                        onPressed: () async {
                          var box = GetStorage();
                          await box.erase();
                          Get.offAllNamed('/');
                        },
                        child: Text('Logout'),
                        color: Color(0xFFFF9797),
                      )

                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 495,
                            height: 58,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.10,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x1C000000),
                                  blurRadius: 5.10,
                                  offset: Offset(1, 1),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            padding: EdgeInsets.only(left: 15),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.notifications_active_outlined,
                                  color: Colors.purpleAccent,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  'Notification',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 150,
                                  child: MyDropdownButtonFormField(
                                      controller: notificationController,
                                      hintText: '',
                                      items: Constants.ISACTIVE),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 495,
                            height: 58,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.10,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x1C000000),
                                  blurRadius: 5.10,
                                  offset: Offset(1, 1),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            padding: EdgeInsets.only(left: 15),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.g_translate_outlined,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  'Language',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 150,
                                  child: MyDropdownButtonFormField(
                                      controller: languageController,
                                      hintText: '',
                                      items: Constants.Language),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 495,
                            height: 58,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.10,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x1C000000),
                                  blurRadius: 5.10,
                                  offset: Offset(1, 1),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            padding: EdgeInsets.only(left: 15),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.settings,
                                  color: Colors.yellow,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  'Theme',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 150,
                                  child: MyDropdownButtonFormField(
                                      controller: themeController,
                                      hintText: '',
                                      items: Constants.Theme),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 495,
                            height: 58,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.10,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x1C000000),
                                  blurRadius: 5.10,
                                  offset: Offset(1, 1),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            padding: EdgeInsets.only(left: 15),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.computer_outlined,
                                  color: Colors.orangeAccent,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  'Display',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 150,
                                  child: MyDropdownButtonFormField(
                                      controller: displayController,
                                      hintText: '',
                                      items: Constants.DisplaySize),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 495,
                            height: 58,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.10,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x1C000000),
                                  blurRadius: 5.10,
                                  offset: Offset(1, 1),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            padding: EdgeInsets.only(left: 15),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.speaker_notes,
                                  color: Colors.purpleAccent,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Terms & Conditions',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 495,
                            height: 58,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.10,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x1C000000),
                                  blurRadius: 5.10,
                                  offset: Offset(1, 1),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            padding: EdgeInsets.only(left: 15),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.redAccent,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Info',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.orange,
                                  ),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(3)))),
                              onPressed: () async {
                                //---------------------

                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    // title: Center(
                                    //     child: Text(
                                    //   "Alert",
                                    //   style: TextStyle(color: Colors.red),
                                    // )),
                                    content: const Text(
                                      'Do you want to Logout?',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                          child: Text('OK'),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            final prefs = await SharedPreferences
                                                .getInstance();
                                            prefs.clear();
                                            Get.offAllNamed(Login.routeName);
                                          }),
                                    ],
                                  ),
                                );

                                //---------------------------
                                // do something
                              },
                              icon: Icon(
                                Icons.logout_outlined,
                                color: Colors.white,
                              ),
                              label: Text(
                                'LogOut',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      )*/
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _initValue() async {
    languageController.text = Constants.Language[0];
    themeController.text = Constants.Theme[0];
    displayController.text = Constants.DisplaySize[0];
    notificationController.text = Constants.ISACTIVE[0];


    var box = GetStorage();

    name.value = '${box.read("name")}';
    email.value = '${box.read("email")}';
  }

  ShapeDecoration boxDecoration() {
    return ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 0.10,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      shadows: const [
        BoxShadow(
          color: Color(0x1C000000),
          blurRadius: 5.10,
          offset: Offset(1, 1),
          spreadRadius: 0,
        )
      ],
    );
  }
}
