import 'package:abtxt/view/login/register_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../widgets/MyElevatedButton.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String routeName = '/register';
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController idController = TextEditingController();
  final userName = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassword = TextEditingController();
  var obscurePassword = true.obs;
  var obscureConformPassword = true.obs;

  final _formKey = GlobalKey<FormState>();
  late RegisterScreenController controller;

  late AnimationController _animationcontroller;

  @override
  void initState() {
    _animationcontroller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<RegisterScreenController>(builder: (controller) {
      this.controller = controller;

      return Scaffold(
        body: Row(children: [
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: Container(
              height: size.height,
              width: size.width * .45,
              color: const Color(0xffF9F3FF),
              child: Center(
                child: SizedBox(
                  width: 400,
                  child: Lottie.asset(
                    "assets/lottie/register page animation.json",
                    fit: BoxFit.fill,
                    controller: _animationcontroller,
                    repeat: false,
                    onLoaded: (composition) {
                      _animationcontroller
                        ..duration = composition.duration
                        ..forward();
                    },
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: size.width * .3,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 200,
                        height: 200,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('User name'),
                        ),
                        keyboardType: TextInputType.name,
                        controller: userName,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Email ID'),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => TextField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscurePassword.value,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              label: Text('Password'),
                              suffixIcon: IconButton(
                                icon: Icon(obscurePassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  obscurePassword.value =
                                      !obscurePassword.value;
                                },
                              )),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => TextField(
                          controller: confirmPassword,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureConformPassword.value,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Confirm Password'),
                              suffixIcon: IconButton(
                                icon: Icon(obscureConformPassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  obscureConformPassword.value =
                                      !obscureConformPassword.value;
                                },
                              )),
                        ),
                      ),
                      SizedBox(height: 24),
                      MyElevatedButton(
                        onPressed: () => submit(),
                        child: const Text('REGISTER'),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
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
                            onPressed: () => Get.back(),
                            child: const Text(
                              'LOGIN',
                              style: TextStyle(
                                color: Color(0xFF5700BC),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      );
    });
  }

  submit() {
    Map<String, dynamic> request = {
      "name": userName.text,
      "email": emailController.text,
      "password": passwordController.text,
      "c_password": confirmPassword.text,
    };
    controller.register(request);
  }
}
