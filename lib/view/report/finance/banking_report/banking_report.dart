import 'package:abtxt/view/report/finance/banking_report/admin_conformation/admin_conformation.dart';
import 'package:abtxt/view/report/finance/banking_report/baking_report_controller.dart';
import 'package:abtxt/view/report/finance/banking_report/conformation/conformation.dart';
import 'package:abtxt/view/report/finance/banking_report/po_details/po_list.dart';
import 'package:abtxt/view/report/finance/banking_report/up_coming_details/upComing_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../flutter_core_widget.dart';
import 'completed_details/completed_list.dart';
import 'in+progress_details/inProcess_list.dart';

class BankingReport extends StatefulWidget {
  const BankingReport({super.key});

  @override
  State<BankingReport> createState() => _State();
}

class _State extends State<BankingReport> {
  BankingReportController controller = Get.put(BankingReportController());
  late GetStorage box;

  @override
  void initState() {
    super.initState();
    box = GetStorage();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankingReportController>(builder: (controller) {
      return AlertDialog(
        title: const Center(
            child: Text(
          'BANKING REPORT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        )),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: SizedBox(
          width: 400,
          // height: 480,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                OutlinedButton(
                  onPressed: () {
                    Get.toNamed(UpcomingList.routeName);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                      (states) {
                        return const Color(0xffF4F2FF);
                      },
                    ),
                    minimumSize: WidgetStateProperty.all(const Size(400, 70)),
                    shape: WidgetStateProperty.resolveWith(
                      (states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    side: WidgetStateProperty.all(
                      const BorderSide(
                        color: Color(0xff5700BC),
                        width: .5,
                      ),
                    ),
                  ),
                  child: const Text(
                    "UPCOMING",
                    style: TextStyle(
                      color: Color(0xff5700BC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                OutlinedButton(
                  onPressed: () {
                    Get.toNamed(ConformationList.routeName);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                      (states) {
                        return const Color(0xffF4F2FF);
                      },
                    ),
                    minimumSize: WidgetStateProperty.all(const Size(400, 70)),
                    shape: WidgetStateProperty.resolveWith(
                      (states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    side: WidgetStateProperty.all(
                      const BorderSide(
                        color: Color(0xff5700BC),
                        width: .5,
                      ),
                    ),
                  ),
                  child: const Text(
                    "CONFORMATION",
                    style: TextStyle(
                      color: Color(0xff5700BC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                OutlinedButton(
                  onPressed: () {
                    Get.toNamed(PoList.routeName);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                          (states) {
                        return const Color(0xffF4F2FF);
                      },
                    ),
                    minimumSize: WidgetStateProperty.all(const Size(400, 70)),
                    shape: WidgetStateProperty.resolveWith(
                          (states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    side: WidgetStateProperty.all(
                      const BorderSide(
                        color: Color(0xff5700BC),
                        width: .5,
                      ),
                    ),
                  ),
                  child: const Text(
                    "PO",
                    style: TextStyle(
                      color: Color(0xff5700BC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Visibility(
                  visible: box.read("user_type") == "A",
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      OutlinedButton(
                        onPressed: () {
                          Get.toNamed(AdminConformationList.routeName);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color?>(
                            (states) {
                              return const Color(0xffF4F2FF);
                            },
                          ),
                          minimumSize:
                              WidgetStateProperty.all(const Size(400, 70)),
                          shape: WidgetStateProperty.resolveWith(
                            (states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          side: WidgetStateProperty.all(
                            const BorderSide(
                              color: Color(0xff5700BC),
                              width: .5,
                            ),
                          ),
                        ),
                        child: const Text(
                          "ADMIN CONFORMATION",
                          style: TextStyle(
                            color: Color(0xff5700BC),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                OutlinedButton(
                  onPressed: () {
                    Get.toNamed(InProcessList.routeName);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                      (states) {
                        return const Color(0xffF4F2FF);
                      },
                    ),
                    minimumSize: WidgetStateProperty.all(const Size(400, 70)),
                    shape: WidgetStateProperty.resolveWith(
                      (states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    side: WidgetStateProperty.all(
                      const BorderSide(
                        color: Color(0xff5700BC),
                        width: .5,
                      ),
                    ),
                  ),
                  child: const Text(
                    "IN PROGRESS",
                    style: TextStyle(
                      color: Color(0xff5700BC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                OutlinedButton(
                  onPressed: () {
                    Get.toNamed(CompletedList.routeName);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                      (states) {
                        return const Color(0xffF4F2FF);
                      },
                    ),
                    minimumSize: WidgetStateProperty.all(const Size(400, 70)),
                    shape: WidgetStateProperty.resolveWith(
                      (states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    side: WidgetStateProperty.all(
                      const BorderSide(
                        color: Color(0xff5700BC),
                        width: .5,
                      ),
                    ),
                  ),
                  child: const Text(
                    "COMPLETED",
                    style: TextStyle(
                      color: Color(0xff5700BC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'CLOSE',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    });
  }
}
