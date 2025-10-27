import 'package:abtxt/flutter_core_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../utils/DeviceInfo.dart';
import '../../widgets/MyElevatedButton.dart';
import 'login_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  static const String routeName = '/login';

  @override
  State<Login> createState() => _State();
}

class _State extends State<Login> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;

  LoginController controller = Get.put(LoginController());
  late AnimationController _animationController;
  var obscurePassword = true.obs;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) {
        controller = controller;
        return CoreWidget(
          autofocus: false,
          loadingStatus: controller.status.isLoading,
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  flex: 1,
                  child: Container(
                    height: Get.height,
                    width: Get.width,
                    decoration: const BoxDecoration(
                      color: Color(0xffF9F3FF),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            width: 400,
                            child: Lottie.asset(
                              "assets/lottie/login animation.json",
                              fit: BoxFit.fill,
                              controller: _animationController,
                              repeat: false,
                              onLoaded: (composition) {
                                _animationController
                                  ..duration = composition.duration
                                  ..forward();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: Center(
                    child: Container(
                      width: 400,
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 200,
                              height: 200,
                            ),
                            const SizedBox(height: 48),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              autofocus: true,
                              onSaved: (value) => email = value ?? "",
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("User Name"),
                              ),
                              validator: (value) {
                                if (GetUtils.isNullOrBlank('$value') == true) {
                                  return 'This looks incorrect';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            Obx(
                              () => TextFormField(
                                textInputAction: TextInputAction.next,
                                onSaved: (value) => password = value ?? "",
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: obscurePassword.value,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    label: const Text("Password"),
                                    suffixIcon: IconButton(
                                      focusNode: FocusNode(skipTraversal: true),
                                      icon: Icon(obscurePassword.value
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      color: Colors.black54,
                                      onPressed: () {
                                        obscurePassword.value =
                                            !obscurePassword.value;
                                      },
                                    )),
                                validator: (value) {
                                  if (GetUtils.isNullOrBlank('$value') ==
                                      true) {
                                    return 'This looks incorrect';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {
                                  login();
                                },
                              ),
                            ),
                            /*     SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Opacity(
                                opacity: 0.5,
                                child: TextButton(
                                  onPressed: null,
                                  child: Text('Forgot Password?',
                                      style:
                                          TextStyle(color: Color(0xFF5700BC))),
                                ),
                              ),
                            ),*/
                            const SizedBox(height: 24),
                            MyElevatedButton(
                              width: double.infinity,
                              onPressed: () {
                                login();
                              },
                              child: const Text('LOGIN'),
                            ),
                            /*         SizedBox(
                              height: 40,
                            ),
                            Opacity(
                              opacity: 0.5,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'Don’t have an account? ',
                                    style: TextStyle(
                                      color: Color(0xFF636363),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: null,
                                    child: Text(
                                      'REGISTER',
                                      style: TextStyle(
                                        color: Color(0xFF5700BC),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )*/
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      var deviceId = await DeviceInfo().getDeviceInfo();
      _formKey.currentState!.save();
      var request = {
        'user_name': '$email',
        'password': '$password',
        "device_id": deviceId.replaceAll("{", "").replaceAll("}", ""),
      };
      controller.login(request);
    }
  }
}
