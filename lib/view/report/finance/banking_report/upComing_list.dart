import 'package:abtxt/widgets/flutter_shortcut_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'baking_report_controller.dart';

class UpcomingList extends StatefulWidget {
  const UpcomingList({super.key});

  static const String routeName = '/up_coming_list';

  @override
  State<UpcomingList> createState() => _UpcomingListState();
}

class _UpcomingListState extends State<UpcomingList> {
  BankingReportController controller = Get.put(BankingReportController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankingReportController>(
      builder: (controller) {
        return ShortCutWidget(
          appBar: AppBar(
            title: const Text("Upcoming - Banking Report"),
            actions: const [],
          ),
          loadingStatus: controller.status.isLoading,
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.keyQ, control: true):
                GetBackIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              GetBackIntent: SetCounterAction(perform: () {
                Get.back();
              }),
            },
            child: FocusScope(
              autofocus: true,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        button(() {}, "UPCOMING"),
                        const SizedBox(width: 20),
                        button(() {}, "IN PROGRESS"),
                        const SizedBox(width: 20),
                        button(() {}, "COMPLETED"),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget button(Function() onPress, String text) {
    return OutlinedButton(
      onPressed: onPress,
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(100, 46)),
        shape: WidgetStateProperty.resolveWith(
          (s) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      child: Text(text),
    );
  }
}
