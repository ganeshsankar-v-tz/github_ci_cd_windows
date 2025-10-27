import 'package:abtxt/view/forgot_password/forget_password_controller.dart';
import 'package:abtxt/view/login/set_new_password_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import '../../flutter_core_widget.dart';
import '../mainscreen/mainscreen.dart';
import '../login/login.dart';
import '../login/otp_screen_controller.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});
  static const String routeName = '/otpscreen';

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // 4 text editing controllers that associate with the 4 input fields
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  // final TextEditingController email = TextEditingController();
  var storedValue = '';
  @override
  void initState() {
    super.initState();
  }


  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<ForgetPasswordController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        child: Container(
          color: const Color(0xFFF4EAFF),
          child: Center(
            child: Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.all(16),
                height: size.height,
                width: size.width / 2,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFF5F5F5),
                      spreadRadius: 1,
                      blurRadius: 1,
                    )
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 42),
                    Image.asset('assets/images/forget_password.png'),
                    const SizedBox(height: 12),
                    const Text(
                      'Check your Email',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text('One Time Password (OTP) has been\nsent to your abtextile@gmail.com.', style: TextStyle(color: Colors.black12),),
                    const SizedBox(height: 52),
                    Container(
                      width: size.width / 4,
                      child: Text('HELLO'),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: size.width / 4,
                      height: 43,
                      decoration: ShapeDecoration(
                        color: Color(0xFF5700BC),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      child: ElevatedButton(
                        onPressed: () => submit(),
                        child: Text('Send OTP'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(38),
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          textStyle: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Color(0xFF5700BC),
                        ),
                      ),
                    )
                  ],
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
      "otp":
          '${_fieldOne.text}${_fieldTwo.text}${_fieldThree.text}${_fieldFour.text}',
    };
    var requestPayload = DioFormData.FormData.fromMap(request);
    //controller.otpScreen(requestPayload);
  }

  resend() {
    Map<String, dynamic> request = {
      "email": storedValue,
    };
    //controller.resendAgain(request);
  }
}
