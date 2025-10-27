import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkManager extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (result.first == ConnectivityResult.none) {
      alertDialogue();
    } else {
      Get.back();
      // Get.toNamed("/");
    }
  }

  alertDialogue() {
    Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          iconColor: Colors.red.shade400,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          icon: const Icon(Icons.wifi_off_rounded, size: 50),
          content: SizedBox(
            height: 70,
            width: 350,
            child: Column(
              children: <Widget>[
                Text(
                  "Check Your Connection",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue.shade400,
                  ),
                ),
                const Text("You don't seem to have an internet connection."),
                const Text("Please check your connection and try again."),
              ],
            ),
          ),
        ));
  }
}
