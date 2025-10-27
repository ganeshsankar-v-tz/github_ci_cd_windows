import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'login.dart';

class ResetSuccessfullyScreen extends StatefulWidget {
  const ResetSuccessfullyScreen({super.key});

  static const String routeName = '/resetsuccessfullyscreen';
  @override
  State<ResetSuccessfullyScreen> createState() =>
      _ResetSuccessfullyScreenState();
}

class _ResetSuccessfullyScreenState extends State<ResetSuccessfullyScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Color(0xFFF4EAFF),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 50, bottom: 50),
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
                                'assets/images/Reset_successfully.png',
                                height: 50,
                                width: 50,
                              ),
                            ],
                          ),
                        ),

                        Container(
                          height: 50,
                          width: size.width * .3,
                          child: const Center(
                            child: Text(
                              'Reset Successfully!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //User Name
                        const Center(
                          child: Text(
                            'Your password has been successfully \n reset',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF858585),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 1.20,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.offAllNamed(Login.routeName);
                          },
                          child: Container(
                            width: size.width * .3,
                            height: 50,
                            decoration: ShapeDecoration(
                              color: Color(0xFF5700BC),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Center(
                              child: Text(
                                'Continue',
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
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => Login()));
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
  }

  LoginScreen() {}
}
