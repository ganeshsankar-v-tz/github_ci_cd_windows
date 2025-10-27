import 'package:abtxt/view/login/reset_successfully_screen.dart';
import 'package:abtxt/view/login/set_new_password_screen_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'login.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});
  static const String routeName = '/setnewpassword';

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  var storedValue = '';

  @override
  void initState() {
    super.initState();
    _loadStoredValue();
  }

  _loadStoredValue() async {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      storedValue = prefs.getString('email') ??
          ''; // Provide a default value if the key doesn't exist
      // email == storedValue;
    });*/
  }

  final _formKey = GlobalKey<FormState>();
  late SetNewPasswordScreenController controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<SetNewPasswordScreenController>(builder: (controller) {
      this.controller = controller;
      return Scaffold(
        body: Container(
          color: const Color(0xFFF4EAFF),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 50),
              child: Container(
                height: size.height,
                width: size.width * .4,
                // color: Colors.green,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFF5F5F5),
                      spreadRadius: 1,
                      blurRadius: 1,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Container(
                      height: size.height,
                      width: size.width * .3,
                      // color: Colors.blue,
                      padding: const EdgeInsets.only(
                        top: 50,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/set_new_password_key.png',
                                  height: 50,
                                  width: 50,
                                ),
                              ],
                            ),
                          ),

                          Form(
                            key: _form,
                            child: Container(
                              // height: 50,
                              width: size.width * .3,
                              child: const Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'Set New Password',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'your new password be different from \npreviously used password',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF858585),
                                        fontSize: 15,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        height: 1.20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          //User Name

                          Container(
                              width: size.width * .3,
                              height: 50,
                              padding: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'New Password',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF636363),
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                                controller: newPassword,
                              )),
                          const SizedBox(
                            height: 3,
                          ),
                          const Text(
                            'Most be  at least 8 character',
                            style: TextStyle(
                              color: Color(0xFF5700BC),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                              width: size.width * .3,
                              height: 50,
                              padding: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Confirm Password',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF636363),
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                                controller: confirmPassword,
                              )),
                          const SizedBox(
                            height: 50,
                          ),
                          GestureDetector(
                            onTap: () {
                              submit();
                            },
                            child: Container(
                              width: size.width * .3,
                              height: 50,
                              decoration: ShapeDecoration(
                                color: const Color(0xFF5700BC),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Center(
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: Color(0xFF636363),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Get.offAllNamed(Login.routeName);
                                  },
                                  child: const Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      color: Color(0xFF5700BC),
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  submit() {
    Map<String, dynamic> request = {
      "email": storedValue,
      "password": newPassword.text,
      "c_password": confirmPassword.text,
    };
    controller.resetpass(request);
    // RegisterScreenController.add(request);
  }
}
