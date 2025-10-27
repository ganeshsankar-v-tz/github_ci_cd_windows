import 'package:abtxt/network/network_manager.dart';
import 'package:get/get.dart';

class NetworkBinding {
  static void init() {
    Get.put<NetworkManager>(NetworkManager(), permanent: true);
  }
}
