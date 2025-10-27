import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/forgot_password/forget_password_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ForgotPassword extends StatefulWidget {
  static const String routeName = '/forget_password';

  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ForgetPasswordController controller = Get.put(ForgetPasswordController());

  @override
  void initState() {
    super.initState();
    emailController.text ="bharathcse01@gmail.com";
  }

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
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 52),
                    Container(
                      width: size.width / 4,
                      child: TextFormField(
                        controller: emailController,
                        style: TextStyle(fontSize: 14),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(fontSize: 14),
                          hintText: 'Email ID',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        validator: (value) {
                          if (GetUtils.isEmail('$value') == false) {
                            return 'This email address looks incorrect';
                          }
                          return null;
                        },
                      ),
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
    if (_formKey.currentState!.validate()) {
      var request = {
        'email': '${emailController.text}',
      };
      controller.requestOTP(request);
    }
  }
}
