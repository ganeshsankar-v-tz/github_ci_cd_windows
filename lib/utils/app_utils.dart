import 'package:abtxt/model/FirmModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../model/LedgerModel.dart';

class AppUtils {
  final String appVersion = "1.0.89";

  final String loginName = GetStorage().read('name') ?? '';

  static DateFormat dateFormatter = DateFormat('yyyy-MM-dd hh:mm:ss a');

  final rupeeFormat = NumberFormat.currency(locale: 'en_IN', symbol: "");

  static TextStyle? weavingWarpDetails() {
    return const TextStyle(
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w500,
        fontSize: 13,
        color: Colors.black);
  }

  static TextStyle? updateAndCreateTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 13,
      overflow: TextOverflow.ellipsis,
    );
  }

//shortcut message text size
  static TextStyle? shortCutTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: Colors.red,
    );
  }

// SFDatagrid table cell text size:
  static TextStyle? cellTextStyle() {
    return const TextStyle(
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Colors.black);
  }

// SFDatagrid table footer text size:
  static TextStyle? footerTextStyle() {
    return const TextStyle(
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.black);
  }

  // payment module text style
  static TextStyle paymentTextStyle({Color? color}) {
    return TextStyle(
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      fontSize: 15,
      color: color,
    );
  }

  static showSuccessToast({required String message, int seconds = 500}) {
    /*Get.snackbar('Alert', message, maxWidth: 250, duration: const Duration(seconds: 2));*/
    Get.showSnackbar(
      GetSnackBar(
        maxWidth: 350,
        title: 'Alert',
        messageText: Text(
          message,
          overflow: TextOverflow.ellipsis,
          maxLines: 10,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: seconds),
      ),
    );
    //ios,android and web alert code:
    // return Fluttertoast.showToast(
    //     msg: message,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.green,
    //     textColor: Colors.white,
    //     fontSize: 14.0);
  }

  /// weaving last inward day's count showing purpose
  static weavingToast({required String message}) {
    Get.showSnackbar(
      GetSnackBar(
        maxWidth: 350,
        messageText: Text(
          message,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static infoAlert({required String message}) {
    Get.defaultDialog(
      title: '',
      titleStyle: const TextStyle(fontSize: 0),
      radius: 8,
      content: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'ALERT!\n',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(
              text: '\n',
              style: TextStyle(
                fontSize: 4.0,
                fontStyle: FontStyle.normal,
              ),
            ),
            TextSpan(
              text: message,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      /*content: Text(
        message,
        overflow: TextOverflow.ellipsis,
      ),*/
      actions: [
        Container(
          padding: const EdgeInsets.only(right: 8, bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => Get.back(),
                autofocus: true,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red), // Border color
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static showErrorToast({required String message}) {
    /*Get.snackbar(
      'Error',
      '$message',snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );*/
    Get.showSnackbar(
      GetSnackBar(
        title: 'Error',
        messageText: Text(
          message,
          overflow: TextOverflow.ellipsis,
          maxLines: 10,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
    /*return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black,
        gravity: ToastGravity.BOTTOM,);*/
  }

/*static List<dynamic>? listOfMultiPart(List<File> file) {
    final List<dynamic> multiPartValues = [];
    for (File element in file) {
      multiPartValues.add(MultipartFile.fromFile(
        element.path,
        // filename: element.path.split('/').last,
      ));
    }
    return multiPartValues;
  }*/

  static findLedgerAccountByName(List<LedgerModel> list, String name) {
    var result = list.where((e) => e.ledgerName == name);
    return result.isNotEmpty ? result.first : null;
  }

  static setDefaultFirmName(List<FirmModel> list) {
    var result = list.where((e) => e.firmName == "A B TEX PRIVATE LIMITED");
    return result.isNotEmpty ? result.first : null;
  }

  static parseDateTime(String dateString) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    try {
      DateTime formattedDate = formatter.parse(dateString);
      final String formatted = formatter.format(formattedDate);
      return formatted;
    } catch (e) {
      print('Invalid date format: $e');
      return '';
    }
  }

  static fractionDigitsText(controller, {int fractionDigits = 3}) {
    double number = double.tryParse(controller.text) ?? 0;
    String formattedValue = number.toStringAsFixed(fractionDigits);
    controller.text = formattedValue;
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );
  }

  static Future<bool?> showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          title: RichText(
            textAlign: TextAlign.start,
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'ALERT!\n',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '\n',
                  style: TextStyle(
                    fontSize: 4.0,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                TextSpan(
                  text: 'Do you want to save?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.back();
                // Navigator.of(context).pop(false); // Return false when "No" is pressed
              },
              child: const Text("No"),
            ),
            TextButton(
              autofocus: true,
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Return true when "Yes" is pressed
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}

extension MyNumberFormater on Object {
  String myNumberFormat(String value, {int decimalPlace = 2}) {
    final formatter = NumberFormat.currency(
        locale: 'en_IN', decimalDigits: decimalPlace, name: "");

    String formated = formatter.format(double.tryParse(value) ?? 0);

    return formated;
  }
}

extension AsExtension on Object? {
  String tryCast(dynamic value) {
    if (value is String) {
      return value;
    } else if (value is num) {
      return "$value";
    } else if (value == null) {
      return '';
    } else {
      return '';
    }

    /*try {
      return (value as T);
    } on TypeError catch (_) {
      return '$value';
    }*/
  }
}

extension MyValidator on String {
  bool isValidAadharNumber() {
    return RegExp(r'^[2-9]{1}[0-9]{3}\\s[0-9]{4}\\s[0-9]{4}$').hasMatch(this);
  }

  bool isValidGST() {
    return RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$')
        .hasMatch(this);
  }

  bool isValidPanCardNo() {
    return RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(this);
  }

  bool isValidIFSC() {
    return RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(this);
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}
